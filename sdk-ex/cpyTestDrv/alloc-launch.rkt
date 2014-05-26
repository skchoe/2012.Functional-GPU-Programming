#lang racket

(require scheme/foreign
         ffi/unsafe
         "../../schcuda/cuda_h.ss"
         "../../schcuda/scuda.ss")

(provide alloc-and-launch)

#;(define (print-f64vector v count)
  (for ([idx (in-range count)])
    (printf "<~a>=~a\t" idx (f64vector-ref v idx)))
  (newline))
  
#;(define (print-f64vector-cpointer vp type count)
  (for ([idx (in-range count)])
    (printf "(~a)=~s\t" idx (ptr-ref vp type idx)))
  (newline))
 
(define (alloc-and-launch hfunc)
  (define BLOCK_SIZE 2)
  (define GRID_SIZE 2)
  
  (let*-values 
      ([(result_b hfunc)
        (cuFuncSetBlockShape hfunc BLOCK_SIZE BLOCK_SIZE BLOCK_SIZE)]
       [(offset_0) (values 0)]
       [(sizeof-ptr) (compiler-sizeof '*)]
       [(alignof-ptr) (ctype-alignof _pointer)]
       [(v) (printf "sizeof_ptr=~a, alignof_ptr=~a\n" sizeof-ptr alignof-ptr)]
       ;;___________________________________________________________________________________________
       ;; storage(receiver) for the copy of array from device
       [(count) 5]
       [(mem_size) (* count (ctype-sizeof _float))]
       [(result_h d_parray_out) (cuMemAlloc mem_size)]
       [(offset_7) (align-up offset_0 alignof-ptr)]
       [(result_i hfunc) (cuParamSetv hfunc offset_7 d_parray_out sizeof-ptr)]
       [(offset_8) (+ offset_7 sizeof-ptr)]

       ;; input(sender) for the array of floats
       [(h_array_in) (let* ([vec (malloc _float count)])
                       #;(printf "************cuParamSetv d_parray_out:~a   w/size=~a bytes offset:~a, size:~a\n" 
                               d_parray_out mem_size offset_7 sizeof-ptr)
                       (for ([i (in-range count)])
                         (ptr-set! vec _float i (* (+ i 1) 0.001)));(random)))
                       (print-f64vector-cpointer vec _float count);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       vec)]
       [(result_j d_parray_in) (cuMemAlloc mem_size)]
       [(result_k d_parray_in_new) (cuMemcpyHtoD d_parray_in h_array_in mem_size)]
       [(offset_9) (align-up offset_8 alignof-ptr)]
       [(result_l hfunc) (cuParamSetv hfunc offset_9 d_parray_in_new sizeof-ptr)]
       [(offset_10) (begin
                     #;(printf "**************cuParamSetv d_parray_in:~a=>~a w/size=~a bytes  offset:~a size:~a\n" 
                             d_parray_in d_parray_in_new mem_size offset_9 sizeof-ptr)
                     (+ offset_9 sizeof-ptr))]
       
       ; input size  of array in d_array_in
       [(offset_11) (align-up offset_10 (ctype-alignof _uint))]
       [(result_m hfunc) (cuParamSeti hfunc offset_11 count)]
       [(offset_12) (begin
                      #;(printf "*************cuParamSeti:Count offset11:~a count:~a\n" offset_11 count)
                      (+ offset_11 (ctype-sizeof _uint)))]
       
       ;;___________________________________________________________________________________________
       ;; storage(receiver) for values of default variables
       [(memst_size) (* 12 (ctype-sizeof _uint))]
       [(result_c d_ppmemst) (cuMemAlloc memst_size)]
       [(offset_1) (align-up offset_12 alignof-ptr)] ;;;;;; (CUdeviceptr = uint8)?
       [(result_d hfunc) (cuParamSetv hfunc offset_1 d_ppmemst sizeof-ptr)]
       [(offset_2) (begin
                     #;(printf "*************cuParamSetv:memset_out offset_1:~a size:~a\n" offset_1 sizeof-ptr)
                     (+ offset_1 sizeof-ptr))]
       
       ;;___________________________________________________________________________________________
       ;; storage(receiver) for the copy of single value 
       [(isize) (ctype-sizeof _uint)]
       [(result_e d_psingle) (cuMemAlloc isize)]
       [(offset_3) (align-up offset_2 alignof-ptr)]
       [(result_f hfunc) (cuParamSeti hfunc offset_3 d_psingle)]
       [(offset_4) (begin
                     #;(printf "************cuParamSeti:single_out offset:~a, d_psingle:~a\n" offset_3 d_psingle)
                     (+ offset_3 sizeof-ptr))]
       
       ;; input(sender) for the copy of single value
       [(h_single_in) (values 256)]
       [(offset_5) (align-up offset_4 (ctype-alignof _int))] ; because h_single_in is of type _uint : depends on type of value
       [(result_g hfunc) (cuParamSeti hfunc offset_5 h_single_in)]
       [(offset_6) (begin
                     #;(printf "************cuParamSeti:single_in offset:~a, d_psingle:~a\n" offset_4 h_single_in)
                     (+ offset_5 (ctype-sizeof _int)))]
       
              
       ;[(w) (printf "offset7:~a, offset8:~a, offset_9:~a, offset_10:~a, offset_11:~a, offset_12:~a, 1:~a, 3:~a, 5:~a\n" offset_7 offset_8 offset_9 offset_10 offset_11 offset_12 offset_1 offset_3 offset_5)]
       ;[(v) (printf "data size 7:~a, 9:~a, 11:~a, 1:~a, 3:~a, 5:~a\n" sizeof-ptr sizeof-ptr count sizeof-ptr d_psingle h_single_in)]
       ;;___________________________________________________________________________________________
       ;; call finial size
       [(result_n hfunc) (cuParamSetSize hfunc offset_6)]
       [(result_o) (cuLaunchGrid hfunc GRID_SIZE GRID_SIZE)]
       
       ;; output of default variables: in h_parray_out
       [(h_memst) (malloc _int memst_size 'raw)]
       [(result_p h_memst_new) (cuMemcpyDtoH h_memst d_ppmemst memst_size)]
       [(result_q) (cuMemFree d_ppmemst)]
       
       ;; output of single vaule
       [(h_single_out) (malloc _int isize 'raw)]
       [(result_r h_single_out_new) (cuMemcpyDtoH h_single_out d_psingle isize)]
       [(result_s) (cuMemFree d_psingle)]
       
       ;; output of array value
       [(h_array_out) (malloc _float mem_size 'raw)]
       [(result_t h_array_out_new) (cuMemcpyDtoH h_array_out d_parray_out mem_size)]
       [(result_u) (begin
                     #;(printf "______________________d_parray_out at end:~a\n" d_parray_out)
                     (cuMemFree d_parray_out))]
       
       [(h_array_newin) (malloc _float mem_size 'raw)]
       [(result_newt h_array_in_new) (cuMemcpyDtoH h_array_newin d_parray_in mem_size)]
       [(result_v) (begin
                     #;(printf "______________________d_parray_in at end:~a\n" d_parray_in)
                     (cuMemFree d_parray_in))]
       )
       
    (printf "c-type_align of uint8:~s, ctype-sizeof uint8:~s\n" (ctype-alignof _uint) (ctype-sizeof _uint))
    (printf "RESULTs:SetBlkshp:~a, MemAlloc:~a, cuParamsetV:~a\n" result_b result_c result_d)
    (printf "RESULTs:MemAlloc:~a, ParamSeti:~a, ParamSeti:~a\n" result_e result_f result_g)
    (printf "RESULTs:MemAlloc:~a, ParamSetv:~a, ParamSeti:~a\n" result_h result_i result_j)
    
    (for ([idx (in-range 12)])
      (printf "Memst value at ~a:~a\n" idx (ptr-ref h_memst_new _int idx)))
    (printf "Output-h_single_out:~a, from ~a\n" (ptr-ref h_single_out _int 0) h_single_out)
    
    (printf "------------------------------------------------------------------\n")
    (if (equal? (ptr-ref h_single_out _int) h_single_in)
        (printf "single-in/out = EQUAL\n")
        (printf "single-in/out = NOT equal----error\n"))
    
    (printf "------------------------------------------------------------------\n")
    
    (for ([idx (in-range count)])
      (let* ([new-value (ptr-ref h_array_out_new _float idx)]
             [new-invalue (ptr-ref h_array_newin _float idx)]
             [original-value (ptr-ref h_array_in _float idx)])
      (printf "[~a]=~a/~a->~a  compare:~a\t" idx new-value original-value new-invalue (equal? new-value original-value))))
    
    (newline)
    (printf "Sizeof Uint=~a, _void=~a\tCompiler-sizeof int:~a, void=~a\n" 
            (ctype-sizeof _uint) (ctype-sizeof _void) (compiler-sizeof 'int) (compiler-sizeof '*))
    (printf "comparison align-of _uint and _int =~a, ~a\n" (ctype-alignof _uint) (ctype-alignof _int))
    (printf "comparison alignof _int64:~a w/ _pointer:~a\n" (ctype-alignof _int64) (ctype-alignof _pointer))
    (free h_memst)
    (free h_single_out)
    (free h_array_out)
    #f))

