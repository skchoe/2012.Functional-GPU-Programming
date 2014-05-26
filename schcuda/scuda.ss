(module scuda scheme
(require scheme/foreign
	 scheme/system         
         "ffi-ext.ss"
         "cutil_h.ss"
         "cuda_h.ss"
         "cudaGL_h.ss"
         "cuda_gl_interop_h.ss"
         "vector_types_h.ss"
         "cuda_runtime_api_h.ss"
         "gl-1.5.ss"
         "glew_h.ss"
         "cutil_gl_error_h.ss")

(unsafe!)
(provide (all-defined-out))

;; (values result cuCtx cuFunction)
(define (load-kernel-driver cuDevice cubin-path-string . l-func-name)
  (printf "-------------------loading module, kernel---------------\n")
  (printf "input module_path-string: ~a\n" cubin-path-string)
  (printf "cuDevice = ~a\n" cuDevice)

  (let*-values (;[(module_path) (string->path cubin-path-string)]
                ;[(cubin-path) (string->path (string-append (path->string (current-directory)) module_path_string))]
                [(resultc cuContext) (cuCtxCreate 0 cuDevice)])
    (if (not (equal? resultc 'CUDA_SUCCESS))
        (begin (cuCtxDetach cuContext)
               (printf "Context Creation Error: ~s\n" resultc)
               (values resultc #f #f))
        (begin
          (printf "cuCtxCreate: ~a w/ Module = ~a, is-string?:~a\n" resultc cubin-path-string (string? cubin-path-string))
          #;(if (path? cubin-path-string) 
              (printf "Right path format\n") (printf "module_path is not path form\n"))
          #;(if (file-exists? cubin-path-string) 
              (printf "Module found\n") (printf "Module not found\n"))
          (let*-values 
              ([(resultm cuModule) (cuModuleLoad cubin-path-string)])
            (printf "Module loading from cubin:~a--->>~a\n" cubin-path-string resultm)
            (if (not (equal? resultm 'CUDA_SUCCESS))
                (begin (cuCtxDetach cuContext) 
                       (error "Module Loading Fail w/error:(1) in (2)\n" resultm cubin-path-string)
                       (values resultm cuContext #f))
                (let* ([l-cuFunction
                        (map (λ (cu-module func-name)
                               (let-values ([(resultf cuFunction) 
                                             (cuModuleGetFunction cu-module func-name)])
                                 (printf "Fetching kernel function : ~a(~a)\n" func-name resultf)
                                 (if (not (equal? resultf 'CUDA_SUCCESS))
                                     (begin (cuCtxDetach cuContext)
                                            (error "Fail to get function w/error\n")
                                            (values resultf #f))
                                     (begin (printf "Function(~a) loading:~a\n" func-name resultf)
                                            cuFunction))))
                             (build-list (length l-func-name) (λ (x) cuModule))
                             l-func-name)])
                      (begin (printf "CtxCreation: ~s\n" resultc)
                             (printf "ModuleLoad: ~s\n" resultm)
                             (values cuContext l-cuFunction)))))))))
  
(define (load-kernel-runtime module_path . l-func-name)
  (printf "-------------------loading module, kernel---------------\n") 

  (let*-values ([(resultm cuModule) (cuModuleLoad module_path)]
                [(l-cuFunction)
                 (map (λ (cu-module func-name)
                        (let-values ([(resultf cuFunction) 
                                      (cuModuleGetFunction cu-module func-name)])
                          (if (not (equal? resultf 'CUDA_SUCCESS))
                              (error "Fail to get function w/error:~a\n" resultf)
                              cuFunction)))
                      (build-list (length l-func-name) (λ (x) cuModule)) l-func-name)])
    #;(printf "* module-path loading: ~a --> ~a\n" module_path resultm)
    #;(printf "* kernel-loading     : ~a --> ~a\n" func-name resultf)
    (if (not (equal? resultm 'CUDA_SUCCESS))
        (begin 
          (error "---> Module Loading fails:\n")
          '())
        l-cuFunction)))

(define (load-module-driver cuDevice module_path)
  #;(printf "MODULE_PATH=~s\n" module_path)
  (let*-values ([(resultc cuContext) (cuCtxCreate 0 cuDevice)])
    (if (not (equal? resultc 'CUDA_SUCCESS))
        (begin (cuCtxDetach cuContext) 
               (printf "Context Creation Error: ~s\n" resultc)
               (values #f #f))
        (begin
          #;(printf "cuXtx init successful w/ Module = ~s\n" module_path)
          (let*-values ([(resultm cuModule) (cuModuleLoad module_path)])

            (if (not (equal? resultm 'CUDA_SUCCESS))
                (begin 
                  (error "Either Module Loading fails:\n")
                  #f)
                (begin #;(printf "ModuleLoad: ~s\n" resultm)
                       cuModule)))))))
  
(define (load-module-runtime module_path)
  #;(printf "MODULE_PATH=~s\n" module_path)
  
  (let*-values ([(resultm cuModule) (cuModuleLoad module_path)])
    
    (if (not (equal? resultm 'CUDA_SUCCESS))
        (begin 
          (printf "scuda: Either Module Loading fails:~s ~s\n" module_path resultm)
          #f)
        (begin #;(printf "ModuleLoad: ~s\n" resultm)
               cuModule))))
  
(define (suda-init-devices num)
  (let* ([resulti (cuInit num)])
    #;(printf "-----------------------init----------------------\n")
    (if (equal? resulti 'CUDA_SUCCESS)
        (begin
          #;(printf "cuda-init-device(cuInit) = ~s\n" resulti)
          (let*-values ([(resultc devCnt) (cuDeviceGetCount)])
            #;(printf "cuda-init-device(# dev) = ~s\n" devCnt)
            (if (equal? devCnt 0)
                (begin
                  (error "cutil error: no device supporting CUDA\n")
                  '())
                (for/fold ([lst-dev '()])
                  ([i (in-range devCnt)])
                  
                  (let*-values ([(resultd cuDevice) (cuDeviceGet i)])
                    #;(printf "cuda-init-device(dev id) = ~s\n" cuDevice)
                    #;(suda-device-info cuDevice)
                    (cons cuDevice lst-dev))))))
        (begin 
          (error "cuda-init-device -- failed\n")
          '()))))
  
(define (suda-device-info cuDevice)
  (let*-values 
      ([(rc cnt) (cuDeviceGetCount)]
       [(rn name) (cuDeviceGetName 20 cuDevice)]
       [(rp min max) (cuDeviceComputeCapability cuDevice)]
       [(rm mem) (cuDeviceTotalMem cuDevice)]
       [(rt prop) (cuDeviceGetProperties cuDevice)]
       [(thr-blk) (CUdevprop-maxThreadsPerBlock prop)]) 
    (printf "**********device information)**************\n")
    (printf "* # of device = ~s\n" cnt)
    (printf "* Name: ~s\n" name)
    (printf "* min/max compute capability = (~s, ~s)\n" min max)
    (printf "* Total memory(byte) = ~s\n" mem)
    (printf "* Property - Max Thread per block(#): ~s\n" thr-blk)
    (let* ([off-x (CUdevprop-maxThreadsDimX prop)]
	   [off-y (CUdevprop-maxThreadsDimY prop)]
	   [off-z (CUdevprop-maxThreadsDimZ prop)]
           [mg-x (CUdevprop-maxGridSizeX prop)]
	   [mg-y (CUdevprop-maxGridSizeY prop)]
           [sm (CUdevprop-sharedMemPerBlock prop)]
           [cm (CUdevprop-totalConstantMemory prop)]
           [swidth (CUdevprop-SIMDWidth prop)]
           [mem-pth (CUdevprop-memPitch prop)]
           [reg (CUdevprop-regsPerBlock prop)])
      (printf "* MAX thd 0: ~a\n" off-x)
      (printf "* MAX thd 1: ~a\n" off-y)
      (printf "* MAX thd 2: ~a\n" off-z)
      (printf "* Property - Max Grid Dim(#) : (~s, ~s)\n" mg-x mg-y)
      (printf "* Property - Shared Memory per block(MB): ~s\n" sm)
      (printf "* Property - Total Constant memory(MB): ~s\n" cm)
      (printf "* Property - SIMDWidth(MB): ~s\n" swidth)
      (printf "* Property - memPitch(MB): ~s\n" mem-pth)
      (printf "* Property - regsPerBlock(MB): ~s\n" reg)
      (printf "* Property - clockRate(Hz): ~s\n" (CUdevprop-clockRate prop))
      (printf "* Property - textureAlign(MB): ~s\n" (CUdevprop-textureAlign prop))
      (printf "****************************************\n")
      
      ; num-gpu, name-gpu, compu-cap min, max, glob-mem, maxthread-blk, numthd-x, numthd-y, numthd-z, grid-x, grid-y 
      (list cnt name min max mem thr-blk off-x off-y off-z mg-x mg-y))))
   
(define (get-max-thread-per-block cu-device)
  (let*-values ([(rt prop) (cuDeviceGetProperties cu-device)])
    (CUdevprop-maxThreadsPerBlock prop)))
  
(define (get-block-dimension cu-device)
  (let*-values ([(rt prop) (cuDeviceGetProperties cu-device)])
    (values (CUdevprop-maxThreadsDimX prop) (CUdevprop-maxThreadsDimY prop) (CUdevprop-maxThreadsDimZ prop))))
  
(define (get-grid-dimension cu-device)
  (let*-values ([(rt prop) (cuDeviceGetProperties cu-device)])
    (values (CUdevprop-maxGridSizeX prop) (CUdevprop-maxGridSizeY prop))))

  
; to positioning offset well in case of vector type argument in cuParamsetv().
(define (align-up offset alignment)
  (bitwise-and (+ offset (- alignment 1)) (bitwise-not (- alignment 1))))
  
;(offsets-ctype (list _uint _int _float _float _int16))
;(offsets-csym (list 'float 'char 'short 'int 'void '* 'double))
  
  (define (print-f64vector v count)
    (for ([idx (in-range count)])
      (printf "<~a>=~a\t" idx (f64vector-ref v idx)))
    (newline))
  
  (define (print-f64vector-cpointer vp type count)
    (for ([idx (in-range count)])
      (printf "(~a)=~s\t" idx (ptr-ref vp type idx)))
    (newline))


(define (string->pointer str)
  (let* ([lst (string->list str)]
         [size (length lst)]
         [ptr (malloc size)])
    (for ([i (build-list size values)])
      (ptr-set! ptr _byte (char->integer (list-ref lst i))))
    ptr)))
