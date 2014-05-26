#lang scheme/base
(require scheme/foreign)

(define context-lib
(ffi-lib "libCUcontext"))

(unsafe!)


(define _CUcontext (_cpointer 'CUcontext))
(define _pCUcontext (_ptr o _CUcontext))

(define attach
  (get-ffi-obj 'cuAttach
               context-lib
               (_fun (ctx : _CUcontext)
                     -> _void)
               (lambda () (printf "cuAttach: NOT found\n"))))

(define detach
  (get-ffi-obj 'cuDetach
               context-lib
               (_fun _CUcontext
                     -> _int)
               (lambda () (printf "cuDetach: NOT found\n"))))

(define create
  (get-ffi-obj 'cuCreate
               context-lib
               (_fun (ctx : _CUcontext)
                     -> _int
                     -> _void)
               (lambda () (printf "cuCreate: Not found\n"))))


(define elt (malloc _pCUcontext 
                    1 'raw))

(define goo (attach elt))
(define value (detach elt))
(printf "value = ~s\n" value)

#|
(define main

  CUcontext *ctx_store = (CUcontext*)malloc(num_pctx * sizeof(CUcontext));
  struct CUctx_st ca;
  ca.value = 100;
  CUcontext ccc = cuAttach(ctx_store, &ca);
  printf ("attach result = %d\n", ccc->value);

  //CUcontext cu = (CUcontext)malloc(sizeof (struct CUctx_st));
  //cu->value = 100;
  printf ("detach result = %d\n", cuDetach(ctx_store, ccc));
}
|#