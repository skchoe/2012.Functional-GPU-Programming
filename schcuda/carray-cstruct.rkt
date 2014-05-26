#lang racket

;; carray : array interface based on cvector with type definition in Racket/ffi
;;          stores data in linear vector type.
;; shape is a list of positive integer to show length of each dimension.
;; utility function is for creating array and accessing individual element.
;; 
;; Seungkeol Choe, 1/26/2011.


(require ffi/unsafe
         ffi/cvector)

(provide (all-defined-out))



;; def: struct carray
; rank : _int 
; shape : _pointer? (to integers that shows range of index)
; elem-vector : pointer?
; Question how to get type of element?
(define-cstruct _carray ([rank _int] [shape _pointer] [type _symbol] [elem-vector _pointer]))


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

(define (less-than-all-alloc? lst0 ptr size type)
  (let* ([lst1 (alloc->list ptr size type)])
    (less-than-all? lst0 lst1)))

; cv : cvector?
; output value is multiplied value of all element.
(define (mult-all-cvelt cv)
  (for/fold ([ans 1])
    ([i (in-range (cvector-length cv))])
    (* ans (cvector-ref cv i))))

;; rank : integer? size of shp
;; shp is allocation of integer
(define (mult-all-alloc-elt size shp type)
  (for/fold ([ans 1])
    ([i (in-range size)])
    (begin #;(printf "TY:~a, MULT: ~a, elt:~a, ans:~a\n" type i (ptr-ref shp type i) ans)
           (* ans (ptr-ref shp type i)))))

;; lst : input list
;; type: type of elt in lst
(define (list->malloc lst type [mode 'atomic])
  (let* ([len (length lst)]
         [pt (malloc type len mode)])
    (for/list ([elt lst]
               [i (in-range len)])
      (ptr-set! pt type i (list-ref lst i)))
    pt))

;; alloc -> cvector -> list
;; ptr : cpointer?
;; length : integer? length of elt in ptr
;; type : type of elt
(define (alloc->list ptr length type)
  (let* ([cv (make-cvector type length)])
    (for ([i (in-range length)])
      (cvector-set! cv i (ptr-ref ptr type i)))
    (cvector->list cv)))

(define (layout->ctype sym)
  (match sym
    ['int8 _int8]['uint8 _uint8]['int16 _int16]['uint16 _uint16]['int32 _int32]
    ['int64 _int64]['uint32 _uint32]['uint64 _uint64]['float _float]['double _double]
    ['bool _bool]['void _void]['pointer _pointer]['fpointer _fpointer]
    ['bytes _bytes]['string/ucs-4 _string/ucs-4]['string/utf-16 _string/utf-16]
    [else #f]))

;(layout->ctype 'int8)
;(layout->ctype 'pointer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rng ... -> mem-alled by cpointer? through constraint checking
(define (shape . l-rng)
  (shape/list l-rng))

(define (shape/list l-rng)
  (let ([len (length l-rng)])
    #;(printf "rank = ~a\n" len)
    (cond 
      [(or (> len 3) (< len 1)) (error "Array shape need 1~3 argument because # of args is rank of array\n")]
      [(not (positive-all? l-rng)) (error "Size value need to be bigger than zero\n")]
      [(not (fixed-type-all? l-rng)) (error "Size must be fixed\n")]
      [else (list->malloc l-rng _int)])))
  

;; Alternative of (make-carray)
;; Given shp, size is determined. 
;; val is a list to be inserted.
;; val over the size? -> cropped
;; val under the size? -> filled with zeros.
(define (build-carray rank shp type . val)
  (build-carray/list rank shp type val))

(define (build-carray/list rank shp type l-val)  
  (let* ([num-elt (mult-all-alloc-elt rank shp _int)]
         
         ; allocation
         [cv (begin
               #;(printf "num_melt=~a\n" num-elt)
               (malloc type num-elt 'atomic))]
         
         ; input size
         [num-input (length l-val)])
    (if (< num-elt num-input)
        ; count by num-elt (cv capacity)
        (for ([k (in-range num-elt)])
          (ptr-set! cv type k (list-ref l-val k)))
        ; count by num-input (input list capacity)
        (for ([k (in-range num-elt)])
          (if (< k num-input)
              (ptr-set! cv type k (list-ref l-val k))
              (ptr-set! cv type k (if (inexact? (list-ref l-val 0)) 0.0 0)))))
    (make-carray rank shp (ctype->layout type) cv)))

;; accessors for individual element.
(define (carray-ref carr . l-idx)
  (carray-ref/list carr l-idx))

(define (carray-ref/list carr l-idx)
  (let* ([rank (carray-rank carr)]
         [shp (carray-shape carr)]
         [type (layout->ctype (carray-type carr))]
         [v (carray-elem-vector carr)])
    #;(printf "Rank:~a, shp:~a, typename:~a, v:~a\n"
            rank shp (carray-type carr) v)
    (cond 
      [(not (non-negative-all? l-idx)) (error "Some index is negative\n")]
      [(not (equal? (length l-idx) rank)) (error "Given index is not fit to rank of array\n")]
      [(not (less-than-all-alloc? l-idx shp rank _int)) (error "Given index is not in range\n")]
      [else 
       (case rank
         ['1 (ptr-ref v type (list-ref l-idx 0))] ; rank 1
         ['2 (ptr-ref v type (+ (* (ptr-ref shp _int 0) (list-ref l-idx 1)) 
                               (list-ref l-idx 0)))]
         ['3 (ptr-ref v type (+ (* (ptr-ref shp _int 0) (ptr-ref shp _int 1) (list-ref l-idx 2))
                               (* (ptr-ref shp _int 0) (list-ref l-idx 1))
                               (list-ref l-idx 0)))]
         [else (error "Carray support upto rank=3\n")])])))
         





