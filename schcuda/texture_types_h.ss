(module texture_types_h mzscheme
  (require scheme/foreign
           "channel_descriptor_h.ss")
  (unsafe!)
  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
  
;/*DEVICE_BUILTIN*/
;struct cudaArray;
(provide _cudaArray)
(define _cudaArray _pointer);(_cpointer 'cudaArray))
(provide _cudaArray-ptr)
(define _cudaArray-ptr _pointer);(_ptr o _cudaArray))


;/*DEVICE_BUILTIN*/
(provide _cudaChannelFormatKind)
(define _cudaChannelFormatKind
  (_enum
    '(cudaChannelFormatKindSigned
      cudaChannelFormatKindUnsigned
      cudaChannelFormatKindFloat)))

;/*DEVICE_BUILTIN*/
(provide _cudaChannelFormatDesc)
(define-cstruct _cudaChannelFormatDesc
  ([x _int]
   [y _int]
   [z _int]
   [w _int]
   [f _cudaChannelFormatKind]))
(provide _cudaChannelFormatDesc-ptr)
(define _cudaChannelFormatDesc-ptr (_ptr o _cudaChannelFormatDesc))

;/*DEVICE_BUILTIN*/
(provide _cudaTextureAddressMode)
(define _cudaTextureAddressMode
  (_enum
    '(cudaAddressModeWrap
      cudaAddressModeClamp)))

;/*DEVICE_BUILTIN*/
(provide _cudaTextureFilterMode)
(define _cudaTextureFilterMode
  (_enum
    '(cudaFilterModePoint
      cudaFilterModeLinear)))

;/*DEVICE_BUILTIN*/
(provide _cudaTextureReadMode)
(define _cudaTextureReadMode
  (_enum
   '(cudaReadModeElementType
     cudaReadModeNormalizedFloat)))
  
;/*DEVICE_BUILTIN*/
(provide _textureReference)
(define-cstruct _textureReference
  ([normalized _int]
   [filterMode _cudaTextureFilterMode]
   [addressMode _pointer];enum cudaTextureAddressMode   addressMode[2];
   [channelDesc _cudaChannelFormatDesc]))

  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#
(define (_texture-type type norm fMode aMode)
  (let ([aMode-ptr (malloc _cudaTextureAddressMode 2)])
    (ptr-set! aMode-ptr _cudaTextureAddressMode 0 aMode)
    (ptr-set! aMode-ptr _cudaTextureAddressMode 1 aMode)
    
    (make-textureReference norm fMode aMode-ptr (cudaCreateChannelDesc type))))
  
(define (_texture norm fMode aMode desc)
  (let ([aMode-ptr (malloc _cudaTextureAddressMode 2)])
    (ptr-set! aMode-ptr _cudaTextureAddressMode 0 aMode)
    (ptr-set! aMode-ptr _cudaTextureAddressMode 1 aMode)
    
    (make-textureReference norm fMode aMode-ptr desc)))

  )
