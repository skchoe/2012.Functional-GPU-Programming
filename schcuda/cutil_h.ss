(module cutil_h scheme

(require scheme/foreign
         "cuda-libs.ss"
         "cuda_h.ss")

(provide (all-defined-out))
(unsafe!)
#|  
////////////////////////////////////////////////////////////////////////////
//! CUT bool type
////////////////////////////////////////////////////////////////////////////
    enum CUTBoolean 
    {
        CUTFalse = 0,
        CUTTrue = 1
    };
|#
(define CUTFalse #f)
(define CUTTrue #t)

#|
#if __DEVICE_EMULATION__
    // Interface for bank conflict checker
#define CUT_BANK_CHECKER( array, index)                                      \
    (cutCheckBankAccess( threadIdx.x, threadIdx.y, threadIdx.z, blockDim.x,  \
    blockDim.y, blockDim.z,                                                  \
    __FILE__, __LINE__, #array, index ),                                     \
    array[index])
#else
#define CUT_BANK_CHECKER( array, index)  array[index]
#endif
|#
  
  
#|  
(define (CUT_BANK_CHECKER emu array index)
  (if emu
    (cutCheckBankAccess (thread ...)
    (list-ref array index)))


#  define CU_SAFE_CALL_NO_SYNC( call ) do {                                  \
    CUresult err = call;                                                     \ 
    if( CUDA_SUCCESS != err) {                                               \
        fprintf(stderr, "Cuda driver error %x in file '%s' in line %i.\n",   \
                err, __FILE__, __LINE__ );                                   \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CU_SAFE_CALL( call ) do {                                          \
    CU_SAFE_CALL_NO_SYNC(call);                                              \
    CUresult err = cuCtxSynchronize();                                       \
    if( CUDA_SUCCESS != err) {                                               \
        fprintf(stderr, "Cuda driver error %x in file '%s' in line %i.\n",   \
                err, __FILE__, __LINE__ );                                   \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUDA_SAFE_CALL_NO_SYNC( call) do {                                 \
    cudaError err = call;                                                    \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString( err) );              \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUDA_SAFE_CALL( call) do {                                         \
    CUDA_SAFE_CALL_NO_SYNC(call);                                            \
    cudaError err = cudaThreadSynchronize();                                 \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString( err) );              \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUFFT_SAFE_CALL( call) do {                                        \
    cufftResult err = call;                                                  \
    if( CUFFT_SUCCESS != err) {                                              \
        fprintf(stderr, "CUFFT error in file '%s' in line %i.\n",            \
                __FILE__, __LINE__);                                         \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUT_SAFE_CALL( call)                                               \
    if( CUTTrue != call) {                                                   \
        fprintf(stderr, "Cut error in file '%s' in line %i.\n",              \
                __FILE__, __LINE__);                                         \
        exit(EXIT_FAILURE);                                                  \
    } 

    //! Check for CUDA error
#  define CUT_CHECK_ERROR(errorMessage) do {                                 \
    cudaError_t err = cudaGetLastError();                                    \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error: %s in file '%s' in line %i : %s.\n",    \
                errorMessage, __FILE__, __LINE__, cudaGetErrorString( err) );\
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    err = cudaThreadSynchronize();                                           \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error: %s in file '%s' in line %i : %s.\n",    \
                errorMessage, __FILE__, __LINE__, cudaGetErrorString( err) );\
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

    //! Check for malloc error
#  define CUT_SAFE_MALLOC( mallocCall ) do{                                  \
    if( !(mallocCall)) {                                                     \
        fprintf(stderr, "Host malloc failure in file '%s' in line %i\n",     \
                __FILE__, __LINE__);                                         \
        exit(EXIT_FAILURE);                                                  \
    } } while(0);

    //! Check if conditon is true (flexible assert)
#  define CUT_CONDITION( val)                                                \
    if( CUTFalse == cutCheckCondition( val, __FILE__, __LINE__)) {           \
        exit(EXIT_FAILURE);                                                  \
    }

#else  // not DEBUG

#define CUT_BANK_CHECKER( array, index)  array[index]

    // void macros for performance reasons
#  define CUT_CHECK_ERROR(errorMessage)
#  define CUT_CHECK_ERROR_GL()
#  define CUT_CONDITION( val) 
#  define CU_SAFE_CALL_NO_SYNC( call) call
#  define CU_SAFE_CALL( call) call
#  define CUDA_SAFE_CALL_NO_SYNC( call) call
#  define CUDA_SAFE_CALL( call) call
#  define CUT_SAFE_CALL( call) call
#  define CUFFT_SAFE_CALL( call) call
#  define CUT_SAFE_MALLOC( mallocCall ) mallocCall

#endif
|#
  
(define (CU_SAFE_CALL_NO_SYNC call) call)
(define (CU_SAFE_CALL call) (CU_SAFE_CALL_NO_SYNC call))


#|
#if __DEVICE_EMULATION__

#  define CUT_DEVICE_INIT()

#else
#  define CUT_DEVICE_INIT() do {                                             \
    int deviceCount;                                                         \
    CUDA_SAFE_CALL_NO_SYNC(cudaGetDeviceCount(&deviceCount));                \
    if (deviceCount == 0) {                                                  \
        fprintf(stderr, "There is no device.\n");                            \
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    int dev;                                                                 \
    for (dev = 0; dev < deviceCount; ++dev) {                                \
        cudaDeviceProp deviceProp;                                           \
        CUDA_SAFE_CALL_NO_SYNC(cudaGetDeviceProperties(&deviceProp, dev));   \
        if (deviceProp.major >= 1)                                           \
            break;                                                           \
    }                                                                        \
    if (dev == deviceCount) {                                                \
        fprintf(stderr, "There is no device supporting CUDA.\n");            \
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    else                                                                     \
        CUDA_SAFE_CALL(cudaSetDevice(dev));                                  \
} while (0)

#endif
|#
(define (CUT_DEVICE_INIT) #t)

  
#|
#  define CUT_DEVICE_INIT_DRV(cuDevice) do {                                 \
    cuDevice = 0;                                                            \
    int deviceCount = 0;                                                     \
    CUresult err = cuInit(0);                                                \
    if (CUDA_SUCCESS == err)                                                 \
        CU_SAFE_CALL_NO_SYNC(cuDeviceGetCount(&deviceCount));                \
    if (deviceCount == 0) {                                                  \
        fprintf(stderr, "There is no device.\n");                            \
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    int dev;                                                                 \
    for (dev = 0; dev < deviceCount; ++dev) {                                \
        int major, minor;                                                    \
        CU_SAFE_CALL_NO_SYNC(cuDeviceComputeCapability(&major, &minor, dev));\
        if (major >= 1)                                                      \
            break;                                                           \
    }                                                                        \
    if (dev == deviceCount) {                                                \
        fprintf(stderr, "There is no device supporting CUDA.\n");            \
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    else                                                                     \
        CU_SAFE_CALL_NO_SYNC(cuDeviceGet(&cuDevice, dev));                   \
} while (0)
|#

(define checkDeviceComputeCapability-major
  (lambda (dev)
	(let-values ([(result major minor)
            ;(CU_SAFE_CALL_NO_SYNC (cuDeviceComputeCapability major minor dev))
            (cuDeviceComputeCapability dev)])
	major)))
      
; input: none
; output: or cuDevice
(define (CUT_DEVICE_INIT_DRV)
  (unless (equal? 'CUDA_SUCCESS (cuInit 0)) (exit #t))
    
  (let ([count (malloc _int 1)])
    (let-values ([(status deviceCount) (cuDeviceGetCount)])
	;(CU_SAFE_CALL_NO_SYNC (cuDeviceGetCount count))
      	
        (when (equal? deviceCount 0)
          (begin (error "There is no device. \n") (exit #t)))
        
        (for/first ([dev (build-list deviceCount values)]
                    #:when (if (>= (checkDeviceComputeCapability-major dev) 1)
                               #t #f))
          (if (equal? dev deviceCount)
              (begin (error "There is no device supporting CUDA.\n") 
		     (exit #t))
	      (let-values ([(result device) 
;             	            (CU_SAFE_CALL_NO_SYNC (cuDeviceGet dev))
                            (cuDeviceGet dev)])
		device))))))

#|
#define CUT_EXIT(argc, argv)                                                 \
    if (!cutCheckCmdLineFlag(argc, (const char**)argv, "noprompt")) {        \
        printf("\nPress ENTER to exit...\n");                                \
        fflush( stdout);                                                     \
        fflush( stderr);                                                     \
        getchar();                                                           \
    }                                                                        \
    exit(EXIT_SUCCESS);
|#
(define (CUT_EXIT argc argv)
  (exit #t))


(define-foreign-cutil cutCompareL2fe
  _pointer _pointer _uint _float -> _bool)
  
#;(define (cutCompareL2fe reference data size threshold)
  (let loop ([accum-err 0]
             [accum-ref 0]
             [idx 0])
    (let* ([ref (ptr-ref reference _int idx)]
           [dat (ptr-ref data _int idx)])
      (if (< idx size) 
          (loop (+ accum-err (sqr (- ref dat))) 
                (+ accum-ref (sqr (* ref ref)))
                (add1 idx))
          (let* ([norm-ref (sqrt accum-ref)]
                 [norm-err (sqrt accum-err)])
            (printf "norm-ref = ~s\n" norm-ref)
            (if (< norm-ref 1.0e-10) 
                (begin 
		  (printf "Too small nominator\n") #f)
		(let (
                 [error (/ norm-err norm-ref)])
                (if (< error threshold) #t #f))))))))  
  )
