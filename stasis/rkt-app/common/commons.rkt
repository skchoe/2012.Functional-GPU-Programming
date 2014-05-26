#lang at-exp racket
(require "../../input-progs/input-progs-forseq.rkt"
         racket/contract
         scribble/manual
         scribble/srcdoc
         (for-doc racket/base
                  racket/contract
                  scribble/manual))

(provide
 (proc-doc/names decimal->list-of-coeff-base
                 (-> number? number? list?)
                 (inupt base)
                 @{For given input number, and base, output is a list of coefficients when input is represented polynomial with input base. The order of coefficients are downward which is the coefficient of biggest exponent comes first and constant comes the last. For example, input 256, base 2^8 produces (1, 0)}))
;; input 13, base 8 => (1, 5)
;; 
(define (decimal->list-of-coeff-base input base)
  (let loop ([v input]
             [lc '()])
    (let-values
        ([(q r) (quotient/remainder v base)])
      (cond
        [(zero? q) (cons r lc)]
        [else (loop q (cons r lc))]))))

;; input : maximum number -> number of bytes to contain the number
;; 255 -> 1, 256 -> 2
;; 65535 -> 2, 65536 -> 3 (if pos2==#f), 4 (if pos2==#t).
(provide
 (proc-doc/names decimal->container-size/byte
                 (->* (number?) (#:powerof2 boolean?) number?)
                 ((input) ((po2 #f)))
                 @{For given input number @racket[input], produces number of bytes to contain the number, for example, 65535->2, 65536->3, if po2==#f, 4 if po2==#t}))
(define (decimal->container-size/byte input #:powerof2 [po2 #f])
  (local
    [(define (decimal->bit-string input)
       (decimal->list-of-coeff-base input 2))
     
     (define (decimal->num-bits input)
       (length (decimal->bit-string input)))
     
     (define (round-to-powerof2 input)
       (let* ([lst-binary (decimal->list-of-coeff-base input 2)])
         (cond 
           [(empty? lst-binary) (error "round-to-powerof2: binary list is empty")]
           [else
            (let* ([len (length lst-binary)]
                   [shift-count
                    (if (zero? (foldl + 0 (rest lst-binary)))
                        (sub1 len)
                        len)])
              (arithmetic-shift (car lst-binary)
                                shift-count))])))]
    
    (let* ([bits (decimal->num-bits input)]
           [bitsabyte 8]
           [ans (ceiling (/ bits bitsabyte))])
      (if po2 
          (round-to-powerof2 ans)
          ans))))


;; var -> box-immutable.
(provide/doc
 (proc-doc/names new-box
                 (->* (number?) () box?)
                 ((x) ())
                 @{Wraps @racket[box-immutable] to create a box form from a variable created as serial number by alpha conversion}))
(define (new-box x)
  (box-immutable x))

;; box -> box
(provide/doc
 (proc-doc/names box-add1
                 (->* (box?) () box?)
                 ((x) ())
                 @{unwrap input box @racket[x], called @racket[y], wrap again @racket[(add1 x)] with box})) 
(define (box-add1 x)
  (new-box (add1 (unbox x))))

;; ask if x is distance index
(provide
 (proc-doc/names distance?
                 (->* (box?) () boolean?)
                 ((x) ())
                 @{calls @racket[(box? x)] to check if @racket[x] is represented as distance in the code.}))
(define (distance? x)
  (box? x))

;; number box -> box
;; pos: number, current traversal position
;; offset: number, distance to closest binder (lambda or let)
;; ->need to support N at (if b M N)
;; db-idx: distance Rep. of variable
(provide
 (proc-doc/names distance->pos-box 
                 (->* (number? box?) () box?)
                 ((pos db-idx) ())
                 @{computes same way as @racket[distance->pos], produce the result of wrapping it with @racket[box].}))
(define (distance->pos-box pos db-idx)
  (let* ([pos (distance->pos pos db-idx)])
    (cond
      [(number? pos) (new-box pos)]
      [else (error "distance->pos didn't return number")])))

;; number box -> number
(provide
 (proc-doc/names distance->pos
                 (->* (number? box?) () number?)
                 ((pos db-idx) ())
                 @{produces ditance between binding and position, which is obtained by subtracting @racket[pos] from @racket[db-idx]. If that value is negative, produce error.}))
(define (distance->pos pos db-idx)
  #;(printf "distance->pos pos:~a, db-idx:~a\n" pos db-idx)
  (cond
    [(distance? db-idx) 
     (let* ([idx (unbox db-idx)]
            [ans (- pos idx)])
       (cond
         [(< ans 0) (error "distance is bigger than current position")]
         [else ans]))]
    [else (error "distance->pos error w/ db-idx - Not distance")]))

#;(defstruct var-rename ([org-var symbol?] 
                       [new-var symbol?] 
                       [pos symbol?])
  "associates three pieces of information about variable transformation. @racket[org-var] denote original variable, @racket[new-var] is new variable after alpha conversion, @racket[pos] is position information when variables are traversed in sequence.")
(provide (struct-out var-rename))
(define-struct var-rename (org-var new-var pos))

#;(provide/doc
 (thing-doc var-rename
            (struct/c var-rename box? box? number?)
            @{associates three pieces of information about variable transformation. @racket[org-var] denote original variable, @racket[new-var] is new variable after alpha conversion, @racket[pos] is position information when variables are traversed in sequence.}))
#;(provide
   (proc-doc/names var-rename?
                   (-> any/c boolean?)
                   (v)
                   @{Returns #t if v is a var-rename struct created by make-var-rename, #f otherwise.}))

(defproc (echo-var-rename [v-r var-rename?]) #f "prints fields of @racket[var-rename] strucure")
#;(provide/doc
 (proc-doc/names echo-var-rename
                 (->* (var-rename?) () void?)
                 ((v-r) ())
                 @{print old name, new name, position in @racket[var-rename] struct})) 
(define (echo-var-rename v-r)
  (printf "org-var:~a\nnew-var:~a\npos:~a\n"
          (var-rename-org-var v-r)
          (var-rename-new-var v-r)
          (var-rename-pos v-r)))

(provide
 (proc-doc/names var-rename->string
                 (->* (var-rename?) () string?)
                 ((v-r) ())
                 @{produces a string showing each element of @racket[var-rename] structure }))
(define (var-rename->string v-r)
  (format "org-var:~a\tnew-var:~a\tpos:~a\n"
          (var-rename-org-var v-r)
          (var-rename-new-var v-r)
          (var-rename-pos v-r)))

(provide/doc
 (proc-doc/names global-binders-hash
                 (->* (symbol?) () hash?)
                 ((prog) ())
                 @{}))
;; input program -> hash-table (<var> <new-var or #f>)  in evaluation order: var occurs either let-binding or lambda binding
#;(provide global-binders-hash)
(defproc (id (prog symbol?)) string? "input program -> hash-table (<var> <new-var or #f>)  in evaluation order: var occurs either let-binding or lambda binding")
(define (global-binders-hash prog)
  (local
    [;; level : previous level to be increased if term is not a symbol(var)
     (define (binders-term prog ht)
       #;(printf "binder-term:~a\n" prog)
       (match prog
         [(? symbol? x) ;(printf "traverse-exps: symbol: ~a\n" x)
          ht]
         [`(let (,x ,exp) ,body)
          (let ([ht (hash-set ht x #f)])
            (binders-exp exp (binders-term body ht)))]))
     
     ;; level : previous level to be likely updated in body
     (define (binders-exp exp ht)
       (match exp
         [`(lambda (,y) ,N) (binders-term N (hash-set ht y #f))]
         [`(cons ,y1 ,y2) ht]
         [(? number? c) ht]
         [(? boolean? c) ht]
         [`(car ,y) ht]
         [`(cdr ,y) ht]
         [`(if ,y ,M ,N) (binders-term N (binders-term M ht))]
         [`(apply ,y ,z) ht]
         ;; expr = M 
         [_ (binders-term exp ht)]))]
    
    (binders-term prog (make-immutable-hash null))))


;; lol is list of pair = (orig-varname alpah-varname)
(provide/doc
 (proc-doc/names global-binders-lol
                 (->* (symbol?) () list?)
                 ((prog) ())
                 @{}))
(define (global-binders-lol prog)
  (local
    (;; level : previous level to be increased if term is not a symbol(var)
     ;; pos is next pos. use as used and output (add1 pos)
     (define (binders-term prog lst pos)
       (match prog
         [(? symbol? x) (values pos lst)]
         [`(let (,x ,exp) ,body)
          (let*-values ([(pos1 l1) (binders-exp exp lst pos)]
                        [(pos2 l2) (values (add1 pos1) (cons (list x pos1) l1))])
            (binders-term body l2 pos2))]))
     
     ;; level : previous level to be likely updated in body
     (define (binders-exp exp lst pos)
       (match exp
         [`(lambda (,y) ,N) (binders-term N (cons (list y pos) lst) (add1 pos))]
         [`(cons ,y1 ,y2)  (values pos lst)]
         [(? number? c)  (values pos lst)]
         [(? boolean? c)  (values pos lst)]
         [`(car ,y)  (values pos lst)]
         [`(cdr ,y)  (values pos lst)]
         [`(apply ,y ,z)  (values pos lst)]
         ;; expr = M
         [_ (binders-term exp lst pos)])))
    
    (let-values ([(last-pos lst-vars) (binders-term prog '() 0)])
      #;(printf "vars in list: ~a in eval order\n" lst-vars)
      (reverse lst-vars))))

;; lov is list of varname = (orig-varname alpah-varname pos)
;; prog: normal program with binding variables
(provide/doc
 (proc-doc/names global-binders-lov
                 (->* (symbol?) () list?)
                 ((prog) ())
                 @{}))
#;(provide global-binders-lov)
(define (global-binders-lov prog)
  (local
    (;; level : previous level to be increased if term is not a symbol(var)
     ;; pos is next pos. use as used and output (add1 pos)
     (define (binders-term prog lst pos)
       (match prog
         [(? symbol? x) (values pos lst)]
         [`(let (,x ,exp) ,body)
          (let*-values ([(pos1 l1) (binders-exp exp lst pos)]
                        [(pos2 l2) (values (add1 pos1) (cons (make-var-rename x #f pos1) l1))])
            (binders-term body l2 pos2))]))
     
     ;; level : previous level to be likely updated in body
     (define (binders-exp exp lst pos)
       (match exp
         [`(lambda (,y) ,N) (binders-term N (cons (make-var-rename y #f pos) lst) (add1 pos))]
         [`(cons ,y1 ,y2)  (values pos lst)]
         [(? number? c)  (values pos lst)]
         [(? boolean? c)  (values pos lst)]
         [`(car ,y)  (values pos lst)]
         [`(cdr ,y)  (values pos lst)]
         [`(if ,y ,M ,N) (let*-values ([(posM lM) (binders-term M lst pos)])
                           (binders-term N lM posM))]
         [`(apply ,y ,z)  (values pos lst)]
         ;; expr = M 
         [_ (binders-term exp lst pos)])))
    
    (let-values ([(last-pos lst-vars) (binders-term prog '() 0)])
      #;(printf "vars in list: in eval order:\n")
      #;(for-each (λ (v-r) 
                    (printf "org:~a, new:~a, pos:~a\n" (var-rename-org-var v-r) (var-rename-new-var v-r) (var-rename-pos v-r)))
                  lst-vars)
      
      (reverse lst-vars))))

(provide/doc
 (proc-doc/names count-bindings
                 (->* (symbol?) () number?)
                 ((prog) ())
                 @{}))
;; prog is simplied version with binding are hidden as a distance to close binders
(define (count-bindings prog)
  (local
    [(define (count-bindings-term prog cnt)
       (match prog
         [`(let ,exp ,body) 
          (let* ([exp-cnt (count-bindings-exp exp cnt)]
                 [term-cnt (count-bindings-term body exp-cnt)])
            (add1 term-cnt))]
         [_ cnt]))
     
     (define (count-bindings-exp exp cnt)
       (match exp
         [`(lambda ,N) 
          (let* ([term-cnt (count-bindings-term N cnt)])
            (add1 term-cnt))]
         [`(cons ,y1 ,y2)  cnt]
         [(? number? c)  cnt]
         [(? boolean? c)  cnt]
         [`(car ,y)  cnt]
         [`(cdr ,y)  cnt]
         [`(if ,y ,M ,N) 
          (let* ([t-cnt (count-bindings-term M 0)]
                 [f-cnt (count-bindings-term N 0)])
            (+ t-cnt f-cnt cnt))]
         [`(apply ,y ,z) cnt]
         ;; expr = M 
         [_ (count-bindings-term exp cnt)]))]
    
    (count-bindings-term prog 0)))


;; program -> list of binders from position zero.
;; prog: normal prog with binding variables
(provide/doc
 (proc-doc/names prog->list-of-binders
                 (->* (symbol?) () list?)
                 ((prog) ())
                 @{}))
(define (prog->list-of-binders prog)
  (let* ([lst-onp (global-binders-lov prog)]); list of (oldvar, newvar, position)
    (map var-rename-org-var lst-onp)))

(provide/doc
 (proc-doc/names dup-exist?
                 (->* (list? symbol? (-> symbol? symbol?)) () list?)
                 ((lst var selector) ())
                 @{}))
;; lst is list of list
(define (dup-exist? lst var selector)
  (cond
    [(empty? lst) #f]
    [else (for/and ([i (in-range (length lst))])
            (symbol=? var (selector (list-ref lst i))))]))

(provide/doc
 (proc-doc/names cons-end
                 (->* (any/c list?) () list?)
                 ((x lst) ())
                 @{insert @racket[x] into list @racket[lst] at the end position}))
(define (cons-end x lst)
  (reverse (cons x (reverse lst))))

#;(provide new-var)
(provide/doc
 (proc-doc/names new-var
                 (->* (symbol? var-rename?) () var-rename?)
                 ((var v-r) ())
                 @{create new @racket[var-rename] object using new variable @racket[var] at @racket[new-var] field of @racket[var-rename]}))

(define (new-var var v-r)
  (make-var-rename (var-rename-org-var v-r)
                   var
                   (var-rename-pos v-r)))

(provide/doc
 (proc-doc/names create-nondup-var-list
                 (->* (list?) () list?)
                 ((lst) ())
                 @{}))
;; lst : list of variables
(define (create-nondup-var-list lst)    
  (let loop ([new-sym (gensym "v")])
    (let ([dup? (dup-exist? lst new-sym (λ (x) x))])
      (if (not dup?)
          (values new-sym (cons-end new-sym lst))
          (loop (gensym "v"))))))

;; lol : list of pair (first second)
(provide/doc
 (proc-doc/names create-nondup-var-lol
                 (->* (list?) () list?)
                 ((lol) ())
                 @{}))
(define (create-nondup-var-lol lol)
  (let loop ([new-sym (gensym "v")])
    (let ([dup? (dup-exist? lol new-sym first)])
      (if (not dup?) 
          (values new-sym (cons-end (list new-sym #f) lol))
          (loop (gensym "v"))))))

;; lov : list of var-rename 
(provide/doc
 (proc-doc/names create-nondup-var-lov 
                 (->* (list?) () list?)
                 ((lov) ())
                 @{}))
(define (create-nondup-var-lov lov)
  (let loop ([new-sym (gensym "v")])
    (let ([dup? (dup-exist? lov new-sym var-rename-org-var)])
      (if (not dup?) 
          (values new-sym (cons-end (make-var-rename new-sym (length lov) #f) lov))
          (loop (gensym "v"))))))

;; ht: immutable hashtable (<variable> <position>):(<symbol> <number>)
;; output variable
;; how: create new variable which is not a member of keys of hashtable.
#;(provide create-nondup-var-hash)
(provide/doc
 (proc-doc/names create-nondup-var-hash
                 (->* (hash) () symbol?)
                 ((ht) ())
                 @{}))
(define (create-nondup-var-hash ht)  
  (let*-values 
      ([(new-var newlst) (create-nondup-var-list (hash-keys ht))]
       [(new-ht) (hash-set ht new-var #f)]) ;; Newly generated variable in inserted to HT
    (values new-var new-ht)))

(provide/doc
 (proc-doc/names list-copy
                 (->* (list?) () list?)
                 ((lst) ())
                 @{}))
(define (list-copy lst)
  (let loop ([rv-lst (reverse lst)]
             [cnt (length lst)]
             [new-lst '()])
    (cond
      [(zero? cnt) new-lst]
      [else (loop (rest rv-lst) (sub1 cnt) (cons (first rv-lst) new-lst))])))

#;(provide update-list-element)
(provide/doc
 (proc-doc/names update-list-element
                 (->* (list? any/c number?) () list?)
                 ((lst elt pos) ())
                 @{}))
(define (update-list-element lst elt pos)
  (let loop ([rv-lst (reverse lst)]
             [cnt (length lst)]
             [new-lst '()])
    (cond
      [(zero? cnt) new-lst]
      [else (let ([cpos (sub1 cnt)])
              (if (equal? cpos pos) 
                  (loop (rest rv-lst) (sub1 cnt) (cons elt new-lst))
                  (loop (rest rv-lst) (sub1 cnt) (cons (first rv-lst) new-lst))))])))


;; input program -> list-of-vars in evaluation order
;; go through pgm, get let-levels
;; each level is defined when it traverse (let x exp) -> x location is the level.
(provide/doc
 (proc-doc/names compute-let-var-position
                 (->* (symbol?) () list?)
                 ((prog) ())
                 @{}))
(define (compute-let-var-position prog)
  (local
    (;; level : previous level to be increased if term is not a symbol(var)
     (define (traverse-term prog lst)
       #;(printf "prog = ~a, level:~a \n" prog lst)
       (match prog
         [(? symbol? x) ;(printf "traverse-exps: symbol: ~a\n" x)
          lst]
         [`(let (,x ,exp) ,body)
          (let* ([lst-var1 (traverse-term body (cons x lst))])
            (traverse-exp exp lst-var1))]))
     
     ;; level : previous level to be likely updated in body
     (define (traverse-exp exp lst)
       (match exp
         [`(lambda (,y) ,N) (traverse-term N lst)]
         [`(cons ,y1 ,y2)  lst]
         [(? number? c) lst]
         [(? boolean? c) lst]
         [`(car ,y) lst]
         [`(cdr ,y) lst]
         [`(apply ,y ,z) lst]
         ;; expr = M 
         [_ (traverse-term exp lst)])))
    
    (let* ([lst-vars (traverse-term prog '())]) ;; zero is initial level (location of the var in env)
      #;(printf "vars in env: ~a in eval order\n" lst-vars)
      (reverse lst-vars))))

(provide/doc
 (proc-doc/names copy-to-new-list
                 (->* (symbol?) () symbol?)
                 ((term) ())
                 @{}))
(define (copy-to-new-list term)
  (local ((define (parse-term out-src src)
            ;(printf "Term: ~a\n" src)
            (match src
              [(? symbol? x) x]
              [`(let (,x ,exp) ,body)
               (list 'let (list x (parse-exp out-src exp)) (parse-term out-src body))]))
          (define (parse-exp out-src expr)
            ;(printf "Exp: ~a\n" expr)
            (match expr
              [`(lambda (,y) ,N) (list 'lambda (list y) (parse-term out-src N))]
              [`(cons ,y1 ,y2)  expr]
              [(? number? c) expr]
              [(? boolean? c) expr]
              [`(car ,y) expr]
              [`(cdr ,y) expr]
              [`(apply ,y ,z) expr]
              ;; expr = M 
              [_ (parse-term out-src expr)])))
    (parse-term '() term)))


;; testing for creating new code after transformation
#;(pretty-display (copy-to-new-list prog))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
