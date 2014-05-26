#lang scheme
(require scheme/foreign
         scheme/system
	 mred
	 mzlib/class
	 sgl
	 sgl/gl
	 sgl/gl-vectors
	 sgl/gl-types
	 "../../../schcuda/gl-1.5.ss"
	 "../../../schcuda/ffi-ext.ss"
         "../../../schcuda/scuda.ss"
	 "../../schcuda/suda-set-env.ss"
	 "../../../schcuda/cuda_h.ss"
         "../../../schcuda/cudaGL_h.ss"
         "../../../schcuda/glew_h.ss")
(unsafe!)
  (define window_width 512)
  (define window_height 512)
(define mesh_width 256)
(define mesh_height 256)
(define vbo-init #f)
(define anim 1.0)

(define cudaGLInit%
  (class* canvas% ()
   (inherit refresh with-gl-context)
    
   (define/override (on-size width height)

     (with-gl-context
      (lambda ()
        ;; VBO init and registration to cuda
        (unless vbo-init
          
          (let* ([cubin-name (generate-cubin #"data/_test_kernel.cubin")]
                 [cuDevice (suda-init-devices 0)])
            (let-values ([(cuContext l-func) 
                          (load-kernel-driver cuDevice cubin-name #"kernel")])
              
              (let* ([glewv (glewInit)]
                     [size (* mesh_width mesh_height 4 (ctype-sizeof _float))]
                     [vb (cvector-ref (glGenBuffers 1) 0)]
                     
                     [bb (glBindBuffer GL_ARRAY_BUFFER vb)]
                     [bd (glBufferData GL_ARRAY_BUFFER 
                                       size 
                                       (malloc 1 _int) 
                                       GL_DYNAMIC_DRAW)]
                     
                     [bb2 (glBindBuffer GL_ARRAY_BUFFER 0)]
                     
                     [resulti (cuGLInit)])
                
                (printf "cuDevice, vbo = ~s ~s\n" cuDevice vb)
                (printf "init result = ~s \n" resulti)
                
                (let* ([resultr (cuGLRegisterBufferObject vb)])
                  (printf "register result = ~s\n" resultr)
                  
                  (let*-values ([(resultm dv size) (cuGLMapBufferObject vb)])
                    (let* ([func (car l-func)]
			   [block-size 8]
                           [grid-w (/ mesh_width block-size)]
                           [grid-h (/ mesh_height block-size)]
                           [lst-offs (offsets-ctype (list _int _uint _uint _float))])
                      (printf "result: MapBufferObject = ~s\n" resultm)
                      (let*-values ([(resultbs func) 
                                     (cuFuncSetBlockShape func block-size block-size 1)]
                                    [(result0 func) (cuParamSeti func 0 dv)]
                                    [(result1 func) (cuParamSeti func (list-ref lst-offs 0) mesh_width)]
                                    [(result2 func) (cuParamSeti func (list-ref lst-offs 1) mesh_height)]
                                    [(result3 func) (cuParamSetf func (list-ref lst-offs 2) anim)]
                                    [(result4 func) (cuParamSetSize func (list-ref lst-offs 3))])
                        
                        (printf "result: ParamSet dv: ~s\n" result0)
                        (printf "result: ParamSet width: ~s\n" result1)
                        (printf "result: ParamSet height: ~s\n" result2)
                        (printf "result: ParamSet anim: ~s\n" result3)
                        (printf "result: ParamSet f: ~s\n" result4)
                        (let* ([resultl (cuLaunchGrid func grid-w grid-h)])
                          (printf "RESULT(cuLaunchGrid):~s\n" resultl)
                          #f)
                        
                        (cuGLUnmapBufferObject vb)))
                    #f
                    )))))

                ;; flag reset.
                (set! vbo-init #t)
                ;  (cutCheckErrorGL "simpleGLDrv.scm" 0)                  
                ))))
    
    (super-instantiate () (style '(gl no-autoclear)))
    ))
    
(define (runClass)
  (let* ([f (make-object frame% "test" #f)]
         [c (instantiate cudaGLInit% (f)
                         (min-width 30)
                         (min-height 40))])
     (send f show #t)))

(runClass)

