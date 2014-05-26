(module cuda_gl_interop_h mzscheme
(require scheme/foreign
         "cuda-libs.ss"
	 "cuda_h.ss"
         "driver_types_h.ss")
  
;/*******************************************************************************
;
;extern __host__ cudaError_t CUDARTAPI cudaGLRegisterBufferObject(GLuint bufObj);
(define-foreign-cudart cudaGLRegisterBufferObject (bufObj : _uint)
                                  -> (result : _cudaError_t))

;extern __host__ cudaError_t CUDARTAPI cudaGLMapBufferObject(void **devPtr, GLuint bufObj);
(define-foreign-cudart cudaGLMapBufferObject 
                                  (devPtr : (_ptr o _CUdevice-ptr))
                                  (bufObj : _uint)
                                  -> (result : _cudaError_t)
                                  -> (values result devPtr))

;extern __host__ cudaError_t CUDARTAPI cudaGLUnmapBufferObject(GLuint bufObj);
(define-foreign-cudart cudaGLUnmapBufferObject 
                                  (bufObj : _uint)
                                  -> (result : _cudaError_t))
  
;extern __host__ cudaError_t CUDARTAPI cudaGLUnregisterBufferObject(GLuint bufObj);
(define-foreign-cudart cudaGLUnregisterBufferObject
                                  (bufObj : _uint)
                                  -> (result : _cudaError_t))
)
