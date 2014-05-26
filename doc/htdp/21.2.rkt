#lang racket

;; my-build-list : N (N  ->  X)  ->  (listof X)
;; to construct (list (f 0) ... (f (- n 1)))
(define (my-build-list n f)
  (local
    ((define (loop n f)
       (let* ([i (sub1 n)])
         (cond 
           [(zero? i) (cons (f 0) '())]
           [else (cons (f i) (loop i f))]))))
    (reverse  (loop n f))))

;(my-build-list 3 add1) ; (1 2 3)


;; my-filter : (X  ->  boolean) (listof X)  ->  (listof X)
;; to construct a list from all those items on alox for which p holds 
(define (my-filter p alox)
  (cond
    [(empty? alox) '()]
    [else (if (p (first alox)) 
              (cons (first alox) (my-filter p (rest alox)))
              (my-filter p (rest alox)))]))

;(my-filter (lambda (x) (not (zero? x))) (my-build-list 5 (lambda (x) x)))

;; my-quicksort : (listof X) (X X  ->  boolean)  ->  (listof X)
;; to construct a list from all items on alox in an order according to cmp
(define (partition lst pv cmp)
  (cond
    [(empty? lst) (list '() '() '())]
    [else (let* ([f (first lst)]
                 [recurse (partition (cdr lst) pv cmp)]
                 [middle (second recurse)])
            (cond
              [(cmp f pv)
               (list (cons f (first recurse)) middle (third recurse))]
              [(equal? f pv)
               (list (first recurse) (cons f middle) (third recurse))]
              [else 
               (list (first recurse) middle (cons f (third recurse)))]))]))

(partition '(1 2 3 4 5 4 5 6 5 6 4) 4 >=)

;; cmp cannot contains equality
(define (my-quicksort alox cmp)
  (cond
    [(empty? alox) '()]
    [else (let* ([pvt (list-ref alox (floor (/ (- (length alox) 1) 2)))]
                 [lst-lr (partition alox pvt cmp)])
            ;(printf "pvt:~a, lst-lr:~a\n" pvt lst-lr)
            (append (my-quicksort (first lst-lr) cmp)
                    (second lst-lr)
                    (my-quicksort (third lst-lr) cmp)))]))

(define l (my-build-list 5 (lambda (x) x)))
;(list-ref l (floor (/ (- (length l) 1) 2)))
l
;(my-quicksort (my-build-list 5 (lambda (x) (- 5 x))) <)
(my-quicksort l >)

;; my-map : (X  ->  Y) (listof X)  ->  (listof Y)
;; to construct a list by applying f to each item on alox
;; that is, (my-map f (list x-1 ... x-n)) = (list (f x-1) ... (f x-n))
(define (my-map f alox) 
  (cond
    [(empty? alox) '()]
    [else (cons (f (first alox)) (my-map f (rest alox)))]))

;(my-map add1 (my-build-list 5 values))

;; my-andmap : (X  ->  boolean) (listof X)  ->  boolean
;; to determine whether p holds for every item on alox
;; that is, (my-andmap p (list x-1 ... x-n)) = (and (p x-1) (and ... (p x-n)))
(define (my-andmap p alox) 
  (cond
    [(empty? alox) #t]
    [else (and (p (first alox)) (my-andmap p (rest alox)))]))

;(define l-s (my-build-list 3 (lambda (x) (- x 0))))
(andmap + '(1 2 3) '(2 3 4));(lambda (x) (< x 3)) l-s)

;; my-ormap : (X  ->  boolean) (listof X)  ->  boolean
;; to determine whether p holds for at least one item on alox
;; that is, (my-ormap p (list x-1 ... x-n)) = (or (p x-1) (or ... (p x-n)))
(define (my-ormap p alox) 
  (cond
    [(empty? alox) #f]
    [else (or (p (first alox)) (my-ormap p (rest alox)))]))
;(define l-s (my-build-list 3 (lambda (x) (- x 0))))
;(my-ormap (lambda (x) (< x 3)) l-s)

;; my-foldl : (X Y  ->  Y) Y (listof X)  ->  Y
;; (my-foldl f base (list x-1 ... x-n)) = (f x-n ... (f x-1 base)) 
(define (my-foldl f base alox) 
  (cond
    [(empty? alox) base]
    [else (my-foldl f (f (first alox) base) (rest alox))]))
;(my-foldl cons '() '(1 2 3))

;; my-foldr : (X Y  ->  Y) Y (listof X)  ->  Y
;; (my-foldr f base (list x-1 ... x-n)) = (f x-1 ... (f x-n base)) 
(define (my-foldr f base alox)
  (reverse (my-foldl f base alox)))
;(my-foldr cons '() '(1 2 3))

;; my-assf : (X  ->  boolean) (listof (list X Y))  ->  (list X Y) or false
;; to find the first item on alop for whose first item p? holds
(define (my-assf p? alop)
  (cond
    [(empty? alop) #f]
    [else (if (p? (first (first alop))) 
              (first alop)
              (my-assf p? (rest alop)))]))

;(my-assf boolean? '((1 2) (#t 2) '(4 3)))
