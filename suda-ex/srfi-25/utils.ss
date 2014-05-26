#lang scheme

(provide lst2lst->vals2vals vals2vals->lst2lst lst2any->vals2any)
;(define-syntax (list->values lststx)
;  (syntax-case lststx (list)
;    [(_ (list x ...)) #'(values x ...)]
;    [(_ '(x ...)) #'(values x ...)]
;    [(_ (x ...)) #'(values x ...)]
;    [(_ _) #'(printf "list->values - else case\n")]))

(define (list->values lst)
  (vector->values (list->vector lst)))

(define-syntax values->list
  (syntax-rules ()
    [(_ vals) (call-with-values (lambda () vals) list)]))

;; (list -> list) -> (values -> values)
(define (lst2lst->vals2vals f)
  (lambda xs
    (list->values (f xs))))

;; (values -> values) -> (list -> list)
(define (vals2vals->lst2lst g)
  (lambda (lst)
    (values->list (apply g lst))))

;; (list -> any) -> (values -> any)
(define (lst2any->vals2any h)
  (lambda xs
    (h xs)))
;
(define I (lambda xs (list->values xs))) ; Values -> Values
(I 1 2 3)
(define J (lambda (x) x))
(J (list 1 2 3))

(list->values (list 1 2 3))
((lst2lst->vals2vals J) 1 3 5)
;((vals2vals->lst2lst I) (list 1 3 5))

(define goo 
  (lambda (lst)
    (length lst)))
((lst2any->vals2any goo) 1 2 3 4 5 6 7 8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; examples
;; values -> values
(define (f-vv xs)
  (list (first xs) (last xs)))

(define f-ll (lst2lst->vals2vals f-vv))
(f-ll (list 1 2 3))

(define f-vv0 (vals2vals->lst2lst f-ll))
(f-vv0 (list 9 8 7 6))


(let* ([a (list 1 2 3 4)])
  (list->values a))
(list->values (list 4 5 6 7))
(list->values '(4 5 6 7))
(let* ([a (list 1 2 3)])
  (list->values a))

(define (f-ll0 lst)
  (list (first lst) (last lst)))

(f-ll0 '(-1 -2 -3 -4))