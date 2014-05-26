#lang scheme/base

(require scheme/unit)
(require "ts-sig.ss")

(define-unit ts@
  (import)
  (export ts^)
  (printf "Unit ts started.\n")
  (define (build-toys n)
    (printf "called build-toys in ts@\n")
    n)

  (define (a-toy)
    1))

(provide ts@)


#|
#lang scheme/unit

(require "ts-sig.ss")
(import)
(export ts^)
(printf "Unit ts started.\n")

(define (build-toys n)
  (printf "called build-toys in ts@\n")
  n)

(define (a-toy)
  1)
|#