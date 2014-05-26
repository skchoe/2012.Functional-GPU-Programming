#lang racket
(require ffi/unsafe
         ffi/cvector
         sgl
         (except-in sgl/gl-types make-gl-vector-type))

(provide (all-defined-out)); get-unsigned-type get-signed-type))

(define (get-unsigned-type size)
  (case size
    ((1) _uint8)
    ((2) _uint16)
    ((4) _uint32)
    ((8) _uint64)
    (else (error 'get-unsigned-type (format "no ~a byte unsigned type" size)))))

(define (get-signed-type size)
  (case size
    ((1) _sint8)
    ((2) _sint16)
    ((4) _sint32)
    ((8) _sint64)
    (else (error 'get-signed-type (format "no ~a byte signed type" size)))))

(define (make-gl-vector-type t)
  (make-ctype _cvector
              (lambda (sval)
                (unless (cvector? sval)
                  (raise-type-error 'Scheme->C "cvector" sval))
                (unless (eq? (cvector-type sval) t)
                  (error 'Scheme->C "wrong kind of cvector"))
                sval)
              #f))

(define _gl-intptr   _gl-int)
(define _gl-sizeiptr _gl-sizei)
(define _gl-ptr _pointer)

(define _gl-sizeiv (make-gl-vector-type _gl-sizei))
(define _gl-voidvv (make-gl-vector-type _gl-voidv))