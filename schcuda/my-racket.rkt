#lang racket
(require ffi/unsafe
         ffi/cvector)

(provide (all-defined-out))

(define (pointer->list ptr type size)
  (let loop ([i 0]
             [lst '()])
    (if (< i size)
        (loop (add1 i) (append lst (list (ptr-ref ptr type i))))
        lst)))

