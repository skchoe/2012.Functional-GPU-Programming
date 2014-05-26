#lang racket

(require ffi/unsafe
         "../../hash-tbl-ctype/hash-ffi-strarray.rkt"
         "../../hash-tbl-ctype/hash-ffi-string.rkt"
         "../common/check-utils.rkt")


(define-values (ht nv nc vec-const) (make-my-shash 104 3 SIZE_CONSTRAINT INIT-CHAR))
(define bsize (* nv nc SIZE_CONSTRAINT))
(zero-fill ht bsize INIT-CHAR)
;(print-shash ht nv nc SIZE_CONSTRAINT)

(define (fill-a-cvalue ht nv nc size-elt chr)
  (let ([bsize (* nv nc SIZE_CONSTRAINT)])
    (for ([i (in-range bsize)])
      (ptr-set! ht _byte i (char->integer chr)))))

(fill-a-cvalue ht nv nc SIZE_CONSTRAINT #\A)
(print-shash ht nv nc SIZE_CONSTRAINT)

(define (internal-malloc count init-char)
  (let* ([a (malloc count _byte)])
    (zero-fill a count init-char)
    a))

(define count 100)
(define A (internal-malloc count #\a))
(print-memory-byte A count)