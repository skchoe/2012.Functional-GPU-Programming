#lang racket

;; replace-eol-with : list-of-numbers list-of-numbers  ->  list-of-numbers
;; to construct a new list by replacing empty in alon1 with alon2
(define (replace-eol-with alon1 alon2)
  (cond
    ((empty? alon1) alon2)
    (else (cons (first alon1) (replace-eol-with (rest alon1) alon2)))))

;; hours->wages : list-of-numbers list-of-numbers  ->  list-of-numbers
;; to construct a new list by multiplying the corresponding items on
;; ASSUMPTION: the two lists are of equal length 
;; alon1 and alon2
(define (hours->wages alon1 alon2)
  (cond
    ((empty? alon1) empty)
    (else (cons (weekly-wage (first alon1) (first alon2))
                (hours->wages (rest alon1) (rest alon2))))))

;; weekly-wage : number number  ->  number
;; to compute the weekly wage from pay-rate and hours-worked
(define (weekly-wage pay-rate hours-worked)
  (* pay-rate hours-worked))


;; list-pick : list-of-symbols N[>= 1]  ->  symbol
;; to determine the nth symbol from alos, counting from 1;
;; signals an error if there is no nth item
(define (list-pick alos n)
  (cond
    [(and (= n 1) (empty? alos)) (error 'list-pick "list too short")]
    [(and (> n 1) (empty? alos)) (error 'list-pick "list too short")]
    [(and (= n 1) (cons? alos)) (first alos)]
    [(and (> n 1) (cons? alos)) (list-pick (rest alos) (sub1 n))]))