;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |27|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
 ;; sierpinski : posn posn posn  ->  true
;; to draw a Sierpinski triangle down at a, b, and c,
;; assuming it is large enough
(define (sierpinski a b c)
  (cond
    [(too-small? a b c) true]
    [else 
      (local ((define a-b (mid-point a b))
	      (define b-c (mid-point b c))
	      (define c-a (mid-point a c)))
	(and
	  (draw-triangle a b c)	    
	  (sierpinski a a-b c-a)
	  (sierpinski b a-b b-c)
	  (sierpinski c c-a b-c)))]))

;; mid-point : posn posn  ->  posn
;; to compute the mid-point between a-posn and b-posn
(define (mid-point a-posn b-posn)
  (make-posn
    (mid (posn-x a-posn) (posn-x b-posn))
    (mid (posn-y a-posn) (posn-y b-posn))))

;; mid : number number  ->  number
;; to compute the average of x and y
(define (mid x y)
  (/ (+ x y) 2))

;; file->list-of-lines : file  ->  (listof (listof symbol))
;; to convert a file into a list of lines 
(define (file->list-of-lines afile)
  (cond
    [(empty? afile) empty]
    [else
      (cons (first-line afile)
	    (file->list-of-lines (remove-first-line afile)))]))

;; first-line : file  ->  (listof symbol)
;; to compute the prefix of afile up to the first occurrence of NEWLINE
(define (first-line afile)
  (cond
    [(empty? afile) empty]
    [else (cond
	    [(symbol=? (first afile) NEWLINE) empty]
	    [else (cons (first afile) (first-line (rest afile)))])]))

;; remove-first-line : file  ->  (listof symbol)
;; to compute the suffix of afile behind the first occurrence of NEWLINE
(define (remove-first-line afile)
  (cond
    [(empty? afile) empty]
    [else (cond
	    [(symbol=? (first afile) NEWLINE) (rest afile)]
	    [else (remove-first-line (rest afile))])]))

(define NEWLINE 'NL)

 ;; find-root : (number  ->  number) number number  ->  number
;; to determine a number R such that f has a 
;; root between R and (+ R TOLERANCE) 
;; 
;; ASSUMPTION: f is continuous and monotonic
(define (find-root f left right)
  (cond
    [(<= (- right left) TOLERANCE) left]
    [else 
      (local ((define mid (/ (+ left right) 2)))
	(cond
	  [(<= (f mid) 0 (f right)) 
           (find-root mid right)]
	  [else 
           (find-root left mid)]))]))