#lang racket

(require ffi/unsafe
         "../../../schcuda/cuda_h.ss"
         "../../../schcuda/scuda.ss"
         "../common/check-utils.rkt")

(provide alloc-and-launch)
 
#;(define (alloc-and-launch l-hfunc h_ht-const num_var num_uconst size_elt)
  (define NUM_ARG 9)
  (define BLOCK_SIZE_X NUM_ARG);(+ 10 num_var))
  (define BLOCK_SIZE_Y 1);(+ 10 num_uconst))
  (define BLOCK_SIZE_Z 1)
  (define GRID_SIZE 1)
  (let*-values 
      ; kernel functions:cuFunction?
      ([(init_constraints_kernel solve_constraints_kernel) (values (car l-hfunc) (cadr l-hfunc))]
       
       ;; memory size for each element(constraint, work, analysis)
       [(mem_size) (* num_var num_uconst size_elt)]
       [(init-byte) (char->integer #\space)]
       
       ;; sizeof types
       [(sizeof-ptr) (compiler-sizeof '*)]
       [(alignof-ptr) (ctype-alignof _pointer)]
       [(alignof-int) (ctype-alignof _int)]
       [(v) (printf "sizeof_ptr=~a, alignof_ptr=~a\n" sizeof-ptr alignof-ptr)]
       
       [(offset)
        (for/fold 
            ;; starting offset
            ([offset 0])
          ([i (in-range NUM_ARG)])
          ; (1) input size 1 - num_var of d_ht-const
          (let*-values ([(offset-new) (align-up offset alignof-int)]
                        [(result_m init_constraints_kernel) (cuParamSeti init_constraints_kernel offset-new i)]
                        [(result0 free0 total0) (cuMemGetInfo)])
            (printf "CUMemGetInfo (~a)= r:~a, fr:~a tot:~a, __ _offset:~a\n" i result0 free0 total0 offset-new)
            (printf "*************cuParamSeti:Count offset:~a num_var:~a\n" offset-new num_var)
            (printf "[[[[ctype-alignof_int:~a, compiler-sizeof_int:~a, offset(~a):~a\n" 
                    (ctype-alignof _int) (compiler-sizeof 'int) i offset-new)
            (+ offset-new (compiler-sizeof 'int))
            ))]
       
       [(init-byte) (char->integer #\space)]
       [(mem_size) (* (ctype-sizeof _int) NUM_ARG)]
       
       ;; test - byteset in
       [(h_byteset) (malloc mem_size)]
       [(v) (begin 
              (for ([i (in-range mem_size)]) 
                (let* ([content i]);(char->integer (car (string->list (number->string i))))])
                  (printf "~a:~a\t" i content)
                  (ptr-set! h_byteset _byte i content)))
              (newline))]
       [(result_bs d_byteset) (cuMemAlloc mem_size)]
       [(result_bs1 d_byteset) (cuMemcpyHtoD d_byteset h_byteset mem_size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_n init_constraints_kernel)
        (cuParamSetv init_constraints_kernel offset d_byteset mem_size)]
       [(offset) (+ offset (compiler-sizeof '*))]
       
       ;; byte_return return value
       [(result_v d_br) (cuMemAlloc mem_size)]
       [(result_v1 d_br) (cuMemsetD8 d_br 0 mem_size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_vn init_constraints_kernel)
        (cuParamSetv init_constraints_kernel offset d_br mem_size)]
       [(offset) (+ offset (compiler-sizeof '*))]
       
       ;; barg return value
       [(result_h d_arg) (cuMemAlloc mem_size)]
       [(result_h1 d_arg) (cuMemsetD8 d_arg init-byte mem_size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_n init_constraints_kernel)
        (cuParamSetv init_constraints_kernel offset d_arg mem_size)]
       [(offset) (+ offset (compiler-sizeof '*))]
       
       ;; launch init_constraint_kernel
       [(result_b init_constraints_kernel)
        (cuFuncSetBlockShape init_constraints_kernel BLOCK_SIZE_X BLOCK_SIZE_Y BLOCK_SIZE_Z)]
       [(result_n init_constraints_kernel) (cuParamSetSize init_constraints_kernel offset)]
       [(result_o kernel) (cuLaunch init_constraints_kernel)]
       
       ;; copy to h_arg
       [(h_br) (malloc mem_size)]
       [(result_dbr h_br) (cuMemcpyDtoH h_br d_br mem_size)]
       [(result_dbr1) (cuMemFree d_br)]
       
       ;; copy to h_arg
       [(h_arg) (malloc mem_size)]
       [(result_dd h_arg) (cuMemcpyDtoH h_arg d_arg mem_size)]
       [(result_de) (cuMemFree d_arg)])
    
    (printf "result h:~a, h1:~a, n:~a\n" result_h result_h1 result_n)
    (printf "results v:~a, v1:~a vn:~a\n" result_v result_v1 result_vn)
    (printf "results dd:~a, de:~a\n" result_dd result_de)
    (printf "results b:~a, n:~a o:~a\n" result_b result_n result_o)
    (printf "result_dbr:~a, ~a\n" result_dbr result_dbr1)
    
    (for ([i mem_size])
      (let ([v (ptr-ref h_br _byte i)])
        (printf "arg returned(byte):~a--~a\n" i v)))

  (for ([i NUM_ARG])
      (let ([v (ptr-ref h_arg _int i)])
        (printf "arg returned(int):~a--~a\n" i v)))
    
    h_ht-const))
  
(define (init-constraints ic-kernel h_ht-const num_var num_uconst size_elt bg-struct)
  
  (let*-values
      (;; memory size for each element(constraint, work, analysis)
       [(mem_size) (* num_var num_uconst size_elt)]
       [(init-byte) (char->integer #\space)]
       
       ;; starting offset
       [(offset) 0]
       
       ;; sizeof types
       [(alignof-int) (ctype-alignof _int)]
       [(sizeof-int) (ctype-sizeof _int)]
       [(sizeof-ptr) (compiler-sizeof '*)]
       [(alignof-ptr) (ctype-alignof _pointer)]
       
       ;; (1) d_ht-const <--- h_ht-const
       [(result_j d_ht-const) (cuMemAlloc mem_size)]
       [(result_k d_ht-const) (cuMemcpyHtoD d_ht-const h_ht-const mem_size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_l ic-kernel) 
        (cuParamSetv ic-kernel offset d_ht-const sizeof-ptr)]
       [(result0 free0 total0) (cuMemGetInfo)]
       [(v) (printf "CUMemGetInfo (1)= r:~a, fr:~a tot:~a\n" result0 free0 total0)]
       [(offset) (+ offset sizeof-ptr)]
       
       ; (2) input size 1 - num_var of d_ht-const
       [(offset) (align-up offset alignof-int)]
       [(result_m ic-kernel) (cuParamSeti ic-kernel offset num_var)]
       [(offset) (+ offset sizeof-int)]
       
       ; (3) input size 2 - num_uconst of d_ht-const
       [(offset) (align-up offset alignof-int)]
       [(result_m ic-kernel) (cuParamSeti ic-kernel offset num_uconst)]
       [(offset) (+ offset sizeof-int)]
       
       ; (4) input size 3 - size_elt of d_ht-const
       [(offset) (align-up offset alignof-int)]
       [(result_m ic-kernel) (cuParamSeti ic-kernel offset size_elt)]
       [(offset) (+ offset sizeof-int)]

       ;; (5) d_work
       [(result_h d_work) (cuMemAlloc mem_size)]
       [(result_h1 d_work) (cuMemsetD8 d_work init-byte mem_size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_i ic-kernel) 
        (cuParamSetv ic-kernel offset d_work sizeof-ptr)]
       [(v) (printf "CPY result for d_work:~a\n" result_i)]
       [(offset) (+ offset sizeof-ptr)]

       ;; (6) d_analysis
       [(result_h2 d_analysis) (cuMemAlloc mem_size)]
       [(result_h3 d_analysis) (cuMemsetD8 d_analysis init-byte mem_size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_i1 ic-kernel) 
        (cuParamSetv ic-kernel offset d_analysis sizeof-ptr)]
       [(v) (printf "CPY result for d_analysis:~a\n" result_i1)]
       [(offset) (+ offset sizeof-ptr)]
     
       ;; (7) d_empty_const
       [(byte-size) (ctype-sizeof _byte)]
       [(h_empty_const) 
        (let ([h_empty_const (malloc byte-size)]) (ptr-set! h_empty_const _byte 1) h_empty_const)]
       [(result_1 d_empty_const) (cuMemAlloc byte-size)]
       [(result_2 d_empty_const) (cuMemcpyHtoD d_empty_const h_empty_const byte-size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_4 ic-kernel) (cuParamSetv ic-kernel offset d_empty_const sizeof-ptr)]
       [(v) (printf "CPY result for d_empty_const:~a\n" result_4)]
       [(offset) (+ offset sizeof-ptr)]

       [(result_n ic-kernel) (cuParamSetSize ic-kernel offset)]

       ;; LAUNCH init_constraint_kernel
       [(result_b ic-kernel)
        (cuFuncSetBlockShape ic-kernel 
                             (block_grid-bx bg-struct)
                             (block_grid-by bg-struct)
                             (block_grid-bz bg-struct))]
       [(result_o) (cuLaunchGrid ic-kernel (block_grid-gx bg-struct) (block_grid-gy bg-struct))]
       [(v) (printf "Launch ic-kernel result :~a\n" result_o)]
       
       ;; h_empty_const
       [(h_empty_const) (malloc (ctype-sizeof _byte))]
       [(v) (ptr-set! h_empty_const _byte 1)]
       [(result_cpy h_empty_const) (cuMemcpyDtoH h_empty_const d_empty_const (ctype-sizeof _byte))])
       
    (printf "LAUNCH results b:~a, n:~a o:~a\n" result_b result_n result_o)
    (check-work-analysis num_var num_uconst size_elt d_work d_analysis)

    (values d_ht-const d_work d_analysis h_empty_const)))


(define (check-work-analysis num_var num_uconst size_elt d_work d_analysis)
  ;; check the output of init-constraints-kernel.
  (let*-values
      (;; h_work
       [(mem_size) (* num_var num_uconst size_elt)]
       [(h_work) (malloc mem_size)]
       [(result_ch h_work) (cuMemcpyDtoH h_work d_work mem_size)]

       ;; h_analysis
       [(h_analysis) (malloc mem_size)]
       [(result_t h_analysis) (cuMemcpyDtoH h_analysis d_analysis mem_size)])
    
    (printf "CPY RESULTs:cpyDtoH for work:~a\n" result_ch)
    (printf "CPY RESULTs:cpyDtoH for analysis:~a\n" result_t)
    (printf "------------------------------------------------------------------\n")
    (print-shash h_work num_var num_uconst size_elt)
    (printf "------------------------------------------------------------------\n")
    (print-shash h_analysis num_var num_uconst size_elt)
    h_analysis))
     
(define (solve-constraints sc-kernel 
                           d_c d_w d_a h_empty_const
                           num_var num_uconst size_elt bg-struct)
  (let loop ([empty? (ptr-ref h_empty_const _byte)]
             [d_w_old d_w]
             [d_analysis d_a])

    (printf "loop - is-empty?:~a\n" (if empty? #t #f))
    (if (zero? empty?) ;; not empty
        ;; zero? end loop, get h_analysis as solution.
        (let*-values 
            ([(init-byte) (char->integer #\space)]
             [(byte-size) (ctype-sizeof _byte)]
             [(alignof-ptr) (ctype-alignof _pointer)]
             [(sizeof-ptr) (compiler-sizeof '*)]
             [(mem_size) (* num_var num_uconst size_elt)]
             [(alignof-int) (ctype-alignof _int)]
             [(sizeof-int) (ctype-sizeof _int)]
             
             [(offset) 0]
             
             ;; (1) reflection
             [(offset) (align-up offset alignof-ptr)]
             [(result sc-kernel) (cuParamSetv sc-kernel offset d_c sizeof-ptr)]
             [(offset) (+ offset sizeof-ptr)]
             
             ;; (2) d_work in
             [(offset) (align-up offset alignof-ptr)]
             [(result sc-kernel) (cuParamSetv sc-kernel offset d_w_old sizeof-ptr)]
             [(offset) (+ offset sizeof-ptr)]

             ;; (3) num_var
             [(offset) (align-up offset alignof-int)]
             [(result_m sc-kernel) (cuParamSeti sc-kernel offset num_var)]
             [(offset) (+ offset sizeof-int)]
             
             ;; (4) num_const
             [(offset) (align-up offset alignof-int)]
             [(result_m sc-kernel) (cuParamSeti sc-kernel offset num_uconst)]
             [(offset) (+ offset sizeof-int)]

             ;; (4.5) size_constraint
             [(offset) (align-up offset alignof-int)]
             [(result_m sc-kernel) (cuParamSeti sc-kernel offset size_elt)]
             [(offset) (+ offset sizeof-int)]
             
             ;; (5) d_w_new
             [(result_w_n d_w_new) (cuMemAlloc mem_size)]
             [(result_ms d_w_new) (cuMemsetD8 d_w_new init-byte mem_size)]
             [(offset) (align-up offset alignof-ptr)]
             [(result sc-kernel) (cuParamSetv sc-kernel offset d_w_new sizeof-ptr)]
             [(offset) (+ offset sizeof-ptr)]
             
             ;; (6) d_analysis in
             [(offset) (align-up offset alignof-ptr)]
             [(result sc-kernel) (cuParamSetv sc-kernel offset d_analysis sizeof-ptr)]
             [(offset) (+ offset sizeof-ptr)]
             
             ;; (7) d_empty_const 
             [(v) (ptr-set! h_empty_const _byte 1)] ; set it be 1(empty), change to 0(non-empty) in kernel.
             [(result_e_c d_empty_const) (cuMemAlloc byte-size)]
             [(result d_empty_const) (cuMemcpyHtoD d_empty_const h_empty_const byte-size)]
             [(offset) (align-up offset alignof-ptr)]
             [(result_4 sc-kernel) (cuParamSetv sc-kernel offset d_empty_const sizeof-ptr)]
             [(v) (printf "CPY result for d_empty_const:~a\n" result_4)]
             [(offset) (+ offset sizeof-ptr)]

             ;; (8,9) two extra args
             [(result_o1 d_out1) (cuMemAlloc mem_size)][(result_ms1 d_out1) (cuMemsetD8 d_out1 init-byte mem_size)]
             [(offset) (align-up offset alignof-ptr)][(result_o1 sc-kernel) (cuParamSetv sc-kernel offset d_out1 sizeof-ptr)][(offset) (+ offset sizeof-ptr)]
             [(result_o1 d_out2) (cuMemAlloc mem_size)][(result_ms2 d_out2) (cuMemsetD8 d_out2 init-byte mem_size)]
             [(offset) (align-up offset alignof-ptr)][(result_o2 sc-kernel) (cuParamSetv sc-kernel offset d_out2 sizeof-ptr)][(offset) (+ offset sizeof-ptr)]
             
             ;; closing arguments
             [(result_n sc-kernel) (cuParamSetSize sc-kernel offset)]
             
             ;;Launch kernel sc-kernel
             [(result_b sc-kernel)
              (cuFuncSetBlockShape sc-kernel 
                                   (block_grid-bx bg-struct)
                                   (block_grid-by bg-struct)
                                   (block_grid-bz bg-struct))]
             [(result_o) (cuLaunchGrid sc-kernel 
                                       (block_grid-gx bg-struct) (block_grid-gy bg-struct))]
             [(v) (printf "Launch sc-kernel result :~a\n" result_o)]
             
             [(result) (cuMemFree d_w_old)]
             
             [(result h_empty_const) (cuMemcpyDtoH h_empty_const d_empty_const byte-size)])
             
          (loop (ptr-ref h_empty_const _byte) d_w_new d_analysis))

        (values empty? d_w_old d_analysis))))
        


(define-struct block_grid (bx by bz gx gy))
  
(define (alloc-and-launch l-hfunc h_ht-const num_var num_uconst size_elt)
  (define BLOCK_SIZE_X num_var)
  (define BLOCK_SIZE_Y num_uconst)
  (define BLOCK_SIZE_Z 1)
  (define GRID_SIZE 1)
  
  (let*-values
      ; kernel functions:cuFunction?
      ([(init_constraints_kernel solve_constraints_kernel) (values (car l-hfunc) (cadr l-hfunc))]
       
       ;; blck, grid size initialization
       [(bg) (make-block_grid BLOCK_SIZE_X BLOCK_SIZE_Y BLOCK_SIZE_Z GRID_SIZE GRID_SIZE)]
       [(d_constraints d_work d_analysis h_empty_const)
        (init-constraints init_constraints_kernel 
                          h_ht-const num_var num_uconst size_elt
                          bg)]
       
       [(empty? d_work d_analysis) 
        (solve-constraints solve_constraints_kernel 
                           d_constraints d_work d_analysis h_empty_const
                           num_var num_uconst size_elt 
                           bg)]
       
       [(solution) (begin
              (printf "======================\nFINAL shash:\n======================\nnum-var:~a, num_uconst:~a, size_elt:~a\n"
                      num_var num_uconst size_elt)
              (check-work-analysis num_var num_uconst size_elt d_work d_analysis))]
       
       [(result_chf) (cuMemFree d_work)]
       [(result_uf) (cuMemFree d_analysis)])
    
    solution))
