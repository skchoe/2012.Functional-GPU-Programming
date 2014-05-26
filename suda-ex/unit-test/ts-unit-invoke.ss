#lang scheme/base

(require (only-in scheme/unit 
                  provide-signature-elements
                  define-values/invoke-unit/infer
                  link))

;#|; ts^, ts@ invoke
(require "ts-sig.ss" "ts-unit.ss")
(define-values/invoke-unit/infer (link ts@))
(provide-signature-elements ts^)
;
;;#|; ts-new^ ts-new@ invoke
;(require "sub-unit/ts-new-sig.ss" "sub-unit/ts-new-unit.ss")
;(define-values/invoke-unit/infer (link ts-new@))
;(provide-signature-elements ts-new^)