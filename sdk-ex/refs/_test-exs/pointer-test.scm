(module pointer-test mzscheme
  
(require scheme/foreign)
(unsafe!)

(list 'a 'b 'c)
()
(define vvv (make-vector 5))
(vector? vvv)
  
(printf "~s\n" (+ 10 20))
(define p (malloc 10))
(ptr-set! p _float 3.14)
(define loc (malloc 1))
(ptr-set! loc _pointer p)

(define p1 (ptr-add #f (ptr-ref loc _long)))
(ptr-ref loc _long)
(ptr-ref p1 _float)
)
