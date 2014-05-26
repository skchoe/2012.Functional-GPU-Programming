#lang at-exp racket

(require scribble/srcdoc)
(require/doc racket/base
             racket/contract
             scribble/manual)

;; name \in h-val
;; form is either simple member of h-val('h-c 'h-b) or collection of st-exp : either (cons st-exp st-exp) - cons or (st-exp st-exp) - lam
(provide/doc
 (thing-doc st-exp
            (struct/c st-exp symbol? (or/c symbol? list?))
            @{@racket[st-exp] is a struct having two fields: @racket[name], @racket[form]. 
               @racket[name] is a expression name of heap values: constant, boolean, lambda, cons. 
               @racket[form] is either simple symbol representing constant or boolean or cons of @racket[st-exp] or domain and range of lambda which is of form @racket[(st-exp? st-exp?)].}))
(define-struct st-exp (name form)) ; intermediate format to store hnm2var var2hnm correctly.

(define VAR_MAX (expt 2 5))
(define init-num-var 10)

(provide/doc
 (proc-doc/names random-but
                 (->* (number?) (#:except list?) number?)
                 ((N) ((l-except '())))
                 @{Outputs random number which are not a member of @racket[l-except].}))
(define (random-but N #:except [l-except '()])
  (let loop ()
    (let ([v (random N)])
      (if (member v l-except) (loop) v))))

(provide/doc
 (proc-doc/names pick-rdm-elt-from-list
                 (->* (list?) (#:except list?) symbol?)
                 ((lst) ((l-except '())))
                 @{Outputs element from list @racket[lst] by random selection except elments of indices in @racket[l-except].}))
(define (pick-rdm-elt-from-list lst #:except [l-except '()]) ;; except is index in lst
  (cond
    [(empty? lst) #f]
    [else
     (list-ref lst (random-but (length lst) #:except l-except))]))


(provide/doc
 (proc-doc/names pick-rdm-elt-from-set
                 (-> set? symbol?)
                 (st)
                 @{Outputs element from set @racket[st] by random selection.}))
(define (pick-rdm-elt-from-set st) ;; except is index in lst
  (cond
    [(set-empty? st) #f]
    [else
     (list-ref (set->list st) (random (set-count st)))]))

;; exp-hash, list-of-exp-name exp-name ('any 'any-but-lambda (-oneof7- if len is l-expname), (-oneof4- if len is l-hval))
;; len: (list 'h-c 'h-b 'h-lam 'h-cons)
;; output: st-exp or #f.
(provide/doc
 (proc-doc/names hash-ref-rdm-exp-name
                 (-> hash? hash? number? symbol? (values symbol? hash?))
                 (h2v v2h len exp-alias)
                 @{ @racket[h2v] is a hashtable which maps expression name to set of variables, 
                    @racket[v2h] is a hashtable which maps varaible to expression name defined by let-binding,
                    @racket[len] is a list of any expression names or heap values, and @racket[exp-alias] is a symbol:
                    
                    @(itemize @item{@racket[h-lam]: lambda expression}
                              @item{@racket[heap-only]: heap expressions: constant, boolean, lambda, cons}
                              @item{@racket[non-lambda-heap]: any names from @racket[heap-only] except lambda}
                              @item{@racket[any-but-lambda]: any names from @racket[len] but lambda}
                              @item{@racket[any]: any names from @racket[len]})
                    
                    Output is a variable randomly chosen and associate hash table of expression name.}))
(define (hash-ref-rdm-exp-name h2v v2h len exp-alias)
  (let ([pick-proc 
         ;; output: (values variable, exp-name of the variable)
         (λ (exp-name)
           (let* ([var-set (hash-ref h2v exp-name)])
             (cond 
               [(set-empty? var-set)
                (begin (printf "varset at expname:~a :~a\n" exp-name var-set)
                       (error " this cannot be happended - h2v is initialized by not empty for every exp-names"))]
               [else
                (let* ([var (pick-rdm-elt-from-set var-set)]
                       [s-exp (hash-ref v2h var)])
                  (values var s-exp))])))])
    
    ;; exp-alias : 'any, 'any-but-lambda, 'non-lambda-heap, 'heap-only, other case, its same as exp-name.
    (cond
      [(symbol=? exp-alias 'any) ;; random kinds of exp pick
       (pick-proc (pick-rdm-elt-from-list len #:except '()))]
      [(symbol=? exp-alias 'any-but-lambda)
       (pick-proc (pick-rdm-elt-from-list len #:except (list 2)))] ;; 2 is index of lambda
      [(symbol=? exp-alias 'non-lambda-heap)
       (pick-proc (pick-rdm-elt-from-list len #:except (list 2 4 5 6 7 8)))] ;; 2 is index of lambda
      [(symbol=? exp-alias 'heap-only)
       (pick-proc (pick-rdm-elt-from-list len #:except (list  4 5 6 7 8)))]
      [(symbol=? exp-alias 'h-lam) ;; need to return 2 values: one is existing variable for lamba, the other is list of exp name(param, finalvar)
       (pick-proc 'h-lam)]
      [(symbol=? exp-alias 'app)
       (pick-proc 'app)] ; -- need addtion
      [else
       (pick-proc exp-alias)])))

;; output-> variable
(provide/doc
 (proc-doc/names hash-ref-rdm-var
                 (->* (hash? symbol?) ((-> void?)) (or/c symbol? void?))
                 ((h2v exp-name) ((proc-failure (λ () (error "no element in corresponding variable set\n")))))
                 @{Choose variable for given expression name @racket[exp-name]. Run @racket[proc-failure] if there is no variable available in @racket[h2v].}))
(define (hash-ref-rdm-var h2v exp-name [proc-failure (λ () (error "no element in corresponding variable set\n"))])
  (let ([st (hash-ref h2v exp-name)])
    (if (set-empty? st)
        (proc-failure)
        (pick-rdm-elt-from-set st))))

;; len (list 'h-c 'h-b 'h-lam 'h-cons)
(provide/doc
 (proc-doc/names init-ht-hnm2var
                 (-> list? hash?)
                 (len)
                 @{Initialize/produce a new hashtable that maps each expression names in @racket[(list 'h-c 'h-b 'h-lam 'h-cons)] to empty sets}))
(define (init-ht-hnm2var len)
  (hash-set
   (hash-set
    (hash-set 
     (hash-set 
      (hash) (list-ref len 3) (set))
     (list-ref len 2) (set))
    (list-ref len 1) (set))
   (list-ref len 0) (set)))

;; len (list of exp-names), exp-name: of the following symbol, varsym: symbol of parameter
;; out: hash
(provide/doc
 (proc-doc/names init-exp-hash-w-param 
                (-> list? symbol? symbol? hash?)
                (len exp-name var-sym)
                @{Initialize hashtable of heap-values with a single input variable @racket[var-sym] of element in @racket[(list 'h-c 'h-b 'h-lam 'h-cons)]}))
(define (init-exp-hash-w-param len exp-name var-sym)
  (let ([h2v (init-ht-hnm2var len)])
    (put-in-ht h2v exp-name var-sym)))

;; put variable var-sym into ht under exp-name key.
(provide/doc
 (proc-doc/names put-in-ht
                (-> hash? symbol? symbol? hash?)
                (ht exp-name var-sym)
                @{@racket[ht] is a hashtable from expression to set of variables.
                   This produces a new hashtable with a key @racket[exp-name] and value that is a form of set with @racket[var-sym] inserted}))
(define (put-in-ht ht exp-name var-sym)
  (let* ([var-set (hash-ref ht exp-name (λ () 
                                          (printf "key of ht to pull:~a\n" exp-name)
                                          (error "put-in-ht: failed to get the key")))]
         [new-ht (hash-set ht exp-name (set-add var-set var-sym))])
    #;(printf "put-in-ht, exp-name:~a, var to put:~a, new-ht:~a\n" exp-name var-sym new-ht)
    new-ht))

      
;; var is a symbol, 
;; output is exp-name by searching throught sets in hts.
(provide/doc
 (proc-doc/names get-exp-name-from-ht
                (-> hash? symbol? (or/c symbol? #f))
                (ht varsym)
                @{Outputs expression name which associates to variable @racket[varsym]. If there is no expression name whose associate set doesn't contain @racket[varsym], it returns @racket[#f].}))
(define (get-exp-name-from-ht ht varsym)
  (let loop ([lst-ht (hash->list ht)])
    (cond
      [(empty? lst-ht) #f]
      [else
       (let ([kv-pair (first lst-ht)])
         (if (set-member? (second kv-pair) varsym) 
             (first kv-pair)
             (loop (rest lst-ht))))])))

(provide/doc
 (proc-doc/names gen-exp
                 (->* (number? number? symbol? hash? hash? list? list?) (#:option symbol?) (values string? hash? hash? number? st-exp?))
                 ((current-num current-depth exp-name hnm2var var2hnm l-expname l-hval) ((position 'in-exp)))
                 @{Takes @racket[current-num] as current count of variables, @racket[exp-name] as name of expression to generate, 
                         @racket[current-depth] as a value saying the distance from mainstream flow of expression tree,
                         @racket[exp-name] as expression name given either explicitly. @racket[gen-random-exp] generates this in random and use this function,
                         @racket[hnm2var], @racket[var2hnm] as hash tables for name to set of variables, for variable to expression name respectively,
                         @racket[l-expname], @racket[l-hval] as lists as defined in @racket[gen-prog],
                         @racket[position], as optional argument saying position of current code generation such as @racket['top], @racket['in-exp], and @racket['in-lambda].
                         As examples of @racket[position], @racket['top] means the expression occurs in top level(tree main flow), @racket['in-exp], in expression (in @racket[M] or (if b @racket[M] @racket[M])), and @racket['in-lambda] in lambda definition (λx. M), respectively.
                         This function uses the following nested function that generates associated code and new values for variable counting.
                         @(itemize @item{@racket[gen-h-c]: generates random constant smaller than @racket[VAR_MAX].}
                                   @item{@racket[gen-h-b]: generates either 0 or 1.}
                                   @item{@racket[gen-h-lam]: generates a single simbol as a parameter and a body of the function using @racket[gen-super-term]. The hash tables @racket[hnm2var] and @racket[var2hnm] are updated by the parameter and a new term as the body of function.}
                                   @item{@racket[gen-h-cons]: randomly pick two values from two hash tables in arguments with their names. lambda is excluded for the choice of variable.}
                                   @item{@racket[gen-car], @racket[gen-cdr]: a cons form was picked from hash tables and the corresponding variable (car, cdr) are picked from the cons form.}
                                   @item{@racket[gen-if]: boolean variable is chosen from hash tables and two terms are generated by @racket[gen-super-term].}
                                   @item{@racket[gen-app]: randomly pick a lambda from hash tables with type information for the parameter and range of the function. pick randomly variable for the type from hash tables uses the type of range as type of expression.})
                                   Finally the term @racket[M] is generated from @racket[gen-super-term].}))

;; output-> c-str-for-exp hnm2var var2hnm current-num st-exp
(define (gen-exp current-num current-depth exp-name hnm2var var2hnm l-expname l-hval #:option [position 'in-exp])
  (local [;; getting constant in range [0 VAR_MAX-1] helps for the values stored in fixed space
          ;; function for exp string generation
          (define (gen-h-c) 
            (values (number->string (random VAR_MAX)) ;; get a value from location (constant)
                    'h-c))
          (define (gen-h-b)
            (values (number->string (remainder (random VAR_MAX) 2)) ;; 0 or 1
                    'h-b))
          ;; output: (values exp-string dom-st-exp rng-st-exp new-num_madeby_body)
          (define (gen-h-lam h2v v2h current-num current-depth l-hval #:option [position 'in-lambda])
            (let*-values 
                (;; parameter creation
                 [(ex-dom-name) (pick-rdm-elt-from-list l-hval #:except (list 1 2))] ;; any h-val except boolean, lambda
                 [(ex-dom-form) (if (symbol=? ex-dom-name 'h-cons) (list 'cons (make-st-exp 'h-c 'h-c) (make-st-exp 'h-c 'h-c)) ex-dom-name)] ;; ex-dom-name is either 'h-c, 'h-b, 'h-cons
                 [(s-dom) (make-st-exp ex-dom-name ex-dom-form)]
                 [(new-current-num) (add1 current-num)] ;; parameter is considered to be a new variable in terms of constraints generation
                 
                 [(var-param) (gensym 'p)]
                 [(new-hnm2var) (put-in-ht hnm2var ex-dom-name var-param)]
                 [(new-var2hnm) (hash-set var2hnm var-param s-dom)]
                 #;[(v) (printf "gen-hlam, param-type:~a hash-set lambda 9:~a, var-param:~a, name_in_v2h:~a\n" 
                              ex-dom-name ex-dom-form var-param
                              (hash-ref new-var2hnm var-param))]

                 ;; body creation
                 [(Mstr new-new-hnm2var new-new-var2hnm new-num new-depth final-s-exp)
                  (gen-super-term "" new-current-num (add1 current-depth) new-hnm2var new-var2hnm l-expname l-hval #:option position)]) ;; add1 to current-num considering param
              
            (values (string-append "(lambda (" (symbol->string var-param) ") " Mstr ")")
                    s-dom
                    final-s-exp new-num))) ;;  2 values (second, third) are for domain, rng type form.
          
          ;; output: (values exp-string ex-name1, 2)
          (define (gen-h-cons h2v v2h l-hval)
            (let-values ([(var1 s-exp1) (hash-ref-rdm-exp-name h2v v2h l-hval 'any-but-lambda)]
                         [(var2 s-exp2) (hash-ref-rdm-exp-name h2v v2h l-hval 'any-but-lambda)])
              (values (string-append "(cons " (symbol->string var1) " " (symbol->string var2) ")") 
                      s-exp1 s-exp2)))
          
          (define (gen-car h2v v2h l-hval)
            (let*-values ([(var s-exp) (hash-ref-rdm-exp-name h2v v2h l-hval 'h-cons)]) ;; s-exp = ('h-cons ['cons name1 name2])
              (values (string-append "(car " (symbol->string var) ")") (second (st-exp-form s-exp)))))
          
          (define (gen-cdr h2v v2h l-hval) 
            (let*-values ([(var s-exp) (hash-ref-rdm-exp-name h2v v2h l-hval 'h-cons)]);; s-exp = ('h-cons ['cons name1 name2])
              (values (string-append "(cdr " (symbol->string var) ")") (third (st-exp-form s-exp)))))
          
          (define (gen-if current-num current-depth h2v v2h l-expname l-hval #:option [position 'in-exp])
            (let*-values
                ([(var b-s-exp) (hash-ref-rdm-exp-name h2v v2h l-hval 'h-b)] ;; answer
                 [(Mstr1 h2v1 v2h1 new-num1 new-depth1 final-s-ex1) 
                  (gen-super-term "" current-num (add1 current-depth) h2v v2h l-expname l-hval #:option position)] ;; true
                 [(Mstr2 h2v2 v2h2 new-num2 new-depth2 final-s-ex2) 
                  (gen-super-term "" new-num1 new-depth1 h2v v2h l-expname l-hval #:option position)]) ;; false
              (values 
               (string-append "(if " (symbol->string var)  " " Mstr1 " " Mstr2 ")")
               (make-st-exp 'h-c 'h-c) ;; by definition of gen-term, all final value is h-c type. (by contract)
               new-num2))) ;; here we need to specify when var can be zero or not
          
          (define (gen-app h2v v2h l-hval)
            (let*-values
                ([(lam-var lam-s-exp) (hash-ref-rdm-exp-name h2v v2h l-hval 'h-lam)]
                 #;[(v) (printf "gen-app---------exp-name-h-lam:~a  \t--ex-form-lam:~a, lam-var:~a\n" (st-exp-name lam-s-exp) (st-exp-form lam-s-exp) lam-var)]
                 #;[(w) (printf "h2v:~a\nv2h:~a\n" h2v v2h)]
                 [(app-var param-s-exp) (hash-ref-rdm-exp-name h2v v2h l-hval (st-exp-name (first (st-exp-form lam-s-exp))))])
              (values (string-append "(apply " (symbol->string lam-var) " " (symbol->string app-var) ")" )
                      (second (st-exp-form lam-s-exp)))))]
    
    (match exp-name
      ['h-c #;(printf "randomly selected expression:~a\n" exp-name)
            (let-values ([(c-str exp-name) (gen-h-c)])
              (values c-str hnm2var var2hnm current-num (make-st-exp 'h-c 'h-c)))]
      ['h-b #;(printf "randomly selected expression:~a\n" exp-name)
            (let-values ([(b-str exp-name) (gen-h-b)])
              (values b-str hnm2var var2hnm current-num (make-st-exp 'h-b 'h-b)))]
      ['h-lam #;(printf "randomly selected expression:~a\n" exp-name)
              ;; body of lambda use existing h2v v2h but doesn't write new one there.
              (let-values ([(lam-str dom-s-exp rng-s-exp new-current-num)
                            (gen-h-lam hnm2var var2hnm current-num current-depth l-hval #:option 'in-lambda)])
                #;(printf "gen-exp: h-lamm -> exp-names:~a, forms:~a\n" (list (st-exp-name dom-s-exp) (st-exp-name rng-s-exp)) (list (st-exp-name dom-s-exp) (st-exp-name rng-s-exp)))
                (values lam-str hnm2var var2hnm new-current-num (make-st-exp 'h-lam (list dom-s-exp rng-s-exp))))];;'(formal_expname, final_expname), hnm2var no change
      ['h-cons #;(printf "randomly selected expression:~a\n" exp-name)
               (let-values ([(cons-str s-exp1 s-exp2) (gen-h-cons hnm2var var2hnm l-hval)])
                 (values cons-str hnm2var var2hnm current-num (make-st-exp 'h-cons (list 'cons s-exp1 s-exp2))))]
      ['car #;(printf "randomly selected expression:~a\n" exp-name)
            (let-values ([(car-str bound-s-exp) (gen-car hnm2var var2hnm l-hval)])
              (values car-str hnm2var var2hnm current-num bound-s-exp))]  ;; ----------last argument is type for bound variable ->
      ['cdr #;(printf "randomly selected expression:~a\n" exp-name)
            (let-values ([(cdr-str bound-s-exp) (gen-cdr hnm2var var2hnm l-hval)])
              (values cdr-str hnm2var var2hnm current-num bound-s-exp))]
      ['if #;(printf "randomly selected expression:~a\n" exp-name)
           (let-values ([(if-str bound-s-exp new-num) (gen-if current-num current-depth hnm2var var2hnm l-expname l-hval #:option 'in-exp)])
             (values if-str hnm2var var2hnm new-num bound-s-exp))]
      ['app #;(printf "randomly selected expression:~a\n" exp-name)
            (let-values ([(app-str bound-s-exp) (gen-app hnm2var var2hnm l-hval)])
              (values app-str hnm2var var2hnm current-num bound-s-exp))]
      ['term #;(printf "randomly selected expression:~a\n" exp-name) ;; how to ???
             (let-values
                 ([(term-str term-hnm2var term-var2hnm new-current-num new-current-depth finalvar-s-exp) ;; finalvar-expname is bound-exp-name 
                   (gen-super-term "" current-num (add1 current-depth) hnm2var var2hnm l-expname l-hval #:option 'in-exp)])
               (values term-str term-hnm2var term-var2hnm new-current-num finalvar-s-exp))])))


;; current-depth : distance to main-stream flow = number of bound variables.
;; output: exp-name ('if), new-exp-string ((if b ex-t ex-f)), new hnm2var, var2hnm
(provide/doc
 (proc-doc/names gen-random-exp
                (->* (number? number? hash? hash? list? list?) (#:option symbol?) (values string? hash? hash? number? st-exp?))
                ((current-num current-depth hnm2var var2hnm l-expname l-hval) ((position 'in-exp)))
                @{Outputs the same thing as @racket[gen-exp], but it creates expression name by randomly choosing 
                                            from @racket[l-expname]. @racket[option] tag defines the policy of the 
                                            choice depending on the location of current expression in code.
                                            @(itemize @item{@racket['top]: in first term: The body of term @racket[M].}
                                                      @item{@racket['in-exp]: in expression: bounded to a variable}
                                                      @item{@racket['in-lambda]: in the body of lambda expression}
                                                      @item{@racket['var-term]: in top level})}))
(define (gen-random-exp current-num current-depth hnm2var var2hnm l-expname l-hval #:option [position 'in-exp]);'top, 'in-exp, 'in-lambda, 'var-term
  (let ([exp-name
         (let loop ([iter-num l-expname]
                    [option-pos position])
           (let* ([lst-except (cond
                                [(symbol=? option-pos 'in-lambda) (list 1 2)] ; 'h-c, 'h-cons allowed
                                [(symbol=? option-pos 'in-exp) (list 1)] ; 'h-c, 'h-lam, 'h-cons allowed
                                [else (list 'any)])] ;; 'var-term => unreachable, 'top-> anything is okey
                  [en (pick-rdm-elt-from-list l-expname #:except lst-except)])
             (cond 
               [(empty? iter-num) 'h-c]
               [(not en) (loop (sub1 iter-num) option-pos)]
               [else en])))])
    (gen-exp current-num current-depth exp-name hnm2var var2hnm l-expname l-hval)))

(provide/doc
 (proc-doc/names proc-init-constant
                 (-> number? hash? hash? (values string? list? hash? hash?))
                 (num-var hnm2var var2hnm)
                 @{Creates an initial code made out of constant values as many as @racket[num-var]. Register them in output hashtables.}))
;; create constants, numbers and set them in 'h-c key in hnm2var
(define (proc-init-constant num-var hnm2var var2hnm)
  (let loop ([code ""]
             [l-var '()]
             [h2v hnm2var]
             [v2h var2hnm]
             [n num-var])
    (cond
      [(zero? n) (values code l-var h2v v2h)]
      [else
       (let* ([new-var (gensym 'v)]
              [new-num (random num-var)])
         (loop (string-append code "(let (" (symbol->string new-var) " " (number->string new-num) ")\n  ")
               (cons new-var l-var)
               (put-in-ht h2v 'h-c new-var) ;; put all the values in the set under 'h-c key.
               (hash-set v2h new-var (make-st-exp 'h-c 'h-c))
               (sub1 n)))])))

(provide/doc
 (proc-doc/names final-term-closing
                 (-> string? hash? hash? string?)
                 (code-before hnm2var var2hnm)
                 @{Generates a string which is a variable defined previously and closing parenthesis as many as opened in the code.}))
(define (final-term-closing code-before hnm2var var2hnm)
  (local
    [(define (var-count-h2v h2v)
       (let loop ([keys (hash-keys h2v)]
                  [num-var 0])
         (cond
           [(empty? keys) num-var]
           [else (loop (cdr keys) (+ num-var (set-count (hash-ref h2v (car keys)))))])))
     (define (var-count-v2h v2h)
       (length (hash-keys v2h)))]

  (let*-values 
      ([(v s-ex) (hash-ref-rdm-exp-name hnm2var var2hnm (hash-keys hnm2var) 'any)])
    #;(printf "number of variable in hnm2var = ~a, var2hnm:~a\n" (var-count-h2v hnm2var) (var-count-v2h var2hnm))
    (string-append code-before (symbol->string v) 
                   (list->string (build-list (var-count-h2v hnm2var) (λ (x) #\))))))))

(provide/doc
 (proc-doc/names gen-a-init-bindexp 
                 (-> symbol? list? hash? hash? number? (values string? hash? hash? number?))
                 (exp-name l-prv-var h2v v2h num-var)
                 @{}))
;; "(let (boudv exp)" where boundv is a symbol for bound variable, exp is expression string in l-expname
(define (gen-a-init-bindexp exp-name l-prv-var h2v v2h num-var)
  (let*-values 
      ([(bound-v) (gensym 'v)]
       [(str-prefix) (string-append "(let " "(" (symbol->string bound-v) " ")]
       [(str-suffix) ")\n"]
       [(new-num-var) (add1 num-var)]
       [(str-exp new-h2v new-v2h new-new-num-var)
        (let* ([pre-v (pick-rdm-elt-from-list l-prv-var)]
               [pre-v-str (symbol->string pre-v)])
          (cond  
            [(symbol=? exp-name 'h-c)
             (let ([val (random (length l-prv-var))])
               (values (number->string val) (put-in-ht h2v 'h-c bound-v) 
                       (hash-set v2h bound-v (make-st-exp 'h-c 'h-c)) 
                       new-num-var))]
            
            [(symbol=? exp-name 'h-b)
             (let* ([val (remainder (random (length l-prv-var)) 2)])
               (values (number->string val) (put-in-ht h2v 'h-b bound-v) (hash-set v2h bound-v (make-st-exp 'h-b 'h-b)) new-num-var))]
            
            [(symbol=? exp-name 'h-lam) ;; identity function with constant argument
             (let* ([p (gensym 'p)]     ;; parameter -  v2h contains < var -> '(name1 name2) >
                    [p-str (symbol->string p)];; p is a var as 'h-c
                    [n-num-var (add1 new-num-var)]) ;; parameter is one of the variable
               (put-in-ht h2v 'h-c p)
               (hash-set v2h p (make-st-exp 'h-c 'h-c))
               #;(printf "init-put in var:~a, exp-name:~a\n" bound-v exp-name)
               (values (string-append "(lambda (" p-str ")  " p-str ")")
                       (put-in-ht h2v 'h-lam bound-v)
                       (hash-set v2h bound-v (make-st-exp 'h-lam (list (make-st-exp 'h-c 'h-c) (make-st-exp 'h-c 'h-c))))
                       n-num-var))]
            
            [(symbol=? exp-name 'h-cons) ;; v2h contains < bound-v -> ('cons name1 name2) >
             (let* ([pv-exp (hash-ref v2h pre-v)]
                    [v2h-val (list 'cons pv-exp pv-exp)])
               (values (string-append "(cons " pre-v-str " " pre-v-str ")")
                       (put-in-ht h2v 'h-cons bound-v)
                       (hash-set v2h bound-v (make-st-exp 'h-cons v2h-val))
                       new-num-var))]
            
            [(symbol=? exp-name 'car)
             (let* ([v-cons (hash-ref-rdm-var h2v 'h-cons)]
                    [fst-s-exp (second (st-exp-form (hash-ref v2h v-cons)))] ;; v2h contains ('cons x y)
                    [exp-nm (st-exp-name fst-s-exp)])
               (values (string-append "(car " (symbol->string v-cons) ")")
                       (put-in-ht h2v exp-nm bound-v)
                       (hash-set v2h bound-v fst-s-exp)
                       new-num-var))]
            
            [(symbol=? exp-name 'cdr) 
             (let* ([v-cons (hash-ref-rdm-var h2v 'h-cons)]
                    [snd-s-exp (third (st-exp-form (hash-ref v2h v-cons)))] ;;v2h contains ('cons x y)
                    [exp-nm (st-exp-name snd-s-exp)])
               #;(printf "Exp-name = cdr, name-sym:~a, exp-nm:~a\n" snd-s-exp exp-nm)
               (values (string-append "(cdr " (symbol->string v-cons) ")")
                       (put-in-ht h2v exp-nm bound-v) 
                       (hash-set v2h bound-v snd-s-exp)
                       new-num-var))]
            
            [(symbol=? exp-name 'if)
             (let* ([v-bool (hash-ref-rdm-var h2v 'h-b)]
                    [v-t (hash-ref-rdm-var h2v 'h-c)]
                    [v-f (hash-ref-rdm-var h2v 'h-c)])
               (values (string-append "(if " (symbol->string v-bool) " " (symbol->string v-t) " " (symbol->string v-f) ")")
                       (put-in-ht h2v 'h-c bound-v)
                       (hash-set v2h bound-v (make-st-exp 'h-c 'h-c))
                       new-num-var))]
            
            [(symbol=? exp-name 'app)
             (let* ([v-lam (hash-ref-rdm-var h2v 'h-lam)]
                    [lam-s-exp (hash-ref v2h v-lam)]
                    [dom-s-exp (first (st-exp-form lam-s-exp))]
                    [rng-s-exp (second (st-exp-form lam-s-exp))]
                    [v-arg (hash-ref-rdm-var h2v (st-exp-name dom-s-exp))])
               (values (string-append "(apply " (symbol->string v-lam) " " (symbol->string v-arg) ")")
                       (put-in-ht h2v (st-exp-name rng-s-exp) bound-v) 
                       (hash-set v2h bound-v rng-s-exp)
                       new-num-var))]
            [(symbol=? exp-name 'term)
             (let ([pv-exp (hash-ref v2h pre-v)])
               (values pre-v-str (put-in-ht h2v (st-exp-name pv-exp) bound-v) (hash-set v2h bound-v pv-exp) new-num-var))]
            [else (error "there is unrecognized one")]))])
    (values (string-append str-prefix str-exp str-suffix) new-h2v new-v2h new-num-var)))
       

;; total num-var
;; current num-var
;; current-depth:int distance to main stream of program tree = number of bound variable.
;; ex) M: cd=0, (λx M): cd=1, (let (x 1) (if b M1 M2)): cd(M1)=1, cd(M2)=(add1 cd(M1)), (let (y (λx M1)) M2): cd(M2)=1, (λx M1)
;; ht for name and variables
;; position 'top, 'in-exp, 'in-lambda, 'var-term
;; -> string for term, updated hnm2var, exp-name of final_var
(provide/doc
 (proc-doc/names gen-super-term
                 (->* (string? number? number? hash? hash? list? list?) (#:option symbol?) (values string? hash? hash? number? number? symbol?))
                 ((code current-num current-depth hnm2var var2hnm l-expname l-hval) ((position 'top)))
                 @{Produces example code and appends to the end of @racket[code]. 
                   This read global variable @racket[init-term-var] and @racket[VAR_MAX] and generate as many variables as the number 
                   of them doesn't exceed the maximum.
                   
                   @racket[current-depth] represents the distance to main stream of program tree, which is counted by the number of bound variable in between term and main stream, for example, 
                   for term @racket[M], current-depth @racket[cd, M: cd=0, (λx M): cd=1, (let (x 1) (if b M1 M2)): cd(M1)=1, cd(M2)=(add1 cd(M1)), (let (y (λx M1)) M2): cd(M2)=1, (λx M1)]
                   
                   Output contains the final variable name as a symbol. 
                   
                   @racket[position] is where the bounded variable is found which is either
                   
                   @(itemize @item{@racket['top]: in first term: The body of term @racket[M].}
                             @item{@racket['in-exp]: in expression: bounded to a variable}
                             @item{@racket['in-lambda]: in the body of lambda expression}
                             @item{@racket['var-term]: in top level})}))
(define (gen-super-term code current-num current-depth hnm2var var2hnm l-expname l-hval #:option [position 'top])
  #;(printf " gen super -term current num:~a, current-depth:~a \n" current-num current-depth)
  (let*-values
      ([(num-term-var) (- VAR_MAX current-depth)]
       [(final-code hnm2var var2hnm new-current-num new-current-depth new-s-exp)
        (cond 
          [(< num-term-var (+ (length l-expname) init-num-var)) 
           (printf "init-num-var:~a w/ length of l-expname:~a VAR_MAX:~a\n ~a < ~a + ~a \n" init-num-var (length l-expname) VAR_MAX
                   VAR_MAX init-num-var (length l-expname) )
           (error "init-num-var + basic expressions .exceeds. VAR__MAX")]
          
          ;; const choice for exp
          [(< current-num init-num-var) ;; stage for initial `constant' generation
           (let*-values
               ([(new-var) (gensym 'v)]
                [(new-num) (random init-num-var)]
                [(bind-str) (string-append "(let " 
                                           " (" (symbol->string new-var) " " (number->string new-num) ")"  "\n")]
                [(n-current-num) (add1 current-num)] ;; new-var is added
                [(final-code hnm2var var2hnm new-current-num new-current-depth new-s-exp)
                 (gen-super-term (string-append code bind-str)
                                 n-current-num
                                 current-depth
                                 (put-in-ht hnm2var 'h-c new-var) ;; put all the values in the set under 'h-c key.
                                 (hash-set var2hnm new-var (make-st-exp 'h-c 'h-c))
                                 l-expname l-hval)])
             (values (string-append final-code ")") hnm2var var2hnm new-current-num new-current-depth new-s-exp))]
          
          ;; round robin choce of exp
          [(< current-num (+ init-num-var (length l-expname))) ;; statge for expression generation  round-robin way
           (let*-values 
               ([(idx) (- current-num init-num-var)]
                [(exp-name) (list-ref l-expname idx)]
                ;; exp generation, ncurrent-num==(add1 current-num)
                [(str-exp new-h2v new-v2h n-current-num) 
                 (gen-a-init-bindexp exp-name (hash-keys var2hnm) hnm2var var2hnm current-num)] ;; new var is added inside of (gen-a-init-bindexp)
                [(final-code hnm2var var2hnm new-current-num new-current-depth new-s-exp)
                 (gen-super-term (string-append code str-exp)
                                 n-current-num 
                                 current-depth 
                                 new-h2v new-v2h 
                                 l-expname l-hval #:option position)])
             (values (string-append final-code ")") hnm2var var2hnm new-current-num new-current-depth new-s-exp))]
          
          ;; random choise of exp (== num-var - 1)
          [(equal? current-num (sub1 (sub1 num-term-var))) ;; num-term-var-1 is last index. 
           (let*-values 
               ([(pre-v ps-exp) (hash-ref-rdm-exp-name hnm2var var2hnm l-hval 'h-c)]
                [(new-v) (gensym 'v)]
                [(bind-str) (string-append "(let (" (symbol->string new-v) " " (symbol->string pre-v) " ) \n")]
                [(new-current-num) (add1 current-num)]
                [(final-code hnm2var var2hnm new-new-current-num new-current-depth new-s-exp)
                 (gen-super-term (string-append code bind-str)
                                 new-current-num current-depth
                                 (put-in-ht hnm2var (st-exp-name ps-exp) new-v)
                                 (hash-set var2hnm new-v ps-exp)
                                 l-expname l-hval #:option position)])
             #;(printf "last of let-binding of recursion making new bound var(h-c):~a, old thing picked var: ~a, w/ expname:~a\n" 
                     new-v pre-v (st-exp-name ps-exp))
             (values (string-append final-code ")") hnm2var var2hnm new-new-current-num new-current-depth new-s-exp))]
          
          ;; random choise of exp ( < num-var - 1)
          [(< current-num (sub1 num-term-var))
           (let*-values 
               (#;[(x) (printf "random\n")]
                [(new-sym) (gensym 'v)]
                [(new-exp-str new-hnm2var new-var2hnm new-current-num s-exp);;returned depth is not used here (bound-var binding-exp)
                 (gen-random-exp current-num (add1 current-depth) hnm2var var2hnm l-expname l-hval #:option position)] ;; exp generation
                [(let-binding) (string-append "(let "  "  (" (symbol->string new-sym) " " new-exp-str ")\n")]
                [(n-current-num) (add1 new-current-num)] ;; new-sym is added
                [(final-code hnm2var var2hnm new-new-current-num new-current-depth new-s-exp)
                  (gen-super-term (string-append code let-binding) 
                                  n-current-num 
                                  current-depth
                                  new-hnm2var new-var2hnm 
                                  l-expname l-hval #:option position)])
             (values (string-append final-code ")") hnm2var var2hnm new-new-current-num new-current-depth new-s-exp))]
          
          [else ;; current-num == num-term-var - 1 ;; last index
           (let* (#;[x (printf "VAR_MAX:~a, current-num:~a\n" VAR_MAX current-num)]
                  [rdm-var (hash-ref-rdm-var hnm2var 'h-c (λ () (error "gen-super-exp : no element in corresponding variable set\n")))])
             (values (string-append code (symbol->string rdm-var)) hnm2var var2hnm current-num current-depth (make-st-exp 'h-c 'h-c)))])]) ;; finish with simple term
    (values (string-append final-code " ") hnm2var var2hnm new-current-num new-current-depth new-s-exp)))

(provide/doc
 (proc-doc/names gen-prog
                 (-> number? number? list? list? string? void?)
                 (current-num current-depth l-expname l-hval out-filename)
                 @{Produce a racket code following target grammar under the limit on number of variables, depth of structure of code. 
                   Currently, @racket[lst-exp-name] is a list @racket[(list 'h-c 'h-b 'h-lam 'h-cons 'car 'cdr 'if 'app 'term)] 
                   and @racket[l-hval] is  @racket[(list 'h-c 'h-b 'h-lam 'h-cons)]. Total number of variable is defined as a global variable @racket[VAR_MAX], and
                   it needs to be greather than @racket[init-num-var]
                   
                   This function calls @racket[gen-super-term] for generating actual body of code and appends it with header portion of racket program which is about language declaration,
                   @racket[require] and @racket[provide] forms}))
(define (gen-prog current-num current-depth l-expname l-hval out-file-name)
  (let* ([opt (open-output-file out-file-name #:mode 'text #:exists 'replace)]
         
         [ht-hnm2var (init-ht-hnm2var l-hval)] ;; h-lam -> v1234 for example
         [ht-var2hnm (hash)]) ;; v1234 -> '('h-c 'h-cons).
    (let*-values
        ([(final-term hnm2var var2hnm new-current-num new-current-depth new-s-exp)
          (gen-super-term "" 0 0 ht-hnm2var ht-var2hnm l-expname l-hval #:option 'top)];; current num of bound var, depth start 0.
         [(final-prog) (string-append "#lang racket \n(provide prog) \n(define prog '" final-term ")")])
      (display final-prog opt)
      (close-output-port opt)
      (printf "\ncode:~a\nnum-of-variable :~a" final-prog (add1 new-current-num)))))
     
;; keyword - values
;; #:position - '('top in-exp in-lambda) : represents occuring position of term M 
;; - either top level(tree main flow), in expression (in M or (if b M M)), or in lambda definition (λx. M)
(let* ([lst-exp-name (list 'h-c 'h-b 'h-lam 'h-cons 'car 'cdr 'if 'app 'term)] ;; kinds of expression to be picked in random
       [lst-hval (list 'h-c 'h-b 'h-lam 'h-cons)]
       [num-var 0]
       [num-depth 0])
  (gen-prog num-var num-depth lst-exp-name lst-hval "input-prog-gen_10_10.rkt"))
