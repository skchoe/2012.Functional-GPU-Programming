#lang scheme

;// includes, project
;#include <cutil.h> -> all api from this eliminated.
;#include "matrixMul.h"
(require scheme/foreign
         scheme/system
         srfi/25
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/array-utils.ss"
         
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss"
         "../../schcuda/ffi-ext.ss"
         
         "../../schcuda/my-racket.rkt"
         
         "../../abscall/dim-rep.rkt"

         "matrixMul_h.rkt")

(unsafe!)
(define computeGold
  (get-ffi-obj 'computeGold 
               (ffi-lib "libmatrixMul_gold")
               (_fun ;(C : (_cvector o _float size))
                     ;(size : _uint)
                     (C : _pointer)
                     _pointer _pointer
                     _int _int _int
                     -> _void -> C)
               (lambda () (error "computeGold not found\n"))))

(define (randomInit size)
  (let* ([arr (make-array (shape 0 size) 0)])
    (for ([i (in-range size)])
      (let* ([val (* 0.1 (+ 1.0 i))]);(random)])
        (array-set! arr i val)))
    arr))

(define (my-catch-initCUDA status ctx)
  (printf "ERROR-caught: ~s\n" status)
  (let ([result (cuCtxDetach ctx)])
         
  (printf "ERROR-detech-ctxz: ~s\n" result)
  (exit #f)))

(define (alloc-and-launch matrixMul)
  ;; Data initialization
  (let* ([_float-size 4] ; 4 bytes for float type
         [mem_size_st2 (ctype-sizeof _size_type_2)]
         
         [size_A (* WA HA)]
         [mem_size_A (* _float-size size_A)]
         [h_pA (array1d->_pointer (randomInit size_A) _float)]
         
         [h_psA (make-size_type_2 WA HA)]
         
         [size_B (* WB HB)]
         [mem_size_B (* _float-size size_B)]
         [h_pB (array1d->_pointer (randomInit size_B) _float)]
         
         [h_psB (make-size_type_2 WB HB)])
    
    (for ([i (in-range size_A)])
      (printf "A: (~a) = ~a\n" i (ptr-ref h_pA _float i)))
    (for ([j (in-range size_B)])
      (printf "B: (~a) = ~a\n" j (ptr-ref h_pB _float j)))
    
    ;; GPU Allocation, Copy
    (let*-values 
        ([(resultA d_A) (cuMemAlloc mem_size_A)]
         [(resultCA da) (cuMemcpyHtoD d_A h_pA mem_size_A)]

         [(resultSA d_sA) (cuMemAlloc mem_size_st2) ]
         [(resultCSA dsa) (cuMemcpyHtoD d_sA h_psA mem_size_st2)]

         [(resultB d_B) (cuMemAlloc mem_size_B)]
         [(resultCB db) (cuMemcpyHtoD d_B h_pB mem_size_B)]
         
         [(resultSA d_sB) (cuMemAlloc mem_size_st2) ]
         [(resultCSB dsb) (cuMemcpyHtoD d_sB h_psB mem_size_st2)]
         
         [(size_C) (* WC HC)]
         [(mem_size_C) (* _float-size size_C)]
         
         [(resultC dc) (cuMemAlloc mem_size_C)]
         [(resultCSC dsc) (cuMemAlloc mem_size_st2)]
      
         [(v) (begin
                (printf "mem-alloc size A:~a, B:~a, C:~a\n" 
                        mem_size_A mem_size_B mem_size_C)
                (printf "resultA = ~s\n" resultA)
                (printf "resultB = ~s\n" resultB)
                (printf "resultCA = ~s\n" resultCA)
                (printf "resultCB = ~s\n" resultCB))]
                
         ;; Parameter setting to kernel
         [(offset-out) 0]
         [(sizeof-ptr) (compiler-sizeof '*)]
         [(alignof-ptr) (ctype-alignof _pointer)]
         [(sizeof-int) (compiler-sizeof 'int)]
         [(alignof-int) (ctype-alignof _int)]
         [(v) (printf "sizeof_ptr=~a, alignof_ptr=~a\n" 
                      sizeof-ptr alignof-ptr)]
         ;; d_A
         [(offset) (align-up offset-out alignof-ptr)]
         [(result3 matrixMul) 
          (cuParamSetv matrixMul offset da sizeof-ptr)]
         [(offset-out) (+ offset sizeof-ptr)]
         
         ;; d_sA
         [(offset) (align-up offset-out alignof-ptr)]
         [(result4 matrixMul) 
          (cuParamSetv matrixMul offset dsa sizeof-ptr)]
         [(offset-out) (+ offset sizeof-ptr)]
         
         ;; d_B
         [(offset) (align-up offset-out alignof-ptr)]
         [(result5 matrixMul) 
          (cuParamSetv matrixMul offset db sizeof-ptr)]
          ;(cuParamSeti matrixMul offset db)]
         [(offset-out) (+ offset sizeof-ptr)]
         
         ;; d_sB
         [(offset) (align-up offset-out alignof-ptr)]
         [(result6 matrixMul) 
          (cuParamSetv matrixMul offset dsb sizeof-ptr)]
         [(offset-out) (+ offset sizeof-ptr)]
         
         ;; d_C
         [(offset) (align-up offset-out alignof-ptr)]
         [(result7 matrixMul) 
          (cuParamSetv matrixMul offset dc sizeof-ptr)]
          ;(cuParamSeti matrixMul offset dc)]
         [(offset-out) (+ offset sizeof-ptr)]
         
         ;; d_sC
         [(offset) (align-up offset-out alignof-ptr)]
         [(result8 matrixMul) 
          (cuParamSetv matrixMul offset dsc sizeof-ptr)]
         [(offset-out) (+ offset sizeof-ptr)]
         
         [(result9 matrixMul) 
          (cuParamSetSize matrixMul offset-out)]
         
         [(result10 matrixMul) 
          (cuFuncSetBlockShape 
           matrixMul BLOCK_SIZE BLOCK_SIZE 1)]
         [(result11 matrixMul) 
          (cuFuncSetSharedSize 
           matrixMul (* 2 BLOCK_SIZE BLOCK_SIZE _float-size))])
      
      (printf "Launch ~s\n"
              (cuLaunchGrid matrixMul (/ WC BLOCK_SIZE) (/ HC BLOCK_SIZE)))
      
      #;(printf "launch-param-pass-runTest 1: ~s\n" result1)
      #;(printf "launch-param-pass-runTest 2: ~s\n" result2)
      (printf "launch-param-pass-runTest 3: ~s\n" result3)
      (printf "launch-param-pass-runTest 4: ~s\n" result4)
      (printf "launch-param-pass-runTest 5: ~s\n" result5)
      (printf "launch-param-pass-runTest 6: ~s\n" result6)
      (printf "launch-param-pass-runTest 7: ~s\n" result7)
      (printf "launch-param-pass-runTest 8: ~s\n" result8)
      (printf "launch-param-pass-runTest 9: ~s\n" result9)
      (printf "launch-param-pass-runTest 10: ~s\n" result10)
      (printf "launch-param-pass-runTest 11: ~s\n" result11)
      #;(printf "launch-param-pass-runTest 12: ~s\n" result12)
      
      (let*-values ; copy result from device to host
          ([(h_pC) (malloc mem_size_C)]
           [(h_psC) (make-size_type_2 WC HC)]
           [(resultC gv-ptr) (cuMemcpyDtoH 
                              h_pC dc mem_size_C)]
           [(resultCs gv-st2-ptr) (cuMemcpyDtoH 
                                   h_psC dsc mem_size_st2)]
           
           [(ref) (malloc mem_size_C)]
           [(reference) (computeGold ref h_pA h_pB HA WA WB)])
        
        (printf "Cpy result to host = ~a, ~a\n" resultC resultCs)
        (for/list ([j (build-list size_C values)])
          (let ([value (ptr-ref reference _float j)])
            (when (>= value 1.0e-3)
              (printf "~s: gold Result: ~s\n" j value))))
        
        (printf "GPURESLT = \n~s\n" 
                (pointer->list gv-ptr _float size_C))
        (printf "ANSWER = \n~s\n" 
                (pointer->list reference _float size_C))
        
        (let* ([error (cutCompareL2fe reference gv-ptr size_C 1.0e-6)])
          (if error (printf "SUCCESS\n") (printf "FAIL\n"))))
      
      (printf "cuMemFree 10: ~s\n" (cuMemFree da))
      (printf "cuMemFree 21: ~s\n" (cuMemFree db))
      (printf "cuMemFree 31: ~s\n" (cuMemFree dc))
      (printf "cuMemFree 11: ~s\n" (cuMemFree dsa))
      (printf "cuMemFree 21: ~s\n" (cuMemFree dsb))
      (printf "cuMemFree 31: ~s\n" (cuMemFree dsc)))))

(define (main)
  (let* ([kernel-name #"matrixMul"]
         ;; Loading kernel from ctx->module
         ;; set kernel launch configuration
         [cubin-path (generate-cubin "data/matrixMul_kernel.sm_10.cubin")]
         [lst-dev (suda-init-devices 0)]
         [cuDevice (last lst-dev)])
    ;; load kernel function
    (printf "suda-init-device-done:~a\n" cuDevice)
    (let*-values ([(cuContext l-hfunc) 
                   (load-kernel-driver cuDevice cubin-path kernel-name)])
      (alloc-and-launch (car l-hfunc))
      (cuCtxDetach cuContext))))

(main)
