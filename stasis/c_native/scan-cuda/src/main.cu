/*
 * main.c
 *
 *  Created on: Mar 15, 2012
 *      Author: u0332192
 */

#include <cuda.h>
#include <cutil.h>

#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <device_functions.h>
#include <vector_types.h>


typedef unsigned char byte;
typedef unsigned long long ullong;

int64_t timespecDiffNano(struct timespec *timeA_p, struct timespec *timeB_p)
{
	return ((timeA_p->tv_sec * 1000000000) + timeA_p->tv_nsec) -
			((timeB_p->tv_sec * 1000000000) + timeB_p->tv_nsec);
}

// return pointer to array of x y z.
int* max_grid()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.maxGridSize;
}


__global__ void test (ullong* num_elt, ullong *elts, ullong* gsum)
{
	int g_id = threadIdx.x + blockDim.x * blockIdx.x;
	int b_id = threadIdx.x;

	int warp_size = 16;
	int i, n = blockDim.x / warp_size;

	*gsum = 155;

	__syncthreads();

	return;
}

// num_elt - number of elt in global memory
// elts array of elts
// gsum -storage in global memory for result of each block
/* Blelloch 1990
1:  for d = 0 to log_2^n – 1 do ;; d=0,1,2,3 if n=16
2:      for all k = 0 to (n – 1) by 2^(d+1) in parallel do (0, 2, 4, 8, as init pos), (1, 2, 4, 8: offsets)
3:           x[k] = x[k] + x[k + 2^d]
d=0 k:0,2,4,... (0,1),(2,3),(4,5),(6,7),(8,9),(10,11)...
d=1 k:0,4,8,... (0,2),      (4,6),      (8,10)
d=2 k:0,8,16,...(0,4),                  (8,16),
d=3 k:16,32,... (0,8),

For 1d block, it works
For 2d blocks, need to get block id considering gridDim.x
*/
__global__ void sum_kernel_ullong(ullong *num_elt, ullong *elts, ullong* num_block, ullong *gsum)
{
	int x = threadIdx.x + blockDim.x * blockIdx.x;
	int y = blockIdx.y;
	int g_id = x + blockDim.x * gridDim.x * y; // position in global memory
	int t_id = threadIdx.x;

	// position of block
	int bidx = blockIdx.x + y * gridDim.x;

	ullong local_num_elt = (*num_elt > 2 * blockDim.x)? 2 * blockDim.x : *num_elt;
	*num_block = *num_elt / local_num_elt;

	// sum block is out of the range of numblocks
	if(bidx < *num_block) {

		extern __shared__ ullong shds_ullong[];
		// 1 thread, 2 copy to shared memory
		shds_ullong[2 * t_id]     = elts[2 * g_id];
		shds_ullong[2 * t_id + 1] = elts[2 * g_id + 1];

		int i, from, to, offset = 1;
		for(i = local_num_elt >> 1; i > 0; i >>= 1) {
			__syncthreads();
			if(t_id < i) {
				from = offset * (2*t_id + 1) - 1;
				to   = offset * (2*t_id + 2) - 1;
				shds_ullong[to] += shds_ullong[from];
			}
			offset *= 2;
		}
		ullong result = shds_ullong[to];
		gsum[bidx] = result;
	}

	__syncthreads();

	return;
}

__global__ void sum_kernel_int32(int *num_elt, int *elts, int* num_block, int *gsum)
{
	int x = threadIdx.x + blockDim.x * blockIdx.x;
	int y = blockIdx.y;
	int g_id = x + blockDim.x * gridDim.x * y; // position in global memory
	int t_id = threadIdx.x;

	// position of block
	int bidx = blockIdx.x + y * gridDim.x;

	int local_num_elt = (*num_elt > 2 * blockDim.x)? 2 * blockDim.x : *num_elt;
	*num_block = *num_elt / local_num_elt;

	// sum block is out of the range of numblocks
	if(bidx < *num_block) {

		extern __shared__ int shds_int32[];
		// 1 thread, 2 copy to shared memory
		shds_int32[2 * t_id]     = elts[2 * g_id];
		shds_int32[2 * t_id + 1] = elts[2 * g_id + 1];

		int i, from, to, offset = 1;
		for(i = local_num_elt >> 1; i > 0; i >>= 1) {
			__syncthreads();
			if(t_id < i) {
				from = offset * (2*t_id + 1) - 1;
				to   = offset * (2*t_id + 2) - 1;
				shds_int32[to] += shds_int32[from];
			}
			offset *= 2;
		}
		int result = shds_int32[to];
		gsum[bidx] = result;
	}

	__syncthreads();

	return;
}

// num_elt : length of input array in cpu
// gnum_elt: pointer to length of input arary in gpu
// g_elts: pointer to the array in GPU
// output: pointer to array that contains the sum at the first location in GPU
ullong*
sum_gpu_kernel_ullong(ullong num_elt, ullong* gnum_elt, ullong* gelts)
{
	size_t sz_ull = sizeof(ullong);
	size_t sz_elts = sz_ull * num_elt;

	int i;
	ullong* gnum_block;
	cudaMalloc(&gnum_block, sz_ull);
	cudaMemset(gnum_block, 0, sz_ull);

    dim3 block1 = dim3 (min((double)512, (double)num_elt/2.0), 1); // 512 threads deals with 1024 data.
    int num_blk;
    num_blk = (num_elt > block1.x)? num_elt / (2 * block1.x): 1; // because each thread process 2 elements

	// return storage gsum
	size_t sz_gsum = sz_ull * num_blk;
	ullong *gsum;
	cudaMalloc(&gsum, sz_gsum);
	cudaMemset(gsum, 0, sz_gsum);

    unsigned int timerg_exe = 0;
    cutCreateTimer(&timerg_exe);
    cutResetTimer(timerg_exe);

	cutStartTimer(timerg_exe);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
    do {
//    	printf("--------------do-------------\nnumelt:%d\n", num_elt);
//    	ullong* tmpelt = (ullong*)malloc(sz_elts);
//    	cudaMemcpy(tmpelt, gelts, sz_elts, cudaMemcpyDeviceToHost);
//    	for(i=0;i<num_elt;i++)
//    		printf("tmpelt[%d] = %llu\n", i, tmpelt[i]);

        block1 = dim3 (min((double)512, (double)num_elt/2.0), 1); // 512 threads deals with 1024 data.
        num_blk = (num_elt > block1.x)? num_elt / (2 * block1.x): 1; // because each thread process 2 elements

        int* mxgrd = max_grid();
        printf("grid max = %d, %d blocks\n", mxgrd[0], mxgrd[1]);

        int gridx = (num_blk > mxgrd[0])? mxgrd[0] : num_blk;
        int gridy = (num_blk > mxgrd[0])? num_blk / mxgrd[0] + 1: 1;
        printf("num_blk:%d\n", num_blk);

        printf("grid dimension x, y = %d, %d\n", gridx, gridy);


        dim3 grid1 = dim3(gridx, gridy);
        size_t shds1 = 2 * block1.x * sizeof(ullong); // need factor 2 because a thread add 2 elements.

        printf("blockdim.x = %d threads, shd size = %d bytes\n", block1.x, shds1);

        // clear used location
		size_t sz_gsum = sz_ull * num_blk;

		// new grid, block, shds
		sum_kernel_ullong<<<grid1, block1, shds1>>>(gnum_elt, gelts, gnum_block, gsum);

		num_elt = num_blk;
		sz_elts = sz_gsum;

		// interchange:
		ullong* tmp_num_elt = gnum_elt;
		ullong* tmp_elts = gelts;

		gnum_elt = gnum_block;
		gelts = gsum;

		gnum_block = tmp_num_elt;
		gsum = tmp_elts;

//		// copy output by printing next inputs
//		ullong* cnum_elt = (ullong*)malloc(sz_ull);
//		cudaMemcpy(cnum_elt, gnum_elt, sz_ull, cudaMemcpyDeviceToHost);
//		printf("next - numelt:%d\n", *cnum_elt);

//		int i;
//		ullong* celts = (ullong*)malloc(sz_elts);
//		cudaMemcpy(celts, gelts, sz_elts, cudaMemcpyDeviceToHost);
//		for(i=0;i<(int)*cnum_elt;i++)
//			printf("%d th next elt:%llu\n", i, celts[i]);

	} while (num_blk != 1);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    cutStopTimer(timerg_exe);
    double tvg = cutGetTimerValue(timerg_exe);
    printf("gpu time glb(kernel):\n %e \n(%f)(ms)\n", tvg, tvg);

    cutDeleteTimer(timerg_exe);

	return gelts;
}

int*
sum_gpu_kernel_int32(int num_elt, int* gnum_elt, int* gelts)
{
	size_t sz_ull = sizeof(int);
	size_t sz_elts = sz_ull * num_elt;

	int i;
	int* gnum_block;
	cudaMalloc(&gnum_block, sz_ull);
	cudaMemset(gnum_block, 0, sz_ull);

    dim3 block1 = dim3 (min((double)512, (double)num_elt/2.0), 1); // 512 threads deals with 1024 data.
    int num_blk;
    num_blk = (num_elt > block1.x)? num_elt / (2 * block1.x): 1; // because each thread process 2 elements

	// return storage gsum
	size_t sz_gsum = sz_ull * num_blk;
	int *gsum;
	cudaMalloc(&gsum, sz_gsum);
	cudaMemset(gsum, 0, sz_gsum);

    unsigned int timerg_exe = 0;
    cutCreateTimer(&timerg_exe);
    cutResetTimer(timerg_exe);

	cutStartTimer(timerg_exe);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
    do {
//    	printf("--------------do-------------\nnumelt:%d\n", num_elt);
//    	int* tmpelt = (int*)malloc(sz_elts);
//    	cudaMemcpy(tmpelt, gelts, sz_elts, cudaMemcpyDeviceToHost);
//    	for(i=0;i<num_elt;i++)
//    		printf("tmpelt[%d] = %llu\n", i, tmpelt[i]);

        block1 = dim3 (min((double)512, (double)num_elt/2.0), 1); // 512 threads deals with 1024 data.
        num_blk = (num_elt > block1.x)? num_elt / (2 * block1.x): 1; // because each thread process 2 elements

        int* mxgrd = max_grid();
        printf("grid max = %d, %d blocks\n", mxgrd[0], mxgrd[1]);

        int gridx = (num_blk > mxgrd[0])? mxgrd[0] : num_blk;
        int gridy = (num_blk > mxgrd[0])? num_blk / mxgrd[0] + 1: 1;
        printf("num_blk:%d\n", num_blk);

        printf("grid dimension x, y = %d, %d\n", gridx, gridy);


        dim3 grid1 = dim3(gridx, gridy);
        size_t shds1 = 2 * block1.x * sizeof(int); // need factor 2 because a thread add 2 elements.

        printf("blockdim.x = %d threads, shd size = %d bytes\n", block1.x, shds1);

        // clear used location
		size_t sz_gsum = sz_ull * num_blk;

		// new grid, block, shds
		sum_kernel_int32<<<grid1, block1, shds1>>>(gnum_elt, gelts, gnum_block, gsum);

		num_elt = num_blk;
		sz_elts = sz_gsum;

		// interchange:
		int* tmp_num_elt = gnum_elt;
		int* tmp_elts = gelts;

		gnum_elt = gnum_block;
		gelts = gsum;

		gnum_block = tmp_num_elt;
		gsum = tmp_elts;

//		// copy output by printing next inputs
//		int* cnum_elt = (int*)malloc(sz_ull);
//		cudaMemcpy(cnum_elt, gnum_elt, sz_ull, cudaMemcpyDeviceToHost);
//		printf("next - numelt:%d\n", *cnum_elt);

//		int i;
//		int* celts = (int*)malloc(sz_elts);
//		cudaMemcpy(celts, gelts, sz_elts, cudaMemcpyDeviceToHost);
//		for(i=0;i<(int)*cnum_elt;i++)
//			printf("%d th next elt:%llu\n", i, celts[i]);

	} while (num_blk != 1);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    cutStopTimer(timerg_exe);
    double tvg = cutGetTimerValue(timerg_exe);
    printf("gpu time glb(kernel):\n %e \n(%f)(ms)\n", tvg, tvg);

    cutDeleteTimer(timerg_exe);

	return gelts;
}


ullong
sum_gpu_interchange_ullong(ullong num_elt, ullong* elts)
{
	size_t sz_ull = sizeof(ullong);
	size_t sz_elts = sz_ull * num_elt;

	printf("sizeof globalmem alloc:%llu\n", sz_elts);

	ullong *gnum_elt;
    cudaMalloc(&gnum_elt, sz_ull);
    cudaMemcpy((void*)gnum_elt, &num_elt, sz_ull, cudaMemcpyHostToDevice);

    ullong *gelts;
    cudaMalloc(&gelts, sz_elts);
    cudaMemcpy(gelts, elts, sz_elts, cudaMemcpyHostToDevice);

    ullong* gelts_out = sum_gpu_kernel_ullong(num_elt, gnum_elt, gelts);

	ullong answer = 0;

	cudaMemcpy(&answer, gelts_out, sz_ull, cudaMemcpyDeviceToHost);
	printf("answer in sum_gpu():%llu\n", answer);

    cudaFree(gelts);

	return answer;
}

int
sum_gpu_interchange_int32(int num_elt, int* elts)
{
	size_t sz_ull = sizeof(int);
	size_t sz_elts = sz_ull * num_elt;

	printf("sizeof globalmem alloc:%llu\n", sz_elts);

	int *gnum_elt;
    cudaMalloc(&gnum_elt, sz_ull);
    cudaMemcpy((void*)gnum_elt, &num_elt, sz_ull, cudaMemcpyHostToDevice);

    int *gelts;
    cudaMalloc(&gelts, sz_elts);
    cudaMemcpy(gelts, elts, sz_elts, cudaMemcpyHostToDevice);

    int* gelts_out = sum_gpu_kernel_int32(num_elt, gnum_elt, gelts);

	int answer = 0;

	cudaMemcpy(&answer, gelts_out, sz_ull, cudaMemcpyDeviceToHost);
	printf("answer in sum_gpu():%llu\n", answer);

    cudaFree(gelts);

	return answer;
}

ullong
sum_gpu_alloc_ullong(ullong num_elt, ullong* elts)
{
	size_t sz_ull = sizeof(ullong);
	size_t sz_elts = sz_ull * num_elt;

	ullong *gnum_elt;
    cudaMalloc(&gnum_elt, sz_ull);
    cudaMemcpy((void*)gnum_elt, &num_elt, sz_ull, cudaMemcpyHostToDevice);

    ullong *gelts;
    cudaMalloc(&gelts, sz_elts);
    cudaMemcpy(gelts, elts, sz_elts, cudaMemcpyHostToDevice);

    unsigned int timerg_exe = 0;
    cutCreateTimer(&timerg_exe);
    cutResetTimer(timerg_exe);

	cutStartTimer(timerg_exe);

	int i;
    int num_blk;
	ullong* gnum_block;
	ullong *gsum;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
    do {

//    	printf("--------------do-------------\nnumelt:%d\n", num_elt);
//    	ullong* tmpelt = (ullong*)malloc(sz_elts);
//    	cudaMemcpy(tmpelt, gelts, sz_elts, cudaMemcpyDeviceToHost);
//    	for(i=0;i<num_elt;i++)
//    		printf("tmpelt[%d] = %llu\n", i, tmpelt[i]);

        dim3 block1 = dim3 (min((double)512, (double)num_elt/2.0), 1); // 512 threads deals with 1024 data.
        num_blk = (num_elt > block1.x)? num_elt / (2 * block1.x): 1; // because each thread process 2 elements

        int* mxgrd = max_grid();
//        printf("grid max = %d, %d blocks\n", mxgrd[0], mxgrd[1]);

        int gridx = (num_blk > mxgrd[0])? mxgrd[0] : num_blk;
        int gridy = (num_blk > mxgrd[0])? num_blk / mxgrd[0] + 1: 1;
//        printf("num_blk:%d\n", num_blk);

//        printf("grid dimension x, y = %d, %d\n", gridx, gridy);


        dim3 grid1 = dim3(gridx, gridy);
        size_t shds1 = 2 * block1.x * sizeof(ullong); // need factor 2 because a thread add 2 elements.

//        printf("blockdim.x = %d threads, shd size = %d bytes\n", block1.x, shds1);

		cudaMalloc(&gnum_block, sz_ull);
		cudaMemset(gnum_block, 0, sz_ull);

		// return storage gsum
		size_t sz_gsum = sz_ull * num_blk;
		cudaMalloc(&gsum, sz_gsum);
		cudaMemset(gsum, 0, sz_gsum);


		// new grid, block, shds
		sum_kernel_ullong<<<grid1, block1, shds1>>>(gnum_elt, gelts, gnum_block, gsum);

// cudaFree() costs 90ms - huge.
//	    cudaFree(gnum_elt);
//		cudaFree(gelts);

		num_elt = num_blk;
		sz_elts = sz_gsum;

		gnum_elt = gnum_block;
		gelts = gsum;

	} while (num_blk != 1);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    cutStopTimer(timerg_exe);
    double tvg = cutGetTimerValue(timerg_exe);
    printf("gpu time glb(kernel):\n %e \n(%f)(ms)\n", tvg, tvg);

    cutDeleteTimer(timerg_exe);

	ullong answer = 0;

	cudaMemcpy(&answer, gsum, sz_ull, cudaMemcpyDeviceToHost);
	printf("answer in sum_gpu():%llu\n", answer);

    cudaFree(gelts);
    cudaFree(gsum);

	return answer;
}

ullong sum_gpu_ullong(ullong num_elt, ullong* elts)
{
	ullong g_sum;
//	g_sum = sum_gpu_alloc_ullong(num_elt, elts);
	g_sum = sum_gpu_interchange_ullong(num_elt, elts);
	return g_sum;
}

int sum_gpu_int32(int num_elt, int* elts)
{
	int g_sum;
	g_sum = sum_gpu_interchange_int32(num_elt, elts);
	return g_sum;
}

void sum_uulong()
{
	int i;
	// data prep

	// cuda call
//	ullong num_elt = (ullong)pow(2, 1); 		// test for single block
//	ullong num_elt = (ullong)pow(2, 9); 		// test for single block
//	ullong num_elt = (ullong)pow(2, 11); 	//2048 = 1024 + 1024 : 2 blocks
//	ullong num_elt = (ullong)pow(2, 29); // 4GB (too big at global memory)
//	ullong num_elt = (ullong)pow(2, 27); // 1.07 GB  (too big at global memory) -> wrong answer
	ullong num_elt = (ullong)pow(2, 26); // 536 MB - gpu faster than cpu : twice (primary data)
//	ullong num_elt = (ullong)pow(2, 25); // cpu gpu(only gpu side - no cudaFree()) similar .1XX ms
//	ullong num_elt = (ullong)pow(2, 24); // cpu faster than gpu 2 times

	size_t sz_elts = sizeof(ullong) * num_elt;
	printf("input data size of length %llu, w/ long long type:%llu bytes\n", num_elt, sz_elts);


	// malloc elts in either normal memory or pinned memory. => pinned memory is 2 times faster in memcpy
//	ullong* elts = (ullong *)malloc(sz_elts);
	ullong *elts;
	cudaMallocHost(&elts, sz_elts);
	for(i=0;i<num_elt;i++) {
		elts[i] = (ullong)i;//(int)rand();
//		printf("%llu th input = %llu\n", i, elts[i]);
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	// begin cpu time check
	timespec ts_start, ts_stop;
	printf("CLOCk:.....%d\n", CLOCK_MONOTONIC + 2);
	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_start))
		printf("taking clock - start successful\n");

	ullong sum=0;
	for(i=0;i<num_elt;i++)
		sum += elts[i];

	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_stop))
		printf("taking clock - stop successful\n");
	uint64_t timeElapsedNano = timespecDiffNano(&ts_stop, &ts_start);

	printf("cpu - ptrptr (s):(%u->%u)\ncpu(ns):(%u->%u)\n cpu_elapsed(ms):%f \n\n",
			ts_start.tv_sec, ts_stop.tv_sec,
			ts_start.tv_nsec, ts_stop.tv_nsec, (double)timeElapsedNano/(double)1000000000);

	printf("numelt=%d, sum in cpu = %llu\n\n", num_elt, sum);

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//begin gpu timer
    unsigned int timerg_all = 0;
    cutCreateTimer(&timerg_all);
    cutResetTimer(timerg_all);

    cutStartTimer(timerg_all);

    ullong g_sum = 0;
    g_sum = sum_gpu_ullong(num_elt, elts);

    cutStopTimer(timerg_all);

    printf("dbl_sum = %llu, diff(c-g):%llu\n", g_sum, sum - g_sum);

    double tvga = cutGetTimerValue(timerg_all);
    printf("gpu time glb(kernel+in-copy):\n %e \n(%f)(ms)\n", tvga, tvga);
    cutDeleteTimer(timerg_all);
	return;
}

void sum_int32()
{
	int i;
	// data prep

	// cuda call
//	int num_elt = (int)pow(2, 1); 		// test for single block
//	int num_elt = (int)pow(2, 9); 		// test for single block
	int num_elt = (int)pow(2, 14); 	    // 2^10 * 2^4 : 2^4 blocks

	size_t sz_elts = sizeof(int) * num_elt;
	printf("input data size of length %llu, w/ long long type:%llu bytes\n", num_elt, sz_elts);


	// malloc elts in either normal memory or pinned memory. => pinned memory is 2 times faster in memcpy
//	int* elts = (int *)malloc(sz_elts);
	int *elts;
	cudaMallocHost(&elts, sz_elts);
	for(i=0;i<num_elt;i++) {
		elts[i] = (int)i;//(int)rand();
//		printf("%llu th input = %llu\n", i, elts[i]);
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	// begin cpu time check
	timespec ts_start, ts_stop;
	printf("CLOCk:.....%d\n", CLOCK_MONOTONIC + 2);
	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_start))
		printf("taking clock - start successful\n");

	int sum=0;
	for(i=0;i<num_elt;i++)
		sum += elts[i];

	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_stop))
		printf("taking clock - stop successful\n");
	uint64_t timeElapsedNano = timespecDiffNano(&ts_stop, &ts_start);

	printf("cpu - ptrptr (s):(%u->%u)\ncpu(ns):(%u->%u)\n cpu_elapsed(ms):%f \n\n",
			ts_start.tv_sec, ts_stop.tv_sec,
			ts_start.tv_nsec, ts_stop.tv_nsec, (double)timeElapsedNano/(double)1000000000);

	printf("numelt=%d, sum in cpu = %llu\n\n", num_elt, sum);

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//begin gpu timer
    unsigned int timerg_all = 0;
    cutCreateTimer(&timerg_all);
    cutResetTimer(timerg_all);

    cutStartTimer(timerg_all);

    int g_sum = 0;
    g_sum = sum_gpu_int32(num_elt, elts);

    cutStopTimer(timerg_all);

    printf("dbl_sum = %llu, diff(c-g):%llu\n", g_sum, sum - g_sum);

    double tvga = cutGetTimerValue(timerg_all);
    printf("gpu time glb(kernel+in-copy):\n %e \n(%f)(ms)\n", tvga, tvga);
    cutDeleteTimer(timerg_all);
	return;
}

int main(int argc, char** argv)
{
//	sum_uulong();
	sum_int32();
	return 0;
}
