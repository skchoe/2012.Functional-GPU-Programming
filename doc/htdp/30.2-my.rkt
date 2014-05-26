#lang racket
;; route-exists? : node node simple-graph  ->  boolean
;; to determine whether there is a route from orig to dest in sg
(define (route-exists? orig dest sg)
  (cond 
    [(empty? sg) #t]
    [else (let ([nb (neighbor orig sg)])
            (route-exists? nb dest sg))]))

(define (neighbor nd sg)
  (cond
    [(empty? sg) #f]
    [else 
     (cond
       [(symbol=? (first (first sg)) nd) (last (first sg))]
       [else (neighbor nd (rest sg))])]))
                                         


(define sg '((A B) (B C) (C E) (D E) (E F)))
;(route-exists? 'A 'F sg)


(define (route-exists2? orig dest sg)
  (local [(define (route-exists-accum? orig dest sg lst-visited)
            (cond 
              [(empty? sg) #t]
              [else (let ([nb (neighbor orig sg)])
                      (pretty-display lst-visited)
                      (if (member nb lst-visited)
                          #f
                          (route-exists-accum? nb dest sg (cons nb lst-visited))))]))]
    
    (route-exists-accum? orig dest sg '())))




(define (route-exists3? org dest sg)
  (let route-exists-accum? ([(orig orig)] 
                            [(dest dest)] 
                            [(sg sg  )]
                            [(lst-visited '())])
            (cond 
              [(empty? sg) #t]
              [else (let ([nb (neighbor orig sg)])
                      (pretty-display lst-visited)
                      (if (member nb lst-visited)
                          #f
                          (route-exists-accum? nb dest sg (cons nb lst-visited))))])))
    


(route-exists2? 'A 'F sg)