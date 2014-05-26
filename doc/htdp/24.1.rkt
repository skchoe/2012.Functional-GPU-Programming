#lang racket

(define (filter1 cmp-op lox t)
  (cond 
    [(empty? lox) '()]
    [else 
     (if (cmp-op (car lox) t) 
         (cons (car lox) (filter1 cmp-op (cdr lox) t))
         (filter1 cmp-op (cdr lox) t))]))

(define-struct ir (name price))

(define (find aloir nm)
  (local ((define (equal?-ir irx name)
            (if (equal? (ir-name irx) name) #t #f)))
    (filter1 equal?-ir aloir nm)))

(define (find-lambda aloir nm)
  (filter1 (lambda (irx name)
             (if (equal? (ir-name irx) name) #t #f))
           aloir
           nm))

(ir-name (car (find (list (make-ir 'a 1) (make-ir 'b 2)) 'a)))