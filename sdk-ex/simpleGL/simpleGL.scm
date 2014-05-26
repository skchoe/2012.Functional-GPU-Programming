(module simpleGL scheme
  (require scheme/system
           mred
           mzlib/class
           scheme/foreign

           sgl
	   sgl/gl
           sgl/gl-vectors
           sgl/gl-types
           "../../schcuda/gl-1.5.ss"
           "../../schcuda/ffi-ext.ss"
           "../../schcuda/scuda.ss"
           "../../schcuda/suda-set-env.ss"

           "../../schcuda/cutil_h.ss"
           "../../schcuda/cuda_h.ss"
	   "../../schcuda/cudaGL_h.ss"
           "../../schcuda/cuda_gl_interop_h.ss"
	   "../../schcuda/vector_types_h.ss"
	   "../../schcuda/cuda_runtime_api_h.ss"
           "../../schcuda/glew_h.ss")

;/* 
;    This example demonstrates how to use the Cuda OpenGL bindings to
;    dynamically modify a vertex buffer using a Cuda kernel.
;
;    The steps are:
;    1. Create an empty vertex buffer object (VBO)
;    2. Register the VBO with Cuda
;    3. Map the VBO for writing from Cuda
;    4. Run Cuda kernel to modify the vertex positions
;    5. Unmap the VBO
;    6. Render the results using OpenGL
;
;    Host code
;*/

;#include <cutil_gl_error.h>
;#include <cuda_gl_interop.h>

;// global definitions
(unsafe!)
(define window_width 512)

(define window_height 512)

(define mesh_width 256)
(define mesh_height 256)

(define vbo-init #f)
(define vbo 0)
(define anim 0.0)
(define box-flag #f)

(define cuFunction #f)

;; window frustum
(define aspect 1)
(define size 1)
(define near 3)
(define far 10000)
  
;; projection
(define is_perspective #t)
  
;; lookat
(define eye_x 0)
(define eye_y 0)
(define eye_z 10)
  
;////////////////////////////////////////////////////////////////////////////////
;//! Create VBO: mesh w/h -> vbo
;////////////////////////////////////////////////////////////////////////////////
(define (create-vbo mesh_width mesh_height)
  (let* ([vb (cvector-ref (glGenBuffers 1) 0)]
         [size (* mesh_width mesh_height 4 (ctype-sizeof _float))]
	 [zr   (malloc _uint 1)])

    (printf "vb generated\n")
    (glBindBuffer GL_ARRAY_BUFFER vb)
    (printf "vbo bounds to an array buffer\n")
    (glBufferData GL_ARRAY_BUFFER size zr GL_DYNAMIC_DRAW)
    (printf "data buffer initialized\n")

    (glBindBuffer GL_ARRAY_BUFFER 0)

    (printf "CREATE VBO: ~s\n" vb)
    
    ; register buffer object with CUDA
    (let* ([result0 (cudaGLRegisterBufferObject vb)])
      (printf "REgister BO done: ~s\n" result0)

      (let* ([r1 (cudaGetLastError)]
             [r2 (cuCtxSynchronize)])
        (printf "r1 = ~s:Error check\n" r1)
        (printf "r2 = ~s:Sync result\n" r2)
      
        vb))))

    
;////////////////////////////////////////////////////////////////////////////////
;//! Run the Cuda part of the computation
;////////////////////////////////////////////////////////////////////////////////
; vbo: _uint -> dta (cpointer _float4)
(define (run-cuda vbo func)

  (let*-values 
      ([(resultb dta) (cudaGLMapBufferObject vbo)])
    

    (let* ([block-size 8]
           [grid-w (/ mesh_width block-size)]
           [grid-h (/ mesh_height block-size)]
           [lst-offs (offsets-ctype (list _int _uint _uint _float))])             
      
      (let*-values ([(resultbs func) 
                     (cuFuncSetBlockShape func block-size block-size 1)]
		     
                    [(result0 func) (cuParamSeti func 0 dta)]
                    [(result1 func) (cuParamSeti func (list-ref lst-offs 0) mesh_width)]
                    [(result2 func) (cuParamSeti func (list-ref lst-offs 1) mesh_height)]
                    [(result3 func) (cuParamSetf func (list-ref lst-offs 2) anim)]
                    [(result4 func) (cuParamSetSize func (list-ref lst-offs 3))])
        
        (let* ([resultl (cuLaunchGrid func grid-w grid-h)])
          #;(printf "RESULT(cuLaunchGrid):~s\n" resultl)
          #f)
        
        (cudaGLUnmapBufferObject vbo)))))
      
  
(define simple-canvas%
  (class* canvas% ()
    
    (inherit refresh with-gl-context swap-gl-buffers get-parent)
    
    (define view-rotx 0.0)
    (define view-roty 0.0)
    (define view-rotz 0.0)
    
    (define step? #f)
    
    (define/public (run)
      (set! step? #t)
      (printf "run\n")
      (refresh))
    
    (define/public (move-left)
      (set! view-roty (+ view-roty 5.0))
      (refresh))
    
    (define/public (move-right)
      (set! view-roty (- view-roty 5.0))
      (refresh))
    
    (define/public (move-up)
      (set! view-rotx (+ view-rotx 5.0))
      (refresh))
    
    (define/public (move-down)
      (set! view-rotx (- view-rotx 5.0))
      (refresh))

    (define/override (on-size width height)
      (with-gl-context
       (lambda ()
         ;; initialization
         (unless vbo-init

           (CUT_DEVICE_INIT) ; #t
           
           ;; generate cubins
           (let* ([cubin-name (generate-cubin "data/simpleGL.sm_10.cubin")]
                  [cuDevice (car (suda-init-devices 0))])
             
             ;; load kernel function
             (let-values ([(cuContext l-hfunc)
                           (load-kernel-driver cuDevice cubin-name #"kernel")])
               (set! cuFunction (car l-hfunc)))
             
             ;; glewInit
             (let* ([glew-v (glewInit)])
               (printf "return value of glew -> ~s: zero is right\n" glew-v))
             
             ; prepare vbo
             (set! vbo (create-vbo mesh_width mesh_height))
	     (printf "vbo is set\n")
           
             ; init cuda.
             (run-cuda vbo cuFunction)
           
             ;; flag reset
             (set! vbo-init #t)))
           
         (gl-viewport 0 0 width height)
         
         (refresh))))
    
    (define sec (current-seconds))
    (define frames 0)
    
    ; frustum constuction
    (define on-paint-frustum
      (lambda ()
        (let* ((left (* -1 size))
               (right size)         
               (top size)
               (bottom (* -1 size)))
          
          (if (> aspect 1) 
              (let* ((l (* left aspect)) (r (* right aspect)))
                (if is_perspective
                    (gl-frustum l r bottom top near far)
                    (gl-ortho (* left 10.0) (* right 10.0) 
                              (* bottom 10.0) (* top 10.0) near far)))
              (let* ((t (/ top aspect)) (b (/ bottom aspect)))
                (if is_perspective
                    (gl-frustum left right b t near far)
                    (gl-ortho (* left 10.0) (* right 10.0) 
                              (* top 10.0) (* bottom 10.0) near far)))))))
    
    (define/override (on-paint)    
      (with-gl-context
       (lambda ()
         
         (run-cuda vbo cuFunction)
         
         (gl-clear-color 0.2 0.2 0.2 1.0)
         (gl-clear 'color-buffer-bit 'depth-buffer-bit)
         
         (gl-shade-model 'smooth)
         (gl-disable 'depth-test)
         
         (gl-matrix-mode 'projection)
         (gl-load-identity)
         
         ;; frustum
         (on-paint-frustum)
         
         (gl-matrix-mode 'modelview)
         (gl-load-identity)
         
         ;; eye, light
         (let* ((look_x 0) (look_y 0) (look_z 0)
                           (up_x 0) (up_y 1) (up_z 0))
           
           ;; gluLookAt()
           (gl-look-at eye_x eye_y eye_z 
                       look_x look_y look_z 
                       up_x up_y up_z))
         
         
         (gl-light-v 'light0 'position (vector->gl-float-vector
                                        (vector eye_x eye_y (* 5 eye_z) 0.0)))
         (gl-light-v 'light1 'position (vector->gl-float-vector
                                        (vector eye_x eye_y (* -5 eye_z) 0.0)))
         (gl-light-v 'light2 'position (vector->gl-float-vector
                                        (vector eye_x (* 5 eye_y) eye_z 0.0)))
         (gl-light-v 'light3 'position (vector->gl-float-vector
                                        (vector eye_x (* -5 eye_y) eye_z 0.0)))
         (gl-light-v 'light4 'position (vector->gl-float-vector
                                        (vector (* 5 eye_x) eye_y eye_z 0.0)))
         (gl-light-v 'light5 'position (vector->gl-float-vector
                                        (vector (* -5 eye_x) eye_y eye_z 0.0)))
         
         (gl-disable 'lighting)
         (gl-enable 'light0)
         (gl-enable 'light1)
         (gl-enable 'light2)
         (gl-enable 'light3)
         (gl-enable 'light4)
         (gl-enable 'light5)
         
         (gl-push-matrix)
         (gl-rotate view-rotx 1.0 0.0 0.0)
         (gl-rotate view-roty 0.0 1.0 0.0)
         (gl-rotate view-rotz 0.0 0.0 1.0)
         
         ;; test scene 
         (glPolygonMode GL_FRONT_AND_BACK GL_LINE)
         (gl-push-attrib 'all-attrib-bits)
         
         (gl-disable 'lighting)
         (if box-flag 
             (begin (gl-color 1.0 0.0 0.0)
                    (set! box-flag #f))
             (begin (gl-color 1.0 0.0 1.0)
                    (set! box-flag #t)))
         
         (gl-push-matrix)
         (gl-scale 2.0 2.0 2.0)
         (gl-begin 'quads)
         (gl-normal 0.0 0.0 1.0)
         (gl-vertex 1.0 1.0 1.0)
         (gl-vertex -1.0 1.0 1.0)
         (gl-vertex -1.0 -1.0 1.0)
         (gl-vertex 1.0 -1.0 1.0)
         (gl-end)
         
         ;// render from the vbo
         (glBindBuffer GL_ARRAY_BUFFER vbo)
         (glVertexPointer 4 GL_FLOAT 0 0)
         
         (glEnableClientState GL_VERTEX_ARRAY)
         (gl-color 1.0 0.0 0.0)
         (glDrawArrays GL_POINTS 0 (* mesh_width mesh_height))
         (glDisableClientState GL_VERTEX_ARRAY)
         
         (gl-pop-matrix)
         (gl-pop-attrib)
         
         (set! anim (+ anim 1.0))
         
         (swap-gl-buffers)
         (refresh)
         ))
      
      (when step?
        (set! step? #f)
        (printf "Onpaint step\n")
        (queue-callback (lambda x (send this run)))))
    
    (super-instantiate () (style '(gl no-autoclear)))
    ))
  
  
;////////////////////////////////////////////////////////////////////////////////
;//! Run a simple test for CUDA
;////////////////////////////////////////////////////////////////////////////////
(define (runTest)

  (let* ([f (make-object frame% "opengl-interop" #f)]
         [c (instantiate simple-canvas% 
			 (f) 
			 (min-width window_width) 
			 (min-height window_height))])

    (let ([h0 (instantiate horizontal-panel% 
			    (f)
			    (alignment '(center center)) 
			    (stretchable-height #f))])
      (let ([h (instantiate horizontal-panel% 
			   (h0)
			   (alignment '(center center)))])
	(instantiate button% 
		     ("Left" h (lambda x (send c move-left)))
		     (stretchable-width #t))
	(let ([v (instantiate vertical-panel% 
			   (h)
			   (alignment '(center center)) 
			   (stretchable-width #f))])
	  (instantiate button% 
		       ("Up" v (lambda x (send c move-up)))
		       (stretchable-width #t))
	  (instantiate button% 
		       ("Down" v (lambda x (send c move-down)))
		       (stretchable-width #t))
	  (instantiate button% 
		       ("Right" h (lambda x (send c move-right)))
		       (stretchable-width #t)))))
      (send f show #t)
    ))


;////////////////////////////////////////////////////////////////////////////////
;// Program main
;////////////////////////////////////////////////////////////////////////////////
  (runTest)


)
