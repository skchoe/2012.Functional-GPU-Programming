#lang scheme
(require scheme/foreign)

(unsafe!)

(define loc (malloc _int 10))
(printf "location offset = ~s\n" (ptr-offset loc))

(define new-loc 10)

(define p (ptr-add #f new-loc))
(printf " ~s\n" (ptr-ref p _int 0))