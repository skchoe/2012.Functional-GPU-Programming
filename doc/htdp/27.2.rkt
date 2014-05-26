;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |27.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))

;; file : list of symbol which 'NL is line separator
;; output : list of lines
(define (file->listoflines file)
  (cond
    [(empty? file) '()]
    [else (cons (first-line file) (file->listoflines (remove-first-line file)))]))

;; list -> list
(define (first-line file)
  (cond
    [(empty? file) '()]
    [(symbol=? (first file) 'NL) '()]
    [else (cons (first file) (first-line (rest file)))]))

(define (remove-first-line file)
  (cond 
    [(empty? file) '()]
    [(symbol=? (first file) 'NL) (rest file)]
    [else (remove-first-line (rest file))]))

(file->listoflines (list 'a 'b 'c 'NL 'd 'e 'NL 'f 'g 'h))