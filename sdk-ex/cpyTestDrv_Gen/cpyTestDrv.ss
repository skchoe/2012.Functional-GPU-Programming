#lang scheme

(require scheme/foreign
         "../../schcuda/ffi-ext.ss"
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss"
	 "../../schcuda/cuda_h.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/driver_types_h.ss"
         "alloc-launch.rkt")

(unsafe!)

(define kernel_name #"test_kernel")
(define (main)
  (let* (;[current_folder (find-system-path 'home-dir)]
         ;[cubin_path_string (string-append (path->string current_folder) "data/cpyTest_kernel.sm_10.cubin")]
         ;; Loading kernel from ctx->module
         ;; set kernel launch configuration
         [cubin-path (generate-cubin "data/test_kernel.sm_10.cubin")]; bytes type if there's '#' infront of string.
         [cuDevice (last (suda-init-devices 0))])

    ;; load kernel function
    (let*-values ([(cuContext l-hfunc) 
                   (load-kernel-driver cuDevice cubin-path kernel_name)])
      (alloc-and-launch (car l-hfunc))
      (cuCtxDetach cuContext))))

(main)
