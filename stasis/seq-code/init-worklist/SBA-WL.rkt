#lang racket

(require "../hash-tbl-ctype/hash-code.rkt"
         "../input-progs/input-progs.rkt")

  
; while syntax
(define-syntax (while stx)
  (syntax-case stx ()
      ((_ condition expression ...)
       #`(do ()
           ((not condition))
           expression
           ...))))

; generate constraint mapping
(define (gen-constraints prg)
  (letrec ((get-finalvar 
        (λ (ae) 
          (match ae
            [(? symbol? x) x]
            [`(let (,x ,exp) ,body)
             (get-finalvar body)]))))
    (match prg
      [(? symbol? x) '()]
      [`(let (,x ,exp) ,body)
       (let ((gen-constraint 
              (λ (expr)
                (match expr
                  [(? integer? c) (list x c)]
                  [`(cons ,y1 ,y2) (list x `(cons ,y1 ,y2))]
                  [`(lambda (,y) ,N)
                   (let ([finalvar-N (get-finalvar N)])
                     (let ((c (gen-constraints N)))
                       #;(printf "gen-const by ~a:~a, finalvar:~a\n" N c finalvar-N)
                       (if (null? c)
                           (list x `(lambda ,y ,N ,finalvar-N))
                           (list (list x `(lambda ,y ,N ,finalvar-N)) (car c)))))]
                  [`(car ,y) (list y `(propagate-car-to ,x))]
                  [`(cdr ,y) (list y `(propagate-cdr-to ,x))]
                  [`(if ,y ,M1 ,M2)
                   (let ([finalvar-M1 (get-finalvar M1)][finalvar-M2 (get-finalvar M2)])
                     (list (list y `(conditional-prop #t ,finalvar-M1 ,x))
                           (list y `(conditional-prop #f ,finalvar-M2 ,x))))]
                  [`(apply ,y ,z) ;(printf "Apply :~a, ~a\n" y z)
                                  (list y `(application ,x ,z))]
                  [`(set! ,y ,z)
                   (list (list z `(propogate-to ,y))
                         (list z `(propogate-to ,x)))]
                  [`(letcc ,y ,N)
                   (let ([finalvar-N (get-finalvar N)])
                     (list (list finalvar-N `(propagate-to ,x))
                           (list y `(cont ,x))))]
                  [_ 
                   (let ([finalvar-exp (get-finalvar exp)])
                     (list finalvar-exp `(propagate-to ,x)))]))))
         (let ((c (gen-constraint exp)))
           (if (pair? (car c))
               (append c (gen-constraints body))
               (cons c (gen-constraints body)))))])))


; find free variables in a constraint
(define (find-FV constraint)
  (match constraint
    [(? symbol? x) `(,x)]
    [(or `(propagate-to ,x)
         `(propagate-car-to ,x) 
         `(propagate-cdr-to ,x)) (find-FV x)]
    [`(application ,result ,arg) (remove-duplicates (append (find-FV result) (find-FV arg)))]
    [`(conditional-prop ,test ,from ,to) (remove-duplicates (append (find-FV test) (find-FV from) (find-FV to)))]
    [else '()]))


(define (atom-constraint? constraint)
  ;(printf "constraint:~a\n" constraint)
  (match constraint
    [(? number?) #t]
    [(? symbol?) #t]
    [`(cons ,_ ,_) #t]
    [`(lambda ,_ ,_ ,_) #t]
    [else #f]))

(define (interpret-constraint c v)
  ;(printf "c:~a v:~a~n" c v)
  (match (cons c v)
    [`((propagate-to ,x) . ,v) (list x v)]
    [`((propagate-car-to ,x) . (cons ,y1 ,y2)) 
     ;(printf "x:~a, y1:~a, y2:~a\n" x y1 y2)
     (list y1 `(propagate-to ,x))]
    [`((propagate-cdr-to ,x) . (cons ,y1 ,y2)) (list y2 `(propagate-to ,x))]
    [`((application ,result ,arg) . (lambda ,para ,_ ,finalvar))
     (list (list finalvar `(propagate-to ,result))
           (list arg `(propagate-to ,para)))]
    [`((application ,result ,arg) . (cont ,x)) (list arg `(propagate-to ,x))]
    [`((conditional-prop ,test ,from ,to) . ,value)
     (if (eq? (null? value) test) 
         (list from `(propagate-to ,to))
         '())]
    [_ '()]))


(define analysis (make-hash)) 
(define refl (make-hash))

(define (solve-constraints constraints-mapping)
  (let ((worklist
         (filter (λ (var-c) 
                   (let ((constraint (car (cdr var-c))))
                     ; init refl
                     (hash-set! refl (car var-c) (set-union (set constraint) (hash-ref refl (car var-c) (set))))
                     (cond 
                       [(atom-constraint? constraint)
                        ;init analysis
                        (begin
                          (hash-set! analysis 
                                     (car var-c) 
                                     (set-union (set constraint)
                                                (hash-ref analysis (car var-c) (set))))
                          #f)]
                       [else #t]))) 
                 constraints-mapping)))
    
    #;(printf "\nconstraints\n")
    #;(display constraints-mapping)
    
    #;(printf "\nAnalysis init\n")
    #;(display analysis)
    
    #;(printf "\nrefl\n")
    #;(display refl)
    
    (while (not (null? worklist))
           (let ((var-c (car worklist)))
             (set! worklist (cdr worklist))
             (let ((var (car var-c)) (c (car (cdr var-c))))
               (let ((value-set (hash-ref analysis var #f)))
                 (when value-set
                   (set-map 
                    value-set 
                    (λ (v)
                      (let ((cl (interpret-constraint c v)))
                        (cond [(null? cl) '()]
                              [(pair? (car cl))
                               (map (λ (c)
                                      (cond 
                                        [(atom-constraint? (car (cdr c)))
                                         (hash-set! analysis (car c) (car (cdr c)))
                                         (let ((val (hash-ref refl (car c) #f)))
                                           (when val
                                             (set-map val (λ (v)
                                                            (set! worklist (append worklist `((,(car c) ,v))))))))] 
                                        [else 
                                         (set! worklist (append worklist (list c)))]))
                                    cl)]
                              [else
                               (cond
                                 [(atom-constraint? (car (cdr cl)))
                                  (hash-set! analysis (car cl) 
                                             (set-union (set (car (cdr cl))) (hash-ref analysis (car cl) (set))))
                                  (let ((val (hash-ref refl (car cl) #f)))
                                    (when val
                                      (set-map val (λ (v)
                                                     (set! worklist (append worklist `((,(car cl) ,v))))))
                                      ))] 
                                 [else
                                  (set! worklist (append worklist (list cl)))])])))))))))))

; test      
#;(solve-constraints 
 (gen-constraints 
  prog)
 )

#;(define gc
  (gen-constraints
    prog))
#;(define gc
  (gen-constraints
   prog))

(define gc
  (let ([start (current-milliseconds)])
    (begin0
      (gen-constraints
       prog)
      (printf "time for const gen:~a\n" 
              (- (current-inexact-milliseconds) start))
    )))

(let ([start (current-inexact-milliseconds)])  
  (solve-constraints
   gc)
  (printf "Milisec:~a\n" (- (current-inexact-milliseconds) start)))


#|
(printf "\nrefl:\n")
(display refl)

(printf "\ngc\n")
(display gc)

(printf "\nanalysis:\n")
(display analysis)
|#
#;(hash-for-each 
 analysis
 (lambda (k v) 
   (let ([col (hash-code (symbol->string k))])
     (printf "[~a:~a]<~a>\n" k col v)
     #f)))
