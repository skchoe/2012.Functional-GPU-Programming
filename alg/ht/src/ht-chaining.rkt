#lang racket

(require "ht-defs.rkt")

(provide (all-defined-out))

(define (make-ht-chaining attrib lst-input) 
  (let* ([w (hash-attrib-w attrib)] 
         [M (hash-attrib-M attrib)]
         [lst-a (hash-attrib-lst-a attrib)]
         [m (hash-attrib-m attrib)]
         [tbl (make-vector m '())]
         
         [insert (λ (x) 
                   (let* ([hc (hash-chaining w M (first lst-a) x)]
                          [pos hc])
                     (vector-set! tbl pos (cons x (vector-ref tbl pos)))))])
    (for-each insert lst-input)
    (make-hash-table attrib tbl)))
    

;;;;;;;;;lookup
(define (ht-chaining-lookup ht x) 
  (local ((define (value-exists? l x)
            (cond 
              [(empty? l) #f]
              [(equal? (car l) x) #t]
              [else (value-exists? (cdr l) x)])))
    (let* ([attrib (hash-table-attrib ht)]
           [vec (hash-table-vec ht)]
           [tbl-length (hash-attrib-m attrib)]
           
           [hc (hash-chaining (hash-attrib-w attrib)
                              (hash-attrib-M attrib)
                              (first (hash-attrib-lst-a attrib))
                              x)]
           [pos (remainder hc tbl-length)]
           [lst-values (vector-ref vec pos)])
      (value-exists? lst-values x))))
    
    
