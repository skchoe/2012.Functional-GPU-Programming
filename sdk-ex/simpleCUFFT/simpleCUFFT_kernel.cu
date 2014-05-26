/* Example showing the use of CUFFT for fast 1D-convolution using FFT. -KERNEL part separated from original source*/

#include <vector_types.h>

// Complex data type
typedef float2 Complex; 
static __device__ inline Complex ComplexScale(Complex, float);
static __device__ __host__ inline Complex ComplexMul(Complex, Complex);

extern "C"
// Complex pointwise multiplication
// Note the static function cannot be applicable to extern "C"
/*static*/ __global__ void ComplexPointwiseMulAndScale(Complex* a, const Complex* b, int size, float scale)
{
    const int numThreads = blockDim.x * gridDim.x;
    const int threadID = blockIdx.x * blockDim.x + threadIdx.x;
    for (int i = threadID; i < size; i += numThreads)
        a[i] = ComplexScale(ComplexMul(a[i], b[i]), scale);     
}

// The filter size is assumed to be a number smaller than the signal size
#define SIGNAL_SIZE        50
#define FILTER_KERNEL_SIZE 11

// Complex scale
static __device__ inline Complex ComplexScale(Complex a, float s)
{
    Complex c;
    c.x = s * a.x;
    c.y = s * a.y;
    return c;
}

// Complex multiplication
static __device__ __host__ inline Complex ComplexMul(Complex a, Complex b)
{
    Complex c;
    c.x = a.x * b.x - a.y * b.y;
    c.y = a.x * b.y + a.y * b.x;
    return c;
}
