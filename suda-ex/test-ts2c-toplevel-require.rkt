#lang racket

(require racket/string
         syntax/kerncase
         syntax/parse
         mzlib/etc
         racket/match
         racket/list
         unstable/mutated-vars
         (only-in racket/contract and/c not/c)
         (only-in '#%kernel [apply k:apply] [#%datum k:#%datum])
         
         (for-syntax 
          (only-in '#%kernel [apply k:apply] [#%datum k:#%datum]))

         ;; typed-scheme rks
         (rename-in "../../typed-scheme/utils/utils.rkt" [infer r:infer])
         (types abbrev)
         (rep type-rep rep-utils)
         (base-env base-types-extra base-env-numeric)
         (typecheck signatures tc-structs provide-handling def-binding tc-metafunctions tc-subst); tc-toplevel)
         (types utils convenience union)
         (private parse-type type-annotation type-contract)
         (env global-env init-envs type-name-env type-alias-env lexical-env type-env-structs)
         (utils tc-utils)
         
         (for-template 
          (only-in '#%kernel [apply k:apply] [#%datum k:#%datum])
          "../../typed-scheme/typecheck/internal-forms.rkt" racket/base racket/bool)
         
;         ;; suda ss
;         "../unit-helpers/tc-sigs.ss"
;         "../unit-helpers/unit-interface.ss"
;         "ts2c-definitions.ss"
;         "typed-srfi-25-cugen.ss"
;         "type-to-symbol.rkt"
         )

;(import tc-expr^ tc-let^ check-subforms^ tc-lambda^ ts2c-app^)
;(export ts2c-toplevel-sig^)
(define (ts2c-parse-type ty) #f)
(define (ts2c-parse-type-ret ty) #f)
(define (tc-type->symbol ty) #f)
(define (ts-compile2c ty) #f)
(define (check-infix ty) #f)
(define (ts2c-expr-translate ty) #f)
(define (lst-exp->lst-type-name-string ty) #f)
(define (expr-to-string ty) #f)
(define (base-type->symbol ty) #f)
(define (terminal-expr? ty) #f)
(define (tc-results->type-list ty) #f)
