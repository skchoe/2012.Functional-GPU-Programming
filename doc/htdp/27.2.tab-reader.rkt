#lang racket
(provide (all-defined-out))

;; list v -> list of values
(define (list-split lst sep-v eq-op)
  (cond 
    [(empty? lst) '()]
    [else 
     (let loop ([current-list '()]
                [input-list lst]
                [lol '()])
       ;(printf "cl:~a, il:~a, lol:~a\n" current-list input-list lol)
       (cond
         [(empty? input-list) (if (empty? current-list)
                                  lol
                                  (append lol (list current-list)))]
         [(eq-op (first input-list) sep-v)
          (loop '() (rest input-list) (append lol (list current-list)))]
         [else (loop (append current-list (list (first input-list)))
                     (rest input-list)
                     lol)]))]))
(list-split '(0 1 2 3 4 5 4 3 2 1 2 3 4 5) 4 equal?)

(define (string-split str sep-char)
  (let* ([lst-char (string->list str)])
    (map list->string (list-split lst-char sep-char char=?))))

(string-split (list->string '(#\0 #\1 #\2 #\3 #\4 #\5 #\4 #\3 #\2 #\1 #\2 #\3 #\5)) #\4)
(string-split "Spring climbing in the Wasatch mountains	p0370n1_3_08.jpg	1_3_08	192.jpg	/UU_Photo_Archives/image/192.jpg" #\tab)

(define (tab-txt->list-list-string filename)
  (let* ([p (open-input-file filename)])
    (let reader ([port p]
                 [ln-cnt 0]
                 [lolos '()])
      (let* ([ln-str (read-line port 'any)])
        (printf "line readed: ~a\n" ln-cnt)
        (if (eof-object? ln-str)
            (begin 
              ;(printf "End of file\n")
              (close-input-port p)
              lolos)
            (let ([los (string-split ln-str #\tab)])
              ;(printf "~a\n" los)
              (reader port (add1 ln-cnt) (append lolos (list los)))))))))

  