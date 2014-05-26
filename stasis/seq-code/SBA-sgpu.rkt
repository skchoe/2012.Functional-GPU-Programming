#lang racket/base
(require racket/set racket/match
         "../input-progs/input-progs-forseq.rkt"
         "SBA-utils.rkt")

;; add elem into list w.r.t. var
(define (shash-add-elt ht var v)
  (let* ([st (hash-ref ht var (set))])
    (hash-set! ht var (set-add st v))
    ht))

;; union given set(st) w/ existing set(s)
(define (shash-union-set ht var st)
  (let* ([s (hash-ref ht var (set))])
    (hash-set! ht var (set-union s st))
    ht))

;; delete elem from list w.r.t. var
;; key not found? -> return ht
;; else value empty? -> delete the key from ht, return ht 
;;      value non-empty -> re-hash-set (cdr value) to the key, return ht
(define (shash-delete-elt ht var v)
  (if (hash-has-key? ht var)
      (let* ([st (hash-ref ht var (set))])
        (if (set-empty? st) 
            (hash-remove! ht var)
            (let* ([new-st (set-remove st v)])
              (if (set-empty? new-st)
                  (hash-remove! ht var)
                  (hash-set! ht var new-st))))
        ht)
      ht))

;; in c, v
;; out: (list (or var lst) c)
(define (interpret-constraint c v)
  ;(printf "c:~a v:~a~n" c v)
  (match (cons c v)
    [`((propagate-to ,x) . ,v) (list x v)] 
    [`((propagate-car-to ,x) . (cons ,y1 ,y2)) (list y1 `(propagate-to ,x))] ; car skip
    [`((propagate-cdr-to ,x) . (cons ,y1 ,y2)) (list y2 `(propagate-to ,x))] ; cdr skip
    [`((application ,result ,arg) . (lambda ,para ,_ ,finalvar))
     (list (list finalvar `(propagate-to ,result))
           (list arg `(propagate-to ,para)))]
    [`((application ,result ,arg) . (cont ,x)) (list arg `(propagate-to ,x))] ; continuatoin skip
    [`((conditional-prop ,test ,from ,to) . ,value) ; conditional skip
     (if (eq? (null? value) test) 
         (list from `(propagate-to ,to))
         '())]
    [_ '()]))

#|
(define (ic c v)
  int C|x = (malloc 2byte) (memcpy C c 2 _byte)
  if(C==P) // propagate-to // return (var:char* , v:int)
  else if (C==A) (L|p|fv)// application // return (finalvar: char*, [P|x]), (arg:char*, [P|p])
  else CR
|#

; generate constraint mapping
(define (gen-constraints prog ht)
    (match prog
      [(? symbol? x) ht]
      [`(let (,x ,exp) ,body)
       (let* 
         ([gen-constraint
           (lambda (expr ht)
             (match expr
               
               [(? integer? c) 
                (shash-add-elt ht x c)]
               [`(cons ,y1 ,y2) 
                (shash-add-elt ht x `(cons ,y1 ,y2))]
               
               [`(lambda (,y) ,N)
                (let* ([finalvar-N (get-finalvar N)]
                       [N-ht (gen-constraints N ht)])
                  (shash-add-elt N-ht x `(lambda ,y ,N ,finalvar-N)))]
               [`(car ,y) 
                (shash-add-elt ht y `(propagate-car-to ,x))]
               [`(cdr ,y) 
                (shash-add-elt ht y `(propagate-cdr-to ,x))]
               [`(if ,y ,M1 ,M2)
                (let ([finalvar-M1 (get-finalvar M1)][finalvar-M2 (get-finalvar M2)])
                  (shash-add-elt 
                   (shash-add-elt ht y (list y `(conditional-prop #t ,finalvar-M1 ,x)))
                   y `(conditional-prop #f ,finalvar-M2 ,x)))]
               
               [`(apply ,y ,z) 
                (shash-add-elt ht y `(application ,x ,z))]
               [`(set! ,y ,z)
                (shash-add-elt (shash-add-elt ht z `(propogate-to ,y)) z `(propogate-to ,x))]
               [`(letcc ,y ,N)
                (let ([finalvar-N (get-finalvar N)])
                  (shash-add-elt
                   (shash-add-elt ht finalvar-N `(propagate-to ,x))
                   y `(cont ,x)))]
               
               [_ 
                (let ([finalvar-exp (get-finalvar exp)])
                  (shash-add-elt ht finalvar-exp `(propagate-to ,x)))]))]
          [ht-exp (gen-constraint exp ht)])
         (gen-constraints body ht-exp))]))
  
(define (show-shash sht)
;  (let* ([len (hash-count sht)])
;    (for ([i (in-range len)])
;      (printf "key: ~a\t value:~a\n" (hash-iterate-key sht i) (hash-iterate-value sht i))))
  (printf "\nshow-shash\n")
  (hash-for-each 
   sht 
   (λ (k v) (printf "key: ~a\t value:~a\n" k v))))

;; const-sht - original const. cuda-study.04.25.1.tgz

;; work-sht - non atomic const.
;; analysis-sht - atomic const.
(define (filter-analysis const-sht work-sht analysis-sht)
  (hash-for-each 
   const-sht
   (λ (var st)
     (set-for-each st 
                   (λ (e)
                     (when (atom-constraint? e)
                       (begin (shash-add-elt analysis-sht var e)
                              (shash-delete-elt work-sht var e)))))))
  (values work-sht analysis-sht))

;; v: var
;; c: constraint
;; sht-constraint sht
;; sht-analysis sht
;; output (values sht-constraint sht-analysis)

;; __device__ locking sht-constraint, sht-analysis update
(define (update-analysis-produce-constraint org-constraint sht-constraint sht-analysis lst-v-c)
  (cond
    [(atom-constraint? (cadr lst-v-c))
     (values
      org-constraint 
      (let ([s (hash-ref org-constraint (car lst-v-c) (set))])
        (for/fold ([new-const sht-constraint])
          ([elt (in-set s)])
          ;; atomic addition to sht-contraint
          (shash-add-elt sht-constraint (car lst-v-c) elt)))
      
      ;; atomic addition to sht-analysis
      (shash-add-elt sht-analysis (car lst-v-c) (cadr lst-v-c)))]
    [else
     (values org-constraint
             ;; atomic addition to sht-constraint
             (shash-add-elt sht-constraint (car lst-v-c) (cadr lst-v-c))
             sht-analysis)]))
  
;;; input - constraint -shash
;;; body - throw away input, create output.
;;; inter-loop-var -> 
;;; output - (values new-constraint updated-analysis-sht)
;(define (solve-constraints work-sht analysis-sht)
;  ;; work-sht solve w/ const \in cst, var
;  
;  )

; test
(define (solve prog)
  (let* ([const-sht (gen-constraints prog (make-hasheq))]
         [start (current-inexact-milliseconds)])
    
    #;(display const-sht)
    
    (begin0
      ;; input - single constraint sht. w/ updated analysis-sht
      ;; initial case: c-sht is from original prg(gen-constraints)
      ;;               a-sht is empty
      ;; inside loop : c-sht -> (w-sht (U a-sht new-a-sht-from c-sht)) -> (new-w-sht,  (U a-sht new-a-sht-from c-sht))
      ;; after loop  : c-sht is output of loop, 
      ;;               a-sht is (U a-sht new-a-sht-from c-sht)
      (let loop ([org-c-sht const-sht]
                 [c-sht (hash-copy const-sht)]
                 [a-sht (make-hasheq)])
        (let-values
            ;; 1. (org-c-sht c-sht a-sht) -> (w-sht (U a-sht new-a-sht))
            ;; Sequential for now. - future parallelization - alot of lock
            ([(work-sht analysis-sht) (filter-analysis org-c-sht c-sht a-sht)])
          
          ;; 2. Constraint solving
          (if (zero? (hash-count work-sht))
              (values org-c-sht work-sht analysis-sht)
              (let-values 
                  ([(o-c new-c up-a)
                    
                    ;; __global__
                    (for/fold ([org-const org-c-sht]
                               [new-const (make-hasheq)]
                               [updated-analysis analysis-sht])
                      ;; Parallel work-sht per each key
                      ;; threadIdx.x
                      ([var (in-hash-keys work-sht)])
                      
                      ;; body of kernel
                      (let* ([cst (hash-ref work-sht var (set))]
                             [vst (hash-ref updated-analysis var (set))])
                        (if (set-empty? vst)
                            (values org-const 
                                    (shash-union-set new-const var cst)
                                    updated-analysis)
                            ;; <cst, vst> -> loop via cst, get value 
                            (for*/fold ([oc org-const] [nc new-const] [ua updated-analysis])
                              ;; Possibly threadIdx.y threadIdx.z
                              ([c (in-set cst)] [v (in-set vst)])
                              (let* ([lst-v-c (interpret-constraint c v)])
                                (cond
                                  [(null? lst-v-c) (values oc nc ua)]
                                  
                                  [(list? (car lst-v-c));lst-v-c = `(`(v c) '(v c)) ;(caar lst) is var, (cadar lst) is const
                                   (for/fold ([ooc oc] [nnc nc] [uua ua])
                                     ([lvc lst-v-c])
                                     ;; __device__ 
                                     (update-analysis-produce-constraint ooc nnc uua lvc))]
                                  [else 
                                   ;; __device__
                                   (update-analysis-produce-constraint oc nc ua lst-v-c)]))))))])
                (loop o-c new-c up-a)
                ))))
      (printf "Milisec:~a\n" (- (current-inexact-milliseconds) start)))))
    

(let-values
    ([(cht wht aht)
      (solve prog)])
  
  (printf "\n\na:\n:~a\n" aht))
