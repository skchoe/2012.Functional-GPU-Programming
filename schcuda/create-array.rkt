#lang racket/base

(require ffi/unsafe
         "../abscall/dim-rep.rkt" ; _size_type_2 is defined
         "scuda.ss"
         )
(provide (all-defined-out))

(define (identity-element c-ty)
  (if (or (eqv? c-ty _uint) (eqv? c-ty _int)) 0
      0.0))

(define (create-input-array st2 c-ty)
  (create-array st2 c-ty #:rdm #f #:nit #f))

(define (create-init-array st2 c-ty)
  (create-array st2 c-ty #:rdm #f #:nit #t))

(define (create-rdm-array st2 c-ty)
  (create-array st2 c-ty #:rdm #t #:nit #f))

(define (create-array st2 c-ty #:rdm [rdm #t] #:nit [nt #f])
  (let* ([cnt (* (size_type_2-w st2) 
                 (size_type_2-h st2))]
         ;; inputs(sender) for the array of floats
         [h_array
          (let* ([mat (malloc c-ty cnt)]) 
            (printf "*cuParamSetv vec:~a   w/size=~a bytes\n" 
                    mat (* (ctype-sizeof c-ty) cnt))
            ;; adding value to mat.
            (for ([i (in-range cnt)])
              (cond [nt (ptr-set! mat c-ty i (identity-element c-ty))]
                    [rdm (ptr-set! mat c-ty i (rdm))]
                    [else (ptr-set! mat c-ty i 
                                    (if (or (eqv? c-ty _uint) (eqv? c-ty _int))
                                        i
                                        (* 0.1 (+ 1.0 i))))]))
            (print-f64vector-cpointer mat c-ty cnt)
            mat)])
    (list h_array st2)))

#|
(create-input-array (make-size_type_2 2 2) _float)

(define l
  (create-array (make-size_type_2 2 2) _float #:rdm #f #:nit #f))
(let ([p (car l)])
  (for ([i (in-range 4)])
    (printf "\t~a" (ptr-ref p _float i))))
(newline)

(let ([st2 (cadr l)])
  (printf "~a, ~a\n" (size_type_2-w st2) (size_type_2-h st2)))
|#