#lang racket

;; Constants:
;; some guessing words: 
(define WORDS 
  '((h e l l o)
    (w o r l d)
    (i s)
    (a)
    (s t u p i d)
    (p r o g r a m)
    (a n d)
    (s h o u l d)
    (n e v e r)
    (b e)
    (u s e d)
    (o k a y)
    ))

(define (fill-a-list sym N)
  (build-list N (λ (x) sym)))


(define (random-pick-1 lst)
  (first lst)
  )
(define (random-pick-2 lst)
  #f ; HOMEWORK
  )
(define (random-pick-3 lst)
  #f ; HOMEWORK
  )
(define (random-pick-4 lst)
  #f ; HOMEWORK
  )

(define random-pick random-pick-1)

; pick a word
(define goal-word (random-pick WORDS))

(define current-word (fill-a-list '_ (length goal-word)))

(define num-chance (* (length goal-word) (length goal-word)))
(define current-chance 0)
  
(define flag #t)
(define (our-equal? lst1 lst2)
  (equal? lst1 lst2))


;; produce #f when the difference is found
(define (our-equal-new? lst1 lst2)
  (cond
    [(and (empty? lst1) (empty? lst2)) #t]
    [(empty? lst1) #f]
    [(empty? lst2) #f]
    [else
     (cond
       [(equal? (first lst1) (first lst2)) 
        (our-equal-new? (rest lst1) (rest lst2))]
       [else #f])]))
  


(our-equal-new? (list) (list 'a 'b 'c))


(define lst1 (list 'a 'b 'c))
(define lst2 (list 'a 'b 'c))

;; produce #f when the difference is found
(define (lst1-lst2-equal?)
  (cond
    [(and (empty? lst1) (empty? lst2)) #t]
    [(empty? lst1) #f]
    [(empty? lst2) #f]
    [else
     (cond
       [(equal? (first lst1) (first lst2)) 
        (set! lst1 (rest lst1))
        (set! lst2 (rest lst2))
        (lst1-lst2-equal?)]
       [else #f])]))

(lst1-lst2-equal?)


; function : char -> Void 
; current-word is replaced if chr is in the goal-word.
;      (_ _ _ _ _) 
;'h -> (h _ _ _ _) Youright
;'o -> (h _ _ _ o) Youright
;'l -> (h _ l l o) Youright
;'e -> (h e l l o) You won.
(define (guess chr)
  (let ([new-word
         (map (λ (g-chr c-chr) 
                (cond
                  [(symbol=? chr g-chr)
                   chr]
                  [else c-chr]
                ))
              goal-word current-word)])
    (set! current-word  new-word)
    (printf "current-chance:~a\n" current-chance)
    (cond
      [(our-equal? current-word goal-word)
       (begin
          (printf "You won : current word:~a\n" current-word))]
      [else
       (begin
         
         (set! current-chance (add1 current-chance))
         (if (<= current-chance num-chance) ; compare xx with num-chance
           (printf "No not yet: currentword:~a\n" current-word)
           (printf "No chance available , You lose, this is what you matched:~a\n" current-word)))])))
  current-word
 (guess 'e) 
 (guess 'h) 
 (guess 's) 
 (guess 'a) 
 (guess 'k) 
 (guess 'r) 
 (guess 'u) 
 (guess 'k)
 (guess 'e) 
 (guess 'h) 
 (guess 's) 
 (guess 'a) 
 (guess 'k) 
 (guess 'r) 
 (guess 'u) 
 (guess 'k)
 (guess 'e) 
 (guess 'h) 
 (guess 's) 
 (guess 'a) 
 (guess 'k) 
 (guess 'r) 
 (guess 'u) 
 (guess 'k)
 (guess 'e) 
 (guess 'h) 
 (guess 's) 
 (guess 'a) 
 (guess 'k) 
 (guess 'r) 
 (guess 'u) 
 (guess 'k)
  
    current-word
  
  