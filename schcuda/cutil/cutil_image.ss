#lang scheme
(require scheme/system
         scheme/foreign)
(unsafe!)

;////////////////////////////////////////////////////////////////////////////////
;//! Create cubin for kernel function:
;////////////////////////////////////////////////////////////////////////////////
(define (generate-shared-object)
  ;;(system "make")
  "libcutil_image")


(define cutil-lib (ffi-lib (generate-shared-object)));(ffi-lib "libcutil_image"))

(define-syntax define-foreign-lib
  (syntax-rules (->)
    ((_ lib name type ... ->)
     (define-foreign-lib lib name type ... -> _void))
    ((_ lib name type ...)
     (begin
       (provide name)
       (define name
         (get-ffi-obj 'name lib (_fun type ...) (unavailable 'name)))))))

(define-syntax define-foreign-cutil
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib cutil-lib args ...))))

(define (unavailable name)
  (printf "~s is n't available on the shared object\n" name))

;int
;cutLoadPPM4ub( const char* file, unsigned char** data,
;               unsigned int *w,unsigned int *h)
(define-foreign-cutil cutLoadPPM4ub
  (image_path : _bytes)
  (data : (_ptr o (_cpointer 'pdata)))
  (width : (_ptr o _uint32))
  (height : (_ptr o _uint32))
  -> (result : _int)
  -> (begin (printf "input string = ~s\n" image_path)
            (values result data width height)))
;
;(define (test)
;  (let-values ([(result data width height) (cutLoadPPM4ub #"data/lena.ppm")])
;    (printf "data:_cpointer = ~s\n" data)
;    (printf "width = ~s\n" width)
;    (printf "height = ~s\n" height)
;    (let ([size (+ 1 (* (ctype-sizeof _ubyte) (* width height)))])
;      (let loop ([counter 0])
;        (if (< counter size)
;            (begin 
;              (printf "val = ~s\t" (ptr-ref data _byte counter))
;              (loop (add1 counter)))
;            (printf "\n"))))))

