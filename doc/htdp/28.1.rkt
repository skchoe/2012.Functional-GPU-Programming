#lang racket
(define Graph 
  '((A (B E))
    (B (E F))
    (C (D))
    (D ())
    (E (C F))
    (F (D G))
    (G ())))

;; node is a symbol
;; find-route : node node graph  ->  (listof node)
;; to create a path from origination to destination in G
(define (find-route origination destination G)
  (cond
    [(empty? G) '()]
    [(equal=? origination destination) (list destination)]
    [else
     (local ((define f_or_l (find-route/list (rest origination) destination G)))
     (cond
       [(equal? f_or_l #f) #f]
       [else (cons origination f_or_l)]))]))

(define (find-route/list lo-origination destination G)
  #f)

(define (node-equal? nd1 nd2)
  (symbol=? nd1 nd2))

(find-route 'C 'D Graph)