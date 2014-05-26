#ifndef _MATRIXMUL_KERNEL_H_
#define _MATRIXMUL_KERNEL_H_

extern "C"
__global__ void
kernel(int* input, int* output)
{
    //int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int ix = threadIdx.x;
    int iy = threadIdx.y;
    int id = iy * blockDim.x + ix;

    int a = input[id];
    output[id] = a * 10;
}

#endif // #ifndef _MATRIXMUL_KERNEL_H_
