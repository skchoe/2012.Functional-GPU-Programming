#lang racket/base

(require syntax/module-reader syntax/parse syntax/context)
(require syntax/kerncase)
(require (for-syntax racket/base syntax/parse unstable/syntax))
(require "../../../local/racket/collects/typed-scheme/env/global-env.rkt")

(define (read-stx fn)
  (let* ([ip (open-input-file (string->path "sk.rkt") #:mode 'text)]
         [stx-m (read-syntax fn ip)])
    (printf "TOP read:\n~a\n" (syntax->datum stx-m))
    (close-input-port ip)
    
    stx-m))

(define (process-form form)
  (syntax-parse
   form #:literals (define-values define-values-for-syntax)
   [(define-values (id ...) (values v ...))
    (printf "id:~a\n" #'(id ...))
    (printf "v0:~a\n" #'(v ...))]
   [(define-values-for-syntax null v)
    (printf "v1:~a\n" #'v)
    (syntax-parse 
     #'v #:literals (begin)
     [(begin vv0 ...) 
      (let ([appform (car (syntax->list #'(vv0 ...)))])
        (printf "vv0:~a\nappform:~a\n" #'(vv0 ...) appform)
        (syntax-case
         appform (register-type)
         [(_ register-type v ...);register-type qid ...);register-type qid app)
          (printf "app-type......:~a\n" #'(v ...))];appform)]
         [_ (printf "app-type-faile:~a\n" appform)]))])]
   [(_ v) (printf "Other v2:~a\n" #'v)]))

(let ([stx (read-stx "sk_expanded.rkt" )]) #f)


    

