#lang racket

(provide prog)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; arbitrary length of variables.
;; This example follows general form of orig syntax heap value h has (λ x . M) where M could be (let ..) form
; testing for serical solver 
#;(define prog '(let (id-it (lambda (x) (let (r x) r)))
                (let (t1 1)
                  (let (t2 (apply id-it t1))
                    t1))))
#;(define prog (λ (λ (λ [1] (apply [2] [1])) [1])) (λ (λ [0]) [0]))
; (debruijn idx) (scope level) -> index in enviornment
; env structure
; 0 id-it
; 1 t1
; 2 t2
    
    
; testing for serical solver
#;(define prog '(let (cons-it (lambda (x) (let (r (cons x x)) r)))
                (let (t1 1)
                  (let (pair1 (apply cons-it t1))
                    (let (t3 3)
                      (let (t2 2)
                        (let (pair2 (apply cons-it t2))
                          (let (a (car pair2))
                            a))))))))

; testing for serical solver
#;(define prog
    '(let (cons-it (lambda (x) (let (r (cons x x)) r)))
     (let (t1 1)
       (let (pair1 (apply cons-it t1))
         (let (t3 3)
         (let (t2 2)
           (let (pair2 (apply cons-it t2))
             (let (a (car pair2))
               a))))))))

#;(define prog
  '(let (x (lambda (y) (let (u 1) 
                         (let (z (cons u y))
                           z))))
     (let (z (cons x x))
       z)))

#;(define prog
  '(let (x (let (x 1) x))
     (let (x 2)
       (let (x 3)
         x))))

#;(define prog
  '(let (x (let (y 1) y))
     (let (y 2)
       (let (z 3)
         (let (w (cons y z)))))))

#;(define prog
  '(let (x (let (z-proc (lambda (z)
                          (let (z1 (cons z z))
                            z1)))
             (let (w-proc (lambda (w) 
                            (let (w1 (cdr w))
                              w1)))
               (let (cons1 (cons z-proc w-proc))
                 (let (app-w (apply w-proc cons1))
                   (let (app-zw (apply z-proc app-w))
                     app-zw))))))
     (let (x (lambda (y) 
                    (let (y1 (cons y y)) 
                      y1)))
       (let (car-x (car x))
         (let (app-yx (apply x car-x))
           app-yx)))))


;; need var renaming by alpha conversion.elivered Thursd
;; x1 introduced at term, again at exp in the term, used again at following term.
#;(define prog
  '(let (x1 (let (z-proc (lambda (z)
                           (let (x (cons z z))
                             x)))
              (let (w-proc (lambda (z-proc) elivered Thursd
                             (let (w1 (cdr z-proc))
                               w1)))
                (let (cons1 (cons z-proc w-proc))
                  (let (app-w (apply w-proc cons1))
                    (let (cons1 (apply z-proc app-w))
                      cons1))))))
     (let (w (lambda (x1) 
               (let (y1 (cons x1 x1)) 
                 y1)))
       (let (x2 (let (x1 (car x1))
                  x1))
         (let (x (apply x1 w))
           x2)))))

; prog->deBruijn rep.
#|
(let (let (λ (let (cons [0] [0]) [0]))
       (let (λ (let (cdr [0]) [0])) 
         (let (cons [1] [0])
           (let (apply [1] [0])
             (let (apply [3] [0])
               [0])))))
  (let (λ (let (cons [0] [0]) [0]))
    (let (let (car [1]) [0])
      (let (apply [2] [1]) [1]))))
|#  
  
#;(define prog
  '(let (x (lambda (x) x))
     (let (y (lambda (x) x))
       (let (z (apply y x))
         x))))

;; example that keep track of x's definition at term and exp, use at last term.
#;(define prog
  '(let (x 5)
     (let (y (let (x 7) x))
       (let (z (apply y x))
         z))))
           
#;(define prog 'a)

;; cons
#;(define prog
  '(let (x 1)
     (let (y (cons x x))
       (let (z (cons y y))
         y))))

#;(define prog
  '(let (x (let (y 1)
             (let (z 1)
               (let (w (cons y z))
                 w))))
     x))

;; lambda
#;(define prog
  '(let (t 1)
     (let (x (lambda (x) 
               (let (y1 1)
                 (let (z1 (cons y1 y1))
                   y1))))
       (let (y 1)
         (let (z (apply x y))
           y)))))
#;(define prog
  '(let (t 1)
     (let (x (lambda (x) t)) 
       (let (y 1)
         (let (z (apply x y))
           y)))))
  

;; conditional in single level ->multilevel will be later
#;(define prog
  '(let (t1 #f)
     (let (t2 (if t1 (let (t3 1) t3) (let (t3 2) t3)))
       t2)))

#;(define prog
  '(let (cons-it (lambda (x) (let (r (cons x x)) r )))
     (let (t1 1)
       (let (t1 2)
         (let (t3 #f)
           (let (pair1 (if t3 
                           (let (w1 (apply cons-it t1)) w1)
                           (let (w1 (apply cons-it t1)) w1)))
             (let (t4 2)
               (let (pair2 (apply cons-it t4))
                 (let (a (car pair2))
                   a)))))))))

;; same as paper.
#;(define prog
  '(let (cons-it (lambda (x) (let (r (cons x x)) r)))
     (let (t1 1)
       (let (pair1 (apply cons-it t1))
         (let (t2 2)
           (let (pair2 (apply cons-it t2))
             (let (a (car pair2))
               a)))))))

;; if test
(define prog
  '(let (t1 0)
     (let (t2 1)
       (let (cons-it (lambda (x) (let (r (cons t1 x)) r)))
         (let (t3 (if t1 (let (b1 (apply cons-it t1)) b1) (let (b2 (apply cons-it t2)) b2)))
           t3)))))
;;-> analysis [<t1 1> <t2 2> <r (cons x x)> <cons-it {x, (let (r (cons x x)) r), r}>]
;;-> constraint [<t1 {conditional-prop  #t b1 t3}> <t1 {conditional-prop #f b2 t3}> <cons-it {app b1 t1}> <cons-it {app b2 t2}>]
;; 0->t1, 1->t2, 2->x, 3->r, 4->cons-it, 5->b1, 6->b2, 7->t3
