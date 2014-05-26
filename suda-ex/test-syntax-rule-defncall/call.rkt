#lang racket
(require (for-syntax syntax/parse))
(require (for-syntax "def.rkt"))
(require "def.rkt")

(define-syntax (ID stx)
  (syntax-parse 
   stx
   [(a . b) (id1 1 k 3 4 5) stx]
   [_ (printf "non filtered\n") stx]))

(id1 1 a 4 5)

(ID 1 2 3)