#lang racket
(require ffi/unsafe
         racket/bool
         racket/local
         racket/match
         racket/pretty
         racket/set
         racket/list
         "../../hash-tbl-ctype/hash-ffi-string.rkt"
         "../../hash-tbl-ctype/hash-ffi-strarray.rkt"
         "../../hash-tbl-ctype/ffi-common.rkt"
         "../../seq-code/SBA-utils.rkt"
         
         "../../input-progs/input-progs-forseq.rkt"
         "commons.rkt"
         "alpha-conversion.rkt"
         "a-normal-to-simple-rep.rkt"
         "encoding-constraints.rkt")


#;(define prog
  '(let (cons-it (lambda (x) (let (r (cons x x)) r )))
     (let (t1 1)
       (let (t1 2)
         (let (t3 #f)
           (let (pair1 (if t3 
                           (let (w1 (apply cons-it t1)) w1)
                           (let (w1 (apply cons-it t1)) w1)))
             (let (t4 2)
               (let (pair2 (apply cons-it t4))
                 (let (a (car pair2))
                   a)))))))))
#;(define prog
  '(let (a (lambda (x) x))
     a))

(let*-values
    (;; used for (gensym) which is not duplicates from. need update for new (gensym)
     [(lol-vars prog1) (convert-no-dupvar prog)]
     [(v) (printf "\nVariable-conversion:~a\n" lol-vars)]
     [(lst-var) (prog->list-of-binders prog1)]
     [(prog2) (convert-to-distance-form prog1)])

  (pretty-display prog2)
  (count-bindings prog2))