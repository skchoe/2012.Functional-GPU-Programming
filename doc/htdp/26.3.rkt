#lang racket
;; gcd-structural : N[>= 1] N[>= 1]  ->  N
;; to find the greatest common divisior of n and m
;; structural recursion using data definition of N[>= 1] 
(define (gcd-structural n m)
  (local ((define (first-divisior-<= i)
	    (cond
	      [(= i 1) 1]
	      [else (cond
		      [(and (= (remainder n i) 0) 
			    (= (remainder m i) 0))
		       i]
		      [else (first-divisior-<= (- i 1))])])))
    (first-divisior-<= (min m n))))

;; gcd-generative : N[>= 1] N[>=1]  ->  N
;; to find the greatest common divisior of n and m
;; generative recursion: (gcd n m) = (gcd n (remainder m n)) if (<= m n)
(define (gcd-generative n m)
  (local ((define (clever-gcd larger smaller)
	    (cond
	      [(= smaller 0) larger]
	      [else (clever-gcd smaller (remainder larger smaller))])))
    (clever-gcd (max m n) (min m n))))



(define current-time-end0 (current-inexact-milliseconds))

(gcd-structural 3 5)

(define current-time-end1 (current-inexact-milliseconds))

(gcd-generative 3 5)

(define current-time-end2 (current-inexact-milliseconds))

(- current-time-end1 current-time-end0)
(- current-time-end2 current-time-end1)
