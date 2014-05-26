(module host_defines_h mzscheme
(require scheme/foreign)
  
(unsafe!)

(unless (or 
         (equal? (system-type) 'unix)
         (equal? (system-type) 'windows))
  (error "unsupported compiler: neither window nor unix\n"))

#|
(when
#if defined(__GNUC__)

#define __noinline__ \
        __attribute__((noinline))
#define __align__(n) \
        __attribute__((aligned(n)))
#define __thread__ \
        __thread
#define __import__
#define __export__
#define __location__(a) \
        __loc__(__attribute__((a)))
#define CUDARTAPI

#else /* __GNUC__ */

#define __inline__ \
        __inline
#define __noinline__ \
        __declspec(noinline)
#define __align__(n) \
        __declspec(align(n))
#define __thread__ \
        __declspec(thread)
#define __import__ \
        __declspec(dllimport)
#define __export__ \
        __declspec(dllexport)
#define __location__(a) \
        __loc__(__declspec(a))
#define CUDARTAPI \
        __stdcall

#endif /* __GNUC__ */

#if defined(__CUDACC__) || defined(__CUDABE__)

#define __loc__(a) \
        a
#define __builtin_align__(a) \
        __align__(a)

#else /* __CUDACC__ || __CUDABE__ */

#define __loc__(a)
#define __builtin_align__(a)

#endif /* __CUDACC__ || __CUDABE__ */

#define __device__ \
        __location__(__device__)
#define __host__ \
        __location__(__host__)
#define __global__ \
        __location__(__global__)
#define __shared__ \
        __location__(__shared__)
#define __constant__ \
        __location__(__constant__)
#define __launch_bounds__(t, b) \
        __location__(__launch_bounds__(t, b))

#endif /* !__HOST_DEFINES_H__ */
|#
  )