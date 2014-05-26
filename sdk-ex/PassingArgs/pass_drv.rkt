#lang racket
(require ffi/unsafe
         "../../schcuda/cuda_h.ss"
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss")

(define NUM_IN_ARG 9)
(define BLOCK_SIZE_X NUM_IN_ARG);(+ 10 num_var))
(define BLOCK_SIZE_Y 1);(+ 10 num_uconst))
(define BLOCK_SIZE_Z 1)
(define GRID_SIZE 1)

(let* ([cubin-path (generate-cubin "data/pass_kernel.cubin")]
       [cuDevice (last (suda-init-devices 0))] ; we support single GPU now.
       [kernel-name #"pass_kernel"])
  (let*-values 
      ([(cuContext l-hfunc) (load-kernel-driver cuDevice cubin-path kernel-name)]
       [(kernel-func) (car l-hfunc)]
       
       ;; sizeof types
       [(sizeof-ptr) (compiler-sizeof '*)]
       [(alignof-int) (ctype-alignof _int)]
       [(alignof-ptr) (ctype-alignof _pointer)]
       [(mem-size) (* (ctype-sizeof _int) NUM_IN_ARG)]
       [(offset)
        (for/fold 
            ;; starting offset
            ([offset 0])
          ([i (in-range NUM_IN_ARG)])
          ; (1) input size 1 - num_var of d_ht-const
          (let*-values ([(offset-new) (align-up offset alignof-int)]
                        [(result_m init_constraints_kernel) (cuParamSeti kernel-func offset-new i)]
                        [(result0 free0 total0) (cuMemGetInfo)])
            (printf "Algn(int(~a),ptr(~a)), CUMemGetInfo (~a)= r:~a, fr:~a tot:~a, __ _offset-old:~a, offset-new:~a-----> result:~a\n" 
                    alignof-int alignof-ptr i result0 free0 total0 offset offset-new result_m)
            (+ offset-new (ctype-sizeof _int))))]
       
       
       [(result_v d_return_values) (cuMemAlloc mem-size)]
       [(result_v1 d_return_values) (cuMemsetD32 d_return_values (char->integer #\A) mem-size)]
       
       [(offset) (align-up offset alignof-ptr)]
       [(result_l kernel-func) (cuParamSetv kernel-func offset d_return_values sizeof-ptr)]
       [(result0 free0 total0) (cuMemGetInfo)]
       [(v) (printf "CUMemGetInfo (array)= r:~a, fr:~a tot:~a\n" result0 free0 total0)]
       [(offset) (+ offset sizeof-ptr)]
       
       [(result_w d_return_N) (cuMemAlloc (ctype-sizeof _int))]
       [(offset) (align-up offset alignof-ptr)]
       [(result_2 kernel-func) (cuParamSetv kernel-func offset d_return_N sizeof-ptr)]
       [(v) (printf "return value= result_2:~a, result_w:~a\n" result_2 result_w)]
       [(offset) (+ offset sizeof-ptr)]
       
       [(result_n kernel-func) (cuParamSetSize kernel-func offset)]
       
       [(result_b kernel-func)
        (begin (printf "offset- after align0up:~a\n" offset)
               (cuFuncSetBlockShape kernel-func BLOCK_SIZE_X BLOCK_SIZE_Y BLOCK_SIZE_Z))]

       [(result0 free0 total0) (cuMemGetInfo)]
       [(v) (printf "CUMemGetInfo (beforelaunch)= r:~a, fr:~a tot:~a\n" result0 free0 total0)]
       [(result_o) (begin
                     (printf "finaloffset:~a\n" offset)
                     (cuLaunchGrid kernel-func GRID_SIZE GRID_SIZE))]
       
       [(h_return_values) (malloc mem-size)]
       [(result_cpy h_return_values) (cuMemcpyDtoH h_return_values d_return_values mem-size)]
       [(result_free) (cuMemFree d_return_values)]
       
       [(h_return_N) (malloc (ctype-sizeof _int))]
       [(return_cpy_N h_return_N) (cuMemcpyDtoH h_return_N d_return_N (ctype-sizeof _int))]
       [(result_free) (cuMemFree d_return_N)])
    
    (printf "results b:~a, n:~a o:~a, cpy:~a, free:~a\n" result_b result_n result_o result_cpy result_free)
    (for ([i (in-range NUM_IN_ARG)])
      (printf "cpy:~a, free:~a, value(~a):~a\n" result_cpy result_free i (ptr-ref h_return_values _uint i)))
    (printf "return_N:~a\n" (ptr-ref h_return_N _int))
    
    (cuCtxDetach cuContext)))
