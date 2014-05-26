;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 01.06.6) (read-case-sensitive #t) (teachpacks ((lib "draw.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "draw.ss" "teachpack" "htdp")))))

(start 200 400)
;(draw-solid-line (make-posn 200 0) (make-posn 0 200) 'red)

(define-struct circle (posn radius color))
(define cc0 (make-circle (make-posn 100 100) 10 'red))

(define (draw-a-circle cc)
  (begin
    (draw-circle (circle-posn cc)
                 (circle-radius cc)
                 (circle-color cc))
    cc))

;(draw-a-circle cc0)

;; template for fun-for-circle
#;(define (fun-for-circle cc)
  (circle-posn cc)
  (circle-radius cc)
  (circle-color cc) ...)

(define (clear-a-circle cl)
  (draw-circle (circle-posn cl)
               (circle-radius cl)
               'white))

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
    (make-circle new-org (circle-radius cl) (circle-color cl))))

;(translate-circle cc0 4)

(define (draw-and-clear-circle cl)
  (begin
    (draw-a-circle cl)
    (sleep-for-a-while 0.5)
    (clear-a-circle cl)))

;(draw-and-clear-circle cc0)


;; dist circle -> new-circle
(define (move-circle delta a-circle)
  (cond
    [(draw-and-clear-circle a-circle) 
     (translate-circle a-circle delta)]
    [else a-circle]))

(define last-circle 
  (draw-a-circle (move-circle 10 (move-circle 10 (move-circle 10 (move-circle 10 (move-circle 10 (move-circle 10 cc0))))))))
(clear-a-circle last-circle)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-struct rectangle (posn w h c))
(define (draw-a-rectangle rec)
  (draw-solid-rect (rectangle-posn rec)
                  (rectangle-w rec)
                  (rectangle-h rec)
                  (rectangle-c rec)))

(define rt0 (make-rectangle (circle-posn last-circle) 10 10 'blue))
;(draw-a-rectangle rt0)
 
  
;; rectangle, position -> true/false
(define (in-rectangle? rect pos)
  (let ([x (posn-x pos)]
        [y (posn-y pos)]
        [minx (posn-x (rectangle-posn rect))]
        [miny (posn-y (rectangle-posn rect))]
        [w (rectangle-w rect)]
        [h (rectangle-h rect)])

    (if (and
         (and (< x (+ minx w)) (< minx x))
         (and (< y (+ miny h)) (< miny y))) #t #f)))

(define (translate-rectangle rect delta )
  (let* ([pn (rectangle-posn rect)])
    (make-rectangle (make-posn (+ delta (posn-x pn))
                               (posn-x pn))
                    (rectangle-w rect)
                    (rectangle-h rect)
                    (rectangle-c rect))))

(define (clear-a-rectangle rect)
  (draw-a-rectangle
   (make-rectangle (rectangle-posn rect)
                   (rectangle-w rect)
                   (rectangle-h rect)
                   'white)))

(define (draw-and-clear-rectangle rect)
  (begin
    (draw-a-rectangle rect)
    (sleep-for-a-while 0.5)
    (clear-a-rectangle rect)))

;; move-rectangle : number rectangle -> rectangle
;; to draw and clear a rectangle, translate it by delta pixels 
(define (move-rectangle delta a-rectangle) 
  (cond 
    [(draw-and-clear-rectangle a-rectangle) 
     (translate-rectangle a-rectangle delta)] 
    [else a-rectangle])) 

(draw-a-rectangle (move-rectangle -10 (move-rectangle -10 (move-rectangle -10 (move-rectangle -10 (move-rectangle -10 (move-rectangle -10 rt0)))))))

(stop)