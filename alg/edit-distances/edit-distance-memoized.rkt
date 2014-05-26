#lang racket
(provide (all-defined-out))
(require "edit-distance-helpers.rkt")

;;----------------------------------------------------------------------------------------------------
;; i=0, empty char at bg-lst
;; j=0, empty char at nd-lst
;; substring of ith element from theh beginning from bg-str where i=0...(string-length bg-str)
;; substring of jth element from theh beginning from nd-str where j=0...(string-length nd-str)
;; loloe : list of list of edit values created for (i-1,j-1), (i, j-1), and (i-1, j)
(define (edit-memoized bg-lst nd-lst i j loloe)
  (let* ([bbg (empty? bg-lst)]
         [bnd (empty? nd-lst)])
    ;(printf "bg-list:~a, nd-lst:~a, (~a, ~a)\n" bg-lst nd-lst i j)
    (cond
      [(and bbg bnd) (cons-mxn 0 0 0 loloe)]
      [bnd (let ([lst-idx (build-list (add1 (length bg-lst)) values)])
             (foldr (lambda (i x l) (cons-mxn i 0 x l))
                  loloe
                  lst-idx
                  lst-idx))] ;; bg-lst empty - '('(0) '(1) ... '((length bg-lst)))
      [bbg (let ([lst-idx (build-list (add1 (length nd-lst)) values)])
             (foldr (lambda (j x l) (cons-mxn 0 j x l))
                  loloe
                  lst-idx
                  lst-idx))] ;; nd-lst empty - '('(0 1 ... (length nd-lst)))
      [else ;; both not empty
       (let* ([bzi (zero? i)]
              [bzj (zero? j)]
              [e_i_j
               (cond 
                 [(and bzi bzj) 0]
                 [bzi j]
                 [bzj i]
                 [else 
                  (let* ([stored_im1_j (lol-ref loloe (- i 1) j)]
                         [stored_i_jm1 (lol-ref loloe i (- j 1))]
                         [stored_im1_jm1 (lol-ref loloe (- i 1) (- j 1))]
                         
                         [e_im1_j (if (not stored_im1_j) ;; check is pre-computed& stored 
                                      (edit-memoized bg-lst nd-lst (- i 1) j loloe)
                                      stored_im1_j)]
                         [e_i_jm1 (if (not stored_i_jm1) ;; check is pre-computed& stored
                                      (edit-memoized bg-lst nd-lst i (- j 1) loloe)
                                      stored_i_jm1)]
                         [e_im1_jm1 (if (not stored_im1_jm1) ;; check is pre-computed& stored
                                        (edit-memoized bg-lst nd-lst (- i 1) (- j 1) loloe)
                                        stored_im1_jm1)])
                    (min (+ 1 e_im1_j) 
                         (+ 1 e_i_jm1) 
                         (+ (diff (list-ref bg-lst (- i 1))
                                  (list-ref nd-lst (- j 1)))
                            e_im1_jm1)))])])
         (cons-mxn i j e_i_j loloe))])))

;; string-start string-end -> n+1 x m+1 matrix for edits, where n, m are length of input bg-str, nd-str,resp.
(define (edit-distances-memoized bg-str nd-str)
  (let* ([bg-lst (string->list bg-str)]
         [nd-lst (string->list nd-str)]
         [lb (length bg-lst)]
         [ln (length nd-lst)])
    (for/fold ([out-lol '()])
      ([i (+ 1 (length bg-lst))]) ; i index of list from 0 to (length bg-lst)
      (for/fold ([out-l out-lol])
        ([j (+ (length nd-lst) 1)])
        (edit-memoized bg-lst nd-lst i j out-l)))))


;; test 
(define bg-str "algorithm")
(define nd-str "altruistic")

(define lol (edit-distances-memoized bg-str nd-str))
;;display the table
(display-edits bg-str nd-str lol)

;; display edit-distance
(define lastnode (last (last lol)))
(printf "------------------------------\nFinal Edit distance by Momoization (recursion, use stored value):~a\n" lastnode)
