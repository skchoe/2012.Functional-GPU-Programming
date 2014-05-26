(module scm2c-xlate scheme
  
(require scheme/system
         ;scheme/pretty
         ;syntax/modread
         ;syntax/to-string
         "scm2c-definitions.ss"
         "scm2c-toplevel.ss")

(define in-filename "../ex/simple-src.scm")
  
 
(define (process-lst-top-levels p-top-level portset)
  (letrec ([inport (port-set-in portset)]
           [outport-cu (port-set-out-cu portset)]
           [outport-h (port-set-out-h portset)]
           [read-newline
            (lambda ()
              (when (char=? #\newline (read-char inport))
                (if (char=? #\newline (peek-char inport))
                    (read-char inport)
                    #f)))]
           [proc-input-char 
            (lambda (c)
              (cond [(eof-object? c) #f]
                    [(eqv? c #\newline)
                     (begin (read-newline)
                            (newline outport-cu)
                            (proc-input-char (peek-char inport)))]
                    [(char-whitespace? c)
                     (begin (write-char (read-char inport) outport-cu)
                            (proc-input-char (peek-char inport)))]
                    [(char=? c #\;) (read-comment c)]
                    ;Start reading non-comment scheme grammar.                       
                    [else (read-content)]))] 
           [read-content 
            (lambda ()
              (let* ([s1 (read inport)])
                (unless (eof-object? s1)
                  (begin 
                    (printf "READ: s1:~s\n" s1)
                    (process-toplevel s1 portset)))
                (proc-input-char (peek-char inport))))]
           
           ;;Comments transcribed to generated C source files.
           [read-comment 
            (lambda (c)
              (cond 
                [(eof-object? c) (proc-input-char c)]
                [(eqv? #\; c)
                 (read-char inport)
                 (read-comment (peek-char inport))]
                ;; Transcribe the comment line to C source file.
                [else
                     (out-c-cmt (read-line inport) outport-cu)
                     (proc-input-char (peek-char inport))]))])
    
    (proc-input-char (peek-char inport))))
  
(define (scm2c in-filename)
  (let* ([in-stream (open-input-file in-filename)]
         [modname (substring in-filename 0 (- (string-length in-filename) 4))]
         [out-h-filename (string-append modname ".h")]
         [out-cu-filename (string-append modname ".cu")]
         [out-h-stream (open-output-file out-h-filename #:mode 'text #:exists 'replace)]
         [out-cu-stream (open-output-file out-cu-filename #:mode 'text #:exists 'replace)]
         
         [portset (make-port-set in-stream out-h-stream out-cu-stream)])

    (process-lst-top-levels process-toplevel portset)

    (close-output-port out-h-stream)
    (close-output-port out-cu-stream)
    (close-input-port in-stream)))
  
  
(system "rm ../ex/*.cu ../ex/*.h")
(scm2c in-filename)
  
  )

  
