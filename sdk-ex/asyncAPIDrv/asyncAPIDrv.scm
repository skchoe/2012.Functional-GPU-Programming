#lang scheme
(require scheme/foreign
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss"
         "../../schcuda/ffi-ext.ss"
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/driver_types_h.ss")

(unsafe!)

(define (correct_output ptr-data n x)
  (let loop ([count 0])
    (if (< count n)
        (let* ([elt (ptr-ref ptr-data _int count)])
          (if (not (equal? elt x)) 0 (loop (add1 count))))
        1)))

(define (alloc-and-launch hfunc)
  (let* ([n (* 1024 (* 1024 16))]
         [nbytes (* n (ctype-sizeof _int))]
         [value 26])
    (let*-values 
        (;allocate host memory    
         [(resulth h_a) (cuMemAllocHost nbytes)]
         ;host memory for receiving data
         [(result_hA h_A) (begin
                            (memset h_a 0 nbytes) 
                            (cuMemAllocHost nbytes))]
         [(result_hoN h_oN) (begin
                              (memset h_A 0 nbytes)
                              (cuMemAllocHost (ctype-sizeof _int)))]
         [(v) (memset h_oN 0 (ctype-sizeof _int))]
         
         ;; stream creation
         [(result_sc strm) (cuStreamCreate 0)]
      
         
         
         ;; allocate device memory
         [(resultc d_a) (cuMemAlloc nbytes)]
         [(results d_a) (cuMemsetD32 d_a 255 n)]
         
         [(resultoc do_a) (cuMemAlloc nbytes)]
         [(resultoc1 do_a) (cuMemsetD32 do_a 255 n)]
         
         [(resulton o_n) (cuMemAlloc (ctype-sizeof _int))]
         [(resulton1 o_n) (cuMemsetD32 o_n 0 1)])
      (printf "cudaMemset result = ~s\n" results)
      
      
      
      (printf "pointer printing ~s\n" h_a)
      ;; create cuda event handles
      (let*-values 
          ([(resultt start) (begin (printf "*************\n")
                                  (cuEventCreate 0))]
           [(resultp stop) (cuEventCreate 0)]
           [(v) (cuCtxSynchronize)]
           [(resultrr start) (cuEventRecord start #f)]
           
           ;; memcpy input to device.
           [(resulta d_a) (cuMemcpyHtoDAsync d_a h_a nbytes #f)]
           
           [(offset) 0]
           [(sizeof-ptr) (compiler-sizeof '*)]
           [(alignof-ptr) (ctype-alignof _pointer)]
           [(sizeof-int) (compiler-sizeof 'int)]
           [(alignof-int) (ctype-alignof _int)]
           [(v) (printf "sizeof_ptr=~a, alignof_ptr=~a\n" sizeof-ptr alignof-ptr)]
           
           [(result0 hfunc) (cuParamSeti hfunc offset d_a)]
           [(offset-out) (+ offset sizeof-ptr)]
           
           [(offset) (align-up offset-out alignof-int)]
           [(result1 hfunc) (cuParamSeti hfunc offset n)]
           [(offset-out) (+ offset sizeof-int)]
           
           [(offset) (align-up offset-out alignof-ptr)]
           [(result2 hfunc) (cuParamSetv hfunc offset do_a sizeof-ptr)]
           [(offset-out) (+ offset sizeof-ptr)]
           
           [(offset) (align-up offset-out alignof-ptr)]
           [(result3 hfunc) (cuParamSetv hfunc offset o_n sizeof-ptr)]
           [(offset-out) (+ offset sizeof-ptr)]

           [(offset) (align-up offset-out alignof-int)]
           [(result4 hfunc) (cuParamSeti hfunc offset value)]
           [(offset-out) (+ offset sizeof-int)]
           
           [(result5 hfunc) (cuParamSetSize hfunc offset-out)]
           [(v) (printf "func call offsets    = ~s ~s \n" offset offset-out)]
            
           [(block-sizex) 512]
           [(grid-w) (/ n block-sizex)]
           [(grid-h) 1]
           
           
           ;increment_kernel<<<blocks, threads, 0, 0>>>(d_a, value);
           [(resultb hfunc)
            (cuFuncSetBlockShape hfunc block-sizex 1 1)]
            
           [(resultl) (cuLaunchGrid hfunc grid-w grid-h)]
           [(v) (printf "RESULT(cuLaunchGrid):~s\n" resultl)]

           ;; return from call of kernel
           [(resultca h_na) (cuMemcpyDtoHAsync h_A do_a nbytes strm)]
           
           [(resultcb h_N) (cuMemcpyDtoHAsync h_oN o_n sizeof-int strm)]
           [(resultsp stop) (cuEventRecord stop strm)])
        
        
        ;; have CPU do some work while waiting for stage 1 to finish 
        (let ([counter (let loop ([cnt 0])
                         (if (equal? (cuEventQuery stop) 'CUDA_ERROR_NOT_READY)
                             (begin #;(printf ">") (loop (add1 cnt)))
                             cnt))])
          (printf "Result of EventQuery: ~s\n" (cuEventQuery stop))
          (let-values ([(resultet gpu_time) 
                        (cuEventElapsedTime start stop)])
            
            (cuStreamSynchronize strm)
            
            (printf "record stop:~a, ~a\n" resultsp stop)
            (printf "returned sizeof array:~a\n" (ptr-ref h_N _int))
            (printf "Event(stop) record started = ~s\n" resultsp)
            ;(printf "STOP Really event is on = ~s\n" (cuEventQuery stop))
            

            ;; print cpu and gpu times
            (printf "time spent executing by the GPU ~s\n" gpu_time)
            ;(printf "time spent by CPU in CUDA calls: ~s\n"  (cutGetTimerValue timer))
            (printf "CPU executed ~s iterations while waiting for GPU to finish\n" counter)
            
            (printf "---------------------------------------------------\n")
            (if (equal? 1 (correct_output h_na n value))
                (printf "Test PASSED\n");
                (printf "Test Failed\n"))))
        
        ;; release resources
        (cuStreamDestroy strm)
        
        (cuEventDestroy start)
        (cuEventDestroy stop)
        (cuMemFreeHost h_a)
        (cuMemFreeHost h_A)
        (cuMemFreeHost h_oN)
        (cuMemFree d_a)
        (cuMemFree do_a)
        (cuMemFree o_n)))))
         
(define (main)
  (let* ([kernel-name #"increment_kernel"]
         ;; Loading kernel from ctx->module
         ;; set kernel launch configuration
         [cubin-path (generate-cubin "data/asyncAPIDrv.sm_10.cubin")]
         [lst-dev (suda-init-devices 0)]
         [cuDevice (last lst-dev)])
    ;; load kernel function
    (printf "suda-init-device-done:~a\n" cuDevice)
    (let*-values ([(cuContext l-hfunc) 
                   (load-kernel-driver cuDevice cubin-path kernel-name)])
      (alloc-and-launch (car l-hfunc))
      (cuCtxDetach cuContext))))

(main)
