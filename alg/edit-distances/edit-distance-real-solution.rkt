#lang racket
(provide (all-defined-out))
(require "edit-distance-helpers.rkt")

;; substring of ith element from theh beginning from bg-str where i=0...(string-length bg-str)
;; substring of jth element from theh beginning from nd-str where j=0...(string-length nd-str)
;; this produces struct-Eij
(define (edit bg-lst nd-lst i j e)
  (let* ([empty-char #\*]
         [bbg (empty? bg-lst)]
         [bnd (empty? nd-lst)])
    #;(printf "bg-list:~a, nd-lst:~a, (~a, ~a) -->e:~a, nw-gb:~a, nw-nd:~a\n" bg-lst nd-lst i j (Eij-ed e) (Eij-new-bg e) (Eij-new-nd e))
    (cond
      [(and bbg bnd) (transfer-bg-nd e 0)]
      [bbg (transfer-bg-nd e (length nd-lst))] ;; bg-lst empty
      [bnd (transfer-bg-nd e (length bg-lst))] ;; nd-lst empty
      [else ;; both not empty
       (let*-values
           ([(bzi) (zero? i)]
            [(bzj) (zero? j)]
            [(e_i_j)
             (cond 
               [(and bzi bzj) (transfer-bg-nd e 0)]
               [bzi (let* ([prev-e (edit bg-lst nd-lst 0 (sub1 j) e)])
                      (make-Eij j (insert-char (Eij-new-bg prev-e) 0 empty-char) (Eij-new-nd prev-e)))] ;; insertion
               [bzj (let* ([prev-e (edit bg-lst nd-lst (sub1 i) 0 e)])
                      (make-Eij i (Eij-new-bg prev-e) (insert-char (Eij-new-nd prev-e) 0 empty-char)))] ;; deletion
               [else 
                (let* ([e_im1_j   (edit bg-lst nd-lst (- i 1) j e)] ;; deletion
                       [e_i_jm1   (edit bg-lst nd-lst i (- j 1) e)] ;; insertion
                       [e_im1_jm1 (edit bg-lst nd-lst (- i 1) (- j 1) e)] ;; substitution or no change
                       [ed-del (add1 (Eij-ed e_im1_j))]
                       [ed-ins (add1 (Eij-ed e_i_jm1))]
                       [ed-subst (+ (diff (list-ref bg-lst (- i 1)) 
                                          (list-ref nd-lst (- j 1)))
                                    (Eij-ed e_im1_jm1))])
                  (cond ;; substitution is priority one, insertion, then deletion
                    [(and (<= ed-ins ed-del) (<= ed-ins ed-subst))   
                     #;(printf "Insert -- ") (make-Eij ed-ins (insert-char (Eij-new-bg e_i_jm1) (sub1 j) empty-char) (Eij-new-nd e_i_jm1))]  ;; insertion 
                    [(and (<= ed-del ed-ins) (<= ed-del ed-subst))   
                     #;(printf "Delete -- ") (make-Eij ed-del (Eij-new-bg e_im1_j) (insert-char (Eij-new-nd e_im1_j) (sub1 j) empty-char))]  ;; deletion
                    [(and (<= ed-subst ed-del) (<= ed-subst ed-ins)) 
                     #;(printf "Sub-st -- ") (transfer-bg-nd e_im1_jm1 ed-subst)] ;; substitution
                    ))])])
                    
         #;(printf "EIJ is decided: w/ ed:~a, new-bg:~a, new-nd:~a\n" (Eij-ed e_i_j) (Eij-new-bg e_i_j) (Eij-new-nd e_i_j))
         e_i_j)])))


;; string-start string-end -> n+1 x m+1 matrix for edits, where n, m are length of input bg-str, nd-str,resp.
(define (edit-distances bg-str nd-str)
  (let* ([bg-lst (string->list bg-str)]
         [nd-lst (string->list nd-str)]
         [lb (length bg-lst)]
         [ln (length nd-lst)]
    
         [rev-lol
          (for/fold ([out-lol '()])
            ([i (in-range (add1 lb))]) ; i index of list from 0 to (length bg-lst)
            (let ([sub-l 
                   (reverse
                    (for/fold ([out-l '()])
                      ([j (in-range (add1 ln))])
                      (cons (edit bg-lst 
                                  nd-lst 
                                  i 
                                  j
                                  (make-Eij 0 bg-lst nd-lst)) out-l)))])
              (cons sub-l out-lol)))])
            
    (reverse rev-lol)))

;; test 
;(define bg-str "exponential")
;(define nd-str "polynomial")
;(define bg-str "ntial")
;(define nd-str "nomial")
(define bg-str "algorithm")
(define nd-str "altruistic")
(define lol (edit-distances bg-str nd-str))
(display-edits bg-str nd-str lol)

(define lastnode (last (last lol)))
(printf "--------------------------\nInput s1: ~a, s2: ~a\nEdit distance:~a, output s1:~a, s2:~a\n" 
        bg-str 
        nd-str 
        (Eij-ed lastnode) 
        (list->string (Eij-new-bg lastnode))
        (list->string (Eij-new-nd lastnode)))

