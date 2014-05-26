#lang racket
(require (for-syntax syntax/parse unstable/syntax) 
         #;(for-syntax "ts2c/ts2c-xlate.ss"))
(require (for-syntax "../typed-scheme/utils/tc-utils.rkt"
                     "../typed-scheme/typecheck/provide-handling.rkt"
                     "../typed-scheme/private/type-contract.rkt"
                     "../typed-scheme/optimizer/optimizer.rkt"
                     "../typed-scheme/typecheck/tc-toplevel.rkt"
                     (except-in "../typed-scheme/utils/utils.rkt" infer)))
(require (only-in "../typed-scheme/typed-reader.rkt" read read-syntax))

(define-syntax (module-begin stx)
  
  (define module-name 'on-file-module);(syntax-property stx 'enclosing-module-name))
  (syntax-parse stx
    [(mb (~optional (~and #:optimize (~bind [opt? #'#t]))) forms ...)
     (let* ([pmb-form (syntax/loc stx (#%plain-module-begin forms ...))]
            [expanded (local-expand pmb-form 'module-begin null)]
            [new-mod (tc-module expanded)])
       (printf "input stx:~a\n" stx)
       (printf "modulename:~a, expanded stx:~a\n" 
               module-name (syntax->datum expanded))
       (parameterize ([optimize? (or (optimize?) (attribute opt?))])
         (syntax-parse expanded
                       [(pmb . forms)
                        (printf "input for ts2c-syntax, pmb:~a, forms:~a\n" 
                                (syntax->datum #'pmb) (syntax->datum #'forms))
                        #;(ts2c-syntax module-name #'forms)])
         
         ;; typed-scheme extra routine to return valid form
         (with-syntax*
          ([(pmb . body2) new-mod]
           [check-syntax-help (syntax-property #'(void) 'disappeared-use (type-name-references))]
           [transformed-body (remove-provides #'body2)]
           [transformed-body (change-contract-fixups #'transformed-body)]
           [(optimized-body ...)
            (if (optimize?)
                (map optimize-top (syntax->list #'transformed-body))
                #'transformed-body)])
          #`(#%module-begin optimized-body ... #,new-mod check-syntax-help))))]))
