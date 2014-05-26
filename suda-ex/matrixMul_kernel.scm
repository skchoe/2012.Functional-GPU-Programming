#lang suda

(require typed-scheme)
(define: BLOCK_SIZE : Integer 4)   

#| These are from matrixMul_h
;// Matrix dimensions
;// (chosen as multiples of the thread block size for simplicity)
  (define WA (* 3 BLOCK_SIZE)) ;// Matrix A width
  (define HA (* 5 BLOCK_SIZE)) ;// Matrix A height
  (define WB (* 8 BLOCK_SIZE)) ;// Matrix B width
  (define HB WA)  ;// Matrix B height
  (define WC WB)  ;// Matrix C width 
  (define HC HA)  ;// Matrix C height
|#

#|
ISSUES OF TRANSLATION
ii) for/fold what to use to get for(int i = 0 ; i < range ; i++) ????

i) Update global state
   scheme: define/alloc global expression -> (set!) inside of proc.
   cu : define/alloc in device code, pass pointer to proc -> update by assignment inside of proc
  -> Solution
     : a.rename all local vars distict from upper scope -> all local vars has unique name
       b.lookahead inside of procedure (scope under current)
       c.find vars in covering scope(environment) and use it as argument w/ pointer type.

-> prerequisite: how to build environmnent
                 how to generate unique name.
|#
(define-struct: BlockIdx ((x : Integer) (y : Integer)))
(define-struct: ThreadIdx ((x : Integer) (y : Integer)))

(define: (matrixMul [C : (Vectorof Number)] 
                    [A : (Vectorof Number)]
                    [B : (Vectorof Number)]
                    [wA : Integer]
                    [wB : Integer]
                    
                    [blockIdx : BlockIdx]
                    [threadIdx : ThreadIdx]) : Void
  (let* (; Block index
         [bx (BlockIdx-x blockIdx)]
         [by (BlockIdx-y blockIdx)]
         ; Thread index
         [tx (ThreadIdx-x threadIdx)]
         [ty (ThreadIdx-y threadIdx)]
         ; Given Blkidx,
         ; index for submatrix A.
         [aBegin (* wA BLOCK_SIZE by)]
         [aEnd (- (+ wA aBegin) 1)]
         ;step size
         [aStep BLOCK_SIZE]
         
         ; index for submatrix B.
         [bBegin (* BLOCK_SIZE  bx)]
         [bStep (* wB BLOCK_SIZE)]
         
         ; cSub
         [Csub 0])
    (for*/fold 
        ([a aBegin] [b bBegin]) 
        ([(a b) (values (+ a aStep) (+ b bStep))] #:when (<= aEnd))
        (let* (;store submatrix of A, B respectively
               [As (build-array (shape 0 BLOCK_SIZE 0 BLOCK_SIZE) 0.0)]
               [bS (build-array (shape 0 BLOCK_SIZE 0 BLOCK_SIZE) 0.0)]
               
               ;prepare indices for cpng submatrix into separate matrix
               [a-ref (+ a (* wA ty) tx)]
               [b-ref (+ b (* wB ty) tx)])
          (copy-Array-elts (array-set! As ty tx) (array-ref A a-ref))
          (copy-array-elts (array-set! Bs ty tx) (array-ref B b-ref))
          
          (__syncthreads)
          
          ;; matrix Multiplication
          (for/fold 
              ([k 0])
              ([k (+ k 1)] #:when (< k BLOCK_SIZE))
            (set! Csub (+ Csub (* (array-ref As ty k) (array-ref Bs k tx)))))
          
          ;;Synch thread again.
          (__syncthreads)))
    
    (let ([c (+ (* wb BLOCK_SIZE by) (BLOCK_SIZE bx))])
      (vector-set! C (+ c (* wB ty) tx) Csub))))