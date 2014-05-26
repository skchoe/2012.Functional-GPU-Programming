#lang racket

(require "../../input-progs/input-progs-forseq.rkt"
         "../../seq-code/SBA-utils.rkt"
         "commons.rkt"
         "alpha-conversion.rkt"
         "SBA-gen-constraints.rkt"
         "encoding-constraints.rkt")


;; ht: hashtable (<var> <order>) : (<symbol> <number>), order starts 0.
;; output: list of vars (v0 v1 ...)
(define (hash->list-vars ht)
  (let* ([len (hash-count ht)]
         [ks (hash-keys ht)]
         [vs (hash-values ht)])
    (local (;; elt : position, lst: src-list that new symbol added to.
            ;; ks : list of symbol
            ;; vs : list of positions
            (define (add2list ks vs elt lst)
              (let* ([pos (elt->pos vs elt 0)])
                (printf "ks:~a, vs:~a, elt:~a, lst:~a--->pos:~a\n" ks vs elt lst pos)
                (if (not pos) ;; 
                    (error "__elt->pos returned false")
                    (append lst (list (list-ref ks pos))))))
            
            ;; output: (or? number #f)
            (define (elt->pos lst elt th)
              (printf "elt->pos lst:~a, elt:~a, th:~a\n" lst elt th)
              (cond 
                [(empty? lst) #f] ;; not exist
                [else (if (equal? (first lst) elt) 
                          th 
                          (elt->pos (rest lst) elt (add1 th)))])))
      (let loop ([i 0]
                 [lst '()])
        (cond [(equal? i len) lst]
              [else (loop (add1 i) (add2list ks vs i lst))])))))
      


(define (gen-constraint-nameless ht bd-var expr)
  (let ([pos (hash-ref ht bd-var)])
    (printf "var:~a, pos:~a in ht:~a, expr:~a\n" bd-var pos ht expr)
    (match expr
      ;; expr = h : (λx M)
      [`(lambda (,y) ,N)
       (let* ([finalvar-N (gen-constraints-nameless ht N)])
         (printf "(gen-constraint) - lambda :(~a) ~a, encoded: ~a\n" y N (encode-constraint `(lambda ,y ,N ,finalvar-N)))
         (gen-constraints-nameless ht N)
         (printf "(gen-constraint) - lambda gen-constraints done\n"))]
       
       ;; expr = h : (cons v v) , v: simple value (var or loc)
       [`(cons ,y1 ,y2) (printf "cons case ~a ~a, encoded:~a\n" y1 y2 (encode-constraint `(cons ,y1 ,y2)))]
       
       ;; expr = h : c - const
       [(? integer? c)
        (printf "integer c:~a, encoded:~a\n" c (encode-constraint c))]
       
       ;; expr = (car v)
       [`(car ,y) 
        (printf "car, y:~a, encoded:~a\n" y
                (encode-constraint `(propagate-car-to ,bd-var)))]
       
       ;; expr = (cdr v)
       [`(cdr ,y) 
        (printf "cdr, y:~a, encoded:~a\n" y (encode-constraint `(propagate-cdr-to ,bd-var)))]
       
       ;; expr = (apply v v)
       [`(apply ,y ,z)
        (printf "apply, y:~a, z:~a. encoded:~a\n" y z
                (encode-constraint `(application ,bd-var ,z)))]
       
       ;; expr = if is not considered.
       ;; expr = M 
       [_ 
        (printf "else case of match: exp-~a\n" expr)
        (let ([finalvar-exp (gen-constraints-nameless ht expr)])
          (printf "finalvar:~a, encoded:~a\n" finalvar-exp
           (encode-constraint `(propagate-to ,bd-var))))])))

(define (gen-constraints-nameless ht prog)
  (match prog
    [(? symbol? x) #t]
    [`(let (,x ,exp) ,body)
     (gen-constraint-nameless ht x exp)
     (gen-constraints-nameless ht body)]))


;; testing for getting variable list from given term (application or variable form)
(let*-values ([(rename-lst prog2) (convert-no-dupvar prog)])
  (printf "\norigianl prog:\n")
  (pretty-display prog)
  (printf "\nalpha-converted:\n")
  (pretty-display prog2)
  
  (let*-values ([(lol) (global-binders-lol prog)]
                [(new-var new-lol) (create-nondup-var-lol lol)])
    (printf "\nbinders in list:~a, ~a\n" lol new-var))
  (printf "\nRename-status:~a\n" rename-lst))
  
