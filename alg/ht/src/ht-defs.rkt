#lang racket
(provide (all-defined-out))

(define bit-W 32)
(define lst-M '(10 12 14))
(define lst-alpha '(1 10 100 1000))
(define lst-s '(0.1 0.2 0.5 0.7 0.9))

(define (odd-random limit)
  (let ([rdm (random limit)])
    (if (odd? rdm) rdm (odd-random limit))))
                          
(define lst-table-size-m (map (λ (x) (expt 2 x)) lst-M))
(define lst-table-size-m-cuckoo (map (λ (x) (expt 2 x)) (map sub1 lst-M)))

(define input-size-n-chaining (* (first lst-alpha) (expt 2 (first lst-M))))
(define input-size-n-open-address (inexact->exact (round (* (first lst-s) (expt 2 (first lst-M))))))
(define input-size-n-cuckoo input-size-n-chaining)

(define (hash-first w M a x)
  (let ([v (floor  (* (/ (modulo (* a x) (expt 2 w)) (expt 2 w)) (expt 2 M)))])
    ;(newline)
    ;(printf "*ax:~a, (mod:~a)\n" (* a x) (modulo (* a x) (expt 2 w)))
    ;(printf "Hash-code first = ~a with M(~a), \n" v M)
    v))

(define (hash-second w M a x)
  (arithmetic-shift (* a x) (- M w)))

(define hash-chaining hash-first)

(define (hash-open-address w M a b i x)
  (let* ([ha (hash-chaining w M a x)]
         [hb (hash-chaining w M b x)])
    ;(printf "hash-open addr a(~a), b(~a), x(~a), i(~a), ha(~a), hb(~a)\n" a b x i ha hb) 
    (modulo (+ ha (* i hb)) (expt 2 M))))

(define hash-cuckoo hash-chaining)

(define a (odd-random (expt 2 (/ bit-W 2))))

(define x (expt 2 10))
(define M (second lst-M))

;(hash-org bit-W M a x)
;(hash bit-W M a x)

(define-struct hash-pair (key value))
(define-struct hash-attrib (w M lst-a m))
(define-struct hash-table (attrib vec))