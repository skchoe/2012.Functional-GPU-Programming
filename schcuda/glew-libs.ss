(module glew-libs mzscheme
  (provide (all-defined))
  (require scheme/foreign)
  (unsafe!)
  ;;-----------------------------------------------------------------------------
(define glew-lib (case (system-type)
                   [(windows) (ffi-lib "glew32")] 
                   ; windows: currently unsupported
                   [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcuda")] 
                   ; macosx: currently unsupported
                   [else (ffi-lib (string-append (path->string (find-system-path 'home-dir)) 
                                                 "/local/glew/lib/libGLEW"))]))
  
(define-syntax define-foreign-lib
  (syntax-rules (->)
    ((_ lib name type ... ->)
     (define-foreign-lib lib name type ... -> _void))
    ((_ lib name type ...)
     (begin
       (provide name)
       (define name
         (get-ffi-obj 'name lib (_fun type ...) (unavailable 'name)))
       ;(printf "~s: defined\n" 'name)
))))

(define-syntax define-foreign-glew
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib glew-lib args ...))))

  (define (unavailable name)
    (lambda ()
      (lambda x
        (error name "unavailable on this system")))))
