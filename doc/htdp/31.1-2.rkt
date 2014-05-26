#lang racket

;; listof x -> listof x
;; reverse of input list of x
(define (invert alox)
  (local [(define (send-elt-to-last x alox)
            (printf "send2last: ~a\n" x)
            (pretty-display alox)
            (cond
              [(empty? alox) (cons x '())]
              [else (cons (first alox) (send-elt-to-last x (rest alox)))]))]
    
    (printf "invert\n")
    (pretty-display alox)
    (cond 
      [(empty? alox) '()]
      [else (send-elt-to-last (first alox) (invert (rest alox)))])))


(define (invert2 alox)
  (local [(define (rev alox acc)
            (pretty-print alox)
            (pretty-print acc)
            (cond
              [(empty? alox) acc]
              [else 
                (rev (rest alox) (cons (first alox) acc))]))]
    (rev alox '())))


(define (invert3 alox)
  (let loop ([org alox]
             [newlst '()])
    
    (pretty-print org)
    (pretty-print newlst)
    (cond
      [(empty? org) newlst]
      [else 
       (loop (rest org) (cons (first org) newlst))])))

;(invert '(1 2 3 4 5 6 7 8 9 0))
;(invert2 '(1 2 3 4 5 6 7 8 9 0))
;(invert3 '(1 2 3 4 5 6 7 8 9 0))