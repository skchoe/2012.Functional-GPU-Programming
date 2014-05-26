#lang racket

(define env (make-hash))
(define constraint-env (make-hash))

(define (in-env? var value)
  (let ((value-list (hash-ref env var '())))
    (if (member value value-list) #t #f)))

(define (add-to-env var new-value)
  (let ((value (in-env? var new-value)))
    (unless value
      (hash-set! env var (cons new-value (hash-ref env var '()))))))

(define (foreach-in-env var fn)
  ;(printf "~a\n foreach-en22 var:~a ~a\n" env var (hash-ref env var #f))
  (when (hash-ref env var #f)
    (for-each fn (hash-ref env var '()))))


(define (in-constraint? var constraint)
  (let ((constraint-list (hash-ref constraint-env var '())))
    (if (member constraint constraint-list) #t #f)))

(define (add-to-constraint var constraint)
  (let ((constraint-list (in-constraint? var constraint)))
    (unless constraint-list
      (hash-set! constraint-env var (cons constraint (hash-ref constraint-env var '()))))))

(define (foreach-in-constraint var fn)
  (when (hash-ref constraint-env var #f)
    (for-each fn (hash-ref constraint-env var '()))))


;; Add new value for var to E
(define (new-value! var value)
  (printf "\nnew-value!!called ...\n var:~a,  value:~a\n"
          var value)
  (unless (in-env? var value)
    (add-to-env var value))
  
  (printf "E:~a\nC:~a\n" env constraint-env))


;; Add new const for var to C
(define (new-constraint! var constraint)
  (printf "\nnew-constraint!!called ... var:~a, const:~a\n"
           var constraint)
  (unless (in-constraint? var constraint)
    (add-to-constraint var constraint))
  
  (printf "E:~a\nC:~a\n" env constraint-env))


(define (interpret-constraint c v)
  (printf "IC const:~a value:~a~n" c v)
  (match (cons c v)
    [`((propagate-to ,x) . ,v) (new-value! x v)]
    [`((propagate-car-to ,x) . (cons ,y1 ,y2)) (new-constraint! y1 `(propagate-to ,x))]
    [`((propagate-cdr-to ,x) . (cons ,y1 ,y2)) (new-constraint! y2 `(propagate-to ,x))]
    [`((application ,result ,arg) . (lambda ,para ,_ ,finalvar))
     (new-constraint! finalvar `(propagate-to ,result))
     (new-constraint! arg `(propagate-to ,para))]
    [`((conditional-prop ,test ,from ,to) . ,value) 
     (when (eq? (null? value) test) (new-constraint! from `(propagate-to ,to)))]
    [_ (printf "no~\n") (void)]))


(define (SBA prog)
  (printf "\n\nprog:~a\n" prog)
  (let ([fv-N 
         (match prog
           [(? symbol? x) (printf "*** symbol? x:~a\n" x) x]
           [`(let (,x ,exp) ,body)
            (begin
              (printf "exp:~a\n" exp)
              (match exp
                ;; New-Values
                [(? integer? c) (new-value! x c)]
                [`(cons ,y1 ,y2) (new-value! x `(cons ,y1 ,y2))]
                [`(lambda (,y) ,N)
                 (let ([finalvar-N (SBA N)])
                   (printf "result of (SBA N):~a\n" finalvar-N)
                   (new-value! x `(lambda ,y ,N ,finalvar-N)))]
                
                ;; New-Constraints
                [`(car ,y) (new-constraint! y `(propagate-car-to ,x))]
                [`(cdr ,y) (new-constraint! y `(propagate-cdr-to ,x))]
                [`(if ,y ,M1 ,M2)
                 (let ([finalvar-M1 (SBA M1)][finalvar-M2 (SBA M2)])
                   (new-constraint! y `(conditional-prop #t ,finalvar-M1 ,x))
                   (new-constraint! y `(conditional-prop #f ,finalvar-M2 ,x)))]
                [`(apply ,y ,z)(new-constraint! y `(application ,x ,z))]
                [_ 

                 (let ([finalvar-exp (SBA exp)])
                   (printf "match-else case: ~a, final Val:~a\n" exp finalvar-exp)
                   (new-constraint! finalvar-exp `(propagate-to ,x)))])
              (SBA body))]
           [_ (printf "Not regular expression in prog:~a\n" prog)])])
    (printf "End of SBA fv-N : ~a for prog:~a\n" fv-N prog)
    fv-N))

(let ([expr (read (open-input-file "test_if.as"))]) ; test_if.as
  (printf "\n\n\nSBA result:~a\n" (SBA expr))
  (printf "ENV:~a\n" env)  
  (printf "CST:~a\n" constraint-env))
;
;(match (current-command-line-arguments)
;  ;[(vector f1) (SBA (read (open-input-file f1)))]
;  [_ (SBA ()) ]
;  ;[else (error "insufficient arguments")]
;  )
