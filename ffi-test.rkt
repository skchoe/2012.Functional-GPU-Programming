#lang racket

(require ffi/unsafe)

;; helper functions in gl.ss  
(define (unavailable name)
  (lambda ()
    (lambda x
      (error name "unavailable on this system"))))

(define-syntax define-foreign-lib
  (syntax-rules (->)
    ((_ lib name type ... ->)
     (define-foreign-lib lib name type ... -> _void))
    ((_ lib name type ...)
     (begin
       (provide name)
       (define name
         (get-ffi-obj 'name lib (_fun type ...) (unavailable 'name)))))))

(define stm-lib (ffi-lib "/home/skchoe/project-gpu/lib/libstm.so"))

(define-syntax define-foreign-stm
  (syntax-rules ()
    [(_ args ...)
     (define-foreign-lib stm-lib args ...)]))

(define-

