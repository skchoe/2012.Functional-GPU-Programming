;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |18.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
#|
<def> = (define <var> <exp>)
	(define (var var ...) exp)
(define-struct var (var ...))

<exp>  = (local (<def> ... <def>) exp)
|#

(local (;; f: locally defined function
        (define (f x) 
          ;; right hand exp
          (+ x 5))
        
        ;; g : locally defined function
        (define (g alon)
          ;; right-hand exp
          (cond
            [(empty? alon) empty]
            [else (cons (f (first alon)) (g (rest alon)))])))
  
  ;; body
  (g (list 1 2 3)))

;; Semantics
#|
def-1 ... def-n 
   E[(local ((define (f-1 x) exp-1) ... (define (f-n x) exp-n)) exp)] 
= 
   def-1 ... def-n (define (f-1' x) exp-1') ... (define (f-n' x) exp-n') 
   E[exp']   ----------evaluation context E.
|#
(+ (local ((define (f x) 10)) (f 13)) 5)
;; exp = (local ((define (f x) 10)) (f 13))
;;   E = (+ ... 5)

;;
;; top-level lifting(?) - eliminating name clash
(define y 10)
(+ y 
   (local ((define y 10)
	   (define z (+ y y)))
     z))
;; same - how about lifting twice?
(define (D x y)
    (local ((define x2 (* x x))
	    (define y2 (* y y)))
      (sqrt (+ x2 y2))))
  (+ (D 0 1) (D 3 4))
  
;; why good? (1) - encapsulation by goal
  ; (sort alon), (insert n alon) ; increasing/decreasing

;; why good? (2) - The dual-use of the natural recursion 
  ; (occurence-at-last name star)
  ;; last-occurrence : symbol list-of-star  ->  star or false
;; to find the last star record in alostars that contains s in name field
(define (last-occurrence s alostars)
  (cond
    [(empty? alostars) false]
    [else (local ((define r (last-occurrence s (rest alostars))))
            (cond
              [(star? r) r]
              [(symbol=? (star-name (first alostars)) s) (first alostars)]
              [else false]))]))

;; why good? (2) -   when a value is computed twice 
;; mult10 : list-of-digits  ->  list-of-numbers
;; to create a list of numbers by multiplying each digit on alod 
;; by (expt 10 p) where p is the number of digits that follow
(define (mult10 alon) #f)
  