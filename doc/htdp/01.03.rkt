;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01.03|) (read-case-sensitive #t) (teachpacks ((lib "convert.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "convert.ss" "teachpack" "htdp")))))
;; 3.1
#|
(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(define (revenue ticket-price)
  (*  (attendees ticket-price) ticket-price))

(define (cost ticket-price)
  (+ 180 
     (* .04 (attendees ticket-price))))

(define (lower-times difference)
  (/ difference .10))

(define (attendees ticket-price)
  (+ 120
     (* 15 (lower-times (- 5.00 ticket-price)))))

(profit 5.577)
(profit 5)
(profit 1)
(profit 0.999)
|#
; 3.3
#|
English                 	metric
1 inch 				= 	2.54 	cm
1 foot 	= 	12 	in.
1 yard 	= 	3 	ft.
1 rod 	= 	5(1/2) 	yd.
1 furlong 	= 	40 	rd.
1 mile 	= 	8 	fl. 
|#

;; dealer's purchase 
;; car $100
;; 

