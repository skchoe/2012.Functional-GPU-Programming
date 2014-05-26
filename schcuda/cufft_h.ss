(module cufft_h scheme
  (require scheme/foreign
	   "cuda-libs.ss"
           "vector_types_h.ss")
;* cufft.h  
;* Public header file for the NVIDIA Cuda FFT library (CUFFT)  

; CUFFT API function return values 
(provide _cufftResult)
(define _cufftResult
  (_enum 
   '(CUFFT_SUCCESS        = #x0
     CUFFT_INVALID_PLAN   = #x1
     CUFFT_ALLOC_FAILED   = #x2
     CUFFT_INVALID_TYPE   = #x3
     CUFFT_INVALID_VALUE  = #x4
     CUFFT_INTERNAL_ERROR = #x5
     CUFFT_EXEC_FAILED    = #x6
     CUFFT_SETUP_FAILED   = #x7
     CUFFT_INVALID_SIZE   = #x8)))
; cufftResult;
 

;// CUFFT defines and supports the following data types
;
;// cufftHandle is a handle type used to store and access CUFFT plans.
;typedef unsigned int cufftHandle;
(provide _cufftHandle)
(define _cufftHandle _uint)

;// cufftReal is a single-precision, floating-point real data type.
;typedef float cufftReal;
(provide _cufftReal)
(define _cufftReal _float)
;
;// cufftComplex is a single-precision, floating-point complex data type that 
;// consists of interleaved real and imaginary components.

; Define ctype corresponding cufftComplex
;typedef float cufftComplex[2];
;typedef cuComplex cufftComplex;
(provide _cufftComplex)
(define _cufftComplex _float2)

;// CUFFT transform directions 
;#define CUFFT_FORWARD -1 // Forward FFT
(provide CUFFT_FORWARD)
(define CUFFT_FORWARD -1)
;#define CUFFT_INVERSE  1 // Inverse FFT
(provide CUFFT_INVERSE)
(define CUFFT_INVERSE 1)

;// CUFFT supports the following transform types 
;typedef enum cufftType_t {
;  CUFFT_R2C = 0x2a, // Real to Complex (interleaved)
;  CUFFT_C2R = 0x2c, // Complex (interleaved) to Real
;  CUFFT_C2C = 0x29  // Complex to Complex, interleaved
;} cufftType;
(provide _cufftType)
(define _cufftType
  (_enum
	'(CUFFT_R2C = #x2a  ;Real to Complex (interleaved)
          CUFFT_C2R = #x2c  ;Complex (interleaved) to Real
          CUFFT_C2C = #x29)  ;Complex to Complex, interleaved
	))

;cufftResult CUFFTAPI cufftPlan1d(cufftHandle *plan, 
;                                 int nx, 
;                                 cufftType type, 
;                                 int batch);
(define-foreign-cufft cufftPlan1d (plan : (_ptr o _cufftHandle)) (nx : _int) 
                                  (type : _cufftType) (batch : _int) -> (result : _cufftResult) 
                                  -> (values result plan))

;cufftResult CUFFTAPI cufftPlan2d(cufftHandle *plan, 
;                                 int nx, int ny,
;                                 cufftType type);
(define-foreign-cufft cufftPlan2d (plan : (_ptr o _cufftHandle)) (nx : _int) (ny : _int)
                                  (type : _cufftType) -> (result : _cufftResult)
                                  -> (values result plan))

;cufftResult CUFFTAPI cufftPlan3d(cufftHandle *plan, 
;                                 int nx, int ny, int nz, 
;                                 cufftType type);
(define-foreign-cufft cufftPlan3d (plan : (_ptr o _cufftHandle)) (nx : _int) (ny : _int)
                                  (nz : _int) (type : _cufftType) -> (result : _cufftResult) 
                                  -> (values result plan))

;cufftResult CUFFTAPI cufftDestroy(cufftHandle plan);
(define-foreign-cufft cufftDestroy (plan : _cufftHandle) -> (result : _cufftResult))

;cufftResult CUFFTAPI cufftExecC2C(cufftHandle plan, 
;                                  cufftComplex *idata,
;                                  cufftComplex *odata,
;                                  int direction);
(define-foreign-cufft cufftExecC2C (plan : _cufftHandle) 
                                   (idata : (_cpointer 'cufftComplex))
                                   ;(odata : (_ptr io _cufftComplex))
                                   (odata : (_cpointer 'cufftComplex)) 
                                   (direction : _int)
                                   -> (result : _cufftResult)
                                   -> (values result odata))

;cufftResult CUFFTAPI cufftExecR2C(cufftHandle plan, 
;                                  cufftReal *idata,
;                                  cufftComplex *odata);
(define-foreign-cufft cufftExecR2C (plan : _cufftHandle) (idata : (_cpointer 'cufftReal))
                                   ;(odata : (_ptr o _cufftComplex))
                                   (odata : (_cpointer 'cufftComplex)) 
                                   -> (result : _cufftResult)
                                   -> (values result odata))

;cufftResult CUFFTAPI cufftExecC2R(cufftHandle plan, 
;                                  cufftComplex *idata,
;                                  cufftReal *odata);
(define-foreign-cufft cufftExecC2R (plan : _cufftHandle) (idata : (_cpointer 'cufftComplex))
                                   (odata : (_cpointer 'cufftComplex))
                                   ;(odata : (_ptr o _cufftReal))
                                   -> (result : _cufftResult)
                                   -> (values result odata))
)
