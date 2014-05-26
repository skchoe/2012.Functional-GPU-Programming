#lang racket
(require "ht-defs.rkt"
         "ht-chaining.rkt"
         "ht-open-address.rkt"
         "ht-cuckoo.rkt")

(define (make-ht method attrib lst-input)
  (cond
    [(symbol=? method 'chaining) (make-ht-chaining attrib lst-input)]
    [(symbol=? method 'open-address) (make-ht-open-address attrib lst-input)]
    [(symbol=? method 'cuckoo) (make-ht-cuckoo attrib lst-input)]
    [else (error "Unknown method")]))
    

(define (ht-lookup method ht x)
  (cond
    [(symbol=? method 'chaining) (ht-chaining-lookup ht x)]
    [(symbol=? method 'open-address) (ht-open-address-lookup ht x)]
    [(symbol=? method 'cuckoo) (ht-cuckoo-lookup ht x)]
    [else (error "Unknown method")]))



(define attrib-chaining (make-hash-attrib bit-W (first lst-M) (list (odd-random (expt 2 (/ bit-W 2)))) (first lst-table-size-m)))
#|
;; chaining
;(define in-data-chaining (build-list input-size-n-chaining (λ (x) (random (expt 2 31)))))
;(define ht-c (make-ht-chaining attrib-chaining in-data-chaining))
;(hash-table-vec ht-c)

;;(define is-there? (ht-lookup 'chaining ht1 (car in-data-chaining)))    
;;is-there?
|#


;; open-addressing
input-size-n-open-address
(define in-data-open-address (build-list input-size-n-open-address (λ (x) (random (expt 2 31)))))
(define attrib-open-address (make-hash-attrib (hash-attrib-w attrib-chaining)
                                              (hash-attrib-M attrib-chaining)
                                              (cons (odd-random (expt 2 (/ bit-W 2))) (hash-attrib-lst-a attrib-chaining))
                                              (hash-attrib-m attrib-chaining)))

(define-values (ht-oa lst-try) (make-ht-open-address attrib-open-address in-data-open-address))
;(hash-table-vec ht-oa)
lst-try

#|
;; Cuckoo - another open addressing
(define in-data-cuckoo (build-list input-size-n-cuckoo (λ (x) (random (expt 2 31)))))
(define attrib-cuckoo (make-hash-attrib (hash-attrib-w attrib-chaining)
                                              (sub1 (hash-attrib-M attrib-chaining)) ;; M-1
                                              (cons (odd-random (expt 2 (/ bit-W 2))) (hash-attrib-lst-a attrib-chaining))
                                              (first lst-table-size-m-cuckoo)))

(define-values (ht-ck lst-probe) (make-ht-cuckoo attrib-cuckoo in-data-cuckoo))
(hash-table-vec ht-ck)
ht-ck

|#