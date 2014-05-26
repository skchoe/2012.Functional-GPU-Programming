;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 01.06.7) (read-case-sensitive #t) (teachpacks ((lib "draw.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "draw.ss" "teachpack" "htdp")))))
(start 300 600)

(define-struct circle (posn radius color))

(define (draw-noose)
  (begin
    (draw-solid-line (make-posn 0 100) (make-posn 150 100) 'black)
    (draw-solid-line (make-posn 150 100) (make-posn 150 150) 'black)
    (draw-circle (make-posn 150 200) 50 'red)))

(define (draw-head)
  (draw-circle (make-posn 150 240) 10 'green))

(define (draw-left-arm)
  (draw-solid-line (make-posn 100 300) (make-posn 150 250) 'green))
(define (draw-right-arm)
  (draw-solid-line (make-posn 200 300) (make-posn 150 250) 'green))
(define (draw-body)
  (draw-solid-line (make-posn 150 250) (make-posn 150 350) 'green))
(define (draw-left-leg)
  (draw-solid-line (make-posn 100 550) (make-posn 150 350) 'green))
(define (draw-right-leg)
  (draw-solid-line (make-posn 200 550) (make-posn 150 350) 'green))

(draw-noose)
(draw-head)
(draw-left-arm)
(draw-right-arm)
(draw-body)
(draw-left-leg)
(draw-right-leg)

(define (draw-next-part part)
  (cond
    [(symbol=? part 'right-leg) #t]
    [(symbol=? part 'left-leg) #t]
    [(symbol=? part 'right-arm) #t]
    [(symbol=? part 'left-arm) #t]
    [(symbol=? part 'body) #t]
    [(symbol=? part 'head) #t]
    [(symbol=? part 'noose) #t]))


(sleep-for-a-while 5)
(stop)