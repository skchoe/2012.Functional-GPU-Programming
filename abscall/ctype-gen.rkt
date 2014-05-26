#lang racket
(require ffi/unsafe syntax/parse syntax/kerncase)
(require racket/require-syntax)

(require (for-syntax syntax/parse))

(require "dim-rep.rkt")

; http://permalink.gmane.org/gmane.comp.lang.racket.user/3945
(define-require-syntax (collects path-stx)
  (syntax-case path-stx ()
    [(_ source)
     (datum->syntax path-stx 
                    (string-append (path->string (find-system-path 'collects-dir)) (syntax-e #'source)))]))

(require (lib "typed-scheme/rep/type-rep.rkt"))
 
(provide (all-defined-out))

(define (base-ts-type->ctype ts-stx)
  (printf "base-name->ctype input name:~a\n" ts-stx)
  (syntax-case ts-stx 
    (Boolean Symbol Void Bytes Regexp PRegexp Byte-Regexp Byte-PRegexp String
             Keyword Char Thread Prompt-Tag Continuation-Mark-Set Path
             Namespace Output-Port Input-Port TCP-Listener Flvector Number
             InexactComplex Float Flonum Nonnegative-Flonum Exact-Rational Integer
             Exact-Positive-Integer Positive-Fixnum Negative-Fixnum)
    [Boolean _bool]
    [Symbol _byte]
    [String _string]
    [Char _byte]
    [Path _string]
    [Number _double]
    [Float _float]
    [Flonum _float]
    [Nonnegative-Flonum _float]
    [Exact-Rational _float]
    [Integer _int]
    [Exact-Postive-Integer _uint]
    [Positive-Fixnum _fixnum]
    [Negative-Fixnum _fixnum]
    [_ (error "base-ts-type->ctype cannot proc input type stx")]))


;; ts-ty-stx is typically the type of element in function arg or rng. Currently, they are not
;; of function form so that function is not the first order value.
;; Result, Union are same treated as normal Base value i.e. output is just a ctype.
;; Values, ValuesDot is same as list of ctypes
;; Vector is a pair with car is _pointer type, second value can be any type (Vectorof anytype) - but function (As line 1 of the comment)
(define (ts-type->ctype-form ts-ty-stx)
  (printf "------ctype-fyorm:~a\n" (syntax-e ts-ty-stx))
  (syntax-case ts-ty-stx (values)
;   [(VectorOf ty) (printf "vector type:~a\n" (syntax->datum ts-ty-stx))]
;   [_ (printf "non-vector type:~a\n" (syntax->datum ts-ty-stx))]))
    [(vec ty) (printf "vector type:~a, l:~a, x:~a\n" (syntax->datum ts-ty-stx) (syntax->datum #'vec) #'ty)
              (if (equal? (syntax->datum #'vec) 'Vectorof)
                  #;(let* ([tty (_cpointer (syntax->datum #'ty))])
                    (printf "ts-type->ctype-form Vectorof:~a\n" tty) 
                    tty)
                  (list _pointer (ts-type->ctype-form #'ty))
                  (error "list type but not identified (not VectorOf XX type)"))]
    [values (printf "Values...:~a\n" #'values)]
    [_ (printf "non-vector type:~a\n" (syntax->datum ts-ty-stx))
       (base-ts-type->ctype ts-ty-stx)]))
    

    
(define (ts-type->ctype-form-deprecated ts-ty-stx)
  #;(printf "------ctype-form:~a\n" (syntax-e ts-ty-stx))
  (syntax-parse
   ts-ty-stx 
   #:literals (make-Base make-Result make-Union make-Value make-Values make-ValuesDots make-Vector)
   ; ty-stx : #'(#%app make-Base name contract)
   [(ap0 make-Base name contract)
    (begin0 (ctype-creator 'Base #'name)
            #;(printf "basetypee's name:~a -> ~a\n" #'name (ctype-creator 'Base #'name)))]

   ; Result -> Base-type name
   ;struct-result-stx : syntax obj of Result type. 
   [(ap0 make-Result t f o) 
    (begin #;(printf "result type: ~a\n" (syntax-e #'t))
           (ts-type->ctype-form #'t))]
   
   ; elems is list of types or null according to typed/racket
   [(ap0 make-Union elems) 
    #;(printf "union type's name:~a\n" (syntax-e #'elems))
    (ctype-creator 'Union #'elems)]
         
   ; direct conversion to ctype
   [(ap0 make-Value v) 
    (let ([_v (syntax-e #'v)])
      #;(printf "value type w/ v:~a\n" _v)
      (cond [(number? _v) _double] [(boolean? _v) _bool] [(null? _v) _void] [else #f]))]
   
   ;; output: list of ctypes of r's
   [(ap0 make-Values (ap1 lst2 r ...)) 
    (let ([len (length (syntax->list #'(r ...)))]
          [l-let-ctype (map ts-type->ctype-form (syntax->list #'(r ...)))])
      #;(printf "values-types:~a\n" l-let-ctype)
      l-let-ctype)]
   
   ;; output: list of ctypes of r's
   [(ap0 make-ValuesDots (ap1 lst2 r ... dty dbound)) 
    #;(printf "make-ValuesDots\n")
    (map ts-type->ctype-form (syntax->list #'(r ...)))]
   
   ; Vector elem:Type/c
   [(ap0 make-Vector elem)
    (begin
      #;(printf "ts-type->Ctype-form: Vector of ~a\n" #'elem)
      (ctype-creator 'Vector #'elem))]
   
   [_ (printf "***********else case of process-ts-type:~a\n" (syntax-e ts-ty-stx))]))
   
;; lst-ty is a list -> collection type with content type:      
;; In body, we add a lst-dim to represents internal structure of (<ctype:ptr> <ctype:elt-ty>)
;; ex) (<ctype:ptr> <ctype:float>) for 1 dimensional array. -> lst-dim = _uint32
;;                                     2                    ->         = size_type_2 : cstruct    
;; how to get 1d or 2d? check type of elt of lst-dim
(define (expand-type-dim lst-ty lst-dim #:dom? [dom? #t])
  (printf "lst-ty:~a, lst-dim:~a, dom?:~a\n" lst-ty lst-dim dom?)
  
  (let* ([lst-coll-ty 
          (map (λ (ty col-dim)
                 (printf "col-dim input:~a with ty:~a  and dom?:~a\t" col-dim ty dom?)
                 (let*([cty-out
                       (cond
                         [(size_type_2? col-dim) ;; catch <cpointer:size_type_2>
                          ; domain - insert Dimension Specifier (such as <uint32> in 1dim-array) after '(<pointer> <ctype>)
                          (if dom? _size_type_2
                              (list _pointer _size_type_2))]
                         
                         ; number->value input, cpointer->size_type for 1d - just cpointer
                         [(number? col-dim)
                          (if (zero? col-dim) 
                              (if dom? ty (list _pointer ty))
                              (if dom? _uint32 (list _pointer _uint32)))]
                         [(cpointer? col-dim) (if dom? _uint32 (list _pointer (cadr ty)))] 
                         [else (printf "col-dim:~a\n" col-dim) (error "col-dim is not recognized")])])
                   (printf "-------> coldim output:~a\n" cty-out)
                   cty-out))
               lst-ty lst-dim)])
    
    ;; format from TS signature form to Kernel argument form
    ;; if Arg collection then append dim-value after Arg
    (let* ([expanded-ty
            (let loop ([ol lst-ty][oct lst-coll-ty][nl '()])
              
              (printf "lst-colll-ty:~a, ol:~a, oct:~a\n" lst-coll-ty ol oct)
              (if (empty? ol) 
                  (begin (printf "expand-list w collec-ty:~a\nfrom: ~a\n" lst-coll-ty lst-ty)
                         (printf "to ~a\n" (reverse nl))
                         (reverse nl))
                  (let* ([elt (car ol)] [ct (car oct)] [odt (cdr ol)] [cdt (cdr oct)])
                    (printf "___elt:~a\n" elt)
                    (if dom?
                        (if (list? elt) ; elt is '(Vectorof Float) e.g.
                            (loop odt cdt (cons ct (cons elt nl)))
                            (loop odt cdt (cons elt nl)))
                        (if (list? elt)
                            (loop odt cdt (cons ct (cons elt nl)))
                            (loop odt cdt (cons ct nl)))))))]
           [expanded-dim
            (let loop ([ol lst-dim][nl '()])
              (if (empty? ol) 
                  (reverse nl)
                  (let* ([elt (car ol)])
                    (cond
                      [(number? elt)
                       (if (zero? elt)
                           (loop (cdr ol) (cons elt nl))
                           (loop (cdr ol) (cons 0 (cons elt nl))))]
                      [(size_type_2? elt)
                       (loop (cdr ol) (cons 0 (cons elt nl)))]))))])
      (printf "expand-type-dim: dim-in:~a, expanded-dim:~a\n" lst-dim expanded-dim)
      (values expanded-ty expanded-dim))))

;; input : '(cty ...).
;; if cty is not list, but just a simple ctype, return (_pointer cty).
#;(define (convert-to-pointer-type lst-cty)
  (map (λ (x) 
         (let* ([ty x])
           (if (list? ty) ty (list _pointer ty))))  ;(printf "ty as list:~a\n" ty) (printf "ty not list:~a\n" ty))))
       lst-cty))

;; type-sym : 'Function
;; lst-ty-stx : (dom rng) in which are defined as typed-scheme types. dom, rng are list of syntax obj's
;; Inputs : 1) Function l-dom-stx rng-stx
;;          2) Base ty-stx
(define (ctype-creator type-sym lst-ty-stx pair-dom-rng-dim)
  (printf "ctype-creator - lst-ty-stx:~a, pair-dom-rng-dim:~a\n" 
          lst-ty-stx pair-dom-rng-dim)
  (match type-sym
   ['Function
    (let* ([lt-dom (car lst-ty-stx)]
           [lt-rng (cadr lst-ty-stx)] ; either list - multi-value rng, or single value stx
           [lct-dom (map ts-type->ctype-form lt-dom)]
           [lct-rng (map ts-type->ctype-form lt-rng)]
           [ld-dom (car pair-dom-rng-dim)]
           [ld-rng (cadr pair-dom-rng-dim)]
           [v (printf "Lt-dom:~a, Lt-rng:~a\n" lt-dom lt-rng)]
           [v (printf "Lct-dom:~a, Lct-rng:~a\n" lct-dom lct-rng)]
           [v (printf "LD-dom:~a, LD-rng:~a\n" ld-dom ld-rng)])
      (let*-values
          ([(cdom d-dom) (expand-type-dim lct-dom ld-dom #:dom? #t)]
           [(crng d-rng) (expand-type-dim lct-rng ld-rng #:dom? #f)])
      (printf "ctype-creator-Function dom:~a, rng:~a\n" (map syntax->datum lt-dom) (map syntax->datum lt-rng))
      (printf "-> result dom:~a, rng:~a\n result dim d:~a, r:~a\n" cdom crng d-dom d-rng)
      (list type-sym (list cdom crng) (list d-dom d-rng))))]
   ['Base (list type-sym (ts-type->ctype-form (car lst-ty-stx)) 0)] ; Because Base type ty is single elt.
   [_
    (error "ctype-creator-Non-Function:Not supporte" lst-ty-stx)
    (list type-sym #f #f)])) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO add more types Vector, Union , etc.. Array eventually, but Values, ValuesDots necessary? no. (they are inside of function signature which is taken care of Function template.
(define (ctype-creator-deprecated type-sym type-args)
  (printf "ctype-creator-deprecated:~a, ~a\n" type-sym type-args)
  (match type-sym
; template in syntax-parse capture dom -> rng of function with arities.
; dom : list of types -> list of type (currently base types only)
; rng : values of Result
    ['Function
     (let ([arities (car type-args)])
       (syntax-parse 
        arities 
        #:literals (make-arr make-Values make-ValuesDots)
        [(~or 
          ; rng is Values
          (ap0 lst0 (ap1 make-arr 
                         (ap2 lst1 arg ...) 
                         (ap3 make-Values (ap4 lst2 rs ...))
                         rest drest kws))
          ; rng is ValuesDots
          (ap0 lst0 (ap1 make-arr 
                         (ap2 lst1 arg ...) 
                         (ap3 make-ValueDots (ap4 lst2 rs ... dty dbound))
                         rest drest kws)))
         (let* ([lst-cty-arg (map ts-type->ctype-form-deprecated (syntax->list #'(arg ...)))]
                [lst-cty-rsl (map ts-type->ctype-form-deprecated (syntax->list #'(rs ...)))])
           (printf "function ari: arg in:~a\n" (map syntax-e (syntax->list #'(arg ...))))
           (printf "function ari: arg out:~a\n" lst-cty-arg)
           (printf "function ari: values in :~a\n" (map syntax-e (syntax->list #'(rs ...))))
           (printf "function ari: values out:~a\n" lst-cty-rsl)
           (list lst-cty-arg lst-cty-rsl))]
        [_ #;(printf "**************function-arities->ctype-pair else case\n")
           (cons '() '())]))]
    ['Base
     (let ([name-stx (car type-args)])
       (printf "base-name->ctype input name:~a\n" name-stx)
       (syntax-case name-stx 
         (Boolean Symbol Void Bytes Regexp PRegexp Byte-Regexp Byte-PRegexp String
                  Keyword Char Thread Prompt-Tag Continuation-Mark-Set Path
                  Namespace Output-Port Input-Port TCP-Listener Flvector Number
                  InexactComplex Flonum Nonnegative-Flonum Exact-Rational Integer
                  Exact-Positive-Integer Positive-Fixnum Negative-Fixnum)
         [(quote Boolean) _bool]
         [(qoute Symbol) _byte]
         [(quote String) _string]
         [(quote Char) _byte]
         [(quote Path) _string]
         [(quote Number) _double]
         [(quote Flonum) _float]
         [(quote Nonnegative-Flonum) _float]
         [(quote Exact-Rational) _float]
         [(quote Integer) _int]
         [(quote Exact-Postive-Integer) _int]
         [(quote Positive-Fixnum) _fixnum]
         [(quote Negative-Fixnum) _fixnum]
         [_ #f]))]
    
    ;;; (Vectorof Type) -> (list _cpointer (ts-type->ctype elem))
    ['Vector
     (let ([elem-stx (car type-args)])
       (printf "vector-elem->Ctype w/tag:~a\n" (ts-type->ctype-form elem-stx))
       (let ([elt-ty (ts-type->ctype-form elem-stx)])
         (list _pointer elt-ty)))]
    
    ;;; Same as any type
    ['Union
     (let ([elems-stx (car type-args)])
       (printf "Union: elems stx:~a\n" (syntax->datum elems-stx))
       (kernel-syntax-case 
        elems-stx #t
;         #:declare cpce (id-from 'checked-procedure-check-and-extract 'racket/private/kw)
;         #:declare s-kp (id-from 'struct:keyword-procedure 'racket/private/kw)
;         #:declare kpe  (id-from 'keyword-procedure-extract 'racket/private/kw)
        [(let-values ([(name ...) expr] ...) . body)
         (let* ([app-expr (second (syntax->list #'(expr ...)))])
           #;(printf "-------------> ~a\n" app-expr)
           (kernel-syntax-case* 
            app-expr #t (list)
            [(ap0 list elt ...)
             (let* ([e (car (syntax->list #'(elt ...)))])
               (kernel-syntax-case
                e #t
                [(#%plain-app ty-maker . ty-arg)
                 #;(printf "make-type0 in Union caught:~a\n" #'ty-maker)
                 (ts-type->ctype-form e)]
                [_ (printf "make-Type00 failed:~a\n" e)]))]
            [_ (printf "make-Type0 failed\n")]))]
         [_ (printf "make-Type1 failed to be caught\n")]))]
                              
;         #;(kernel-syntax-case
;          (car (syntax->list #'body)) #t
;          [(#%plain-app
;            (#%plain-app cpce s-kp fn kpe kws num)      
;            kw-list
;            (#%plain-app list . kw-arg-list)
;            . pos-args)
;           
;           (printf "pros-args's let-values caught: ~a\n" (syntax->datum elems-stx))]
;            
;          [_ (printf "kernel-syntax-parse fail:~a\n" (car (syntax->list #'body)))])]
    [else (printf "***********ctype-creator's else case: stx:\n")]))
         
#|
http://docs.racket-lang.org/syntax/Modules_and_reusable_syntax_classes.html check error message:
syntax-parse: not defined as syntax class at: id-from in: (syntax-parse elems-stx #:literals () ((ap0 (ap1 cpce s-kp fn kpe kws num) kw-list (ap2 list . kw-arg-list) . pos-args) #:declare cpce (id-from (quote checked-procedure-check-and-extra
|#