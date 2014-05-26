;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 01-06) (read-case-sensitive #t) (teachpacks ((lib "draw.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "draw.ss" "teachpack" "htdp")))))
(start 200 200)
(draw-solid-line (make-posn 200 0) (make-posn 0 200) 'red)

(define-struct circle (posn radius))
(make-circle (make-posn 0 0) 1)
(draw-circle (make-posn 100 100) 10 'red)
#;(define (clear-circle cl)
  (draw-circle (make-circle
                (circle-posn cl)
                (circle-radius cl))
               'white))
(sleep-for-a-while 5)
(clear-circle (make-posn 100 100) 10)
;(define (fun-for-circle circles)

(define (sq x) (* x x))
;; cl:circle
;; p :posn
(define (in-circle? cl p)
  (let* ([cx (posn-x (circle-posn cl))]
         [cy (posn-y (circle-posn cl))]
         
         [r (circle-radius cl)]
         
         [px (posn-x p)]
         [py (posn-y p)]
         
         [d (sqrt (+ (sq (- px cx))
                     (sq (- py cy))))])
    (if (< d r) #f #t)))

(define (translate-circle cl delta)
  (let* ([org (circle-posn cl)]
         [new-org (make-posn 
                   (+ delta (posn-x org))
                   (posn-y org))])
    (make-circle new-org (circle-radius cl))))

(translate-circle (make-circle (make-posn 1 1) 2) 4)

(define (draw-and-clear-circle cl)
  (draw-circle cl))

(define (move-circle delta a-circle)
  (cond
    [(draw-and-clear-circle a-circle) (translate-circle a-circle delta)]
    [else a-circle]))