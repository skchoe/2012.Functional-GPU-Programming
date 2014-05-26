#lang racket

(require "ht-defs.rkt")

(provide (all-defined-out))

(define (make-ht-open-address attrib lst-input) 
  (let* ([w (hash-attrib-w attrib)]
         [M (hash-attrib-M attrib)]
         [lst-a (hash-attrib-lst-a attrib)]
         [m (hash-attrib-m attrib)]
         [tbl (make-vector m '())]
         
         [insert (λ (x) 
                   (local ((define (local-insert x i)
                             (cond 
                               [(< i m)
                                (let* ([hc (hash-open-address w M (first lst-a) (second lst-a) i x)]
                                       [lx (vector-ref tbl hc)])
                                  (if (empty? lx)
                                      (begin 
                                        (vector-set! tbl hc (list x))
                                        i)
                                      (local-insert x (add1 i))))]
                               [else i])))
                     (local-insert x 0)))]
         [lst-try (map insert lst-input)])
    
    (values (make-hash-table attrib tbl) lst-try)))


(define (ht-open-address-lookup ht x) #f)
