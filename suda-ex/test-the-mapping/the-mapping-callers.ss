#lang scheme
(require "the-mapping.ss")
(require (for-syntax "the-mapping.ss"))

(require "filling-mapping.ss")
(require "calling-mapping.ss")

(define id1 #'A)
(mp-put! id1 "A")
(define id2 #'B)
(mp-put! id2 "B")

(define id3 #'A)
(define id4 #'B)

(mp-get id3)
(mp-get id4)

(define lst0 (list "a" "b" "c" "d"))
(number? (syntax->datum (syntax '1)))


(number->string 111)
(gensym (number->string 111 ))
(define k 5)
(define K (string->symbol (bytes->string/locale (make-bytes k))))
K
(printf "is K idienti? ~s\n" (identifier? (syntax K)))

(define (number->symbol-stx n)
  (printf "(1)~s (2)~s (3)~s\n" (make-bytes n) (bytes->string/locale (make-bytes n)) (string->symbol (bytes->string/locale (make-bytes n))))
  (string->symbol (bytes->string/locale (make-bytes n))))

(define nnn 1)
(define d (number->symbol-stx nnn))
(identifier? (syntax d))
(printf "----------------------------------------------\n")
(define C (gensym (number->string 1)))
(identifier? (syntax C))
(identifier? (syntax (gensym (number->string 1))))

;
;(let ([nnn 2]
;      [gs (gensym (number->string nnn))])
;  (printf "id?(gs) = ~s\n" (identifier? (syntax gs)))
;
;  (for ([i (in-range (length lst0))])
;    (let* ([s (gensym (number->string i))]
;           [ss (syntax s)])
;      (printf "VAL = ~s, ~s ~s ~s\n" i s (syntax->datum (syntax s)) (syntax->datum ss))
;      (if (identifier? ss);(syntax s))
;          (begin (mp-put! ss (list-ref lst0 i))
;                 (printf "~s is successfully inserted \n" (mp-get ss)))
;          (printf "NON-ideiintifier\n")))))
;


(printf "----------------------------------------------\n")

(define lst (list "A" "B" "C" "D"))
(define lst-id (list #'A #'B #'C #'D))

(for-each (lambda (y) (printf "for-each : ~s\n" (syntax-e y))) lst-id)

(define (view-mapping)
  (mp-view))
  
(define (map-check)

  
  (define-syntax (test-mapping stx)
    (syntax-case stx ()
      [(_)
       #'(begin
           (printf "captured 2\n")
           (view-mapping))]
      [(_ lst lst-id)
       #'(begin
           (printf "captureed 1\n")
           (fill-in-mapping lst lst-id)
           (call-out-mapping lst lst-id))]
      ))
  
  
  (test-mapping lst lst-id)
  (test-mapping)
  
  (identifier? #'A)
  (printf "----------------------------------------------\n"))

(map-check)
(view-mapping)
  
;(define-syntax (or stx)
;  (syntax-case stx ()
;    [(_) (syntax (begin (printf "pattern 0\n") #f))]
;    [(_ e) (syntax (begin (printf "pattern 1\n") e))]
;    [(_ e1 e2 e3 ...)
;     (syntax (let ([t e1])
;               (printf "pattern 2\n")
;               (if t t (or e2 e3 ...))))]))
;
;(define a (or))
;(define gstm (or #f))
;(define gstm1 (or (list + 1 2 3 4 5)))
;(define gstm11 (or 1 2 3 4))
;(define gstm2 (or (syntax #t)))
;(printf "~s\n" gstm)
;(printf "~s\n" gstm1)
;(printf "~s\n" (syntax->datum gstm2))


    
