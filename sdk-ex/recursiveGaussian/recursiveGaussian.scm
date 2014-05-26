(module recursiveGaussian scheme
(require scheme/foreign
         scheme/system
         mred
         mzlib/class
         sgl
         sgl/gl
         sgl/gl-vectors
         sgl/gl-types
         "../../schcuda/ffi-ext.ss"
         "../../schcuda/scuda.ss"
         "../../schcuda/suda-set-env.ss"
	 "../../schcuda/cutil/cutil_image.ss"
         "../../schcuda/gl-1.5.ss"
         "../../schcuda/cuda_h.ss"
         "../../schcuda/cuda_runtime_api_h.ss"
         "../../schcuda/cuda_gl_interop_h.ss"
         "../../schcuda/glew_h.ss"
         "../../schcuda/glext_h.ss")
  
(unsafe!)
  ;// global definitions
  (define BLOCK_DIM 16)
  
  (define window-width 512)
  (define window-height 512)
  
  (define pbo-init #f)
  (define pbo 0)
  (define texid 0)
  (define data-ptr '())
  (define box-flag #t)
  
  (define sigma 10.0)
  (define order 0)
  (define nthreads 64)
  
  (define d-transpose #f)
  (define d-recursiveGaussian-rgba #f)

  (define h_img #f)
  (define d_img #f)
  (define d_temp #f)
  
  (define width 0)
  (define height 0)
  
  (define (cpointer->cvector pdata size)
    (let ([cvtr (make-cvector _byte size)])
      (printf "input bytearray of size = ~s\n" size)
      (let loop ([counter 0])
        (if (< counter size)
            (begin 
              (cvector-set! cvtr counter (ptr-ref pdata _byte counter))
              (loop (add1 counter)))
            (begin 
              (printf "Pointer->Cvector conversion DONE.\n")
              cvtr)))))
  

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
  ;//! Create pbo: mesh w/h -> pbo
  ;////////////////////////////////////////////////////////////////////////////////
  (define (create-pbo h_img width height)
    (let* ([vb (cvector-ref (glGenBuffers 1) 0)]
           [size (* width height 4 (ctype-sizeof _byte))]
           [zr   (malloc _int 1)])

      (printf "pbo creation\n")
      (glBindBuffer GL_PIXEL_UNPACK_BUFFER_ARB vb)
      ;; only reserve the memory space by #f (data pointer)
      (glBufferData GL_PIXEL_UNPACK_BUFFER_ARB size h_img GL_STREAM_DRAW)
      (glBindBuffer GL_PIXEL_UNPACK_BUFFER_ARB 0)
      
      (printf "-PBOBuffer initialized\n")
            
      (printf "cudaGLInit successful: pbo ~s\n" vb)
      ;; cuGLRegisterBufferObject
      (let* ([resultr (cudaGLRegisterBufferObject vb)])
        (printf "resulting GLRegister = ~s\n" resultr)
        (if (equal? resultr 'cudaSuccess)
            (begin 
              (printf "Register pbo to Cuda: ~s\n" resultr)
              ;; create pixel for display
              (let ([texId (cvector-ref (glGenTextures 1) 0)])
                (set! texid texId)
                (glBindTexture GL_TEXTURE_2D texid)
                (glTexImage2D GL_TEXTURE_2D 0 GL_RGBA8 width height 0 
                              GL_RGBA GL_UNSIGNED_BYTE 
                              (make-cvector _ubyte 0))
                (glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_NEAREST)
                (glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_NEAREST)
                (glBindTexture GL_TEXTURE_2D 0)))
            (printf "Fail registering pbo to cuda: ~s\n" resultr))
        vb)
      ))
  
  ;////////////////////////////////////////////////////////////////////////////////
  ;//! Run the Cuda part of the computation
  ;////////////////////////////////////////////////////////////////////////////////
  (define (proc_gaussianFilter_rgba d_src d_dst
			      length nthreads 
			      a0 a1 a2 a3 
                              b1 b2 coefp coefn)
    (printf "~s, ~s, ~s, ~s; ~s ~s; coefp = ~s: coefn = ~s\n" 
            a0 a1 a2 a3 b1 b2 coefp coefn)
    (let ([ngrid (/ length nthreads)]
          [size (* width height 4 (ctype-sizeof _byte))])
      (cuFuncSetBlockShape d-recursiveGaussian-rgba nthreads 1 1)
      (cuParamSetv d-recursiveGaussian-rgba 0 d_src size)
      (cuParamSetv d-recursiveGaussian-rgba 4 d_dst size)
      (cuParamSeti d-recursiveGaussian-rgba 8 length)
      (cuParamSeti d-recursiveGaussian-rgba 12 length)
      (cuParamSetf d-recursiveGaussian-rgba 16 a0)
      (cuParamSetf d-recursiveGaussian-rgba 20 a1)
      (cuParamSetf d-recursiveGaussian-rgba 24 a2)
      (cuParamSetf d-recursiveGaussian-rgba 28 a3)
      (cuParamSetf d-recursiveGaussian-rgba 32 b1)
      (cuParamSetf d-recursiveGaussian-rgba 36 b2)
      (cuParamSetf d-recursiveGaussian-rgba 40 coefp)
      (cuParamSetf d-recursiveGaussian-rgba 44 coefn)
      (cuParamSetSize d-recursiveGaussian-rgba 48)
      (cuLaunchGrid d-recursiveGaussian-rgba ngrid 1)
      d_dst))
  
  (define (proc_transpose d_dst d_src width height)
    (let ([size (* width height 4 (ctype-sizeof _byte))])
      (cuFuncSetBlockShape d-transpose BLOCK_DIM BLOCK_DIM 1)
      (cuParamSetv d-transpose 0 d_dst size)
      (cuParamSetv d-transpose 4 d_src size)
      (cuParamSeti d-transpose 8 width)
      (cuParamSeti d-transpose 12 height)
      (cuParamSetSize d-transpose 16)
      (cuLaunchGrid d-transpose  (/ width BLOCK_DIM) (/ height BLOCK_DIM))
      d_dst))
  
  ;; input d_src, d_temp, width, height, sigma order
  ;; output pd_dest
  (define (gaussianFilterRGBA d_src pd_dest d_temp width height sigma order)
    (let* ([nsigma (if (< sigma 0.1) 0.1 sigma)]
           [alpha (/ 1.695 nsigma)]
           [ema (exp (- alpha))]
           [ema2 (exp (* alpha (- 2)))]
           [b1 (* ema (- 2))]
           [b2 ema2]
           
           [a0 0.0][a1 0.0][a2 0.0][a3 0.0][coefp 0.0][coefn 0.0])

      (cond
        [(equal? order 0)
         (let ([k (/ (* (- 1 ema) (- 1 ema)) (- (+ 1 (* 2 alpha ema)) ema2))])
           (set! a0 k) (set! a1 (* k (- alpha 1) ema)) 
           (set! a2 (* k (+ alpha 1) ema)) (set! a3 (* (- k) ema2)) )]
        [(equal? order 1)
         (let ([k (/ (* (- 1 ema) (- 1 ema)) ema)])
           (set! a0 (* k ema)) (set! a1 .0) (set! a2 (- a0)) (set! a3 .0) )]
        [(equal? order 2)
         (let* ([ea (exp (- alpha))]
                [k (- (/ (- ema2 1) (* 2 alpha ema)))]
                [kn (/ (* -2 (+ -1 (* 3 ea) (* -3 ea ea) (* ea ea ea)))
                       (+ (* 3 ea) 1 (* 3 ea ea) (* ea ea ea)))])
           (set! a0 kn) (set! a1 (* (- kn) (+ 1 (* k alpha)) ema)) 
           (set! a2 (* kn (- 1 (* k alpha)) ema)) (set! a3 (* (- kn) ema2))
           #f)]
        [else (begin (error "gaussianFilter: invalid order parameter!\n") )])
      
      ;(printf "Now call of kernels\n")
      (let* ([coefp (/ (+ a0 a1) (+ 1 b1 b2))]
             [coefn (/ (+ a2 a3) (+ 1 b1 b2))]
        
             [d_temp_inout
              (proc_gaussianFilter_rgba d_src d_temp width nthreads a0 a1 a2 a3 b1 b2 coefp coefn)]
             [d_dest_inout (proc_transpose pd_dest d_temp_inout width height)]
             [d_temp_out (proc_gaussianFilter_rgba d_dest_inout d_temp_inout
                                                   height nthreads a0 a1 a2 a3 b1 b2 coefp coefn)]
             [d_dest_out (proc_transpose d_dest_inout d_temp_out height width)])
        d_dest_out)
      ))
      
  (define (run-cuda pbo d-transp d-rcsGaussian)
    (let*-values ([(resultm d_result) (cudaGLMapBufferObject pbo)])
      (printf "Result of GLMapBuffer = ~s\n" resultm)
      (let* ([d_dest (gaussianFilterRGBA d_img d_result d_temp width height sigma order)])
        (cudaGLUnmapBufferObject pbo))))
  
  (define (benchmark iterations)
    #f)
  
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
      
      (define/override (on-char ch)
        (let* ([key (send ch get-key-code)])
          (printf "CHR EVENT: ~s\n" key)
          (cond
            [(or (equal? key #\=) (equal? key #\+)) (set! sigma (+ sigma 0.1))]
            [(equal? key #\-) (begin
                                (set! sigma (+ sigma -0.1))
                                (when (< sigma 0.0) (set! sigma 0.0)))]
            [(equal? key #\0) (set! order 0)]
            [(equal? key #\1) (begin (set! order 1) (set! sigma 0.5))]
            [(equal? key #\2) (begin (set! order 2) (set! sigma 0.5))]
            [else (printf "No operation of the key ~s" key)])
          (refresh)))
        
      (define/override (on-size width height)
        (with-gl-context
         (lambda ()
           
           ;; pbo init and registration to cuda
           (unless pbo-init
             ;; allocate device memory
             (let ([size (* (ctype-sizeof _uint) (* width height))])
               (let*-values ([(resultd pd_imgT) (cudaMalloc size)]
                             [(resultt pd_temp) (cudaMalloc size)]
                             [(resultc pd_img) 
                              (cudaMemcpy pd_imgT h_img size 'cudaMemcpyHostToDevice)])
                 (printf "result - malloc1 = ~s\n" resultd)
                 (printf "result - malloc2 = ~s\n" resultt)
                 (printf "result - memcpy = ~s\n" resultc)
                 (set! d_img pd_img)
                 (set! d_temp pd_temp)
                 
                 (when #f;runBenchmark
                   (begin (benchmark 100) (exit)))
                 
                 ;; glewInit
                 (let* ([glew-v (glewInit)])
                   (printf "return value of glew -> ~s\n" glew-v))
                 
                 ;; initialize pbo
                 (set! pbo (create-pbo h_img width height))
                 
                 (printf "Press '+' and '-' to change filter width\n")
                 (printf "0, 1, 2 - change filter order\n")
                 
                 ;; flag reset.
                 (set! pbo-init #t)
                 ;  (cutCheckErrorGL "simpleGLDrv.scm" 0)             
                 )))
                     
           (gl-viewport 0 0 width height)
           
           (glMatrixMode GL_MODELVIEW)
           (glLoadIdentity)

           (glMatrixMode GL_PROJECTION)
           (glLoadIdentity)
           (glOrtho 0.0 1.0 0.0 1.0 0.0 1.0)
           
           (refresh)
           )))
      
      (define sec (current-seconds))
      (define frames 0)

      ; frustum constuction
      (define on-paint-frustum
        (lambda ()
          (let* ([left (* -1 size)]
                 [right size]
                 [top size]
                 [bottom (* -1 size)])

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

           (printf "on-paint : pbo = ~s\n" pbo)
           (run-cuda pbo d-transpose d-recursiveGaussian-rgba)
   
           ;;load texture from pbo
           (glBindBuffer GL_PIXEL_UNPACK_BUFFER_ARB pbo)
           (glBindTexture GL_TEXTURE_2D texid)
           (glPixelStorei GL_UNPACK_ALIGNMENT 1)
           (glTexSubImage2D GL_TEXTURE_2D 0 0 0 width height 
                            GL_RGBA GL_UNSIGNED_BYTE (make-cvector _uint 0))
           (glBindBuffer GL_PIXEL_UNPACK_BUFFER_ARB 0)
           
           ;;display results
           (glClear GL_COLOR_BUFFER_BIT)
           
           (glEnable GL_TEXTURE_2D)
           (glDisable GL_DEPTH_TEST)
           
           (glBegin GL_QUADS)
           (glVertex2f 0 0) (glTexCoord2f 0 0)
           (glVertex2f 0 1) (glTexCoord2f 1 0)
           (glVertex2f 1 1) (glTexCoord2f 1 1)
           (glVertex2f 1 0) (glTexCoord2f 0 1)
           (glEnd)
           
           (glDisable GL_TEXTURE_2D)
           
           (swap-gl-buffers)
           (refresh)
           ))
        
        (when step?
          (set! step? #f)
          (printf "Onpaint step\n")
          (queue-callback (lambda x (send this run)))))
     
      (super-instantiate () (style '(gl no-autoclear)))
    ))
  
(define (load-data)
  
  ;;generate cubins -  initCuda
  (let* ([cubin-name (generate-cubin "data/recursiveGaussian.sm_10.cubin")]
         [cuDevice (suda-init-devices 0)]
         ;(CUT_DEVICE_INIT_DRV): same thing
         
         [cuModule (load-module-driver cuDevice cubin-name)])
         
         ;[cuModule (load-module-runtime cubin-name)])
    (if (not cuModule)
        (error "Module loading failed\n")
        (begin
          ;; load kernel function
          (let-values ([(status0 d_transpose) 
                        (cuModuleGetFunction cuModule #"d_transpose")]
                       [(status1 d_recursiveGaussian_rgba)
                        (cuModuleGetFunction cuModule #"d_recursiveGaussian_rgba")])
            (if (equal? status0 'CUDA_SUCCESS) 
                (set! d-transpose d_transpose)
                (error "d_transpose failed to be loaded\n"))
            (if (equal? status1 'CUDA_SUCCESS)
                (set! d-recursiveGaussian-rgba d_recursiveGaussian_rgba)
                (error "d_recursiveGaussian_rgba failed to be loaded\n"))
            
            
            ;; image data loading
            (let-values ([(result dt w h) (cutLoadPPM4ub #"data/lena.ppm")])
              (printf "data:_cpointer = ~s\n" dt)
              (printf "width = ~s\n" w)
              (printf "height = ~s\n" h)  
              
              (values dt w h)))))))
  
;////////////////////////////////////////////////////////////////////////////////
;//! Run a simple test for CUDA
;////////////////////////////////////////////////////////////////////////////////
(define (runClass width height)

  (let* ([f (make-object frame% "opengl-cuda-interop" #f)]
         [c (instantiate simple-canvas% 
			 (f) 
			 (min-width window-width) 
			 (min-height window-height))])

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
(define (main)
  (let-values ([(h_data w h) (load-data)])
    (set! h_img h_data)
    (set! width w)
    (set! height h)
    (runClass w h)))
  
(main)
)
  
