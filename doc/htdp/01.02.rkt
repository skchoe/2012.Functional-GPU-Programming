;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |01.02|) (read-case-sensitive #t) (teachpacks ((lib "convert.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "convert.ss" "teachpack" "htdp")))))
; 2.2

; Tc = (5/9)*(Tf-32);
; Tf = (9/5)*Tc+32; 
(define (Fahrenheit->Celsius f)
   f)
(convert-gui Fahrenheit->Celsius)
(convert-repl Fahrenheit->Celsius)
;(convert-file "in.dat" Fahrenheit->Celsius "out.dat")
;(define (dollar->euro d) (* 0.7 d))
;(define (triangle w h) (/ (* w h) 2.0))
;(define (convert3 a0 a1 a2) (+ (* 100 a2) (* 10 a1) a0))

;(define (f n)
;  (+ (/ n 3) 2))
;
;(f 2)
;(f 5)
;(f 9)


; 2.3

;(define (grossincome->tax gi)
;  (* 0.15 gi))
;
;(define (netpay hr)
;  (* 12 hr))
;
;(define (sum-coins penny nickel dime quarter)
;  (+ penny (* 5 nickel) (* 10 dime) (* 15 quarter)))
;
;;; income producer
;(define (total-profit attendee-per-show)
;  (- (* attendee-per-show 5.0) 
;     20
;     (* .5 attendee-per-show)))

;; 2.4
;; syntax errors
#;(define (f 1)
  (+ x 10))

#;(define (g x)
  + x 10)

#;(define h(x) 
  (+ x 10))

;; runtime errors
#;(+ 5 (/ 1 0))

#;(sin 10 20)



#;(define (somef x)
  (sin x x))

#;(somef 10 20)

#;(somef 10)



