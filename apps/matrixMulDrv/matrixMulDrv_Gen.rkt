#lang racket
(require "../../schcuda/ffi-ext.ss"
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss"
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/driver_types_h.ss"
         "../../abscall/kernel-launcher.rkt"
         "../../abscall/dim-rep.rkt" ; _size_type_2 is defined
         "../../schcuda/create-array.rkt"
         "../../sdk-ex/matrixMulDrv/matrixMul_h.rkt" 
         )


(require ffi/unsafe racket/require-syntax)

(define kernel-name #"matrixMul")

(let* (;[current_folder (find-system-path 'home-dir)]
       ;[cubin_path_string (string-append (path->string current_folder) "data/matrixMul_kernel.sm_10.cubin")]
       [cubin_path_string "../../sdk-ex/matrixMulDrv/data/matrixMul_kernel.sm_10.cubin"]
       ;; Loading kernel from ctx->module
       ;; set kernel launch configuration
       [cubin-path (generate-cubin cubin_path_string)]
       [cuDevice (last (suda-init-devices 0))]
       [lst-gpu-info (suda-device-info cuDevice)]) ; num-gpu, name-gpu, compu-cap min, max, glob-mem, maxthread-blk, numthd-x, numthd-y, numthd-z, grid-x, grid-y 

    ;; load kernel function
    (let*-values 
        ([(cuContext l-hfunc) 
          (load-kernel-driver cuDevice cubin-path kernel-name)]
         [(sizeof-float) (compiler-sizeof 'float)]
         [(sizeof-size_type_2) (ctype-sizeof _size_type_2)]
         [(st2_in_0 st2_in_1 st2_out)
          (let* ([BLOCK_SIZE 1]
                 [WA (* 2 BLOCK_SIZE)]
                 [HA WA]
                 [WB (* 4 BLOCK_SIZE)]
                 [HB WA]
                 [WC WB]
                 [HC HA])
            (values (make-size_type_2 WA HA)
                    (make-size_type_2 WB HB)
                    (make-size_type_2 WC HC)))]
         
         ;; input arrays initialization by simple value.
         [(mat_in_0 mat_in_1)
          (let* ([mat_in0 (create-input-array st2_in_0 _float)]
                 [mat_in1 (create-input-array st2_in_1 _float)])
            (values mat_in0 mat_in1))]
         
         
         ;; output values initialization by zero.
         [(mat_out) (create-init-array st2_out _float)]
         
         [(v) (printf "check size_type_2:~a ~a ~a\n" 
                    (size_type_2? (cadr mat_in_0))
                    (size_type_2? (cadr mat_in_1))
                    (size_type_2? (cadr mat_out)))]
         
         [(lst-results)
          (kernel-launcher* lst-gpu-info 
                            (bytes->string/utf-8 kernel-name)
                            (car l-hfunc)
                            "matrixMul_kernel.rkt"
                            cubin-path
                            ; output as a list of locs(for C and size_type_2). size_type_2 gives structure
                            (list mat_out)
                            ;; <cpointer> size <cpointer> size
                            mat_in_0 ; arg for mat A : pointer and value:size_type_2
                            mat_in_1)] ; arg for mat B : pointer and value:size_type_2
         [(result_dt) (cuCtxDetach cuContext)])
      (printf "RESULT:~a\n" lst-results)
      (for-each print-cu-param lst-results)
      (printf "result of CtxDetach:~a\n" result_dt)))
