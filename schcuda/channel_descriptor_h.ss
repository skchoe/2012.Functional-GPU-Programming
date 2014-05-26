(module channel_descriptor_h scheme
  (require scheme/foreign)
  
#|
/*******************************************************************************
*                                                                              *
*                                                                              *
*                                                                              *
*******************************************************************************/
|#

(unsafe!)

(provide cudaCreateChannelDesc)
(define (cudaCreateChannelDesc type)
  (let* ([is (* (ctype-sizeof _int) 8)]
         [e (* (ctype-sizeof type) 8)]
         [s (malloc _int 4)])
    (when (<= e (* 4 * is))
      (for ([i (in-range 4)])
        (ptr-set! s i (if (> e is) is e))
        (set! e (if (> e is) (- e is) 0))))
    
    (cudaCreateChannelDesc (ptr-ref s 0)
                           (ptr-ref s 1)
                           (ptr-ref s 2)
                           (ptr-ref s 3)
                           'cudaChannelFormatKindUnsigned))) ; need a way to define cudaCreateChannelDesc with 'cudaChannelFormatKindSinged. or Float

(define __SINGED_CHARS__ #t)

;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<char1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uchar1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<char2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uchar2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<char3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uchar3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<char4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uchar4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<short>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<unsigned short>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<short1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ushort1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<short2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ushort2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<short3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ushort3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<short4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ushort4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<int>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<unsigned int>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<int1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uint1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<int2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uint2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<int3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uint3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<int4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<uint4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<long>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<unsigned long>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<long1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ulong1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<long2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ulong2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<long3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ulong3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<long4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<ulong4>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<float>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<float1>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<float2>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<float3>(void)
;template<> __inline__ __host__ cudaChannelFormatDesc cudaCreateChannelDesc<float4>(void)
)
