(module load-cuda-rapi scheme
(require scheme/foreign
         "cuda-type.ss")
  
(unsafe!)
  
(define cuda-lib (ffi-lib  "libcuda"))
(define cudart-lib (ffi-lib "libcudart"))
(define cufft-lib (ffi-lib "libcufft"))
(define cublas-lib (ffi-lib "libcublas"))
(define glew-lib (ffi-lib "libGLEW"))
                                       
(define  (get-ffi-obj 'cuCtxCreate
                          cuda-lib
                          (_cprocedure (list _float) _float)
                          (lambda () (printf "__sinf NOT found\n"))))
       
)
