#lang racket
;; http://en.wikipedia.org/wiki/Multiplication_algorithm#Karatsuba_multiplication

;; Compute the base-10 logarithm of a number
(define (log10 x)
  (/ (log x) (log 10)))

(define (logb x b)
  (/ (log x) (log b)))

;; exact exact -> exact
;; mult using Karatsuba algorithm
(define (karatsuba in0 in1 base)
  (cond
    [(or (zero? in0) (zero? in1)) 0]
    [else
     (let* ([m (inexact->exact 
                (floor (logb in0 base)))])
       (if (zero? m)
           (* in0 in1)
           (let*-values
               ([(ds) (expt base m)]
                [(q0 r0) (quotient/remainder in0 ds)]
                [(q1 r1) (quotient/remainder in1 ds)]
                
                [(z0) (karatsuba r0 r1 base)]
                [(z2) (karatsuba q0 q1 base)]
                [(z1) (- (karatsuba (+ q0 r0) (+ q1 r1) base)
                         z0
                         z2)])
            
             (+ (* z2 (* ds ds))
                (* z1 ds)
                z0))))]))

  
(define in0 135851547)
(define in1 124381185)
(let* ([start0 (current-inexact-milliseconds)]
       [k-result (karatsuba in0 in1 10)]
       [end0 (current-inexact-milliseconds)]
       
       [start1 (current-inexact-milliseconds)]
       [m-result (* in0 in1)]
       [end1 (current-inexact-milliseconds)])
  (printf "~a, ~a\nEqual? ~a\n" 
          k-result
          m-result
          (equal? k-result m-result))
  (printf "Time: K(~a), M(~a)\n" 
          (- end0 start0)
          (- end1 start1)))

