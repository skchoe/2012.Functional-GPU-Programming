#lang racket
;  @item { 
;                   }
  ]

;
; structure of ht (exp-hash):
; < key, value > 
; where key is element of list-exp-name : 'h-c 'h-b 'h-lam 'h-cons 'if 'app 'term
; where value is a set of element v
;       where v is a binder              ;; (ignore now) struct [binder, lst-var], ex) (let (binder (cons (first lst-var) (second lst-var)))
;             especially when exp-name == 'h-lam, v is a form of list '(v 'exp-name-dom 'exp-name-finalvar)
;
; (define-struct var-map (binder lst-var))
;
; used to pick a variable with exp-name
;


;