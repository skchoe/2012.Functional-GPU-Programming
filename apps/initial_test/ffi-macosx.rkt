#lang racket
(require ffi/unsafe)

;; don't forget adding -m32
;gcc -c foo.c -m32
;gcc -dynamiclib foo.o -m32 -o libfoo.dylib
;gcc -c goo.c -m32
;gcc -v goo.o ./libfoo.dylib -m32 -o goo
;nm -gpv libfoo.dylib

(define foolib (ffi-lib "libfoo"))

(define add1
  (get-ffi-obj "add1" foolib (_fun _int -> _int)
    (lambda ()
      (error 'foolib
             "installed foolib does not provide \"foo\""))))

