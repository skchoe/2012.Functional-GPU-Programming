#lang scheme

(require scheme/foreign
         "../../schcuda/ffi-ext.ss"
         "../../schcuda/scuda.ss"
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/driver_types_h.ss")

(unsafe!)



(define (alloc-and-launch hfunc)
  #f)


(define (main)
  (let* ([kernel-name #"cpyTest"]
         ;; Loading kernel from ctx->module
         ;; set kernel launch configuration
         [cubin-path (generate-cubin #"data/cpyTest_kernel.cubin")]
         [cuDevice (last (suda-init-devices 0))])
      ;; load kernel function
      (let*-values ([(status cuContext l-hfunc) 
                     (load-kernel-driver cuDevice cubin-path kernel-name)])
        (alloc-and-launch (car l-hfunc))
        (cuCtxDetach cuContext)
        )))

(main)
