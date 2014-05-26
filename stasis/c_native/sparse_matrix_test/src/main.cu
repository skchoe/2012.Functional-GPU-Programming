/*
 * main.cu
 *
 *  Created on: Feb 24, 2012
 *      Author: skchoe
 */


#include <stdio.h>
#include <time.h>

#include <cuda.h>
#include <cutil.h>
#include <sm_11_atomic_functions.h>
#include <vector_types.h>



int sharedMemory()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.sharedMemPerBlock;
}
int maxThreadsPerBlock()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.maxThreadsPerBlock;
}


void split2constanalys_seq(int num_var, int* num_const, int max_num_const,
		int* pinput, int* poutput1, int* poutput2)
{
	int i, j, k;
	for(i=0;i<max_num_const;i++) // height
		for(j=0;j<num_var;j++) {
			k = j + i * max_num_const;
			if(i < num_const[j])
				if(pinput[k] == 1)
					poutput1[k] = 1;
				else if(pinput[k] == 2)
					poutput2[k] = 2;
				else // pinput[k] == 0
				{}
		}

	return;
}

__global__ void split2constanalys_gpumat(
		int *num_var, int* num_const, int *max_num_const,
		int* pginput, int* pgoutput1, int* pgoutput2)
{
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	int j = threadIdx.y + blockDim.y * blockIdx.y;
	int k = j + i * *max_num_const;
	if(i < num_const[j]) {
		if(pginput[k] == 1)
			pgoutput1[k] = 1;
		else if(pginput[k] == 2)
			pgoutput2[k] = 2;
		else // pinput[k] == 0
		{}
	}

	return;
}

__global__ void split2constanalys_gpusp(
		int* num_var, int* num_const, int* max_num_const,
		int* psginput,
		int* num_outconst1, int* psgoutput1,
		int* num_outconst2, int* psgoutput2)
{
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	int j = threadIdx.y + blockDim.y * blockIdx.y;

	__shared__ int s_mat[10000];

	__syncthreads();

	int k = j + i * *max_num_const;
	if(i < num_const[j]) {
		if(psginput[k] == 1)
			psgoutput1[k] = 1;
		else if(psginput[k] == 2)
			psgoutput2[k] = 2;
		else // pinput[k] == 0
		{}
	}

	__syncthreads();



	return;
}


void print_constanalys_mat (int num_var, int max_num_const, int* poutput1, int* poutput2)
{

	int i, j, k;
	printf("array of 1's\n");
	for(i=0;i<max_num_const;i++) {
		for(j=0;j<num_var;j++) {
			k = j + i*max_num_const;
			printf(" %d ", poutput1[k]);
		}
		printf("\n");
	}

	printf("array of 2's\n");
	for(i=0;i<max_num_const;i++) {
		for(j=0;j<num_var;j++) {
			k = j + i*max_num_const;
			printf(" %d ", poutput2[k]);
		}
		printf("\n");
	}
}

void init_int_array(int* pint, int x, int num_ints)
{
	int i;
	for(i=0;i<num_ints;i++)
		pint[i] = x;
	return;
}


int main(int argc, char** argv)
{
	int i, j, k;

	int num_var = (int) pow(2, 8 * 2);//16; // W x W is maximum allowable number of threads.
	int num_const_limit = 16;
//	int mtpb = maxThreadsPerBlock();
//	int Hthreads = min(H, mtpb/W);
	size_t sz1 = sizeof(int) * num_var;

	// list of num_const for each var.
	int* num_const = (int*) malloc(sz1);
	for(i=0;i<num_var;i++)
		num_const[i] = (int) (rand() % (num_const_limit + 1));

	int sum_const = 0;
	int max_num_const = 0;
	for(i=0;i<num_var;i++) {
		if(num_const[i] > max_num_const) max_num_const = num_const[i];
		sum_const += num_const[i];
	}

	printf("num_var: %d, max num const=%d, number of const:%d\n",
			num_var, max_num_const, sum_const);

	///////////////////////////////////////////////////
	// representation
	// original 2D matrix
	size_t sz2 = sizeof(int) * num_var * max_num_const;
	int* pinput = (int*) malloc (sz2);
	for(i=0;i<max_num_const;i++) // height
		for(j=0;j<num_var;j++) {
			k = j + i * max_num_const;
			if(i < num_const[j])
				pinput[k] = rand() % 2 + 1;
			else
				pinput[k] = 0;
		}
//	// test printing
//	for(i=0;i<max_num_const;i++) {
//		for(j=0;j<num_var;j++) {
//			k = j + i*max_num_const;
//			printf(" %d ", pinput[k]);
//		}
//		printf("\n");
//	}

	int* poutput1 = (int*) malloc (sz2);

	int num_int = num_var * max_num_const;
	init_int_array(poutput1, 0, num_int);
	int* poutput2 = (int*) malloc (sz2);
	init_int_array(poutput2, 0, num_int);

	clock_t tv_start = clock();

	split2constanalys_seq(num_var, num_const, max_num_const, pinput, poutput1, poutput2);

	clock_t tv_stop = clock();
	double dateclock_diff_ms = (double)(tv_stop - tv_start) * 1000. / CLOCKS_PER_SEC;

	printf("elapsed time for cpu:%e (%f)(ms)\n", dateclock_diff_ms, dateclock_diff_ms);

//	print_constanalys_mat (num_var, max_num_const, poutput1, poutput2);

	///////////////////////////////////////////////////////////////////////////////

	// gpu handling of the 2d matrix
	int* gnum_var;
	cudaMalloc(&gnum_var, sizeof(int));
	cudaMemcpy(gnum_var, &num_var, sizeof(int), cudaMemcpyHostToDevice);

	int* gnum_const;
	cudaMalloc(&gnum_const, sz1);
	cudaMemcpy(gnum_const, num_const, sz1, cudaMemcpyHostToDevice);

	int* gmax_num_const;
	cudaMalloc(&gmax_num_const, sizeof(int));
	cudaMemcpy(gmax_num_const, &max_num_const, sizeof(int), cudaMemcpyHostToDevice);

	// data storage
	int *pginput, *pgoutput1, *pgoutput2;
	cudaMalloc(&pginput, sz2);
	cudaMemcpy(pginput, pinput, sz2, cudaMemcpyHostToDevice);

    cudaMalloc(&pgoutput1, sz2);
	cudaMemcpy(pgoutput1, poutput1, sz2, cudaMemcpyHostToDevice);
    cudaMalloc(&pgoutput2, sz2);
	cudaMemcpy(pgoutput2, poutput2, sz2, cudaMemcpyHostToDevice);

	int block_w = 16,  block_h = max_num_const;
	printf("block:(%d,%d), grid(%d, %d)\n", block_w, block_h, num_var / block_w, max_num_const/block_h);

    dim3 grid(num_var / block_w, max_num_const/block_h, 1);
    dim3 block(block_w, block_h, 1);

    unsigned int timerg1 = 0;
    cutCreateTimer(&timerg1);
    cutResetTimer(timerg1);
	cutStartTimer(timerg1);

    split2constanalys_gpumat<<<grid, block>>>(gnum_var, gnum_const, gmax_num_const, pginput, pgoutput1, pgoutput2);

    cutStopTimer(timerg1);

    double tvg1 = cutGetTimerValue(timerg1);
    printf("gpu time glb(-num_var:%d): %e (%f)(ms)\n", num_var, tvg1, tvg1);
    cutDeleteTimer(timerg1);


    printf("diff: cpu-gpu:%e, percentage gpu/cpu:%f\n",
    		dateclock_diff_ms - timerg1,
    		(double)timerg1 / (double)dateclock_diff_ms);

    init_int_array(poutput1, 0, num_var * max_num_const);
    init_int_array(poutput2, 0, num_var * max_num_const);
    cudaMemcpy(poutput1, pgoutput1, sz2, cudaMemcpyDeviceToHost);
    cudaMemcpy(poutput2, pgoutput2, sz2, cudaMemcpyDeviceToHost);

//	print_constanalys_mat (num_var, max_num_const, poutput1, poutput2);

	//////////////////////////////////////////////////////////////////////////////////////
	// sparse form of the input
	int sz3 = sizeof(int) * sum_const;
	int* psinput = (int*) malloc (sz3);
	int l=0;
	for(i=0;i<max_num_const;i++) // height
		for(j=0;j<num_var;j++) {
			k = j + i * max_num_const;
			if(i < num_const[j])
				psinput[l++] = pinput[k];
		}

//	// checking above.
//	for(j=0;j<sum_const;j++)
//		printf("j:%d (%d)\t", j, psinput[j]);
//	printf("\n");

	int* psginput;
	cudaMalloc(&psginput, sz3);
	cudaMemcpy(psginput, psinput, sz3, cudaMemcpyHostToDevice);

	int* num_outconst1 = (int*) malloc(sz1);
	int* num_outconst2 = (int*) malloc(sz1);
	for(i=0;i<num_var;i++) {
		num_outconst1[i] = 0;
		num_outconst2[i] = 0;
	}

	int* gnum_outconst1, *gnum_outconst2;
	cudaMalloc(&gnum_outconst1, sz1);
	cudaMemcpy(gnum_outconst1, num_outconst1, sz1, cudaMemcpyHostToDevice);
	cudaMalloc(&gnum_outconst2, sz1);
	cudaMemcpy(gnum_outconst2, num_outconst2, sz1, cudaMemcpyHostToDevice);

	int *psgoutput1, *psgoutput2;
	cudaMalloc(&psgoutput1, sz3);
	cudaMalloc(&psgoutput2, sz3);

    unsigned int timerg2 = 0;
    cutCreateTimer(&timerg2);
    cutResetTimer(timerg2);
	cutStartTimer(timerg2);

	split2constanalys_gpusp<<<grid, block>>>(gnum_var, gnum_const, gmax_num_const,
			                                 psginput,
			                                 gnum_outconst1, psgoutput1,
			                                 gnum_outconst2, psgoutput2);

    cutStopTimer(timerg2);

    double tvg2 = cutGetTimerValue(timerg2);
    printf("gpu time glb(-num_var:%d): %e (%f)(ms)\n", num_var, tvg2, tvg2);
    cutDeleteTimer(timerg2);


    printf("diff: cpu-gpu:%e, percentage gpu/cpu:%f\n",
    		dateclock_diff_ms - timerg2,
    		(double)timerg2 / (double)dateclock_diff_ms);

    int *psoutput1, *psoutput2;
	psoutput1 = (int*)malloc(sz3);
	psoutput2 = (int*)malloc(sz3);

	cudaMemcpy(psoutput1, psgoutput1, sz3, cudaMemcpyDeviceToHost);
	cudaMemcpy(psoutput2, psgoutput2, sz3, cudaMemcpyDeviceToHost);



	return 0;
}
