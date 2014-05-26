#lang racket
(provide (all-defined-out))
(require "edit-distance-helpers.rkt")

;; i=0, empty char at bg-lst
;; j=0, empty char at nd-lst
;; substring of ith element from theh beginning from bg-str where i=0...(string-length bg-str)
;; substring of jth element from theh beginning from nd-str where j=0...(string-length nd-str)
(define (edit bg-lst nd-lst i j)
  (let* ([bbg (empty? bg-lst)]
         [bnd (empty? nd-lst)])
    ;(printf "bg-list:~a, nd-lst:~a, (~a, ~a)\n" bg-lst nd-lst i j)
    (cond
      [(and bbg bnd) 0]
      [bbg (length nd-lst)] ;; bg-lst empty
      [bnd (length bg-lst)] ;; nd-lst empty
      [else ;; both not empty
       (let*-values
           ([(bzi) (zero? i)]
            [(bzj) (zero? j)]
            [(e_i_j)
             (cond 
               [(and bzi bzj) 0]
               [bzi j]
               [bzj i]
               [else 
                (let* ([e_im1_j (edit bg-lst nd-lst (- i 1) j)]
                       [e_i_jm1 (edit bg-lst nd-lst i (- j 1))]
                       [e_im1_jm1 (edit bg-lst nd-lst (- i 1) (- j 1))])
                  (min (+ 1 e_im1_j) 
                       (+ 1 e_i_jm1) 
                       (+ (diff (list-ref bg-lst (- i 1))
                                (list-ref nd-lst (- j 1)))
                          e_im1_jm1)))])])
         e_i_j)])))


;; string-start string-end -> n+1 x m+1 matrix for edits, where n, m are length of input bg-str, nd-str,resp.
(define (edit-distances bg-str nd-str)
  (let* ([bg-lst (string->list bg-str)]
         [nd-lst (string->list nd-str)]
         [lb (length bg-lst)]
         [ln (length nd-lst)]
    
         [rev-lol
          (for/fold ([out-lst '()])
            ([i (+ 1 (length bg-lst))]) ; i index of list from 0 to (length bg-lst)
            (let* ([len (+ (length nd-lst) 1)]
                   [l-bg (build-list len (lambda (x) bg-lst))]
                   [l-nd (build-list len (lambda (x) nd-lst))]
                   [l-i  (build-list len (lambda(x) i))]
                   [l-c  (build-list len values)])
              (cons (map edit l-bg l-nd l-i l-c)
                    out-lst)))])
    (reverse rev-lol)))

;; test 
;(define bg-str "exponential")
;(define nd-str "polynomial")
                    
(define bg-str "algorithm")
(define nd-str "altruistic")

(define lol (edit-distances bg-str nd-str))

(display-edits bg-str nd-str lol)

(printf "-----------------------\nEdit Distance (Pure recursion):~a\n" (last (last lol)))