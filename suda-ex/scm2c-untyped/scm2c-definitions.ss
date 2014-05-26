(module scm2c-definitions scheme
 
  
(provide (all-defined-out))

(define CONTLINE -80)
;; prepare the calling convention
(define EXTERN 'extern)
  
;; for 'use' in process-exp
(define BOOL 'BOOL)
(define VAL 'VAL)
(define LONG 'long)
(define VOID 'void)    
(define COND 'cond)  
(define LAMBDA 'lambda)
(define QUOTE 'quote)
  
(define BEGIN 'begin)
  
;; These are types and type-modifiers
(define INT 'int)

  
;; for 'termin' in process-exp
(define RETURN "return")
(define NONE "")
(define COMMA ", ")
(define SEMI ";")
(define SUBSCRIPT "]")
    
(define-struct port-set (in out-h out-cu))


  )
