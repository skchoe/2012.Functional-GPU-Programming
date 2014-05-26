#lang scheme/base

(require scheme/unit)
(require "../ts-sig.ss")
(require "ts-new-sig.ss")

(define-unit ts-new@ 
  (import ts^)
  (export ts-new^)
  (printf "Unit ts-new new invoked\n")
  
  (define (build-new-toys n)
    (printf "called build-toys in ts-new@\n")
    (build-toys (+ 1 n)))
  
  (define (a-new-toy)
    (+ 1 (a-toy))))

(provide ts-new@)