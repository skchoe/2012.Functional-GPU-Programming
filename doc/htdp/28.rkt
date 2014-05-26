#lang racket


(define graph '((A (B E))
    (B (E F))
    (C (D))
    (D ())
    (E (C F))
    (F (D G))
    (G ())))

;; find-route : node node graph  ->  (listof node)
;; to create a path from origination to destination in G


(define l1 '(A B C D E F G))
(define l2 '((E B) (E F) (D) () () (D G) ()))
(define l3 '((#t #f) (#f #f) (#f) () () (#f #f) ()))

;; output : listof node or '()
(define (find-route/list lon dest l1 l2)
  (cond 
    [(empty? lon) #f]
    [else 
     (or (find-route (first lon) dest l1 l2)
         (find-route/list (rest lon) dest l1 l2))]))

;; get position of elt in lst
;; if lst='() output #f
(define (idx-node elt lst)
  (local ((define (idx-node-i elt lst i)
            (cond 
              [(empty? lst) #f]
              [(symbol=? elt (first lst)) i]
              [else (idx-node-i elt (rest lst) (add1 i))])))
          (idx-node-i elt lst 0)))
  
;;find elt in l2 whose position is same as org in l1
(define (next-nodes org l1 l2)
  (let ([i (idx-node org l1)])
    (list-ref l2 i)))

;; output : list of nodes '(A B F G) or '()
(define (find-route org dest l1 l2)
  (cond
    [(symbol=? org dest) (cons dest '())]
    [else 
     (let ([b-l (find-route/list (next-nodes org l1 l2) dest l1 l2)])
       (if b-l 
           (cons org b-l)
           #f))]))
           


(find-route 'A 'G l1 l2)
  

;; output is list of list
(define (find-all-route org dst l-1 l-2)
  #f)

(find-all-route 'A 'B l1 l2)

 
  


        
    