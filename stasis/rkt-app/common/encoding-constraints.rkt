#lang racket
(require ffi/unsafe
         racket/local
         racket/match
         "../../hash-tbl-ctype/hash-ffi-string.rkt"
         "../../hash-tbl-ctype/hash-ffi-strarray.rkt"
         "../../hash-tbl-ctype/ffi-common.rkt"
         "commons.rkt")


(provide (all-defined-out))

;; output ptr w/ cstrelt at each cell of length: length-cstrelt
;; output size: SIZE_CONSTRAINT
(define (encode-constraint-2byte-const cstr)
  (local
    [;; cstrelt: symbol, number -> string -> (values cpointer length-of-string)
     (define (convert-to-cptr cstrelt)
       (let* (#;[v (printf "convert-to-cptr: ~a\n" cstrelt)]
              [cstrelt-str 
               (cond [(symbol? cstrelt) (symbol->string cstrelt)]
                     [(number? cstrelt) (number->string cstrelt)]
                     [else (begin (error "constraint element is neither number or symbol (Need extend syntax to have let-form as a body of lambda definition\n") #f)])])
         (values (string->ptr cstrelt-str) (if cstrelt-str (string-length cstrelt-str) 0))))
     
     (define (c-memcpy ptr lst-cstrelt)
       (let ([len-str (length lst-cstrelt)])
         (for/list ([i (in-range len-str)]) ; for each elt of constraint element
           (let ([pos (* i (max-cstrelt-size-byte))])
             (let*-values
                 ([(cstrelt) (list-ref lst-cstrelt i)] ;cstrelt is a string w/o space.
                  [(cstrelt-cptr elt-size) (convert-to-cptr cstrelt)])
               #;(printf "c-memcpy for(~a), at:~a, cstrelt:~a, size:~a\n" i pos cstrelt elt-size)
               (memcpy ptr pos cstrelt-cptr elt-size _byte))))))]
          
  (let* ([ffi-cstr (malloc SIZE_CONSTRAINT _byte)])
    (zero-fill ffi-cstr SIZE_CONSTRAINT INIT-CHAR)
    (match cstr
      [`(cons ,y1 ,y2)
       #;(printf "encode-4. cons: ~a, ~a\n" y1 y2)
       (c-memcpy ffi-cstr (list '_c y1 y2))]
      
      [`(lambda ,y ,N ,finalvar-N) 
       #;(printf "encode-1. Lambda: y:~a, N:~a, finalvar-N:~a\n" y N finalvar-N)
       (c-memcpy ffi-cstr (list '_l y N finalvar-N))]

      [`(propagate-to ,x)
       #;(printf "encode-3. propag to: ~a\n" x)
       (c-memcpy ffi-cstr (list '_P x))]
      
      [`(propagate-car-to ,x)
       #;(printf "encode-5. car to: ~a\n" x)
       (c-memcpy ffi-cstr (list '_C x))]
      
      [`(propagate-cdr-to ,x)
       #;(printf "encode-6. cdr to: ~a\n" x)
       (c-memcpy ffi-cstr (list '_D x))]
      
      [`(conditional-prop ,b ,finalvar ,x)
       #;(printf "encode-if. if, b:~a, finalvar:~a, bindto:~a\n" b finalvar x)
       (c-memcpy ffi-cstr (list '_B b finalvar x))]
      
      [`(application ,x ,z) 
       #;(printf "encode-2. app x:~a, z:~a\n" x z)
       (c-memcpy ffi-cstr (list '_A x z))]

      [_ 
       #;(printf "encode-7. const: ~a\n" cstr)
       (c-memcpy ffi-cstr (list '_v cstr))])
    (let* ([const-encoded-str (ptr->string ffi-cstr length-constraint-string)])
      #;(printf "\n\nencoded -string(~a):~a|\n" cstr const-encoded-str)
      const-encoded-str))))

;; symbol list-of-variables -> string of char
;;'C x -> "cx"
(define (encode-constraint-to-bytestring const-sym 
                                         lst-vars 
                                         var-max-byte 
                                         #:const-name-byte [cn-byte var-max-byte]
                                         #:equal-length [equal-length #t])

  (local
    [;; sym byte-cap list-of-var -> string : list-of-char 
     ;; 'a 1 '(32 6) -> '(#\a 32 6)
     ;; 'b 2 '(256 255) -> '((char->integer b) 1 255 0 255) if cn-byte==1
     ;;                    '(0 (char->integer b) 1 0 0 255) if cn-byte==var-max-byte(2)
     ;; cn-cap is a capacity in byte for constraint name chracter
     ;; cap is a capacity in byte for element in lst.
     ;; lst : list of mix of (boolean number box). 
     ;; output: string, not that bool, number, box are all transformed to chracter #\X or list of it.
     ;; #t->1, #f->0, number -> number, box -> unbox, distiction need to be parsed by symbol/specification.
     (define (gen-constraint-string ch cn-cap cap lst)
       (local
         [(define len (length lst))
          ;; symbol->character representing the kind of constraint
          ;; output: bytestring filled with (symbol->string sym) from the rear.
          ;; ex: 'abc, cap=4 ==> (0 97 98 99)
          (define (symbol->const-code sym cap)
            (let* ([str (symbol->string sym)]
                   [num-zero (- cap (string-length str))])
              (if (< num-zero 0)
                  (error "symbol is longer than capacity")
                  (append (build-list num-zero (λ (x) 0))
                          (map char->integer (string->list str))))))
          
          ;; cap: max-capacity (byte), lst: list of coefficient with base 2^8 (1 byte)
          ;; cap: 4, lst:'(1 2^6 2) = 1*2^(8*2) + 2^6 * 2^(8*1) + 2 * 2^0 => '(0 1 2^6 2)
          ;; output: list of coefficients
          (define (coeffs-in-cap cap lst)
            (let* ([num-zeros (- cap (length lst))])
              (append (build-list num-zeros (λ (x) 0))
                      lst)))]
         
         ;; ch = 'a, lst = (#t [256] 511)
         (let* (;; lst->lst-numbers : (1 256 511)
                ;; unboxing variable into number
                [lst-numbers (map (λ (x) 
                                    (cond
                                      [(number? x) x]
                                      [(box? x) (unbox x)]
                                      [else
                                       (cond
                                         [(not (boolean? x))
                                          (error "var-num->list is taking unsuppored list element")]
                                         [(boolean=? #t x) 1]
                                         [(boolean=? #f x) 0])]))
                                  lst)]
                ;; lst-numbers -> lst-lst-coeff : ((1) (1 0) (1 255))
                [lst-lst-coeff (map decimal->list-of-coeff-base 
                                    lst-numbers
                                    ;; list of base 2^8.
                                    (build-list len (λ (x) (expt 2 8))))]
                ;; lst-lst-coeff -> lst-in-cap : ((0 0 0 1) (0 0 1 0) (0 0 1 255)) if cap=4
                [lst-in-cap (map coeffs-in-cap (build-list (length lst-lst-coeff) (λ (x) cap))  lst-lst-coeff)]
                
                ;; lst-in-cap -> lst-out-codes :       (52 0 0 0 1 0 0 1 0 0 0 1 255) if cn-cap=1
                ;;                               (0 0 0 52 0 0 0 1 0 0 1 0 0 0 1 255) if cn-cap=4
                [lst-out-codes (append (symbol->const-code ch cn-cap)
                                     (flatten lst-in-cap))])
          
           #;(printf "lst-numbers:~a\nlst-lst-coeff:~a\nlst-in-cap:~a\nlst-out-codes:~a\nbyte-string:~s\n" 
                   lst-numbers lst-lst-coeff lst-in-cap lst-out-codes (list->bytes lst-out-codes))
           #;(printf "------~a------~a\n" (add-between lst-out-codes #\|) ch)
           
           (list->bytes lst-out-codes))))]
    
    (let ([len (length lst-vars)]
          [constraint-same? symbol=?])
      ;; checking if constraint is right for each case
      (cond
        [(constraint-same? const-sym 'v) ;; number?
         (unless (equal? len 1) (error " num-var not right - v"))]
        [(constraint-same? const-sym 'b) ;; boolean? 
         (unless (equal? len 1) (error " num-var not right - v"))]
        [(constraint-same? const-sym 'c) ;; cons
         (unless (equal? len 2) (error " num-var not right - c"))]
        [(constraint-same? const-sym 'l) ;; lambda
         (unless (equal? len 2) (error " num-var not right - l"))]
        [(constraint-same? const-sym 'C) ;; propagate-car
         (unless (equal? len 1) (error " num-var not right - C"))]
        [(constraint-same? const-sym 'D) ;; propagate-cdr
         (unless (equal? len 1) (error " num-var not right - D"))]
        [(constraint-same? const-sym 'B) ;; conditional
         (unless (equal? len 3) (error " num-var not right - B"))]
        [(constraint-same? const-sym 'A) ;; application
         (unless (equal? len 2) (error " num-var not right - A"))]
        [(constraint-same? const-sym 'P) ;; propagate-to
         (unless (equal? len 1) (error " num-var not right - P"))]
        [else (error "symbol for constraint is not covered")])
      
      ;; write encoding
      #;(printf "------------------\ninput:const-sym:~a, cap:~a, lst-var:~a\n" const-sym var-max-byte lst-vars)
      (gen-constraint-string const-sym cn-byte var-max-byte lst-vars))))

;; char num -> (values bytes-size numberofvaribles-in-constraint)
(define (constraint-length const-char var-max-byte #:const-name-byte [cn-byte var-max-byte])
  (let* ([const-char-form (if (char? const-char) const-char (integer->char const-char))]
         [xxx (printf "const-char-form:~a, with original const-char:~a\n" const-char-form const-char)]
         [num-vars
          (cond [(char=? const-char-form #\v) 1]
                [(char=? const-char-form #\b) 1]
                [(char=? const-char-form #\c) 2]
                [(char=? const-char-form #\l) 2]
                [(char=? const-char-form #\P) 1]
                [(char=? const-char-form #\C) 1]
                [(char=? const-char-form #\D) 1]
                [(char=? const-char-form #\B) 3]
                [(char=? const-char-form #\A) 2]
                [else (error "constraint-length error at cond")])]
         [const-size-byte (* (+ cn-byte (* var-max-byte num-vars)) (ctype-sizeof _byte))])
    #;(printf "in constraint-length, const-size-byte:~a\n" const-size-byte)
    (values const-size-byte num-vars)))

;; var-max-byte : width of each variable rep (list of byte)
;; lst-vars : list of variables in constraint.
;; const-sym : constraint recognizer
;; output : pointer after memcpy.
(define (encode-constraint-to-cpointer const-sym 
                                       lst-vars 
                                       var-max-byte 
                                       #:const-name-byte [cn-byte var-max-byte]
                                       #:equal-length [equal-length #t])
  
  (let* ([byte-string (encode-constraint-to-bytestring const-sym 
                                                       lst-vars 
                                                       var-max-byte
                                                       #:const-name-byte cn-byte)])
    (cond
      [(zero? (bytes-length byte-string)) (error "byte-string doens't contains valid byte")]
      [else (let* ([ffi-cptr (bytes->ptr byte-string)])
              ffi-cptr)])))

       
;; list-of-list-of-cpointer, num-of-bytes-per-variable_in-constraint
(define (parse-out-collect-cpointer lstlst-const var-max-byte #:uniform-width [uniform-width #t])
  (local
    [(define cn-byte (if uniform-width var-max-byte 1))
     ;; cpointer number -> void
     ;; print const-sym, variables 
     (define (parse-a-constraint-bytes const-bytes var-max-byte #:const-name-byte cn-byte)
       (local
         [;;;
          (define (subdivide-list lst sub-size)
            (local 
              [(define (cons-end elt lst)
                 (append lst (list elt)))]
              (cond
                [(not (zero? (remainder (length lst) sub-size)))
                 (error "subdivide in parse-out-collect-cpointer is not possible - non zero remainder")]
                [else
                 (let loop ([lst-ans '()]
                            [lst-rest lst]
                            [lst-current '()]
                            [idx 1])
                   (cond 
                     [(empty? lst-rest) lst-ans]
                     [else 
                      (cond 
                        [(zero? (remainder idx sub-size)) 
                         (loop (cons-end (cons-end (first lst-rest) lst-current) lst-ans)
                               (rest lst-rest) '() (add1 idx))]
                        [else (loop lst-ans (rest lst-rest) (cons-end (first lst-rest) lst-current) (add1 idx))])]))])))
          ;; (rest-general lst 0) = (rest lst), 
          ;; (rest-general lst k) = (rest ... (rest lst)) , where ... k+1 rests
          (define (rest-general lst offset)
            (let loop ([off offset]
                       [l lst])
              (cond 
                [(zero? off) (rest l)]
                [else (loop (sub1 off) (rest l))])))]
         (let*-values 
             ([(lst-by) (bytes->list const-bytes)]
              [(const-char) (integer->char (first lst-by))]
              #;[(v) (printf "parse-a-const-by, const-char:~a, lst-by:~a\n" const-char lst-by)]
              [(size-byte num-vars) (constraint-length const-char var-max-byte #:const-name-byte cn-byte)])
           (cond
             [(zero? (bytes-length const-bytes)) (begin
                                                   (printf "zero-length constraint - error:~a\n")
                                                   (error "zero length constraint-error"))]
             [else (let* ([lst-by-vars (rest-general lst-by (sub1 cn-byte))] ;;;
                          [lstlst-var (subdivide-list lst-by-vars var-max-byte)])
                     #;(printf "constraint name: ~s\n" (string->symbol (list->string (cons const-char '()))))
                     (for-each (λ (l num-by) 
                                 (let loop ([cnt 0]
                                            [lst l])
                                   (cond [(equal? cnt num-by) (printf "\n")]
                                         [else (printf "~s\t" (first l))
                                               (loop (add1 cnt) (rest lst))])))
                               lstlst-var (build-list (length lstlst-var) (λ (x) var-max-byte))))]))))
     
     ;; constraint:ctype -> byte-string 
     (define (const-cpointer->bytes const var-max-byte [type _byte] #:const-name-byte [cn-byte 1])
       (let* ([by0 (ptr-ref const type (sub1 cn-byte))] ;first element in cptr if cn-byte=1
              [ch0 (integer->char by0)])   ;first char - constraint recognizer
         (let-values ([(const-size num-vars) (constraint-length ch0 var-max-byte #:const-name-byte cn-byte)])
           #;(printf "after lenght, const-size(byte):~a, num-var:~a\n" const-size num-vars)
           (ptr->bytes const const-size type))))]
    
    (for-each 
     ;; index in list-of-<var - l-const>. l-const
     (λ (idx lst-const)
       (cond
         [(empty? lst-const) (printf "var: ~a -------------------\n No-const\n" idx)]
         [else (for-each (λ (sidx const)
                           (let* ([const-bytes (const-cpointer->bytes const var-max-byte #:const-name-byte cn-byte)])
                             (printf "var: ~a--------------------\nconst: ~a,,,,,,,,,,,,,,,\n ~s\n" idx sidx const-bytes)
                             (parse-a-constraint-bytes const-bytes var-max-byte #:const-name-byte cn-byte))
                           (printf "\n----------------------------------------------------------------\n"))
                         (build-list (length lst-const) values)
                         lst-const)]))
     (build-list (length lstlst-const) values) lstlst-const)))

