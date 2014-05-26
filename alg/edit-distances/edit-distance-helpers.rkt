#lang racket
(provide (all-defined-out))


;; char char -> 0 or 1
(define (diff x y)
  (cond 
    [(char=? x y) 0]
    [else 1]))



;; (listof number) element -> listof number 
;; insert x at the end of list l
    
(define (insert-end l x)
  (append l (list x)))

;; listof number number number -> new list
;; replace ith element of list l with x
(define (replace-elt l i x)
  (local
    ((define (sub-list-front l i) ;; get (0 ... i-1)th elts
       (let loop ([cnt i]
                  [result-list '()])
         (let* ([idx (- cnt 1)]
                [elt (list-ref l idx)]
                [new-lst (cons elt result-list)])
           (if (zero? idx) new-lst (loop idx new-lst)))))
     
     ;; get element from ith position i=0 ...
     (define (sub-list-end l i)
       ;(printf "i=~a, l:~a\n" i l)
       (cond 
         [(equal? (length l) (add1 i)) (last l)]
         [(< (length l) (add1 i)) '()]
         [else (let loop ([cnt i]
                          [result-list l])
                 (cond 
                   [(zero? cnt) result-list]
                   [else (loop (- cnt 1) (rest result-list))]))])))
    
    (cond
      [(<= (length l) i) l]
      [(zero? i) (cons x (rest l))]
      [else (append (sub-list-front l i) ;; 1 <= i < (length l)
                    (list x)
                    (sub-list-end l (add1 i)))])))

;create listoflist adding elt at (i,j)th position.
(define (cons-mxn i j elt lol)
  (cond
    [(and (zero? i) (zero? j)) (cons (cons elt '()) '())]
    [(zero? j) (insert-end lol (cons elt '()))]
    [(zero? i) (cons (insert-end (first lol) elt) '())]
    [else (replace-elt lol i (insert-end (list-ref lol i) elt))]))


(define-struct Eij (ed new-bg new-nd));; number lst lst

(define (transfer-bg-nd e ed)
  (make-Eij ed (Eij-new-bg e) (Eij-new-nd e)))


(define (display-edits bg-str nd-str lol)
  (let* ([bg-lst (string->list (string-append " " bg-str))]
         [nd-lst (string->list (string-append " " nd-str))]) ;; ed field printing in Eij struct
    ;; line 1
    (printf "  ")
    (print-elt nd-lst)
    ;; line k > 1
    (for-each 
     print-elt
     (map (lambda (chr x) (append (list chr) 
                                  (if (Eij? (caar lol))
                                      (map Eij-ed x)
                                      x))) bg-lst lol))))

;; print list element in a line with space
(define (print-elt lst)
  (cond
    [(empty? lst) (newline)]
    [else
     (begin
       (printf "~a " (car lst))
       (print-elt (cdr lst)))]))


;; print list element in a line with space
(define (print-Eij-elt lst)
  (cond
    [(empty? lst) (newline)]
    [else
     (begin
       (if (Eij? (car lst)) 
           (printf "~a " (Eij-ed (car lst)))
           (error "EIJ is not EIJ"))
       (print-Eij-elt (cdr lst)))]))

;; print mxn matrix
(define (print-mxn lol)
  (cond 
    [(empty? lol) (newline)]
    [else 
     (begin
       (print-elt (car lol))
       (newline)
       (print-mxn (rest lol)))]))



;; data random generation for list of list of numbers [0,1]
(define (build-mxn row col)
  (cond 
    [(zero? row) '()]
    [else 
     (cons (build-list col (lambda (x) (random)))
           (build-mxn (- row 1) col))]))

;; count row of matrix
(define (count-row lol)
  (length lol))

;; check the equality of each list in the list of list
(define (all-equal-length? lol)
  (let* ([lst-len (length lol)])
    (cond 
      [(empty? lst-len) #f]
      [else (foldl (lambda (old new) (equal? old new)) (length (car lol)) (map length (cdr lol)))])))

;; listof listof val -> number or false
;; 
(define (count-col lol)
  (cond 
    [(empty? lol) 0]
    [(all-equal-length? lol) (length (car lol))]
    [else #f]))

  
;; (listof listof number) int int -> int or false
;; get element from 2d array (list of list)
(define (lol-ref lol r c)
  (let* ([num-row (length lol)])
    (if (<= num-row r) ;; r is greater than or equal to num-row
        #f  ;; exceed limit
       (let* ([row (list-ref lol r)]
              [num-col (length row)]) ;; r is in range
         (if (<= num-col c)
             #f ;; exceed limit
             (list-ref row c))))));; col c exists

;; lst-ch : list of characters
;; i : index for new space
;; shift all character from position i, let ith position space
;; -> new listof chars
(define (insert-char lst-ch i ch)
;; i=0, empty char at bg-lst
;; j=0, empty char at nd-lst
;; e : struct-Eij
  (cond
    [(< i 0) (error "insert-char: i is negative")];lst-ch]
    [(<= (length lst-ch) i) (error "insert-char: i is greater or equal to length of lst")];lst-ch] 
    [else
     (cond
       [(empty? lst-ch) lst-ch]
       [else (reverse 
              (for/fold ([lst-out '()]) 
                ([k (in-range (length lst-ch))])
                (let ([kth-ch (list-ref lst-ch k)])
                  (if (equal? k i) 
                    (cons kth-ch (cons ch lst-out))
                    (cons kth-ch lst-out)))))])]))

(define (insert-char-str str th ch)
  (list->string (insert-char (string->list str) th ch)))


;; 97 ~ 122 range of ascii code
(define (random-char)
  (let* ([r (random 123)])
    (if (< r 97) 
        (random-char) 
        r)))

;(integer->char (random-char))

(define (random-string num)
  (list->string (foldr (lambda (n l)
                         (cons (integer->char (random-char)) l))
                        '() (build-list num values))))

(random-string 10)

