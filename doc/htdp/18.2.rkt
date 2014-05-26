#lang racket

(define (f x) (+ (* x x) 25))
(define (g x) (* 12 (expt x 5)))
;call the one to the right of the function name BINDING occurrence of x and those in the body the BOUND occurrences of x
;LEXICAL SCOPE
;FREE OCCURRENCE GLOBAL SCOPE.

(define (p1 x y) 
  (+ (* x y)
     (+ (* 2 x)
	(+ (* 2 y) 22))))

(define (p2 x)
  (+ (* 55 x) (+ x 11)))

(define (p3 x)
  (+ (p1 x 0)
     (+ (p1 x 1) (p2 x))))

; push <check-syntax> button

