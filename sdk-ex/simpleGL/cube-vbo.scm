(module cube-vbo scheme
(require mred
         mzlib/class
         scheme/foreign
         sgl
         sgl/gl
         sgl/gl-vectors
         sgl/gl-types
         "../../gl-1.5.scm"
         )

(unsafe!)
(define controls? #t)
  
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
           (set! v-vbo-id (glGenBuffers 3))

           (printf "vboid = ~s ~s ~s\n" (cvector-ref v-vbo-id 0) 
                   (cvector-ref v-vbo-id 1) (cvector-ref v-vbo-id 2))

           ; ffi sgl-1.5
           (glBindBuffer GL_ARRAY_BUFFER (cvector-ref v-vbo-id 0))
           (let-values ([(ptr ty sz) (cvector->ptr-set vertices)])
             (glBufferData GL_ARRAY_BUFFER
                           (* sz (ctype-sizeof ty))
                           ptr
                           GL_STATIC_DRAW))
           
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
         (gl-flush)))
      
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
