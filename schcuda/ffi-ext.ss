(module ffi-ext scheme
(require scheme/foreign)
         
; cuda has all unsafe features in ffi.
(unsafe!)

;; in: list of ctypes
;; out: list of accumlated values from ctype-sizeof ctype.
(provide offsets-ctype)
(define (offsets-ctype lst-ctype)
  (let* ([lst-size (map (lambda (cty) (ctype-sizeof cty)) lst-ctype)])
    (list->list-accum lst-size)))

  
;; in:list type in c. 'float 'int 'short 'long '* 'char 'double
;; out: list of accumlated values from compiler-sizeof csymbol.
(provide offsets-csym)
(define (offsets-csym lst-csym)
  (let* ([lst-size (map (lambda (cty) (compiler-sizeof cty)) lst-csym)])
    (list->list-accum lst-size)))


(provide list->list-accum)
(define (list->list-accum lst)
  (let loop ([idx 0]
             [last-amount 0]
             [old-list '()])
    (if (equal? idx (length lst))
        (reverse old-list)
        (let* ([cvalue (list-ref lst idx)]
               [new-amount (+ last-amount cvalue)]
               [new-lst (cons new-amount old-list)])
          (loop (+ idx 1) new-amount new-lst))))))
