#lang racket

(require "ht-defs.rkt")

(provide (all-defined-out))

(define (make-ht-cuckoo attrib lst-input) 
  (let* ([random-rng (expt 2 31)]
         [w (hash-attrib-w attrib)] 
         [M (hash-attrib-M attrib)] ;; alread M-1
         [m (hash-attrib-m attrib)] ;; m is already based on 2^(M-1)
         [vec-l (make-vector m '())]
         [vec-r (make-vector m '())]
         [max-rehashing 100]
         [max-probing (hash-attrib-m attrib)]) ;; probing is same as size of ht
    (let loop ([a-l (odd-random random-rng)]
               [a-r (odd-random random-rng)]
               [rehashing-i 0])
      (printf "rehashing-i - ~a\n" rehashing-i)
      (cond
        [(< rehashing-i max-rehashing)
         (let* ([l-prob (insert-with-hash attrib vec-l vec-r lst-input a-l a-r rehashing-i max-probing)])
           (if l-prob ;; non false means prob is lst of probe for each x in lst-input
               l-prob
               (let ([new-a-l (odd-random random-rng)]
                     [new-a-r (odd-random random-rng)])
                 (loop new-a-l new-a-r (add1 rehashing-i)))))]
        ;; given hashing...
        [else (error "Maximum rehashing reached - quit")]))))


;; #f if number of probing reached max-probing
; '(num-of-prob ...) for each lst-input '(x ...)
;; for each element in sequence from lst-input, do-insert hash-cuckoo.
(define (insert-with-hash attr vec-l vec-r lst-input hash-a-l hash-a-r re-hashing-i max-probing)
  (local (;; x input from lst-input
          ;; i number of probe?
          ;; ht-side : 'left or 'right - where x want to save (left by default)
          (define (local-insert x i ha-l ha-r ht-side)
            (let* ([w (hash-attrib-w attr)]
                   [M (hash-attrib-M attr)]
                   [hc-l (hash-cuckoo w M ha-l x)]
                   [hc-r (hash-cuckoo w M ha-r x)]
                   [xl (vector-ref vec-l hc-l)]
                   [xr (vector-ref vec-r hc-r)])
              
              (printf "local-insert :x(~a), i(~a), ht-side(~a)\n" x i ht-side)
              
              (cond
                [(empty? xl) (begin 
                               (vector-set! vec-l hc-l (cons x '()))
                               i)]
                [(empty? xr) (begin 
                               (vector-set! vec-r hc-r (cons x '()))
                               i)]
                [else
                 (if (equal? i max-probing) 
                     #f
                     (cond
                       [(symbol=? ht-side 'left) 
                        (begin
                          (vector-set! vec-l hc-l (cons x '()))
                          (local-insert (first xl) (add1 i) ha-l ha-r 'right))]
                       [(symbol=? ht-side 'right)           
                        (begin
                          (vector-set! vec-r hc-r (cons x '()))
                          (local-insert (first xr) (add1 i) ha-l ha-r 'left))]))]))))
    
    (let loop ([lst-prob '()]
               [i 0])
      (cond 
        [(equal? (length lst-input) i) lst-prob]
        [else (let* ([probe (local-insert (list-ref lst-input i) 0 hash-a-l hash-a-r 'left)])
                (if probe ;; newly inserted
                    (loop (cons probe lst-prob) (add1 i))
                    #f))]))))

(define (ht-cuckoo-lookup ht x) #f)


