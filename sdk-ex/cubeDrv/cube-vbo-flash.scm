(module cube-vbo-flash scheme
(require mred
         mzlib/class
         scheme/foreign
         sgl
         sgl/gl
         sgl/gl-vectors
         sgl/gl-types
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss"
	 "../../schcuda/gl-1.5.ss"
         "../../schcuda/ffi-ext.ss"
         "../../schcuda/cutil_h.ss"
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cudaGL_h.ss"
         "../../schcuda/cuda_gl_interop_h.ss"
         "../../schcuda/vector_types_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/glew_h.ss"
         "../../schcuda/cutil_gl_error_h.ss")

(unsafe!)
(define controls? #t)
(define flag #t)  
(define vbo-init #f)
  
(define v-vbo-id '())
;// cube ///////////////////////////////////////////////////////////////////////
;//    v6----- v5
;//   /|      /|
;//  v1------v0|
;//  | |     | |
;//  | |v7---|-|v4
;//  |/      |/
;//  v2------v3


  ;; vertex coordinates array
  (define vertices
    (cvector _gl-float
             1.0 1.0 1.0  -1.0 1.0 1.0  -1.0 -1.0 1.0  1.0 -1.0 1.0       ;0-1-2-3
             1.0 -1.0 -1.0  -1.0 -1.0 -1.0  -1.0 1.0 -1.0  1.0 1.0 -1.0   ;4-7-6-5
             -1.0 -1.0 -1.0  1.0 -1.0 -1.0  1.0 -1.0 1.0  -1.0 -1.0 1.0   ;7-4-3-2
             -1.0 1.0 1.0  -1.0 1.0 -1.0  -1.0 -1.0 -1.0  -1.0 -1.0 1.0   ;1-6-7-2
             1.0 1.0 1.0  1.0 1.0 -1.0  -1.0 1.0 -1.0  -1.0 1.0 1.0 ;0-5-6-1
             1.0 1.0 1.0  1.0 -1.0 1.0  1.0 -1.0 -1.0  1.0 1.0 -1.0 ;0-3-4-5
             )  
    ) 
  ;;normal array
  (define normals 
    (cvector _gl-float 
             0 0 1   0 0 1   0 0 1   0 0 1              ; v0-v1-v2-v3
             0  0 -1  0  0 -1  0  0 -1  0  0 -1         ; v4-v7-v6-v5
             0 -1  0  0 -1  0  0 -1  0  0 -1  0         ; v7-v4-v3-v2
             -1 0 0  -1 0 0 -1 0 0  -1 0 0              ; v1-v6-v7-v2
             0 1 0   0 1 0   0 1 0   0 1 0              ; v0-v5-v6-v1
             1 0 0   1 0 0   1 0 0   1 0 0              ; v0-v3-v4-v5
             ))
  ;;color array
  (define colors
    (cvector _gl-float 
             1 1 1  1 1 0  1 0 0  1 0 1              ; v0-v1-v2-v3
             0 0 1  0 0 0  0 1 0  0 1 1              ; v4-v7-v6-v5
             0 0 0  0 0 1  1 0 1  1 0 0              ; v7-v4-v3-v2
             1 1 0  0 1 0  0 0 0  1 0 0              ; v1-v6-v7-v2
             1 1 1  0 1 1  0 1 0  1 1 0              ; v0-v5-v6-v1
             1 1 1  1 0 1  0 0 1  0 1 1              ; v0-v3-v4-v5
             ))
  
  (define cvector->ptr-set
    (lambda (cv)
      (let* ([_type (cvector-type cv)]
             [length (cvector-length cv)]
             [ptr (malloc _type length)])
        (for ([i (in-range length)])
          (ptr-set! ptr _type i (cvector-ref cv i)))
        (values ptr _type (* (ctype-sizeof _type) length)))))
  
  (define print-pointer
    (lambda (ptr _type length)
      (for ([i (in-range length)])
        (printf "~s\t" (ptr-ref ptr _type i)))))

  
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

  (define cuFunction #f)
  
(define flagG 0)
(define (run-cuda vbo func)
  (let*-values
      ([(resultm dv size) (cuGLMapBufferObject vbo)])

    (printf "run-cuda vbo, size = ~s ~s ~s\n" resultm dv size)

    (let* ([block-size-x 8]
           [block-size-y 9] ; 72 vertices
           [shared-size (* block-size-x (* block-size-y (* 3 (ctype-sizeof _float))))]
           [grid-w 1];(/ block-size block-size)]
           [grid-h 1];(/ block-size block-size)]
           [lst-offs (offsets-ctype (list _uint _uint _float _float _uint _uint))])
      
      (let*-values ([(resultm0 dim-dx) (cuMemAlloc (ctype-sizeof _int))]
                    [(resultm1 dim-dy) (cuMemAlloc (ctype-sizeof _int))]

                    [(resultbs func)
                     ;#therad x,y dir in blk
                     (cuFuncSetBlockShape func block-size-x block-size-y 1)]

                    [(results func)
                     (cuFuncSetSharedSize func shared-size)]
                    [(result0 func) (cuParamSeti func 0 dv)]
                    [(result1 func) (cuParamSeti func (list-ref lst-offs 0) block-size-x)]
                    [(result2 func) (cuParamSetf func (list-ref lst-offs 1) (random))]
                    [(result3 func) (cuParamSetf func (list-ref lst-offs 2)
                                                 (if (equal? flagG 0) 
                                                     (begin (set! flagG 1) 0.5) 
                                                     (begin (set! flagG 0) 2.0)))]
                    [(result30 func) (cuParamSeti func (list-ref lst-offs 3) dim-dx)]
                    [(result31 func) (cuParamSeti func (list-ref lst-offs 4) dim-dy)]
                    [(result4 func) (cuParamSetSize func (list-ref lst-offs 5))]
                    )
        
        (printf "MemAllocon Device = ~s ~s\n" resultm0 resultm1)
        (printf "RESULT_Param ~s ~s ~s ~s ~s\n" result0 result1 result2 result3  result4)
        
        (let* ([resultl (cuLaunchGrid func grid-w grid-h)]
               
               ;[dim-hx (malloc _int (ctype-sizeof _int) 'raw)]
               ;[dim-hy (malloc _int (ctype-sizeof _int) 'raw)]
               )
          
;          (let*-values ([(resultC dh-ptrx) (cuMemcpyDtoH dim-hx dim-dx (ctype-sizeof _int))]
;                        [(resultD dh-ptry) (cuMemcpyDtoH dim-hy dim-dy (ctype-sizeof _int))])
;            (printf "MemcpyD2H = ~s ~s\n" resultC resultD)
;            (printf "threadIdx.x = ~s : threadIdx.y = ~s\n" 
;                    (ptr-ref dh-ptrx _int 0) (ptr-ref dh-ptry _int 0)))
            
          (let* ([resultu (cuGLUnmapBufferObject vbo)])
            (printf "RESULT(cuLaunchGrid):~s\n" resultl)
            (printf "REsULT(UNMAPBO = ~s\n" resultu))
            #f)))))

  ;;class gears-canvas
  (define gears-canvas%
  (class* canvas% ()

    (inherit refresh with-gl-context swap-gl-buffers get-parent)

    (define view-rotx 0.0)
    (define view-roty 0.0)
    (define view-rotz 0.0)

    (define step? #f)

    (define/public (run)
      (set! step? #t)
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

;    (define cv (make-cvector _gl-float 0))
;    (display (cvector-length cv))
;    (define cl (cvector->list cv))
;    (if (null? cl) (display 'null) (display 'not_null))
    
    (define/override (on-size width height)
      (with-gl-context
       (lambda ()

         (unless vbo-init
           
           ;;generate cubins -  initCuda
           (let* ([cubin-name (generate-cubin "data/cube_kernel.sm_10.cubin")]
                  [cuDevice (car (suda-init-devices 0))])
             ;(CUT_DEVICE_INIT_DRV): same thing

             ;; load kernel function
             (let-values ([(cuContext l-hfunc)
                           (load-kernel-driver cuDevice cubin-name #"kernel")])
               (set! cuFunction (car l-hfunc)))
             
             ;; glewInit
             (let* ([glew-v (glewInit)])
               (printf "return value of glew -> ~s\n" glew-v))
             #f)
           
           (set! v-vbo-id (glGenBuffers 3))

           (printf "vboid = ~s ~s ~s\n" (cvector-ref v-vbo-id 0) 
                   (cvector-ref v-vbo-id 1) (cvector-ref v-vbo-id 2))

           ; ffi sgl-1.5
           (glBindBuffer GL_ARRAY_BUFFER (cvector-ref v-vbo-id 0))
           (let-values ([(ptr ty sz) (cvector->ptr-set vertices)])
             (glBufferData GL_ARRAY_BUFFER
                           (* sz (ctype-sizeof ty))
                           ptr
                           GL_DYNAMIC_DRAW))
           
           (glBindBuffer GL_ARRAY_BUFFER (cvector-ref v-vbo-id 1))
           (let-values ([(ptr ty sz) (cvector->ptr-set normals)])
             (glBufferData GL_ARRAY_BUFFER
                           (* sz (ctype-sizeof ty))
                           ptr
                           GL_STATIC_DRAW))

           (glBindBuffer GL_ARRAY_BUFFER (cvector-ref v-vbo-id 2))
           (let-values ([(ptr ty sz) (cvector->ptr-set colors)])
             (glBufferData GL_ARRAY_BUFFER
                           (* sz (ctype-sizeof ty))
                           ptr
                           GL_STATIC_DRAW))
           
           (glBindBuffer GL_ARRAY_BUFFER 0)
           
           ;; cuGLInit
           (let* ([resulti (cuGLInit)])
             (if (not (equal? resulti 'CUDA_SUCCESS))
                 
                 (printf "cudaGLInit fails\n")
                 
                 (begin 
                   (printf "cudaGLInit successful\n")
                   ;; cuGLRegisterBufferObject
                   (let* ([resultr0 (cuGLRegisterBufferObject 
                                     (cvector-ref v-vbo-id 0))]
;                          [resultr1 (cuGLRegisterBufferObject 
;                                     (cvector-ref v-vbo-id 1))]
;                          [resultr2 (cuGLRegisterBufferObject 
;                                     (cvector-ref v-vbo-id 2))]
                          )
                     (printf "resulting GLRegister = ~s\n" resultr0)
;                     (printf "resulting GLRegister = ~s\n" resultr1)
;                     (printf "resulting GLRegister = ~s\n" resultr2)
                     
                     (if (equal? resultr0 'CUDA_SUCCESS)
                         (begin (printf "Register VBO to Cuda: ~s\n" resultr0)
                                #|(cuCtxSynchronize)|#
                                
                                (run-cuda (cvector-ref v-vbo-id 0) cuFunction)
                                
                                )
                         (printf "Fail registering VBO to cuda: ~s\n" resultr0))
;                   #|(cuCtxSynchronize)|#)
           
;                     (if (equal? resultr1 'CUDA_SUCCESS)
;                         (begin (printf "Register VBO1 to Cuda: ~s\n" resultr1)
;                                #|(cuCtxSynchronize)|#)
;                         (printf "Fail registering VBO1 to cuda: ~s\n" resultr1))
;;                   #|(cuCtxSynchronize)|#)))
;
;                     (if (equal? resultr2 'CUDA_SUCCESS)
;                         (begin (printf "Register VBO2 to Cuda: ~s\n" resultr2)
;                                #|(cuCtxSynchronize)|#)
;                         (printf "Fail registering VBO2 to cuda: ~s\n" resultr2))
;;                   #|(cuCtxSynchronize)|#)
                     ))))
           
           (set! vbo-init #t))
         
         (gl-viewport 0 0 width height)
         ))
      
      (refresh))

    (define sec (current-seconds))
    (define frames 0)

    ; frustum constuction
    (define on-paint-frustum
      (lambda ()
        (let* (
               (left (* -1 size))
               (right size)         
               (top size)
               (bottom (* -1 size))
               )
          
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
         
         (run-cuda (cvector-ref v-vbo-id 0) cuFunction)
         
         (gl-clear-color 0.0 0.0 0.0 0.0)
         (gl-clear 'color-buffer-bit 'depth-buffer-bit)
         
         (gl-shade-model 'smooth)
         (gl-enable 'depth-test)
         
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
         ;(gl-enable 'cull-face)
         (gl-enable 'lighting)
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
         
         (glPolygonMode GL_FRONT_AND_BACK GL_LINE)
         (gl-push-attrib 'all-attrib-bits)
         (gl-disable 'lighting)
         (if flag 
             (begin (gl-color 1.0 0.0 0.0 1.0)
                    (set! flag #f))
             (begin (gl-color 0.0 1.0 0.0 1.0)
                    (set! flag #t)))
         (gl-push-matrix)
         (gl-scale 2.0 2.0 2.0)
         (gl-begin 'quads)
         (gl-normal 0.0 0.0 1.0)
         (gl-vertex 1.0 1.0 1.0)
         (gl-vertex -1.0 1.0 1.0)
         (gl-vertex -1.0 -1.0 1.0)
         (gl-vertex 1.0 -1.0 1.0)
         (gl-end)
         (gl-pop-matrix)
         (gl-pop-attrib)
         
         (glPolygonMode GL_FRONT_AND_BACK GL_FILL)
         
         (gl-push-attrib 'all-attrib-bits)
         (gl-color-material 'front-and-back 'ambient-and-diffuse)
         (gl-enable 'color-material)
         
         (glEnableClientState GL_VERTEX_ARRAY)
         (glEnableClientState GL_NORMAL_ARRAY)           
         (glEnableClientState GL_COLOR_ARRAY)
         
         (unless (null? v-vbo-id) 
           (begin 
             (printf "in on-point: vboid = ~s ~s ~s\n" (cvector-ref v-vbo-id 0)
                     (cvector-ref v-vbo-id 1) (cvector-ref v-vbo-id 2))
             
             ; ffi sgl-1.5
             (glBindBuffer GL_ARRAY_BUFFER (cvector-ref v-vbo-id 1))
             (glNormalPointer GL_FLOAT 0 0)
             
             (glBindBuffer GL_ARRAY_BUFFER (cvector-ref v-vbo-id 2))
             (glColorPointer 3 GL_FLOAT 0 0)
             
             (glBindBuffer GL_ARRAY_BUFFER (cvector-ref v-vbo-id 0))
             (glVertexPointer 3 GL_FLOAT 0 0)
             
             (glDrawArrays GL_QUADS 0 24))
           )
         (glDisableClientState GL_VERTEX_ARRAY)
         (glDisableClientState GL_COLOR_ARRAY)
         (glDisableClientState GL_NORMAL_ARRAY)
         
         (glBindBuffer GL_ARRAY_BUFFER 0)
         
         (gl-pop-attrib)
         (gl-pop-matrix)
         
         (swap-gl-buffers)
         (refresh)
         ))
      
      (when step?
	  (set! step? #f)
	  (queue-callback (lambda x (send this run)))))
     
    (super-instantiate () (style '(gl no-autoclear)))
    ))

(define (f)
  (let* ((f (make-object frame% "gears-bufferobject" #f))
         (c (instantiate gears-canvas% (f) (min-width 300) (min-height 300))))
    (when controls?
      (let ((h (instantiate horizontal-panel% (f)
                 (alignment '(center center)) (stretchable-height #f))))
        (let ((h (instantiate horizontal-panel% (h)
                   (alignment '(center center)))))
          (instantiate button% ("Left" h (lambda x (send c move-left)))
            (stretchable-width #t))
          (let ((v (instantiate vertical-panel% (h)
                     (alignment '(center center)) (stretchable-width #f))))
            (instantiate button% ("Up" v (lambda x (send c move-up)))
              (stretchable-width #t))
            (instantiate button% ("Down" v (lambda x (send c move-down)))
              (stretchable-width #t)))
          (instantiate button% ("Right" h (lambda x (send c move-right)))
            (stretchable-width #t)))))
    (send f show #t)))
(f)
)
;;eof
