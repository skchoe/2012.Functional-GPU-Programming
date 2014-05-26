#lang scheme

 (define filename "simple-src.scm")
 (define modname 'simple-src)

 (require syntax/modread)
 (define (read-module filename modname)
    (let* ([in-stream (open-input-file filename)])
      (check-module-form (read-syntax filename in-stream)
                         modname
                         filename)))

 (define s (read-module filename modname))
 (printf "EXP_1: ~s\n" (syntax->datum (expand-syntax s)))