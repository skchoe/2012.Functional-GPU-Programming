
(module sum_kernel suda 
  (#%module-begin 
   (define-values (sum) (lambda (a) '1)) 
   (define-values (b) '12.4)
   
   (define-values-for-syntax () 
     (begin 
       (#%app register-type 
              (quote-syntax sum) 
              (#%app make-Function 
                     (#%app list 
                            (#%app make-arr 
                                   (#%app list 
                                          (#%app make-Base 
                                                 'Integer 
                                                 (quote-syntax exact-integer?))) 
                                   (#%app make-Values 
                                          (#%app list 
                                                 (#%app make-Result 
                                                        (#%app make-Base 'Integer (quote-syntax exact-integer?))
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top))
                                                        (#%app make-Empty))))
                                   '#f '#f '()))))
       (#%app values)))
   
   (define-values-for-syntax () 
     (begin 
       (#%app register-type 
              (quote-syntax b) 
              (#%app make-Base 'Flonum (quote-syntax inexact-real?))) 
       (#%app values)))
   
   (#%app void)))

(module sum_kernel suda 
  (#%module-begin 
   (define-values () (begin (quote-syntax (:-internal exlst (Vectorof Integer))) (#%plain-app values))) 
   (define-values (exlst) (#%app vector '1 '2 '3 '4 '5)) 
   (define-values (return_2_val) (lambda () (#%app values '1 '1.0))) 
   
   (define-values-for-syntax () 
     (begin 
       (#%app register-type 
              (quote-syntax exlst) 
              (#%app make-Vector (#%app make-Base 'Integer (quote-syntax exact-integer?)))) 
       (#%app values))) 
   
   (define-values-for-syntax () 
     (begin 
       (#%app register-type 
              (quote-syntax return_2_val) 
              (#%app make-Function 
                     (#%app list 
                            (#%app make-arr 
                                   '() 
                                   (#%app make-Values 
                                          (#%app list 
                                                 (#%app make-Result 
                                                        (#%app make-Base 
                                                               'Positive-Fixnum 
                                                               (quote-syntax (and/c number? fixnum? positive?))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Bot)) 
                                                        (#%app make-Empty))
                                                 (#%app make-Result 
                                                        (#%app make-Base 
                                                               'Nonnegative-Flonum 
                                                               (quote-syntax 
                                                                (and/c inexact-real? 
                                                                       (or/c positive? zero?)
                                                                       (lambda (x) (not (eq? x -0.0)))))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Bot)) 
                                                        (#%app make-Empty))))
                                   '#f '#f '())
                            )
                     )
              ) 
       (#%app values))) 
   (#%app void)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(module 
    sum_kernel suda 
  (#%module-begin 
   (define-values () (begin 
                       (quote-syntax 
                        (:-internal cpyTestDrv_kernel 
                           ((Vectorof Float) Integer Exact-Nonnegative-Integer 
                           -> 
                           (values (Vectorof Float) (Vectorof Integer) Exact-Nonnegative-Integer)))) 
                       (#%plain-app values))) 
   (define-values (cpyTestDrv_kernel) 
     (lambda (array_in array_size sgl_in) 
       (#%app values array_in (#%app vector '1 '2 '3) '100))) 
   
   (define-values-for-syntax () 
     (begin 
       (#%app register-type 
              (quote-syntax cpyTestDrv_kernel) 
              (#%app make-Function 
                     (#%app list 
                            (#%app make-arr 
                                   (#%app list 
                                          (#%app make-Vector (#%app make-Base 'Flonum (quote-syntax inexact-real?))) 
                                          (#%app make-Base 'Integer (quote-syntax exact-integer?)) 
                                          (#%app make-Union 
                                                 (let-values (((procedure) sort) 
                                                              ((temp1) (#%app list (#%app make-Base 'Exact-Positive-Integer (quote-syntax exact-positive-integer?)) (#%app make-Value '0))) 
                                                              ((<2) <) 
                                                              ((Type-seq3) Type-seq)) 
                                                   (#%app 
                                                    (#%app checked-procedure-check-and-extract struct:keyword-procedure procedure keyword-procedure-extract '(#:key) '4) 
                                                    '(#:key) 
                                                    (#%app list Type-seq3) 
                                                    temp1 <2))))
                                   (#%app make-Values
                                          (#%app list 
                                                 (#%app make-Result 
                                                        (#%app make-Vector (#%app make-Base 'Flonum (quote-syntax inexact-real?))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top)) 
                                                        (#%app make-Empty)) 
                                                 (#%app make-Result
                                                        (#%app make-Vector (#%app make-Base 'Integer (quote-syntax exact-integer?))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top)) 
                                                        (#%app make-Empty)) 
                                                 (#%app make-Result 
                                                        (#%app make-Union 
                                                               (let-values (((procedure) sort) 
                                                                            ((temp4) (#%app list (#%app make-Base 'Exact-Positive-Integer (quote-syntax exact-positive-integer?)) (#%app make-Value '0))) 
                                                                            ((<5) <) 
                                                                            ((Type-seq6) Type-seq)) 
                                                                 (#%app 
                                                                  (#%app checked-procedure-check-and-extract 
                                                                         struct:keyword-procedure procedure 
                                                                         keyword-procedure-extract 
                                                                         '(#:key) 
                                                                         '4)
                                                                  '(#:key) 
                                                                  (#%app list Type-seq6) 
                                                                  temp4 <5))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top)) 
                                                        (#%app make-Empty)))) 
                                   '#f '#f '()))))
       (#%app values))) (#%app void)))

(let-values 
    (((procedure) sort) 
     ((temp4) (#%app list 
                     (#%app make-Base (quote Exact-Positive-Integer) (quote-syntax exact-positive-integer?))
                     (#%app make-Value (quote 0))))
     ((<5) <) 
     ((Type-seq6) Type-seq))
  (#%app 
   (#%app checked-procedure-check-and-extract 
          struct:keyword-procedure 
          procedure 
          keyword-procedure-extract
          (quote (#:key)) 
          (quote 4))
   (quote (#:key))
   (#%app list Type-seq6)
   temp4 
   <5))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; expansion by Racket v5.0
(module sum_kernel suda 
  (#%module-begin 
   (define-values () (begin (quote-syntax (:-internal cpyTestDrv_kernel ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)))) (#%plain-app values))) 
   (define-values (cpyTestDrv_kernel) (lambda (array_in sgl_in) (#%app values array_in (quote 100)))) 
   (define-values-for-syntax 
     () 
     (begin
       (#%app register-type 
              (quote-syntax cpyTestDrv_kernel) 
              (#%app make-Function 
                     (#%app list 
                            (#%app make-arr 
                                   (#%app list 
                                          (#%app make-Vector 
                                                 (#%app make-Base (quote Flonum) (quote-syntax inexact-real?)))
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          (#%app make-Union 
                                                 (let-values 
                                                     (((procedure) sort)
                                                      ((temp1) (#%app list
                                                                      (#%app make-Base 
                                                                             (quote Exact-Positive-Integer)
                                                                             (quote-syntax exact-positive-integer?))
                                                                      (#%app make-Value (quote 0)))) 
                                                      ((<2) <) ((Type-seq3) Type-seq))
                                                   (#%app (#%app 
                                                           checked-procedure-check-and-extract 
                                                           struct:keyword-procedure 
                                                           procedure 
                                                           keyword-procedure-extract 
                                                           (quote (#:key)) 
                                                           (quote 4)) 
                                                          (quote (#:key)) 
                                                          (#%app list Type-seq3)
                                                          temp1 <2)))) 
                                   
                                   
                                   (#%app make-Values 
                                          (#%app list 
                                                 (#%app make-Result 
                                                        (#%app make-Vector 
                                                               (#%app make-Base 
                                                                      (quote Flonum) (quote-syntax inexact-real?))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top)) 
                                                        (#%app make-Empty)) 
                                                 (#%app make-Result 
                                                        (#%app make-Union 
                                                               (let-values 
                                                                   (((procedure) sort) 
                                                                    ((temp4) (#%app list 
                                                                                    (#%app make-Base
                                                                                           (quote Exact-Positive-Integer) 
                                                                                           (quote-syntax exact-positive-integer?)) 
                                                                                    (#%app make-Value (quote 0)))) ((<5) <) ((Type-seq6) Type-seq)) 
                                                                 (#%app (#%app 
                                                                         checked-procedure-check-and-extract 
                                                                         struct:keyword-procedure 
                                                                         procedure 
                                                                         keyword-procedure-extract 
                                                                         (quote (#:key)) 
                                                                         (quote 4)) 
                                                                        (quote (#:key)) 
                                                                        (#%app list Type-seq6) 
                                                                        temp4 
                                                                        <5))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top)) 
                                                        (#%app make-Empty)))) 
                                   (quote #f) (quote #f) (quote ()))))) 
       (#%app values))) 
   (#%app void)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; expansion by Racket v5.1
(module sum_kernel suda 
  (#%module-begin 
   (define-values () (begin (quote-syntax (:-internal cpyTestDrv_kernel ((Vectorof Float) Exact-Nonnegative-Integer -> (values (Vectorof Float) Exact-Nonnegative-Integer)))) (#%plain-app values))) 
   (define-values (cpyTestDrv_kernel) (lambda (array_in sgl_in) (#%app values array_in (quote 100)))) 
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
                                                        (let-values 
                                                            (((procedure) sort) 
                                                             ((temp1) (#%app list 
                                                                             -FlonumPosZero
                                                                             -FlonumNegZero
                                                                             -FlonumNan 
                                                                             -PosFlonum
                                                                             -NegFlonum))
                                                             ((<2) <) ((Type-seq3) Type-seq))
                                                          (#%app (#%app
                                                                  checked-procedure-check-and-extract 
                                                                  struct:keyword-procedure 
                                                                  procedure
                                                                  keyword-procedure-extract
                                                                  (quote (#:key)) 
                                                                  (quote 4))
                                                                 (quote (#:key))
                                                                 (#%app list Type-seq3)
                                                                 temp1 <2))))
                                          (#%app make-Union 
                                                 (let-values 
                                                     (((procedure) sort) 
                                                      ((temp4) (#%app list 
                                                                      (#%app make-Value (quote 0)) 
                                                                      (#%app make-Value (quote 1))
                                                                      -Byte>1
                                                                      -PosIndexNotByte 
                                                                      -PosFixnumNotIndex 
                                                                      -PosIntNotFixnum)) 
                                                      ((<5) <) ((Type-seq6) Type-seq)) 
                                                   (#%app (#%app 
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
                                                                                   ((temp7) (#%app list 
                                                                                                   -FlonumPosZero
                                                                                                   -FlonumNegZero
                                                                                                   -FlonumNan
                                                                                                   -PosFlonum
                                                                                                   -NegFlonum)) 
                                                                                   ((<8) <) ((Type-seq9) Type-seq))
                                                                        (#%app (#%app
                                                                                checked-procedure-check-and-extract
                                                                                struct:keyword-procedure 
                                                                                procedure 
                                                                                keyword-procedure-extract 
                                                                                (quote (#:key)) 
                                                                                (quote 4))
                                                                               (quote (#:key))
                                                                               (#%app list Type-seq9)
                                                                               temp7 <8)))) 
                                                        (#%app make-FilterSet (#%app make-Top) (#%app make-Top))
                                                        (#%app make-Empty)) 
                                                 (#%app make-Result 
                                                        (#%app make-Union 
                                                               (let-values (((procedure) sort)
                                                                            ((temp10) (#%app list 
                                                                                             (#%app make-Value 
                                                                                                    (quote 0))
                                                                                             (#%app make-Value
                                                                                                    (quote 1))
                                                                                             -Byte>1
                                                                                             -PosIndexNotByte
                                                                                             -PosFixnumNotIndex
                                                                                             -PosIntNotFixnum))
                                                                            ((<11) <) 
                                                                            ((Type-seq12) Type-seq))
                                                                 (#%app (#%app checked-procedure-check-and-extract
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
                                   (quote #f) (quote #f) (quote ())))))
       (#%app values)))
   (#%app void)))

