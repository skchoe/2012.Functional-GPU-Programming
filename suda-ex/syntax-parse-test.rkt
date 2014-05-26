#lang racket/base

(require syntax/parse)

(define app-string "(apply + lst)")
(define lst-string "(list 1 2)")
(define ipp (open-input-string lst-string))
(define stx-form (read-syntax (object-name ipp) ipp))

(define fn "test-input-rkt.rkt")
(define ip (open-input-file fn))
;(define stx (read-syntax fn ip))

(define (run-parse form)
  (printf "input form = ~a\n" form)
  (syntax-parse form
                #:literals ()
                [(apply f . args) (printf "app: args:~a\n" #'args)]
                [(list . args) (printf "list filtered: ~a\n" #'args)]
                [(map f . args) (printf "map: f:~a, arg:~a\n" #'f #'args)]
                [(f . args) (printf "just f:~a, args:~a\n" #'f #'args)]))



(define (run-parse2 form)
  (syntax-parse form
                #:literals (apply)
                [(apply f . args) (printf "apply w/ list:~a\n" #'args)]
                [(f . args) (printf "gen\n")]))

(apply + 1 2 3 (list 1 2 3))
(define stx #'(apply + 1 2 3 (list 1 2 3)))
(if (syntax? stx)
    (begin (printf "syntax\n")
           (run-parse stx))
    (printf "not syntax form\n"))
(run-parse2 stx)
(run-parse stx)
(define stx-map #'(map add1 (list 1 2 3)))
(run-parse stx-map)