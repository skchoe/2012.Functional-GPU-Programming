;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |37.3|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(require teachpack/htdp/draw)

;; Data Def.: A TL-color is either 'green, 'yellow, or 'red. 

;; State Variable: 
;; current-color : TL-color
;; to keep track of the current color of the traffic light
(define current-color 'red)

;; Contract: next :  ->  void

;; Purpose: the function always produces (void)

;; Effect: to change current-color from 'green to 'yellow, 
;; 'yellow to 'red, and 'red to 'green

;; Header: omitted for this particular example

;; Examples: 
;; if current-color is 'green and we evaluate (next), then current-color is 'yellow
;; if current-color is 'yellow and we evaluate (next), then current-color is 'red
;; if current-color is 'red and we evaluate (next), then current-color is 'green

;; Template: data-directed on state-variable that is to be mutated
;; (define (f)
;;   (cond
;;     [(symbol=? 'green current-color) (set! current-color ...)]
;;     [(symbol=? 'yellow current-color) (set! current-color ...)]
;;     [(symbol=? 'red current-color) (set! current-color ...)]))

;; Definition:
(define (next)
  (cond
    [(symbol=? 'green current-color) (set! current-color 'yellow)]
    [(symbol=? 'yellow current-color) (set! current-color 'red)]
    [(symbol=? 'red current-color) (set! current-color 'green)]))
  
;; Tests:
(begin (set! current-color 'green) (next) (symbol=? current-color 'yellow))
(begin (set! current-color 'yellow) (next) (symbol=? current-color 'red))
(begin (set! current-color 'red) (next) (symbol=? current-color 'green))


;; switch : N  ->  void
;; effect: switch the traffic light n times, holding each color for 3 seconds
;; structural recursion 
(define (switch n)
  (cond
    [(= n 0) (void)]
    [else (begin (sleep-for-a-while 3)
                 (next)
                 (switch (- n 1)))]))

;; switch-forever :  ->  void
;; effect: switch the traffic light forever, holding each color for 3 seconds
;; generative recursion 
(define (switch-forever)
  (begin (sleep-for-a-while 3)
         (next)
         (switch-forever)))




;; how-many-in-list : (listof X)  ->  N
;; to count how many items alist contains 
(define (how-many-in-list alist)
  (cond
    [(empty? alist) 0]
    [else (+ (how-many-in-list (rest alist)) 1)]))


(how-many-in-list '(1 2 3))