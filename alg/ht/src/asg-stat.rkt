#lang racket
(require racket/vector 
         "ht-chaining.rkt"
         "ht-defs.rkt")

;ht1

;; list of numbers -> number
;; sum all element of the list
(define (sum-of-list lst)
  (cond
    [(empty? lst) 0]
    [else (+ (first lst) (sum-of-list (rest lst)))]))

;; list of numbers -> number
;; find average of the numbers in list
(define (list->avg lst)
  (cond
    [(empty? lst) 0]
    [else (/ (sum-of-list lst) (length lst))]))

;; list of numbers -> number
;; find maximum number from the numbers in the list
(define (max-in-list lst)
  (cond 
    [(empty? lst) 0]
    [else (max (first lst) (max-in-list (rest lst)))]))

;; list of numbers -> number
;; find variance of elements in the list
;; http://en.wikipedia.org/wiki/Computational_formula_for_the_variance
(define (list->variance lst)
  (cond 
    [(empty? lst) 0]
    [else 
     (let* ([mu (list->avg lst)]
            [sum-diff2 (sum-of-list 
                        (map (λ (x) 
                               (let* ([diff (- x mu)])
                                 (* diff diff)))
                             lst))])
       (/ sum-diff2 (length lst)))]))

(define (ht-mu-max-sig2 ht)
  (local ((define (ht->list-count t)
            (let* ([attrib (hash-table-attrib t)]
                   [vec (hash-table-vec t)]
                   [l-len (vector->list (vector-map length vec))]
                   [xxx (printf "~a\n" l-len)])
              l-len)))
    (let* ([lst-l (ht->list-count ht)]
           [xxx (printf "list ~a\n" lst-l)]
           [mu (list->avg lst-l)]
           [max (max-in-list lst-l)]
           [sig2 (list->variance lst-l)])
      (vector mu max sig2))))

#;(ht-mu-max-sig2 ht1)