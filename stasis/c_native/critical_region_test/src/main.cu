/*
 * main.cu
 *
 *  Created on: Feb 23, 2012
 *      Author: u0332192
 */

// input = n x n w/ element are row number
// output = n x n w/ element filled in parallel

#include <stdio.h>
#include <time.h>

#include <cuda.h>
#include <cutil.h>
#include <sm_11_atomic_functions.h>

__device__ unsigned int* shared_part(unsigned int th, unsigned int spart_width,
		int block_width, int block_idx)
{
	extern __shared__ unsigned int s_lock_nums[];
	unsigned int offset = (th * spart_width) + (block_idx * block_width);
	return (unsigned int*) (s_lock_nums + offset);
}


// need to fit var_lock, var_nums in shared memory.
__global__ void gaddx(int* w, int* h, unsigned int* spart_width, unsigned long* gin, unsigned int* var_lock, unsigned int* var_nums, unsigned long* gout)
{
	// Shared Memory setting
	unsigned int* s_lock = shared_part(0, *spart_width, blockDim.x, blockIdx.x);
	unsigned int* s_nums = shared_part(1, *spart_width, blockDim.x, blockIdx.x);

	unsigned int i;
	for(i=0;i<*spart_width;i++) {
		s_lock[i] = var_lock[blockIdx.x * *spart_width + i];
		s_nums[i] = var_nums[blockIdx.x * *spart_width + i];
	}

	__syncthreads();

	// copy by threads.
	int x = threadIdx.x + blockDim.x * blockIdx.x;
	int y = threadIdx.y + blockDim.y * blockIdx.y;

	int k = x + y * *w;

	while( atomicCAS(&(s_lock[x]), 0, 1) != 0 );
//	gout[k] = gin[k];
	gout[s_nums[x] + y * *w] = gin[k];
	s_nums[x]++;

	atomicExch(&(s_lock[x]), 0);

	return;
}

void addx(int w, int h, int amt, unsigned long* gin, unsigned long* gout)
{
	int i,j,k;
	for(j=0;j<h;j++) {
		for(i=0;i<w;i++) {
			int k = i + j * w;
			gout[k] = gin[k];
		}
	}
	return;
}

int sharedMemory()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.sharedMemPerBlock;
}


// return pointer to array of x y z.
int* max_grid()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.maxGridSize;
}

int main(int argc, char** argv)
{
	int i, j, k;

	unsigned int W =  16;//16; // W x W is maximum allowable number of threads.
	unsigned int scale = 1000;//50

	int sW = scale*W; // similar to num_var

	int amt = 1;

	size_t sz = sizeof(unsigned long) * sW * sW;
	size_t sz1 = sizeof(unsigned long) * sW;

	unsigned long* pinput = (unsigned long*) malloc (sz);
	for(i=0;i<sW;i++) // height
		for(j=0;j<sW;j++){ //width
			k = j + i*sW;
			pinput[k] = i;
		}

	unsigned long* poutput = (unsigned long*) malloc(sz);

	// begin cpu time check
	clock_t tv_start = clock();

    addx(sW, sW, amt, pinput, poutput);

	clock_t tv_stop = clock();
	double dateclock_diff_ms = (double)(tv_stop - tv_start) * 1000. / CLOCKS_PER_SEC;

	printf("elapsed time for cpu:%e (%f)(ms)\n", dateclock_diff_ms, dateclock_diff_ms);

	//begin gpu timer
    unsigned int timerg = 0;
    cutCreateTimer(&timerg);
    cutResetTimer(timerg);
	cutStartTimer(timerg);

	int SHD_CAP = sharedMemory();

	int num_shdmem_item = 2; // var_lock, var_nums (integers)
	if(SHD_CAP  <= 2 * sW * sizeof(int))
		printf("shared memory is too small(%d byte) to be fit for num_var\n", SHD_CAP);
	else
		printf("shared memory is can contain num_var (%d bytes)\n", SHD_CAP);

	dim3 GRID_DIM = dim3(sW/W, sW/W);
	dim3 NUM_THREAD = dim3(W, W);

	int SHD_NEED = sizeof(int) * (W + W); // one W: var_lock, the other W: var_nums.
	if(SHD_CAP  <= SHD_NEED)
		printf("shared memory (lock+nums) is too small(%d byte) to be fit for num_var\n", SHD_NEED);
	else
		printf("shared memory (lock+nums) is can contain num_var (%d bytes)\n", SHD_NEED);

	// gpu struct
	unsigned long* pginput;
	cudaMalloc(&pginput, sz);
	cudaMemcpy(pginput, pinput, sz, cudaMemcpyHostToDevice);

	unsigned long* pgoutput;
	cudaMalloc(&pgoutput, sz);

	// lock for each column
	size_t var_sz = sW * sizeof(unsigned int);
	unsigned int* gvar_lock;
	cudaMalloc(&gvar_lock, var_sz);
	cudaMemset(gvar_lock, 0, var_sz);

	unsigned int* gvar_nums;
	cudaMalloc(&gvar_nums, var_sz);
	cudaMemset(gvar_nums, 0, var_sz);

	gaddx<<<GRID_DIM, NUM_THREAD, SHD_NEED>>>(&sW, &sW, &W, pginput, gvar_lock, gvar_nums, pgoutput);

	cudaMemcpy(poutput, pgoutput, sz, cudaMemcpyDeviceToHost);

    cutStopTimer(timerg);

    double tvg = cutGetTimerValue(timerg);
    printf("gpu time glb(-scale:%d): %e (%f)(ms)\n", scale, tvg, tvg);
    cutDeleteTimer(timerg);


    printf("diff: cpu-gpu:%e, percentage gpu/cpu:%f\n",
    		dateclock_diff_ms - timerg,
    		(double)timerg / (double)dateclock_diff_ms);
//
//	int sum_cpu = 0;
//	for(i=0;i< sW;i++)
//		sum_cpu += poutput[i];
//    for(i=0;i< sW;i++)
//    	printf("[%d]%d, ", i, poutput[i]);
//
//	printf("\n sum of all output (cpu) = %d\n", sum_cpu);
//
//	int sum_gpu = 0;
//	for(j=0;j< sW;j++)
//		sum_gpu += poutput[j];
//
//    for(j=0;j< sW;j++)
//    	printf("[%d]%d, ", j, poutput[j]);
//
//    printf("\n sum of all output (gpu) = %d\n", sum_gpu);
//
//
////	int i,j, k;
////	for(i=0;i<sW;i++) {
////		for(j=0;j<sW;j++){
////			k= j + i * sW;
////			printf("%d,%d => %d\n", i,j,poutput[k]);
////		}
////	}

	return 0;
}
