#lang racket

(require ffi/unsafe ffi/cvector 
         "../../schcuda/carray-cstruct.rkt"
         
;         "../../schcuda/cuda_h.ss"
;         "../../schcuda/scuda.ss"
;         "../../schcuda/suda-set-env.ss"
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; simple carray testers

;(define shp (shape 1 2 5))
;(mult-all-alloc-elt 3 shp _int)


;; 1D carray
(define ar1 (build-carray 1 (shape 4) _float 1.0 1.0 2.0 3.0))
(carray-ref ar1 2)

(define ptr (carray-elem-vector ar1))
(equal? 3.0 (ptr-ref ptr _float 3))
(equal? 2.0 (carray-ref ar1 2))


; 2D carray
(define ar2 (build-carray 2 (shape 2 3) 
                          _float 
                          1.0 3.0 
                          4.0 6.0 
                          2.0 4.0))
(equal? 2.0 (ptr-ref (carray-elem-vector ar2) _float 4))

(carray-shape ar2)
(carray-elem-vector ar2)
(equal? 6.0 (carray-ref ar2 1 1))

;; 3D carray
(define ar3 (build-carray 3 (shape 2 3 2)
                          _float
                          1.0 3.0 
                          4.0 6.0 
                          2.0 4.0
                          -1.0 -3.0 
                          -4.0 -6.0 
                          -2.0 -4.0))
(ptr-ref (carray-elem-vector ar3) _float 1)
(equal? -4.0 (carray-ref ar3 1 2 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;(define (alloc-run-fetch hfunc . args)
;  (alloc-run-fetch hfunc l-arg))
;  
;(define (alloc-run-fetch hfunc l-arg)
;  (if (empty? l-arg) (error "No computation meaningful with no in/out\n")
;      (
;       
;       Now need to have abstraction of alloc and launch based on function prototype.
;           )))
;       
;       
;       
;;; build big carray
;(define cu-device (last (suda-init-devices 0)))
;
;(define alen (get-max-thread-per-block cu-device))
;(define inarr (build-list alen (lambda (x) (random))))
;(define airbag1 (build-carray/list 1 (shape alen) _float inarr))
;(define cpu-sum (for/fold ([sum 0]) ([i (in-range alen)]) (+ sum (list-ref inarr i))))
;
;
;;; basic names by string, codegen to CUDA C
;(define kernel_name #"sum")
;(define cubin_path_string "data/sum_kernel.sm_10.cubin")
;(define cubin-path (generate-cubin cubin_path_string))
;
;;; echo device info
;(suda-device-info cu-device)
;
;(let*-values 
;    ([(cuContext l-hfunc)
;                   (load-kernel-driver cu-device cubin-path kernel_name)]
;     [(ans) (alloc-run-fetch (car l-hfunc) airbag1)])
;  (cuCtxDetach cuContext))
