#lang scheme

(define-syntax define-datatype
  (lambda (stx)
    (syntax-case stx ()
      ;; field
      [(_ name pred-name 
          (variant-name (field-name field-pred) ...) 
          ...)
       (begin (printf "0st\n")
              (syntax #f))]
      ;; pred only
      [(_ name pred-name variant ...)
       (begin (printf "1st\n")
              (if (null? (syntax->list (syntax (variant ...))))
                  (printf "~s\n" 'null)
                  (printf "isn't null: ~s\n" (syntax->datum (syntax (variant ...)))))
           
              (syntax #t))];"~s ~s\n" name pred-name)]
      ;; nothing
      [else (printf "else\n")
            (syntax #f)])))


  (define-datatype expval expval?
    (num-val
      (value number?))
    (bool-val
      (boolean boolean?))
    (proc-val 
      (proc proc?)))
  
(define-datatype a b c)