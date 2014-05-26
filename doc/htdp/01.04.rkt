;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01.04|) (read-case-sensitive #t) (teachpacks ((lib "convert.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "convert.ss" "teachpack" "htdp")))))
;;; 1.4


true
#t
false
#f

(define (wage hr)
  (cond 
    [(< 65 hr) (error "Overtime")]
    [(> 20 hr) (error "Undertime")]
    [else (* hr 20)]))

#;(wage 80)
#;(wage 10)
(wage 30)