(module vector_types_h mzscheme 
  (require scheme/foreign
           "host_defines_h.ss")

(provide (all-defined))
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
  _byte
;/*DEVICE_BUILTIN*/
(define-cstruct _char1
  ([x _byte]))

;/*DEVICE_BUILTIN*/
(define-cstruct _uchar1
  ([x _ubyte]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _char2
  ([x _byte]
  [y _byte]))

;/*DEVICE_BUILTIN*/
(define-cstruct _uchar2
  ([x _ubyte]
   [y _ubyte]))

;/*DEVICE_BUILTIN*/
(define-cstruct _char3
  ([x _byte]
   [y _byte]
   [z _byte]))

;/*DEVICE_BUILTIN*/
(define-cstruct _uchar3
  ([x _ubyte]
   [y _ubyte]
   [z _ubyte]))

;/*DEVICE_BUILTIN*/
(define-cstruct _char4
  ([x _byte]
   [y _byte]
   [z _byte]
   [w _byte]))

;/*DEVICE_BUILTIN*/
(define-cstruct _uchar4
  ([x _ubyte]
   [y _ubyte]
   [z _ubyte]
   [w _byte]))

;/*DEVICE_BUILTIN*/
(define-cstruct _short1
  ([x _short]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _ushort1
  ([x _ushort]))

;/*DEVICE_BUILTIN*/
(define-cstruct _short2
  ([x _short]
   [y _short]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _ushort2
  ([x _ushort]
   [y _ushort]))

;/*DEVICE_BUILTIN*/
(define-cstruct _short3
  ([x _short]
   [y _short]
   [z _short]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _ushort3
  ([x _ushort]
   [y _ushort]
   [z _ushort]))

;/*DEVICE_BUILTIN*/
(define-cstruct _short4
  ([x _short]
   [y _short]
   [z _short]
   [w _short]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _ushort4
  ([x _ushort]
   [y _ushort]
   [z _ushort]
   [w _ushort]))

;/*DEVICE_BUILTIN*/
(define-cstruct _int1
  ([x _int]))
  
(define-cstruct _uint1
  ([x _uint]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _int2
  ([x _int]
   [y _int]))
  
(define-cstruct _uint2
  ([x _uint]
   [y _uint]))

;/*DEVICE_BUILTIN*/
(define-cstruct _int3
  ([x _int]
   [y _int]
   [z _int]))
  
(define-cstruct _uint3
  ([x _uint]
   [y _uint]
   [z _uint]))

;/*DEVICE_BUILTIN*/
(define-cstruct _int4
  ([x _int]
   [y _int]
   [z _int]
   [w _int]))
  
(define-cstruct _uint4
  ([x _uint]
   [y _uint]
   [z _uint]
   [w _uint]))

;/*DEVICE_BUILTIN*/
(define-cstruct _long1
  ([x _long]))
  
(define-cstruct _ulong1
  ([x _ulong]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _long2
  ([x _long]
   [y _long]))
  
(define-cstruct _ulong2
  ([x _ulong]
   [y _ulong]))

;/*DEVICE_BUILTIN*/
(define-cstruct _long3
  ([x _long]
   [y _long]
   [z _long]))
  
(define-cstruct _ulong3
  ([x _ulong]
   [y _ulong]
   [z _ulong]))

;/*DEVICE_BUILTIN*/
(define-cstruct _long4
  ([x _long]
   [y _long]
   [z _long]
   [w _long]))
  
(define-cstruct _ulong4
  ([x _ulong]
   [y _ulong]
   [z _ulong]
   [w _ulong]))

;/*DEVICE_BUILTIN*/
(define-cstruct _float1
  ([x _float]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _float2
  ([x _float]
   [y _float]))
 
;/*DEVICE_BUILTIN*/
(define-cstruct _float3
  ([x _float]
   [y _float]
   [z _float]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _float4
  ([x _float]
   [y _float]
   [z _float]
   [w _float]))
    
;/*DEVICE_BUILTIN*/
(define-cstruct _double1
  ([x _double]))
  
;/*DEVICE_BUILTIN*/
(define-cstruct _double2
  ([x _double]
   [y _double]))

#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
;/*DEVICE_BUILTIN*/
(provide _dim3)
(define-cstruct _dim3
  ([x _uint]
   [y _uint]
   [z _uint]))

;(define (uint3)
;  (make-dim3 0 0 0))
)