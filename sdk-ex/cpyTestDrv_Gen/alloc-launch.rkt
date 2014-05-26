#lang racket

(require scheme/foreign
         ffi/unsafe
         "../../schcuda/cuda_h.ss"
         "../../schcuda/scuda.ss")

(provide alloc-and-launch)
 
(define (alloc-and-launch hfunc)
  (define BLOCK_SIZE 1)
  (define GRID_SIZE 1)
  
  (let*-values 
      ([(offset) (values 0)]
       [(sizeof-ptr) (compiler-sizeof '*)]
       [(alignof-ptr) (ctype-alignof _pointer)]
       [(v) (printf "sizeof_ptr=~a, alignof_ptr=~a\n" sizeof-ptr alignof-ptr)]
       
       ;;___________________________________________________________________________________________
       ;; storage(receiver) for the copy of array from device
       [(count) 5]
       [(mem_size) (* count (compiler-sizeof 'float))]
       
       ;; input(sender) for the array of floats
       [(h_array_in) (let* ([vec (malloc _float count)])
                       #;(printf "************cuParamSetv d_parray_out:~a   w/size=~a bytes offset:~a, size:~a\n" 
                               d_parray_out mem_size offset sizeof-ptr)
                       (for ([i (in-range count)])
                         (ptr-set! vec _float i (* (+ i 1) 0.001)));(random)))
                       (print-f64vector-cpointer vec _float count);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       vec)]
       [(result_j d_parray_in) (cuMemAlloc mem_size)]
       [(result_k d_parray_in_new) (cuMemcpyHtoD d_parray_in h_array_in mem_size)]
       [(offset) (align-up offset alignof-ptr)]
       [(result_l hfunc) (cuParamSetv hfunc offset d_parray_in_new sizeof-ptr)]
       [(offset_out) (begin
                     #;(printf "**************cuParamSetv d_parray_in:~a=>~a w/size=~a bytes  offset:~a size:~a\n" 
                             d_parray_in d_parray_in_new mem_size offset sizeof-ptr)
                     (+ offset sizeof-ptr))]
       [(vd) (printf "1-ptr:(od/nw:~a/~a)\n" offset offset_out)]
       
       ; input size  of array in d_array_in
       [(offset) (align-up offset_out alignof-ptr)]
       [(result_m hfunc) (cuParamSeti hfunc offset count)]
       [(offset_out) (begin
                      (printf "*************cuParamSeti:Count offset:~a count:~a\n" offset count)
                      (printf "[[[[ctype-alignof_int:~a, compiler-sizeof_int:~a, offset:~a\n" (ctype-alignof _int) (compiler-sizeof 'int) offset)
                      (+ offset (compiler-sizeof 'int)))]
       
       [(vd) (printf "2-size-uint:(od/nw:~a/~a)\n" offset offset_out)]

       ;; input(sender) for the copy of single value
       [(h_single_in) (values 256)]
       [(offset) (begin
                   (printf "offset from prev:~a\n" offset_out)
                   (align-up offset_out alignof-ptr))] ; because h_single_in is of type _uint : depends on type of value
       [(result_g hfunc) 
        (begin
          (printf "offset by aligh-up:~a\n" offset)
          (cuParamSeti hfunc offset h_single_in))]
       [(offset_out) (begin
                     #;(printf "************cuParamSeti:single_in offset:~a, d_psingle:~a\n" offset h_single_in)
                     (+ offset (compiler-sizeof 'int)))]

       [(vd) (printf "3-int(256):(od/nw:~a/~a)\n" offset offset_out)]

       ;; receiver of array input
       [(result_h d_parray_out) (cuMemAlloc mem_size)]
       [(offset) (align-up offset_out alignof-ptr)]
       [(result_i hfunc) (cuParamSetv hfunc offset d_parray_out sizeof-ptr)]
       [(offset_out) (+ offset sizeof-ptr)]
       [(vd) (printf "4-ptr-return:(od/nw:~a/~a)\n" offset offset_out)]

       ;;___________________________________________________________________________________________
       ;; storage(receiver) for the length of parray 
       [(isize) (compiler-sizeof 'int)]
       [(result_e1 d_parray_out_len) (cuMemAlloc isize)]
       [(offset) (align-up offset_out alignof-ptr)]
       [(result_f hfunc) (cuParamSeti hfunc offset d_parray_out_len)]
       [(offset_out) (+ offset sizeof-ptr)]
       [(vd) (printf "5-int-return:(od/nw:~a/~a)\n" offset offset_out)]
       
       ;;___________________________________________________________________________________________
       ;; storage(receiver) for the copy of single value 
       [(isize) (compiler-sizeof 'int)]
       [(result_e d_psingle) (cuMemAlloc isize)]
       [(offset) (align-up offset_out alignof-ptr)]
       [(result_f hfunc) (cuParamSeti hfunc offset d_psingle)]
       [(offset_out) (begin
                     #;(printf "************cuParamSeti:single_out offset:~a, d_psingle:~a\n" offset d_psingle)
                     (+ offset sizeof-ptr))]

       [(vd) (printf "6-int-return:(od/nw:~a/~a)\n" offset offset_out)]
       
;       ;;___________________________________________________________________________________________
;       ;; storage(receiver) for values of default variables
;       [(memst_size) (* 12 (compiler-sizeof 'int))]
;       [(result_c d_ppmemst) (cuMemAlloc memst_size)]
;       [(offset) (align-up offset alignof-ptr)] ;;;;;; (CUdeviceptr = uint8)?
;       [(result_d hfunc) (cuParamSetv hfunc offset d_ppmemst sizeof-ptr)]
;       [(offset) (begin
;                     #;(printf "*************cuParamSetv:memset_out offset:~a size:~a\n" offset sizeof-ptr)
;                     (+ offset sizeof-ptr))]
       
       
              
       ;[(w) (printf "offset7:~a, offset8:~a, offset:~a, offset:~a, offset:~a, offset:~a, 1:~a, 3:~a, 5:~a\n" offset offset offset offset offset offset offset offset offset)]
       ;[(v) (printf "data size 7:~a, 9:~a, 11:~a, 1:~a, 3:~a, 5:~a\n" sizeof-ptr sizeof-ptr count sizeof-ptr d_psingle h_single_in)]
       ;;============================================================================================================================
       ;; call finial size
       [(result_b hfunc)
        (cuFuncSetBlockShape hfunc BLOCK_SIZE BLOCK_SIZE BLOCK_SIZE)]
       [(result_n hfunc) (cuParamSetSize hfunc offset_out)]
       [(result_o) (cuLaunchGrid hfunc GRID_SIZE GRID_SIZE)]
       
       ;; output of single vaule
       [(h_single_out) (malloc isize 'raw)]
       [(result_r h_single_out_new) (cuMemcpyDtoH h_single_out d_psingle isize)]
       [(result_s) (cuMemFree d_psingle)]
       
       ;; output of array value
       [(h_array_out) (malloc mem_size 'raw)]
       [(result_t h_array_out_new) (cuMemcpyDtoH h_array_out d_parray_out mem_size)]
       [(result_u) (begin
                     (printf "______________________d_parray_out at end:~a\n" d_parray_out)
                     (cuMemFree d_parray_out))]
       
       [(h_out_len) (malloc isize 'raw)]
       [(result_r1 h_out_len_new) (cuMemcpyDtoH h_out_len d_parray_out_len isize)]
       [(result_s1) (cuMemFree d_parray_out_len)]
       
       [(h_array_newin) (malloc mem_size 'raw)]
       [(result_newt h_array_in_new) (cuMemcpyDtoH h_array_newin d_parray_in mem_size)]
       [(result_v) (begin
                     (printf "______________________h_parray_in_new at end:~a\n" h_array_in_new)
                     (cuMemFree d_parray_in))])
       
       
;       ;;output of default variables: in h_parray_out
;       [(h_memst) (malloc _int memst_size 'raw)]
;       [(result_p h_memst_new) (cuMemcpyDtoH h_memst d_ppmemst memst_size)]
;       [(result_q) (cuMemFree d_ppmemst)])
       
    (printf "c-type_align of uint8:~s, compiler-sizeof uint8:~s\n" (ctype-alignof _uint) (compiler-sizeof 'int))
    (printf "h_parray_out:~a\n" (ptr-ref h_array_out_new _float 0))
    (printf "h_parray_out_len:~a\n" (ptr-ref h_out_len_new _int 0))
;    (printf "RESULTs:SetBlkshp:~a, MemAlloc:~a, cuParamsetV:~a\n" result_b result_c result_d)
    (printf "RESULTs:cpyDtoH for parray:~a, for parray_out_len:~a\n" result_t result_r1)
    (printf "RESULTs:MemAlloc:~a, ParamSeti:~a, ParamSeti:~a\n" result_e result_f result_g)
    (printf "RESULTs:MemAlloc:~a, ParamSetv:~a, ParamSeti:~a\n" result_h result_i result_j)

;    (for ([idx (in-range 12)])
;      (printf "Memst value at ~a:~a\n" idx (ptr-ref h_memst_new _int idx)))
;    (free h_memst)
    
    
    (printf "------------------------------------------------------------------\n")
    (if (equal? (ptr-ref h_single_out _int) h_single_in)
        (printf "single-in/out = EQUAL\n")
        (printf "single-in/out = NOT equal----error\n"))
    (free h_single_out)
    
    (printf "------------------------------------------------------------------\n")
    
    (for ([idx (in-range count)])
      (let* ([new-value (ptr-ref h_array_out_new _float idx)]
             [new-invalue (ptr-ref h_array_newin _float idx)]
             [original-value (ptr-ref h_array_in _float idx)])
      (printf "[~a]=~a/~a->~a  compare:~a\n" idx new-value original-value new-invalue (equal? new-value original-value))))
    
    (newline)
    (printf "Sizeof Uint=~a,\tCompiler-sizeof int:~a, void=~a\n" 
            (compiler-sizeof 'int) (compiler-sizeof 'int) (compiler-sizeof '*))
    (printf "comparison align-of _uint and _int =~a, ~a\n" (ctype-alignof _uint) (ctype-alignof _int))
    (printf "comparison alignof _int64:~a w/ _pointer:~a\n" (ctype-alignof _int64) (ctype-alignof _pointer))
    (free h_array_out)
    #f))
