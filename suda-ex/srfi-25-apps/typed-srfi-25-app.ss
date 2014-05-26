#lang typed/racket

(require "typed-srfi-25.ss")

;#;(printf "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n")
;(a1111 2)
;(define: sh : Array (shape 0 2 0 3))
;(define: Arr : Array (make-array sh  0))
;(define: A1111 : Integer (a1111 2))
;(define: shp : Array
;   (shape 0 2 0 3))
;
;shp
;(define: cuatro-array : Array
;  (array shp
;         'uno 'dos 'tres
;         'cuatro 'cinco 'seis))
;        
;(array-ref cuatro-array (vector 1 0))
;
(define: a : Array 
  (array (shape 4 7 1 2 2 3) 3 1 4))

(define vector--elt (list (array-ref a (vector 4 1 2))
                        (array-ref a (vector 5 1 2))
                        (array-ref a (vector 6 1 2))))
;
;(equal? '(3 1 4)
;        vector--elt);(array (shape 0 3) 6 1 2)))) ; here 3 is the rank of the array
;
;(define: as : Array (array-shape a))
;(array->list a)
;(array-rank a)
;(array-length a 0)
;(array-length a 1)
;(array-length a 2)
;(array-size a)
;
(define: sA : Array (shape 1 3 3 4 5 6))
(define: A : Array (make-array sA 1))
;
;(equal? 5
;        (array-ref (shape 0 1 4 5 2 3) 
;                   (vector 1 1))) ; 5
;
;(define: jj : Integer
;  (let-values ([(a b) (values 1 2)])
;    (+ a b)))

;(define: K : Integer
;  (let: ([proc : (Integer -> Integer) (lambda (x) x)])
;    (proc 1)))

(define: i_4 : Array
  (let: ([i : Array 
            (make-array
             (shape 0 4 0 4) 0)]
         [proc : ((Listof Integer) -> (Listof Integer))
               (lambda: ([lst : (Listof Integer)])
                        (list (car lst) (car lst)))])
        (let: ([d : Array (share-array* i (shape 0 4) proc)])
              (do ([k 0 (+ k 1)])
                ((= k 4))
                (array-set! d (vector k) 1))
              i)))
(printf "i_4\n")






;(array->list i_4)
;(define: B : Array
;  (tabulate-array*
;   (shape 0 4 0 4)
;   (lambda (lst)
;     (let* ([f (car lst)]
;            [sA (cadr lst)])
;     (if (= f s) 1 0)))))
;(array->list B)
;(or (array-equal? i_4 B)
;    (error "failed to build i_4"))
;(printf "i_4 vs tabulate-array\n")

;(define: C : Array
;  (transpose i_4))
;(array->list C)
;(printf "C transpose of i_4\n")

;;; Try a three dimensional transpose. This will also exercise matrix
;;; multiplication.
;(define: threed123 : Array
;  (array (shape 0 1 0 2 0 3)
;         'a 'b 'c
;         'd 'e 'f))
;(printf "threed123\n")

;(define: threed312 : Array
;  (array (shape 0 3 0 1 0 2)
;         'a 'd
;         'b 'e
;         'c 'f))
;(printf "threed312\n")
;
;
;(define: rot231 : (Listof Integer) 
;  (begin
;    (printf "begin rot231\n")
;    (list 1 2 0)
;    (printf "end rot231\n")
;    (list 21)))
;
;  ;; 0 1 0
;  ;; 0 0 1
;  ;; 1 0 0
;;(or (array-equal? threed123
;;                  (transpose threed312 rot231))
;;    (error "failed to transpose three dimensions"))
;;(printf "traspose done\n")
;
;;(array-ref (array-shape s) (vector 1))
;(shape-for-each* (array-shape sA) (lambda: ([lst : (Listof Integer)]) (add1 (car lst))))
;(array-for-each-index* sA (lambda: ([lst : (Listof Integer)]) (add1 (car lst))))
;
;;(define ta (tabulate-array* (array-shape s) (lambda (lst) 
;;                                              (let* ([x (car lst)]
;;                                                      [y (cadr lst)])
;;                                                 (+ x y)))))
;;(equal? '(0 1 1 2 2 3) (array->list ta))
;;
;;(define: ta-array : (Vectorof Integer) (vector 1 3))
;;(define: (ta-proc-v [iv : (Vectorof Integer)]) : Any 
;;  (vector-ref iv 0)); (lambda (x y) (+ x y))
;;(define: (ta-proc-a [ia : Array]) : Any 
;;  (vector 0 0)); (lambda (x y) (+ x y))
;;(array->list (array-shape A))
;;(tabulate-array!-a (array-shape A) ta-proc-a (array-shape A))
;;(equal? '(ta-proc ta-proc ta-proc ta-proc ta-proc ta-proc) (array->list ta!))
;
;;(array-retabulate! As (array-shape s) (lambda: ([vec : (Vectorof Any)]) (vector-ref vec 0)) 'e0 'e1)
;
(array->list sA)
(define: A0 : Array (array sA '10 '20))
(array->list A0)
(define: r : Integer (array-rank A0))
(array-start A0 0)
(array-end A0 1)
(array-start A0 2)
(array-ref A0 (vector (array-start A0 0) (array-start A0 1) (array-start A0 2)))
(array-set! A0 (vector (array-start A0 0) (array-start A0 1) (array-start A0 2)) '30)
(array-ref A0 (vector (array-start A0 0) (array-start A0 1) (array-start A0 2)))
;"__________________________"
;(+ 1 2)
;(define: I : (Integer -> Integer)
;  (lambda (x) (+ 0 x)))
;(define: proc-ll : ((Listof Integer) -> (Listof Integer))
;  (lambda (is) (map I is)))
;
;(proc-ll (list 1 2 3))
;(define: S : Array
;  (share-array* A0 (shape 1 2 3 4 5 6) proc-ll))
;
;(define: shap_ : Array (shape 0 1 0 2 0 3))
;(define: Arr1 : Array (make-array shap_ 100))
;(define: Arr2 : Array (make-array shap_ 200))
;(define: Arr3 : Array (make-array shap_ 300))
;(define: (proc_ [a : All-Number]) : All-Number  (+ 1 a))
;(define: new_Arr : Array (array-map (array-shape Arr1) proc_ Arr1))
;(play new_Arr)
;
;(array-map! new_Arr (array-shape new_Arr) proc_ new_Arr)
;(play new_Arr)
;(define: l : (Integer -> Integer)
;  (lambda (x) (+ 1 x)))
;(define: proc-l : ((Listof Integer) -> (Listof Integer))
;  (lambda (is) (map l is)))
;(define: O : Array (make-array (shape 0 2 10 40) 1))
;(play O)
;;(define sO (share-array* O (shape 0 1 1 2) proc-l))
;;(play sO)
;(define sAP (share-array/prefix O 1))
;(play sAP)
;(define sAO (share-array/origin O 0 -20))
;(play sAO)
;(play (array-shape sAO))
;(play (array-shape sAP))
;(define aa0 (make-array (shape 0 2 0 2) 0))
;(define aa1 (make-array (shape 0 3 0 2) 1))
;(define sAA (array-append 0 aa0 aa1))
;(play sAA)
;
;(define s4T (make-array (shape 0 2 0 2 0 2) -1))
;(define sT (transpose s4T))
;(play sT)
;"__________________________"
;(define sS (share-nths sT 1 2))
;(play sS)