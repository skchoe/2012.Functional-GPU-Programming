#lang racket
#|
#This code is implementation of Hash-table (key value) set specifically
# key and values are racket string type.
# key doesn't allow duplicate by definition (this is possible because this will 
# deal with intermediate code from fully extended program
|#
(require ffi/unsafe
         "hash-code.rkt"
         "ffi-common.rkt")
(provide (all-defined-out))



(define length-constraint-string 8); max length of a constraint string (2 x 4) ex:(lambda ,y ,N ,finalvar-N) 

;; bytes for max-long constraint
(define SIZE_CONSTRAINT
  (* length-constraint-string _byte-size))

(define start-code 48) ; zero code - for efficiently use key-space from index 0.


;; v string
;; outstring-put: void?
(define (string-put ht k v)
  (let* ([idx (string->hash-code k)]
         [size-v (string-size-byte v)]
         [m-str (string->ptr v)])
    (memcpy ht 
            (* SIZE_CONSTRAINT idx) 
            m-str 
            (+ (string-size-byte v) _byte-size) 
            _byte)
    (printf "k:~a, idx:~a\n" k v)))

(define (string-get ht k)
  (let*-values
      ([(idx) (string->hash-code k)]
       [(max-const-byte) SIZE_CONSTRAINT]
       [(dest) (malloc max-const-byte)])
    (memcpy dest 0 
            ht (* SIZE_CONSTRAINT idx) max-const-byte 
            _byte)
    (ptr->string dest length-constraint-string)))