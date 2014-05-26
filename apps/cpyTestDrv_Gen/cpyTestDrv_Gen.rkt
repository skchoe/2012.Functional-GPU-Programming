#lang racket
(require "../../schcuda/ffi-ext.ss"
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss"
	 "../../schcuda/cuda_h.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/driver_types_h.ss"
         "../../abscall/kernel-launcher.rkt"
         )


(require ffi/unsafe racket/require-syntax)

(define kernel-name #"test_kernel")
(define cubin-path (string->path "../../sdk-ex/cpyTestDrv_Gen/data/test_kernel.sm_10.cubin"))

(let* (;[current_folder (find-system-path 'home-dir)]
       ;[cubin_path_string (string-append (path->string current_folder) "data/cpyTest_kernel.sm_10.cubin")]
       [cubin_path_string "../../sdk-ex/cpyTestDrv_Gen/data/test_kernel.sm_10.cubin"]
       ;; Loading kernel from ctx->module
       ;; set kernel launch configuration
       [cubin-path (generate-cubin cubin_path_string)]
       [cuDevice (last (suda-init-devices 0))]
       [lst-gpu-info (suda-device-info cuDevice)]) ; num-gpu, name-gpu, compu-cap min, max, glob-mem, maxthread-blk, numthd-x, numthd-y, numthd-z, grid-x, grid-y 

    ;; load kernel function
    (let*-values 
        ([(cuContext l-hfunc) 
          (load-kernel-driver cuDevice cubin-path kernel-name)]
         [(num-vec-in-out) 5]
         [(arr_in val_in)
          (values ;; data 1
           ;; Collection type, later on, will use (make-cvector _type length), 
           ;;such as
           (list
            (let* ([count num-vec-in-out]
                   ;; input(sender) for the array of floats
                   [h_array_in 
                    (let* ([vec (malloc _float count)]) 
                      (printf "************cuParamSetv vec:~a   w/size=~a bytes\n" 
                              vec (* count (compiler-sizeof 'float)) )
                      (for ([i (in-range count)])
                        (ptr-set! vec _float i (* (+ i 1) 0.001)));(random)))
                      (print-f64vector-cpointer vec _float count)
                      vec)])
              h_array_in) ; (_pointer, int) represents pointer of array with size.
           num-vec-in-out)
           256)]

         ;; output values initialization by zero.
         [(arr_out val_out)
          (let* ([a0 (malloc (* num-vec-in-out (ctype-sizeof _float)))]
                 [a2 (malloc (ctype-sizeof _int32))])
            (for ([i (in-range num-vec-in-out)]) (ptr-set! a0 _float i 0.0))
            (ptr-set! a2 _int32 0)
            (values (list a0 num-vec-in-out) a2))]
         
         [(lst-results)
          (kernel-launcher* lst-gpu-info 
                            (bytes->string/utf-8 kernel-name) 
                            (car l-hfunc)
                            "sum_kernel.rkt"
                            cubin-path
                            (list arr_out val_out) ;; arr_out = (<cpointer> length), val_out = (<cpointer> 0).
                            arr_in val_in)] ;; arr_in= (<cpointer> length), val_in = integer-value.
         [(result_dt) (cuCtxDetach cuContext)])
      (printf "RESULT:~a\n" lst-results)
      (for-each print-cu-param lst-results)
      ; output - print 
      #;(let loop ([i 0])
        (if (equal? i (cadr arr_out)) 
            (printf "Done\n")
            (begin (printf "AAAAAOUTPUT: A1[~a]: ~a]\n" 'pos (ptr-ref (car arr_out) _float i))
                   (loop (add1 i)))))
      #;(printf "XXXXXOUTPUT: A2: ~a\n" (ptr-ref val_out _int32))
      (printf "result of CtxDetach:~a\n" result_dt)))
