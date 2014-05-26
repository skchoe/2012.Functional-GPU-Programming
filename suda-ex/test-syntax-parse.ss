#lang scheme/base

(require "../../../typed-scheme/utils/utils.ss")
(require ;(except-in (rep type-rep) make-arr)
         ;(rename-in (types convenience union utils) [make-arr* make-arr])
         ;;(utils tc-utils stxclass-util)
         ;(prefix-in c: scheme/contract)
         (only-in syntax/parse define-conventions)
         syntax/parse
         ;stxclass/util
         (env index-env global-env init-envs tvar-env type-env-structs lexical-env type-alias-env type-name-env)
         ;scheme/match
         (base-env base-env base-types-extra)
         )

;(p/c [parse-type (syntax? . c:-> . Type/c)]
;     [parse-type/id (syntax? c:any/c . c:-> . Type/c)] 
;     [parse-tc-results (syntax? . c:-> . tc-results?)] 
;     [parse-tc-results/id (syntax? c:any/c . c:-> . tc-results?)] 
;     [parse-type* (syntax? . c:-> . Type/c)])

(syntax-parse #'X
              #:literals ()
;              #:literal-sets ()
              ;#:conventions ()
              (vv:id (syntax-e #'vv) 'VAR-ID)
              (atomic-datum 'NUMBER))

(syntax-parse #'(define x 12)
              #:literals (define (def define))
              ((def var:id body:expr) 
               (list (syntax->datum #'var) 
                     (syntax->datum #'body))))

(syntax-parse #'(a #:foo bar)
              ((x #:foo y) (syntax->datum #'y)))

#;(syntax-parse #'(m (import one two))
              #:literals (import)
              ((_ (~and import-clause (import i ...)))
               (let ([bad (check-imports
                           (syntax->list #'(i ...)))])
                 (when bad
                   (raise-syntax-error
                    #f "bad import" #'import-clause bad))
                 'ok)))

(define-syntax-class star
  #:description "*" 
  (pattern star:id
           #:when (eq? '* #'star.datum)))

(define-syntax-class ddd
  #:description "..."
  (pattern ddd:id
           #:when (eq? '... #'ddd.datum)))

(define-syntax-class tvar
  #:description "type variable"
  (pattern v:id
           #:with val (lookup (current-tvars) #'v.datum (lambda (_) #f))
           #:with name #'v.datum
           #:with datum #'v.datum
           #:when #'val))


(define-conventions xyz-as-ids
  (x id) (y id) (z id))

(syntax-parse #'(1 2 3 a  b c)
              #:conventions (xyz-as-ids)
  ((x ... n ...)(syntax->datum #'(x ...))))
