#lang racket

(define (random-list size max-value)
  (build-list size (lambda (x) (random max-value))))
  
;; log current time-1  
(define current-time-begin (current-inexact-milliseconds))

(define lst (random-list 10 50))

;; log current time-2
(define current-time-end (current-inexact-milliseconds))

;; different between time-1 and time-2 is the elapsed time for expression 
;; creating 'lst' by (random-list 10 50)
(- current-time-end current-time-begin)

;; Don't forget to erase any printf expression when you measure the elapsed time
;; Unit is millisecond = 1/1000 second.

