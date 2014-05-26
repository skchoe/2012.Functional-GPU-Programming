(module cudaGL_h mzscheme
(require scheme/foreign
         "cuda-libs.ss"
	 "cuda_h.ss"	 
         "driver_types_h.ss")

;CUresult CUDAAPI cuGLInit(void);
(define-foreign-cuda cuGLInit -> (result : _CUresult))

;CUresult CUDAAPI cuGLRegisterBufferObject( GLuint bufferobj );
(define-foreign-cuda cuGLRegisterBufferObject (bufferobj : _uint) -> (result : _CUresult))

;CUresult CUDAAPI cuGLMapBufferObject( CUdeviceptr *dptr, unsigned int *size,  GLuint bufferobj ); 
(define-foreign-cuda cuGLMapBufferObject (dptr : (_ptr o _CUdevice-ptr))
					(size : (_ptr o _uint))
					(bufferobj : _int) 
					-> (result : _CUresult)
					-> (values result dptr size))

;CUresult CUDAAPI cuGLUnmapBufferObject( GLuint bufferobj );
(define-foreign-cuda cuGLUnmapBufferObject (bufferobj : _uint) -> (result : _CUresult))

;CUresult CUDAAPI cuGLUnregisterBufferObject( GLuint bufferobj );
(define-foreign-cuda cuGLUnregisterBufferObject (bufferobj : _uint) -> (result : _CUresult)))
