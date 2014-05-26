#lang typed-scheme

;(define-struct: Child-Struct ([son : String] [daughter : String]))
(require/opaque-type Child-Struct child-struct? "typed-scheme-untyped.scm")

(require/typed "typed-scheme-untyped.scm"
               [ten Number]
               [mult-ten (Number -> Number)])

ten
(mult-ten 2)
(provide ten)
;(provide: [add-proc : (Number -> Number)]
;          [minus : (Number -> Number)])
(provide: [hundred Number])
(define: hundred : Number 100)

(provide: [add-proc  (Number -> Number)])
(define: add-proc : (Number -> Number)
  (lambda (x) (add1 x)))

(provide: [back Number])
(define: back : Number 100)

(define: minus : (Number -> Number)
  (lambda (x) (- 1.0 x)))

(: plus : (Number -> Number))
(define plus 
  (lambda (x) (+ x 1)))

;(define: cond-proc : (U Number (Number -> Number) String)
;  (cond
;    [(number? 1) 1]
;    [(string? "1") (lambda (x) (- 1.0 x))]
;    [else "nothing"]))

(: cond-proc1 (U Number (Number -> Number) String))
(define cond-proc1
  (cond
    [(number? 1) 1]
    [(string? "1") plus]
    [else "nothing"]))

(define: (add1 (x : Number)) : Number
  (+ 1 x))

(: add2 (Integer -> Integer))
(define (add2 x) (+ 2 x))
 
(define-struct: Nothing ())
(define-struct: (a) Just ((v : a)))
(define-type-alias (Maybe a) (U Nothing Integer (Just a) (a -> a)))

(: find (Number (Listof Number) -> (Maybe Number)))
(define (find v l)
  (cond [(null? l) (make-Nothing)]
        [(= v (car l)) (make-Just v)]
        [(string? "A") minus]
        [else (find v (cdr l))]))

;(find 1 (list 21 34))

(: findv (Maybe Number))
(define findv
  (cond 
    [(string? "A") (make-Nothing)]
    [(integer? 1) 1]
    [(number? 100) (make-Just 10)]
    [else (make-Nothing)]))

(: add1-ftn (Integer -> Integer))
(define add1-ftn
  (lambda (x) (+ 1 x)))

(: add1v ((Vectorof Integer) -> (Vectorof Integer)))
(define add1v (lambda (v) (list->vector (map add1-ftn (vector->list v)))))

(define: add1tv : ((Vectorof Integer) -> (Vectorof Integer))
  (lambda: ([v : (Vectorof Integer)]) (list->vector (map add1-ftn (vector->list v)))))

(add1v (vector 1 2 3))