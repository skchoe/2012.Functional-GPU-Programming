#lang racket
(provide (all-defined-out))
(require "mathutils.rkt")

(define (odd-random rng)
  (let ([n (random rng)])
    (if (odd? n) n (odd-random rng))))

(define w 32)


;universe
(define list-M '(10 12 14))

(define limit (expt 2 31)) ;chenge 10 to max of 0......2^31 = (expt 2 31)
(define (create-universe n)
  (build-list n (λ (x) (random limit))))
  

;; output '(mus mxs vars)
(define (l-stat->l-mus-mxs-vrs l-mu-mx-var)
  (let* ([mu_s (mean-of-list (map first l-mu-mx-var))]
         [max_s (mean-of-list (map second l-mu-mx-var))]
         [var_s (mean-of-list (map third l-mu-mx-var))])
    (list mu_s max_s var_s)))

;; n : length of a universe
;; num-univ : length of list of universe
;; output : list of universe
(define (size->l-univ n num-univ)
  (map create-universe (build-list-X num-univ n)))

(define (build-list-X n x)
  (build-list n (λ (y) x)))

;universelist
;hotel

(define M (first list-M))
(define m (expt 2 M));房间

(define (hash-chaining a x m w) ;(arithmetic-shift (* a x)(- m w)))
  (floor (* (/ (modulo (* a x) (expt 2 w)) (expt 2 w)) (expt 2 M))))

