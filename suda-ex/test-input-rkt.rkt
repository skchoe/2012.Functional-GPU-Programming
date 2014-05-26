#lang suda
;;
;;; int len = (length lst);
;;; int A[len];
;;; for(int i = 0 ; i < len ; i++)
;;; A[i] = (list-ref lst i);
;;(define: A : (Listof Integer) (quote (1 2)))
;(define: a : Integer 1)
;(set! a 2)
;;

;(define: (add2 [in : Integer]) : Integer
;  (if #f (+ in 1) (+ in 2)))
;(define: (let-ex) : Integer
;  (let: ([a1 : Integer 1][b1 : Integer 2][c1 : Integer 4])
;        (add1 a1)
;        (+ 1 1)))

;__________________________________________________________
;void vec(int* v, int* a){
;   *a = v[0];
;}

;(define: (vec [v : (Vectorof Integer)]) : Integer
;  (vector-ref v 0))
;(vec (vector 1 2 3))
;(: a (Vectorof Integer))
;(define a (vector 1 2 3 4 5))
;
;(vector-ref a 1)
;
;(vector-set! a (let: ([b : Exact-Nonnegative-Integer 1]) b) (add1 100))

(define-struct: Float3 ([x : Float] [y : Float] [z : Float]))