#lang scheme
(require scheme/system
         scheme/file
         syntax/to-string
         "../schcuda/vector_types_h.ss")
#|
conversion rule:

-----------------------------------------------
(let ([a exp1] ...) exp2 ...)
> (integer? a) (Write_Lvalue "int" a) (Write_Rvalue (exp))

-----------------------------------------------
(define exp1 exp2)
>
-----------------------------------------------
(call arg ...)
>
|#
(define out-file "example0_kernel.cu")
(define out-string "")
(define init-flag #t)
(define counter 0)

(define (exp->string exp)
  (number->string exp))

(define (write-integer-def id exp outstr)
  (let ([str (string-append "\tint " (symbol->string id) ";\n\t" (symbol->string id) " = " (exp->string exp) ";\n")])
    (string-append outstr str)))

(define (write-float-def id exp outstr)
  (let ([str (string-append "\tfloat " (symbol->string id) ";\n\t" (symbol->string id) " = " (exp->string exp) ";\n")])
    (string-append outstr str)))

(define (write-bool-def id exp outstr)
  (printf "BOOL\n")
  (let ([str " "])
    (string-append outstr str)))

(define (write-int2-def id exp outstr)
  (let ([str " "])
    (string-append outstr str)))

(define (gen-formal-list kw-formals)
  (let loop ([str ""]
             [i 0])
    (if (< i (length kw-formals)) 
        (let ([nwstr 
               (if (equal? i 0) 
                   (string-append str 
                                  "(float4* " 
                                  (symbol->string (list-ref kw-formals i)))
                   (string-append str 
                                  ", int " 
                                  (symbol->string (list-ref kw-formals i))))])
          (loop nwstr (add1 i)))
        str)))

(define (gen-header id kw-formals)
  (let* ([qualifier (string-append "__global__ void " (symbol->string id))]
         [fstr (gen-formal-list kw-formals)])
    (string-append qualifier fstr ")\n")))

(define (process-app-1 opn opd)
  ;; opn: int2-x, int2-y, sin, and cos: four cases
;  (let ([coord (li
  (let ([opnstr (symbol->string opn)])
  (cond 
    [(equal? opnstr "int2-x") (string-append 
                              (symbol->string opd) ".x")]
    [(equal? opnstr "int2-y") (string-append 
                              (symbol->string opd) ".y")]
    [(equal? opnstr "sin") (string-append
                            "sinf(" (process-sexp opd) ")")]
    [(equal? opnstr "cos") (string-append 
                            "cosf(" (process-sexp opd) ")")])))
                                          

(define (process-sexp exp)
  (let* ([nopd (- (length exp) 1)]
         [op (list-ref exp 0)]
         [str-sexp
          (let loop ([i 0]
                     [str ""])
            (if (< i nopd)
                (let* ([nstr
                        (string-append 
                         str
                         (string-append (if (equal? i 0) 
                                            ""
                                            (string-append " " (symbol->string op) " "))
                                        (process-eval-exp (list-ref exp (+ i 1)))))])
                  (loop (add1 i) nstr))
                str))])
    str-sexp))

(define (process-eval-exp exp)
  (cond 
    [(list? exp)
     (cond
       [(equal? (length exp) 2) (process-app-1 (list-ref exp 0) (list-ref exp 1))]
       [(equal? (length exp) 1) (list->string exp)]
       [(>= (length exp) 3) (process-sexp exp)])]
    [(symbol? exp) (symbol->string exp)]
    [(number? exp) (number->string exp)]))

(define (process-app-4 name arg0 arg1 arg2 arg3)
  (unless (equal? (symbol->string name) "make-float4")
    (begin (error "currently make_float4 only supported\n")
           0))
  (string-append "make_float4(" 
                 (symbol->string arg0) ", "
                 (symbol->string arg1) ", "
                 (symbol->string arg2) ", "
                 (number->string arg3) "f" ")"))

    
(define (process-vector-assignment asg)
  (let* ([store (list-ref asg 1)]
         [idx (list-ref asg 2)]
         [val (list-ref asg 3)])
    (string-append "\t"
                   (symbol->string store)
                   "["
                   (symbol->string idx)
                   "] = "
                   (process-app-4 (list-ref val 0)
                                  (list-ref val 1)
                                  (list-ref val 2)
                                  (list-ref val 3)
                                  (list-ref val 4))
                   ";")))

(define (gen-func-def lst-exp)
  ;(printf "length of exp's = ~s\n" (length lst-exp))
  ;; length = 4 -> let*, ([]...), exp(assignment), return
  (when (equal? "let*" (symbol->string (list-ref lst-exp 0)))

    (let* ([cdefs
            (let* ([lst-localdef (list-ref lst-exp 1)]
                   ;; 1. processing local definitions following let* - 7 def's
                   [str-def 
                    (let loop ([k 0]
                               [lstr ""])
                      (if (< k (length lst-localdef))
                          (let* ([localdef (list-ref lst-localdef k)]
                                 [nwstr
                                  (string-append 
                                   lstr
                                   (if (< k 3) "\tunsigned int " "\tfloat ")
                                   (symbol->string (list-ref localdef 0))
                                   " = "
                                   (process-eval-exp (list-ref localdef 1))
                                   ";\n")])
                            (loop (add1 k) nwstr))
                          lstr))])
              str-def)]
           ;; 2.processing (addition of )expressions on the def of the func
           [str-exp 
            (let* ([assignment (list-ref lst-exp 2)]
                   [return (list-ref lst-exp 3)])
              (when (equal? "vector-set!" (symbol->string (list-ref assignment 0)))
                  (process-vector-assignment assignment))
              ;ignore return because we assume return value is stored, pointed by
              ;input pointer argument.
              )])

      (string-append "{\n" cdefs "\n" str-exp "\n}\n"))))
  
 
; (define proc-name list0)
; list0 = (lambda (arg ...) exp ...)
; -> (return type?) : set to void w/__global__!!!! if  currently
; types of format vars? vector/cvector/list type -> pointer type
;                          integer real -> int float
;  (let* ([] ...) exp ...) -> like define processing.
;                          -> exp(recursive)
;  (vector-set! function) -> pos[idx] = value (assignment)
(define (write-procedure-def id exp outstr) ;(lambda form only thought)
  ;(when (list? exp) (printf "length-exp: ~s\n" (length exp)))
  (let* ([lmd (list-ref exp 0)]
         [kw-formals (list-ref exp 1)]
         [lst-exp (list-ref exp 2)]
         [header (gen-header id kw-formals)]
         [body (gen-func-def lst-exp)])
    ;; name and format vars
    (string-append header body)))

(define (process-def id exp out-str)
  (cond
    [(boolean? exp) (write-bool-def id exp out-str)]
    [(equal? 'blockIdx id) (write-int2-def id exp out-str)]
    [(equal? 'blockDim id) (write-int2-def id exp out-str)]
    [(equal? 'threadIdx id) (write-int2-def id exp out-str)]
    [(equal? id 'kernel) (write-procedure-def id exp out-str)]
    [(integer? exp) (write-integer-def id exp out-str)]
    [(real? exp) (write-float-def id exp out-str)]
    [else (begin (printf "how to define?\n")
          out-str)]))

(define (process-if condc texp fexp)
  #f)

(define (parse-initial-list lst outstr)
  (let* ([el0 (list-ref lst 0)])
    (unless (list? el0)
      (cond
        [(equal? el0 'define) 
         (process-def (list-ref lst 1) (list-ref lst 2) outstr)]
        [(equal? el0 'if)
         (process-if (list-ref lst 1) (list-ref lst 2) (list-ref lst 3) outstr)]
        [else outstr]))))

(define (parse-string str outstr)
  outstr)

(define (parse-pair pair outstr)
  outstr)
(define (parse-struct strt outstr)
  outstr)

(define cu_prefix
  "#ifndef _SIMPLEGL_KERNEL_H_\n#define _SIMPLEGL_KERNEL_H_\nextern \"C\"\n")

(define cu_postfix
  "#endif\n")

(define (main)
  
  (let* ([input-file "example0.scm"]
         [ip (open-input-file input-file)]
         [lst (read ip)])
    ; parsing.
    (let loop ([i 0]
               [init-string ""])
      (if (< i (length lst))
        (let* ([lst-elt (list-ref lst i)]
               [out-string (cond 
                             [(string? lst-elt) (parse-string lst-elt init-string)]
                             [(list? lst-elt) (parse-initial-list lst-elt init-string)]
                             [(pair? lst-elt) (parse-pair lst-elt init-string)]
                             [(struct? lst-elt) (parse-struct lst-elt init-string)]
                             [else init-string])])
          (loop (add1 i) out-string))
        (print-add (string-append cu_prefix init-string cu_postfix)))
      init-string)))
  
#|
(define (write-handler content op)
    (printf "CONTENT = ~s\n" content)
    (fprintf op "~s\n" content))
|#
(define (print-add content)
  (let* ([file-name out-file]
         ;; ready for multiple write to given file.
         [op (if init-flag 
                 (open-output-file #:exists 'truncate file-name)
                 (open-output-file #:exists 'append file-name))])
    (unless init-flag (set! init-flag #t))

    (fprintf op "~a\n" (string->symbol content))
    (close-output-port op)))

(main)