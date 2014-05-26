#lang scheme
; check srfi-25/utils.ss

;(define (list->values lst))
;

(define (foo x)
  (values x 2))

(call-with-values (lambda () (foo 'x)) list)
33333333
(define-syntax values->list
  (syntax-rules ()
    [(_ vals) (call-with-values (lambda () vals) list)]))

(values->list (values 1 2 4))
333333333


(define-syntax (list->values lststx)
  (syntax-case lststx (list)
    [(_ (list x ...)) #'(values x ...)]))

(list->values (list 1 2 3))

;(values 1 2  3)
;(list (lambda () (values 1 2  3 4 5 6)))
555555555555555555555

(call-with-values 
 (lambda () (list 1 2 3))
 values)