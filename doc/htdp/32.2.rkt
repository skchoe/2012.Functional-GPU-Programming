#lang racket
(define MC 3)
(define BOAT-CAPACITY 2)

;data represeentation :
; boat is either 's or 'e, other field are all number
(define-struct rc (s-m s-c boat e-m e-c))

(define (echo-rc rc)
  (printf (string-append "start-m:~a, c:~a\tboat:~a\tend-m:~a, c:~a\t----------------\n")
          (rc-s-m rc) (rc-s-c rc)
          (rc-boat rc)
          (rc-e-m rc) (rc-e-c rc)))

(define (echo-rc/list lst-rc)
  (for-each echo-rc lst-rc))

(define BOAT-LOAD '()) ; list of possible boat load.

(define (make-BOAT-LOAD cap)
  (build-list 1 cons))

(define (sub2 x)
  (- x 2))
(define (add2 x)
  (+ x 2))


;;Exercise 32.2.3. 
(define (state->list-successor state)
  (local
    [(define (new-boat b)
       (cond [(symbol=? b 's) 'e]
             [(symbol=? b 'e) 's]))
     
     (define (boat-ship-1 m c b)
       (cond 
         [(symbol=? b 's)
          (cond
            [(and (< 0 m) (< 0 c) (<= m MC) (<= c MC))
             (list (make-rc (sub1 m) c (new-boat b) (add1 (- MC m)) (- MC c))
                   (make-rc m (sub1 c) (new-boat b) (- MC m) (add1 (- MC c))))]
            [(and (not (zero? m)) (zero? c)) (list (make-rc (sub1 m) c (new-boat b) (add1 (- MC m)) (- MC c)))]
            [(and (zero? m) (not (zero? c))) (list (make-rc m (sub1 c) (new-boat b) (- MC m) (add1 (- MC c))))]
            [else '()])]
         [(symbol=? b 'e)
          (cond
            [(and (< 0 m) (< 0 c) (<= m MC) (<= c MC))
             (list (make-rc (add1 (- MC m)) (- MC c) (new-boat b) (sub1 m) c)
                   (make-rc (- MC m) (add1 (- MC c)) (new-boat b) m (sub1 c)))]
            [(and (not (zero? m)) (zero? c)) (list (make-rc (add1 (- MC m)) (- MC c) (new-boat b) (sub1 m) c))]
            [(and (zero? m) (not (zero? c))) (list (make-rc  (- MC m) (add1 (- MC c)) (new-boat b) m (sub1 c)))]
            [else (error "err2")])]))
     
     (define (boat-ship-2 m c b)
       (cond 
         [(symbol=? b 's)
          (cond
            [(and (<= 2 m) (<= 2 c) (<= m MC) (<= c MC))
             (list (make-rc (sub2 m) c (new-boat b) (add2 (- MC m)) (- MC c))
                   (make-rc m (sub2 c) (new-boat b) (- MC m) (add2 (- MC c)))
                   (make-rc (sub1 m) (sub1 c) (new-boat b) (add1 (- MC m)) (add1 (- MC c))))]
            [(and (<= 2 m) (not (<= 2 c)) (and (<= 1 m) (<= 1 c)))
             (list (make-rc (sub2 m) c (new-boat b) (add2 (- MC m)) (- MC c))
                   (make-rc (sub1 m) (sub1 c) (new-boat b) (add1 (- MC m)) (add1 (- MC c))))]
            [(and (not (<= 2 m)) (<= 2 c) (and (<= 1 m) (<= 1 c)))
             (list (make-rc m (sub2 c) (new-boat b) (- MC m) (add2 (- MC c)))
                   (make-rc (sub1 m) (sub1 c) (new-boat b) (add1 (- MC m)) (add1 (- MC c))))]
            [(and (<= 1 m) (<= 1 c))
             (list (make-rc (sub1 m) (sub1 c) (new-boat b) (add1 (- MC m)) (add1 (- MC c))))]
            [else (error "err3")])]
         [(symbol=? b 'e)
          (cond
            [(and (<= 2 m) (<= 2 c) (<= m MC) (<= c MC))
             (list (make-rc (add2 (- MC m)) (- MC c) (new-boat b) (sub2 m) c)
                   (make-rc (- MC m) (add2 (- MC c))(new-boat b) m (sub2 c) )
                   (make-rc (add1 (- MC m)) (add1 (- MC c)) (new-boat b) (sub1 m) (sub1 c)))]
            [(and (<= 2 m) (<= 1 m) (<= 1 c))
             (list (make-rc (add2 (- MC m)) (- MC c) (new-boat b) (sub2 m) c)
                   (make-rc (add1 (- MC m)) (add1 (- MC c)) (new-boat b) (sub1 m) (sub1 c)))]
            [(and (<= 2 c) (<= 1 m) (<= 1 c))
             (list (make-rc (- MC m) (add2 (- MC c)) (new-boat b) m (sub2 c))
                   (make-rc (add1 (- MC m)) (add1 (- MC c)) (new-boat b) (sub1 m) (sub1 c)))]
            [(and (<= 1 m) (<= 1 c))
             (list (make-rc (add1 (- MC m)) (add1 (- MC c)) (new-boat b) (sub1 m) (sub1 c)))]
            [else '()])]))]
       
  (let* ([s-m (rc-s-m state)]
         [s-c (rc-s-c state)]
         [boat (rc-boat state)]
         [e-m (rc-e-m state)]
         [e-c (rc-e-c state)]
         [direct-next
          (cond
            [(symbol=? boat 's)
             (append (boat-ship-1 s-m s-c boat) (boat-ship-2 s-m s-c boat))]
            [(symbol=? boat 'e)
             (append (boat-ship-1 e-m e-c boat) (boat-ship-2 e-m e-c boat))]
            [else (error "other boat side?")])])
    (filter legal? direct-next))))

;;Exercise 32.2.3. 
;; lst-state -> list of lst-state
(define (state->list-successor/list lst-state)
  (cond
    [(empty? lst-state) '()]
    [else 
     (cons (state->list-successor (first lst-state)) (state->list-successor/list (rest lst-state)))]))

(define (equal? s1 s2)
  (if (and (equal? (rc-s-m s1) (rc-s-m s2))
           (equal? (rc-s-c s1) (rc-s-c s2))
           (symbol=? (rc-boat s1) (rc-boat s2))
           (equal? (rc-e-m s1) (rc-e-m s2))
           (equal? (rc-e-c s1) (rc-e-c s2)))
      #t
      #f))

;;Exercise 32.2.4.
(define (legal? state)
  (let* ([s-m (rc-s-m state)]
         [s-c (rc-s-c state)]
         [boat (rc-boat state)]
         [e-m (rc-e-m state)]
         [e-c (rc-e-c state)])
  (cond
    [(< MC s-m) #f]
    [(< MC s-c) #f]
    [(< MC e-m) #f]
    [(< MC e-c) #f]
    
    [(< s-m s-c) #f]
    [(< e-m e-c) #f]
    [else state])))

;Exercise 32.2.5.
(define (final? state)
  (let* ([s-m (rc-s-m state)]
         [s-c (rc-s-c state)]
         [boat (rc-boat state)]
         [e-m (rc-e-m state)]
         [e-c (rc-e-c state)])
    (cond
      [(and (equal? MC e-m) (equal? MC e-c)) state]
      [else #f])))

;; list of state -> #f or final state
(define (contains-final? lst-state)
  (ormap final? lst-state))


;Exercise 32.2.6. 
;; state -> #f or 
(define (mc-solvable? init-state)
  (local [;; output #f or list of state having path to solution
          (define (local-solvable?/list lst-state acc)
            (cond
              [(empty? lst-state) acc]
              [else
               (let* ([final-state (contains-final? lst-state)])
                 (cond
                   [final-state (cons final-state acc)]
                   [else
                    (let* ([first-state (first lst-state)]
                           [lst-succ (state->list-successor first-state)]
                           [final (local-solvable?/list lst-succ acc)])
                      (if (empty? final)
                          (local-solvable?/list (rest lst-state) acc)
                          (cons first-state final)))]))]))]
    (cond
      [(final? init-state) (list init-state)]
      [else (let* ([result/list (local-solvable?/list (state->list-successor init-state) '())])
              (cond 
                [(empty? result/list) #f]
                [else 
                 (cons init-state result/list)]))])))
            
(define (simple-solvable? init-state max-iter)
  (let loop ([state init-state]
             [iter 0])
    (cond
      [(equal? iter max-iter) (error "Not solvable")]
      [else 
       (let* ([lst-next-state (state->list-successor state)])
         (printf "iter:~a\t" iter)
         (echo-rc/list lst-next-state)
         (newline)

         (cond
           [(empty? lst-next-state) #f]
           [(contains-final? lst-next-state) #t]
           [else (ormap (λ (x) (boolean=? #t x))
                        (map loop lst-next-state (build-list (length lst-next-state) (λ (x) (add1 iter)))))]))])))
                 
                 
                 
#;(define init-state (make-rc 0 3 's 3 0))
#;(echo-rc init-state)



(define init-state (make-rc 1 2 'e 2 1))

(echo-rc init-state)
(printf "--------XXXXXXXXXXX--\n")



(simple-solvable? init-state 10000)
   
#;(for-each echo-rc (mc-solvable? init-state))
                                     

;(define lst-succ (state->list-successor init-state))
;(for-each echo-rc lst-succ)
