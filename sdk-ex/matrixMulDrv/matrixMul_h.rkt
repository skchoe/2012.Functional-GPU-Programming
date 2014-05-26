(module matrixMul_h mzscheme
  (require "../../schcuda/cuda_h.ss"
           "../../schcuda/cutil_h.ss"
           "../../abscall/dim-rep.rkt"

           ffi/unsafe)
  
  ; // Thread block size
  (provide (all-defined))
  
  ;// Matrix dimensions
  ;// (chosen as multiples of the thread block size for simplicity)
;  (define BLOCK_SIZE 4)
;  (define WA (* 1 BLOCK_SIZE)) ;// Matrix A width
;  (define HA (* 1 BLOCK_SIZE)) ;// Matrix A height
;  (define WB (* 1 BLOCK_SIZE)) ;// Matrix B width  
  (define BLOCK_SIZE 1)
  (define WA (* 2 BLOCK_SIZE)) ;// Matrix A width
  (define HA (* 2 BLOCK_SIZE)) ;// Matrix A height
  (define WB (* 4 BLOCK_SIZE)) ;// Matrix B width
  (define HB WA) ;// Matrix B height
  (define WC WB) ;// Matrix C width 
  (define HC HA)) ;// Matrix C height
  