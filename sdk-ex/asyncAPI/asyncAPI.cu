#include <stdio.h>
#include <cutil.h>

extern "C"

__global__ void increment_kernel(int *g_data, int inc_value)
{ 
   int idx = blockIdx.x * blockDim.x + threadIdx.x;
   g_data[idx] = g_data[idx] + inc_value;
}

int correct_output(int *data, const int n, const int x)
{
    for(int i = 0; i < n; i++)
        if(data[i] != x)
            return 0;
    return 1;
}

int main(int argc, char *argv[])
{
    CUT_DEVICE_INIT(argc, argv);

    int n = 16 * 1024 * 1024;
    int nbytes = n * sizeof(int);
    int value = 26;

#ifdef __DEVICE_EMULATION__
    n = 1024;   // reduce workload for emulation
#endif
    
    // allocate host memory
    int *a = 0;
    CUDA_SAFE_CALL( cudaMallocHost((void**)&a, nbytes) );
    memset(a, 0, nbytes);

    // allocate device memory
    int *d_a=0;
    CUDA_SAFE_CALL( cudaMalloc((void**)&d_a, nbytes) );
    CUDA_SAFE_CALL( cudaMemset(d_a, 255, nbytes) );

    // set kernel launch configuration
    dim3 threads = dim3(512, 1);
    dim3 blocks  = dim3(n / threads.x, 1);

    // create cuda event handles
    cudaEvent_t start, stop;
    CUDA_SAFE_CALL( cudaEventCreate(&start) );
    CUDA_SAFE_CALL( cudaEventCreate(&stop)  );
    
    unsigned int timer;
    CUT_SAFE_CALL(  cutCreateTimer(&timer)  );
    CUT_SAFE_CALL(  cutResetTimer(timer)    );
    CUDA_SAFE_CALL( cudaThreadSynchronize() );
    float gpu_time = 0.0f;

    // asynchronously issue work to the GPU (all to stream 0)
    CUT_SAFE_CALL( cutStartTimer(timer) );
        cudaEventRecord(start, 0);
        cudaMemcpyAsync(d_a, a, nbytes, cudaMemcpyHostToDevice, 0);
        increment_kernel<<<blocks, threads, 0, 0>>>(d_a, value);
        cudaMemcpyAsync(a, d_a, nbytes, cudaMemcpyDeviceToHost, 0);
        cudaEventRecord(stop, 0);
    CUT_SAFE_CALL(cutStopTimer(timer) );

    printf("start status = %d\n", cudaEventQuery(start));
//    cudaThreadSynchronize();
    printf("stop status = %d\n", cudaEventQuery(stop));

    // have CPU do some work while waiting for stage 1 to finish
    unsigned long int counter=0;
    while( cudaEventQuery(stop) == cudaErrorNotReady )
    {
        counter++;
    }
   
    printf("counting finished: stop status = %d\n", cudaEventQuery(stop));
    CUDA_SAFE_CALL(cudaEventElapsedTime(&gpu_time, start, stop) );

    // print the cpu and gpu times
    printf("time spent executing by the GPU: %.2f\n", gpu_time);
    printf("time spent by CPU in CUDA calls: %.2f\n", cutGetTimerValue(timer) );
    printf("CPU executed %d iterations while waiting for GPU to finish\n", counter);

    // check the output for correctness
    printf("--------------------------------------------------------------\n");
    if( correct_output(a, n, value) )
        printf("Test PASSED\n");
    else
        printf("Test FAILED\n");

    // release resources
    CUDA_SAFE_CALL( cudaEventDestroy(start) );
    CUDA_SAFE_CALL( cudaEventDestroy(stop) );
    CUDA_SAFE_CALL( cudaFreeHost(a) );
    CUDA_SAFE_CALL( cudaFree(d_a) );

    CUT_EXIT(argc, argv);

    return 0;
}
