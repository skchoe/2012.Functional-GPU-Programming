#lang racket
(require racket/vector
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
         plot
         "mathutils.rkt"
         "listutils.rkt")

;(define list-alpha '(1 10 100 1000))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define list-alpha '(1 5 25 625))
(define (alpha->n alpha)
  (* alpha (expt 2 M)))
(define n (* (first list-alpha) (expt 2 (first list-M))))

(define a (odd-random (expt 2 31)))
(define hotel (make-vector m'()))
(define universelist (create-universe n))
;hash function
(define hash hash-chaining)


;H is hotel, p as person->there is no out put


;; m w are defined global
(define (insert h p seed)
;;get room by hash,put new numbers there
  (local 
    ((define pos (hash seed p m w))
     (define current-members (vector-ref h pos))
     (define new-members (cons p current-members)))
    (vector-set! h pos new-members)))



;put new members there

;hotel


;(for-each (λ (x) (insert hotel x (odd-random limit))) universelist)
;(mu-max-variance (map (λ (x) (length x)) (vector->list hotel)))

;; input univ:universe 
;; input seed:hash-function-seed
;; output  '(mu mx variance)
;; how: -> list of length ->
(define (univ->stat univ seed)
  ;; m w are defined in global 
  (let* ([ht (make-vector m '())])
    ;; insert element in univ into hash table ht
    (for-each (λ (x) (insert ht x seed)) univ)
    (let* ([l-length (map (λ (x) (length x)) (vector->list ht))]
           [mu (average-of-list l-length)];; average mu
           [mx (max-in-list l-length)];; maximum
           [vr (variance l-length)]);; variance
      (list mu mx vr))))

;(define l-univ (size->l-univ (alpha->n (first list-alpha)) 3))

(define (l-univ->l-stat l-univ len seed)
  (map univ->stat 
       l-univ
       (build-list-X len seed)))



;; list of '(mu max varience)0
;(define l-mu-mx-var
;  (l-univ->l-stat l-univ (length l-univ) (odd-random limit)))

(define (l-univ->l-mus-mxs-vrs l-univ len seed)
  (l-stat->l-mus-mxs-vrs (l-univ->l-stat l-univ len seed)))

;(l-univ->l-mus-mxs-vrs l-univ (length l-univ) (odd-random limit))
         

;; given alpha -> n 
;; -> hash and 3 hash tables 
;; -> 3 (mu max var) 
;; -> (mus maxs vars)
;; M is global
(define (alpha->stat-star alpha)
  (let* (;; universe
         [n (alpha->n alpha)]
         [num-samples 3]
         [l-univ (size->l-univ n num-samples)])
    (l-univ->l-mus-mxs-vrs l-univ num-samples alpha)))



(map alpha->stat-star list-alpha)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; l-dom : list of number
;; l-rng : list of list of numbers -> length of elt == number of lines in a plot
(define (plot-hash-result l-dom l-rng)
  (local ((define fit-fun
            (lambda (x m b) (+ b (* m x))))
          (define (fitted data) 
            (fit fit-fun '((m 1) (b 1))
                 data)))
    
    (let* ([num-lines (length (first l-rng))]
           [colors (list 'black 'red 'blue)];; 4 colors are enough
           
           [l-first (map first l-rng)]
           [l-second (map second l-rng)]
           [l-third (map third l-rng)]
           
           [data-first (map list->vector (map (λ (d r) (list d r 1)) l-dom l-first))]
           [data-second (map list->vector (map (λ (d r) (list d r 1)) l-dom l-second))]
           [data-third (map list->vector (map (λ (d r) (list d r 1)) l-dom l-third))])
      
      (plot (mix (points data-first #:color (first colors))
                 (points data-second #:color (second colors))
                 (points data-third #:color (third colors))
                 (line (fit-result-function (fitted data-first)) #:color (first colors)) 
                 (line (fit-result-function (fitted data-second)) #:color (second colors))
                 (line (fit-result-function (fitted data-third)) #:color (third colors)))
            #:x-min (- (first l-dom) 100) #:x-max (+ 100 (last l-dom))
            #:y-min 0 #:y-max (+ 1- (max (max-in-list l-first) (max-in-list l-second) (max-in-list l-third)))))))
  
  
  (plot-hash-result (map alpha->n list-alpha) (map alpha->stat-star list-alpha))
