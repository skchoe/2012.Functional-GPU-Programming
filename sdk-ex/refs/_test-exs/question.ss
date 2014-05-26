(module question scheme

; (1) This works fine.
(let* ([sx (syntax
            (module m scheme
                     #f))])
  (printf "EXP_0: ~s\n" (syntax->datum (expand-syntax sx))))
  
(let* ([a (syntax '100)])
  (printf "a = ~s\n" (syntax->datum a))
  (cond
    [(identifier? a) (printf "a is ident\n")]
    [(symbol? (syntax->datum a)) (printf " a is symbol\n")]
    [(pair? (syntax->datum a)) (printf " a is pair\n")]
    [else (printf "idont' know\n")]))

  
  
  
; (2) This doesn't.
(define filename "simple-src.scm")

(define (read-module filename)
  (let* ([in-stream (open-input-file filename)])
    (read in-stream)))

(define md (read-module filename))
(define s (datum->syntax #f md #f))
(printf "EXP_1: ~s\n" (syntax->datum (expand-syntax s)))

  )