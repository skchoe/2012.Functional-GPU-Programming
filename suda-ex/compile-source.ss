(module compile-source scheme/base
  (require "../../../../local/plt/collects/typed-scheme/typed-reader.ss")

  #|
  (define old-evaluator (current-eval))
  (define (evaluator x)
    (cond [(and (syntax? x) (compiled-expression? (syntax-e x)))
           (display "evaluating compiled code wrapped in syntax\n")]
          [(syntax? x)
           (display "evaluating syntax\n")]
          [(compiled-expression? x) (display "evaluating compiled code\n")]
          [else (display "evaluating S-expression\n")]))
    |#
  
  
  (define in-filename "./simple-src.scm")
  (define in-stream (open-input-file in-filename))
  (define src-name (substring in-filename 2 (- (string-length in-filename) 4)))

  (define (inputport->lst-stx in-path in-stream)
    (let loop ([lst-stx '()]
               [in-port in-stream])
      (let ([stx (read-syntax in-path in-port)])
        (if (eof-object? stx)
            lst-stx
            (let* ([lst-stx-new (append lst-stx (list (read-syntax in-path in-port)))])
              (loop lst-stx-new in-port))))))

    
  (define lst-stx (inputport->lst-stx in-filename in-stream))
  (for-each (lambda (x) (printf "~s" (syntax->datum x))) lst-stx)
  (printf "~n")
  
  ;(define module-name (syntax-property srcstx 'enclosing-module-name))
  ;(printf "module-name = ~s\n~s\n" module-name (syntax->datum srcstx))

  #|
  (begin (current-eval evaluator)

         ;; the module-name-resolver calls eval
         ;; on the contents of the .zo file
         (require (lib "cmdline.ss"))

         ;; 'eval' just passes argument along
         (void (eval '(lambda (x) x)))
         (void (eval (compile '(lambda (x) x))))) 
|#


)