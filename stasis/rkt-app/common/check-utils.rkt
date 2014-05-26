#lang racket
(require ffi/unsafe "../../hash-tbl-ctype/hash-code.rkt")
(provide (all-defined-out))
         

;; input cpointer, bytesize
(define (print-memory-byte ptr count)
  (for ([i (in-range count)])
    (let ([by (ptr-ref ptr _byte i)])
      (printf "print-memory-byte: [~a]~a(~a)\t" i by (integer->char by))))
  (newline))

;; shash : cpointer w/ _byte
;; num_var : #column
;; num_uconst : #row
;; unit-size-by: bytes of a cell.
(define (print-shash shash num_var num_uconst unit-size-by)
  (for ([i (in-range num_var)])
    (printf "~a[~a]" (hash-code->string i) i)
    (for ([j (in-range num_uconst)])
      (printf "[~a]" j)
      (for ([pos (in-range unit-size-by)])
          ;; pos + (j*num_var + i) * unit-size-by
        (printf "~a" (integer->char (ptr-ref shash _byte (+ pos (* unit-size-by (+ i (* j num_var))))))))
      (printf "\t"))
    (newline)))
      


(define (print-hash-tbl-stmt ht num-var num-const var-string encoded-constraint constraint-counter)
  
  ;; ptr : string of (num char) = count
  ;; count - # of bytes
  (define (print-char str count)
    (printf "|")
    (for-each (lambda (c) (printf "~a" c)) (string->list str))
    (printf "|\n"))
  
  #;(printf "print-hash-tbl-stmt constraint-cnt:~a, var-string:~a\n" constraint-counter var-string)
  (let* ([var-i (string->hash-code var-string)])
    (let* ([const-i (add1 (vector-ref constraint-counter var-i))])
      (vector-set! constraint-counter var-i const-i)
      
      #;(print-memory-byte encoded-constraint SIZE_CONSTRAINT)
      (printf ;"[~a, ~a] var-string:~a, encoded-constraint:~a\n" var-i const-i var-string encoded-constraint))))
              "put_element(ht, ~a, \"~a\");\n" var-i encoded-constraint)
      )))