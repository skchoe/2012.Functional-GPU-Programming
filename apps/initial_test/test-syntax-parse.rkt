#lang racket
(require syntax/parse
         syntax/kerncase
         #;(lib "typed-scheme/typecheck/internal-forms.rkt")
         #;(lib "typed-scheme/private/internal.rkt")

         ;; typed-scheme rks
         (rename-in (lib "typed-scheme/utils/utils.rkt") [infer r:infer])
         (private parse-type)
         (base-env base-types)
         (types abbrev utils convenience union)
         )
         

(define (insert-string lst str)
  (if (null? lst) 
      null
      (if (null? (cdr lst)) 
          lst
          (for/fold ([out-lst (cons (car lst) '())])
            ([i (in-range (- (length lst) 1))])
            (append out-lst (list str (list-ref lst (+ i 1))))))))

#;(insert-string (list 'a 'b 'c 'd) "XX")
      
(define module-port (open-input-string 
                     "(module sum_kernel typed/racket (: cpyTestDrv_kernel  ((Vectorof Float) Exact-Nonnegative-Integer  ->  (values (Vectorof Float) Exact-Nonnegative-Integer))) (define (cpyTestDrv_kernel array_in sgl_in) (values array_in  100)))"))
(define current-orig-stx (make-parameter #'here))

(define (parse-port module-port)
  (let* ([form-stx (parameterize ([current-namespace (make-base-namespace)])
                     (expand (read-syntax #f module-port)))])
    (parameterize ([current-orig-stx form-stx])
      (kernel-syntax-case* 
       form-stx
       #f 
       (define-type-alias-internal define-typed-struct-internal define-type-internal 
         require/typed-internal values)
       [(module mn req (#%module-begin form ...))
        (let* ([lst-n-t-init 
                (map 
                 (λ (form)
                   (kernel-syntax-case*
                    form #f (define-values define-values-for-syntax void  begin quote-syntax )
                    [(define-values () 
                       (begin (quote-syntax (:-internal id ty)) 
                              (#%plain-app values)))
                     (identifier? #'id)
                     (begin
                       (printf "kern-nm:~a, kern-ty:~a\n" #'id #'ty)
                       (list #'id (parse-type #'ty)))]
                    [_ #f '() #;(printf "ELSE: form:~a\n" (syntax->datum form))]))
                 (syntax->list #'(form ...)))]
               [lst-n-t (filter (λ (lst) (not (null? lst))) lst-n-t-init)])
          (for-each (λ (lst) (printf "nm:~a, ty:~a\n" (first lst) (second lst))) lst-n-t))]
       [_ (error "form-stx is not parsed enough\n")]))))

(parse-port module-port)
