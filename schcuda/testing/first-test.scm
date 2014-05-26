#lang scheme
(require scheme/foreign)
(unsafe!)

;; lib definitions
(define math-lib (ffi-lib  "libm"))
(define cuda-lib (ffi-lib  "libcuda"))
(define cudart-lib (ffi-lib "/home/skchoe"))
(define cufft-lib (ffi-lib "/home/skchoe"))
(define cublas-lib (ffi-lib "/home/skchoe"))
(define glew-lib (ffi-lib "/home/skchoe"))

(let* (
;       [sin (get-ffi-obj 'sin
;                         cuda-lib
;                         (_cprocedure (list _double) _double)
;                         (lambda () (printf "sin NOT found\n")))]
;       [out-val0 (sin 1.75)]
;       
;       [erfc (get-ffi-obj 'erf
;                          cuda-lib
;                          (_cprocedure (list _double) _double)
;                          (lambda () (printf "erf NOT found\n")))]
;       [out-val1 (erfc 0.0)]

       [dvsinf (get-ffi-obj '__sinf
                          math-lib
                          ;cudart-lib
                          (_cprocedure (list _float) _float)
                          (lambda () (printf "__sinf NOT found\n")))]
       )
  (printf "outval = ~s\n" (dvsinf 1.75)))

  (define (unavailable name)
    (lambda ()
      (lambda x
        (error name "unavailable on this system"))))
  
  (define-syntax define-foreign-lib
    (syntax-rules (->)
      ((_ lib name type ... ->)
       (define-foreign-lib lib name type ... -> _void))
      ((_ lib name type ...)
       (begin
         (provide name)
         (define name
           (get-ffi-obj 'name lib (_fun type ...) (unavailable 'name)))))))
  
  (define-foreign-lib glew-lib glGenBuffers (n : _uint32) (r : (_cvector o _uint32 n)) -> _void -> r)

(let* ([gl-gb (glGenBuffers 4)]
       [out-valc_0 (cvector-ref gl-gb 0)]
       [out-valc_1 (cvector-ref gl-gb 1)]
       [out-valc_2 (cvector-ref gl-gb 2)]
       [out-valc_3 (cvector-ref gl-gb 3)])

  (printf "~s ~s ~s ~s\n" out-valc_0 out-valc_1 out-valc_2 out-valc_3)

  )
