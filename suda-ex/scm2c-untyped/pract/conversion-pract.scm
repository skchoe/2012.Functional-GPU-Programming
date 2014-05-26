#lang scheme 

(require scheme/list)

(define a '(define name (lambda (x y) (+ x y))))

(car a) ; define
(cadr a) ; name
(define lam (caddr a))
lam
(cadr lam) ; '(x y)
(caddr lam)

; (define (name x y) (+ x y))
(define b (append (list 'define (cons (cadr a) (cadr lam)) (caddr lam))))
b

(define c '(define name : (Integer Integer -> Integer)
             (lambda (x y) (+ x y) (- x y))))
c

; in lambda typed proc expression,
; get-type-protop gets type decl. part
(define (get-type-protop t-proc)
  (cadddr t-proc))

; in lambda typed proc expression,
; get-num-args gets number of arguments
(define (get-formal-vars t-proc)
  (let* ([lam-body (caddr (cddr t-proc))])
    (cadr lam-body)))
  
(define (get-num-formals t-proc)
  (let* ([arg-list (get-formal-vars t-proc)])
    (length arg-list)))

;; in lambda typed proc expression
; this returns list of types of formals
(define (get-formal-types c)
  (let* ([type-protop (get-type-protop c)]
         [num-formals (get-num-formals c)])
    (if (< (length type-protop) num-formals)
        (error "numformal is bigger than all prototype")
        (take type-protop num-formals))))
    
(define (build-formal-pairs t-proc)
  (let* ([vars (get-formal-vars t-proc)]
         [types (get-formal-types t-proc)])
    (if (equal? (length vars) (length types))
        (map (lambda (v T) (list v ': T)) vars types)
        (error "cannot make list of pairs for type declaration\n"))
    ))

; (define: name : (T ... -> Texp) (lambda (arg ... ) exp ...))
; -> (define: (name (arg : T) ...) : Texp exp ...)
(define (lambda->procedure sexp)
  (let* ([name (cadr sexp)]
         [lst-typed-arg (build-formal-pairs sexp)]
         [proc-type (proc-return-type sexp)]
         [lambda-term (caddr (cddr sexp))]
         [lst-exp-for-body (cddar (cddddr sexp))])
    (append (list 'define: (cons name lst-typed-arg) ': proc-type) lst-exp-for-body)))

(define (proc-return-type t-proc)
  (let* ([type-protop (get-type-protop t-proc)])
    (last type-protop)))

(printf "-----------\n")
(lambda->procedure c)
(cddar (cddddr c))
(get-type-protop c)
(get-num-formals c)
(get-formal-types c)
(define (get-formals t-proc)
  (let* ([name-arg (cadr t-proc)]
         [lst-formal (cdr name-arg)])
    lst-formal))
(build-formal-pairs c)
(proc-return-type c)
;(define (lambda->procedure sexp)
;  (let* ([formals (get-formals sexp)]
;         [vars (typed-formals->formal-vars formals)]
;         [types (typed-formals->formal->types formals)])
;    
                                                  
                                                  
;; ([v : T] ...) -> (v ...) (T ...)
(define (typed-formals->formal-vars formals)
  (map (lambda (decl) (car decl)) formals))

(define (typed-formals->formal-types formals)
  (map (lambda (decl) (caddr decl)) formals))                                                  