#lang racket


(define (to-string x)
  (cond
    [(string? x) x]
    [(symbol? x) (symbol->string x)]
    [(number? x) (number->string x)]
    [else (error  "(to-string) have no idea how to convert input:~a to string\n" x)]))
  
(define lst-str (list "+" "1" "2" "3" "4" "5"))

; input : '("+" "1" "2" "3" "4" "5")
; output: "(1 + (2 + (3 + (4 + (5)))))"
(define (pre->infix ls)
  (let* ([op (car ls)] ; operator string
         [lord (cdr ls)]) ; list of operand strings
    ; "+ 2 "
    (let loop ([lord lord])
      (if (null? (cdr lord))
          (car lord)
          (string-append "( " (car lord) " " op " " (loop (cdr lord)) " )")))))

(pre->infix lst-str)

;(+ 1 2 3 4) ---> (1 + (2 + (3 + (4)))) 
(define (pref-app->inf-app-string lst-pref)

  (let* ([lst-str (map to-string lst-pref)])
    (pre->infix lst-str)))

(define answer (pref-app->inf-app-string (list '+ 1 2 3 4 5)))
answer

(define (pre->funapp ls)
  (let* ([op (car ls)] ; operator string
         [lord (cdr ls)] ; list of operand strings
         [od1 (car lord)] ; 1st operand
         [lord1 (cdr lord)]) ; list from 2nd operand
    
    (let* ([tail-string ; , 2
            (for/fold ([str ""])
              ([i (in-range (length lord1))])
              (printf "str:~a for/fold:~a\n" str (list-ref lord1 i))
              (string-append str ", " (list-ref lord1 i)))])
      (string-append op "(" od1 tail-string ")"))))

(define (pref-app->funapp-string lst-pref) 
  (let* ([lst-str (map to-string lst-pref)])
    (pre->funapp lst-str)))


(define lst-funapp (list 'proc 1 2 3))
(define funapp (pref-app->funapp-string lst-funapp))
lst-funapp
funapp