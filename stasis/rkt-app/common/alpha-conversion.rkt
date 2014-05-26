#lang at-exp racket
(require racket/pretty
         scribble/srcdoc
         "commons.rkt"
         "../../input-progs/input-progs-forseq.rkt"
         (for-doc racket/base
                  racket/contract
                  scribble/manual))

;;(provide (all-defined-out))

(provide/doc
 (proc-doc/names convert-no-dupvar
                  (->* (symbol?) () (values list? symbol?))
                  ((prog) ())
                  @{For given input symbol made of long string, this produces a symbol representing a program without dup let-bindings.}))
;; term : symbol made out of long string -> term without dup let-bindings.
(define (convert-no-dupvar prog)
    (let*-values 
        ([(ht-binders) (global-binders-hash prog)]
         [(lov-binders) (global-binders-lov prog)]
         [(drk pos) (convert-term (make-dup-remove-kit ht-binders lov-binders prog) (make-immutable-hash '()) 0)])
      #;(printf "global-binder-ht:~a, size:~a\n" ht-binders (length (hash-keys ht-binders)))
      #;(printf "global-binder-lov:~a, size:~a\n" lov-binders (length lov-binders))
      (values (dup-remove-kit-vars-lov drk) (dup-remove-kit-prog drk))))

(provide/doc 
 (proc-doc/names dup-remove-kit?
                 (-> dup-remove-kit? symbol?)
                 (drk)
                 @{Returns the state of @racket[drk].}))
;; dic-vars: hashtable containing rename info: keep key unique by (hash-set!)
;; vars-lov: list of pair containing all vars from let/lambda binding at its (first)
(define-struct dup-remove-kit (dic-vars vars-lov prog)) ;; will be defined as `drk';; output: ht-rename l-vars new-term

(provide/doc
 (proc-doc/names echo-dup-remove-kit
                 (->* (dup-remove-kit?) () void?)
                 ((drk) ())
                 @{tests your dup-remove-kit struct by echoing its fields @racket[dic-vars], @racket[prog], and each element of list of variable @racket[vars-lov].}))
(define (echo-dup-remove-kit drk)
  (printf "DRK-dic-vars:~a\nDRK-vars-lov:\n~a\nDRK-prog:~a\n"
          (dup-remove-kit-dic-vars drk)
          (map var-rename->string (dup-remove-kit-vars-lov drk))
          (dup-remove-kit-prog drk)))

;; key exists & value is #f
;; global-scope property
(provide/doc
 (proc-doc/names once-introduced?
                 (->* (hash? any/c) () boolean?)
                 ((ht v) ())
                 @{produces @racket[true] if key exists and the value is not @racket[false]}))
(define (once-introduced? ht v)
  (and (hash-has-key? ht v)
       (not (boolean=? #f (hash-ref ht v)))))

;; key exists & value is a symbol (not boolean)
;; local-scope property
(provide/doc
 (proc-doc/names conv-exists?
                 (->* (hash? any/c) () boolean?)
                 ((ht v) ())
                 @{proces @racket[true] if key exists and the value is a symbol}))
(define (conv-exists? ht v)
  (and (hash-has-key? ht v)
       (not (boolean? (hash-ref ht v)))))

;; check if occur new?
(provide/doc
 (proc-doc/names introduced-or-converted?
                 (->* (hash? hash? any/c) () boolean?)
                 ((ght ht v) ())
                 @{produces @racket[true] if @racket[v] is either introduced once in @racket[ght] or converted variable exists in @racket[ht].}))
(define (introduced-or-converted? ght ht v)
  (or (once-introduced? ght v)
      (conv-exists? ht v)))

;; l-vars is list of pair (original-var order renamed-var ...)
(provide/doc
 (proc-doc/names insert-new-var-at-old-var
                 (->* (list? symbol? number?) () list?) 
                 ((l-vars var pos) ())
                 @{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}))
(define (insert-new-var-at-old-var l-vars var pos)
  (let ([pr (list-ref l-vars pos)]);; pr is <var-rename>
    ;(printf "oldvar:~a, num:~a, new-var:~a, pos:~a\n" (first pr) (second pr) var pos)
    (if (equal? pos (var-rename-pos pr))
        (update-list-element l-vars (new-var var pr) pos)
        (error "insert-new-var-at-old-var error"))))

;; drk : dup-remove-kit, ht-rename: immutable-hash (var -> new-var), pos : index in env.
(provide/doc
 (proc-doc/names convert-term
                 (->* (dup-remove-kit? hash? number?) () (values dup-remove-kit? number?))
                 ((drk ht-rename pos) ())
                 @{YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY}))
(define (convert-term drk ht-rename pos)
  (let* ([dic-vars (dup-remove-kit-dic-vars drk)]
         [l-vars   (dup-remove-kit-vars-lov drk)]
         [term     (dup-remove-kit-prog drk)])
    (match term
      [(? symbol? x)
       (cond [(conv-exists? ht-rename x) 
              (values (make-dup-remove-kit dic-vars l-vars (hash-ref ht-rename x)) 
                      pos)]
             [else (values (make-dup-remove-kit dic-vars l-vars x)
                           pos)])]
      [`(let (,x ,exp) ,body)
       (let*-values 
           ([(exp-drk new-pos) (convert-exp (make-dup-remove-kit dic-vars l-vars exp) ht-rename pos)]
            [(exp-dic-vars) (dup-remove-kit-dic-vars exp-drk)]
            [(next-pos) (add1 new-pos)]) 
         (cond 
           [(introduced-or-converted? exp-dic-vars ht-rename x) ;; occur once or conversion exists
            (let*-values 
                (;; 1. over-write global hash: dic-vars as #t to show this item is used
                 ;; 2. create new var, add it to dic-vars=>new-dic-vars, l-vars=>new-l-vars
                 [(new-x new-dic-vars) (create-nondup-var-hash (hash-set exp-dic-vars x #t))]
                 
                 ;; pos need increased because of the occurence of `x.
                 [(new-l-vars) (insert-new-var-at-old-var l-vars new-x new-pos)]
                 
                 
                 ;; over-write current renaming if any, then add new-x w/ #t - visited.
                 [(new-ht-rename) (hash-set ht-rename x new-x)])
              
              (let*-values ([(term-drk pos2) (convert-term (make-dup-remove-kit new-dic-vars new-l-vars body)
                                                           new-ht-rename
                                                           next-pos)])
                
                (values (make-dup-remove-kit (dup-remove-kit-dic-vars term-drk)
                                             (dup-remove-kit-vars-lov term-drk)
                                             (cons 'let (list (list new-x (dup-remove-kit-prog exp-drk))
                                                              (dup-remove-kit-prog term-drk))))
                        pos2)))]
           [else 
            ; x is the first occurence until now=> rename vars in `body' by ht-rename, 
            ;                                      rename vars in `exp' by ht-rename
            (let*-values ([(new-ht-rename) (hash-set ht-rename x #f)] ;; initial appearance.
                          
                          ;; over-write global hash: dic-vars as #t to show this item is used
                          [(new-dic-vars) (hash-set exp-dic-vars x #t)]
                          
                          [(term-drk pos2) (convert-term (make-dup-remove-kit new-dic-vars (dup-remove-kit-vars-lov exp-drk) body) 
                                                         new-ht-rename 
                                                         next-pos)])
              (values (make-dup-remove-kit (dup-remove-kit-dic-vars term-drk)
                                           (dup-remove-kit-vars-lov term-drk)
                                           (cons 'let (list (list x (dup-remove-kit-prog exp-drk))
                                                            (dup-remove-kit-prog term-drk))))
                      pos2))]))])))

;; output: ht-rename l-vars new-exp
(provide/doc
 (proc-doc/names convert-exp
                 (->* (dup-remove-kit? hash? number?) () (values hash? list? symbol?))
                 ((dup-remove-kit ht-rename pos) ())
                 @{ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ}))
(define (convert-exp drk ht-rename pos)
  (let* ([dic-vars  (dup-remove-kit-dic-vars drk)]
         [l-vars    (dup-remove-kit-vars-lov drk)]
         [exp       (dup-remove-kit-prog drk)]
         #;[v (echo-dup-remove-kit drk)])
    (match exp
      [`(lambda (,x) ,N) (cond 
                           [(introduced-or-converted? dic-vars ht-rename x) ;; x occurs at previous level.=> need rename
                            (let*-values ([(new-x newtmp-dic-vars) (create-nondup-var-hash dic-vars)]
                                          ;; over-write global hash: dic-vars as #t to show this item is used
                                          [(new-dic-vars) (hash-set newtmp-dic-vars x #t)]
                                          
                                          [(new-l-vars) (insert-new-var-at-old-var l-vars new-x pos)])
                              (let* ([new-ht-rename (hash-set ht-rename x new-x)]) ;; over-write current renaming if any.
                                
                                (let*-values ([(next-pos) (add1 pos)] ;; next pos is pos for N
                                              [(term-drk new-pos) (convert-term (make-dup-remove-kit new-dic-vars new-l-vars N) 
                                                                                new-ht-rename 
                                                                                next-pos)])
                                  
                                  (values (make-dup-remove-kit (dup-remove-kit-dic-vars term-drk)
                                                               (dup-remove-kit-vars-lov term-drk)
                                                               (cons 'lambda (list (list new-x)
                                                                                   (dup-remove-kit-prog term-drk))))
                                          new-pos))))]
                           [else
                            (let* ([new-ht-rename (hash-set ht-rename x #f)]
                                   ;; over-write global hash: dic-vars as #t to show this item is used
                                   [new-dic-vars (hash-set dic-vars x #t)])
                              
                              ; x is the first occurence until now=> rename vars in `body' by ht-rename, 
                              ;                                      rename vars in `exp' by ht-rename
                              (let*-values
                                  ([(next-pos) (add1 pos)] ;; next pos is pos for N
                                   [(term-drk new-pos) (convert-term (make-dup-remove-kit new-dic-vars l-vars N) 
                                                                     new-ht-rename
                                                                     next-pos)])
                                
                                (values (make-dup-remove-kit (dup-remove-kit-dic-vars term-drk)
                                                             (dup-remove-kit-vars-lov term-drk)
                                                             (cons 'lambda (list (list x)
                                                                                 (dup-remove-kit-prog term-drk))))
                                        new-pos)))])]
      
      [`(cons ,y1 ,y2) (let*([b-y1-in (conv-exists? ht-rename y1)]
                             [b-y2-in (conv-exists? ht-rename y2)]
                             [exp-cons-proc (λ (p ht-r lol-v new-y1 new-y2)
                                              (values (make-dup-remove-kit ht-r lol-v (cons 'cons (list new-y1 new-y2)))
                                                      p))])
                         (cond [(and b-y1-in b-y2-in);; both are duplicate as prev vars
                                (exp-cons-proc pos dic-vars l-vars (hash-ref ht-rename y1) (hash-ref ht-rename y2))]
                               [(and (not b-y1-in) b-y2-in) ;; only y1 is not duplicate as prev vars
                                (exp-cons-proc pos dic-vars l-vars y1 (hash-ref ht-rename y2))]
                               [(and b-y1-in (not b-y2-in)) ;; only y2 is not duplicate as prev vars
                                (exp-cons-proc pos dic-vars l-vars (hash-ref ht-rename y1)  y2)]
                               [else ;; y1 y2 are not in dup list
                                (exp-cons-proc pos dic-vars l-vars y1 y2)]))]
      
      [(? number? c) (values (make-dup-remove-kit dic-vars l-vars c)
                             pos)]
      
      [(? boolean? c) (values (make-dup-remove-kit dic-vars l-vars c)
                              pos)]
      
      [`(car ,y) (cond [(conv-exists? ht-rename y) 
                        (values (make-dup-remove-kit dic-vars l-vars (cons 'car (cons (hash-ref ht-rename y) '())))
                                pos)]
                       [else (values (make-dup-remove-kit dic-vars l-vars (cons 'car (cons y '())))
                                     pos)])]
      
      [`(cdr ,y) (cond [(conv-exists? ht-rename y)
                        (values (make-dup-remove-kit dic-vars l-vars (cons 'cdr (cons (hash-ref ht-rename y) '())))
                                pos)]
                       [else (values (make-dup-remove-kit dic-vars l-vars (cons 'cdr (cons y '())))
                                     pos)])]
      
      [`(if ,y ,M1 ,M2) (let*-values
                            ([(term-drk1 pos1) (convert-term (make-dup-remove-kit dic-vars l-vars M1) ht-rename pos)]
                             [(term-drk2 pos2) (convert-term (make-dup-remove-kit (dup-remove-kit-dic-vars term-drk1)
                                                                                  (dup-remove-kit-vars-lov term-drk1)
                                                                                  M2)
                                                             ht-rename pos1)]
                             [(prog1) (dup-remove-kit-prog term-drk1)]
                             [(prog2) (dup-remove-kit-prog term-drk2)])
                          
                          (cond [(conv-exists? ht-rename y)
                                 (values (make-dup-remove-kit dic-vars 
                                                              l-vars 
                                                              (list 'if (hash-ref ht-rename y) prog1 prog2))
                                         pos2)]
                                [else 
                                 (values (make-dup-remove-kit dic-vars 
                                                              l-vars 
                                                              (list 'if y prog1 prog2))
                                         pos)]))]
      
      [`(apply ,y ,z) (let*([b-y-in (conv-exists? ht-rename y)]
                            [b-z-in (conv-exists? ht-rename z)]
                            [exp-apply-proc (λ (p ht-r ht-v new-y new-z)
                                              (values (make-dup-remove-kit ht-r ht-v (cons 'apply (list new-y new-z)))
                                                      p))])
                        (cond [(and b-y-in b-z-in);; both are duplicate as prev vars
                               (exp-apply-proc pos dic-vars l-vars (hash-ref ht-rename y) (hash-ref ht-rename z))]
                              [(and (not b-y-in) b-z-in) ;; only y is not duplicate as prev vars
                               (exp-apply-proc pos dic-vars l-vars y (hash-ref ht-rename z))]
                              [(and b-y-in (not b-z-in)) ;; only z is not duplicate as prev vars
                               (exp-apply-proc pos dic-vars l-vars (hash-ref ht-rename y) z )]
                              [else ;; y z are not in dup list
                               (exp-apply-proc pos dic-vars l-vars y z)]))]
      
      ;; expr = M 
      [_ (convert-term (make-dup-remove-kit dic-vars l-vars exp) ht-rename pos)])))

;; testing for getting variable list from given term (application or variable form)
#;(let*-values 
      (;; used for (gensym) which is not duplicates from. need update for new (gensym)
       [(l-vars prog2) (time (convert-no-dupvar prog))])
    (printf "\norigianl prog:\n")
    (pretty-display prog)
    (printf "\nalpha-converted:\n")
    (pretty-display prog2)
    
    (printf "\nlolvars:\n")
    (for-each (λ (v-r) (echo-var-rename v-r)) l-vars))


