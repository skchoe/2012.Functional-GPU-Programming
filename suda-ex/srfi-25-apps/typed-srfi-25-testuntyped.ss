#lang scheme

(require "srfi-25/array.ss")
(include "srfi-25/example/play.scm")


(define shap_ (shape 0 3  0 3))
(define shap2_ (shape 0 1  0 2 0 2))
(play shap_)

(define Arr1 (make-array shap_ 100))
(define Arr2 (make-array shap2_ 200))

(define Arr3 (make-array shap_ 300))
(define Arr4 (make-array shap_ 400))
(define (proc_ a) (+ 1 a))
(define new_Arr (array-map (shape 0 1 0 2) proc_ Arr3 Arr4))
(play new_Arr)
