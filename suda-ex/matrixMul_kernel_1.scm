#lang typed-scheme

(require typed-scheme)
(define: BLOCK_SIZE : Integer 4)

; These are from matrixMul_h
;// Matrix dimensions
;// (chosen as multiples of the thread block size for simplicity)
(define: WA : Integer (* 3 BLOCK_SIZE)) ;// Matrix A width
(define: HA : Integer (* 5 BLOCK_SIZE)) ;// Matrix A height
(define: WB : Integer (* 8 BLOCK_SIZE)) ;// Matrix B width
(define: HB : Integer WA)  ;// Matrix B height
(define: WC : Integer WB)  ;// Matrix C width 
(define: HC : Integer HA)  ;// Matrix C height



(: matrix-mul-func 
   (Integer Integer Integer 
            (Listof Number) (Listof Number)    
            Keyword Keyword    
            ->    
            (Listof umber)))
(define (matrix-mul-func wa ha wb A B C #:tq G
                         block-size #:bix bbi-x #:biy bbi-y #:kix kki-x #:kiy kki-y)
  (let* 
      ; Given Blkidx,
      ; index for submatrix A.
      ([aBegin (* wa block-size bbi-y)]
       [aEnd (- (+ wa aBegin) 1)]
       ;step size
       [aStep block-size]
       
       ; index for submatrix B.
       [bBegin (* block-size  bbi-x)]
       [bEnd (- (+ wb bBegin) 1)]
       [bStep (* wb block-size)]
       
       ; cSub
       [Csub 0])
    (for*/fold 
      ([a aBegin] [b bBegin]) 
      ([(a b) (values (in-range aBegin aEnd aStep)
                      (in-range bBegin bEnd bStep))])
      (let* (;store submatrix of A, B respectively
             [As (build-array (shape 0 block-size 0 block-size) 0.0)]
             [bS (build-array (shape 0 block-size 0 block-size) 0.0)]
             
             ;prepare indices for cpng submatrix into separate matrix
             [a-ref (+ a (* wA tti-y) tti-x)]
             [b-ref (+ b (* wB tti-y) tti-x)])
        (copy-Array-elts (array-set! As tti-y tti-x) (array-ref A a-ref))
        (copy-array-elts (array-set! Bs tti-y tti-x) (array-ref B b-ref))
        
        (__syncthreads)
        
        ;; matrix Multiplication
        (for/fold 
            ([k 0])
          ([k (+ k 1)] #:when (< k block-size))
          (set! Csub (+ Csub (* (array-ref As ty k) (array-ref Bs k tx)))))
        
        ;;Synch thread again.
        (__syncthreads)))
    
    (let ([c (+ (* wb block-size bbi-y) (block-size bbi-x))])
      (vector-set! C (+ c (* wB tti-y) tti-x) Csub))))

;; currently one dimensional array is used for 2D matrix
(marix-mul-func WA HA WB A B C
                #:tq 'G
                4
                #:bix bbi-x #:biy bbi-y  
                #:kix kki-x #:kiy kki-y)