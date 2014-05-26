#lang racket

;; produce #f when the difference is found
(define (our-equal-new? lst1 lst2)
  (cond
    [(and (empty? lst1) (empty? lst2)) #t]
    [(empty? lst1) #f]
    [(empty? lst2) #f]
    [else
     (cond
       [(equal? (first lst1) (first lst2)) 
        (our-equal-new? (rest lst1) (rest lst2))]
       [else #f])]))


(our-equal-new? (list) (list 'a 'b 'c))


(define lst1 (list 'a 'b 'c))
(define lst2 (list 'a 'b 'c))

;; produce #f when the difference is found
(define (lst1-lst2-equal?)
  (cond
    [(and (empty? lst1) (empty? lst2)) #t]
    [(empty? lst1) #f]
    [(empty? lst2) #f]
    [else
     (cond
       [(equal? (first lst1) (first lst2)) 
        (set! lst1 (rest lst1))
        (set! lst2 (rest lst2))
        (lst1-lst2-equal?)]
       [else #f])]))

(lst1-lst2-equal?)