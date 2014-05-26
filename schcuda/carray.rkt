#lang racket

;; carray : array interface based on cvector with type definition in Racket/ffi
;;          stores data in linear vector type.
;; shape is a list of positive integer to show length of each dimension.
;; utility function is for creating array and accessing individual element.
;; 
;; Seungkeol Choe, 1/26/2011.


(require ffi/unsafe
         ffi/cvector)

;; def: struct carray
; shape : list?
; elem-vector : cvector?
(define-struct carray (shape elem-vector))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; checker's for constraints of shape and indices
(define (positive-all? lst)
  (for/and ([i lst])
    #;(printf "pos-check - elt:~a\n" i)
      (< 0 i)))

(define (non-negative-all? lst)
  (for/and ([i lst])
    #;(printf "non-neg-check - elt:~a\n" i)
      (<= 0 i)))

(define (fixed-type-all? lst)
  (for/and ([i lst])
    #;(printf "type-check - elt:~a\n" i)
           (exact-positive-integer? i)))

;; compare elementwise w/ less than
(define (less-than-all? lst0 lst1)
  (for/and
      ([elt (map (lambda (x0 x1)
                   (< x0 x1))
                 lst0 lst1)])
    (equal? #t elt)))


(define (mult-all-cvelt cv)
  (for/fold ([ans 1])
    ([i (in-range (length cv))])
    (* ans (list-ref cv i))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; rng ... -> (list rng ...) through constraint checking
(define (shape . l-rng)
  (let ([len (length l-rng)])
    #;(printf "rank = ~a\n" len)
    (cond 
      [(or (> len 3) (< len 1)) (error "Array shape need 1~3 argument because # of args is rank of array\n")]
      [(not (positive-all? l-rng)) (error "Size value need to be bigger than zero\n")]
      [(not (fixed-type-all? l-rng)) (error "Size must be fixed\n")]
      [else l-rng])))
(define shp (shape 1 2 5))

;; Alternative of (make-carray)
;; Given shp, size is determined. 
;; val is a list to be inserted.
;; val over the size? -> cropped
;; val under the size? -> filled with zeros.
(define (build-carray shp type . val)
  (let* ([rank (length shp)]
         [num-elt (mult-all-cvelt shp)]
         
         ; allocation
         [cv (make-cvector type num-elt)]
         
         ; input size
         [num-input (length val)])
    (if (< num-elt num-input)
        ; count by num-elt (cv capacity)
        (for ([k (in-range num-elt)])
          (cvector-set! cv k (list-ref val k)))
        ; count by num-input (input list capacity)
        (for ([k (in-range num-elt)])
          (if (< k num-input)
              (cvector-set! cv k (list-ref val k))
              (cvector-set! cv k (if (inexact? (list-ref val 0)) 0.0 0)))))
    (make-carray shp cv)))

;; accessors for individual element.
(define (carray-ref carr l-idx)
  (let* ([shp (carray-shape carr)]
         [v (carray-elem-vector carr)])
    (cond 
      [(not (non-negative-all? l-idx)) (error "Some index is negative\n")]
      [(not (equal? (length l-idx) (length shp))) (error "Given index is not fit to rank of array\n")]
      [(not (less-than-all? l-idx shp)) (error "Given index is not in range\n")]
      [else 
       (case (length shp)
         ['1 (cvector-ref v (list-ref l-idx 0))] ; rank 1
         ['2 (cvector-ref v (+ (* (cvector-ref shp 0) (list-ref l-idx 1)) 
                               (list-ref l-idx 0)))]
         ['3 (cvector-ref v (+ (* (cvector-ref shp 0) (cvector-ref shp 1) (list-ref l-idx 2))
                               (* (cvector-ref shp 0) (list-ref l-idx 1))
                               (list-ref l-idx 0)))]
         [else (error "Carray support upto rank=3\n")])])))
         


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Playing with carray.
(equal? #t (less-than-all? (list 2 3 ) (list 3 4)))

;; cstruct, accessor test when field is cvector or cpointer
(printf "_____\n")
(ctype-sizeof _pointer)
(define ttt-ptr (_cpointer "ttt" _int64)) 
(ctype-sizeof ttt-ptr)

;;; This struct definition contains _cvector whose pointer is stored in field, content exists outside of struct (unsafe)
;;; so we got error in accessing the _cvector field.
;(define-cstruct _A ([i _int] [v _cvector]))
;(define cv (make-cvector _int 2))
;(define cv-ptr (cvector-ptr cv))
;(cpointer-push-tag! cv-ptr "cv-ptr")
;(cpointer-tag cv-ptr)
;
;(define test-struct (make-A 10 cv))
;A-tag
;(A-i test-struct)
;;; ERRRORRR not access possible cvector defined outside.
;(A-v test-struct)
;(cpointer? (ptr-ref (A-v test-struct) _pointer 0))


;; How about (_list-struct) function which marshals contents of fields.
(define _carray-lst (_list-struct _int _cvector)) ; which stores rank and cvector only.
(ctype? _carray-lst)



#|
;; 1D carray
(define ar1 (build-carray (shape 4) _float 1.0 1.0 2.0 3.0))
(define cv0 (make-cvector _int 1))
(cvector-set! cv0 0 1)
(cvector? cv0)
(cvector-ref cv0 0)
(carray? (make-carray (make-cvector _int 1) cv0))
(carray? ar1)
carray-tag
(cvector? (carray-shape ar1))


(define ptr (carray-elem-vector ar1))
(equal? 3.0 (ptr-ref ptr _float 3))
(equal? 2.0 (carray-ref ar1 (list 2)))

;; 2D carray
(define ar2 (build-carray (shape 2 3) 
                          _float 
                          1.0 3.0 
                          4.0 6.0 
                          2.0 4.0))
(cvector->list (carray-elem-vector ar2))
(equal? 2.0 (ptr-ref (cvector-ptr (carray-elem-vector ar2)) _float 4))

(carray-shape ar2)
(carray-elem-vector ar2)
(equal? 6.0 (carray-ref ar2 (list 1 1)))

;; 3D carray
(define ar3 (build-carray (shape 2 3 2)
                          _float
                          1.0 3.0 
                          4.0 6.0 
                          2.0 4.0
                          -1.0 -3.0 
                          -4.0 -6.0 
                          -2.0 -4.0))
(cvector->list (carray-elem-vector ar3))
(equal? -4.0 (carray-ref ar3 (list 1 2 1)))
|#