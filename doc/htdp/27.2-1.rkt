;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 27.2-1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(define input (list 'a 'b 'c 'NL
      'd 'e 'NL
      'f 'g 'h 'NL))
;;

;(cons '(a (b (c ()))) '(d e) '(f g h))

;; output '(a b c)
(define (first-line in)
  (cond
    [(empty? in) '()]
    [(symbol=? (first in) 'NL) '()]
    [else (cons (first in) (first-line (rest in)))]))

;; output '(d e NL f g h NL)
(define (rest-lines in)
  (cond
    [(empty? in) '()]
    [(symbol=? (first in) 'NL) (rest in)]
    [else (rest-lines (rest in))]))

;; file->list-of-lines : file  ->  (listof(listof symbols))
;; to convert a file into a list of lines 
(define (file->listoflist in)
  (cond
    [(empty? in) '()]
    [else
     (cons (first-line in) (file->listoflist (rest-lines in)))]))
    
(first-line input)
(rest-lines (list 'c 'NL 'a 'b)) ; '(a)
(rest-lines input)
(file->listoflist input)