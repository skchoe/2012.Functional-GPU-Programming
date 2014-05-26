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

#ifndef _HELLOWORLD_KERNEL_H_
#define _HELLOWORLD_KERNEL_H_

#include <stdio.h>
#include <device_launch_parameters.h>

///////////////////////////////////////////////////////////
// Simple Hello World kernel
// @param gpu_odata output data in global memory
///////////////////////////////////////////////////////////
__global__ void HelloWorld_kernel(int size, char *gpu_odata)
{
	int i,k,x,n,last_num;
	int idx,not_done;

	// Access thread id and block id
	const unsigned int thread_idx = threadIdx.x;
	const unsigned int block_idx = blockIdx.x;

	// Write data to global memory
	idx = 0;
	gpu_odata[thread_idx*size + idx++] = 'H';
	gpu_odata[thread_idx*size + idx++] = 'e';
	gpu_odata[thread_idx*size + idx++] = 'l';
	gpu_odata[thread_idx*size + idx++] = 'l';
	gpu_odata[thread_idx*size + idx++] = 'o';
	gpu_odata[thread_idx*size + idx++] = ' ';
	gpu_odata[thread_idx*size + idx++] = 'W';
	gpu_odata[thread_idx*size + idx++] = 'o';
	gpu_odata[thread_idx*size + idx++] = 'r';
	gpu_odata[thread_idx*size + idx++] = 'l';
	gpu_odata[thread_idx*size + idx++] = 'd';
	gpu_odata[thread_idx*size + idx++] = ' ';
	gpu_odata[thread_idx*size + idx++] = 'F';
	gpu_odata[thread_idx*size + idx++] = 'r';
	gpu_odata[thread_idx*size + idx++] = 'o';
	gpu_odata[thread_idx*size + idx++] = 'm';
	gpu_odata[thread_idx*size + idx++] = ' ';
	gpu_odata[thread_idx*size + idx++] = 'T';
	gpu_odata[thread_idx*size + idx++] = 'h';
	gpu_odata[thread_idx*size + idx++] = 'r';
	gpu_odata[thread_idx*size + idx++] = 'e';
	gpu_odata[thread_idx*size + idx++] = 'a';
	gpu_odata[thread_idx*size + idx++] = 'd';
	gpu_odata[thread_idx*size + idx++] = ' ';

	// Convert thread id to chars
	// Determine number of places in thread idx
	not_done = 1;
	k = 10;
	n = 1;
	while(not_done == 1) {
		x = thread_idx/k;
		if (x>0) {
			k = k*10;
			n +=1;
		}
		else
			not_done = 0;
	}

	// Parse out the thread index and convert to chars
	k = k/10;
	last_num = 0;
	for(i=n;i>0;i--) {
		x = thread_idx/k-last_num;
		gpu_odata[thread_idx*size + idx++] = '0' + x;
		last_num = (thread_idx/k)*10;
		k = k/10;
	}

	gpu_odata[thread_idx*size + idx++] = ' ';
	gpu_odata[thread_idx*size + idx++] = 'i';
	gpu_odata[thread_idx*size + idx++] = 'n';
	gpu_odata[thread_idx*size + idx++] = ' ';
	gpu_odata[thread_idx*size + idx++] = 'B';
	gpu_odata[thread_idx*size + idx++] = 'l';
	gpu_odata[thread_idx*size + idx++] = 'o';
	gpu_odata[thread_idx*size + idx++] = 'c';
	gpu_odata[thread_idx*size + idx++] = 'k';
	gpu_odata[thread_idx*size + idx++] = ' ';

	// Convert block id to chars
	// Determine number of places in thread idx
	not_done = 1;
	k = 10;
	n = 1;
	while(not_done == 1) {
		x = block_idx/k;
		if (x>0) {
			k = k*10;
			n +=1;
		}
		else
			not_done = 0;
	}

	// Parse out the block index and convert to chars
	k = k/10;
	last_num = 0;
	for(i=n;i>0;i--) {
		x = block_idx/k-last_num;
		gpu_odata[thread_idx*size + idx++] = '0' + x;
		last_num = (block_idx/k)*10;
		k = k/10;
	}

	// Fill out rest of string
	for(i=idx;i<size;i++)
		gpu_odata[thread_idx*size + idx++] = ' ';
}

#endif // #ifndef _HELLOWORLD_KERNEL_H_
