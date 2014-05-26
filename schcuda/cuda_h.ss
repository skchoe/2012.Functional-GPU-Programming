(module cuda_h mzscheme
(require scheme/foreign
         "cuda-libs.ss") 
  
(provide (all-defined))
  
;    typedef int CUdevice;
(define _CUdevice _int)

;    typedef unsigned int CUdeviceptr;
(define _CUdevice-ptr _int) ;better to be uint, but cuParamSeti uses _int.

;    typedef struct CUctx_st *CUcontext;
;            struct CUctx_st === CUcontext in terms of name.
(define _CUcontext _pointer);(cpointer 'CUcontext))

;    typedef struct CUmod_st *CUmodule;
;            struct CUmod_st === CUmodule in terms of name.  
(define _CUmodule _pointer)

;    typedef struct CUfunc_st *CUfunction;
;            struct CUfunc_st === CUfunction in terms of name.  
(define _CUfunction _pointer); 'CUfunction))
;(define-fun-syntax _CUfunction-ptr (lambda (x) #'(_ptr o _CUfunction)))

;    typedef struct CUarray_st *CUarray;
;            struct CUarray_st === CUarray in terms of name.  
(define _CUarray _pointer); 'CUarray))

;    typedef struct CUtexref_st *CUtexref;
;            struct CUtexref_st === CUtexref in terms of name.  
(define _CUtexref _pointer); 'CUtexref))

;typedef struct CUevent_st *CUevent;
;            struct CUevent_st === CUevent in terms of name.  
(define _CUevent _pointer); 'CUevent))

;    typedef struct CUstream_st *CUstream;
;            struct CUstream_st === CUstream in terms of name.  
(define _CUstream _pointer); 'CUstream))

#|
/************************************
 **
 **    Enums
 **
 ***********************************/
|#
;//
;// array formats
;//
(provide _CUarray_format)
(define _CUarray_format; CUarray_format_enum 
  (_enum '(CU_AD_FORMAT_UNSIGNED_INT8  = 1;0x01
           CU_AD_FORMAT_UNSIGNED_INT16 = 2;0x02
           CU_AD_FORMAT_UNSIGNED_INT32 = 3;0x03
           CU_AD_FORMAT_SIGNED_INT8    = 8;0x08
           CU_AD_FORMAT_SIGNED_INT16   = 9;0x09
           CU_AD_FORMAT_SIGNED_INT32   = 10;0x0a
           CU_AD_FORMAT_HALF           = 16;0x10
           CU_AD_FORMAT_FLOAT          = 32)));0x20)));CUarray_format;

;//
;// Texture reference addressing modes
;//
(provide _CUaddress_mode)
(define _CUaddress_mode;_CUaddress_mode_enum
  (_enum '(CU_TR_ADDRESS_MODE_WRAP = 0
          CU_TR_ADDRESS_MODE_CLAMP = 1
          CU_TR_ADDRESS_MODE_MIRROR = 2)));CUaddress_mode;

;//
;// Texture reference filtering modes
;//
(provide _CUfilter_mode)
(define _CUfilter_mode;_CUfilter_mode_enum
  (_enum '(CU_TR_FILTER_MODE_POINT = 0
          CU_TR_FILTER_MODE_LINEAR = 1)));CUfilter_mode;

;//
;// Device properties
;//
(provide _CUdevice_attribute)
(define _CUdevice_attribute;Udevice_attribute_enum
  (_enum '(CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK = 1
          CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X = 2
          CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Y = 3
          CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Z = 4
          CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X = 5
          CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Y = 6
          CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Z = 7
          CU_DEVICE_ATTRIBUTE_SHARED_MEMORY_PER_BLOCK = 8
          CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY = 9
          CU_DEVICE_ATTRIBUTE_WARP_SIZE = 10
          CU_DEVICE_ATTRIBUTE_MAX_PITCH = 11
          CU_DEVICE_ATTRIBUTE_REGISTERS_PER_BLOCK = 12
          CU_DEVICE_ATTRIBUTE_CLOCK_RATE = 13
          CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT = 14
          CU_DEVICE_ATTRIBUTE_GPU_OVERLAP = 15)));CUdevice_attribute;

;//
;// Legacy device properties
#|
typedef struct CUdevprop_st {
    int maxThreadsPerBlock;
    int maxThreadsDim[3];
    int maxGridSize[3];
    int sharedMemPerBlock;
    int totalConstantMemory;
    int SIMDWidth;
    int memPitch;
    int regsPerBlock;
    int clockRate;
    int textureAlign;
} CUdevprop;
|#
(provide _CUdevprop)
(define-cstruct _CUdevprop
  ([maxThreadsPerBlock _int]
   [maxThreadsDimX _int]	; int[3];
   [maxThreadsDimY _int]
   [maxThreadsDimZ _int]
   [maxGridSizeX _int]	; int[3]; 
   [maxGridSizeY _int]	
   [sharedMemPerBlock _int]
   [totalConstantMemory _int]
   [SIMDWidth _int]
   [memPitch _int]
   [regsPerBlock _int]
   [clockRate _int]
   [textureAlign _int])) 	; CUdevprop;


;//
;// Memory types
;//
(provide _CUmemorytype)
(define _CUmemorytype;_CUmemorytype_enum
  (_enum '(CU_MEMORYTYPE_HOST = 1	;0x01
          CU_MEMORYTYPE_DEVICE = 2	;0x02
          CU_MEMORYTYPE_ARRAY = 3)))	;0x03))));CUmemorytype;


#|
/************************************
 **
 **    Error codes
 **
 ***********************************/
|#
(provide _CUresult)
(define _CUresult;_cudaError_enum
  (_enum 
   '(CUDA_SUCCESS                   = 0
    CUDA_ERROR_INVALID_VALUE        = 1
    CUDA_ERROR_OUT_OF_MEMORY        = 2
    CUDA_ERROR_NOT_INITIALIZED      = 3

    CUDA_ERROR_NO_DEVICE            = 100
    CUDA_ERROR_INVALID_DEVICE       = 101

    CUDA_ERROR_INVALID_IMAGE        = 200
    CUDA_ERROR_INVALID_CONTEXT      = 201
    CUDA_ERROR_CONTEXT_ALREADY_CURRENT = 202
    CUDA_ERROR_MAP_FAILED           = 205
    CUDA_ERROR_UNMAP_FAILED         = 206
    CUDA_ERROR_ARRAY_IS_MAPPED      = 207
    CUDA_ERROR_ALREADY_MAPPED       = 208
    CUDA_ERROR_NO_BINARY_FOR_GPU    = 209
    CUDA_ERROR_ALREADY_ACQUIRED     = 210
    CUDA_ERROR_NOT_MAPPED           = 211

    CUDA_ERROR_INVALID_SOURCE       = 300
    CUDA_ERROR_FILE_NOT_FOUND       = 301

    CUDA_ERROR_INVALID_HANDLE       = 400

    CUDA_ERROR_NOT_FOUND            = 500

    CUDA_ERROR_NOT_READY            = 600

    CUDA_ERROR_LAUNCH_FAILED        = 700
    CUDA_ERROR_LAUNCH_OUT_OF_RESOURCES = 701
    CUDA_ERROR_LAUNCH_TIMEOUT       = 702
    CUDA_ERROR_LAUNCH_INCOMPATIBLE_TEXTURING = 703

    CUDA_ERROR_UNKNOWN              = 999)));CUresult



#|    /*********************************
     ** Initialization
     *********************************/ 
|#
;    CUresult  CUDAAPI cuInit(unsigned int Flags);
;(define cuInit (get-ffi-obj 'cuInit cuda-lib
;                            (_fun _uint -> _CUresult)
;                            (unavailable 'cuInit)))
(define-foreign-cuda cuInit _uint -> _CUresult)

#|
    /************************************
     **
     **    Device management
     **
     ***********************************/
|#
;    CUresult  CUDAAPI cuDeviceGet(CUdevice *device, int ordinal);
(define-foreign-cuda cuDeviceGet (device : (_ptr o _CUdevice)) 
                             (ordinal : _int)
                             -> (result : _CUresult)
                             -> (values result device))
  
;    CUresult  CUDAAPI cuDeviceGetCount(int *count);
(define-foreign-cuda cuDeviceGetCount (count : (_ptr o _int))
                                 -> (result : _CUresult)
                                 -> (values result count))

;    CUresult  CUDAAPI cuDeviceGetName(char *name, int len, CUdevice dev);
(define-foreign-cuda cuDeviceGetName (name : (_bytes o len))
                                (len : _int) 
                                (dev : _CUdevice)
                                -> (result : _CUresult)
				-> (values result name))

;    CUresult  CUDAAPI cuDeviceComputeCapability(int *major, int *minor, CUdevice dev);
(define-foreign-cuda cuDeviceComputeCapability (major : (_ptr o _int))
                                          (minor : (_ptr o _int))
                                          (dev : _CUdevice)
                                          -> (result : _CUresult)
                                          -> (values result major minor))

;    CUresult  CUDAAPI cuDeviceTotalMem(unsigned int *bytes, CUdevice dev);
(define-foreign-cuda cuDeviceTotalMem (bytes : (_ptr o _uint)) 
                                 (dev : _CUdevice)
                                 -> (result : _CUresult)
                                 -> (values result bytes))

;    CUresult  CUDAAPI cuDeviceGetProperties(CUdevprop *prop, CUdevice dev);
(define-foreign-cuda cuDeviceGetProperties (prop : (_ptr o _CUdevprop)) 
                                      (dev : _CUdevice)
                                      -> (result : _CUresult)
                                      -> (values result prop))

;    CUresult  CUDAAPI cuDeviceGetAttribute(int *pi, CUdevice_attribute attrib, CUdevice dev);
(define-foreign-cuda cuDeviceGetAttribute (i : (_ptr o _int))
                                     (attrib : _CUdevice_attribute)
                                     (dev : _CUdevice)
                                     -> (result : _CUresult)
                                     -> (values result i))

#|
    /************************************
     **
     **    Context management
     **
     ***********************************/
|#
;    CUresult  CUDAAPI cuCtxCreate(CUcontext *pctx, unsigned int flags, CUdevice dev );
(define-foreign-cuda cuCtxCreate (ctx : (_ptr o _CUcontext)) 
                            (flags : _uint) 
                            (dev : _CUdevice)
                            -> (result : _CUresult)
                            -> (values result ctx))

;    CUresult  CUDAAPI cuCtxAttach(CUcontext *pctx, unsigned int flags);
(define-foreign-cuda cuCtxAttach (pctx : (_ptr o _CUcontext))
                            (flags : _uint)
                            -> (result : _CUresult))
;                           -> (values result pctx))
    
;    CUresult  CUDAAPI cuCtxDetach(CUcontext ctx);
(define-foreign-cuda cuCtxDetach (ctx : _CUcontext) 
                           -> (result : _CUresult))

;    CUresult  CUDAAPI cuCtxGetDevice(CUdevice *device);
(define-foreign-cuda cuCtxGetDevice (pdev : (_ptr o _CUdevice))
                              -> (result : _CUresult)
                              -> (values result pdev))

;    CUresult  CUDAAPI cuCtxSynchronize(void);
(define-foreign-cuda cuCtxSynchronize 
                              -> (result : _CUresult))


#|
    /************************************
     **
     **    Module management
     **
     ***********************************/
|#    
;    CUresult  CUDAAPI cuModuleLoad(CUmodule *module, const char *fname);
(define-foreign-cuda cuModuleLoad  (mod : (_ptr o _CUmodule))
  	                           (fname : _string)
  	                           -> (result : _CUresult)
  	                           -> (values result mod))

;    CUresult  CUDAAPI cuModuleLoadData(CUmodule *module, const void *image);
(define-foreign-cuda cuModuleLoadData (mod : (_ptr o _CUmodule))
                                 (image : _pointer)
                                 -> (result : _CUresult)
                                 -> (values result mod image))

;    CUresult  CUDAAPI cuModuleLoadFatBinary(CUmodule *module, const void *fatCubin);
(define-foreign-cuda cuModuleLoadFatBinary (mod : (_ptr o _CUmodule))
                                      (fatCubin : _pointer)
                                      -> (result : _CUresult)
                                      -> (values result mod fatCubin))

;    CUresult  CUDAAPI cuModuleUnload(CUmodule hmod);
(define-foreign-cuda cuModuleUnload (mod : _CUmodule) 
                         -> (result : _CUresult)
                         -> (values result mod))

;    CUresult  CUDAAPI cuModuleGetFunction(CUfunction *hfunc, CUmodule hmod, const char *name);
(define-foreign-cuda cuModuleGetFunction (hfunc : (_ptr o _CUfunction))
                                    (mod : _CUmodule)
                                    (name : _pointer)
                                    -> (result : _CUresult)
                                    -> (values result hfunc))

;    CUresult  CUDAAPI cuModuleGetGlobal(CUdeviceptr *dptr, unsigned int *bytes, CUmodule hmod, const char *name);
(define-foreign-cuda cuModuleGetGlobal (dptr : _pointer)
                                  (bytes : _pointer)
                                  (hmod : _CUmodule) 
                                  (name : _pointer)
                                  -> (result : _CUresult)
                                  -> (values result dptr bytes hmod name))

;    CUresult  CUDAAPI cuModuleGetTexRef(CUtexref *pTexRef, CUmodule hmod, const char *name);
(define-foreign-cuda cuModuleGetTexRef (texRef : (_ptr o _CUtexref))
                                  (hmod : _CUmodule) 
                                  (name : _pointer)
                                  -> (result : _CUresult)
                                  -> (values result texRef hmod name))

#|
    /************************************
     **
     **    Memory management
     **
     ***********************************/
|#

;    CUresult CUDAAPI cuMemGetInfo(unsigned int *free, unsigned int *total);
(define-foreign-cuda cuMemGetInfo (free : (_ptr o _int))
                      (total : (_ptr o _int))
                      -> (result : _CUresult)
                      -> (values result free total))

;    CUresult CUDAAPI cuMemAlloc(CUdeviceptr *dptr, unsigned int bytesize);
(define-foreign-cuda cuMemAlloc (dptr : (_ptr o _CUdevice-ptr))
                      (bytesize : _uint)
                      -> (result : _CUresult)
                      -> (values result dptr))

;    CUresult CUDAAPI cuMemAllocPitch( CUdeviceptr *dptr, 
;                                      unsigned int *pPitch,
;                                      unsigned int WidthInBytes, 
;                                      unsigned int Height, 
;                                      // size of biggest r/w to be performed by kernels on this memory
;                                      // 4, 8 or 16 bytes
;                                      unsigned int ElementSizeBytes
;                                     );
(define-foreign-cuda cuMemAllocPitch (ptr : (_ptr o _CUdevice-ptr))
                      (pitch : (_ptr o _int))
                      (WidthInBytes : _uint)
                      (Height : _uint)
                      (ElementSizeBytes : _uint)
                      -> (result : _CUresult)
                      -> (values result ptr pitch))

;    CUresult CUDAAPI cuMemFree(CUdeviceptr dptr);
(define-foreign-cuda cuMemFree (dptr : _CUdevice-ptr) 
                      -> (result : _CUresult))

;    CUresult CUDAAPI cuMemGetAddressRange( CUdeviceptr *pbase, unsigned int *psize, CUdeviceptr dptr );
;
(define-foreign-cuda cuMemGetAddressRange (base : (_ptr o _CUdevice-ptr))
                      (size : (_ptr o _int)) 
                      (dptr : _CUdevice-ptr)
                      -> (result : _CUresult)
                      -> (values result base size))

;    CUresult CUDAAPI cuMemAllocHost(void **pp, unsigned int bytesize);
(define-foreign-cuda cuMemAllocHost (host : (_ptr o _pointer))
                      (bytesize : _uint)
                      -> (result : _CUresult)
                      -> (values result host))

;    CUresult CUDAAPI cuMemFreeHost(void *p);
(define-foreign-cuda cuMemFreeHost (p : _pointer)
                      -> (result : _CUresult)
                      -> (values result p))

#|
    /************************************
     **
     **    Synchronous Memcpy
     **
     ** Intra-device memcpy's done with these functions may execute in parallel with the CPU,
     ** but if host memory is involved, they wait until the copy is done before returning.
     **
     ***********************************/
|#

;    // 1D functions
;        // system <-> device memory
;        CUresult  CUDAAPI cuMemcpyHtoD (CUdeviceptr dstDevice, const void *srcHost, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyHtoD (dstDevice : _CUdevice-ptr)
                         (srcHost : _pointer)
                         (ByteCount : _uint)
                         -> (result : _CUresult)
                         -> (values result dstDevice))

;        CUresult  CUDAAPI cuMemcpyDtoH (void *dstHost, CUdeviceptr srcDevice, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyDtoH (dstHost : _pointer) 
                         (srcDevice : _CUdevice-ptr)
                         (ByteCount : _uint)
                         -> (result : _CUresult)
                         -> (values result dstHost))

;
;        // device <-> device memory
;        CUresult  CUDAAPI cuMemcpyDtoD (CUdeviceptr dstDevice, CUdeviceptr srcDevice, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyDtoD (dstDevice : _CUdevice-ptr)
                         (srcDevice : _CUdevice-ptr)
                         (ByteCount : _uint)
                         -> (result : _CUresult))

;
;        // device <-> array memory
;        CUresult  CUDAAPI cuMemcpyDtoA ( CUarray dstArray, unsigned int dstIndex, CUdeviceptr srcDevice, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyDtoA (dstArray : _CUarray)
                         (dstIndex : _uint)
                         (srcDevice : _CUdevice-ptr)
                         (ByteCount : _uint)
                         -> (result : _CUresult)
                         -> (values result dstArray))

;        CUresult  CUDAAPI cuMemcpyAtoD ( CUdeviceptr dstDevice, CUarray hSrc, unsigned int SrcIndex, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyAtoD (dstDevice : _CUdevice-ptr)
                         (hSrc : _CUarray)
                         (SrcIndex : _uint)
                         (ByteCount : _uint)
                         -> (result : _CUresult)
                         -> (values result hSrc))

;
;        // system <-> array memory
;        CUresult  CUDAAPI cuMemcpyHtoA( CUarray dstArray, unsigned int dstIndex, const void *pSrc, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyHtoA (dstArray : _CUarray)
                         (dstIndex : _uint)
                         (pSrc : _pointer)
                         (ByteCount : _uint)
                         -> (result : _CUresult)
                         -> (values result dstArray pSrc))

;        CUresult  CUDAAPI cuMemcpyAtoH( void *dstHost, CUarray srcArray, unsigned int srcIndex, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyAtoH (dstHost : _pointer)
                         (srcArray : _CUarray)
                         (srcIndex : _uint)
                         (ByteCount : _uint)
                         -> (result : _CUresult)
                         -> (values result dstHost srcArray))

;
;        // array <-> array memory
;        CUresult  CUDAAPI cuMemcpyAtoA( CUarray dstArray, unsigned int dstIndex, CUarray srcArray, unsigned int srcIndex, unsigned int ByteCount );
(define-foreign-cuda cuMemcpyAtoA (dstArray : _CUarray)
                         (dstIndex : _uint)
                         (srcArray : _CUarray)
                         (srcIndex : _uint)
                         (ByteCount : _uint)
                         -> (result : _CUresult)
                         -> (values result dstArray srcArray))
;
;    // 2D memcpy
;
;        typedef struct CUDA_MEMCPY2D_st {
;
;            unsigned int srcXInBytes, srcY;
;            CUmemorytype srcMemoryType;
;                const void *srcHost;
;                CUdeviceptr srcDevice;
;                CUarray srcArray;
;                unsigned int srcPitch; // ignored when src is array
;
;            unsigned int dstXInBytes, dstY;
;            CUmemorytype dstMemoryType;
;                void *dstHost;
;                CUdeviceptr dstDevice;
;                CUarray dstArray;
;                unsigned int dstPitch; // ignored when dst is array
;
;            unsigned int WidthInBytes;
;            unsigned int Height;
;        } CUDA_MEMCPY2D;
(define-cstruct _CUDA_MEMCPY2D 
  ([srcXInBytes _uint]
   [srcY _uint]
   [srcMemoryType _CUmemorytype]
   [srcHost _pointer]
   [srcDevice _CUdevice-ptr]
   [srcArray _CUarray]
   [srcPitch _uint]
   [dstXInBytes _uint]
   [dstY _uint]
   [dstMemoryType _CUmemorytype]
   [dstHost _pointer]
   [dstDevice _CUdevice-ptr]
   [dstArray _CUarray]
   [dstPitch _uint] 
   [WidthInBytes _uint]
   [Height _uint]))

;        CUresult  CUDAAPI cuMemcpy2D( const CUDA_MEMCPY2D *pCopy );
(define-foreign-cuda cuMemcpy2D (pCopy : _pointer) 
                         -> (result : _CUresult)
                         -> (values result pCopy))

;        CUresult  CUDAAPI cuMemcpy2DUnaligned( const CUDA_MEMCPY2D *pCopy );
(define-foreign-cuda cuMemcpy2DUnaligned (pCopy : _pointer) 
                         -> (result : _CUresult)
                         -> (values result pCopy))

#|
    /************************************
     **
     **    Asynchronous Memcpy
     **
     ** Any host memory involved must be DMA'able (e.g., allocated with cuMemAllocHost).
     ** memcpy's done with these functions execute in parallel with the CPU and, if
     ** the hardware is available, may execute in parallel with the GPU.
     ** Asynchronous memcpy must be accompanied by appropriate stream synchronization.
     **
     ***********************************/
|#

;    // 1D functions
;        // system <-> device memory
;        CUresult  CUDAAPI cuMemcpyHtoDAsync (CUdeviceptr dstDevice, 
;            const void *srcHost, unsigned int ByteCount, CUstream hStream );
(define-foreign-cuda cuMemcpyHtoDAsync (dstDevice : _CUdevice-ptr)
                         (srcHost : _pointer)
                         (ByteCount : _uint)
                         (hStream : _CUstream)
                         -> (result : _CUresult)
                         -> (values result dstDevice))

;        CUresult  CUDAAPI cuMemcpyDtoHAsync (void *dstHost, 
;            CUdeviceptr srcDevice, unsigned int ByteCount, CUstream hStream );
(define-foreign-cuda cuMemcpyDtoHAsync (dstHost : _pointer)
                         (srcDevice : _CUdevice-ptr)
                         (ByteCount : _uint)
                         (hStream : _CUstream)
                         -> (result : _CUresult)
                         -> (values result dstHost))

;
;        // system <-> array memory
;        CUresult  CUDAAPI cuMemcpyHtoAAsync( CUarray dstArray, unsigned int dstIndex, 
;            const void *pSrc, unsigned int ByteCount, CUstream hStream );
(define-foreign-cuda cuMemcpyHtoAAsync (dstArray : _CUarray)
                         (dstIndex : _uint)
                         (pSrc : _pointer)
                         (ByteCount : _uint)
                         (hStream : _CUstream)
                         -> (result : _CUresult)
                         -> (values result dstArray))



;        CUresult  CUDAAPI cuMemcpyAtoHAsync( void *dstHost, CUarray srcArray, 
;                                             unsigned int srcIndex, 
;                                             unsigned int ByteCount, CUstream hStream );
(define-foreign-cuda cuMemcpyAtoHAsync (dstHost : _pointer)
                         (srcArray : _CUarray)
                         (srcIndex : _uint)
                         (ByteCount : _uint)
                         (hStream : _CUstream)
                         -> (result : _CUresult)
                         -> (values result dstHost))

;
;        // 2D memcpy
;        CUresult  CUDAAPI cuMemcpy2DAsync( const CUDA_MEMCPY2D *pCopy, CUstream hStream );
(define-foreign-cuda cuMemcpy2DAsync (pCopy : _pointer)
                         (hStream : _CUstream)
                         -> (result : _CUresult)
                         -> (values result pCopy))

#|
    /************************************
     **
     **    Memset
     **
     ***********************************/
|#

;        CUresult  CUDAAPI cuMemsetD8( CUdeviceptr dstDevice, unsigned char uc, unsigned int N );
(define-foreign-cuda cuMemsetD8 (dstDevice : _CUdevice-ptr)
                         (uc : _ubyte) ; unsigned char
                         (N : _uint)
                         -> (result : _CUresult)
                         -> (values result dstDevice))

;        CUresult  CUDAAPI cuMemsetD16( CUdeviceptr dstDevice, unsigned short us, unsigned int N );
(define-foreign-cuda cuMemsetD16 (dstDevice : _CUdevice-ptr)
                         (us : _ushort)
                         (N : _uint)
                         -> (result : _CUresult)
                         -> (values result dstDevice))

;        CUresult  CUDAAPI cuMemsetD32( CUdeviceptr dstDevice, unsigned int ui, unsigned int N );
(define-foreign-cuda cuMemsetD32 (dstDevice : _CUdevice-ptr)
                         (ui : _uint)
                         (N : _uint)
                         -> (result : _CUresult)
                         -> (values result dstDevice))
;
;        CUresult  CUDAAPI cuMemsetD2D8( CUdeviceptr dstDevice, unsigned int dstPitch, unsigned char uc, unsigned int Width, unsigned int Height );
(define-foreign-cuda cuMemsetD2D8 (dstDevice : _CUdevice-ptr)
                         (dstPitch : _uint)
                         (uc : _ubyte)
                         (Width : _uint)
                         (Height : _uint)
                         -> (result : _CUresult)
                         -> (values result dstDevice))

;        CUresult  CUDAAPI cuMemsetD2D16( CUdeviceptr dstDevice, unsigned int dstPitch, unsigned short us, unsigned int Width, unsigned int Height );
(define-foreign-cuda cuMemsetD2D16 (dstDevice : _CUdevice-ptr)
                         (dstPitch : _uint)
                         (us : _ushort)
                         (Width : _uint)
                         (Height : _uint)
                         -> (result : _CUresult)
                         -> (values result dstDevice))

;        CUresult  CUDAAPI cuMemsetD2D32( CUdeviceptr dstDevice, unsigned int dstPitch, unsigned int ui, unsigned int Width, unsigned int Height );
(define-foreign-cuda cuMemsetD2D32 (dstDevice : _CUdevice-ptr)
                         (dstPitch : _uint)
                         (ui : _uint)
                         (Width : _uint)
                         (Height : _uint)
                         -> (result : _CUresult)
                         -> (values result dstDevice))


#|
    /************************************
     **
     **    Function management
     **
     ***********************************/
|#


;    CUresult CUDAAPI cuFuncSetBlockShape (CUfunction hfunc, int x, int y, int z);
(define-foreign-cuda cuFuncSetBlockShape (hfunc : _CUfunction);(_ptr io _CUfunction))
                         (x : _int)
                         (y : _int)
                         (z : _int)
                         -> (result : _CUresult)
			-> (values result hfunc))
   

;    CUresult CUDAAPI cuFuncSetSharedSize (CUfunction hfunc, unsigned int bytes);
(define-foreign-cuda cuFuncSetSharedSize (hfunc : _CUfunction);(_ptr io _CUfunction))
                         (bytes : _uint)
                         -> (result : _CUresult)
			-> (values result hfunc))


#|
    /************************************
     **
     **    Array management 
     **
     ***********************************/
|#
   
;    typedef struct
;    {
;        //
;        // dimensions
;        //            
;            unsigned int Width;
;            unsigned int Height;
;            
;        //
;        // format
;        //
;            CUarray_format Format;
;        
;            // channels per array element
;            unsigned int NumChannels;
;    } CUDA_ARRAY_DESCRIPTOR;
(define-cstruct _CUDA_ARRAY_DESCRIPTOR
  ([Width _uint][Height _uint][Format _CUarray_format][NumChannels _uint]))

;    CUresult  CUDAAPI cuArrayCreate( CUarray *pHandle, const CUDA_ARRAY_DESCRIPTOR *pAllocateArray );
(define-foreign-cuda cuArrayCreate (handle : (_ptr o _CUarray))
                        (pAllocateArray : _pointer)
                        -> (result : _CUresult)
                        -> (values result handle pAllocateArray))
;    
;    CUresult  CUDAAPI cuArrayGetDescriptor( CUDA_ARRAY_DESCRIPTOR *pArrayDescriptor, CUarray hArray );
(define-foreign-cuda cuArrayGetDescriptor
                        (arrayDescriptor : (_ptr o _CUDA_ARRAY_DESCRIPTOR))
                        (hArray : _CUarray)
                        -> (result : _CUresult)
                        -> (values result arrayDescriptor))
;    
;    CUresult  CUDAAPI cuArrayDestroy( CUarray hArray );
(define-foreign-cuda cuArrayDestroy (hArray : _CUarray)
                        -> (result : _CUresult))
    

#|
    /************************************
     **
     **    Texture reference management
     **
     ***********************************/
|#
;    CUresult  CUDAAPI cuTexRefCreate( CUtexref *pTexRef );
(define-foreign-cuda cuTexRefCreate (texRef : (_ptr o _CUtexref))
                        -> (result : _CUresult)
                        -> (values result texRef))
  
;    CUresult  CUDAAPI cuTexRefDestroy( CUtexref hTexRef );
(define-foreign-cuda cuTexRefDestroy (hTexRef : _CUtexref) 
                        -> (result : _CUresult))
    
;    CUresult  CUDAAPI cuTexRefSetArray( CUtexref hTexRef, CUarray hArray, unsigned int Flags )
(define-foreign-cuda cuTexRefSetArray (hTexRef : _pointer);(_ptr io _CUtexref))
                        (hArray : _CUarray)
                        (Flags : _uint)
                        -> (result : _CUresult)
                        -> (values result hTexRef))
  
;        // override the texref format with a format inferred from the array
;        #define CU_TRSA_OVERRIDE_FORMAT 0x01
(define CU_TRSA_OVERRIDE_FORMAT 1);0x01)
;    CUresult  CUDAAPI cuTexRefSetAddress( unsigned int *ByteOffset, CUtexref hTexRef, CUdeviceptr dptr, unsigned int bytes );
(define-foreign-cuda cuTexRefSetAddress
                        (ByteOffset : _pointer); (_ptr io _uint))
                        (hTexRef : _CUtexref)
                        (dptr : _CUdevice-ptr)
                        (bytes : _uint)
                        -> (result : _CUresult)
                        -> (values result ByteOffset hTexRef))
  
;    CUresult  CUDAAPI cuTexRefSetFormat( CUtexref hTexRef, CUarray_format fmt, int NumPackedComponents );
(define-foreign-cuda cuTexRefSetFormat (hTexRef : _CUtexref)
                        (fmt : _CUarray_format)
                        (NumPackedComponents : _int)
                        -> (result : _CUresult)
                        -> (values result hTexRef))
  
;    CUresult  CUDAAPI cuTexRefSetAddressMode( CUtexref hTexRef, int dim, CUaddress_mode am );
(define-foreign-cuda cuTexRefSetAddressMode (hTexRef : _CUtexref)
                        (dim : _int)
                        (am : _CUaddress_mode)
                        -> (result : _CUresult)
                        -> (values result hTexRef))

;    CUresult  CUDAAPI cuTexRefSetFilterMode( CUtexref hTexRef, CUfilter_mode fm );
(define-foreign-cuda cuTexRefSetFilterMode (hTexRef : _CUtexref)
                        (fm : _CUfilter_mode)
                        -> (result : _CUresult)
                        -> (values result hTexRef))
  
;    CUresult  CUDAAPI cuTexRefSetFlags( CUtexref hTexRef, unsigned int Flags );
(define-foreign-cuda cuTexRefSetFlags (hTexRef : _CUtexref)
                        (Flags : _uint)
                        -> (result : _CUresult)
                        -> (values result hTexRef))
  
;        // read the texture as integers rather than promoting the values
;        // to floats in the range [0,1]
;        #define CU_TRSF_READ_AS_INTEGER         0x01
(define CU_TRSF_READ_AS_INTEGER 1);0x01)
;        // use normalized texture coordinates in the range [0,1) instead of [0,dim)
;        #define CU_TRSF_NORMALIZED_COORDINATES  0x02
(define CU_TRSF_NORMALIZED_COORDINATES 2);0x02)
;
;    CUresult  CUDAAPI cuTexRefGetAddress( CUdeviceptr *pdptr, CUtexref hTexRef );
(define-foreign-cuda cuTexRefGetAddress (hTexRef : (_ptr o _CUdevice-ptr))
                        (Flags : _uint)
                        -> (result : _CUresult)
                        -> (values result hTexRef))
  
;    CUresult  CUDAAPI cuTexRefGetArray( CUarray *phArray, CUtexref hTexRef );
(define-foreign-cuda cuTexRefGetArray (hArray : (_ptr o _CUarray))
                        (hTexRef : _CUtexref)
                        -> (result : _CUresult)
                        -> (values result hArray hTexRef))
  
;    CUresult  CUDAAPI cuTexRefGetAddressMode( CUaddress_mode *pam, CUtexref hTexRef, int dim );
(define-foreign-cuda cuTexRefGetAddressMode (am : (_ptr o _CUaddress_mode))
                        (hTexRef : _CUtexref)
                        (dim : _int)
                        -> (result : _CUresult)
                        -> (values result am))
  
;    CUresult  CUDAAPI cuTexRefGetFilterMode( CUfilter_mode *pfm, CUtexref hTexRef );
(define-foreign-cuda cuTexRefGetFilterMode (fm : (_ptr o _CUfilter_mode))
                        (hTexRef : _CUtexref)
                        -> (result : _CUresult)
                        -> (values result fm))
  
;    CUresult  CUDAAPI cuTexRefGetFormat( CUarray_format *pFormat, int *pNumChannels, CUtexref hTexRef );
(define-foreign-cuda cuTexRefGetFormat (format : (_ptr o _CUarray_format))
                        (pNumChannel : _pointer)
                        (hTexRef : _CUtexref)
                        (Flags : _uint)
                        -> (result : _CUresult)
                        -> (values result format))
  
;    CUresult  CUDAAPI cuTexRefGetFlags( unsigned int *pFlags, CUtexref hTexRef );
(define-foreign-cuda cuTexRefGetFlags (flag : (_ptr o _uint))
                        (hTexRef : _CUtexref)
                        -> (result : _CUresult)
                        -> (values result flag))
  

#|
    /************************************
     **
     **    Parameter management
     **
     ***********************************/
|#

;    CUresult  CUDAAPI cuParamSetSize (CUfunction hfunc, unsigned int numbytes);
(define-foreign-cuda cuParamSetSize (hfunc : _CUfunction); (_ptr io _CUfunction)); )
                        (numbytes : _uint)
                        -> (result : _CUresult)
			-> (values result hfunc))

;    CUresult  CUDAAPI cuParamSeti    (CUfunction hfunc, int offset, unsigned int value);
(define-foreign-cuda cuParamSeti (hfunc : _CUfunction);(_ptr io _CUfunction))
                        (offset : _uint)
                        (value : _int)
                        -> (result : _CUresult)
			-> (values result hfunc))

  
;    CUresult  CUDAAPI cuParamSetf    (CUfunction hfunc, int offset, float value);
(define-foreign-cuda cuParamSetf (hfunc : _CUfunction); (_ptr io  _CUfunction))
                        (offset : _uint)
                        (value : _float)
                        -> (result : _CUresult)
			-> (values result hfunc))
  
;    CUresult  CUDAAPI cuParamSetv    (CUfunction hfunc, int offset, void * ptr, unsigned int numbytes);
(define-foreign-cuda cuParamSetv (hfunc : _CUfunction);(_ptr io _CUfunction))
                        (offset : _uint)
                        (ptr : (_ptr i _CUdevice-ptr))
                        (numbytes : _uint)
                        -> (result : _CUresult)
			-> (values result hfunc))
  
;    CUresult  CUDAAPI cuParamSetTexRef(CUfunction hfunc, int texunit, CUtexref hTexRef);
(define-foreign-cuda cuParamSetTexRef (hfunc : _CUfunction);(_ptr io _CUfunction))
                        (texunit : _int)
                        (hTexRef : _CUtexref)
                        -> (result : _CUresult)
			-> (values result hfunc))
  
;        // for texture references loaded into the module,
;        // use default texunit from texture reference
;        #define CU_PARAM_TR_DEFAULT -1
(define CU_PARAM_TR_DEFAULT -1)

#|
    /************************************
     **
     **    Launch functions
     **
     ***********************************/
|#

;    CUresult CUDAAPI cuLaunch ( CUfunction f );
(define-foreign-cuda cuLaunch (f : _CUfunction)
                        -> (result : _CUresult))

;    CUresult CUDAAPI cuLaunchGrid (CUfunction f, int grid_width, int grid_height);
(define-foreign-cuda cuLaunchGrid (f : _CUfunction)
                        (grid_width : _int)
                        (grid_height : _int)
                        -> (result : _CUresult))
  
;    CUresult CUDAAPI cuLaunchGridAsync( CUfunction f, int grid_width, int grid_height, CUstream hStream );
(define-foreign-cuda cuLaunchGridAsync (f : _CUfunction)
                        (grid_width : _int)
                        (grid_height : _int)
                        (hStream : _CUstream)
                        -> (result : _CUresult))

#|
    /************************************
     **
     **    Events
     **
     ***********************************/
|#
;    CUresult CUDAAPI cuEventCreate( CUevent *phEvent, unsigned int Flags );
(define-foreign-cuda cuEventCreate (hEvent : (_ptr o _CUevent))
                        (Flags : _uint)
                        -> (result : _CUresult)
                        -> (values result hEvent))
  
;    CUresult CUDAAPI cuEventRecord( CUevent hEvent, CUstream hStream );
(define-foreign-cuda cuEventRecord (hEvent : _CUevent)
                        (hStream : _CUstream)
                        -> (result : _CUresult)
                        -> (values result hEvent))
  
;    CUresult CUDAAPI cuEventQuery( CUevent hEvent );
(define-foreign-cuda cuEventQuery (hEvent : _CUevent)
                        -> (result : _CUresult))
  
;    CUresult CUDAAPI cuEventSynchronize( CUevent hEvent );
(define-foreign-cuda cuEventSynchronize (hEvent : _CUevent)
                        -> (result : _CUresult))
  
;    CUresult CUDAAPI cuEventDestroy( CUevent hEvent );
(define-foreign-cuda cuEventDestroy (hEvent : _CUevent)
                        -> (result : _CUresult))
  
;    CUresult CUDAAPI cuEventElapsedTime( float *pMilliseconds, CUevent hStart, CUevent hEnd );
(define-foreign-cuda cuEventElapsedTime (milliseconds : (_ptr o _float))
                        (hStart : _CUevent)
                        (hEnd : _CUevent)
                        -> (result : _CUresult)
                        -> (values result milliseconds))
  

#|
    /************************************
     **
     **    Streams
     **
     ***********************************/
|#
;    CUresult CUDAAPI  cuStreamCreate( CUstream *phStream, unsigned int Flags ); Flag must be zero.
(define-foreign-cuda cuStreamCreate (phStream : (_ptr o _CUstream))
                        (Flags : _uint)
                        -> (result : _CUresult)
                        -> (values result phStream))
             
;    CUresult CUDAAPI  cuStreamQuery( CUstream hStream );
(define-foreign-cuda cuStreamQuery (hStream : _CUstream)
                        -> (result : _CUresult))

;    CUresult CUDAAPI  cuStreamSynchronize( CUstream hStream );
(define-foreign-cuda cuStreamSynchronize (hStream : _CUstream)
                        -> (result : _CUresult))
  
;    CUresult CUDAAPI  cuStreamDestroy( CUstream hStream );
(define-foreign-cuda cuStreamDestroy (hStream : _CUstream)
                        -> (result : _CUresult))
)
