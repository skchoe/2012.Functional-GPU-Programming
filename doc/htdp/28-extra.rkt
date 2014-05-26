#lang racket


;; find-route : node node graph  ->  (listof node) or false
;; to create a path from origination to destination in G
;; if there is no path, the function produces false
(define (find-route origination destination G)
  (cond
    [(symbol=? origination destination) (list destination)]
    [else (local ((define possible-route 
		    (find-route/list (neighbors origination G) destination G)))
	    (cond
	      [(boolean? possible-route) false]
	      [else (cons origination possible-route)]))]))

;; find-route/list : (listof node) node graph  ->  (listof node) or false
;; to create a path from some node on lo-Os to D
;; if there is no path, the function produces false
(define (find-route/list lo-Os D G)
  (cond
    [(empty? lo-Os) false]
    [else (local ((define possible-route (find-route (first lo-Os) D G)))
	    (cond
	      [(boolean? possible-route) (find-route/list (rest lo-Os) D G)]
	      [else possible-route]))]))

;; node is name: symbol
;; G is a graph: list of node/neighbors
(define (neighbors node G)
  (local 
    ((define (nbr nd G)
       (cond 
         [(empty? G) '()]
         [else 
          (let ([nd (first G)])
            (cond 
              [(symbol=? node (first nd)) (first (rest nd))]
              [else (nbr nd (rest G))]))])))
    (nbr node G)))
    
;; now find until nothing is found.
;; termination condition? - end of traversal for all neighbor node.
(define (find-all-routes origination destination G)
  (cond
    [(symbol=? origination destination) (list (list destination))] ; because G is directed graph
    [else (local ((define lst-possible-route
		    (find-all-routes/list (neighbors origination G) destination G)))
	    (cond
	      [(empty? lst-possible-route) '()]
	      [else (map cons 
                         (build-list (length lst-possible-route) (λ (x) origination))
                         lst-possible-route)]))]))

;; output: list of list from list of neighbor to destination
(define (find-all-routes/list lo-Os D G)
  (cond
    [(empty? lo-Os) '()]
    [else (local ((define lst-possible-route (find-all-routes (first lo-Os) D G)))
	    (cond
	      [(empty? lst-possible-route) (find-all-routes/list (rest lo-Os) D G)]
	      [else (append lst-possible-route (find-all-routes/list (rest lo-Os) D G))]))]))

(define Graph 
  '((A (B E))
    (B (E F))
    (C (D))
    (D ())
    (E (C F))
    (F (D G))
    (G ())))

(neighbors 'C Graph)
(find-route 'A 'G Graph)
(find-all-routes 'A 'G Graph)
(find-all-routes 'D 'C Graph)
(find-all-routes 'E 'D Graph)