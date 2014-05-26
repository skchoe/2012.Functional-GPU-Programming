#lang racket
(define ex1 '( 1 3 5 7 8 5 3 10 334 45 67 78 5 2 6 9))

;; sort: data -> data
;; data is sorted list
;; insert x into data with the comparison operator, comp_op (<=, <, equal?, >, or >=)
(define (insert x data comp_op)
  (cond
    [(empty? data) (cons x empty)]
    [else 
     (cond
       [(comp_op x (first data)) (cons x data)]
       [else (cons (first data) (insert x (rest data) comp_op))])]))

(insert 4 '() <=)
(insert 5 '() > )
;; insertion-sort: sort data by comp_op.
(define (insertion-sort data comp_op)
  (cond 
    [(empty? data) data]
    [else 
     (insert (first data) (insertion-sort (rest data) comp_op) comp_op)]))

(insertion-sort '( 9 7 5 4 2 1) <=)
(insertion-sort '( 9 7 5 4 2 1) >)
(insertion-sort ex1 <=)
(insertion-sort ex1 >)