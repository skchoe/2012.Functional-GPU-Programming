#lang scheme/base

(provide ten)
(define ten 10)

(provide mult-ten)
(define (mult-ten x)
         (* x 10))

(provide child-struct?)
(define-struct child-struct (son daughter))

(define cld (make-child-struct "tom" "gerry"))
(if (child-struct? cld) (printf "right type\n") (printf "wrong type\n"))