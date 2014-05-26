;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |27.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(require htdp/draw)

(define width 500)
(start width width)

(define a (make-posn 0 0))
(define b (make-posn width 0))
(define c (make-posn (/ width 2) width))


;;; posn is a structure (x y)
;; (define-struct posn (x y))
;; a b c : posn
;; -> area : number
(define (area-of-triangle a b c) 
  sldsldjslkfsjldkslfjlsdkfjsl)



(equal? (area-of-triangle a b c) (area-traiangle a b c)) ; #t




;; d0 d1 two directions from origin
(define (area-parallelogram d0 d1)
  (abs (- (* (posn-x d0) (posn-y d1))
          (* (posn-y d0) (posn-x d1)))))
  
;; a b c posn's for positions
(define (area-triangle a b c)
  (let* ([ax (posn-x a)]
         [ay (posn-y a)]
         [bx (posn-x b)]
         [by (posn-y b)]
         [cx (posn-x c)]
         [cy (posn-y c)]
         
         [dir0 (make-posn (- bx ax) (- by ay))]
         [dir1 (make-posn (- cx ax) (- cy ay))])
    (/ (area-parallelogram dir0 dir1) 2.0)))
  
(area-triangle (make-posn 0 0) (make-posn 1 0) (make-posn 1 1))
  
(define (too-small? a b c)
  (if (< (area-triangle a b c) 0.1) #t #f)) 

;; a b c: posn -> boolean
(define (draw-triangle a b c)
  (begin
    (draw-solid-line a b 'red)
    (draw-solid-line b c 'red)

    (draw-solid-line c a 'red)))

;; a b : posn -> a posn in the middle
(define (middle-posn a b)
  (make-posn (/ (+ (posn-x a) (posn-x b)) 2)
             (/ (+ (posn-y a) (posn-y b)) 2)))

;; sierpinski : posn posn posn  ->  true
;; to draw a Sierpinski triangle down at a, b, and c, 
;; assuming it is large enough
(define (sierpinski a b c)
  (cond 
    [(too-small? a b c) #t]
    [else 
     (let ([mab (middle-posn a b)]
            [mbc (middle-posn b c)]
            [mca (middle-posn c a)])
       (and (draw-triangle a b c)
            (sierpinski mab mbc mca)))]))

;(draw-triangle a b c) 
(sierpinski a b c)
   