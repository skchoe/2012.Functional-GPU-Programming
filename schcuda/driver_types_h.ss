(module driver_types_h mzscheme
(require scheme/foreign
         "cuda-libs.ss")
#|/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;/*DEVICE_BUILTIN*/
  (provide _cudaError)
  (define _cudaError
    (_enum 
     '(cudaSuccess = 0
       cudaErrorMissingConfiguration
       cudaErrorMemoryAllocation
       cudaErrorInitializationError
       cudaErrorLaunchFailure
       cudaErrorPriorLaunchFailure
       cudaErrorLaunchTimeout
       cudaErrorLaunchOutOfResources
       cudaErrorInvalidDeviceFunction
       cudaErrorInvalidConfiguration
       cudaErrorInvalidDevice
       cudaErrorInvalidValue
       cudaErrorInvalidPitchValue
       cudaErrorInvalidSymbol
       cudaErrorMapBufferObjectFailed
       cudaErrorUnmapBufferObjectFailed
       cudaErrorInvalidHostPointer
       cudaErrorInvalidDevicePointer
       cudaErrorInvalidTexture
       cudaErrorInvalidTextureBinding
       cudaErrorInvalidChannelDescriptor
       cudaErrorInvalidMemcpyDirection
       cudaErrorAddressOfConstant
       cudaErrorTextureFetchFailed
       cudaErrorTextureNotBound
       cudaErrorSynchronizationError
       cudaErrorInvalidFilterSetting
       cudaErrorInvalidNormSetting
       cudaErrorMixedDeviceExecution
       cudaErrorCudartUnloading
       cudaErrorUnknown
       cudaErrorNotYetImplemented
       cudaErrorMemoryValueTooLarge
       cudaErrorInvalidResourceHandle
       cudaErrorNotReady
       cudaErrorStartupFailure = 127;0x7f
       cudaErrorApiFailureBase = 10000)))


;/*DEVICE_BUILTIN*/
  (provide _cudaMemcpyKind)
  (define _cudaMemcpyKind
    (_enum '(cudaMemcpyHostToHost = 0
             cudaMemcpyHostToDevice
             cudaMemcpyDeviceToHost
             cudaMemcpyDeviceToDevice)))

;;/*DEVICE_BUILTIN*/
;struct cudaDeviceProp
;{
;  char   name[256];
;  size_t totalGlobalMem;
;  size_t sharedMemPerBlock;
;  int    regsPerBlock;
;  int    warpSize;
;  size_t memPitch;
;  int    maxThreadsPerBlock;
;  int    maxThreadsDim[3];
;  int    maxGridSize[3]; 
;  size_t totalConstMem; 
;  int    major;
;  int    minor;
;  int    clockRate;
;  size_t textureAlignment;
;};
  (provide _cudaDeviceProp)
  (define-cstruct _cudaDeviceProp
    ([name _pointer]
     [totalGlobalMem _size_t] 
     [sharedMemPerBlock _size_t]
     [regsPerBlock _int]
     [warpSize _int]
     [memPitch _size_t]
     [maxThreadsPerBlock _int]
     [maxThreadsDimX _int]; int[3];
     [maxThreadsDimY _int];
     [maxThreadsDimZ _int];
     [maxGridSizeX _int]; int[2]
     [maxGridSizeY _int]
     [totalConstMem _size_t]
     [major _int]
     [minor _int]
     [clockRate _int]
     [textureAlignment _size_t] 
     ))


#|
#define cudaDevicePropDontCare                        \
        {                                             \
          {'\0'},    /* char   name[256];          */ \
          0,         /* size_t totalGlobalMem;     */ \
          0,         /* size_t sharedMemPerBlock;  */ \
          0,         /* int    regsPerBlock;       */ \
          0,         /* int    warpSize;           */ \
          0,         /* size_t memPitch;           */ \
          0,         /* int    maxThreadsPerBlock; */ \
          {0, 0, 0}, /* int    maxThreadsDim[3];   */ \
          {0, 0, 0}, /* int    maxGridSize[3];     */ \
          0,         /* size_t totalConstMem;      */ \
          -1,        /* int    major;              */ \
          -1,        /* int    minor;              */ \
          0,         /* int    clockRate;          */ \
          0,         /* size_t textureAlignment;   */ \
        }
|#
  
 
#|
/*******************************************************************************
*                                                                              *
*  SHORTHAND TYPE DEFINITION USED BY RUNTIME API                               *
*                                                                              *
*******************************************************************************/
|#
;/*DEVICE_BUILTIN*/
;typedef enum cudaError cudaError_t;
(provide _cudaError_t)
(define _cudaError_t _cudaError)

;/*DEVICE_BUILTIN*/
;typedef int cudaStream_t;
(provide _cudaStream_t)
(define _cudaStream_t _int)
(provide _cudaStream_t-ptr)
(define _cudaStream_t-ptr _pointer)

;/*DEVICE_BUILTIN*/
;typedef int cudaEvent_t;
(provide _cudaEvent_t)
(define _cudaEvent_t _int)
(provide _cudaEvent_t-ptr)
(define _cudaEvent_t-ptr _pointer)
)
