(module cuda_runtime_api_h mzscheme
  
(require scheme/foreign
         "cuda-libs.ss"
         "host_defines_h.ss"
         "driver_types_h.ss"
         "texture_types_h.ss"
         "vector_types_h.ss")
  
  
;#define CUDART_VERSION 1010 /* 1.1 */
(provide CUDART_VERSION)
(define CUDART_VERSION 1010)
  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
  
  
;#include "host_defines.h"
; -> "host_defines_h.ss"
;#include "builtin_types.h"
  ; -> will call "device, driver, texture, vector_type.h"
; device_type.h
;/*DEVICE_BUILTIN*/
(define _cudaRoundMode
  (_enum 
   '(cudaRoundNearest
     cudaRoundZero
     cudaRoundPosInf
     cudaRoundMinInf)))

; driver_type.h -> ffi's are defined in driver_types_h.ss
  
; texture_type.h -> texture_types_h.ss
  
  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#

;extern __host__ cudaError_t CUDARTAPI cudaMalloc(void **devPtr, size_t size);
(define-foreign-cudart cudaMalloc (devPtr : (_ptr o _pointer))
                                  (size : _size_t)
                                  -> (result : _cudaError_t)
                                  -> (values result devPtr))
  

;extern __host__ cudaError_t CUDARTAPI cudaMallocHost(void **ptr, size_t size);
(define-foreign-cudart cudaMallocHost (devPtr : (_ptr o _pointer))
                                  (size : _size_t)
                                  -> (result : _cudaError_t)
                                  -> (values result devPtr))
                           
;extern __host__ cudaError_t CUDARTAPI cudaMallocPitch(void **devPtr, size_t *pitch, size_t width, size_t height);
(define-foreign-cudart cudaMallocPitch (devPtr : (_ptr o _pointer))
                                  (ppitch : _size_t-ptr)
                                  (width : _size_t)
                                  (height : _size_t)
                                  -> (result : _cudaError_t)
                                  -> (values result devPtr ppitch))
  
;extern __host__ cudaError_t CUDARTAPI cudaMallocArray(struct cudaArray **array, const struct cudaChannelFormatDesc *desc, size_t width, size_t height __dv(1));
(define-foreign-cudart cudaMallocArray (array : (_ptr o _cudaArray-ptr))
                                  (desc : _cudaChannelFormatDesc-ptr)
                                  (width : _size_t)
                                  (height : _size_t)
                                  -> (result : _cudaError_t)
                                  -> (values result array desc))
  
;extern __host__ cudaError_t CUDARTAPI cudaFree(void *devPtr);
(define-foreign-cudart cudaFree (devPtr : _pointer)
                                  -> (result : _cudaError_t))
  
;extern __host__ cudaError_t CUDARTAPI cudaFreeHost(void *ptr);
(define-foreign-cudart cudaFreeHost (ptr : _pointer)
                                  -> (result : _cudaError_t))
  
;extern __host__ cudaError_t CUDARTAPI cudaFreeArray(struct cudaArray *array);
(define-foreign-cudart cudaFreeArray (array : _cudaArray)
                                  -> (result : _cudaError_t))

#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#

;extern __host__ cudaError_t CUDARTAPI cudaMemcpy(void *dst, const void *src, size_t count, enum cudaMemcpyKind kind);
(define-foreign-cudart cudaMemcpy (dst : _pointer)
                                  (src : _pointer)
                                  (count : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
                                   
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyToArray(struct cudaArray *dst, size_t wOffset, size_t hOffset, const void *src, size_t count, enum cudaMemcpyKind kind);
(define-foreign-cudart cudaMemcpyToArray (dst : _cudaArray)
                                  (wOffset : _size_t)
                                  (hOffset : _size_t)
                                  (src : _pointer)
                                  (count : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyFromArray(void *dst, const struct cudaArray *src, size_t wOffset, size_t hOffset, size_t count, enum cudaMemcpyKind kind);
(define-foreign-cudart cudaMemcpyFromArray (dst : _pointer)
                                  (src : _cudaArray)
                                  (wOffset : _size_t)
                                  (hOffset : _size_t)
                                  (count : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyArrayToArray(struct cudaArray *dst, size_t wOffsetDst, size_t hOffsetDst, const struct cudaArray *src, size_t wOffsetSrc, size_t hOffsetSrc, size_t count, enum cudaMemcpyKind kind __dv(cudaMemcpyDeviceToDevice));
(define-foreign-cudart cudaMemcpyArrayToArray (dst : _cudaArray)
                                  (wOffsetDst : _size_t)
                                  (hOffsetDst : _size_t)
                                  (src : _pointer)
                                  (wOffsetSrc : _size_t)
                                  (hOffsetSrc : _size_t)
                                  (count : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpy2D(void *dst, size_t dpitch, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind);
(define-foreign-cudart cudaMemcpy2D (dst : _pointer)
                                  (dpitch : _size_t)
                                  (src : _pointer)
                                  (spitch : _size_t)
                                  (width : _size_t)
                                  (height : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
  

;extern __host__ cudaError_t CUDARTAPI cudaMemcpy2DToArray(struct cudaArray *dst, size_t wOffset, size_t hOffset, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind);
(define-foreign-cudart cudaMemcpy2DToArray (dst : _cudaArray)
                                  (wOffset : _size_t)
                                  (hOffset : _size_t)
                                  (src : _pointer)
                                  (spitch : _size_t)
                                  (width : _size_t)
                                  (height : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpy2DFromArray(void *dst, size_t dpitch, const struct cudaArray *src, size_t wOffset, size_t hOffset, size_t width, size_t height, enum cudaMemcpyKind kind);
(define-foreign-cudart cudaMemcpy2DFromArray (dst : _pointer)
                                  (dpitch : _size_t)
                                  (src : _cudaArray)
                                  (wOffset : _size_t)
                                  (hOffset : _size_t)
                                  (width : _size_t)
                                  (height : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpy2DArrayToArray(struct cudaArray *dst, size_t wOffsetDst, size_t hOffsetDst, const struct cudaArray *src, size_t wOffsetSrc, size_t hOffsetSrc, size_t width, size_t height, enum cudaMemcpyKind kind __dv(cudaMemcpyDeviceToDevice));
(define-foreign-cudart cudaMemcpy2DArrayToArray (dst : _cudaArray)
                                  (wOffsetDst : _size_t)
                                  (hOffsetDst : _size_t)
                                  (src : _cudaArray)
                                  (wOffsetSrc : _size_t)
                                  (hOffsetSrc : _size_t)
                                  (width : _size_t)
                                  (height : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyToSymbol(const char *symbol, const void *src, size_t count, size_t offset __dv(0), enum cudaMemcpyKind kind __dv(cudaMemcpyHostToDevice));
(define-foreign-cudart cudaMemcpyToSymbol (symbol : _bytes)
                                  (src : _pointer)
                                  (count : _size_t)
                                  (offset : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result symbol))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyFromSymbol(void *dst, const char *symbol, size_t count, size_t offset __dv(0), enum cudaMemcpyKind kind __dv(cudaMemcpyDeviceToHost));
(define-foreign-cudart cudaMemcpyFromSymbol (dst : _pointer)
                                  (symbol : _bytes)
                                  (count : _size_t)
                                  (offset : _size_t)
                                  (kind : _cudaMemcpyKind)
                                  -> (result : _cudaError_t)
                                  -> (values result dst))

#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyAsync(void *dst, const void *src, si
;                                                           ze_t count, enum cudaMemcpyKind kind, cudaStream_t stream);
(define-foreign-cudart cudaMemcpyAsync (dst : _pointer)
                                       (src : _pointer)
                                       (count : _size_t)
                                       (kind : _cudaMemcpyKind)
				       (stream : _cudaStream_t)
                                       -> (result : _cudaError_t)
                                       -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyToArrayAsync(struct cudaArray *dst, size_t wOffset, size_t hOffset, const void *src, size_t count, enum cudaMemcpyKind kind, cudaStream_t stream);
(define-foreign-cudart cudaMemcpyArrayAsync (dst : _cudaArray)
                                       (wOffset : _size_t)
                                       (hOffset : _size_t)
                                       (src : _pointer)
                                       (count : _size_t)
                                       (kind : _cudaMemcpyKind)
                                       -> (result : _cudaError_t)
                                       -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpyFromArrayAsync(void *dst, const struct cudaArray *src, size_t wOffset, size_t hOffset, size_t count, enum cudaMemcpyKind kind, cudaStream_t stream);
(define-foreign-cudart cudaMemcpyFromArrayAsync (dst : _pointer)
                                       (src : _cudaArray)
                                       (wOffset : _size_t)
                                       (hOffset : _size_t)
                                       (count : _size_t)
                                       (kind : _cudaMemcpyKind)
                                       -> (result : _cudaError_t)
                                       -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpy2DAsync(void *dst, size_t dpitch, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind, cudaStream_t stream);
(define-foreign-cudart cudaMemcpy2DAsync (dst : _pointer)
                                       (dpitch : _size_t)
                                       (src : _pointer)
                                       (spitch : _size_t)
                                       (width : _size_t)
                                       (height : _size_t)
                                       (kind : _cudaMemcpyKind)
                                       (stream : _cudaStream_t)
                                       -> (result : _cudaError_t)
                                       -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpy2DToArrayAsync(struct cudaArray *dst, size_t wOffset, size_t hOffset, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind, cudaStream_t stream);
(define-foreign-cudart cudaMemcpy2DToArrayAsync (dst : _cudaArray)
                                       (wOffset : _size_t)
                                       (hOffset : _size_t)
                                       (src : _pointer)
                                       (spitch : _size_t)
                                       (width : _size_t)
                                       (height : _size_t)
                                       (kind : _cudaMemcpyKind)
                                       (stream : _cudaStream_t)
                                       -> (result : _cudaError_t)
                                       -> (values result dst))
  
;extern __host__ cudaError_t CUDARTAPI cudaMemcpy2DFromArrayAsync(void *dst, size_t dpitch, const struct cudaArray *src, size_t wOffset, size_t hOffset, size_t width, size_t height, enum cudaMemcpyKind kind, cudaStream_t stream);
(define-foreign-cudart cudaMemcpy2DFromArrayAsync (dst : _pointer)
                                       (dpitch : _size_t)
                                       (src : _cudaArray)
                                       (wOffset : _size_t)
                                       (hOffset : _size_t)
                                       (width : _size_t)
                                       (height : _size_t)
                                       (kind : _cudaMemcpyKind)
                                       (stream : _cudaStream_t)
                                       -> (result : _cudaError_t)
                                       -> (values result dst))
  

#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaMemset(void *mem, int c, size_t count);
(define-foreign-cudart cudaMemset (mem : _pointer)
                                  (c : _int)
                                  (count : _size_t)
                                  -> (result : _cudaError_t)
				  -> (values result mem))
;extern __host__ cudaError_t CUDARTAPI cudaMemset2D(void *mem, size_t pitch, int c, size_t width, size_t height);
(define-foreign-cudart cudaMemset2D (mem : _pointer)
                                  (pitch : _size_t)
                                  (c : _int)
                                  (width : _size_t)
                                  (height : _size_t)
                                  -> (result : _cudaError_t)
				  -> (values result mem))
  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaGetSymbolAddress(void **devPtr, const char *symbol);
(define-foreign-cudart cudaGetSymbolAddress (devPtr : _pointer)
                                     (symbol : _bytes)
                                     -> (result : _cudaError_t)
                                     -> (values result symbol))
  
;extern __host__ cudaError_t CUDARTAPI cudaGetSymbolSize(size_t *size, const char *symbol);
(define-foreign-cudart cudaGetSymbolSize (size : _size_t-ptr)
                                     (symbol : _bytes)
                                     -> (result : _cudaError_t)
                                     -> (values result size))

#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaGetDeviceCount(int *count);
(define-foreign-cudart cudaGetDeviceCount (count : _pint)
                                     -> (result : _cudaError_t)
                                     -> (values result count))
  
;extern __host__ cudaError_t CUDARTAPI cudaGetDeviceProperties(struct cudaDeviceProp *prop, int device);
(define-foreign-cudart cudaGetDeviceProperties (prop : _cudaDeviceProp)
                                     (device : _int)
                                     -> (result : _cudaError_t)
                                     -> (values result prop))
  
;extern __host__ cudaError_t CUDARTAPI cudaChooseDevice(int *device, const struct cudaDeviceProp *prop);
(define-foreign-cudart cudaChooseDevice (device : _pint)
                                     (prop : _cudaDeviceProp)
                                     -> (result : _cudaError_t)
                                     -> (values result device))
  
;extern __host__ cudaError_t CUDARTAPI cudaSetDevice(int device);
(define-foreign-cudart cudaSetDevice (device : _int)
                                     -> (result : _cudaError_t)
                                     -> (values result))

;extern __host__ cudaError_t CUDARTAPI cudaGetDevice(int *device);
(define-foreign-cudart cudaGetDevice (device : _pint)
                                     -> (result : _cudaError_t)
                                     -> (values result device))

#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaBindTexture(size_t *offset, const struct textureReference *texref, const void *devPtr, const struct cudaChannelFormatDesc *desc, size_t size __dv(UINT_MAX));
(define-foreign-cudart cudaBindTexture (offset : _size_t-ptr)
                                     (texref : _textureReference)
                                     (devPtr : _pointer)
                                     (desc : _cudaChannelFormatDesc)
                                     (size : _size_t)
                                     -> (result : _cudaError_t)
                                     -> (values result devPtr))
  
;extern __host__ cudaError_t CUDARTAPI cudaBindTextureToArray(const struct textureReference *texref, const struct cudaArray *array, const struct cudaChannelFormatDesc *desc);
(define-foreign-cudart cudaBindTextureToArray (texref : _textureReference)
                                     (array : _cudaArray)
                                     (desc : _cudaChannelFormatDesc)
                                     -> (result : _cudaError_t)
                                     -> (values result array))
  
;extern __host__ cudaError_t CUDARTAPI cudaUnbindTexture(const struct textureReference *texref);
(define-foreign-cudart cudaUnbindTexture (texref : _textureReference)
                                     -> (result : _cudaError_t))
  
;extern __host__ cudaError_t CUDARTAPI cudaGetTextureAlignmentOffset(size_t *offset, const struct textureReference *texref);
(define-foreign-cudart cudaGetTextureAlignmentOffset (offset : _size_t-ptr)
                                     (texref : _textureReference)
                                     -> (result : _cudaError_t)
                                     -> (values result offset))
  
;extern __host__ cudaError_t CUDARTAPI cudaGetTextureReference(const struct textureReference **texref, const char *symbol);
(define-foreign-cudart cudaGetTextureReference (texref : _textureReference)
                                     (symbol : _bytes)
                                     -> (result : _cudaError_t)
                                     -> (values result symbol))
  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaGetChannelDesc(struct cudaChannelFormatDesc *desc, const struct cudaArray *array);
(define-foreign-cudart cudaGetChannelDesc (desc : _cudaChannelFormatDesc)
                                     (array : _cudaArray)
                                     -> (result : _cudaError_t)
                                     -> (values result desc))

;extern __host__ struct cudaChannelFormatDesc CUDARTAPI cudaCreateChannelDesc(int x, int y, int z, int w, enum cudaChannelFormatKind f);
(define-foreign-cudart cudaCreateChannelDesc (x : _int)
                                     (y : _int)
                                     (z : _int)
                                     (f : _cudaChannelFormatKind)
                                     -> (result : _cudaError_t))
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaGetLastError(void);
(define-foreign-cudart cudaGetLastError -> (result : _cudaError_t))
  
;extern __host__ const char* CUDARTAPI cudaGetErrorString(cudaError_t error);
(define-foreign-cudart cudaGetErrorString (error : _cudaError_t)
                                   -> (result : _bytes))
  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaConfigureCall(dim3 gridDim, dim3 blockDim, size_t sharedMem __dv(0), cudaStream_t stream __dv(0));
(define-foreign-cudart cudaConfigureCall (gridDim : _dim3)
                                   (blockDim : _dim3)
                                   (sharedMem : _dim3)
                                   (stream : _cudaStream_t)
                                   -> (result : _cudaError_t))
 
;extern __host__ cudaError_t CUDARTAPI cudaSetupArgument(const void *arg, size_t size, size_t offset);
(define-foreign-cudart cudaSetupArgument (arg : _pointer)
                                   (size : _size_t)
                                   (offset : _size_t)
                                   -> (result : _cudaError_t))
  
;extern __host__ cudaError_t CUDARTAPI cudaLaunch(const char *symbol);
(define-foreign-cudart cudaLaunch (symbol : _pointer)
                                  -> (result : _cudaError_t))

#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaStreamCreate(cudaStream_t *stream);
(define-foreign-cudart cudaStreamCreate (stream : _cudaStream_t-ptr)
                                  -> (result : _cudaError_t))  
;extern __host__ cudaError_t CUDARTAPI cudaStreamDestroy(cudaStream_t stream);
(define-foreign-cudart cudaStreamDestroy (stream : _cudaStream_t)
                                  -> (result : _cudaError_t))  
;extern __host__ cudaError_t CUDARTAPI cudaStreamSynchronize(cudaStream_t stream);
(define-foreign-cudart cudaStreamSynchronize (stream : _cudaStream_t)
                                  -> (result : _cudaError_t))  
;extern __host__ cudaError_t CUDARTAPI cudaStreamQuery(cudaStream_t stream);
(define-foreign-cudart cudaStreamQuery (stream : _cudaStream_t)
                                  -> (result : _cudaError_t))  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaEventCreate(cudaEvent_t *event);
(define-foreign-cudart cudaEventCreate (event : (_ptr o _cudaEvent_t))
                                 -> (result : _cudaError_t)
                                 -> (values result event))
;extern __host__ cudaError_t CUDARTAPI cudaEventRecord(cudaEvent_t event, cudaStream_t stream);
(define-foreign-cudart cudaEventRecord (event : _cudaEvent_t)
                                 (stream : _cudaStream_t)
                                 -> (result : _cudaError_t))  
;extern __host__ cudaError_t CUDARTAPI cudaEventQuery(cudaEvent_t event);
(define-foreign-cudart cudaEventQuery (event : _cudaEvent_t)
                                 -> (result : _cudaError_t))  
;extern __host__ cudaError_t CUDARTAPI cudaEventSynchronize(cudaEvent_t event);
(define-foreign-cudart cudaEventSynchronize (event : _cudaEvent_t)
                                 -> (result : _cudaError_t))  
;extern __host__ cudaError_t CUDARTAPI cudaEventDestroy(cudaEvent_t event);
(define-foreign-cudart cudaEventDestroy (event : _cudaEvent_t)
                                  -> (result : _cudaError_t))  
;extern __host__ cudaError_t CUDARTAPI cudaEventElapsedTime(float *ms, cudaEvent_t start, cudaEvent_t end);
(define-foreign-cudart cudaEventElapsedTime (ms : (_ptr o _float))
                                  (start : _cudaEvent_t)
                                  (end : _cudaEvent_t)
                                  -> (result : _cudaError_t)
                                  -> (values result ms))
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;extern __host__ cudaError_t CUDARTAPI cudaThreadExit(void);
(define-foreign-cudart cudaThreadExit -> (result : _cudaError_t))
;extern __host__ cudaError_t CUDARTAPI cudaThreadSynchronize(void);
(define-foreign-cudart cudaThreadSynchronize -> (result : _cudaError_t))
)
