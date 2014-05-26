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


; 
(define (new-value! var value)
  (unless (in-env? var value)
    (add-to-env var value))
  (foreach-in-constraint var (lambda (c) (interpret-constraint c value))))

(define (new-constraint! var constraint)
  ;(printf "new-constraint!!called \n ~a\n ~a\n var:~a cons:~a\n" constraint-env env var constraint)
  (unless (in-constraint? var constraint)
    (add-to-constraint var constraint))
  (foreach-in-env var (lambda (value) (interpret-constraint  constraint value))))

(define (interpret-constraint c v)
  ;(printf "c:~a v:~a~n" c v)
  (match (cons c v)
    [`((propagate-to ,x) . ,v) (new-value! x v)]
    [`((propagate-car-to ,x) . (cons ,y1 ,y2)) (new-constraint! y1 `(propagate-to ,x))]
    [`((propagate-cdr-to ,x) . (cons ,y1 ,y2)) (new-constraint! y2 `(propagate-to ,x))]
    [`((application ,result ,arg) . (lambda ,para ,_ ,finalvar))
     (new-constraint! finalvar `(propagate-to ,result))
     (new-constraint! arg `(propagate-to ,para))]
    [`((application ,result ,arg) . (cont ,x)) (new-constraint! arg `(propagate-to ,x))]
    [`((conditional-prop ,test ,from ,to) . ,value) 
     (when (eq? (null? value) test) (new-constraint! from `(propagate-to ,to)))]
    [_ (printf "no~\n") (void)]))


(define (SBA prog)
    (match prog
      [(? symbol? x) x]
      [`(let (,x ,exp) ,body)
       (begin
         (match exp
           [(? integer? c) (new-value! x c)]
           [`(cons ,y1 ,y2) (new-value! x `(cons ,y1 ,y2))]
           [`(lambda (,y) ,N)
            (let ([finalvar-N (SBA N)])
              (new-value! x `(lambda ,y ,N ,finalvar-N)))]
           [`(car ,y) (new-constraint! y `(propagate-car-to ,x))]
           [`(cdr ,y) (new-constraint! y `(propagate-cdr-to ,x))]
           [`(if ,y ,M1 ,M2)
            (let ([finalvar-M1 (SBA M1)][finalvar-M2 (SBA M2)])
              (new-constraint! y `(conditional-prop #t ,finalvar-M1 ,x))
              (new-constraint! y `(conditional-prop #f ,finalvar-M2 ,x)))]
           [`(apply ,y ,z)(new-constraint! y `(application ,x ,z))]
;           [`(set! ,y ,z)
;            (new-constraint! z `(propogate-to ,y))
;            (new-constraint! z `(propogate-to ,x))]
;           [`(letcc ,y ,N)
;            (let ([finalvar-N (SBA N)])
;              (new-constraint! finalvar-N `(propagate-to ,x))
;              (new-value! y `(cont ,x)))]
           [_ 
            (let ([finalvar-exp (SBA exp)])
                  (new-constraint! finalvar-exp `(propagate-to ,x)))])
         (SBA body))]))

(match (current-command-line-arguments)
  [(vector f1) (SBA (read (open-input-file f1)))]
  [_ (SBA (read (open-input-file "test_if.as"))) (printf "~a\n" env)  (printf "~a\n" constraint-env)]
  [else
   (error "insufficient arguments")])
