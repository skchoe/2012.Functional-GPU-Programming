/*
 * main.cu
 *
 *  Created on: Feb 20, 2012
 *      Author: skchoe
 */
#include <stdio.h>
#include <cuda.h>
#include <sm_11_atomic_functions.h>
#include <device_launch_parameters.h>

#include <cutil.h>

typedef unsigned char byte;

#define WARP_WIDTH 16
#define W 256
#define H 1




__global__ void kernel_shdatm(int* in, long int* n, int* out)
{
	int j = threadIdx.x + blockDim.x * blockIdx.x;
	__shared__ int shd[WARP_WIDTH];
	//shd[threadIdx.x] = in[j];
	//__syncthreads();

	long int i;
	for(i=0;i<*n;i++){
	  //atomicAdd((int*)&(shd[threadIdx.x]), i );
      shd[threadIdx.x] = 0;
	}

	out[j] =shd[threadIdx.x];
	//__syncthreads();
	return;
}

__global__ void kernel_glbatm(int* in, long int *n, int* out)
{
	int j = threadIdx.x + blockDim.x * blockIdx.x;
	long int i,k;
	for(i=0;i<*n;i++) {
	  //atomicAdd((int*)&(out[j]), i);
	  out[j] = 0;
	}
	//__syncthreads();
	return;
}

int main(int argc, char** argv)
{
	int i;
	int const_dim = W*H;
	size_t memsz = sizeof(int) * const_dim; // byte

	long int n = 100000000000;

	// one memory alloc
	int* in = (int*)malloc(memsz);
//    printf("in-\n");
//    for(i=0;i<W;i++){
//    	in[i]= 0;
//    	printf("%d(%d)\t", i, in[i]);
//    }
//    printf("\n");

    ////////////////////////////////////////////
//    cudaEvent_t startg, stopg;
//    cudaEventCreate(&startg);
//    cudaEventCreate(&stopg);
    long int  *ng;

    cudaMalloc(&ng, sizeof(long int));
    cudaMemcpy(ng, (const void*)&n, sizeof(long int), cudaMemcpyHostToDevice);


    unsigned int timerg = 0;
    cutCreateTimer(&timerg);
    cutResetTimer(timerg);
	cutStartTimer(timerg);

//    cudaEventRecord(startg, 0);

    int* g_ing;
        cudaMalloc((void**) &g_ing, memsz);
        cudaMemcpy((void*)g_ing, in, memsz, cudaMemcpyHostToDevice);

        int* g_outg;
        cudaMalloc((void**) &g_outg, memsz);
        cudaMemcpy((void*)g_outg, in, memsz, cudaMemcpyHostToDevice);

        kernel_glbatm<<<W/WARP_WIDTH, WARP_WIDTH>>>(g_ing, ng, g_outg);

        int* outg = (int*)malloc(memsz);
        cudaMemcpy(outg, g_outg, memsz, cudaMemcpyDeviceToHost);

        cudaThreadSynchronize();

//    cudaEventRecord(stopg, 0);
    cutStopTimer(timerg);

//    float gpu_timeg = 0.0f;
//    cudaEventElapsedTime(&gpu_timeg, startg, stopg);
//    cudaEventDestroy(startg);
//    cudaEventDestroy(stopg);
//    printf("gpu time glb %.9f.\n", gpu_timeg);
float tvg = cutGetTimerValue(timerg);
printf("gpu time glb(%l): %f (ms)\n", n, tvg);
cutDeleteTimer(timerg);




    ///////////////////////////////////////
//cudaEvent_t starts, stops;
//cudaEventCreate(&starts);
//cudaEventCreate(&stops);

unsigned int timers = 0;
cutCreateTimer(&timers);
cutResetTimer(timers);
cutStartTimer(timers);

//cudaEventRecord(starts, 0);

int* g_in;
    cudaMalloc((void**) &g_in, memsz);
    cudaMemcpy((void*)g_in, in, memsz, cudaMemcpyHostToDevice);

    int* g_out;
    cudaMalloc((void**) &g_out, memsz);
    cudaMemcpy((void*)g_out, in, memsz, cudaMemcpyHostToDevice);


    kernel_shdatm<<<W/WARP_WIDTH, WARP_WIDTH>>>(g_in, ng, g_out);


    int* outs = (int*)malloc(memsz);
    cudaMemcpy(outs, g_out, memsz, cudaMemcpyDeviceToHost);

    cudaThreadSynchronize();

//cudaEventRecord(stops, 0);
cutStopTimer(timers);

//float gpu_times = 0.0;
//cudaEventElapsedTime(&gpu_times, starts, stops);
//cudaEventDestroy(starts);
//cudaEventDestroy(stops);
//printf("gpu time shd %f.\n", gpu_times);
float tvs = cutGetTimerValue(timers);
printf("gpu time shd(%d): %f (ms)\n", n, tvs);
cutDeleteTimer(timers);


float ratio = tvs / tvg * 100;
printf("shd/global (percent): %f %\n", ratio);
/*
    printf("out-\n");
    for(i=0;i<W;i++)
    	printf("%d(%d)\t", i, outg[i]);
    printf("\n");
*/

	return 0;
}
