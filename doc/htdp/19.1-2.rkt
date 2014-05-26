#lang racket
;;FUNCTIONAL ABSTRACTION
;; contains-doll? : los  ->  boolean
;; to determine whether alos contains 
;; the symbol 'doll
(define (contains-doll? alos)
  (cond
    [(empty? alos) false]
    [else
      (cond
	[(symbol=? (first alos) 'doll)
	 true]
	[else 
	 (contains-doll? (rest alos))])]))

(contains-doll? '(car doll pen paper))

;; contains-car? : los  ->  boolean
;; to determine whether alos contains 
;; the symbol 'car
(define (contains-car? alos)
  (cond
    [(empty? alos) false]
    [else
      (cond
	[(symbol=? (first alos) 'car)
	 true]
	[else 
	 (contains-car? (rest alos))])]))

(contains-car? '(car doll pen paper))


;;------------------>
(define (contains? s alos)
  (local ((define (contains-doll? alos)
  (cond
    [(empty? alos) false]
    [else
      (cond
	[(symbol=? (first alos) 'doll)
	 true]
	[else 
	 (contains-doll? (rest alos))])]))
          
          (define (contains-car? alos)
  (cond
    [(empty? alos) false]
    [else
      (cond
	[(symbol=? (first alos) 'car)
	 true]
	[else 
	 (contains-car? (rest alos))])]))
          )
  (cond
    [(symbol=? s 'doll) (contains-doll? s alos)]
    [(symbol=? s 'car) (contains-car? s alos)]
    [else (error "don't know s")])

(contains? 'doll '(car doll pen paper))
(contains? 'car '(car doll pen paper))
;--------------------------------------------------------------------------------------------
;; data definition similarity - same function struct, differentiate operator as ir<
;; below : number lon  ->  lon
;; to construct a list of those numbers
;; on alon that are below t
(define (below alon t)
  (cond
    [(empty? alon) empty]
    [else (cond
	    [(< (first alon) t)
	     (cons (first alon)
	       (below (rest alon) t))]
	    [else
	      (below (rest alon) t)])]))
(define (above alon t)
  (cond
    [(empty? alon) empty]
    [else (cond
	    [(> (first alon) t)
	     (cons (first alon)
	       (above (rest alon) t))]
	    [else
	      (above (rest alon) t)])]))

(define (filter1 reln-op alon t)
  (cond
    [(empty? alon) empty]
    [else (cond
	    [(reln-op (first alon) t)
	     (cons (first alon)
	       (filter1 (rest alon) t))]
	    [else
	      (filter1 (rest alon) t)])]))


(below '( 23 4 5 6 7 8) 7)
(above '( 23 4 5 6 7 8) 7)
(filter1 equal? '( 23 4 5 6 7 8) 7)


;----
(define-struct ir (name price))
;; below-ir : loIR number ->  loIR
;; to construct a list of those records 
;; on aloir that contain a price below t
(define (below-ir aloir t)
  (cond
    [(empty? aloir) empty]
    [else (cond
	    [(<ir (first aloir) t) 
	     (cons (first aloir)
	      (below-ir (rest aloir) t))]
	    [else
	      (below-ir (rest aloir) t)])]))

;; <ir : IR number  ->  boolean
(define (<ir ir p)
    (< (ir-price ir) p))

;; alox (list of x)(list of x)(list of z) -> list of x
;; x is a struct that have 'price' as field.
(define (below-generic alox aloy aloz t)
  (cond
    [(empty? alox) empty]
    [else (cond
	    [(<ir (first alox) t)
	     (cons (first alox) (below-generic (rest alox) t))]
            [else (below-generic (rest alox) t)])]))

    
(below-generic '(4 7 1 9 5) 7)  
(define l-ir (list (make-ir 'a 4) (make-ir 'b 7) (make-ir 'c 1) (make-ir 'd 9) (make-ir 'e 5)))
(map ir-name (below-generic  l-ir 7))


;; parametric definition
;; length-lon : lon  ->  number
(define (length-lon alon)
  (cond
    [(empty? alon) empty]
    [else 
      (+ (length-lon (rest alon)) 1)]))

(define (length-ir aloir) #f)
(define (length-gen alox) #f)
    
    (define (com? reln-op x y)
  (reln-op x y))


(< 1 2)
(> 1 2)
(equal? 1 2)

(define (a< x y)
 (< x y))

(define (a> x y)
 ( x y))


(com? < 1 2)
(com? > 1 2)
(com? equal? 1 2)