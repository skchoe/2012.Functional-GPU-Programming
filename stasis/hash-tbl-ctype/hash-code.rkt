#lang racket

(provide (all-defined-out))

(define (hash-1-str x)
  (hash-1-char (car (string->list x))))

(define (hash-1-char x)
  (hash-1-by (char->integer x)))

;; a(97) ~ z(122) A(65) ~ Z(90)
;; 0     ~ 25     26    ~ 51 : Total 52 in a row.
(define (hash-1-by by)
  (let* ([nby (if (<= 97 by) ;; lower case character?  
                  (- by 97)  ;; by - 'a'
                  (- by 39))]) ;; by - 39(65-26)
    nby))

;; input - string with 2 digit valid alphabet
;; output -hash code: integer?
(define (hash-2-str xx)
  (hash-2-char (string->list xx)))

(define (hash-2-char l-c)
  (hash-2-by (map char->integer l-c)))

(define (hash-2-by l-by)
  (let* ([l-idx (map hash-1-by l-by)]
         
         [head (car l-idx)]   ;; hash code for digit 2
         [neck (cadr l-idx)]) ;; hash code for digit 1
    
    #;(display l-idx)
    (+ (+ neck (* head 52)) ; order 2
       52))) ; order 1

(define (hash-3-str xxx)
  (hash-3-char (string->list xxx)))

(define (hash-3-char l-c)
  (let* ([l-by (map char->integer l-c)]
         [l-idx (map hash-1-by l-by)]
         
         [o3 (car l-idx)]
         [o2 (cadr l-idx)]
         [o1 (caddr l-idx)])
    (+ (* 52 52 o3) (* 52 o2) o1
       (* 52 52) ; order 2
       52))) ; order 1

;; given char-list, convert to sublist from 'a~z', 'A~Z' by deleting #\null or #\space
;; whereever in the list, call corresponding hash-x func by the length of the resulting list.
(define (string->hash-code str)
  (let* ([new-string 
          (list->string 
           (filter (λ (x) 
                     (if (or (equal? x #\null)
                             (equal? x #\space)) 
                         #f #t))
                   (string->list str)))]
         [result
          (case (string-length new-string)
            [(1) (hash-1-str new-string)]
            [(2) (hash-2-str new-string)]
            [(3) (hash-3-str new-string)]
            [else (printf " string->hashcode : Hashcode for ~a?\n" new-string)
                  (error "TODO: such long string cannot have hash code now\n")])])
    ;(printf "string->hashcode for ~a, newstr:~a  --> result:~a\n" str new-string result)
    result))


(define (hash-code->string-1 code)
  (if (<= code 51)
      (list->string (list (integer->char (if (<= code 25) (+ code 97) (+ code 39)))))
      (error "hash-code->string-1 outof range error\n")))

(define (hash-code->string-2 code)
  (cond
    [(< code (string->hash-code "aa")) (error "hash-code->string-2 outof range error: too small\n")]
    [(<= code (string->hash-code "ZZ")) 
     (let*-values ([(length1) (+ (string->hash-code "Z") 1)]
                   [(normed-code) (- code length1)]
                   [(q r) (quotient/remainder normed-code length1)])
       #;(printf "code:~a, quotient:~a, remainder:~a, length:~a\n" normed-code q r length1)
       (let ([s0 (hash-code->string-1 q)]
             [s1 (hash-code->string-1 r)])
         (string-append s0 s1)))]
    [else (error "hash-code->string-2 outof range error: too big\n")]))

(define (hash-code->string-3 code)
  (cond
    [(< code (string->hash-code "aaa")) (error "hash-code->string-3 outof range error: too small\n")]
    [(<= code (string->hash-code "ZZZ")) 
     (let*-values ([(length1) (+ (string->hash-code "Z") 1)]
                   [(length2) (* length1 length1)]
                   [(normed-code) (- code length1 length2)]
                   [(q2 r2) (quotient/remainder normed-code length2)]
                   [(q1 r1) (quotient/remainder r2 length1)])
       #;(printf "n-code:~a, len1:~a len2:~a quotients:~a ~a, remainder:~a ~a\n" 
               normed-code length1 length2 q2 q1 r2 r1)
       (let ([s0 (hash-code->string-1 q2)]
             [s1 (hash-code->string-1 q1)]
             [s2 (hash-code->string-1 r1)])
         (string-append s0 s1 s2)))]
    [else (error "hash-code->string-3 outof range error: too big\n")]))

;(string->hash-code "a")
;(hash-code->string-1 0)
;(string->hash-code "aa")
;(hash-code->string-2 52)
;(string->hash-code "aZ")
;(hash-code->string-2 103)
;(string->hash-code "ZZ")
;(hash-code->string-2 2755)
;(- (string->hash-code "aaa") (string->hash-code "baa"))
;(hash-code->string-3 2756)
;(- (string->hash-code "ZZZ") (string->hash-code "YZZ"))
;(hash-code->string-3 143363)

;code: integer? non-negative
(define (hash-code->string code)
  (let* ([max1 (string->hash-code "Z")]
         [max2 (string->hash-code "ZZ")]
         [max3 (string->hash-code "ZZZ")]
         [result
          (cond
            [(<= code max1) (hash-code->string-1 code)]
            [(<= code max2) (hash-code->string-2 code)]
            [(<= code max3) (hash-code->string-3 code)]
            [else (error "Hash code too big\n")])])
    ;(printf "hash-code->string: INPUT-code:~a, uppbd:~a, ~a, ~a\n" code max1 max2 max3)
    result))

                         
                         
#;(hash-code->string (string->hash-code "a"))
;(string->hash-code "z ")
;(string->hash-code " A")
#;(hash-code->string (string->hash-code "Z"))

#;(hash-code->string (string->hash-code "aa"))
#;(hash-code->string (string->hash-code "ZZ"))
#;(hash-code->string (string->hash-code "aaa"))
#;(hash-code->string (string->hash-code "ZZZ"))
;"aZ"
;(string->hash-code "aZ")
;"ZZ"
;(string->hash-code "ZZ")
;"aaa"
;(string->hash-code "aaa")
;"ZZZ"
#;(string->hash-code "ZZZ")
;(- (+ (* 52 52 52) (* 52 52) 52) 1)