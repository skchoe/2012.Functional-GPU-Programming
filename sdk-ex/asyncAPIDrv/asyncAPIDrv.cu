// -*- c++ -*-
#include <stdio.h>
#include <cuda.h>
#include <cutil.h>

/*
(: increment_kernel ((Listof Integer) Integer -> (Listof Integer)))
(define (increment_kernel lin inc_value)
  (map (lambda (x) (+ inc_value x)) lin))

*/

#define ALIGN_UP(offset, alignment) (offset) = ((offset) + (alignment) - 1) & ~((alignment) - 1)


extern "C"
__global__ void increment_kernel(int *g_data, int N, int *go_data, int* No, int inc_value)
{
   int idx = blockIdx.x * blockDim.x + threadIdx.x;

   *No = N;
   if(idx < N) go_data[idx] = g_data[idx] + inc_value;
}

int correct_output(int *data, const int n, const int x)
{
    for(int i = 0; i < n; i++) {
	if(i==n-1) printf ("correct_output-%d:[%d]%d, w/val:%d\n", n, i, data[i], x);
        if(data[i] != x)
            return 0;
    }
    return 1;
}

////////////////////////////////////////////////////////////////////////////////
//! Init for CUDA
////////////////////////////////////////////////////////////////////////////////
static CUresult
initCuda(CUfunction *pKernel, 
	int argc, char** argv)
{
    CUdevice cuDevice = 0;
    CUcontext cuContext;
    CUmodule cuModule;    
    CUfunction cuFunction = 0;

    CUT_DEVICE_INIT_DRV(cuDevice, argc, argv);

    CUdevprop dp;
    cuDeviceGetProperties(&dp, cuDevice);
    int a[3];
    a[0] = dp.maxThreadsDim[0];
    a[1] = dp.maxThreadsDim[1];
    a[2] = dp.maxThreadsDim[2];
    printf("cuDevice prop:Max threads = %d, %d, %d\n", a[0], a[1], a[2]);

    CUresult status = cuCtxCreate( &cuContext, 0, cuDevice );
    printf ("Ctx Creation: %d\n", status);
    if ( CUDA_SUCCESS != status )
    {    
      cuCtxDetach(cuContext);
      return status;
    }

    status = cuModuleLoad(&cuModule, "data/asyncAPIDrv.sm_10.cubin");
    printf ("ModuleLoad: %d\n", status);

//    cutFree(module_path);
    if ( CUDA_SUCCESS != status )
    {    
      cuCtxDetach(cuContext);
      return status;
    } 

    // Global function
    status = cuModuleGetFunction( &cuFunction, cuModule, "increment_kernel" );
    printf("function loading: %d\n", status);
    if ( CUDA_SUCCESS != status)
    {    
      cuCtxDetach(cuContext);
      return status;
    }     

    *pKernel = cuFunction;

    return CUDA_SUCCESS;
}

int main(int argc, char *argv[])
{
    CUfunction kernel = NULL;
    CU_SAFE_CALL(initCuda(&kernel, argc, argv));

    int n = 16 * 1024 * 1024;
    int nbytes = n * sizeof(int);
    int value = 26;

    printf("Initial length of array :%d\n", n);


    // allocate host memory
    int init_value = 1;

    int *a = NULL;
    CU_SAFE_CALL(cuMemAllocHost((void**)&a, nbytes));
    //a = (int*)malloc(nbytes);
    for(int i=0 ; i < n ; i++)
      a[i] = init_value;
    //memset(a, 0, nbytes);

    int* A = NULL;
    CU_SAFE_CALL(cuMemAllocHost((void**)&A, nbytes));
    //A = (int*)malloc(nbytes);
    memset(A, 0, nbytes);

    int* oN = NULL;
    CU_SAFE_CALL(cuMemAllocHost((void**)&oN, sizeof(int)));
    //oN = (int*)malloc(sizeof(int));
    memset(oN, 0, sizeof(int));

    CUstream strm;
    cuStreamCreate(&strm, 0);
/*
printf("Free host mem = %d, %d, %c: \n", n-1, sizeof(int), a[n-1]);
printf("Free host mem = %d: \n", cuMemFreeHost(a));
*/
    // allocate device memory
    CUdeviceptr d_a;
    CU_SAFE_CALL( cuMemAlloc(&d_a, nbytes));
    CU_SAFE_CALL( cuMemsetD32(d_a, 255, n));

    // alloc dev mem for return
    CUdeviceptr do_a;
    CU_SAFE_CALL( cuMemAlloc(&do_a, nbytes));
    CU_SAFE_CALL( cuMemsetD32(do_a, 255, n));

    // alloc dev mem for length of return
    CUdeviceptr o_n;
    CU_SAFE_CALL( cuMemAlloc(&o_n, sizeof(int)));
    CU_SAFE_CALL( cuMemsetD32(o_n, 255, 1));

    // create cuda event handles
    CUevent start, stop;
    CU_SAFE_CALL( cuEventCreate(&start, 0) );
    CU_SAFE_CALL( cuEventCreate(&stop, 0)  );

    unsigned int timer;
    CUT_SAFE_CALL(  cutCreateTimer(&timer)  );
    CUT_SAFE_CALL(  cutResetTimer(timer)    );
    CU_SAFE_CALL( cuCtxSynchronize() );
    float gpu_time = 0.0f;

    // asynchronously issue work to the GPU (all to stream 0)
    CUT_SAFE_CALL( cutStartTimer(timer) );
        cuEventRecord(start, 0);

      printf("memcpy H to D 1= %d\n", cuMemcpyHtoDAsync(d_a, a, nbytes, 0));

      int offset = 0;
      void* ptr;
      ptr = (void*)(size_t)d_a;
      ALIGN_UP(offset, __alignof(ptr));
      printf("1. device array set = %d, offset = %d\n", cuParamSetv(kernel, offset, &ptr, sizeof(ptr)), offset);
      offset += sizeof(void*);

      ALIGN_UP(offset, __alignof(n));
      printf("2. array size set = %d, offset = %d\n", cuParamSeti(kernel, offset, n), offset);
      offset += sizeof(int);

      ptr = (void*)(size_t)do_a;
      ALIGN_UP(offset, __alignof(ptr));
      printf("3. return dev addr set= %d, offset = %d\n", cuParamSetv(kernel, offset, &ptr, sizeof(ptr)), offset);
      offset += sizeof(void*);

      ptr = (void*)(size_t)o_n;
      ALIGN_UP(offset, __alignof(ptr));
      printf("4. return length addr set= %d, offset = %d\n", cuParamSetv(kernel, offset, &ptr, sizeof(ptr)), offset);
      offset += sizeof(void*);

      ALIGN_UP(offset, __alignof(value));
      printf("5. value set: %d, offset = %d\n", cuParamSeti(kernel, offset, value), offset);
      offset += sizeof(int);

      printf("6. param setisze set:%d, offset = %d\n", cuParamSetSize(kernel, offset), offset);

      printf("setblock = %d\n", cuFuncSetBlockShape(kernel, 512, 1, 1));

      printf("Launching kernel = %d\n", cuLaunchGrid(kernel, n/512, 1));

      printf("DtoH copy:%d\n", cuMemcpyDtoHAsync(A, do_a, nbytes, strm));
      //printf("DtoH copy:%d\n", cuMemcpyDtoH(A, do_a, nbytes));

      printf ("Fetching array length = %d\n", cuMemcpyDtoHAsync(oN, o_n, sizeof(int), strm));
      //printf ("Fetching array length = %d\n", cuMemcpyDtoH(oN, o_n, sizeof(int)));

      cuEventRecord(stop, 0);

    CUT_SAFE_CALL( cutStopTimer(timer) );

    // have CPU do some work while waiting for stage 1 to finish
    int counter = 0;
    while( cuEventQuery(stop) == CUDA_ERROR_NOT_READY )
    {
        counter++;
	//printf("stop? = %d\n", cuEventQuery(stop));

    }
    printf("stop finally? = %d\n", cuEventQuery(stop));
    CU_SAFE_CALL( cuEventElapsedTime(&gpu_time, start, stop));

    cuStreamSynchronize(strm);
    printf ("Output array length = %d\n", *oN);

    // print the cpu and gpu times
    printf("time spent executing by the GPU: %.2f\n", gpu_time);
    printf("time spent by CPU in CUDA calls: %.2f\n", cutGetTimerValue(timer) );
    printf("CPU executed %d iterations while waiting for GPU to finish\n", counter);

    // check the output for correctness
    printf("--------------------------------------------------------------\n");
    if( correct_output(A, n, init_value + value) )
        printf("Test PASSED\n");
    else
        printf("Test FAILED\n");


/*
      for(int i = 0 ; i < n ; i++)
      printf ("[%d]%d\t", i, A[i]);
      printf ("\n");
      */

    // release resources

    CU_SAFE_CALL( cuStreamDestroy(strm));
    CU_SAFE_CALL( cuEventDestroy(start) );
    CU_SAFE_CALL( cuEventDestroy(stop) );
    CU_SAFE_CALL( cuMemFreeHost(a) );
    CU_SAFE_CALL( cuMemFreeHost(A) );
    CU_SAFE_CALL( cuMemFreeHost(oN) );
    //free(oN);
    CU_SAFE_CALL( cuMemFree(d_a) );

    CUT_EXIT(argc, argv);

    return 0;
}
