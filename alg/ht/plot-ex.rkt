#lang racket
(require plot
         plot/extend)
 
(define (dashed-line fun
                     #:x-min [x-min -5]
                     #:x-max [x-max 5]
                     #:samples [samples 100]
                     #:segments [segments 20]
                     #:color [color 'red]
                     #:width [width 1])
  (let* ((dash-size (/ (- x-max x-min) segments))
         (x-lists (build-list
                   (/ segments 2)
                   (lambda (index)
                     (x-values
                      (/ samples segments)
                      (+ x-min (* 2 index dash-size))
                      (+ x-min (* (add1 (* 2 index))
                         dash-size)))))))
    (lambda (2dview)
      (send 2dview set-line-color color)
      (send 2dview set-line-width width)
      (for-each
       (lambda (dash)
         (send 2dview plot-line
               (map (lambda (x) (vector x (fun x))) dash)))
       x-lists))))
;Plot a test case using dashed-line:

(plot (dashed-line (lambda (x) x) #:color 'blue))