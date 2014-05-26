#lang scheme

(require "sllgen-test.scm")

;;;;;;;;;;
; sllgen style token and grammars
; 
(define the-lexical-spec
  '((whitespace (whitespace) skip)
    (comment (";" (arbno (not #\newline))) skip)
    
    (identifier (letter (arbno (or letter digit "_" "-" "?" "!"))) symbol)
    (number (digit (arbno digit)) number)
    (number ("-" digit (arbno digit)) number)))

(define the-grammar
  `((program (expression) a-program)
    (expression (number) const-exp)
    (expression (identifier) var-exp)
    (expression ("`" identifier) symbol-exp)
    (expression ("lambda" formals expression) proc-exp)
    (expression (#%app expression expression) call-exp)
    (expression ("let-values" "(" "[" identifier expression "]" ")") let-values-exp)))

(define type-of-program
  (lambda () #f))

(define check
  (lambda (string) 
    (type-of-program (scan-parse string))))

(define check-all
  (lambda ()
    (run-tests! check tests-for-check)))