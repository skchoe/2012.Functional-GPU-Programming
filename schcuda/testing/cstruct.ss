#lang scheme
(require scheme/foreign)

(define-struct empty ())
(define a (make-empty))

(define (check-empty a)
  (if (empty? a) (printf "yes empty struct\n")
      (error "not empty struct\n")))

(check-empty a)

;
;(define-cstruct empty-t ())
;(define a-t (make-empty-T))
;
;(define (check-empty-t at)
;  (if (empty-t? at) (printf "yes empty type\n")
;      (error "not empty type\n")))

(define am (make-cstruct-type (list)))

(define al (_list-struct))
(define (check-empty-l al)
  (if (ctype? al)
      (printf "yes empty list type\n")
      (error "not empty list\n")))

(check-empty-l al)
  