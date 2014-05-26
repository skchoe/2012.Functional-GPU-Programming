#lang racket/base

(require syntax/module-reader syntax/parse syntax/context)
(require syntax/kerncase)
(require racket/list racket/match)
(require (for-syntax racket/base syntax/parse unstable/syntax))
(require ffi/unsafe)
(require (lib "typed-scheme/rep/type-rep.rkt"))

(require "ctype-gen.rkt"
         "../schcuda/cuda_h.ss"
         "../schcuda/scuda.ss"
         "../abscall/dim-rep.rkt")

(provide (all-defined-out))

(define-struct nm_ty_stx
  (name-stx type-stx)) ; name and type from expanded-file in (define-values () (begin (quote-syntax (:-internal name type) app-val)

;; ctypename: list? | ctype? where list? is the form (<pointer> ctypename)
;; loc : <ctype:XXX>
;; cnt : <uint32> number of element of the type
;; init? : #f only if the param is for output of kernel.
(define-struct cu-param
  (ctypename loc cnt init?))

(define (expanded-stx fn)
  (let* ([ip (open-input-file (string->path fn) #:mode 'text)]
         [stx-m (read-syntax fn ip)]
         [top-expanded (parameterize ([current-namespace (make-base-namespace)])
                         (expand stx-m))])
    ;(parse-stx stx-m) ;testing
    ;(parse-typed-racket fn ip) ;testing
    (printf "_______________________________________________________________________________\n")
    (printf "TOP expanded:\n~a\n" (syntax->datum top-expanded))
    (close-input-port ip)
    
    top-expanded))

; input form
; output: nm_ty_stx?
(define (dv-4-stx form)
  (syntax-parse
   form #:literals (define-values define-values-for-syntax void  begin quote-syntax)
   [(define-values () (begin (quote-syntax (intl nm ty)) app-val))
    (printf "nm:~a, ty:~a\n" (syntax->datum #'nm) (syntax->datum #'ty))
    (make-nm_ty_stx #'nm #'ty)]
   #;[(define-values (id ...) (values v ...))
    (printf "d-v - id:~a\n" #'(id ...))
    (printf "d-v - v0:~a\n" #'(v ...))
    #f]
   #;[(define-values-for-syntax null v)
    (printf "v1:~a\n" #'v)
    #f ; new-output
    #;(syntax-parse 
     #'v #:literals (begin)
     [(begin vv0 ...) 
      (let ([appform (car (syntax->list #'(vv0 ...)))])
        #;(printf "vv0:~a\nappform:~a\n" #'(vv0 ...) appform)
        (kernel-syntax-case*
         appform #f (register-type values)
         [(_ register-type qs app-form)
          (printf "register-type -- app-type......:~a\n" #'app-form)
          (list #'qs #'app-form) ; deprecated
          #f]
         [(_  values) 
          (printf "app-type-faile:~a\n" (syntax->datum appform))
          #f]))])]
   [_ #;(printf "Void:(~a ~a)\n" (syntax->datum #'app) (syntax->datum #'void))
             #f]))

;; nts is struct with (name:symbol, type: stx(list)? | stx?)
;; pair-dom-rng is a pair with (l-dom rng)
;; output (list id-stx ctype)
(define (nm_ty_stx->nm_ctype nts pair-dom-rng)
  
  ;; output 1) list of syntax(ty-name)
  ;;        2) syntax(ty-name)
  (define (filter-out-values ty-stx)
    (syntax-case ty-stx (values)
      [(values ty ...) (cdr (syntax->list ty-stx))] ; multi-valued -> list
      [_ (list ty-stx)])) ; single valued -> singleton list
        
  (if (not (nm_ty_stx? nts))
      (error "nm_ty_stx->nm_ctype input nts is not nm_ty_stx struct type\n")
      (begin
        (printf "nm_ty_stx->nm_ctype's nts elt - name:~a, type:~a\n" 
                (symbol? (syntax->datum (nm_ty_stx-name-stx nts)))
                (if (list? (syntax->datum (nm_ty_stx-type-stx nts)))
                    (syntax->datum (nm_ty_stx-type-stx nts))
                    #f))
        (let* ([nm-stx (nm_ty_stx-name-stx nts)]
               [ty-stx (nm_ty_stx-type-stx nts)]
               [ty-stx-lst (syntax->list ty-stx)]
               [ty-sym-lst (map (λ (x)
                                  (let ([dt (syntax->datum x)])
                                    (printf "~a is syntax?:~a\n" dt (syntax? x))
                                    dt))
                                ty-stx-lst)]
               [cty-dim
                (syntax-case ty-stx ()
                  [(ty ... arrow rng)
                   (printf "list of types:~a\n... tys:~a, arrow:~a rng:~a\n" 
                           (map syntax->datum ty-stx-lst) (map syntax->datum (syntax->list #'(ty ...))) 
                           (syntax->datum #'arrow) (syntax->datum #'rng))
                   (if (equal? (syntax->datum #'arrow) '->) 
                       (begin (printf "function type------------------------------------\n")
                              (ctype-creator 'Function 
                                             (list (syntax->list #'(ty ...)) (filter-out-values #'rng))   
                                             pair-dom-rng))
                       (begin (printf "non-function list --then what?\n") (error "cannot convert to ctype")))]
                  [ty
                   (printf "non-list tpye - maybe single value:~a\n" (syntax->datum #'ty))
                   (ctype-creator 'Base #'ty 'VAL)]
                  [_
                   (printf "else-case: ~a\n" (map syntax->datum ty-stx-lst))
                   (error "cannot convert to ctype")])])
          (printf "syntax?(~a), elt:~a \n" (syntax? ty-stx) ty-sym-lst)

          (cons (syntax->datum nm-stx) cty-dim)))))

(define (take-out-false pair)
  (if pair
      (let* ([qid (car pair)]
             [app (last pair)])
        #;(printf "take-out elt:~a, ~a\n" qid app)
        (and qid app))
      #f))

(define (qid-ctype->name qid-ctype)
  (let* ([name-sym (car qid-ctype)]
         [name-str (symbol->string name-sym)])
    #;(printf "(qid-ctype->name):name-str:~a\n" name-str)
    name-str))

;; ty is ctype
(define (compiler-sizeof-ctype ty)
  (define  (eqv-or? obj lst-comrand)
    (for/or ([cm (in-list lst-comrand)])
      (eqv? obj cm)))
  (let* ([out
          (cond
            [(eqv-or? ty (list _int32 _uint32 _int _uint)) (compiler-sizeof 'int)]
            [(eqv-or? ty (list _int8 _uint8)) (compiler-sizeof 'char)]
            [(eqv-or? ty (list _int16 _uint16)) (compiler-sizeof 'short)]
            [(eqv-or? ty (list _int64 _uint64)) (compiler-sizeof 'long)]
            [(eqv-or? ty (list _void)) (compiler-sizeof 'void)]
            [(eqv-or? ty (list _float)) (compiler-sizeof 'float)]
            [(eqv-or? ty (list _double)) (compiler-sizeof 'double)]
            [(eqv-or? ty (list _pointer)) (compiler-sizeof '*)]
            
            [(equal? ty _size_type_2) (ctype-sizeof _size_type_2)]
            [else (error "unknown type in compiler-sizeof-ctype")]
            )])
    #;(printf "+++++compiler-sizeof-ctpye of ~a:~a\n" ty out)
    out))
      
      
(define (print-type-dom-rng l-dom l-rng)
  ;; ___domain processing
  (printf "\ndom-rng-type(size) ---- dom: ~a\n" l-dom)
  (for-each 
   (lambda (arg) 
     (if (list? arg)  ; function case
         (begin
           (printf "collec(~a)____~a\n" (length arg) arg)
           (for-each (λ(x) (printf "size of (~a) :~a, ptr-align:~a\n" x (compiler-sizeof-ctype x) (ctype-alignof x))) arg))
         (begin
           (printf "single___~a\n" arg)
           (printf "size:~a\n" (compiler-sizeof-ctype arg)))))
   l-dom)
  ;; ___range processing
  (printf "\ndom-rng-type(size) ---- rng: ~a\n" l-rng)
  (for-each 
   (lambda (val) 
     (if (list? val) 
         (begin
           (printf "collec(~a)____~a\n" (length val) val) 
           (for-each (λ(x) (printf "size of (~a):~a, ptr-align:~a\n" x (compiler-sizeof-ctype x) (ctype-alignof x))) val))
         (begin
           (printf "single___~a\n" val)
           (printf "size:~a\n" (compiler-sizeof-ctype val)))))
   l-rng))


(define (data-length val)
  (letrec ([array? (lambda (x) #f)]
           [array-length (lambda (x) 1)]) ; temporary definition of array predicate.
    (cond
      [(list? val) (last val)] ; because val=(_ptr length).
      [(vector? val) (vector-length val)]
      [(array? val) (array-length val)]
      [else 1])))


  
;; alloc copy set for basic type including pointer type'(_pointer _elt-type) in ty
;; -> offset by align-up from ty
;; -> paramset(i,f,v) w/ align offset (w/ v size in byte)
;; -> return cu-param : ty <-cp, loc <-(cuMalloc), cnt <-cp, init? <-cp.
(define (galloc-copy-set-arg hfunc offset cp)
  
  ;; all cases that needs to use (cuParamsetv) - collection type and struct type calls this:
  (define (ptr-alloc-cpy-offset cp offset-in)
    (let*-values
        ([(ctn) (cu-param-ctypename cp)]
         [(h_loc) (cu-param-loc cp)]
         [(cnt) (cu-param-cnt cp)]
         [(init?) (cu-param-init? cp)]
         
         [(v) (print-cu-param cp)]
         
         [(sizeof-ptr) (compiler-sizeof '*)])
      (printf "___________________________\n")
      (print-cu-param cp)
      
      ;; collection type -> ctn:list?
      ;; struct type -> ctn:non-list, ctn _size_type_2
      ;; both case: alignment is alignof-ptr
      (let*-values
          ([(mem_size) (size_type->mem_size 
                        (cond [(list? ctn) (cadr ctn)]
                              [(equal? ctn _size_type_2) _size_type_2]
                              [else (error "ptr-alloc-cpy: Error")])
                        cnt)]
           [(result_ parray) (cuMemAlloc mem_size)]
           [(result_k d_parray_arg_new)
            (begin
              (printf "Result of cuMemAlloc:~a w/ size:~a x ~a, parray:~a\n" 
                      result_ (compiler-sizeof-ctype (cond [(list? ctn) (cadr ctn)]
                              [(equal? ctn _size_type_2) _size_type_2]
                              [else (error "ptr-alloc-cpy: Error")]))
                      (size_type_2_len->count cnt) parray)
              (if init? ; input/output distinction
                  ;; in output allocation there's no memcpy called
                  (cuMemcpyHtoD parray h_loc mem_size)
                  (values 'NO_COMP parray)))]
           
           ;; parameter passing is _pointer form because they are 1d based collection or struct
           [(alignof-ptr) (ctype-alignof _pointer)]
           [(offset_t) 
            (begin
              (printf "Result of cpyHtoD:~a\n" result_k)
              (align-up offset-in alignof-ptr))]
           [(result_i hfunc) 
            (cuParamSetv hfunc offset_t d_parray_arg_new sizeof-ptr)]
           [(offset_o) (begin
                         (printf "Result of ParamSetv:~a\n" result_i)
                         (+ offset_t sizeof-ptr))])
        (printf "**************cuParamSetv: offset(in/used):~a/~a, location in gpu:~a=~a\n" offset offset_t parray d_parray_arg_new)
        (values offset_o result_i d_parray_arg_new))))
  
  (let* ([ctn (cu-param-ctypename cp)]
         [loc (cu-param-loc cp)]
         [cnt (cu-param-cnt cp)]
         [init? (cu-param-init? cp)])
    (printf "cu-param ty:~a, loc:~a, cnt:~a->~a, init?:~a\n" ctn loc cnt (size_type_2_len->count cnt) init?)
    (cond
      ;; ctn is pair      '(_pointer _ctype)
      ;;     or _ctype -> the second cond.
      ;; v = '(ptr size_type) in input => v is a collection type input
      ;; v =  in output      => v is a (collection or base) type output
      [(pair? ctn)
       (let*-values
           ([(offset_o result_i d_parray_arg_new) 
             (ptr-alloc-cpy-offset cp offset)])
         (values offset_o result_i 
                 (make-cu-param 
                  ctn d_parray_arg_new cnt init?)))]
      
      ;; ctypename is not pair: not collection type
      ;; input scalar or struct
      ;; loc := value: is base type if base-type => paramSet(i,f)
      ;;        struct: (cuParamSetv) with alloc, copy.
      [else 
       (printf "ctypename is not pair, input scalar loc = value or pointer, ctn base type or struct:~a\n" ctn)
       (printf "align of ~a : ~a, layout:~a\n" ctn (ctype-alignof ctn) (ctype->layout ctn))
       (let* ([layout (ctype->layout ctn)]) 
         (if (list? layout) ;; list-layout -> struct for now
             (let*-values
                 ([(offset_o result_i d_parray_arg_new) 
                   (ptr-alloc-cpy-offset cp offset)])
               (printf "ty-list (struct) type -> pointer group:~a\n" ctn)
               (values offset_o result_i 
                       (make-cu-param 
                        ctn d_parray_arg_new cnt init?)))
             ;; else non-list layout -> simple types
             (let*-values 
                 ([(offset_t) (align-up offset (ctype-alignof ctn))]
                  [(result_f hfunc)
                   (case layout 
                     ['int32 
                      (printf "ty-simple type in integer group:~a\n" ctn)
                      (cuParamSeti hfunc offset_t loc)]
                     ['uint32 
                      (printf "ty-simple type in integer group:~a\n" ctn)
                      (cuParamSeti hfunc offset_t loc)]
                     ['uint64 
                      (printf "ty-simple type in integer group:~a\n" ctn)
                      (cuParamSeti hfunc offset_t loc)]
                     ['float 
                      (printf "ty-simple type in float group:~a\n" ctn)
                      (cuParamSetf hfunc offset_t loc)]
                     [('int8 'uint8 'int16 'uint16 'int32 'uint32 'int64 'uint64)
                      (printf "ty-simple type in integer group:~a\n" ctn)
                      (cuParamSeti hfunc offset_t loc)]
                     [('float 'double) 
                      (printf "ty-simple type in float group:~a\n" ctn)
                      (cuParamSetf hfunc offset_t loc)]
                     [else
                      (begin
                        (printf  "---g-alloc-copy-set-arg! failed to check type of parameter:~a: eqchk(~a) ~a\n"
                               layout (equal? (ctype->layout ctn) 'uint32) loc)
                        (values 1 'CUDA_ERROR_UNKNOWN))])])
         
               (printf "************cuParamSet(i,f):ParamSetResult:~a, single_in offset_t(in/used):~a/~a, value:~a\n" 
                       result_f offset offset_t loc)
               (values (+ offset_t (compiler-sizeof-ctype ctn)) result_f #f))))])))

       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l-cu-param : cu-param?
(define (kernel-launcher lst-gpu-info kernel-name hfunc l-cu-param)
  
  (printf "kernel-launcher begins w/ l-cu-param:~a\n" l-cu-param)
  (unless (empty? l-cu-param)
    
    ;; gpu structure setup
    ;; 1. allocation input/output collections and values
    (let*-values 
        ([(blk-x blk-y blk-z)
          (values (list-ref lst-gpu-info 6) (list-ref lst-gpu-info 7) (list-ref lst-gpu-info 8))]
         
         [(grid-x grid-y) (values (list-ref lst-gpu-info 9) (list-ref lst-gpu-info 10))]

         ;; (galloc-copy-set-arg) calls ffi for CUDA-api's.
         [(offset_in result_in l-out-gcp)
          (for/fold ([offset 0]
                     [cu-result 'CUDA_ERROR_UNKNOWN]
                     [l-gout-cu-param '()])
            ([i (in-range (length l-cu-param))])
            (let* ([cp (list-ref l-cu-param i)])
              
              ;; (in-ty in-val) pair has following cases:
              ;; ((_pointer _cbasetype) (cpointer length) - colection input as a pointer
              ;; (_cbasetype value)                       - base type input
              (let*-values
                  ([(offset-new cu-result-new new-cu-param)
                    (galloc-copy-set-arg hfunc offset cp)])
                #;(printf "End (~a) offset(od/nw):~a/~a, cu-result:~a\n\n" 
                          (if (cu-param-init? cp) "IN" "OUT") offset offset-new cu-result-new)
                (values offset-new cu-result-new 
                        (if (cu-param-init? cp) ;; init? field shows if cp is for output or input.
                            l-gout-cu-param ;; if output then just pass given gptrs
                            (append l-gout-cu-param (list new-cu-param)) ;; if output=#f store the ptr to l-out-gcp.
                            )))))] ; list of output ptr is null   ---(1)
         
         #;[(v) (begin (printf "CU_PRM after cuParamSet:\n")
                     (for-each (λ (x) (print-cu-param x)) l-out-gcp))]
         
         [(result_n hfunc) (cuParamSetSize hfunc offset_in)]
         
         ;; block shape - currently single thread is doing the copy
         ;[(result_b hfunc) (cuFuncSetBlockShape hfunc blk-x blk-y blk-z)]
         [(result_b hfunc) (cuFuncSetBlockShape hfunc 1 1 1)]
         
         ;; launch the kernel
         ;[(result_o) (cuLaunchGrid hfunc grid-x grid-y)]
         [(result_o) (cuLaunchGrid hfunc 1 1)]
         #;[(v) (begin
                (printf "Result of Launch:~a\n" result_o)
                
                ;; receive output value to host, w/ types, gpu-ptr, length
                (printf "Result of Block shp:~a-b\n" result_b)
                (printf "Result SetParamSize:~a\n" result_n)
                (printf "B4-Calloc, offset_in:~a, l-out-gcp:~a\n" offset_in l-out-gcp))])

      ;; receive output value from gpu to host
      ;; l-rng-ty : list of ctypes: '(<pointer> ctype>)
      ;; l-out-ptr-N : list of list of out-gptr and length of data in range(out)
      ;; so (map car l-out-ptr-N) :  list of pointers allocated before launching kernel.
      ;; output: list of result w/ length. '('(ptr1 N1) '(ptr2 N2) ...) compatible to l-out-ptr
      
      (map  (lambda (cp)
              (let* ([ty (cu-param-ctypename cp)]
                     [ptr (cu-param-loc cp)]
                     [len (cu-param-cnt cp)]
                     [init? (cu-param-init? cp)]) 
                (let*-values
                    ([(memst_size) (size_type->mem_size (cadr ty) len)]
                     [(h_memst) (malloc memst_size)]
                     [(result_p h_memst_new) (cuMemcpyDtoH h_memst ptr memst_size)]
                     [(result_q) (cuMemFree ptr)])
                  (printf "REesult of ptr:~a, ty:~a, memsize:~ax~a, val:~a, memcpy:~a, degalloc:~a\n" 
                          ptr ty (compiler-sizeof-ctype (cadr ty)) (size_type_2_len->count len) (ptr-ref h_memst_new _float 0)
                          result_p result_q)
                  (make-cu-param ty h_memst_new len init?))))
            l-out-gcp))))

;(define (sublist pred? lst)
;  (let* ([len (length lst)])
;    (for/list ([elt lst]
;               [i (in-range len)]
;               #:when (pred? i))
;      (list-ref lst i))))
;
;(define (sublist-even lst)
;  (sublist even? lst))
;(define (sublist-odd lst)
;  (sublist odd? lst))

(define (size_type_2_len->count len)
  (cond 
    [(number? len) (if (zero? len) 1 len)]; simple value w/ basic type
    [(size_type_2? len) (* (size_type_2-w len) (size_type_2-h len))]
    [else (error "Cannot compute memsize with given size_type")]))

(define (size_type->mem_size cty cnt)
  (let* ([tysize (compiler-sizeof-ctype cty)]
         [cot (size_type_2_len->count cnt)])
    (* tysize cot)))

(define (size_type_2->1d-list arr cty st2)
  (let* ([w (size_type_2-w st2)]
         [h (size_type_2-h st2)]
         [rl (for*/fold ([ol '()])
               ([j (in-range h)] [i (in-range w)])
               (let* ([idx (+ i (* j w))])
                 (cons (ptr-ref arr cty idx) ol)))])
    (reverse rl)))

(define (cptr->list arr cty len)
  (let loop ([lst '()][idx 0])
    (printf "cptr->list ---- lst:~a, idx:~a, ty:~a\n" lst idx cty)
    (if (equal? len idx)
        (reverse lst)
        (loop (cons (ptr-ref arr _float idx) lst) (add1 idx)))))

;; loc is <pointer> if cp is for host value
;; loc is uint32 if cp is for device value
(define (print-cu-param cp)
  (let* ([ty (cu-param-ctypename cp)]
         [loc (cu-param-loc cp)]
         [cnt (cu-param-cnt cp)]  ; for now cnt is scalar or size_type_2
         [init? (cu-param-init? cp)]
         
         [t0 (if (list? ty) (car ty) ty)]
         [t1 (if (list? ty) (cadr ty) #f)]
         [v (printf "print-cuparam:~a ~a ~a ~a\n" ty loc cnt init?)]
         [v0 (if (cpointer? loc)
                 (if (list? ty); collection? or output-struct
                     (cond
                       [(size_type_2? cnt) (size_type_2->1d-list loc t1 cnt)]
                       [(number? cnt) (cptr->list loc t1 cnt)]
                       [else (error "print-cu-param: other dimension type")])
                     (if (equal? ty _size_type_2)
                         (list (size_type_2-w loc) (size_type_2-h loc))
                         (error "ERROR:print-cu-param : ty is not list, loc is cpointer")))
                 loc)]) ; just value

    (printf "CU-PARAM: \tty:~a(~a, ~a), \tloc:~a(~a), length of v0: ~a, \tcnt:~a, \tinit?:~a\n"
            ty t0 t1 loc v0 (if (list? v0) (length v0) -1) cnt init?)))

;; (define (kernel-launcher xx yy . l-in) zz) here l-in is list of input data in functional
;; procedure. 
;; If x \in l-in, x can be either 
;; value, if x is just a simple value including struct (broadly non-collection form), 
;; or
;; list of cpointer of a collection object and size-value. The size value structure is depends on collection object.
;; currently the collection includes only cvector form in Racket.

;; type of x is taken care of domain part of function type from kernel-name by getting the type from expanded form
(define (kernel-launcher* lst-gpu-info kernel-name hfunc suda-path cubin-path l-out . l-in)

  (let ([stx (expanded-stx suda-path)])
    (printf"_____________________________________________________________________\n")
    (syntax-parse 
     stx #:literals (module)
     [(module id lng mb)
      ;(printf "id:~a\nlng:~a\n" #'id #'lng)
      (syntax-parse 
       #'mb #:literals ()
       [(mmbb form ...)
        (for-each (λ (x) (printf "input - forms:\n~a\n" (syntax->datum x))) (syntax->list #'(form ...)))
        (let* ([lst-form (syntax->list #'(form ...))]
               [lst-nm_ty_stx (filter (λ (x) (nm_ty_stx? x)) (map dv-4-stx lst-form))])
          
          (unless (equal? 1 (length lst-nm_ty_stx))
            (error "#of kernel is not single - exit"))
          
          ;; take one element from lst-nm_ty_stx
          (let* ([nts (car lst-nm_ty_stx)]
                 [doms-dim (map (λ (x) (if (list? x) (last x) 0)) l-in)]
                 [rngs-dim (map (λ (x) (if (list? x) (last x) 0)) l-out)]
                 [pair-dom-rng (list doms-dim rngs-dim)]
                 
                 #;[vv (printf "nts ---(name):~a, (type):~a\n" 
                             (syntax->datum (nm_ty_stx-name-stx nts))
                             (syntax->datum (nm_ty_stx-type-stx nts)))]
                 [vv0 (printf "inputs, l-in:~a, l-out:~a\n" l-in l-out)]
                 [vvv (printf "l-doms-rngs: doms-dim:~a, rngs-dim:~a\n" doms-dim rngs-dim)]
                 [qid-ctype (nm_ty_stx->nm_ctype nts pair-dom-rng)]
                 
                 [name-sym (qid-ctype->name qid-ctype)]
                 [function? (cadr qid-ctype)]
                 [l-dom-ty (car (second (cdr qid-ctype)))]
                 [l-rng-ty (cadr (second (cdr qid-ctype)))]
                 
                 [l-dom-dim (car (third (cdr qid-ctype)))]
                 [l-rng-dim (cadr (third (cdr qid-ctype)))]
                 
                 [fl-in (flatten l-in)]
                 [fl-out (flatten l-out)]
                 [v (printf "l-dom-ty------:~a, l-fin :~a(~a), lddim:~a\n" l-dom-ty fl-in (ptr-ref (car fl-in) _float 0) l-dom-dim)]
                 [v (printf "l-rng-ty------:~a, l-fout:~a, lrdim:~a\n" l-rng-ty fl-out l-rng-dim)]
                 
                 #;[size-giver 
                    (lambda (l-ty l-val-expanded)
                    (printf "size:giver \nl-ty:~a \nl-val-expanded:~a\n" l-ty l-val-expanded)
                    (reverse 
                     (for/fold ([ol '()])
                       ([i (in-range (length l-ty))])
                       (let* ([elt (list-ref l-ty i)])
                         (if (list? elt) ;; pointer type
                             (if (equal? _size_type_2 (last elt)) ;; size-token -> length 1.
                                 (begin (printf "________return size:1:~a\n" (last elt))
                                        (cons 1 ol))
                                 (let* ([size-val (list-ref l-val-expanded (+ 1 i))])
                                   (printf "********sizeof elt:~a, is:~a\n" elt size-val)
                                   (cons size-val ol)))
                             (begin
                               (printf "size recognizer for ~a:~a\n" elt 0)
                               (cons 0 ol)))))))]
                 #;[l-input-size (size-giver l-dom-ty fl-in)]
                 #;[l-output-size (size-giver l-rng-ty fl-out)]
                 
                 [l-cty (append l-dom-ty l-rng-ty)]
                 [l-loc (append fl-in fl-out)]
                 [l-count (append l-dom-dim l-rng-dim)]
                 [l-init (append (build-list (length l-dom-dim) (λ (x) #t))
                                 (build-list (length l-rng-dim) (λ (x) #f)))]
                 
                 [vvv (printf "\nl-cty:~a\n" l-cty)]
                 [www (printf "l-loc:~a\n" l-loc)]
                 [www (printf "l-count:~a\n" l-count)]
                 [vvv (printf "l-init:~a\n" l-init)]
                 
                 [l-cu-param (map make-cu-param
                                  l-cty l-loc l-count l-init)])

            (for-each print-cu-param l-cu-param)
            (printf "__________qid-ctype________\n")
            (printf "Ftn-name: ~a\n" name-sym)
            (printf "Elt type: ~a\n" function?)
            (printf "Ftn-dom:~a\n" l-dom-ty)
            (printf "Ftn-rng:~a\n" l-rng-ty)
            
            (printf "l-dom-dim:~a\n" l-dom-dim)
            (printf "l-rng-dim:~a\n" l-rng-dim)
            (printf "l-in:~a\n" l-in)
            (printf "l-out-ptr:~a\n" l-out)

            (let* ([name (qid-ctype->name qid-ctype)]
                   [kernel-type (last qid-ctype)])
              (printf "qid-ctype matching:~a and  ~a\n" name kernel-type) ; kernel type is ('Function ty) where ty=(dom rng)
              (kernel-launcher lst-gpu-info name hfunc l-cu-param))))]
       [_ (error "Not accepted Module-begin form")])]
      [_ (error "Not accepted Module form ex: #lang ...")])))