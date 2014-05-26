#lang at-exp racket/base

(require racket/list
         racket/local
         racket/match
         racket/pretty
         racket/contract
         scribble/srcdoc
         "commons.rkt"
         (for-doc racket/base
                  scribble/manual))

#|
(require scribble/srcdoc
         "commons.rkt"
         "../../input-progs/input-progs-forseq.rkt"
         "alpha-conversion.rkt"
         (for-doc racket/base
                  racket/contract
                  scribble/manual))
|#

#|
M, N = v
     | (let (x h) M)
     | (let (x (car v) M)
     | (let (x (cdr v) M)
     | (let (x (if v M M)) M)
     | (let (x (apply v v) M)
     | (let (x M) M),

v is a simple value (variable | location)
x is variable.
h is a heap value (λx.M | (cons v v) | c: constant / boolean.
|#

#|
M, N = n
     | (let h M)
     | (let (car n) M)
     | (let (cdr n) M)
     | (let (if n M M) M)
     | (let (apply n n) M)
     | (let M M),
n is a deBruijn index, rep'd by box
h is either (lambda M) | (cons n n) | 'c, constant-list of single number<-doesn't start `let' or `lambda', ''5 (list 5)
|#

#| example
   (let (x 5) (let (x 3) (let (y 6) (cons x y))))
=> (let 5 (let 3 (let 6 (cons (new-box 1) (new-box 0)))))

   (let (x (let (y 1) (cons y y))) (car x))
=> (let (let 1 (cons (new-box 0) (new-box 0))) (car (new-box 0)))
|#


(provide/doc
 (proc-doc/names hash-table-update
                    (->* ((and/c hash? immutable?) (any/c . -> . any/c)) () (and/c hash? immutable?))
                    ((ht updater) ())
                    @{Outputs new hash table with all values are updated by @racket[updater].}))
;; hash-immutable, updator -> new hash-table
(define (hash-table-update ht updater)
  (let loop ([h ht]
             [keys (hash-keys ht)])
    (cond
      [(empty? keys) h]
      [else (loop (hash-update h (first keys) updater) (rest keys))])))

(provide/doc
 (proc-doc/names add1-hash
                    (->* ((and/c hash? immutable?) any/c) () (and/c hash? immutable?))
                    ((ht x) ())
                    @{Outputs new hash whose value for @racket[x] is zero if the value associated @racket[x] is boolean or one increased.}))
;; hash-immutable key -> new hash
(define (add1-hash ht x)
  (let* ([n (hash-ref ht x)])
    (if (boolean? n)
        (zero-hash ht x)
        (hash-set ht x (new-box (add1 n))))))

(provide/doc
 (proc-doc/names zero-hash
                    (->* ((and/c hash? immutable?) any/c) () (and/c hash? immutable?))
                    ((ht x) ())
                    @{Outputs new hash whose value for @racket[x] is zero.}))
;; hash-immutable key -> new hash
(define (zero-hash ht x)
  (hash-set ht x (new-box 0)))

(provide/doc
 (proc-doc/names new-lambda
                    (->* ((and/c hash? immutable?) any/c) () (and/c hash? immutable?))
                    ((ht x) ())
                    @{Outputs new hash XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}))
;; hash-immutable var -> new hash table.
;; increase other vars, but x, set x's be zero
(define (new-lambda ht x)
  (hash-set (hash-table-update ht box-add1) x (new-box 0)))

(provide/doc
 (proc-doc/names symbol->deBruijn-index
                    (->* ((and/c hash? immutable?) any/c) () (and/c hash? immutable?))
                    ((ht x) ())
                    @{Outputs the value associated to key @racket[x] if it is one of keys from hash @racket[ht]. Output @racket[(new-box 'Unknown)] otherwise. Output @racket[x] if @racket[x] is not a symbol.}))
;; hash-immutable key -> value :   box of number
(define (symbol->deBruijn-index ht x)
  (cond
    [(symbol? x)
     (let ([lk (hash-keys ht)])
       (cond
         [(empty? lk) (error "index pool is empty")]
         [(member x lk) (hash-ref ht x)]
         [else (new-box 'Unknown)]))]
    [else x]))

(provide/doc
 (thing-doc symbol->distance
            (-> any/c (->* (hash? symbol?) () (or/c #:void box?)))
            @{@racket[symbol->distance] is an alias of a procedure currently used as a transformer of 
               input file to transformed program with unique variable names. Currrently,
               distance from initial variable is use for the uniquness property.
               }))
(define symbol->distance symbol->deBruijn-index)


(provide/doc
 (proc-doc/names convert-to-deBruijn
                    (->* (symbol?) () symbol?)
                    ((prog) ())
                    @{Outputs a new program with deBruijn index form from a symbol of input program.}))
;; prog is a program with all distinct variables.
(define (convert-to-deBruijn prog)
  (local [(define (parse-term src local-ht out-src)
            (printf "Term: ~a\n" src)
            (match src
              [(? symbol? x) (values local-ht (symbol->deBruijn-index local-ht x))]
              [`(let (,x ,exp) ,body)
               (let* ([exp-result (parse-exp exp local-ht out-src)]
                      [new-local-ht (new-lambda local-ht x)])
                 (printf "NEW local lambda: ~a\n" new-local-ht)
                 
                 (let*-values ([(new-ht new-out-src) (parse-term body new-local-ht out-src)])
                   (values new-ht (list 'let exp-result new-out-src))))]))
          
          (define (parse-exp expr local-ht out-src)
            (printf "Exp: ~a\n" expr)
            (match expr
              [`(lambda (,y) ,N)
               (let*-values ([(new-local-ht) (new-lambda local-ht y)]
                             [(new-ht parse-result) (parse-term N new-local-ht out-src)])
                 (list 'lambda parse-result))]
              [`(cons ,y1 ,y2)  (list 'cons (symbol->deBruijn-index local-ht y1) (symbol->deBruijn-index local-ht y2))]
              [(? number? c) c]
              [(? boolean? c) c]
              [`(car ,y) (list 'car (symbol->deBruijn-index local-ht y))]
              [`(cdr ,y) (list 'cdr (symbol->deBruijn-index local-ht y))]
              [`(if ,y ,M ,N) 
               (let*-values ([(ht-M src-M) (parse-term M local-ht out-src)]
                             [(ht-N src-N) (parse-term N local-ht out-src)])
                 (list 'if (symbol->deBruijn-index local-ht y) src-M src-N))]
              [`(apply ,y ,z) (list 'apply (symbol->deBruijn-index local-ht y) (symbol->deBruijn-index local-ht z))]
              ;; expr = M 
              [_ (let-values ([(new-ht parse-result) (parse-term expr local-ht out-src)])
                   parse-result)]))]

    (let-values ([(ht parse-result) (parse-term prog (make-immutable-hash '()) '())])
      (pretty-display ht)
      parse-result)))


(provide/doc
 (proc-doc/names convert-to-distance-form
                    (->* (symbol?) () symbol?)
                    ((prog) ())
                    @{Outputs a new program with index defined by the distance to let-bindings from a symbol of input program.}))
;; only `if' expression shows difference in `FALSE' expression in it.
(define (convert-to-distance-form prog)
  (local [(define (parse-term src local-ht out-src)
            #;(printf "Term: ~a\n" src)
            (match src
              [(? symbol? x) (values local-ht (symbol->distance local-ht x))]
              [`(let (,x ,exp) ,body)
               (let*-values
                   ([(new-ht exp-result) (parse-exp exp local-ht out-src)]
                    [(new-local-ht) (new-lambda new-ht x)]
                    [(new-ht new-out-src) (parse-term body new-local-ht out-src)])
                   #;(printf "NEW local lambda: ~a\n" new-local-ht)
                 
                   (values new-ht (list 'let exp-result new-out-src)))]))
          
          (define (parse-exp expr local-ht out-src)
            #;(printf "Exp: ~a\n" expr)
            (match expr
              [`(lambda (,y) ,N)
               (let*-values ([(new-local-ht) (new-lambda local-ht y)]
                             [(new-ht parse-result) (parse-term N new-local-ht out-src)])
                 (values new-ht (list 'lambda parse-result)))]
              [`(cons ,y1 ,y2)  (values local-ht (list 'cons (symbol->distance local-ht y1) (symbol->distance local-ht y2)))]
              [(? number? c) (values local-ht c)]
              [(? boolean? c) (values local-ht c)]
              [`(car ,y) (values local-ht (list 'car (symbol->distance local-ht y)))]
              [`(cdr ,y) (values local-ht (list 'cdr (symbol->distance local-ht y)))]
              [`(if ,y ,M ,N) 
               (let*-values ([(ht-M src-M) (parse-term M local-ht out-src)]
                             
                             ;; this line only differs from convert-to-deBruijn-distance-only-to-binder-introduction
                             [(ht-N src-N) (parse-term N ht-M out-src)])
                 (values ht-N (list 'if (symbol->distance local-ht y) src-M src-N)))]
              [`(apply ,y ,z) (values local-ht (list 'apply (symbol->distance local-ht y) (symbol->distance local-ht z)))]
              ;; expr = M 
              [_ (let-values ([(new-ht parse-result) (parse-term expr local-ht out-src)])
                   (values new-ht parse-result))]))]

    (let-values ([(ht parse-result) (parse-term prog (make-immutable-hash '()) '())])
      (pretty-display ht)
      parse-result)))



#;(define convert-to-simple-rep convert-to-deBruijn)
(define convert-to-simple-rep convert-to-distance-form)


#;(let*-values
    (;; used for (gensym) which is not duplicates from. need update for new (gensym)
     [(lol-vars prog1) (convert-no-dupvar prog)]
     [(v) (printf "\nVariable-conversion:~a\n" lol-vars)]
     [(lst-var) (prog->list-of-binders prog1)]
     [(prog2) (convert-to-simple-rep prog1)])
  
  (printf "\nList of variables in order:\n")
  (pretty-print lst-var)
  (newline)
  
  (printf "\nResult of alpha conversion:\n")
  (pretty-display prog1)
  (newline)
  
  (printf "\nResult of simple-rep conversion for variables:\n")
  (pretty-display prog2))

