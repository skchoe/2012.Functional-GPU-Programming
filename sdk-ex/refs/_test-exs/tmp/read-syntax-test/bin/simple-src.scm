(module simple-src scheme
  
  (define blocksize 10)
  (define threadsize blocksize)
  
  (define (compute-main arg0 arg1 arg2)
    (+ arg0 (+ arg1 (add1 arg2))))
  
  (define (kernel)
    (let* ([arg0 1]
           [arg1 2]
           [arg2 3])
      
      (compute-main arg0 arg1 arg2)))

    (kernel)

  )




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

#| Expanded Syntax that cugen compiler recognizes.
top-level-form    = (module id name-id (#%module-begin module-level-form ...))

module-level-form = (define-values (id) expr)
                      
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
|#

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

