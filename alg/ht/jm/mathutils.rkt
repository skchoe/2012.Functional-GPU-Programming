;; newer version 
#lang racket

(provide (all-defined-out))


;; list of numbers -> number
;; find average of the numbers in list
(define (average-of-list lst)
  (/ (apply + lst) (length lst)))



;; list of numbers -> number
;; find maximum number from the numbers in the list
(define (max-in-list list)
  (cond
    [(empty? (rest list)) (first list)]
    [else (local ((define m (max-in-list (rest list))))
            (cond
              [(empty? list) empty]
              [(> (first list) m) (first list)]
              [(> m (first (rest list))) m]
              [else (first (rest list))]))]))

;; list of numbers -> number
;; find variance of elements in the list

(define (variance lst)
  (let* ([len (length lst)]
         [mu (/ (apply + lst) len)]
         [seq (map (λ (x) (/ x len)) (map sqr (map (λ (x) (- x mu)) lst)))])
    (apply + seq)))


(variance '(1 2 1 2 1 2))

;; list-of-number -> mean value
;; output number or #f
(define (mean-of-list lst)
  (cond
    [(empty? lst) #f]
    [else
     (let* ([len (length lst)]
            [i (floor (/ len 2))]
            [l-sorted (sort lst <)])
       (list-ref l-sorted i))]))

;; list-of-length -> mu max variance
(define (mu-max-variance lol)
  (let* ([mu (average-of-list lol)]
         [mx (max-in-list lol)]
         [v (variance lol)])
    (values mu mx v)))

