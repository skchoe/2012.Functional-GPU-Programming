#lang racket
;(1 + ( 1 + (1 + 2)));   
;                -->  int a0=1;int a1=1;int a2=1;int a3=2; 
;                     int ta3=0+a3; int ta2 = a2+ta3; int ta1 = a1+ta2; 
;                     int A = a0+ta1;
;  with output name A, type `int

(define proc 'nop)
(define dom (list 'a 'b 'c))
(define domtype (list 'A 'B 'C))
(define outtype 'NOP)

;; here eval is converting code to string (c-grammar)
;; input e: symbol
(define (eval-expr e)
  (list 'ty 'nm (symbol->string e)))

(define (lstlst->lst ll k)
  (let ([lst-idx (build-list (length ll) (lambda (x) k))])
    (map list-ref  ll lst-idx)))

(define (prefix-nop->infix-bop proc domexp domtype outtype)
  (unless (equal? (length domexp) (length domtype))
    (error "dom's arg, type mismatch\n"))
  ;; stage 1. eval dom and assing var for each dom elt. - string 1
  (let* ([ldxp (map eval-expr domexp)]
         ;[lstr (ldxp->lststring ldxp)]
         )
    #f))

(eval-expr proc)
(lstlst->lst (map eval-expr dom) 1)
(map eval-expr domtype)
(eval-expr outtype)

(prefix-nop->infix-bop proc dom domtype outtype)