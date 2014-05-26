#lang racket

(require ffi/unsafe)

(require "hash-ffi-string.rkt"
         "hash-code.rkt"
         "ffi-common.rkt"
         "../rkt-app/common/check-utils.rkt")

(provide (all-defined-out))

;number of elt of cstrelt
(define length-cstrelt 2) ; encoding for constraint-tag, lengthes of following variables.
(define (max-cstrelt-size-byte) (* length-cstrelt (ctype-sizeof _byte)))

;; given hash key var-key, idx in value-set
;; output is the count(byte) upto the pos (var-key, set-idx).
;; useful for (ptr-ref)
;; new to be ready for coalescing.
(define (byte-var-setidx num-variables var-key set-idx)
  (+ (* var-key SIZE_CONSTRAINT)
     (* set-idx (shash-size-width num-variables SIZE_CONSTRAINT))))

;; INIT-CHAR-ize a constraint in (var-key, set-idx) in terms of index
(define (shash-clear-var-setidx shash num-variables var-key set-idx)
  (let* ([offset (byte-var-setidx num-variables
                                  var-key 
                                  set-idx)])
    (for ([i (in-range length-constraint-string)])
      (let* ([pos (+ i offset)])
        (ptr-set! shash _byte pos INIT-CHAR)))))

;; given shash, key(var), check all place for const if it's not INIT-CHAR.
;; all INIT-CHAR=>return #f, not all INIT-CHAR=>#t, with first constidx w/ non-INIT-CHAR
(define (shash-key-exist? shash num-variables num-max-constraints k)
  (let*-values
      ([(idx) (string->hash-code k)]
       [(constidxdx exe?)
        (let loop ([constidx 0]
                   [exe? #f])
          (printf "key-exist?-------idx 2 = ~a, Xth-const:~a(~a), num-var-c:~a\n" 
                    idx constidx exe? num-max-constraints)
          (if (equal? constidx num-max-constraints)
              (values constidx exe?)
              (let* ([by (ptr-ref shash 
                                  _byte 
                                  (byte-var-setidx num-variables idx constidx))])
                (printf "key-exist?-------row:~a(~a), ~ath elt-by:~a elt:~a :bool:~a\n" 
                        idx k constidx by (hash-code->string by) (equal? INIT-CHAR (integer->char by)))
                (if (equal? (integer->char by) INIT-CHAR)
                    (values constidx #t)
                    (loop (add1 constidx) exe?)))))])
    (printf "shash-key-exist?:~a, at:~a\n" exe? constidxdx)
    (printf "shash-key-exist?")
    (shash-print-const-set shash num-variables num-max-constraints k)
    exe?))
    
;; given const-arr(var), check if it has v(constraint) already as set element
;; (i #t) -> value exists at i-th index
;; (i #f) -> not exist and i-th index is first empty field.
;;           if i == -1 then full capacity (no place to put)
(define (shash-value-exist? shash num-variables num-max-constraints k v)
  (let*-values 
      ([(idx) (string->hash-code k)] ;; idx starts from zero because INIT-CHAR is subtracted.
       [(lcl-idx exe?)
        (let loop ([lcl-i (- num-max-constraints 1)]; last index in constraint set
                   [exe? #f])
          #;(printf "idx 2 = ~a, lcl-i:~a, num-var-c:~a\n" 
                  idx lcl-i num-max-constraints)
          (if (< lcl-i 0)
              (values lcl-i #f) ;first index in constraint set.
              (let* ([by (ptr-ref shash _byte (byte-var-setidx num-variables idx lcl-i))])
                (if (equal? (integer->char by) INIT-CHAR) 
                    (begin
                      #;(printf "equal; ~ath elt:~a\n" lcl-i by)
                      (loop (- lcl-i 1) exe?))
                    (let ([const-str (malloc SIZE_CONSTRAINT)])
                      (memcpy const-str 
                              shash 
                              (byte-var-setidx num-variables idx lcl-i)
                              SIZE_CONSTRAINT 
                              _byte)
                      (let* ([str (ptr->string const-str length-constraint-string)])
                        #;(printf "str in ~athh pos:~a to comp. v:~a\n" lcl-i str v)
                        (if (string=? str v)
                            (values lcl-i #t)
                            (loop (- lcl-i 1) exe?))))))))])
        (values lcl-idx exe?)))

;; output : exe? shows if full?
;;          idx of empty room if (exe? == #f)
;;          idx is meaningless if (exe? == #t)
;; useful if need to find empty pos if (exe? == #f)
(define (shash-value-full? shash num-variables num-max-constraints k)
  (let*-values 
      ([(idx) (string->hash-code k)]) ;; idx starts from zero because INIT-CHAR is subtracted.
    (let loop ([lcl-i 0]
               [exe? #t])
      #;(printf "idx 2 = ~a, lcl-i:~a, num-var-c:~a\n" 
                idx lcl-i num-max-constraints)
      (if (equal? lcl-i num-max-constraints)
          (values lcl-i exe?)
          (let* ([offset (byte-var-setidx num-variables idx lcl-i)]
                 [by (ptr-ref shash _byte offset)])
            #;(printf "full?(~a) w/ offset:~a, by:~a\n" lcl-i offset by)
            (if (equal? (integer->char by) INIT-CHAR)
                (values lcl-i #f)
                (loop (+ lcl-i 1) exe?)))))))


;; shash is mutable array 
;; output: void
;; updated: shash, cv-ht.
(define (shash-add-elt shash num-variables num-max-constraints k v dummy-arg)
  (let* ([idx (string->hash-code k)]
         [size-v (string-size-byte v)]
         [m-str (string->ptr v)])
    (print-memory-byte m-str SIZE_CONSTRAINT)
    (printf "____(shash-add-elt) to shash k:~a, v:~a, idx:~a, size-v:~a\n"
            k v idx size-v)
    (let*-values
        ([(k-exe?) (shash-key-exist? shash num-variables num-max-constraints k)]
         [(pos v-exe?) (shash-value-exist? shash num-variables num-max-constraints k v)]
         [(empty-pos full?) (shash-value-full? shash num-variables num-max-constraints k)])
      (printf "key-exist?:~a, \tvalue-exist? ~a, where:~a value:~a, size:~a\n" 
              k-exe? v-exe? pos (ptr-ref m-str _byte) size-v)
      (if k-exe?
          (if full? 
              (error "Value set is full\n")
              (unless v-exe? ;;#t=value exists -> nothing
                (let-values ()
                  (memcpy shash (byte-var-setidx num-variables idx empty-pos)
                          m-str size-v _byte))))
          (memcpy shash (byte-var-setidx num-variables idx 0) m-str size-v _byte))
      (printf "____(shash-add-elt) ended v-idx:~a(~a), c-pos:~a\n" idx k empty-pos)
      (printf "Updated shash(~a):\n" k)
      )))


; union arr into existing shash w/ key `k'.
; arr: static array of string(under cap: max-string-size-byte, < length-constraint-string char) "propagage ."
; represented bytes in racket w/ length.
; output is void.
(define (shash-union-set shash k ptr-arr count)
  (for ([lcl-i (in-range count)])
    (if (shash-value-full? shash k)
        (error "union failed: value set is full\n")
        (let* ([const-by (malloc SIZE_CONSTRAINT _byte)])
          (memcpy const-by 0 
                  (ptr-ref ptr-arr _byte (* lcl-i SIZE_CONSTRAINT)) SIZE_CONSTRAINT
                  _byte)
          (let* ([const-str (ptr->string const-by length-constraint-string)])
            (shash-add-elt shash k const-str))))))

; output ptr to pos: byte-array w/ valid length(size)
(define (shash-get-elts shash num-variables num-max-constraints k)
  (let* ([num-valid-value (shash-count-constraints shash k)]
         [idx (string->hash-code k)])
    (let*-values 
        ([(ptr idx)
          (for/fold ([out-ptr (malloc (* num-valid-value SIZE_CONSTRAINT) _byte)]
                     [out-idx 0])
            ([lcl-i (in-range num-max-constraints)])
            (let* ([init-by (byte-var-setidx (shash-size-width num-variables SIZE_CONSTRAINT) idx lcl-i)])
              (if (equal? INIT-CHAR (integer->char (ptr-ref shash _byte init-by)))
                  (values out-ptr out-idx)
                  (begin
                    (memcpy out-ptr (* out-idx length-constraint-string)
                            shash init-by SIZE_CONSTRAINT
                            _byte)
                    (values out-ptr (+ out-idx 1))))))])
      (values num-valid-value ptr))))

;; output is integer
(define (shash-count-constraints shash num-variables num-max-constraints k)
  (let* ([idx (string->hash-code k)])
    (for/fold ([num 0])
      ([lcl-i (in-range num-max-constraints)])
      (let* ([offset (byte-var-setidx (shash-size-width num-variables SIZE_CONSTRAINT) idx lcl-i)]
             [init-by (ptr-ref shash _byte offset)])
        #;(printf "num(~a)--off:~a--------~a, ~a\n" lcl-i offset INIT-CHAR init-by)
        (if (equal? INIT-CHAR (integer->char init-by)) num (+ 1 num))))))
  
;; INIT-CHAR=-ize all constraint set(v) for k. 
(define (shash-delete-elt shash num-variables k v)
  (if (shash-key-exist? shash (shash-size-width num-variables SIZE_CONSTRAINT) k)
      (let-values ([(lcl-i v-exe?) 
                    (shash-value-exist? shash (shash-size-width num-variables SIZE_CONSTRAINT)k v)])
        (if v-exe?
            (shash-clear-var-setidx shash (shash-size-width num-variables SIZE_CONSTRAINT) (string->hash-code k) lcl-i)
            (error "shash deletion: key exists, but no value in the set\n")))
      (error "shash deletion: doesn't have a key\n")))

(define (shash-print-all shash bsize)
  (for ([i (in-range bsize)])
    (printf "~a " (ptr-ref shash _byte i)))
  (newline))

(define (shash-print-const-set shash num-variables num-max-constraints var-key)
  (let* ([idx (string->hash-code var-key)])
    (printf "idx:~a(~a) -- " idx var-key)
    (for ([lcl-i (in-range num-max-constraints)])
      (let* ([const-by (malloc SIZE_CONSTRAINT _byte)])
             
        (memcpy const-by 0 shash (byte-var-setidx num-variables idx lcl-i) SIZE_CONSTRAINT _byte)
        
        (let* ([const-str (ptr->string const-by length-constraint-string)]
                                       ;(λ (x) (if (equal? x SP) #\space (integer->char x))))]
               [const-char (map char->integer (string->list const-str))])
        (printf "[~a]: ~a(~a)\t" lcl-i const-str const-char))))
    (printf "\n")))


(define (shash-size-width num-variables size_constraint)
  (* num-variables size_constraint))


;num-var : a ~ Z aa ~ aZ
;num-uconst : constraints per variable - unit constraint
; size-const: bytes for each encoded constraint
(define (make-my-shash num-var num-uconst size-const init-char)
  (let* ([size-by (* num-var num-uconst size-const)]
         [constraint-counter (make-vector num-var 0)]
         
         [shash (malloc size-by _byte)])
    
    (zero-fill shash size-by init-char)
    (values shash
            num-var
            num-uconst
            constraint-counter)))
