#lang racket

(provide foo)
(define foo 
  (lambda (x) (add1 x)))

(provide goo)
(define goo
  (lambda (x) (add1 (add1 (add1 x)))))
