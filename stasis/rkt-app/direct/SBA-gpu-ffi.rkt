#lang racket

(require "../../hash-tbl-ctype/hash-ffi-string.rkt"
         "../../hash-tbl-ctype/hash-ffi-strarray.rkt"
         "../../hash-tbl-ctype/ffi-common.rkt"

         ;; cuda-ffi related
         "../../../schcuda/scuda.ss"
         "../../../schcuda/suda-set-env.ss"
         "../../../schcuda/cuda_h.ss"
         
         ;; main init-copy-launch-module
         "../common/check-utils.rkt"
         "../common/SBA-gen-constraints.rkt"
         "alloc-launch.rkt"
                  
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;; code made maually
         #;"../../input-progs/input-progs-forseq.rkt"
         "../../input-progs/input-progs.rkt"
         ;; code generated
         #;"../../input-progs/input-prog-gen.rkt")         

(provide (all-defined-out))

; hash table, total size 
(define (cuda-setup-execute ht sz)
  (let* (;[current_folder (find-system-path 'home-dir)]
         ;[cubin_path_string (string-append (path->string current_folder) "data/test_kernel.sm_10.cubin")]
         ;; Loading kernel from ctx->module
         ;; set kernel launch configuration
         [cubin-path (generate-cubin "../../CUDA_C/data/cu_lib.cubin")]; bytes type if there's '#' infront of string.
         [cuDevice (last (suda-init-devices 0))] ; we support single GPU now.
         #;[kernel_name0 #"test1"]
         [kernel_name0 #"init_constraints_kernel"]
         [kernel_name1 #"solve_constraints_kernel"])

    ;; load kernel function
    (load-kernel-driver cuDevice cubin-path kernel_name0 kernel_name1)))

          
;;________________________________________________________________________________________________
;;; This one is simplified syntax which heap value h has (λ x . v) where v is var or location.
;; This restriction make possible for encoding to deal with list of symbol or constants.
(let-values
 ([(shash num_var num_uconst constraint-counter) (make-my-shash 8 3 SIZE_CONSTRAINT INIT-CHAR)])
  (printf "prog = ~a\n" prog)
  
  ;; gen-constraints w/ shash-add-elt is to add constraints into shash table.
  (gen-constraints prog
                   shash num_var num_uconst shash-add-elt)
  
  ;; test function for gen-constraint.
  ;; gen-constraints to print out code for C-version execution
  #;(gen-constraints prog
                   shash num_var num_uconst print-hash-tbl-stmt constraint-counter)
  
  ;; now shash os full of constraint.
  (print-shash shash num_var num_uconst SIZE_CONSTRAINT)
  
  (let*-values 
      ([(cuContext l-hfunc) (cuda-setup-execute shash (* num_var num_uconst SIZE_CONSTRAINT))]
       [(solution) (alloc-and-launch l-hfunc shash num_var num_uconst SIZE_CONSTRAINT)])
    
    #;(print-shash solution num_var num_uconst SIZE_CONSTRAINT)
    
    (cuCtxDetach cuContext)))
