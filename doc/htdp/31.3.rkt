#lang racket
(define (sum lon)
  (pretty-display lon)
  (cond
    [(empty? lon) 0]
    [else (+ (first lon) (sum (rest lon)))]))

(define (sum2 lon)
  (local [(define (sum-local lon acc)
            (pretty-display lon)
            (pretty-display acc)
            (cond
              [(empty? lon) acc]
              [else (sum-local (rest lon) (+ (first lon) acc))]))]
    (sum-local lon 0)))

(sum '(1 2 3 4 5 6 ))
(sum2 '(1 2 3 4 5 6))