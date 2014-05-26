#lang typed/racket
(define-type V-str (Vectorof String))

;; signature of kernel
;; vars: variable set
;; m: constraint matrix w/ vertical elems are w.r.t a var
;; an: multi-vector (nx1) of analysis w/ vertical elem are w.r.t. var
;; idx: index for current value in analysis mapping i.e. row elem in an.
;; new-m: newly generated constraints by looping/applying I.C constraints w/ current value
;; new-an: newly derived values by I.C.
(: solve-constraints  (V-str V-str V-str V-str V-str V-str -> Void))
(define-global-func (solve-constraint vars m an idx new-m new-an)
  ;; generate new value from constraints
  (let ([a  an<threadIdx:idx>])
    (when (valid-value? a)
      (let ([cs m<threadIdx>]
            ;; copy to shared memory
            [c-sh (copy-to-shared-memory cs)]
        
            ;; Constraint solving: c-sh, a -> new c-sh applying I.C.
            ;; (a-map λ lst a) = (map λ lst (build-list a |lst|))
            [new-c-sh
             (a-map interpret-constraint c-sh a)])
        
        ;; copy back to global memory
        (for-each
         (lambda (c) 
           (if (anom-constraint? c) 
               (insert new-an<threadIdx> c) 
               (insert new-m<threadIdx> c))) 
         nc-sh)
        
        (syncThreads)))))

(define-device-func: (interpret-constraints: [c V-str] [val V-str]) : V-str
  ;; compute new constraint w/ c, val
  ;; return it;