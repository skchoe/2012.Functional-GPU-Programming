#lang suda
(require/typed racket/base 
               [build-list (Number (Number -> Any) -> (Listof Number))]
               [map ((Float -> Float) (Listof Float) -> (Listof Float))]) 
               

(: single-valued-ftn (-> Integer))
(define (single-valued-ftn) 1)


(: cpyTestDrv_kernel ((Listof Float) Integer Integer Integer -> (values (Listof Float) (Listof Integer) Integer)))
(define (cpyTestDrv_kernel l_fin num num-out iin)
  (values (map (lambda(x) (+ 200.200 x)) l_fin) (list 11 21 31) (+ 10000 iin)))


#|
void cpyTestDrv_kernel(float* l_fin, int num, int iin, float* l_fout, int* l_iout, int* iout)
{
  int i;
  for(i=0;i<num;i++)
  l_fout[i] = 200.200 + l_fin[i];

  l_iout[0] = 11;
  l_iout[1] = 21;
  l_iout[2] = 31;

  iout = 10000 + iin;

  return;
}
|#
(define inputlst (list 1.0 2.0))
(cpyTestDrv_kernel inputlst (length inputlst) 3 12345)


;;;test void kernel
;(: cpyTestDrv_kernel_void ((Listof Float) Integer Integer (Listof Float) (Listof Integer) Integer -> Void))
;(define (cpyTestDrv_kernel_void l_fin num iin l_fout l_iout iout)
;  
;  
;  )