(module scm2c-toplevel scheme
  
(require "scm2c-definitions.ss"
         "scm2c-common.ss")

(provide (all-defined-out))
  
(define main-defined? #f)
  
(define (out-sharpdef expr oport)
  (cond 
    [(and (pair? expr)
          (eq? 'quote (car expr))
          (symbol? (cadr expr))
          (null? (cddr expr)))
     (write-to-outport  0 oport "#define ")
     (c-ify-string
      (string-upcase (symbol->string (cadr expr)))
      oport)]))

(define (out-include spec oport)
  (cond
    [(and (pair? spec) (eq? (car spec) 'quote) (symbol? (cadr spec)))]
    [else
     (write-to-outport  0 oport "#include ")
     (cond 
       [(not (pair? spec))
        (write-to-outport  CONTLINE oport "\"" (descmfilify spec) ".h\"")]
       [else
        (write-to-outport CONTLINE oport "\"" (descmfilify (caddr spec)) ".h\"")])
     (write-to-outport 0 oport)]))
  
(define (out-c-cmt line oport)
  (display "/* " oport)
  (display line oport)
  (display " */" oport)
  (newline oport))
 
  ;; BODY must be one, ie a list of one or more forms.
(define (tailcalled-in-body? ident body)
  (define (tcalled? form)
    (cond ((not (pair? form)) #f)
	  ((eq? ident (car form)) #t)
	  (else
	   (case (car form)
	     ((BEGIN)
	      (tailcalled-in-body? ident (cdr form)))
	     ((LET)
	      (tailcalled-in-body? ident
				   (if (symbol? (cadr form))
				       (cdddr form)
				       (cddr form))))
	     ((LETREC LET*)
	      (tailcalled-in-body? ident (cddr form)))
	     ((IF)
	      (or (tcalled? (caddr form))
		  (and (pair? (cdddr form))
		       (tcalled? (cadddr form)))))
	     ((AND OR)
	      (tailcalled-in-body? ident (cdr form)))
	     ((DO)
	      (tailcalled-in-body? ident (caddr form)))
	     ((COND CASE CASEV QASE)
	      (let loop ((clauses (if (eq? (car form) COND)
				      (cdr form)
				      (cddr form))))
		(cond ((null? clauses) #f)
		      ((tailcalled-in-body? ident (car clauses)))
		      (else (loop (cdr clauses))))))
	     (else #f)))))
  (let defloop ((body body))
    (cond ((null? body) #f)		;This shouldn't happen
	  ((not (pair? (car body)))
	   (tcalled? (car (last-pair body))))
	  ((eq? 'DEFINE (caar body))
	   (or (and (let ((form (car body)))
		      (and (pair? (cdr form))
			   (pair? (cadr form))
			   (tailcalled-in-body? ident (cddr form)))))
	       (defloop (cdr body))))
	  (else
	   (tcalled? (car (last-pair body)))))))

(define proc-name #f)

(define (process-toplevel sexp portset)
  (let ([h-port (port-set-out-h portset)]
        [o-port (port-set-out-cu portset)])
    (cond 
      [(symbol? sexp) 
       (printf "sexp:symbol - ~s : nothing\n" sexp) 
       (comment-out 0 (symbol->string sexp) o-port)]
      [(string? sexp) 
       (printf "sexp:string - ~s\n" sexp) 
       (comment-out 0 sexp o-port)]
      [(and (pair? sexp) (eq? (car sexp) 'quote))
       (printf "sexp:pair w/ quote - ~s\n" sexp) 
       (comment-out 0 (symbol->string (remove-quote sexp)) o-port)]
      [(not (pair? sexp))
       (printf "sexp:not pair -> outcomment - ~s\n" sexp) 
       (comment-out 0 sexp o-port)]
      [else
       (printf "----------sexp: ~s\t---------(car sxep):~s\n" sexp (car sexp))
       (case (car sexp)
         ['require
          (out-include (cadr sexp) o-port)]
         ['provide ; NEED review details
          (out-sharpdef (cadr sexp) o-port)]
         ['begin
          (for-each process-toplevel (cdr sexp) (build-list (length (cdr sexp)) (lambda (x) portset)))]
         ['define
          (printf "'define and then ...~s\n" (cadr sexp))
          (if (pair? (cadr sexp)) ; case - procedure definition
              (let ([ptype (proctype (caadr sexp))])
                (set! proc-name (caadr sexp))

                ; write ftn decl on h-file
                (unless (equal? 'main (caadr sexp))
                  (begin
                    (outtype 0 ptype (caadr sexp) VOID h-port)
                    (write-formals-to-port sexp "void" ");" h-port)
                    (write-to-outport 0 h-port)))
                
                ; add name, args to `label-list' 
                (add-label (caadr sexp) (cdadr sexp))
                
                ; write ftn definition on cu-file
                (outtype 0 ptype (caadr sexp) VOID o-port) ;name
                (write-formals-to-port sexp "" ")" o-port)
                (write-to-outport 0 o-port #\{)
                (printf "Tailcall checking w/ ~s, ~s\n" (caadr sexp) (cddr sexp))
                (if (tailcalled-in-body? (caadr sexp) (cddr sexp)) ; always false for now_____
                    (begin
                      (printf "________________T:tailcalled in body\n")
                      ;;(funcalled-in-code? (caadr sexp) (cddr sexp))
                      (write-to-outport 0 o-port (lblify (caadr sexp)) #\:)
                      (process-maybe-bracketed-begin
                       RETURN (type->exptype ptype) 2 (cddr sexp) o-port))
                    (begin
                      (printf "________________F:tailcalled in body\n")
                      (process-body RETURN (type->exptype ptype)
                                    2 (cddr sexp) o-port)))
                (write-to-outport 0 o-port #\})
                (rem-label (caadr sexp)))
          
              (begin ; global variable definition or lambda term
                (printf "----external var def or lambda term: ~s\n" sexp)
                (if (pair? (caddr sexp)) ; body is expression 
                    (begin
                      (printf "caddr sexp:~s\n" (caddr sexp))
                      (if (eq? 'lambda (caaddr sexp))
                          ; translate the form to (define (name v ....) exp ...), send to top.
                          (process-toplevel (lambda->procedure sexp) portset)
                          
                          ;(process-exp SEMI VAL 0 (caddr sexp) o-port)
                          (outbinding 0 (cdr sexp) o-port)
                          ))
                    (begin
                      (printf "caddr sexp:~s\n" (caddr sexp))
                      (outbinding 0 (cdr sexp) o-port))
                    )))
          (write-to-outport 0 o-port)]
         
         [else (printf "-NEED MAIN(ARGC ARGV) process-toplevel: statement not in procedure: ~s\n" sexp)])])))
  )
