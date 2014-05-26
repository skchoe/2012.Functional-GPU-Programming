;#lang scheme
(module example0 scheme

(require "../schcuda/vector_types_h.ss")


(define int_def 100)
(define float_def 0.001)

(define blockIdx (make-int2 0 0))
(define blockDim (make-int2 0 0))
(define threadIdx (make-int2 0 0))

;(if (int2? (make-int2 1 0)) (printf "INT2 TYPE\n") (printf "NOT INT2 TYPE\n"))

(define kernel 
  (lambda (pos width height time)
  (let* ([x (+ (* (int2-x blockDim) (int2-x blockIdx)) 
	       (int2-x threadIdx))]
	 [y (+ (* (int2-y blockDim) (int2-y blockIdx)) 
	       (int2-y threadIdx))]
	 [i (+ (* y width) x)]

	 [u (- (* 2.0 (/ x width)) 1.0)]
	 [v (- (* 2.0 (/ y width)) 1.0)]
	 [freq 5.0]
	 [w (* (+ (sin (+ (* u freq) time))
		  (cos (+ (* v freq) time)))
	       0.5)])

    (vector-set! pos i (make-float4 u v w 1.0))
    pos)))
  
  )
