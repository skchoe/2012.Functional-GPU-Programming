(module matrixMul_h mzscheme

  (provide (all-defined))

  (define BLOCK_SIZE 1) ;  16 was too big.
  
;// Matrix dimensions
;// (chosen as multiples of the thread block size for simplicity)
  (define WA (* 3 BLOCK_SIZE)) ;// Matrix A width
  (define HA (* 5 BLOCK_SIZE)) ;// Matrix A height
  (define WB (* 8 BLOCK_SIZE)) ;// Matrix B width
  (define HB WA)  ;// Matrix B height
  (define WC WB)  ;// Matrix C width 
  (define HC HA)  ;// Matrix C height
)

