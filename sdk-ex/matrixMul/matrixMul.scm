#lang scheme
  
(require scheme/foreign
         scheme/system
         srfi/25
         "../../schcuda/ffi-ext.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/array-utils.ss"
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/vector_types_h.ss"
         "matrixMul_h.scm")
(unsafe!)
(define computeGold
  (get-ffi-obj 'computeGold 
               (ffi-lib "libmatrixMul_gold")
               (_fun (C : _pointer)
                     _pointer _pointer
                     _int _int _int
                     -> _void
                     -> C)
               (lambda () (error "computeGold not found\n"))))  

(define (randomInit size)
  (let* ([arr (make-array (shape 0 size) 0)])
    (for ([i (in-range size)])
      (let* ([val (random)])
        (array-set! arr i val)))
    arr))

(define (gen-cubin)
  (system "make")
  "data/matrixMul.sm_10.cubin")

(define (my-catch-initCUDA status ctx)
  (printf "ERROR-caught: ~s\n" status)
  (let ([result (cuCtxDetach ctx)])
         
  (printf "ERROR-detech-ctxz: ~s\n" result)
  (exit #f)))

(define (initCUDA)
  (let* ([cuDevice (CUT_DEVICE_INIT_DRV)]
         [module_path (gen-cubin)]
         [ftn_name #"matrixMul"])

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
  
(define (print-array addr size type)
  (let loop ([counter 0])
    (if (equal? counter size)
        (begin 
          (printf "\n")
          addr)
        (begin
          (printf "~s\t" (ptr-ref addr type counter))
          (loop (add1 counter))))))
             
;             
;(define (runTest)
;  (let*-values ([(status matrixMul ctx) (initCUDA)])
;    (printf "runTest 1: ~s\n" status)
;    (let* (
;         [_float-size (ctype-sizeof _float)]
;         [_pointer-size (ctype-sizeof _pointer)]
;         
;         ; ready for mem allocation for operands
;         [size_A (* WA HA)]
;         [mem_size_A (* _float-size size_A)]
;         ;[h_pA (malloc _pointer size_A 'raw)]
;         
;;         [size_B (* WB HB)]
;;         [mem_size_B (* _float-size size_B)]
;;         ;[h_pB (malloc _pointer size_B 'raw)]
;;
;;         ; ready for mem alloc for result
;;         [size_C (* WC HC)]
;;         [mem_size_C (* _float-size size_C)]
;;         [mem_size_pC (* _pointer-size size_C)]
;;         [h_pC (malloc _pointer size_C 'raw)]
;;         ;[h_pC (malloc _float size_C 'raw)]
;;         
;;         [lst-offs (offsets-ctype (list _uint _uint _uint _long _long))]
;;         
;;         [h_pA (array1d->_pointer (randomInit size_A) _float)]
;;         [h_pB (array1d->_pointer (randomInit size_B) _float)]
;         )
;      
;;      (printf "BEGIN-cudaMalloc/Free testing\n")
;;      (let-values ([(a b) (cudaMalloc (malloc 1 _float) mem_size_A)])
;;        (printf "TempFree = ~s\n" (cudaFree b)))
;;      (printf "END\nMemcpyTest\n")
;;      (print-array h_pAtmp size_A _float)
;;      (printf "End MemcpyTest\n")
;      #f
;;      ;malloc on device, copy hot to device, get kernel and apply
;;      (let*-values (
;;#|                    
;;            [(resultA d_pA) (cudaMalloc #|(malloc 1 _float)|# mem_size_A)]
;;            [(resultDA da) (begin
;;                             (printf "resultA = ~s\n" resultA)
;;                             (cudaMemcpy d_pA h_pA mem_size_A
;;                                       'cudaMemcpyHostToDevice))]
;;            
;;            [(resultB d_pB) (cudaMalloc #|(malloc 1 _float)|# mem_size_B)]
;;            [(resultDB db) (begin
;;                             (printf "resultB = ~s\n" resultB)
;;                             (cudaMemcpy d_pB h_pB mem_size_B
;;                                       'cudaMemcpyHostToDevice))]
;;|#
;;            [(resultC d_pC) (cudaMalloc #|(malloc 1 _float)|# mem_size_C)]
;;
;;            
;;            ;;function call
;;            [(result1 matrixMul) (begin
;;                                   (printf "resultC = ~s\n" resultC)
;;                                   (cuFuncSetBlockShape 
;;                                  matrixMul BLOCK_SIZE BLOCK_SIZE 1))] 
;;
;;            [(result2 matrixMul) (cuFuncSetSharedSize 
;;                                  matrixMul (* 64 BLOCK_SIZE BLOCK_SIZE _float-size))]
;;
;;            [(result3 matrixMul)  (cuParamSetv matrixMul 0 h_pC size_C)]
;;
;;            [(result4 matrixMul) (begin
;;                                   (printf "result of paramset C = ~s\n" result3)
;;                                   (cuParamSetv matrixMul size_C h_pA size_A))]
;;            [(result5 matrixMul) (begin
;;                                   (printf "result of paramset A = ~s\n" result4)
;;                                   (cuParamSetv matrixMul (+ size_C size_A) h_pB size_B))]
;;            [(result6 matrixMul) (begin
;;                                   (printf "result of paramset B = ~s ~s\n" result5 size_B)
;;                                   (cuParamSeti matrixMul (+ size_C size_A size_B) WA))]
;;            
;;            [(result7 matrixMul) (begin
;;                                   (printf "result of paramset WA = ~s\n" result6)
;;                                   (cuParamSeti matrixMul (+ size_C size_A size_B 4) WB))]
;;            
;;            [(result8 matrixMul) (begin
;;                                   (printf "result of paramset WB = ~s\n" result7)
;;                                   (cuParamSetSize matrixMul (+ size_C size_A size_B 8)))]
;;)
;;        
;;        (printf "Launch NOW: ~s\n"
;;                (cuLaunchGrid matrixMul (/ WC BLOCK_SIZE) (/ HC BLOCK_SIZE)))
;;#|
;;        (printf "cudaFreeA: ~s\n" (cudaFree d_pA))
;;        (printf "cudaFreeB: ~s\n" (cudaFree d_pB))
;;|#
;;
;;;        (for ([i (in-range size_C)])
;;;          (let* ([
;;        (let-values ([(result gv-ptr) (cudaMemcpy h_pC d_pC mem_size_C
;;                                                  'cudaMemcpyDeviceToHost)])
;;          (let* ([ref (malloc _float size_C 'raw)]
;;                 [reference (computeGold ref h_pA h_pB HA WA WB)])
;;            
;;            (let* ([error (cutCompareL2fe reference gv-ptr mem_size_C 1.0e-6)])
;;              (if error (printf "SUCCESS\n") (printf "FAIL\n")))
;;            
;;            (free h_pA)
;;            (free h_pB)
;;            (free h_pC)
;;            (free ref)
;;            
;;))
;
;  )
;(runTest)

(initCUDA)
