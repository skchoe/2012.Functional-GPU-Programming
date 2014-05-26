#lang scheme

;// includes, project
;#include <cutil.h> -> all api from this eliminated.
;#include "matrixMul.h"
(require scheme/foreign
         ffi/unsafe
         ffi/unsafe/cvector
         scheme/system
         srfi/25
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/array-utils.ss"
         "../../schcuda/cufft_h.ss"
         
         "../../schcuda/scuda.ss"
         "../../schcuda/vector_types_h.ss")

(unsafe!)
(define SIGNAL_SIZE 50)
(define FILTER_KERNEL_SIZE 11)
(define simpleCUFFTDrv-lib (ffi-lib "libsimple_gold.so"))

(define compute-test
  (get-ffi-obj 'test
               simpleCUFFTDrv-lib
               (_fun (isignal : _int)
                     ;(osignal : (_ptr io _int))
                     -> _int); -> osignal)
               (lambda () (error "test not found\n"))))

(define Convolve
  (get-ffi-obj 'Convolve
               simpleCUFFTDrv-lib
               (_fun (signal : _float2-pointer)
                     (signal_size : _int)
                     (filter_kernel : _float2-pointer)
                     (filter_kernel_size : _int)
                     (filtered_signal : (_ptr o _float2))
                     -> _void -> filtered_signal)
               (lambda () (error "Convolve not found\n"))))

(define (cvector->ptr type cv)
  (let* ([length (cvector-length cv)]
         [ptr (malloc type length)])
    (for ((i (build-list length values)))
      (ptr-set! ptr type i (cvector-ref cv i)))
    ptr))


(define (randomInit size)
  (let* ([arr (make-array (shape 0 size) 0)])
    (for ([i (in-range size)])
      (let* ([val (random)])
        (array-set! arr i val)))
    (printf "~s\n" 0)
    arr))

(define (pointer->list ptr type size)
  (let loop ([i 0]
             [lst '()])
    (if (< i size)
        (loop (add1 i) (append lst (list (ptr-ref ptr type i))))
        lst)))

(define (my-catch-initCUDA status ctx)
  (printf "ERROR-caught: ~s\n" status)
  (let ([result (cuCtxDetach ctx)])
         
    (printf "ERROR-detech-ctxz: ~s\n" result)
  (exit #f)))

#;(define (string->pointer str)
  (let* ([lst (string->list str)]
         [size (length lst)]
         [ptr (malloc size)])
    (for ([i (build-list size values)])
      (printf "~s \t" (list-ref lst i)) 
      (ptr-set! ptr _byte (char->integer (list-ref lst i))))
    (printf "~s\n" 0)
    ptr))

(define (gen-cubin)
  (system "make")
  #"data/simpleCUFFTDrv_kernel.cubin")

(define (initCUDA)
  (let* ([cuDevice (CUT_DEVICE_INIT_DRV)]
         [module_path (gen-cubin)]
         [ftn_name #"ComplexPointwiseMulAndScale"])

    (let-values ([(status ctx) 
                  (cuCtxCreate 0 cuDevice)])

      (printf "1: status(Context Creation) = ~s\n" status)
      (unless (equal? status 'CUDA_SUCCESS)
        (my-catch-initCUDA status ctx))

      (when (equal? module_path 0) (my-catch-initCUDA 'CUDA_ERROR_NOT_FOUND ctx))
     
      (let-values ([(result mod) (cuModuleLoad module_path)])
        (printf "2: status(Module Loading) = ~s\n" result)
        
        ;(cutFree module_path)
        (unless (equal? 'CUDA_SUCCESS status) (my-catch-initCUDA status ctx))

        (let-values ([(result hfunc) 
                      (cuModuleGetFunction
		                     	mod
                                     	ftn_name)])
          (printf "3: status(GetFunction:~s) = ~s, ~s\n" ftn_name hfunc result)
          (unless (equal? 'CUDA_SUCCESS result) (my-catch-initCUDA result ctx))
          (values 'CUDA_SUCCESS hfunc ctx))))))

(define (randomInit-Complex-X v-cpx size)
  (for ([i (in-range size)])
    (let ([cpx (ptr-ref v-cpx _cufftComplex i)]
          [new-cpx (make-float2 (random) 0.0)])
      (ptr-set! cpx _cufftComplex new-cpx)))
  v-cpx)

(define (cast-loc-to-pointer loc tag)
  (let ([ptr (ptr-add #f loc)])
    (cpointer-push-tag! ptr tag)
    ptr))

(define (print-complex-array arr size)
  (printf "--------~s -------------\n" size)
  (for ([i (in-range size)])
    (let ([z (ptr-ref arr _cufftComplex i)])
      (printf "(~s, ~s)\t" (float2-x z) (float2-y z))))
  (printf "\n"))
  
(define (runTest)
  (let-values ([(status ComplexPointwiseMulAndScale ctx) (initCUDA)])
    (printf "runTest 1: ~s\n" status)
    
    (let* ([h_signal_0 (malloc _float2 (* (ctype-sizeof _float2) SIGNAL_SIZE))]
           [h_filter_kernel_0 
            (malloc _cufftComplex (* (ctype-sizeof _cufftComplex) FILTER_KERNEL_SIZE))]
           [h_signal (randomInit-Complex-X h_signal_0 SIGNAL_SIZE)]
           [h_filter_kernel (randomInit-Complex-X h_filter_kernel_0 FILTER_KERNEL_SIZE)])

      (printf "before_padding_h_signal = \n")
      (print-complex-array h_signal SIGNAL_SIZE)
      
      (printf "before_padding_h_filter_kernel = \n")
      (print-complex-array h_filter_kernel FILTER_KERNEL_SIZE)

      ;;PadData, generates new h_padded_signal, h_padded_filter_kernel
      (let*-values ([(h_padded_signal h_padded_filter_kernel new_size)
                     (PadData h_signal SIGNAL_SIZE h_filter_kernel FILTER_KERNEL_SIZE)])

        (printf "newsize = ~s\n" new_size)
        (printf "after_padding_h_signal = \n")
        (print-complex-array h_padded_signal new_size)
        (printf "after_padding_h_filter_kernel = \n")
        (print-complex-array h_padded_filter_kernel new_size)
        
        (let* ([mem_size (* (ctype-sizeof _cufftComplex) new_size)])

          (printf "mem_Size = ~s\n" mem_size)
          
          (let*-values 
              
              ([(result1 d_signal_0) (cuMemAlloc mem_size)]

               [(result2 d_signal_1)
                (cuMemcpyHtoD d_signal_0 h_padded_signal mem_size)]

               
               
               [(result25 d_filter_kernel_0) (cuMemAlloc mem_size)]

               [(result3 d_filter_kernel_1)
                (cuMemcpyHtoD d_filter_kernel_0 h_padded_filter_kernel mem_size)])
            
            (printf "runTest 1: ~s\n" result1)
            (printf "runTest 2: ~s\n" result2)
            (printf "runTest 25: ~s\n" result25)
            (printf "runTest 3: ~s\n" result3)

            (let* ([d_signal_1-ptr (cast-loc-to-pointer d_signal_1 'cufftComplex)]
                   [d_filter_kernel_1-ptr (cast-loc-to-pointer 
                                           d_filter_kernel_1 'cufftComplex)]
                   [z0 (malloc _cufftComplex new_size)])
              
              (printf "new size = ~s\n" new_size)
              
              (let*-values
                  ;;plan
                  ([(result35 plan) (cufftPlan1d new_size 'CUFFT_C2C 1)]
                   
                   ;; EXEC
                   [(result4 d_signal) 
                    (cufftExecC2C plan
                                  d_signal_1-ptr
                                  d_signal_1-ptr
                                  CUFFT_FORWARD)]
#|                   
;                   [(result45 z)
;                    (cuMemcpyDtoH z0 d_signal mem_size)]

                   ;; EXEC
                   [(result5 d_filter_kernel) 
                    (cufftExecC2C plan 
                                  d_filter_kernel_1-ptr
                                  d_filter_kernel_1-ptr
                                  CUFFT_FORWARD)]
|#                   )

;                (printf "plan = ~s, runTest 45: ~s\n" plan result45)
                
;                (for ([i (in-range new_size)])
;                  (let* ([cpx (ptr-ref z _cufftComplex i)])
;                    (printf "d_signal = ~s, ~s\n" (float2-x cpx) (float2-y cpx))))

                (printf "runTest 35: ~s\n" result35)

                (printf "runTest 4: ~s\n" result4)
;                (printf "runTest 5: ~s\n" result5)
                ))
            ))))))
                   
;;               [(result6 ComplexPointwiseMulAndScale) 
;;                (cuFuncSetBlockShape 
;;                 ComplexPointwiseMulAndScale 256 1 1)]
;;               
;;               [(result7 ComplexPointwiseMulAndScale) 
;;                (cuParamSeti ComplexPointwiseMulAndScale 0  d_signal)]
;;               [(result8 ComplexPointwiseMulAndScale) 
;;                (cuParamSeti ComplexPointwiseMulAndScale 4 d_filter_kernel)]
;;               [(result9 ComplexPointwiseMulAndScale) 
;;                (cuParamSeti ComplexPointwiseMulAndScale 8 new_size)]
;;               [(result10 ComplexPointwiseMulAndScale) 
;;                (cuParamSeti ComplexPointwiseMulAndScale 12 (/ 1.0 new_size))]
;;               [(result11 ComplexPointwiseMulAndScale) 
;;                (cuParamSetSize ComplexPointwiseMulAndScale 16)]
;               )
;#f
;;            (printf "Launch `~s\n"
;;                    (cuLaunchGrid ComplexPointwiseMulAndScale 32 1))
;
;;            (printf "runTest 6: ~s\n" result6)
;;            (printf "runTest 7: ~s\n" result7)
;;            (printf "runTest 8: ~s\n" result8)
;;            (printf "runTest 9: ~s\n" result9)
;;            (printf "runTest 10: ~s\n" result10)
;;            (printf "runTest 11: ~s\n" result11)
;
;;            (let*-values ([(result12 d_signal_new) 
;;                           (cufftExecC2C plan d_signal CUFFT_INVERSE)]
;;                          [(result13 h_convolved_signal)
;;                           (cuMemcpyDtoH h_padded_signal d_signal_new mem_size)])
;
;;              (let* ([h_convolved_signal_ref_0 
;;                      (malloc _cufftComplex (* (ctype-sizeof _cufftComplex) SIGNAL_SIZE))]
;;                     [h_convolved_signal_ref 
;;                      (Convolve h_signal SIGNAL_SIZE
;;                                h_filter_kernel FILTER_KERNEL_SIZE
;;                                h_convolved_signal_ref_0)]
;;                     [b (cutCompareL2fe h_convolved_signal_ref
;;                                        h_convolved_signal
;;                                        (* 2 SIGNAL_SIZE)
;;                                        1e-5)])
;;                (if b (printf "PASSED\n") (printf "FAILED\n"))
;;                (cufftDestroy plan)
;
;;                (free h_signal)
;;                (free h_filter_kernel)
;;                (free h_padded_signal)
;;                (free h_padded_filter_kernel)
;;                (free h_convolved_signal_ref)
;;                (cuMemFree d_signal)
;;                (cuMemFree d_filter_kernel))
;;            )
;          ))))))


;// Padding functions
;int PadData(const Complex*, Complex**, int,
;            const Complex*, Complex**, int);

(define (PadData signal signal_size filter_kernel filter_kernel_size)
  (let* ([minRadius (truncate (/ filter_kernel_size 2))]
         [maxRadius (- filter_kernel_size minRadius)]
         [new_size (+ signal_size maxRadius)]
         [new_data_signal (malloc _cufftComplex (* (ctype-sizeof _cufftComplex) new_size))]
         [new_data_filter (malloc _cufftComplex (* (ctype-sizeof _cufftComplex) new_size))])

    (printf "PadData : signal_size = ~s, filter_kernel_size =  ~s,
             minR = ~s, maxR = ~s, new_size = ~s\n" 
            signal_size filter_kernel_size minRadius maxRadius new_size)

    ; Paded signal
    (memcpy new_data_signal 0 signal signal_size _cufftComplex)
    ;(* signal_size (ctype-sizeof _cufftComplex)))
    (memset new_data_signal signal_size 0 (- new_size signal_size) _cufftComplex)
    ; (ctype-sizeof _cufftComplex)))

    ; Paded filter
    (memcpy new_data_filter 0 filter_kernel minRadius maxRadius _cufftComplex)
    ;(* maxRadius (ctype-sizeof _cufftComplex)))
    (memset new_data_filter maxRadius 
            0 (- new_size filter_kernel_size) _cufftComplex)
            ;(* (- new_size filter_kernel_size) (ctype-sizeof _cufftComplex)))
    (memcpy new_data_filter (- new_size minRadius) 
            filter_kernel minRadius _cufftComplex)
    ;(* minRadius (ctype-sizeof _cufftComplex)))

    (values new_data_signal new_data_filter new_size)))

(define (ComplexMul a b) 
  (let* ([ax (float2-x a)] 
         [ay (float2-y a)]
         [bx (float2-x b)]
         [by (float2-y b)]
         [zx (- (* ax bx) (* ay by))]
         [zy (+ (* ax by) (* ay bx))])
    (make-float2 zx zy)))


(runTest)
