#lang racket

;; make-possible-divisors
;; N -> list (2 3 4... N-1)
;; 2 -> '()
;; 3 -> '(2)
;; 4 -> '(2 3)
;; 5 -> '(2 3 4)
;; 6 -> '(2 3 4 5)
(define (make-possible-divisors N)

  (cond 
    [(equal? N 2) '()]
    [else (cons (- N 1) (make-possible-divisors (- N 1)))]))
;; lst '(2)
;; '()
(define (function-making-true-false N lst)
  (cond
    [(empty? lst) #t] ;; #t, N is prime
    [(zero? (remainder N (first lst))) #f] ;;; #f means N is not prime
    [else (function-making-true-false N (rest lst))]))
    
(define (prime? N)
  
  (let ([lst (make-possible-divisors 23)])
    ;(first lst)      (first (rest lst)) (first (rest (rest lst)))
    (function-making-true-false N lst)))
           
;(make-possible-divisors 26)
;(prime? 26)

;; 
(define (prime-1-helper N x0)
  (cond 
      [(< x0 N) (if (zero? (remainder N x0)) 
                     #f 
                     (prime-1-helper N (add1 x0)))]
      [else #t]))

(define (prime-1? N)
  (cond 
    [(<= N 1) (error "N need to be bigger than 1")]
    [else (prime-1-helper N 2)]))


(prime-1? 123)
