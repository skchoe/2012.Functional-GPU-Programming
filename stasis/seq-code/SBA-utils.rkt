#lang racket
(require "../rkt-app/common/commons.rkt")
(provide (all-defined-out))

;; final variable finder
(define (get-finalvar ae)
  ;(printf "get-finalvar: ae(~a)\n" ae)
  (match ae
    [(? symbol? x) x]
    [`(let (,x ,exp) ,body)
     (get-finalvar body)]))


;; atomic constraint predicate
(define (atom-constraint? constraint)
  ;(printf "constraint:~a\n" constraint)
  (match constraint
    [(? number?) #t]
    [(? boolean?) #t]
    [(? symbol?) #t]
    [`(cons ,_ ,_) #t]
    [`(lambda ,_ ,_ ,_) #t]
    [else #f]))

