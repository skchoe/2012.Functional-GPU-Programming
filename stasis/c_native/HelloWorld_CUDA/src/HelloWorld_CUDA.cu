//============================================================================
// Name        : HelloWorld_CUDA.cu
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in CUDA
//============================================================================

/*
* Copyright 2008, Karen Hains, UWA . All rights reserved.
*
* NOTICE TO USER:
*
* This source code is subject to NVIDIA ownership rights under U.S. and
* international Copyright laws. Users and possessors of this source code
* are hereby granted a nonexclusive, royalty-free license to use this code
* in individual and commercial software.
*
* WE MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE
* CODE FOR ANY PURPOSE. IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR
* IMPLIED WARRANTY OF ANY KIND.
*/

/* HelloWorld Project
* This project demonstrates the basics on how to setup
* an example GPU Computing application.*
* This file contains the CPU (host) code.
*/

// Host defines
#define NUM_THREADS 8
#define STR_SIZE 50

// Includes
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <vector_types.h>
#include <cuda_runtime_api.h>


// GPU Kernels declarations
__global__ void HelloWorld_kernel(int size, char *gpu_odata);

//////////////////////
// Program main
//////////////////////
int main( int argc, char** argv)
{

	// Host variables
	int i,nBytes;
	unsigned int num_threads;
	char *cpu_odata;
	char *string;

	// GPU variables
	char *gpu_odata;
	int str_size;
	
	// Initialize CPU variables and allocate required memory
	num_threads = (unsigned int) NUM_THREADS;
	nBytes = num_threads*STR_SIZE*sizeof(char);
	
	// Allocate and initialize CPU output vector
	string = (char *) malloc(STR_SIZE);
	if(!string) {
		printf("Cannot allocate string memory on CPU\n");
		exit(-1);
	}
	cpu_odata = (char *) malloc(nBytes);
	if(!cpu_odata) {
		printf("Cannot allocate cpu_odata memory on CPU\n");
		exit(-1);
	}
	
	// Allocate GPU (device) memory and variables
	str_size = (int) STR_SIZE;
	cudaMalloc( (void**) &gpu_odata, nBytes);
	
	// Setup kernel execution parameters
	dim3 grid(1,1,1);
	dim3 threads(num_threads,1,1);
	
	// Execute the kernel on the GPU
	HelloWorld_kernel<<< grid, threads >>>(str_size, gpu_odata);
	
	// Copy result from GPU to CPU
	cudaMemcpy(cpu_odata,gpu_odata,nBytes,cudaMemcpyDeviceToHost);
	
	// Output results is same as the expected solution
	for(i=0;i<num_threads;i++) {
		strncpy(string,&cpu_odata[i*STR_SIZE],STR_SIZE);
		printf("From thread %d: %s\n",i,string);
	}
	
	//////////////////////////////////////////
	// All done - clean up and exit
	//////////////////////////////////////////
	// Free up CPU memory
	free(cpu_odata);
	
	// Free up GPU memory
	cudaFree(gpu_odata);

}
