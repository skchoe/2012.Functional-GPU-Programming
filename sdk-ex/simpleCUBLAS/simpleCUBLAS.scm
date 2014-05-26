#lang scheme
(require scheme/foreign
         "../../schcuda/cublas_h.ss")

(unsafe!)
(define N 275)
(printf "INIT? ~s \n" (cublasInit))

(define alpha 1.0)
(define beta 0.0)
(define n2 (* N N))
(define _float-size (ctype-sizeof _float))

(define h_C_ref #f)

(define libsimple_gold (ffi-lib "libsimple_gold"))

(define simple_sgemm
  (get-ffi-obj 'simple_sgemm
               libsimple_gold
               (_fun (n : _int)
                     (alpha : _float)
                     (A : (_cpointer 'float))
                     (B : (_cpointer 'float))
                     (beta : _float)
                     (C : (_cpointer 'float))
                  -> _void -> C)
               (lambda () (error "sgemm not found\n"))))

; initialization
(let* ([h_A (malloc _float n2 'raw)]
       [h_B (malloc _float n2 'raw)]
       [h_C (malloc _float n2 'raw)])
  
  (cpointer-push-tag! h_A 'float)
  (cpointer-push-tag! h_B 'float)
  (cpointer-push-tag! h_C 'float)
  
  (for ([i (in-range n2)])
    (ptr-set! h_A _float i (random))
    (ptr-set! h_B _float i (random))
    (ptr-set! h_C _float i (random)))
  
  (let*-values ([(statusA d_A0) (cublasAlloc n2 _float-size)]
                [(statusB d_B0) (cublasAlloc n2 _float-size)]
                [(statusC d_C0) (cublasAlloc n2 _float-size)]
                
                [(statusSA d_A) (cublasSetVector n2 _float-size h_A 1 d_A0 1)]
                [(statusSB d_B) (cublasSetVector n2 _float-size h_B 1 d_B0 1)]
                [(statusSC d_C) (cublasSetVector n2 _float-size h_C 1 d_C0 1)])
    
    (cpointer-push-tag! d_A 'float)
    (cpointer-push-tag! d_B 'float)
    (cpointer-push-tag! d_C 'float)
    
    (printf "A ~s\n" statusA)
    (printf "B ~s\n" statusB)
    (printf "C ~s\n" statusC)
    (printf "SA ~s\n" statusSA)
    (printf "SB ~s\n" statusSB)
    (printf "SC ~s\n" statusSC)
    
    ; CPU CALL
    (let* ([h_C (simple_sgemm N alpha h_A h_B beta h_C)])
      (set! h_C_ref h_C))
    
    (printf "Error cleaning = ~s\n" (cublasGetError))
    
    ; CUBLAS CALL
    (let* ([d_cC (cublasSgemm (char->integer #\n);110
                              (char->integer #\n);110
                                               N N N alpha d_A N d_B N beta d_C N)])
      (printf "cleaning = ~s\n" (cublasGetError))
      (let* ([hr_C (malloc _float n2 'raw)])
        (let*-values ([(resultCC1 hr_C) (cublasGetVector n2 _float-size d_cC 1 hr_C 1)]
                      ; check result against reference
                      [(en rn) (for/fold ([err_norm 0.0]
                                          [ref_norm 0.0])
                                 ([i (in-range n2)])
                                 (let* ([d_v (ptr-ref hr_C _float i)]
                                        [h_v (ptr-ref h_C_ref _float i)]
                                        [diff (- h_v d_v)])
                                   (values (* diff diff) 
                                           (* h_v h_v))))])
          (printf "resultStatus of cublasGetVector = ~s\n" resultCC1)
          (if (< (sqrt rn) 1e-7) (error "fail\n") (printf "valid value\n"))
          (if (< (/ (sqrt en) (sqrt rn)) 1e-6) (printf "PASS\n") (printf "FAIL\n"))
          )
        (free hr_C))
      
      (cublasFree d_cC)
      (cublasFree d_C)
      (cublasFree d_B)
      (cublasFree d_A))
    )
  (free h_A)
  (free h_B)
  (free h_C)
  
  )
