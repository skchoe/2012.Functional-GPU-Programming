#lang scheme
(require scheme/foreign)
(unsafe!)

(provide* (unsafe sine_array))

;; libcada
(define cuda-lib (ffi-lib  "libcuda"))
(let* (
       [sin (get-ffi-obj 'sin
			cuda-lib
			(_cprocedure (list _double)
				     _double)
			(lambda (x) (printf "NOT found\n")))]
       [out-val (sin 1.75)]
       )
  (printf "outval = ~s\n" out-val))


;; libgle
(define value-seT (cvector _float 1.0 100.0))
(define glew-lib (ffi-lib "/home/skchoe/local/glew/lib/libGLEW"))

(let* ([glVertex3f (get-ffi-obj 'glVertex3f
                         glew-lib
                         (_cprocedure (list _float _float _float)
                                     _void)
                         (lambda (x) (printf "NOT found\n"))
                         )]
         [out-valc (glVertex3f 0.1 0.2 0.3)])
    #f
;    (let (;[v1 (make-cvector* out-valc _float 2)])
;  (printf "cvector 0: ~s\n" (cvector-ref out-valc 0))
;  (printf "cvector 1: ~s\n" (cvector-ref out-valc 1))
  )

