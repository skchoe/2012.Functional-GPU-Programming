// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <cuda.h>
#include <cutil.h>
#include <math_functions.h>

extern "C"
__global__ void
cpyTest(float* answer, int size, float cnst)
{
  int i=0;
  for(i=0;i<size;i++)
    answer[i] = i * cnst;
}

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main(int argc, char** argv)
{
    int sf = sizeof(float);
    int size = 1000;
    float scale = 2.3f;

    float* d_0;
    CUDA_SAFE_CALL(cudaMalloc( (void**) &d_0, sf * size));

    dim3 threads(1, 1);
    dim3 grids(1, 1);
    // Calling kernel
    cpyTest<<<grids, threads>>>(d_0, size, scale);


    float *h_0 = (float*)malloc(sf*size);
    CUDA_SAFE_CALL(cudaMemcpy(h_0, d_0, sf*size, cudaMemcpyDeviceToHost));

    int i;
    for(i=0;i<size;i++)
      printf("%dth answer = %f\n", i, h_0[i]);
    free(h_0);

    CUT_EXIT(argc, argv);
}
