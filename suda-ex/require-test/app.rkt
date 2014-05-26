#lang s-exp racket;"request_provide.rkt"

(require unstable/mutated-vars)
(require (for-syntax unstable/mutated-vars
                     unstable/syntax))

(require "src1.rkt")
(require (except-in "src2.rkt" foo goo))
(goo 1)

(define-syntax (hoo) #f)
#;(define (hoo) #f)
(provide (rename-out [hoo #%hoo]))
