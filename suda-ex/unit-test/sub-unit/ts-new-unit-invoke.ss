#lang scheme/base

(require (only-in scheme/unit 
                  provide-signature-elements
                  define-values/invoke-unit/infer
                  link))

;#|; ts-new^ ts-new@ invoke
(require "../ts-sig.ss" "../ts-unit.ss" "ts-new-sig.ss" "ts-new-unit.ss")
(define-values/invoke-unit/infer (link ts@ ts-new@))
(provide-signature-elements ts-new^)