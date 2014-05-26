#lang racket	
;Fullyexpandedstx:- by (local-expand)
(#%plain-module-begin 
 (define-values () 
   (begin 
     (quote-syntax (:-internal cpyTestDrv_kernel ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)))) 
     (#%plain-app values))) 
 (define-values (cpyTestDrv_kernel) (lambda (array_in sgl_in) (#%app values array_in (quote 100)))))

;;new-mod: - output of (tc-typecheck)
(begin 
  (begin) 
  (begin-for-syntax 
    (register-type (syntax cpyTestDrv_kernel) 
                   (make-Function 
                    (quasiquote 
                     ((unquote 
                       (make-arr 
                        (quasiquote 
                         ((unquote 
                           (make-Vector 
                            (make-Union (sort (list -FlonumPosZero -FlonumNegZero -FlonumNan -PosFlonum -NegFlonum) < #:key Type-seq)))) 
                          (unquote 
                           (make-Union (sort (list (make-Value 0) (make-Value 1) -Byte>1 -PosIndexNotByte -PosFixnumNotIndex -PosIntNotFixnum) < #:key Type-seq))))) 
                        
                        (make-Values 
                         (quasiquote 
                          ((unquote 
                            (make-Result (make-Vector (make-Union (sort (list -FlonumPosZero -FlonumNegZero -FlonumNan -PosFlonum -NegFlonum) < #:key Type-seq))) 
                                         (make-FilterSet (make-Top) (make-Top)) 
                                         (make-Empty))) 
                           (unquote 
                            (make-Result (make-Union (sort (list (make-Value 0) (make-Value 1) -Byte>1 -PosIndexNotByte -PosFixnumNotIndex -PosIntNotFixnum) < #:key Type-seq)) 
                                         (make-FilterSet (make-Top) (make-Top)) 
                                         (make-Empty)))))) 
                        #f #f (quasiquote ())))))))) 
  (begin-for-syntax) 
  (begin-for-syntax) 
  (begin-for-syntax (begin)) 
  (begin))
;Typechecking-Done
;12 pass2_____((define-values () (begin (quote-syntax (:-internal cpyTestDrv_kernel ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)))) (#%plain-app values))))_____: 
;predicate assertion == ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)), (Any -> Boolean : Error)
;14 pass2 __ w/ var: (cpyTestDrv_kernel)
;ret of list of type:(((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)))
;lst of type:(#(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f))
;base-type->symbol: ty:((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)), w/ name:((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer))
;basse-type->symbol: Function type w/ dom:((Vectorof Float) Exact-Nonnegative-Integer), rng:(values (Vectorof Float) Exact-Nonnegative-Integer)
;symbol of (car types) = Function_type
;----------------Just check expr: ts2c-expr-translate---------------------------
;ts2c-expr-translate form:(lambda (array_in sgl_in) (#%app values array_in (quote 100))), expected:#(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f)
;(tc-results->type-list expected):(((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)))
;tc-expr of form:#(struct:tc-results (#(struct:tc-result (Any Any -> (values (Any : ((! False @ 0) | (False @ 0)) : (0)) (Positive-Byte : (Top | Bot)))) (Top | Bot) -)) #f)
;not vector type w/ expected:#(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f)
;----------------End of just check expr: ts2c-expr-translate---------------------
;expr_transln_case_11_1____formal:(array_in sgl_in), body:((#%app values array_in (quote 100)))
;lambda check w/ expected:#(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f)
;formals :(array_in sgl_in), bodies:((#%app values array_in (quote 100)))
;base-type->symbol: ty:(Vectorof Float), w/ name:(Vectorof Float)
;base-type->symbol: Vector type:(Vectorof Float)
;base-type->symbol: ty:Float, w/ name:Float
;base-type->symbol: ty:Exact-Nonnegative-Integer, w/ name:Exact-Nonnegative-Integer
;(lst-body->type-name-string: return-tc-type:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f), formalstx:#<syntax (array_in sgl_in)>, arg-tys:((Vectorof Float) Exact-Nonnegative-Integer), lst-bdy:(#<syntax::514 (#%app values array_in (quote...>)
;***lst-bdy:(#<syntax::514 (#%app values array_in (quote...>)
;***lst-bdy-ty:(#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f))
;----------------Just check expr: ts2c-expr-translate---------------------------
;ts2c-expr-translate form:(#%app values array_in (quote 100)), expected:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)
;(tc-results->type-list expected):((Vectorof Float) Exact-Nonnegative-Integer)
;tc-expr of form:#(struct:tc-results (#(struct:tc-result (Vectorof Float) ((! False @ array_in) | (False @ array_in)) (#<syntax::493 array_in>)) #(struct:tc-result Positive-Byte (Top | Bot) -)) #f)
;tc-results w/ ts:((Vectorof Float) Positive-Byte) w/ expected:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)
;----------------End of just check expr: ts2c-expr-translate---------------------
;expr_transln_case_7.6.0 plain-app . _ w/ form:(#%app values array_in (quote 100)), expected:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)
;ts2c-expr-app_case:_________(8 w/values = #<procedure:values>, args = (array_in (quote 100)), expected = #(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f),  listof Result:((Vectorof Float) Exact-Nonnegative-Integer), list of Type:(#f #f)
;----------------Just check expr: ts2c-expr-translate---------------------------
;ts2c-expr-translate form:array_in, expected:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -)) #f)
;(tc-results->type-list expected):((Vectorof Float))
;tc-expr of form:#(struct:tc-results (#(struct:tc-result (Vectorof Float) ((! False @ array_in) | (False @ array_in)) (#<syntax::493 array_in>))) #f)
;vector type:Float
;----------------End of just check expr: ts2c-expr-translate---------------------
;expr_transln_case_6____identifier:array_in w/expected = #(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -)) #f)
;(ret type) of array_in == #(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -)) #f), 
;string as symbol == array_in, type= (Vectorof Float)
;stringized_id == array_in, nmx=array_in4226
;***** EXPR - TRANSLATION *****
;FORM == array_in: 
;EXPECTED: #(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -)) #f) / (Vectorof Float), Type?:#t, Base?:#f 
;===========================================
;Result of expr-translation:
;type: #(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -)) #f)
;var: (array_in4226)
;string: array_in4226 = array_in;
;, outvar-renamed:(array_in4226)
;------terminal?(identifier)
;<<<terminal-expr?---form:array_in	#t
;INSIDE of (expr-to-string) w tc-ty:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -)) #f), lnm:(array_in4226), nullname?(#f), str:array_in4226 = array_in;
;, terminal?:#t
;expr-to-string 3rd case
;base-type->symbol: ty:(Vectorof Float), w/ name:(Vectorof Float)
;base-type->symbol: Vector type:(Vectorof Float)
;base-type->symbol: ty:Float, w/ name:Float
;----------------Just check expr: ts2c-expr-translate---------------------------
;ts2c-expr-translate form:(quote 100), expected:#(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)
;(tc-results->type-list expected):(Exact-Nonnegative-Integer)
;tc-expr of form:#(struct:tc-results (#(struct:tc-result Positive-Byte (Top | Bot) -)) #f)
;not vector type w/ expected:#(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)
;----------------End of just check expr: ts2c-expr-translate---------------------
;single value(non boolean..val: 100, (tc-results->type-list expected):(Exact-Nonnegative-Integer)
;expr_transln_case_3_3-3(IP)_____: form:(quote 100), val: 100, ty: Exact-Nonnegative-Integer, expected:#(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Bot) -)) #f)
;base-type->symbol: ty:Exact-Nonnegative-Integer, w/ name:Exact-Nonnegative-Integer
;tc-structs-ty(expected):#(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Bot) -)) #f), Base?: #f, symbol form: int
;not a type or base type, cannot get type name: Exact-Nonnegative-Integer
;type-not-base w/ name:Exact-Nonnegative-Integer
;(quote val) output - number:100, - name:n4291
;***** EXPR - TRANSLATION *****
;FORM == (quote 100): 
;EXPECTED: #(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f) / Exact-Nonnegative-Integer, Type?:#t, Base?:#f 
;===========================================
;Result of expr-translation:
;type: #(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Bot) -)) #f)
;var: (n4291)
;string: n4291 = 100;
;, outvar-renamed:(n4291)
;<<<terminal-expr?---form:(quote 100)	#t
;INSIDE of (expr-to-string) w tc-ty:#(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Bot) -)) #f), lnm:(n4291), nullname?(#f), str:n4291 = 100;
;, terminal?:#t
;expr-to-string 3rd case
;base-type->symbol: ty:Exact-Nonnegative-Integer, w/ name:Exact-Nonnegative-Integer
;l-res-ty:(#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -)) #f) #(struct:tc-results (#(struct:tc-result Exact-Nonnegative-Integer (Top | Bot) -)) #f)), 
;ll-n:((array_in4226) (n4291)), 
;ll-s:(float* array_in4226;
;array_in4226 = array_in;
; int n4291;
;n4291 = 100;
;)
;***** EXPR - TRANSLATION *****
;FORM == (#%app values array_in (quote 100)): 
;EXPECTED: #(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f) / (Vectorof Float), Type?:#t, Base?:#f 
;===========================================
;Result of expr-translation:
;type: #(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)
;var: (array_in4226 n4291)
;string: float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;, outvar-renamed:(array_in4226 n4291)
;<<<terminal-expr?---form:(#%app values array_in (quote 100))	#f
;INSIDE of (expr-to-string) w tc-ty:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f), lnm:(array_in4226 n4291), nullname?(#f), str:float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;, terminal?:#f
;expr-to-string 3rd case
;base-type->symbol: ty:(Vectorof Float), w/ name:(Vectorof Float)
;base-type->symbol: Vector type:(Vectorof Float)
;base-type->symbol: ty:Float, w/ name:Float
;base-type->symbol: ty:Exact-Nonnegative-Integer, w/ name:Exact-Nonnegative-Integer
;l-res-ty:(#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)), 
;ll-n:((array_in4226 n4291)), 
;ll-s:(float* array_in4226;
;int n4291;
;float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;)
;Result of body processing w/l-res_ty:(#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f)), ll-fml_nm:((array_in4226 n4291)), l-bdy-str:(float* array_in4226;
;int n4291;
;float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;)
;lst-retn-ty:((Vectorof Float) Exact-Nonnegative-Integer)
;Return prep: Base?((Vectorof Float))(#f), Result?((Vectorof Float))(#f), Type-key(vector), 
;Num-returns:2, arg-nm:(float*4110 int4111), fml_nm:((array_in4226 n4291))
;Void-return check - (car lst-retn-ty):(Vectorof Float), is it Base?:#f, What's the key?:vector
;Non-void case - assignment to return pointers:*lv:float*4110 rv:array_in4226
;Non-void case - assignment to return pointers:*lv:int4111 rv:n4291
;compile-lambda 1.1.2: expected:#(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f), fml-tys:((Vectorof Float) Exact-Nonnegative-Integer), ret:((Vectorof Float) Exact-Nonnegative-Integer)
;ts2c-fml-translate:___ in-tys: ((Vectorof Float) Exact-Nonnegative-Integer), vars: (array_in sgl_in), res-ty:#(struct:tc-results (#(struct:tc-result (Vectorof Float) (Top | Top) -) #(struct:tc-result Exact-Nonnegative-Integer (Top | Top) -)) #f), lst-ret-nm:(float*4110 int4111)
;base-type->symbol: ty:(Vectorof Float), w/ name:(Vectorof Float)
;base-type->symbol: Vector type:(Vectorof Float)
;base-type->symbol: ty:Float, w/ name:Float
;base-type->symbol: ty:Exact-Nonnegative-Integer, w/ name:Exact-Nonnegative-Integer
;base-type->symbol: ty:(Vectorof Float), w/ name:(Vectorof Float)
;base-type->symbol: Vector type:(Vectorof Float)
;base-type->symbol: ty:Float, w/ name:Float
;base-type->symbol: ty:Exact-Nonnegative-Integer, w/ name:Exact-Nonnegative-Integer
;len-inout:4
;in-tys == (float* int)
;in-nms == (array_in sgl_in)
;out-tys == (float** int*)
;out-nms == (float*4110 int4111)
;F/fold, i:0
;old-str:
;new-str:(float* array_in , 
;F/fold, i:1
;old-str:(float* array_in , 
;new-str:int sgl_in , 
;F/fold, i:2
;old-str:(float* array_in , int sgl_in , 
;new-str:float** float*4110 , 
;F/fold, i:3
;old-str:(float* array_in , int sgl_in , float** float*4110 , 
;new-str:int* int4111 )
;***** EXPR - TRANSLATION *****
;FORM == (lambda (array_in sgl_in) (#%app values array_in (quote 100))): 
;EXPECTED: #(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f) / ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)), Type?:#t, Base?:#f 
;===========================================
;Result of expr-translation:
;type: #(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f)
;var: (array_in4226 n4291)
;string: (float* array_in , int sgl_in , float** float*4110 , int* int4111 ) {
;float* array_in4226;
;int n4291;
;float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;
;*float*4110 = array_in4226;
;*int4111 = n4291;
;return;
;}
;, outvar-renamed:(array_in4226 n4291)
;translated form:(lambda (array_in sgl_in) (#%app values array_in (quote 100)))
;<<<terminal-expr?---form:(lambda (array_in sgl_in) (#%app values array_in (quote 100)))	#f
;INSIDE of (expr-to-string) w tc-ty:#(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f), lnm:(array_in4226 n4291), nullname?(#f), str:(float* array_in , int sgl_in , float** float*4110 , int* int4111 ) {
;float* array_in4226;
;int n4291;
;float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;
;*float*4110 = array_in4226;
;*int4111 = n4291;
;return;
;}
;, terminal?:#f
;INSIDE of define-values-to-string w ret-ty:#(struct:tc-results (#(struct:tc-result ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)) (Top | Top) -)) #f), nm:(cpyTestDrv_kernel), out-nm: (array_in4226 n4291), str:(float* array_in , int sgl_in , float** float*4110 , int* int4111 ) {
;float* array_in4226;
;int n4291;
;float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;
;*float*4110 = array_in4226;
;*int4111 = n4291;
;return;
;}
;
;-- function type: void cpyTestDrv_kernel(float* array_in , int sgl_in , float** float*4110 , int* int4111 ) {
;float* array_in4226;
;int n4291;
;float* array_in4226;
;array_in4226 = array_in;
;
;int n4291;
;n4291 = 100;
;
;*float*4110 = array_in4226;
;*int4111 = n4291;
;return;
;}
;
;
;expv == expv
;ts2c/toplevel-pass2-10 ended 
;cpu time: 155 real time: 154 gc time: 47
;__________________________________
;Time for ts2c-toplevel/pass2:
;cpu time: 155 real time: 154 gc time: 47
;__________________________________
;Time for whole code gen:
;_______________________________________________________________________________
;TOP expanded: - fully expanded.
(module sum_kernel suda 
  (#%module-begin 
   (define-values () 
     (begin 
       (quote-syntax (:-internal cpyTestDrv_kernel ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)))) 
       (#%plain-app values))) 
   (define-values (cpyTestDrv_kernel) 
     (lambda (array_in sgl_in) (#%app values array_in (quote 100)))) 
   (define-values-for-syntax () 
     (begin 
       (#%app register-type 
              (quote-syntax cpyTestDrv_kernel) 
              (#%app make-Function 
                     (#%app list 
                            (#%app make-arr 
                                   (#%app list 
                                          (#%app make-Vector 
                                                 (#%app make-Union 
                                                        (let-values (((procedure) sort)
                                                                     ((temp1) (#%app list -FlonumPosZero -FlonumNegZero -FlonumNan -PosFlonum -NegFlonum)) 
                                                                     ((<2) <) 
                                                                     ((Type-seq3) Type-seq)) 
                                                          (#%app 
                                                           (#%app checked-procedure-check-and-extract 
                                                                  struct:keyword-procedure 
                                                                  procedure 
                                                                  keyword-procedure-extract 
                                                                  (quote (#:key)) 
                                                                  (quote 4)) 
                                                           (quote (#:key)) 
                                                           (#%app list Type-seq3)
                                                           temp1 <2)))) 
                                          (#%app make-Union 
                                                 (let-values (((procedure) sort)
                                                              ((temp4) 
                                                               (#%app list 
                                                                      (#%app make-Value (quote 0)) 
                                                                      (#%app make-Value (quote 1)) 
                                                                      -Byte>1 
                                                                      -PosIndexNotByte 
                                                                      -PosFixnumNotIndex 
                                                                      -PosIntNotFixnum)) 
                                                              ((<5) <) 
                                                              ((Type-seq6) Type-seq)) 
                                                   (#%app 
                                                    (#%app 
                                                     checked-procedure-check-and-extract
                                                     struct:keyword-procedure 
                                                     procedure 
                                                     keyword-procedure-extract 
                                                     (quote (#:key)) 
                                                     (quote 4)) 
                                                    (quote (#:key)) 
                                                    (#%app list Type-seq6) 
                                                    temp4 <5)))) 
                                   (#%app make-Values 
                                          (#%app list 
                                                 (#%app make-Result 
                                                        (#%app make-Vector 
                                                               (#%app make-Union 
                                                                      (let-values (((procedure) sort)
                                                                                   ((temp7) (#%app list -FlonumPosZero -FlonumNegZero -FlonumNan -PosFlonum -NegFlonum))
                                                                                   ((<8) <)
                                                                                   ((Type-seq9) Type-seq)) 
                                                                        (#%app 
                                                                         (#%app 
                                                                          checked-procedure-check-and-extract 
                                                                          struct:keyword-procedure
                                                                          procedure
                                                                          keyword-procedure-extract 
                                                                          (quote (#:key)) (quote 4))
                                                                         (quote (#:key))
                                                                         (#%app list Type-seq9) 
                                                                         temp7 
                                                                         <8))))
                                                        (#%app make-FilterSet 
                                                               (#%app make-Top) 
                                                               (#%app make-Top)) 
                                                        (#%app make-Empty))
                                                 (#%app make-Result
                                                        (#%app make-Union 
                                                               (let-values (((procedure) sort)
                                                                            ((temp10) (#%app list 
                                                                                             (#%app make-Value (quote 0)) 
                                                                                             (#%app make-Value (quote 1)) 
                                                                                             -Byte>1 
                                                                                             -PosIndexNotByte 
                                                                                             -PosFixnumNotIndex
                                                                                             -PosIntNotFixnum))
                                                                            ((<11) <)
                                                                            ((Type-seq12) Type-seq)) 
                                                                 (#%app 
                                                                  (#%app 
                                                                   checked-procedure-check-and-extract 
                                                                   struct:keyword-procedure 
                                                                   procedure 
                                                                   keyword-procedure-extract 
                                                                   (quote (#:key)) 
                                                                   (quote 4)) 
                                                                  (quote (#:key))
                                                                  (#%app list Type-seq12) 
                                                                  temp10 <11))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top)) 
                                                        (#%app make-Empty)))) 
                                   (quote #f) (quote #f) (quote ()))))) (#%app values))) (#%app void)))
