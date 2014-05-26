#lang suda


(define: A : Float 1.0)
;(define-type-alias All-Number (U Fixnum Integer Number Exact-Positive-Integer Exact-Nonnegative-Integer))

(require/typed racket/base 
               [build-list (Number (Number -> Any) -> (Listof Number))]
               [map ((Float -> Float) (Listof Float) -> (Listof Float))]
               [apply (((Listof Float) -> Float) (Listof Float) -> Float)]
               [add1 (Float -> Float)])

   
(: id (Float -> Float))
(define (id x) x)

(: exlst (Vectorof Integer))
(define exlst (vector 1 2 3 4 5))

(: return_2_val (-> (values Integer Float)))
(define (return_2_val) 
  (values 1 1.0))

;;; void test_map (float* in, int Ni, float* out, int* No)
;;{ int n=N;int i; for(i=0;i<N;i++) out[i] = add1(in[i]);return; }
;(: test_map ((Listof Float) -> (Listof Float)))
;(define (test_map lst)
;  (map id lst))

(: test_apply (Float -> Float))
(define (test_apply expr)
  (add1 expr))

;(test_map (list 1.2 2.3))

;(: cpyTestDrv_kernel ((Listof Float) Integer Integer Integer -> (values (Listof Float) (Listof Integer) Integer)))
;(define (cpyTestDrv_kernel l_fin num num-out iin)
;  (values (map (lambda: ([x : All-Number]) (+ 200.200 x)) l_fin) (list 11 21 31) (+ 10000 iin)))

(define: ex : Integer
  123)
(define: (ey [a : Exact-Positive-Integer]) : Exact-Positive-Integer
  (+ 1 a))

(ey 1)
#|
(require/typed version/check
               [check-version (Void -> (U Symbol (Listof Any)))])
;(printf "Version = ~s\n" (check-version)) 
|#
;typedef struct { ... } Array;
;(require/opaque-type Array
;                     array?
;                     "../typed-srfi-25.ss")
;
;(provide: [blocksize Integer])

;(require/typed "../scm2c-untyped/pract/typed-scheme-pract.scm" 
;               [hundred Number]
;               [back Number]
;               [add-proc (Number -> Number)])

; void ftn test
; void void_ftn (int arg, int arg2) {
;   arg = 1;  
;   return;
; }


; int blocksize = 10;
(define: blocksize : Integer 10)

(define: blocksize2 : Integer 100)

;
;int sigle_value2 (int n, int m) {
;  int single_value2_n = n;
;  int single_value2_m = m;
;  return single_value2_m;
;  }
(define: (single-value1 (n : Exact-Positive-Integer)) : Exact-Positive-Integer
  (+ n 1))

(single-value1 32)

(define: (single-value2 (n : Integer) (m : Integer)) : Integer
  n
  m)

(single-value2 2 3)

(define: (single-value (n : Integer)) : Integer
  n)

; Dont support multi-valued proc 07/13/10.- starts to support 9/21/19
; how to define ftn: -> (values v ...)
;(#%app * -1 n) -> -1 * n;
;
(define: (multi-value (n : Integer)) : (values Integer Integer)
  (values n (* -1 n)))



; void void_ftn (int arg, int arg2) 
;{ arg = blocksize; };
(define: (void-ftn! (arg : Integer) (arg2 : Boolean)) : Void
  (set! arg blocksize))


(define: (negate (a : Boolean)) : Boolean
  (not a))

(define: (change-sign (n : Number)) : Number
  (* -1 n))

;; keyword typed-function howto? - current typed racket doesn't support keyword arg.
;(define: (func-kw [x : Any] [#:y y : Any] [#:z [z 10] : Any]) : (Listof Any)
;    (list x y z))

;; Things are not supported : 'apply - takes function as argument - later with map, fold
;(define: (lst-sum [lst : (Listof Number)]) : Number
;  (apply + 1 2 3 lst))
;
;(define: (sum [a : All-Number] [b : All-Number]) : All-Number
;  (apply + a b '()))
;(sum 1 2)

;typedef struct Date {
; int* day;
; char* month;
; int* year;
;} Date;
;make_Date (Date dt, int* d, char* m, int* y) {
;  dt.day = d; 
;  dt.month = m;
;  dt.year = y;
;  };

;Date* dt = (Date*)malloc(sizeof(Date));
;int* d = (int*)malloc(sizeof(int));
;int size = length(-pre-def'd string);
;char* m = (char*)malloc(sizeof(char)*size)
;int* y = (int*)malloc(sizeof(int));
;make_Date(dt, d, m, y);

;(define da (Date-day dt))
;-> int* da = dt->day;
;(define dm (Date-month dt))
;-> int* dm = dt->month;

;int* Date_day(Date* dt) {
; int* dtXX = dt->day;
; return dtXX;
(define-struct: Date ([day : Number] [month : String] [year : Number]))


; char* format_date (Date d) {
;  int dt = d.day;
;  char* 
;  format ("Today is day ~a of ~a in the year ~a"
; scheme function: -> int a = sprintf(dest, format, args);   > use dest..
#|
(: format-date (Date -> String))
(define (format-date d)
  (format "Today is day ~a of ~a in the year ~a"
          (Date-day d) (Date-month d) (Date-year d)))
;|#
;;; (define d make_Date(28 "November" 2008))
;;; Date* d = (Date*)malloc(sizeof(Date))
;;;       d.day = 28;
;(define d (make-Date 28 "November" 2008))
;;
;
;
;; int threadsize = blocksize;
;(define: threadsize : Integer blocksize)
;  
;; int x = 100;
;(define: x : Integer 100)
;; int y = add1(x);
;(define: y : Integer x)
;
;; int myadd(int x) {
;;   int z = add1(x);
;;   return z;
;; }
;(define: myadd : (Integer -> Integer)
;  (lambda: ([x : Integer])
;           x))
;
;
;
;;; From CuDA3.1, function pointer is supported. Recursive call will be handled at that point.
;;; int fac (int x) {
;;;   if (x <= 1)
;;;     fac ((x-1));
;;;   else return 1;
;;; }
;;
;;(define: fac : (Integer -> Integer)
;;  (lambda: ([x : Integer]) (if (<= 1 x) 
;;                   (fac (- x 1))
;;                   1)))
;;
;;; From Cuda3.1 print function in kernel code is possible.
;;; void x() {
;;;   printf("val = %d\n" 100);
;;; }
;;(define: (x!) : Void
;;  (printf "val = ~s\n" 100))
;;
;
;; int a = 300;
;(define: a : Integer 300)
;
;(define: bf : Boolean #f)
;(define: bt : Boolean #t)
;
;;;; toplevel-if - suda doesn't allow toplevel expression
;;(if (< a 200)
;;   (+ 1 1) (* 2 2))
;
;;; if as inner expr.
;(define: (bigger? [x : Integer]) : String
;  (if (< x 200) "A" "B"))
;
;; int lam (int x, int y) {
;;   z = x + y;
;;   return z;
;(define: (lamb (x : All-Number) (y : All-Number)) : All-Number (+ x y))
;
;; int lamb1 (x) {
;;   return 388;
;; }
;(define: lamb1 : (Integer -> Integer)
;  (lambda (x) 388))
;
;; int lamb2 (int x, int y) {
;;   int z = x + y;
;;   return z;
;; }
;(define: lamb2 : (All-Number All-Number -> All-Number)
;  (lambda (x y) (+ x y)))
;
;; int* r;
;; void lamb3(int x, int y, int* r) {
;;   // check size of resulting list
;;   r = (int*)malloc(sizeof(int) * size);
;;   r[0] = x;
;;   r[1] = y;
;;   return;
;; }
;; -> this doesn't work in CUDA code because it doesn't support dynamic memory allocation in kernel code
;; -> instead we alloc it from caller of kernel, send pointer to the kernel, kernel fill the storage.
;; The code should be 
;; void lamb3(int x, int y, int* r) {
;;   r[0] = x;
;;   r[1] = y;
;;   return;
;;}
;; In acutal Typed-scheme code, list-creation expression = '(list x ...) .........................................
;(define: lamb3 : (Integer Integer -> (Listof Integer))
;  (lambda: ([x : Integer] [y : Integer]) (list x y)))
;
;(define: lamb4 : (Integer Integer -> (Listof Symbol))
;  (lambda: ([x : Integer][value : Integer])
;           (cons 'b (list 'a))))
;
;; typedef union { int
;(define-type-alias IntVariants (U Integer (Integer -> Integer)))
;
;
;(define: adding : Integer 
;  (add1 20))
;
;(define: aading : Integer
;  (add1 (add1 19)))
;
;(define: (minus1 (a : Number)) : Number
;  (- a 1))

#|
;(: new-or! (Boolean -> Void))
(define: (new-or! (a : Boolean)) : Void
  (if (or a (change2neg a))
      (printf "input is larger than 1\n")
      (printf "input is smaller than 1\n")))
  
;(define: (new-or! (a : (U Boolean Integer))) : Void
;  (if (or a (- a 1))
;      (printf "input is larger than 1\n")
;      (printf "input is smaller than 1\n")))

;(: return-or ((U Integer Boolean) -> Boolean))
; Need skip because C, Cu doesn't support polymorphism
;(define: (return-or (b : (U Integer Boolean))) : Boolean
;  (or (integer? b) (string? b)))

(define: (compute-main (arg0 : Number) 
                       (arg1 : Number)
                       (arg2 : Number)) : Number
  (+ arg0 (+ arg1 (add1 arg2))))

(compute-main 13 56 67)
(begin (compute-main 1 2 3)
       (compute-main 2 3 4))

(define: (kernel) : Number
  (let ([arg0 1.0000]
        [arg1 2999999.999]
        [arg2 39999999.9999999999])
    
    (compute-main arg0 arg1 arg2)))

;(: test-cond (Integer -> Integer))
(define: test-cond : (Integer -> Integer)
  (cond
    [(string? "abc") (lambda (x) (+ 1 x))]
    [else (lambda (y) (+ 2 y))]))

(define: minus : (Integer -> Integer)
  (lambda (x) (- x 1)))

;(: cond-type IntVariants)
(define: cond-type : IntVariants
  (cond 
    [(integer? 1) 1]
    [(string? "a") minus]
    [else 1]))

(define: test-cond1 : (Integer -> Integer)
  (cond
    [(string? "abc") (lambda (x) (+ 1 x))]
    [else (lambda (y) (+ 2 y))]))

(define: cond-type1 : IntVariants
  (cond 
    [(integer? 1) 1]
    [(string? "a") minus]
    [else 1]))

;(: cond-func (U Integer String (Integer -> Integer)))
(define: cond-func : (U Integer String (Integer -> Integer))
  (let ([abc 1])
    (cond 
      [(integer? 3) 3]
      [(string? "abc") abc]
      [(number? 3) minus]
      [else "123"])))

;(: case-func! ((U Integer Char)
;               -> Void))
(define: (case-func! (c : (U Integer Char))) : Void
  (case c
    [(#\c #\d #\e) (printf "string \n")]
    [(1 2 3) (printf "integer\n")]
    [else (printf "not string\n")]))

;(: case-func! ((U Integer Char)
;               -> Void))
(define: (case-func2! (c : (U Integer Char))) : (U Integer Char (List Integer) Void)
  (case c
    [(#\c #\d #\e) (begin (printf "string \n") #\c)]
    [(1 2 3) (begin (printf "integer\n") 1)]
    [else (printf "not string\n")]))

;(: case-func! ((Void) -> (U Integer Char))
(define: (case-func3!) : (U Integer Char)
  (let* ([c 1])
    (case c
      [(equal? 'a 'a) #\o]
      [else 0])))

;(define: cs1 : Char-Set (char-set #\a #\b #\c))
;(define cs2 (char-set-adjoin! cs1 #\d))
;(printf "cs : ~s\n" cs2)
;(define arr (make-array (shape 0 100) 0))

(define: (two-args [arg1 : Number]
                   [arg2 : Number]) : Number
  (+ arg1 arg2))


(define: (begin-test [str : String]) : Boolean
  (begin (printf "BEGin-test: ~s\n" str)
         #t))
(define: (begin0-test [str : String]) : Boolean
  (begin0 #f
         (printf "BEGin-test: ~s\n" str)))
  
(define: multi-ftn : (case-lambda (-> Integer) (Any -> Any) (Any Any -> (List Any Any)))
  (case-lambda:
    [() 0]
    [([x : Any]) x]
    [([x : Any] [y : Any]) (list y x)]))

(multi-ftn)
(multi-ftn 1)
(multi-ftn 'a 'b)

;(: main : (Integer String -> Integer))
(define: (main [argc : Integer]
               [argv : String]) : Integer
  (case-func! #\c)
  (case-func! 4)
  (kernel)
  (new-or! (< 1 2))
  0)

|#
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;RESULT of expansion
(#%plain-module-begin 
 (#%require typed-scheme) 
 (define-values (cnt) '#f) 
 (define-values () (begin (quote-syntax (require/typed-internal check-version (-> (U Symbol (Listof Any))))) (#%plain-app values))) 
 (#%require (just-meta 0 (rename version/check check-version check-version)) (only version/check)) 
 (define-values (check-version) (#%app contract/proc cnt check-version '(interface for check-version) 'never-happen (quote-syntax check-version))) 
 (define-values (pred-cnt) 
   (#%app build--> '-> (#%app list any/c) '#f (#%app list boolean?) (#%app list) '() '#f (lambda (chk any/c6 boolean?7) (#%expression (lambda (val) (#%app chk val) (lambda (any/c5) (#%app boolean?7 (#%app val (#%app any/c6 any/c5))))))))) 
 (define-values () (begin (quote-syntax (require/typed-internal array? (Any -> Boolean : (Opaque array?)))) (#%plain-app values))) 
 (define-syntaxes (Array) (lambda (stx) (#%app raise-syntax-error 'type-check '"type name used out of context" stx))) 
 (define-values () (begin (quote-syntax (define-type-alias-internal Array (Opaque array?))) (#%plain-app values))) 
 (#%require (just-meta 0 (rename "../typed-srfi-25.ss" array? array?)) (only "../typed-srfi-25.ss")) 
 (define-values (array?) (#%app contract/proc pred-cnt (begin (#%app contract/proc array?30 array?30 '(definition array?30) temp79 (#%app list (#%app make-srcloc array?30 '#f '#f '#f '0) '"array?30"))) '(interface for array?) 'never-happen (quote-syntax array?))) 
 (define-values (cnt) '#f) 
 (define-values () (begin (quote-syntax (require/typed-internal hundred Number)) (#%plain-app values))) 
 (#%require (just-meta 0 (rename "../scm2c-untyped/pract/typed-scheme-pract.scm" hundred hundred)) (only "../scm2c-untyped/pract/typed-scheme-pract.scm")) 
 (define-values (hundred) (#%app contract/proc cnt (begin (#%app contract/proc hundred11 hundred11 '(definition hundred11) temp18 (#%app list (#%app make-srcloc hundred11 '#f '#f '#f '0) '"hundred11"))) '(interface for hundred) 'never-happen (quote-syntax hundred))) 
 (define-values (cnt) '#f) 
 (define-values () (begin (quote-syntax (require/typed-internal back Number)) (#%plain-app values))) 
 (#%require (just-meta 0 (rename "../scm2c-untyped/pract/typed-scheme-pract.scm" back back)) (only "../scm2c-untyped/pract/typed-scheme-pract.scm")) 
 (define-values (back) (#%app contract/proc cnt (begin (#%app contract/proc back15 back15 '(definition back15) temp22 (#%app list (#%app make-srcloc back15 '#f '#f '#f '0) '"back15"))) '(interface for back) 'never-happen (quote-syntax back))) 
 (define-values (cnt) '#f) 
 (define-values () (begin (quote-syntax (require/typed-internal add-proc (Number -> Number))) (#%plain-app values))) 
 (#%require (just-meta 0 (rename "../scm2c-untyped/pract/typed-scheme-pract.scm" add-proc add-proc)) (only "../scm2c-untyped/pract/typed-scheme-pract.scm")) 
 (define-values (add-proc) (#%app contract/proc cnt (begin (#%app contract/proc add-proc13 add-proc13 '(definition add-proc13) temp20 (#%app list (#%app make-srcloc add-proc13 '#f '#f '#f '0) '"add-proc13"))) '(interface for add-proc) 'never-happen (quote-syntax add-proc))) 
 (define-values (void-ftn!) (lambda (arg arg2) (set! arg '1))) 
 (define-values (blocksize) '10) 
 (#%provide blocksize) 
 (define-values (threadsize) blocksize) 
 (define-values (x) '100) 
 (define-values (y) (#%app add1 x)) 
 (define-values (myadd) (lambda (x) (#%app add1 x))) 
 (define-values (fac) (lambda (x) (if (#%app <= '1 x) (#%app fac (#%app - x '1)) '1))) 
 (define-values (x!) (lambda () (#%app printf '"val = ~s\n" '100))) 
 (define-values (a) '300) 
 (define-values (lamb) (lambda (x y) (#%app + x y))) 
 (define-values (lamb1) (lambda (x) '388)) 
 (define-values (lamb2) (lambda (x y) (#%app + x y))) 
 (define-values (lamb3) (lambda (x y) (#%app + x y))) 
 (define-syntaxes (IntVariants) (lambda (stx) (#%app raise-syntax-error 'type-check '"type name used out of context" stx))) 
 (define-values () (begin (quote-syntax (define-type-alias-internal IntVariants (U Integer (Integer -> Integer)))) (#%plain-app values))) 
 (define-values (struct:Date make-Date Date? Date-day Date-month Date-year) 
   (let-values (((struct: make- ? -ref -set!) (letrec-syntaxes+values (((struct-field-index18) (convert-renamer (lambda (stx) (syntax-case stx (day month year) ((_ day) #'0) ((_ month) #'1) ((_ year) #'2) ((_ name) (raise-syntax-error #f "no such field" stx #'name))))))) () (letrec-syntaxes+values (((struct-field-index1) (values (make-rename-transformer (quote-syntax struct-field-index18))))) () (#%app make-struct-type 'Date '#f '3 '0 '#f null (#%app current-inspector) '#f '(0 1 2) '#f))))) (#%app values struct: make- ? (#%app make-struct-field-accessor -ref '0 'day) (#%app make-struct-field-accessor -ref '1 'month) (#%app make-struct-field-accessor -ref '2 'year)))) 
 (define-syntaxes (Date) 
   (#%app make-checked-struct-info (lambda () (#%app list (quote-syntax struct:Date) (quote-syntax make-Date) (quote-syntax Date?) (#%app list (quote-syntax Date-year) (quote-syntax Date-month) (quote-syntax Date-day)) (#%app list '#f '#f '#f) '#t)))) 
 (define-values () (begin (quote-syntax (define-typed-struct-internal Date ((day : Number) (month : String) (year : Number)))) (#%plain-app values))) 
 (define-values () (begin (quote-syntax (:-internal format-date (Date -> String))) (#%plain-app values))) 
 (define-values (format-date) (lambda (d) (#%app format '"Today is day ~a of ~a in the year ~a" (#%app Date-day d) (#%app Date-month d) (#%app Date-year d)))) 
 (#%app format-date (#%app make-Date '28 '"November" '2006)) 
 (define-values (adding) (#%app add1 '20)) 
 (define-values (aading) (#%app add1 (#%app add1 '19))) 
 (define-values (minus1) (lambda (a) (#%app - a '1))) 
 (define-values (change2neg) (lambda (b) (#%app not b))) 
 (define-values (new-or!) (lambda (a) (if (let-values (((or-part) a)) (if or-part or-part (#%app change2neg a))) (#%app printf '"input is larger than 1\n") (#%app printf '"input is smaller than 1\n")))) 
 (define-values (compute-main) (lambda (arg0 arg1 arg2) (#%app + arg0 (#%app + arg1 (#%app add1 arg2))))) 
 (#%app compute-main '1 '2 '3) 
 (#%app compute-main '2 '3 '4) 
 (define-values (kernel) (lambda () (let-values (((arg0) '1.0) ((arg1) '2999999.999) ((arg2) '40000000.0)) (#%app compute-main arg0 arg1 arg2)))) 
 (define-values (test-cond) (if (#%app string? '"abc") (begin (lambda (x) (#%app + '1 x))) (begin (lambda (y) (#%app + '2 y))))) 
 (define-values (minus) (lambda (x) (#%app - x '1))) 
 (define-values (cond-type) (if (#%app integer? '1) (begin '1) (if (#%app string? '"a") (begin minus) (begin '1)))) 
 (define-values (test-cond1) (if (#%app string? '"abc") (begin (lambda (x) (#%app + '1 x))) (begin (lambda (y) (#%app + '2 y))))) 
 (define-values (cond-type1) (if (#%app integer? '1) (begin '1) (if (#%app string? '"a") (begin minus) (begin '1)))) 
 (define-values (cond-func) (let-values (((abc) '1)) (if (#%app integer? '3) (begin '3) (if (#%app string? '"abc") (begin abc) (if (#%app number? '3) (begin minus) (begin '"123")))))) 
 (define-values (case-func!) (lambda (c) (let-values (((x) c)) (if (let-values (((tmp) x)) (if (#%app eqv? tmp '#\c) '#t (if (#%app eqv? tmp '#\d) '#t (#%app eqv? tmp '#\e)))) (begin (#%app printf '"string \n")) (let-values (((x) x)) (if (let-values (((tmp) x)) (if (#%app eqv? tmp '1) '#t (if (#%app eqv? tmp '2) '#t (#%app eqv? tmp '3)))) (begin (#%app printf '"integer\n")) (#%expression (begin x (#%app printf '"not string\n"))))))))) 
 (define-values (two-args) (lambda (arg1 arg2) (#%app + arg1 arg2))) 
 (define-values (main) (lambda (argc argv) (#%app case-func! '#\c))))

|#

#|
value: string, number symbol
exp: (lambda (x..) exp...)          -> type name (x ...) c-exp ;
     (proc-call x ...)              -> call (x ...);
toplevel:=value                     -> comment out
        |(define name value)        -> type name = value;
        |(define name exp)          -> type name = c_exp;
        |(define (name v ...) exp...) -> type name (v ...) { exp ...}
      
exp:= if, or + begin let cond case.


|#


#| AFter local = expand
(#%module-begin 
(require typed-scheme) 
(require/typed version/check (check-version (-> (U Symbol (Listof Any))))) 
(require/opaque-type Array array? "../typed-srfi-25.ss") 
(require/typed "../scm2c-untyped/pract/typed-scheme-pract.scm" (hundred Number) (back Number) (add-proc (Number -> Number)))
(define: (void-ftn! (arg : Integer) (arg2 : Boolean)) : Void (set! arg 1)) 

(add-proc 100) 
(provide blocksize) 
(define: x : Integer 
  100) 
(define: (x!) : Void 
  (printf "val = ~s\n" 100)) 
(define: a : Integer 
  100) 
(define: lamb : (Integer -> Integer) 
  (lambda (x) 388)) 
(define-type-alias IntVariants (U Integer (Integer -> Integer))) 
(define: adding : Integer 
  (add1 20)) 
(define: aading : Integer 
  (add1 (add1 19))) 
(define: blocksize : Integer 
  10) 
(define: threadsize : Integer 
  blocksize) 
(define: (minus1 (a : Number)) : Number 
  (- a 1)) 
(define: (change2neg (b : Boolean)) : Boolean 
  (not b)) 
(define: (new-or! (a : Boolean)) : Void 
  (if (or a (change2neg a)) 
      (printf "input is larger than 1\n") 
      (printf "input is smaller than 1\n"))) 
|#


#|
(define: test-cond : (Integer -> Integer) 
  (cond ((string? "abc") (lambda (x) (+ 1 x))) (else (lambda (y) (+ 2 y))))) 

(define: minus : (Integer -> Integer) (lambda (x) (- x 1))) 

(define: cond-type : IntVariants (cond ((integer? 1) 1) ((string? "a") minus) (else 1))) 

(define: test-cond1 : (Integer -> Integer) 
  (cond ((string? "abc") (lambda (x) (+ 1 x))) (else (lambda (y) (+ 2 y))))) 

(define: cond-type1 : IntVariants 
  (cond ((integer? 1) 1) ((string? "a") minus) (else 1))) 

(define: cond-func : (U Integer String (Integer -> Integer)) 
  (let ((abc 1)) 
    (cond ((integer? 3) 3) 
          ((string? "abc") abc)
          ((number? 3) minus) 
          (else "123")))) 

(define: (case-func! (c : (U Integer Char))) : Void 
  (case c ((#\c #\d #\e) (printf "string \n")) ((1 2 3) (printf "integer\n")) (else (printf "not string\n"))))

(define: (two-args (arg1 : Number) (arg2 : Number)) : Number 
  (+ arg1 arg2)) 

(define: (main (argc : Integer) (argv : String)) : Integer
  (case-func! #\c)
  (case-func! 4)
  (kernel) 
  (new-or! (< 1 2)) 
  0)

)

|#

;;#| expanded forms
;(module simple-src scheme 
;  (#%module-begin
;   (define-values (blocksize) '10)
;   (define-values (threadsize) blocksize)
;   (define-values (compute-main)
;     (lambda (arg0 arg1 arg2) (#%app + arg0 (#%app + arg1 (#%app add1 arg2)))))
;   (define-values (kernel) 
;     (lambda () (let-values (((arg0) '1))
;                  (let-values (((arg1) '2))
;                    (let-values (((arg2) '3)) 
;                      (#%app compute-main arg0 arg1 arg2))))))
;   (#%app call-with-values (lambda () (#%app kernel)) print-values)
;  ))
;;|#

#|
int blocksize = 10;
int threadsize = blocksize;
int compute-main (arg0, arg1, arg2)
{
  int s2 = 1 + arg2;
  int s1 = arg1 + s2;
  return arg0 + s1;
}

int kernel ()
{
  int arg0 = 1;
  int arg1 = 2;
  int arg2 = 3;
  return compute-main (arg0, arg1, arg2);
}

__device__ int compute_main (int arg0, int arg1, int arg2)
{
  int temp0 = arg2 + 1;
  int temp1 = arg1 + temp0;
  return arg0 + temp1;
}
(#%app call-with-values (lambda () '3) print-values)
__global__ int
|#


#|
ARRAY VERSION
(module kernel scheme
(require "kernel-defs.ss")
(define-device (call0) #f)
(define-global (compute_simd lst-arrays lst-params)
   grid-idx
   thread-idx

   (call0))
)
|#

#| stage 1.
top-level-form    = (module id name-id (#%module-begin module-level-form ...))
module-level-form = (#%app 'call-with-values ('lambda '() exp) 'print-values)
exp               = ('quote num)
num               = number?
|#
; -> stage 1 is a parse tree. 
; -> need a symbol table to assign the type information.
;    type variable for each expression
;    type inference information (from unification)


; closer goal
#| Expanded Syntax that cugen compiler recognizes.
top-level-form    = (module id name-id (#%module-begin module-level-form ...))

module-level-form = (define-values (id) expr)
                  | expr

expr              = id
                  | (quote id) ; 'id
                  | (lambda formals expr ...+)
                  | (#%app 'call-with-values expr expr)
                  | (#%app '+ expr ...+)
                  | (#%app id expr ...+)
                  | (#%app id expr 'print-values)
                  | (let-values (((id) expr)) expr)

formals           = (id ...)
                  | (id ...+ . id)

num               = number?

|#

; final goal.
#|
top-level-form	=general-top-level-form
 	 	|(#%expression expr)
 	 	|(module id name-id
                   (#%plain-module-begin
                    module-level-form ...))
 	 	|(begin top-level-form ...)

                
module-level-form=general-top-level-form
 	 	|(#%provide raw-provide-spec ...)
                 
 	 	 	 	 
general-top-level-form = expr
 	 	|(define-values (id ...) expr)
 	 	|(define-syntaxes (id ...) expr)
 	 	|(define-values-for-syntax (id ...) expr)
 	 	|(#%require raw-require-spec ...)
 	 	 
                 
  expr	 	= id
 	 	|(#%plain-lambda formals expr ...+)
 	 	|(case-lambda (formals expr ...+) ...)
 	 	|(if expr expr expr)
 	 	|(begin expr ...+)
 	 	|(begin0 expr expr ...)
 	 	|(let-values (((id ...) expr) ...)
                   expr ...+)
 	 	|(letrec-values (((id ...) expr) ...)
                    expr ...+)
 	 	|(set! id expr)
 	 	|(quote datum)
 	 	|(quote-syntax datum)
 	 	|(with-continuation-mark expr expr expr)
 	 	|(#%plain-app expr ...+)
 	 	|(#%top . id)
 	 	|(#%variable-reference id)
 	 	|(#%variable-reference (#%top . id))
 	 	|(#%variable-reference)
 	 	 	 	 
  formals	=(id ...)
 	 	|(id ...+ . id)
 	 	|id
|#

