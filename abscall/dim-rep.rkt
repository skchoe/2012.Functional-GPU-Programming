#lang racket
(require ffi/unsafe)

(provide (all-defined-out))


(define-cstruct _size_type_2 ([w _uint]
                              [h _uint]))

#;(printf "~a\n" (ctype-sizeof _size-type-2))
#;(let* ([st (make-size_type_2 1 2)])
  (if (size_type_2? st)
      (printf "Yes:~a\n" st)
      (printf "No:~a\n" st))
  (printf "ST :~a, ~a, ptr-instnace:~a, type:~a, tag:~a, layout:~a\n align:~a, size:~a, compiler-size:~a" 
          (size_type_2-w st)
          (size_type_2-h st)
          st
          _size_type_2
          size_type_2-tag
          
          (ctype->layout _size_type_2-pointer)
          (ctype-alignof _size_type_2)
          (ctype-sizeof _size_type_2)
          (compiler-sizeof '*)))
