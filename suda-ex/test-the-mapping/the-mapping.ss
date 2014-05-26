#lang scheme
(require syntax/boundmap)

(provide (all-defined-out))

(define the-mapping (make-module-identifier-mapping))

(define (mp-put! k v)
  (module-identifier-mapping-put! the-mapping k v))

(define (mp-get k)
  (module-identifier-mapping-get the-mapping k))

(define (mp-view)
  (module-identifier-mapping-for-each 
   the-mapping 
   (lambda (id idv) (printf "Module-id-mapping :~s, ~s -> ~s\n" id idv
                        (module-identifier-mapping-get the-mapping id)))))