/*
 * bvg.cu
 *
 *  Created on: Mar 19, 2012
 *      Author: u0332192
 */


#include <stdio.h>
#include <cuda.h>

__global__ void get_block_value(int* inv, int* outv)
{


	return;
}

void main(int argc, char** argv)
{
	unsigned int N = pow(2,4);
	size_t sz = sizeof(int) * N;
	int* inv = (int*)malloc(sz);
	int i;
	for(i=0;i<N;i++) inv[i] = i;

	dim3 grd (N, 1);
	dim3 blk (1, 1);

	int* ginv;
	cudaMalloc(&ginv, sz);
	cudaMemcpy(ginv, inv, sz, cudaMemcpyHostToDevice);

	int* goutv;
	cudaMalloc(&goutv, sz);
	cudaMemset(goutv, 0, sz);

	get_block_value<<<grd, blk>>>(ginv, goutv);



	return;
}
