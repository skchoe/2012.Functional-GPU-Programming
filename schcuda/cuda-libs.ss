(module cuda-libs mzscheme
  (provide (all-defined))

  (require scheme/foreign)
(unsafe!)
;;-----------------------------------------------------------------------------
(define cuda-lib (case (system-type)
                   [(windows) (ffi-lib "nvcuda")] 
                   ; windows: currently unsupported
                   [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcuda")] 
                   ; macosx: currently unsupported
                   [else (ffi-lib "libcuda")]))
  
(define cudart-lib (case (system-type)
                   [(windows) (ffi-lib "cudart")] 
                   ; windows: currently unsupported
                   [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcudart")] 
                   ; macosx: currently unsupported
                   [else (ffi-lib "libcudart")]))

(define cutil-lib (case (system-type)
                    [(windows) (ffi-lib "cutil")] 
                    ; windows: currently unsupported
                    [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcudart")] 
                    ; macosx: currently unsupported
                    [else (ffi-lib "libcutil_x86_64")]))
  
(define cudafft-lib (case (system-type)
                   [(windows) (ffi-lib "cufft")] 
                   ; windows: currently unsupported
                   [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcufft")] 
                   ; macosx: currently unsupported
                   [else (ffi-lib "libcufft")]))

(define cudablas-lib (case (system-type)
                   [(windows) (ffi-lib "cublas")] 
                   ; windows: currently unsupported
                   [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcublas")] 
                   ; macosx: currently unsupported
                   [else (ffi-lib "libcublas")]))

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

(define-syntax define-foreign-cuda
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib cuda-lib args ...))))

(define-syntax define-foreign-cudart
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib cudart-lib args ...))))

(define-syntax define-foreign-cutil
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib cutil-lib args ...))))
    
(define-syntax define-foreign-cufft
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib cudafft-lib args ...))))
  
(define-syntax define-foreign-cublas
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib cudablas-lib args ...))))
  
(define (unavailable name)
  (lambda ()
    (lambda x
      (error name "unavailable on this system"))))
  
  #|
  /****************************************************************************/
   *              c-related types                                             *
  /****************************************************************************/
  |#
  
  ;; size_t
  (provide _size_t)
  (define _size_t (make-ctype _int #f #f))
  
  (provide _size_t-ptr)
  (define _size_t-ptr (_ptr o _size_t))
 
  ;; int
  (provide _pint)
  (define _pint (make-ctype _int #f #f))
  
  
  )
