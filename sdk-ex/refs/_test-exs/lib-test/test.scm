#lang scheme
(require scheme/foreign
         scheme/system)
(unsafe!)

(system "make")

(define foo 
  (get-ffi-obj 'foo
               (ffi-lib "libtest.so")
               (_fun _int -> _int)
               (lambda () (error "ERR-foo\n"))))
(foo 1)

(define add1f
  (get-ffi-obj 'add1f
               (ffi-lib "libtest.so")
               (_fun (io : (_ptr io _float))
                     -> _void
                     -> io)
               (lambda () (error "ERR-add1f\n"))))

(add1f 100.0)

(define vadd1f
  (get-ffi-obj 'vadd1f
               (ffi-lib "libtest.so")
               (_fun (vio : (_cpointer '_float))
                     (n : _int)
                     -> _void
                     -> vio)
               (lambda () (error "ERR-vadd1f\n"))))

(define v-alloc (malloc _float 3))
(cpointer-push-tag! v-alloc '_float)
(if (cpointer? v-alloc) (printf "cptr\n") (printf "not cptr\n"))
(ptr-set! v-alloc _float 0 1.0)
(ptr-set! v-alloc _float 1 2.0)
(ptr-set! v-alloc _float 2 3.0)
(if (cpointer? v-alloc) (printf "cptr\n") (printf "not cptr\n"))

(vadd1f v-alloc 3)
(printf "~s ~s ~s\n" (ptr-ref v-alloc _float 0)
(ptr-ref v-alloc _float 1)
(ptr-ref v-alloc _float 2))
