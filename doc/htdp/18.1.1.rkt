#lang racket
;; pragmatics of local form
;; 1. insertion sort - encapsultaion

(define (mysort lon)
  (cond 
    [(empty? lon) '()]
    [else (insert (first lon) (mysort (rest lon)))]))

(define (insert x lon)
  (cond
    [(empty? lon) (cons x '())]
    [else 
     (cond
       [(< x (first lon)) (cons x lon)]
       [else (cons (first lon) (insert x (rest lon)))])]))

#;(mysort '(2 4 6 3 1))

(define (newsort lon)
  (local
    ((define (insert x lon)
       (cond
         [(empty? lon) (cons x '())]
         [else 
          (cond
            [(< x (first lon)) (cons x lon)]
            [else (cons (first lon) (insert x (rest lon)))])])))
    (cond 
      [(empty? lon) '()]
      [else (insert (first lon) (mysort (rest lon)))])))

#;(newsort '(7 5 6 4 32 5 67 7834))
  
;; ex 2 back-tracking
(define-struct star (name instrument))
(define alos 
  (list (make-star 'Chris 'saxophone)
        (make-star 'Robby 'trumpet)
        (make-star 'Matt 'violin)
        (make-star 'Wen 'guitar)
        (make-star 'Matt 'radio)))

;; last-occurrence : symbol list-of-star  ->  star or false
;; to find the last star record in alostars that contains s in name field
(define (last-occurrence s alostars)
  (cond
    [(empty? alostars) #f]
    [else
     (cond
       [(star? (last-occurrence s (rest alostars))) 
        (last-occurrence s (rest alostars))]
       [(symbol=? s (star-name (first alostars))) (first alostars)]
       [else #f])]))

#;(last-occurrence 'Matt alos)

(define (last-occurrence-local s alostars)
  (cond
    [(empty? alostars) #f]
    [else
     (local [(define r (last-occurrence s (rest alostars)))]
       (cond
         [(star? r) r]
         [(symbol=? s (star-name (first alostars))) (first alostars)]
         [else #f]))]))

#;(last-occurrence-local 'Matt alos)

(define (last-occurrence-for nm alos)
  (local
    [(define star #f)]
    (begin
      (for ([s alos])
        (cond 
          [(symbol=? nm (star-name s)) (set! star s)]))
      star)))

#;(star-instrument (last-occurrence-for 'Matt alos))

;; mult10 : list-of-digits  ->  list-of-numbers
;; to create a list of numbers by multiplying each digit on alod 
;; by (expt 10 p) where p is the number of digits that follow
(define (mult10 alon)
  (cond
    [(empty? alon) '()]
    [else (cons (* (first alon) (expt 10 (length (rest alon))))
                (mult10 (rest alon)))]))

;(mult10 '(2 3 6 8 3 1))

;; a*10^|r|
(define (mult10-local alon)
  (cond
    [(empty? alon) '()]
    [else 
     (local 
       ((define coeff (first alon))
        (define rst (rest alon))
        (define exponent (length rst))
        (define expt10 (expt 10 exponent))
        (define xformed-elt (* coeff expt10)))
       (cons xformed-elt (mult10 (rest alon))))]))

(mult10-local '(2 3 6 8 3 1))
