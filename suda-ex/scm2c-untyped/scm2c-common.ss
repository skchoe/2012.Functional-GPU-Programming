(module scm2c-common scheme
  
(require srfi/13
         "scm2c-definitions.ss")
  
(provide (all-defined-out))

(define (write-to-outport indent output-port . lst-content)
  ;x(if (port? output-port) (printf "OUT: ok\n") (printf "OUT: not ok\n"))
  (when (>= indent 0)
    (newline output-port)
    (do ((j indent (- j 8)))
      ((> 8 j)
       (do ((i j (- i 1)))
         ((>= 0 i))
         (display #\space output-port)))))
    (for-each
     (lambda (a)
       (printf "print to file : ~s\n" a)
       (cond ((symbol? a)
              (c-ify-symbol a output-port))
             ((string? a)
              (display a output-port)
              (cond (#f (string-index a #\newline)
                        (printf "newline in string: ~s\n" a))))
             (else
              (when (and (number? a) (negative? a))
                (display #\space output-port))
              (display a output-port))))
     lst-content))

  
  
(define (comment-out indent str oport)
  (if (number? str) 
      (comment-out indent (number->string str) oport)
      (write-to-outport indent oport "/*" str "*/")))
  
(define (remove-quote sexp)
  (if (and (pair? sexp) (eq? 'quote (car sexp)))
      (cadr sexp)
      sexp))
  
;; Removes or translates characters from @1 and displays to @2
(define (c-ify-string name port)
  (define visible? #f)
  (printf "c-ify-string name \n")
  (for-each
   (lambda (c)
     (let ((tc (cond ((char-alphabetic? c) c)
		     ((char-numeric? c) c)
		     ((char=? c #\%) "_Percent")
		     ((char=? c #\@) "_At")
		     ((char=? c #\=) "Eql")
		     ((char=? c #\:) #\_)
		     ((char=? c #\-) #\_)
		     ((char=? c #\_) #\_)
		     ((char=? c #\>) "to_")
		     ((char=? c #\?) "_P")
		     ((char=? c #\.) ".")
		     (else #f))))
       (cond (tc (set! visible? #t) (display tc port)))))
   (string->list name)))

(define (c-ify-symbol name port)
  (c-ify-string (symbol->string name) port))


;; Makes a temporary variable name.
(define (tmpify sym)
  (string->symbol (string-append "T_" (symbol->string sym))))

;; Makes a label name.
(define (lblify sym)
  (string->symbol (string-append "L_" (symbol->string sym))))

(define (assoc-if str alst)
  (cond ((null? alst) #f)
	(((caar alst) str) (car alst))
	(else (assoc-if str (cdr alst)))))
  
;;; LOOKUP - translate from table or return arg as string
(define (lookup arg tab)
  (let* ((p (assq arg tab))
	 (l (if p (cdr p) arg)))
    (if (symbol? l) (symbol->string l) l)))

(define (has-defines? body)
  (cond [(null? body) #f]
        [(null? (cdr body)) #f]
        [(not (pair? (car body))) (has-defines? (cdr body))]
        [(eq? BEGIN (caar body)) (has-defines? (cdar body))]
        [else (memq (caar body) '(define define))]))
  

(define (process-body termin use indent body oport)
  (printf "process-body\n")
  (when (and (not (eq? RETURN termin)) (not (eq? use VOID)))
      (printf "body value not at top level, ~s, ~s, ~s\n" termin use body))
  (cond 
    [(not (pair? body))
     (when (not (eq? use VOID))
         (printf "short body?: ~s\n" body))]
    [(null? (cdr body))
     (write-to-outport indent oport)
     (process-exp termin use indent (car body) oport)]
    [else
     (case (caar body)
       ['define
        (cond 
          [(symbol? (cadar body))
           (outbinding indent (cdar body) oport)
           (process-body termin use indent (cdr body) oport)]
          [else (add-label (caadar body) (cdadar body))
                    (for-each (lambda (b)
                                (outtype indent (vartype b) b VOID oport)
                                (write-to-outport  CONTLINE oport SEMI))
                              (cdadar body))
                    (process-body termin use indent (cdr body) oport)
                    (when (and (eq? use VOID) (eq? termin RETURN))
                        (write-to-outport indent oport "return;"))
                    (write-to-outport  0 oport (lblify (caadar body)) #\:)
                    (process-body termin use indent (cddar body) oport)
                    (rem-label (caadar body))])]
       [else
        (write-to-outport indent oport)
        (process-exp SEMI VOID indent (car body) oport)
        (process-body termin use indent (cdr body) oport)])]))

(define (filter pred? lst)
  (cond 
    [(null? lst) lst]
    [(pred? (car lst))
     (cons (car lst) (filter pred? (cdr lst)))]
    [else (filter pred? (cdr lst))]))
  
(define (c-ify-char chr)
  (cond ((char-alphabetic? chr) (string chr))
	((char-numeric? chr) (string chr))
	(else
	 (case chr
	   ((#\! #\" #\# #\$ #\% #\& #\' #\( #\) #\* #\+ #\, #\- #\. #\/
	     #\: #\; #\< #\= #\> #\? #\@
	     #\[     #\] #\^ #\_ #\`
	     #\{ #\| #\} #\~)
	    (string chr))
	   ((#\\) "\\\\")
	   ((#\newline) "\\n")
	   ((#\tab) "\\t")
	   ((#\backspace) "\\b")
	   ((#\return) "\\r")
           ;((#\page) "\\f")
	   ((#\space) " ")
	   ;;((#\null) "\\0")
	   (else
	    (let ((numstr (number->string (char->integer chr) 8)))
	      (string-append
	       "\\" (make-string (- 3 (string-length numstr)) #\0) numstr)))))))

(define (descmfilify file)
  (if (not (string? file))
      (descmfilify (symbol->string file))
      (let ((sl (string-length file)))
        (cond ((< sl 4) file)
              ((string-ci=? (substring file (- sl 4) sl) ".scm")
               (substring file 0 (- sl 4)))
              (else file)))))

(define (outtype indent type name val oport)
  (cond 
    [(symbol? type)
     (let ((typestr
            (case type
              ((BOOL) "int")
              (else type))))
       (write-to-outport indent oport typestr #\space name))
       #t]
    [(string? type) (write-to-outport indent oport type #\space name)]
    [else #f]))

;;; VARTYPE gives a guess for the type of var
(define (vartype var)
  'int)

;;; PROCTYPE - gives a guess for the type of proc
(define (proctype proc)
  (let ((str (symbol->string proc)))
    (case (string-ref str (- (string-length str) 1))
      ((#\?) BOOL)
      ((#\!) VOID)
      (else (vartype proc)))))
  
(define (type->exptype type)
  (case type
    ((VOID BOOL LONG) type)
    (else VAL)))

  
;;; OUTBINDING - indents and prints out local binding
(define (outbinding indent b oport)
  ;(printf "outbinding : b:~s, val:~s\n" b (car b) )    
  (let ((type (vartype (car b))))
    ;(printf "outbinding : val:~s, type:~s\n" (car b) type)    
    
    (cond ((var-involved? (car b) (cadr b))
	   (outtmpbnd indent (car b) (cadr b) oport)
	   (outuntmpbnd indent (car b) oport))
	  ((outtype indent type (car b) (cadr b) oport)
	   (write-to-outport CONTLINE oport " = ")
	   (process-exp SEMI (type->exptype type) indent (cadr b) oport))
	  (else
	   (write-to-outport CONTLINE oport SEMI)))))
  
;;; OUTBINDINGS - indents and prints out local bindings
(define (outbindings indent b oport)
  (for-each (lambda (b) (outbinding indent b oport)) b))

(define (outtmpbnd indent var val oport)
  (let ((type (vartype var)))
    (cond ((outtype indent type (tmpify var) val oport)
	   (write-to-outport CONTLINE oport " = ")
	   (process-exp SEMI (type->exptype type) indent val oport))
	  (else
	   (write-to-outport CONTLINE oport SEMI)))))

(define (outuntmpbnd indent var oport)
  (outtype indent (vartype var) var VOID oport)
  (write-to-outport CONTLINE oport " = " (tmpify var) SEMI))
  
;;; OUTLETBINDINGS - indents and prints out local simultaneous bindings
(define (outletbindings indent bindings types? oport)
  (when (not (null? bindings))
      (let* ((vars (map car bindings))
	     (exps (map cadr bindings))
	     (invol (map
		     (lambda (b)
		       (if types?
			   (var-involved? (car b) (map cadr bindings))
			   (var-involved-except?
			    (car b) (map cadr bindings) (cadr b))))
		     bindings)))
	(for-each
	 (lambda (v b i) (when i (outtmpbnd indent (car b) (cadr b))))
	 vars bindings invol)

	(for-each
	 (lambda (v b i)
	   (let ((type (vartype (car b))))
	     (cond (i)
		   ((not types?)
		    (write-to-outport indent oport (car b))
		    (write-to-outport CONTLINE oport " = ")
		    (process-exp SEMI (type->exptype type) indent (cadr b) oport))
		   ((outtype indent type (car b) (cadr b) oport)
		    (write-to-outport CONTLINE oport " = ")
		    (process-exp SEMI (type->exptype type) indent (cadr b) oport))
		   (else		;(report "can't initialize" b)
		    (write-to-outport CONTLINE oport SEMI)))))
	 vars bindings invol)
	(for-each
	 (lambda (v b i)
	   (let ((type (vartype (car b))))
	     (cond (i (if types? (outuntmpbnd indent v)
			  (write-to-outport indent oport v " = " (tmpify v) SEMI))))))
	 vars bindings invol))))
  
(define (var-involved-except? var sexps own)
  (if (null? sexps) #f
      (if (eq? (car sexps) own)
	  (var-involved-except? var (cdr sexps) own)
	  (or (var-involved? var (car sexps))
	      (var-involved-except? var (cdr sexps) own)))))

(define (var-involved? var sexp )
  (if (pair? sexp)
      (or (var-involved? var (car sexp))
	  (var-involved? var (cdr sexp)))
      (eq? sexp var)))

(define (outcomment indent str oport)
  (if (number? str)
      (outcomment indent (number->string str) oport)
      (begin
        (printf "input - outcomment : ~s\n" str)
        (write-to-outport indent oport "/*" str "*/"))))
  
(define (process-to-sharp-if test consequent alternate proc-tplvl sense oport)
  (define (crestif)
    (proc-tplvl consequent oport)
    (cond (alternate
	   (write-to-outport 0 oport "#else                    /*")
	   (ctest (not sense) test)
	   (write-to-outport CONTLINE oport "*/")
	   ;; (write-to-outport0)
	   (proc-tplvl alternate oport)))
    (write-to-outport 0 oport "#endif	")
    (write-to-outport CONTLINE oport "/* ")
    (ctest (if alternate (not sense) sense) test)
    (write-to-outport CONTLINE oport " */")
    (write-to-outport 0 oport))
  
  (define (ctest sense test)
    (write-to-outport CONTLINE oport (if sense "" "n") "def ")
    (cond ((and (eq? 'PROVIDED? (car test))
		(pair? (cadr test))
		(eq? 'quote (caadr test)))
	   (c-ify-string
            (string-upcase (symbol->string (cadadr test)))
            oport))
	  ((string? (cadr test))
	   (c-ify-string (cadr test) oport))
	  ((symbol? (cadr test))
	   (c-ify-symbol (cadr test) oport))))
  
  (write-to-outport 0 oport (string-append "#if " (if sense "" "!") "("))
  (process-exp NONE BOOL CONTLINE test oport)
  (write-to-outport CONTLINE oport ")")
  (write-to-outport 0 oport)
  (crestif))
    
  
(define *label-list* '())  
(define (add-label name arglist)
  (set! *label-list* (cons (cons name arglist) *label-list*)))

(define (label-vars name)
  (let ((p (label? name)))
    (and p (cdr p))))

(define (rem-label name)
  (set! *label-list* (cdr *label-list*)))
  
(define (label? name) (assq name *label-list*))

(define (long-string? str)
  (and (string? str) (> (string-length str) 40)))
  
(define (process-infix-exp use op indent exps oport)
  (define extra-nl? (and (string? op) (string-index op #\newline)))
  (define cnt 0)
  (define (par x indent)
    (cond ((or (pair? x) (symbol? x))
	   (write-to-outport CONTLINE oport "(")
	   (process-exp NONE use (+ 1 indent) x oport)
	   (write-to-outport CONTLINE  oport ")"))
	  (else (process-exp NONE use indent x oport))))
  (cond ((eqv? #\, op)
	 (write-to-outport CONTLINE  oport "(")
	 (cond ((not (null? exps))
		(cond ((long-string? (car exps))
		       (set! op ",\n\t")
		       (set! extra-nl? #t)))
		(process-exp NONE use indent (car exps) oport)
		(set! exps (cdr exps))))
	 (for-each
	  (lambda (x)
	    (when (long-string? x) (set! op ",\n\t") (set! extra-nl? #t))
	    (write-to-outport CONTLINE  oport op #\space)
	    (process-exp NONE use indent x oport))
	  exps)
	 (write-to-outport CONTLINE  oport ")"))
	(else
	 (cond ((not (null? exps))
		(par (car exps) indent)
		(set! exps (cdr exps))))
	 (for-each
	  (lambda (x)
	    (set! cnt (+ 1 cnt))
            (write-to-outport (if (or (and (string? op) (char=? #\space (string-ref op 0)))
                                      (zero? (modulo cnt 8)))
                                  (+ -1 indent)
                                  CONTLINE)
                              oport 
                              op)
	    (par x (+ (if (char? op) 1 (+ -1 (string-length op))) indent)))
	  exps))))
    
(define (process-goto indent sexp oport)
  (define lbls (label-vars (car sexp)))
  (cond ((eq? RETURN lbls)
	 (write-to-outport CONTLINE oport "return ")
	 (process-exp SEMI VAL (+ 7 indent) (cadr sexp)))
	(else
	 (let ((lv (filter (lambda (l) (not (eq? (car l) (cadr l))))
			   (map list lbls (cdr sexp)))))
	   (cond ((pair? lv)
		  (write-to-outport CONTLINE oport "{")
		  (outletbindings (+ 2 indent) lv #f)
		  (write-to-outport (+ 2 indent) oport "goto " (lblify (car sexp)) #\;)
		  (write-to-outport indent oport "}"))
		 (else
		  (write-to-outport CONTLINE oport "goto " (lblify (car sexp)) #\;)))))))

;;; PROCESS-EXP - schlep expression
(define (process-exp termin use indent sexp oport)
    (printf "EXP   schlep-exp term:~s, use:~s, indent:~s sexp:~s.\n" termin use indent sexp )
    (cond 
      [(not (pair? sexp))		;atoms
       (cond 
         [(eq? RETURN termin)	;return from here
          (case use
            ((VOID)	  	;shouldn't happen
             (printf "___________________terminal exp but void return values: ~s\n" sexp)
             (cond (sexp (process-exp SEMI use indent sexp)))
             (write-to-outport indent oport "return;"))
            (else
             (write-to-outport CONTLINE oport "return ")
             (process-exp SEMI use (+ 7 indent) sexp oport)))]
         [(string? sexp)
          (let ((icnt (if (> (string-length sexp) 80) 0 #f)))
            (write-to-outport CONTLINE oport #\")
            (cond 
              [(<= 60 (string-length sexp) 80)
               (write-to-outport CONTLINE oport #\\)
               (write-to-outport 0 oport)])
            (for-each 
             (lambda (c)
               (cond ((not icnt))
                     ((zero? (modulo icnt 16))
                      (set! icnt (+ 1 icnt))
                      (write-to-outport CONTLINE  oport #\\)
                      (write-to-outport 0 oport ))
                     (else
                      (set! icnt (+ 1 icnt))))
               (write-to-outport CONTLINE oport 
                                 (case c
                                   ((#\") "\\\"")
                                   (else (c-ify-char c)))))
             (string->list sexp))
            (write-to-outport CONTLINE  oport #\" termin))]
         [(and (number? sexp) (inexact? sexp))
          (write-to-outport CONTLINE oport sexp termin)]
         [(integer? sexp)
          (write-to-outport CONTLINE oport sexp termin)]
         [(char? sexp)
          (write-to-outport CONTLINE oport "'" (c-ify-char sexp) "'" termin)]
         [(vector? sexp)
          (write-to-outport CONTLINE oport "{\n\t")
          (process-infix-exp VAL ",\n\t" indent (vector->list sexp) oport)
          (write-to-outport CONTLINE oport "\n\t}" termin)]
         [(eq? VOID use)
          (write-to-outport CONTLINE oport termin)]
         [else (write-to-outport CONTLINE oport 
                                 (case sexp 
                                   ((#f) 0)
                                   ((#t) "!0") 
                                   (else sexp))
                                 termin)])]
      [(and (pair? (car sexp))
            (eq? LAMBDA (caar sexp)))
       (printf "((((((((((cond lambda case: ~s\n" sexp)
       (process-exp termin use indent
                    (append (list 'LET (map list (cadar sexp) (cdr sexp)))
                            (cddar sexp)))]
      [(case (car sexp)
         ('if
          (process-if termin use indent (cdr sexp) #t oport) #t)
         ('or
          (process-or termin use indent (cdr sexp) oport) #t)
         ('and
          (process-and termin use indent (cdr sexp) oport) #t)
         ('cond
          (process-cond termin use indent (cdr sexp) oport) #t)
         ('begin
          (process-begin termin use indent (cdr sexp) oport) #t)
         ('do
          (process-do termin use indent (cdr sexp) oport) #t)
         ('let
          (process-let termin use indent (cdr sexp) oport) #t)
         ('let*
          (process-let* termin use indent (cdr sexp) oport) #t)
         ('case
          (process-case termin use indent (cdr sexp) oport) #t)
         ('quote
          (process-exp
           termin use indent
           (cond ((or (number? (cadr sexp))
                      (string? (cadr sexp))
                      (vector? (cadr sexp)))
                  (cadr sexp))
                 ((symbol? (cadr sexp))
                  (call-with-output-string
                   (lambda (stp)
                     (c-ify-symbol (cadr sexp) stp))))
                 (else #f))
             oport)
	    #t)
         (else
          (and (label? (car sexp))
               (cond
                 ((or (eq? termin RETURN)
                      ;;(eq? termin SEMI)
                      (eq? use VOID))
                  (process-goto indent sexp oport)
                  #t)
                 (else
                  #f)))))]
    (else
     (cond 
       ((and (eq? RETURN termin) (not (eq? use VOID)))
        (write-to-outport CONTLINE oport "return ")
            (set! indent (+ 7 indent))))
     (printf "####### schlep-exp's EEEElse (car sexp) = ~s\n" (car sexp))
     (case (car sexp)

       ((+ - * /)
        (process-infix-exp use
                          (lookup (car sexp)
                                  '((REMAINDER . remainder)
                                    (MODULO . modulo) (/ . /)
                                    (QUOTIENT . quotient) (LOGIOR . bitwise-ior)
                                    (LOGAND . bitwise-and) (LOGTEST . bitwise-and)
                                    (LOGXOR . bitwise-xor)))
                          indent
                          (cdr sexp)
                          oport))
       ((< > = <= >=)
        (case (length (cdr sexp))
          ((0 1) (printf "to few arguments to comparison operator: ~s\n" sexp)
                 (process-exp NONE use indent #t))
          ((2)
           (process-infix-exp
            VAL (lookup (car sexp)
                        '((= . ==)
                          (!=-internal . !=)
                          (EQ? . ==) (EQV? . ==) (CHAR<? . <) (CHAR>? . >)
                          (CHAR<=? . <=) (CHAR>=? . >=) (CHAR=? . ==)))
            indent
            (cdr sexp)
            oport))
          (else (process-exp "" use indent
                            `(and (,(car sexp) ,(cadr sexp) ,(caddr sexp))
                                  (,(car sexp) ,@(cddr sexp)))))))

       (else
        (cond ((pair? (car sexp))	;computed function
               (write-to-outport indent  oport "(*(")
               (process-exp NONE VAL (+ 3 indent) (car sexp))
               (write-to-outport CONTLINE  oport "))")
               (write-to-outport (+ 2 indent)))
              (else (write-to-outport CONTLINE  oport (car sexp))))
        (process-infix-exp VAL #\, (+ 2 indent) (cdr sexp)
                           oport)))
     (cond ((eq? VOID use)
            ;;;		(if (not (eq? VOID (proctype (car sexp))))
            ;;;		    (report "void function returning?" sexp))
            (write-to-outport CONTLINE  oport (if (eq? COMMA termin) COMMA SEMI))
            ;;;		(if (eq? RETURN termin) (write-to-outport indent "return;"))
            )
           ((eq? RETURN termin)
            (write-to-outport CONTLINE  oport #\;))
           (else (write-to-outport CONTLINE  oport termin))))))
  
  
  

;;; SCHLEP-EXPS - schlep expressions separated by commas
(define (process-exps use indent exps oport)
  (cond ((null? (cdr exps))
	 (process-exp NONE use indent (car exps) oport))
	(else
	 (process-exp COMMA VOID indent (car exps) oport)
					;VOID causes if statements inside parenthesis.
	 (process-exps use indent (cdr exps) oport))))
  
(define (clause->sequence clause)
  (cond ((not (pair? clause)) (printf "bad clause: ~s\n" clause) clause)
	((null? (cdr clause)) (car clause))
	(else (cons 'BEGIN clause))))
    
(define (process-if termin use indent exps sense oport)
  (letrec ([test (car exps)]
           [consequent (cadr exps)]
           [alternate (if (null? (cddr exps)) #f (caddr exps))])
    (case (and (pair? test) (car test))
      (`not ;(NOT)
       (process-if termin use indent
                   `(,(cadr test) ,@(cdr exps)) (not sense) oport))
      ('define ;(DEFINED? PROVIDED?)
       (process-to-sharp-if test consequent alternate
                           (lambda (exp)
                             (write-to-outport indent oport)
                             (process-exp termin use (+ 2 indent) exp))
                           sense
                           oport))
      (else
       (cond
         ((and (not (eq? RETURN termin)) (not (eq? use VOID)))
          (process-exp NONE BOOL (+ 4 indent) (if sense test (list 'not test)))
          (write-to-outport (+ 2 indent) oport #\?)
          (process-exp NONE use (+ 2 indent) consequent)
          (write-to-outport (+ 2 indent) oport #\:)
          (when (null? (cddr exps))
              (process-exp termin use (+ 2 indent) alternate oport)))
         (else
          (write-to-outport CONTLINE oport "if (")
          (process-exp NONE BOOL (+ 4 indent) (if sense test (list 'not test)) oport)
          (write-to-outport CONTLINE oport ")")
          (write-to-outport (+ 2 indent) oport)
          (cond ((null? (cddr exps))
                 (process-begin termin use (+ 2 indent) (cdr exps) oport)) ;no else
                (else			;have an else clause
                 (if (and (eq? use VOID) consequent)
                     (process-bracketed-begin
                      termin use (+ 2 indent) (list consequent) oport)
                     (process-begin termin use (+ 2 indent) (list consequent) oport))
                 (write-to-outport indent oport "else ")
                 (process-begin termin use indent (cddr exps) oport)))))))))
  

(define (process-or termin use indent exps oport)
  (if (eq? termin RETURN)
      (case (length exps)
	((0) (if (eq? VOID use)
		 (write-to-outport CONTLINE oport "return;")
		 (write-to-outport CONTLINE oport "return 0;")))
	((1) (process-exp termin use indent (car exps)))
	(else
	 (case use
	   ((BOOL) (write-to-outport CONTLINE oport "return ")
	    (process-or SEMI use (+ 7 indent) exps))
	   ((VOID) (process-or SEMI use indent exps)
	    (write-to-outport indent oport "return;"))
	   (else
	    (cond ((symbol? (car exps))
		   (process-if
		    termin use indent
		    (list (car exps) (car exps) (cons 'OR (cdr exps)))
		    #t
                    oport))
		  (else
		   (let ((procedure-tmp-symbol (tmpify 'proc-name-fixed)))
		     (process-let* termin use indent
				  `(((,procedure-tmp-symbol ,(car exps)))
				    (or ,procedure-tmp-symbol ,@(cdr exps)))
                                  oport))))))))
      (case (length exps)
	((0) (write-to-outport CONTLINE oport 0))
	((1) (process-exp termin use indent (car exps)))
	(else
	 (case use
	   ((VAL LONG) (printf "OR of values treated as booleans: ~s\n" exps)
	    (process-infix-exp BOOL " || " indent exps oport)
	    (write-to-outport CONTLINE oport termin))
	   ((BOOL) (process-infix-exp BOOL " || " indent exps oport)
	    (write-to-outport CONTLINE oport termin))
	   ((VOID) (process-if termin use indent
			      (list (car exps) #f (cons 'OR (cdr exps)))
			      #t
                              oport)))))))
  
(define (process-and termin use indent exps oport)
  (case (length exps)
    ((0) (write-to-outport CONTLINE oport (if termin "" "return ") "!0"))
    ((1) (process-exp termin use indent (car exps) oport))
    (else
     (case use
       ((BOOL)
	(cond ((eq? termin RETURN) (write-to-outport CONTLINE oport "return ")))
	(process-infix-exp use " && " indent exps oport)
	(cond ((eq? termin RETURN) (write-to-outport CONTLINE oport SEMI))
	      (else (write-to-outport CONTLINE oport termin))))
       ((VAL)
	(process-if termin use indent (list (car exps)
					   (cons 'AND (cdr exps))
					   #f)
		   #t))
       ((VOID)
	(cond (termin
	       (process-if termin use indent
			  (list (cons 'AND (but-last-pair exps))
				(car (last-pair exps)))
			  #t))
	      (else (process-and SEMI use indent exps oport)
		    (write-to-outport indent oport "return;"))))))))
  
(define (but-last-pair lst)
  (cond ((null? (cdr lst)) '())
	(else
	 (cons (car lst) (but-last-pair (cdr lst))))))
  
(define (process-let termin use indent exps oport)
  (cond ((symbol? (car exps))
	 (add-label (car exps) (map car (cadr exps)))
	 (write-to-outport CONTLINE oport #\{)
	 (outletbindings (+ 2 indent) (cadr exps) #t oport)
	 (write-to-outport 0 oport (lblify (car exps)) #\:)
	 (process-maybe-bracketed-begin termin use (+ 2 indent) (cddr exps))
	 (write-to-outport indent oport "}")
	 (rem-label (car exps)))
	(else
	 (write-to-outport CONTLINE oport #\{)
	 (outletbindings (+ 2 indent) (car exps) #t oport)
	 (process-body termin use (+ 2 indent) (cdr exps) oport)
	 (write-to-outport indent oport "}"))))

(define (process-maybe-bracketed-begin termin use indent exps oport)
;;;  (print 'has-defines? exps)
;;;  (print '==> (has-defines? exps))
  (cond ((has-defines? exps)
	 (write-to-outport indent oport )
	 (process-bracketed-begin termin use indent exps oport))
	(else
	 (process-body termin use indent exps oport))))

(define (process-let* termin use indent exps oport)
  (write-to-outport CONTLINE oport #\{)
  (outbindings (+ 2 indent) (car exps) oport)
  (process-body termin use (+ 2 indent) (cdr exps) oport)
  (write-to-outport indent oport "}"))
  
  
(define (process-do termin use indent exps oport)
  (when (and (not (eq? RETURN termin)) (not (eq? use VOID)))
    (printf "Do- value not at top level: ~s\n" exps)) 
  (write-to-outport CONTLINE oport #\{)
  (outletbindings (+ 2 indent)
		  (map (lambda (b) (list (car b) (cadr b))) (car exps))
		  #t
                  oport)
  (write-to-outport (+ 2 indent) oport "while (")
  (process-exp NONE BOOL (+ 7 indent) (list 'NOT (caadr exps)) oport)
  (write-to-outport CONTLINE oport ") {")
  (process-body SEMI VOID (+ 4 indent) (cddr exps) oport)
  (cond ((not (null? (car exps)))
	 (write-to-outport (+ 4 indent) oport #\{)
	 (outletbindings
	  (+ 6 indent)
          (filter (lambda (l) l)
		  (map (lambda (b)
			 (and (= 3 (length b)) (list (car b) (caddr b))))
		       (car exps)))
	  #f
          oport)
	 (write-to-outport (+ 4 indent) oport "}")))
  (write-to-outport (+ 2 indent) oport "}")
  (process-body termin use (+ 2 indent) (cdadr exps) oport)
  (write-to-outport indent oport "}"))

(define (process-case termin use indent exps oport)
  (when (and (not (eq? RETURN termin)) (not (eq? use VOID)))
    (printf "CASE not at top level: ~s\n" exps))
  (write-to-outport CONTLINE oport "switch (")
  (process-exp NONE VAL (+ 8 indent) (car exps) oport)
  (write-to-outport CONTLINE oport ") {")
  (for-each
   (lambda (x)
     (case (car x)
       ('else (write-to-outport (+ 2 indent) oport "default:"))
       (else (for-each (lambda (d)
			 (cond ((not (pair? d))
				(if (char? d)
				    (write-to-outport (+ 2 indent) oport "case '" (c-ify-char d) "':")
				    (write-to-outport (+ 2 indent) oport "case " d ":")))
			       ((eq? 'UNQUOTE (car d))
				(write-to-outport (+ 2 indent) oport "case ")
				(process-exp NONE VAL CONTLINE (cadr d))
				(write-to-outport CONTLINE oport ":"))))
		       (car x)))) 
     (process-body termin use (+ 2 indent) (cdr x) oport)
     (if (eq? RETURN termin)
	 (when (eq? use VOID) (write-to-outport (+ 2 indent) oport "return;"))
	 (write-to-outport (+ 2 indent) oport "break;")))
   (cdr exps))
  (write-to-outport indent oport "}"))

(define (process-cond termin use indent clauses oport)
  (cond ((null? clauses)
	 ;; What should this value be?
	 (write-to-outport CONTLINE oport 0))
	(else
         (printf "-cond-clause = ~s \n" clauses)
	 (let* ((clause (car clauses)))
	   (cond ((null? (cdr clause))
		  (process-or termin use indent
			     (list (car clause)
				   (cons COND (cdr clauses))))
                  oport)
		 ((eq? 'else (car clause))
		  (process-begin termin use indent (cdr clause) oport))
		 ((not (null? (cdr clauses)))
		  (process-if termin use indent
			     (list (car clause)
				   (clause->sequence (cdr clause))
				   (cons COND (cdr clauses)))
			     #t
                             oport))
		 (else
		  (process-if termin use indent
			     (list (car clause)
				   (clause->sequence (cdr clause)))
			     #t
                             oport)))))))
  
(define (process-begin termin use indent exps oport)
  (cond ((null? exps) (outcomment CONTLINE "null begin?" oport))
	((null? (cdr exps))
	 (process-exp termin use indent (car exps) oport))
	(else (process-bracketed-begin termin use indent exps oport))))
  

(define (process-bracketed-begin termin use indent exps oport)
  (cond [(and (not (eq? RETURN termin)) (not (eq? VOID use)))
	 (write-to-outport CONTLINE oport "(")
	 (process-exps use (+ 2 indent) exps oport)
	 (write-to-outport CONTLINE oport ")" termin)]
        [else
	 (write-to-outport CONTLINE oport #\{)
	 (process-body termin use (+ 2 indent) exps oport)
	 (write-to-outport indent oport "}")]))
  
;; (define id (lambda (arg ...) sexp) -> (define (id arg ...) sexp)
(define (lambda->procedure sexp)
  (let* ([lam (caddr sexp)]
         [lst-arg (cadr lam)]
         [body (cddr lam)])
  (append '(define ) (list (cons (cadr sexp) lst-arg)) body)))
  
  
;; formal variable representation to both header and def. files (dep's on port)
;; (write-formals-to-port (define (f arg1) exp) "void"  ");" h-port)
;; (write-formals-to-port (define (f arg1) exp) "" ")" cu-port)  
(define (write-formals-to-port sexp null-arg close-paran port)
  (write-to-outport CONTLINE port "(")
  (if (null? (cdadr sexp))
      (write-to-outport CONTLINE port null-arg)
      (let ((bs (cdadr sexp)))
        (outtype CONTLINE (vartype (car bs))
                 (car bs) VOID port)
        (for-each (lambda (b)
                    (write-to-outport  CONTLINE port COMMA)
                    (outtype CONTLINE (vartype b)
                             b VOID port))
                  (cdr bs))))
  (write-to-outport CONTLINE port close-paran))

)