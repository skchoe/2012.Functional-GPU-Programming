#lang racket
(define-syntax-rule
  (id1 a b . c)
  (let ([b 100])
    (printf "~a, ~a, ~a\n" #'a #'b #'c)))

(provide id1)