/*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 *
 * NVIDIA Corporation and its licensors retain all intellectual property and 
 * proprietary rights in and to this software and related documentation. 
 * Any use, reproduction, disclosure, or distribution of this software 
 * and related documentation without an express license agreement from
 * NVIDIA Corporation is strictly prohibited.
 *
 * Please refer to the applicable NVIDIA end user license agreement (EULA) 
 * associated with this source code for terms and conditions that govern 
 * your use of this NVIDIA software.
 * 
 */

/* Matrix multiplication: C = A * B.
 * Host code.
 *
 * This sample implements matrix multiplication using the CUDA driver API.
 * It has been written for clarity of exposition to illustrate various CUDA
 * programming principles, not with the goal of providing the most
 * performant generic kernel for matrix multiplication.
 *
 * CUBLAS provides high-performance matrix multiplication.
 * See also:
 * V. Volkov and J. Demmel, "Benchmarking GPUs to tune dense linear algebra,"
 * in Proc. 2008 ACM/IEEE Conf. on Superconducting (SC '08),
 * Piscataway, NJ: IEEE Press, 2008, pp. Art. 31:1-11. 
 *
 */

// includes, system
#include <stdlib.h>
#include <stdio.h>
//#include <string.h>
#include <math.h>

//#include <iostream>
//#include <cstring>

// includes, CUDA
#include <cuda.h>

// includes, project
#include <cutil_inline.h>
#include "matrixMul.h"


#define ALIGN_UP(offset, alignment)                                 \
        (offset) = ((offset) + (alignment) - 1) & ~((alignment) - 1)

using namespace std;
////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest(int argc, char** argv);
void randomInit(float*, int);

extern "C"
void computeGold(float*, const float*, const float*, unsigned int, unsigned int, unsigned int);

static CUresult initCUDA(int argc, char **argv, CUfunction *pMatrixMul );

////////////////////////////////////////////////////////////////////////////////
// Globals
////////////////////////////////////////////////////////////////////////////////
CUdevice cuDevice;
CUcontext cuContext;
CUmodule cuModule;


////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main(int argc, char** argv)
{
    runTest(argc, argv);

    cutilExit(argc, argv);
}

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA
////////////////////////////////////////////////////////////////////////////////
void
runTest(int argc, char** argv)
{
    // initialize CUDA
    CUfunction matrixMul = NULL;
    cutilDrvSafeCallNoSync(initCUDA(argc, argv, &matrixMul ));

    // set seed for rand()
    srand(2006);

    unsigned int mem_size_st2 = sizeof(SizeType2);

    unsigned int size_A = WA * HA;
    unsigned int mem_size_A = sizeof(float) * size_A;
    float* h_A = (float*) malloc(mem_size_A);
    
    SizeType2* h_sA = (SizeType2*) malloc(mem_size_st2);
    h_sA->w = WA; h_sA->h = HA;

    unsigned int size_B = WB * HB;
    unsigned int mem_size_B = sizeof(float) * size_B;
    float* h_B = (float*) malloc(mem_size_B);

    SizeType2* h_sB = (SizeType2*) malloc(mem_size_st2);
    h_sB->w = WB; h_sB->h = HB;

    // initialize host memory
    randomInit(h_A, size_A);
    randomInit(h_B, size_B);
    for(int i=0;i < size_A ; i++)
        printf("A:%f\n", h_A[i]);
 
    for(int i=0;i < size_B ; i++)
        printf("B:%f\n", h_B[i]);

    // allocate device memory
    CUdeviceptr d_A;
    cutilDrvSafeCallNoSync(cuMemAlloc( &d_A, mem_size_A ));
    cutilDrvSafeCallNoSync(cuMemcpyHtoD( d_A, h_A, mem_size_A ));

    CUdeviceptr d_sA;
    cutilDrvSafeCallNoSync(cuMemAlloc( &d_sA, mem_size_st2 ));
    cutilDrvSafeCallNoSync(cuMemcpyHtoD( d_sA, h_sA, mem_size_st2 ));

    CUdeviceptr d_B;
    cutilDrvSafeCallNoSync(cuMemAlloc( &d_B, mem_size_B )); 
    cutilDrvSafeCallNoSync(cuMemcpyHtoD( d_B, h_B, mem_size_B ));

    CUdeviceptr d_sB;
    cutilDrvSafeCallNoSync(cuMemAlloc( &d_sB, mem_size_st2 ));
    cutilDrvSafeCallNoSync(cuMemcpyHtoD( d_sB, h_sB, mem_size_st2 ));


    // allocate device memory for result
    unsigned int count_C = WC * HC;
    unsigned int mem_size_C = sizeof(float) * count_C;

    CUdeviceptr d_C;
    cutilDrvSafeCallNoSync(cuMemAlloc(&d_C, mem_size_C));
    
    CUdeviceptr d_sC;
    cutilDrvSafeCallNoSync(cuMemAlloc( &d_sC, mem_size_st2 ));
    
    // create and start timer
    unsigned int timer = 0;
    cutilCheckError(cutCreateTimer(&timer));
  
    // start the timer 
    cutilCheckError(cutStartTimer(timer));

    // setup execution parameters
    int offset = 0;
    void* ptr = NULL;

    ptr = (void*)(size_t)d_A;
    ALIGN_UP(offset, __alignof(ptr));
printf("offset (0):%d\n", offset);
    cutilDrvSafeCallNoSync(cuParamSetv( matrixMul, offset, &ptr, sizeof(ptr)));
    offset += sizeof(ptr);

    ptr = (void*)(size_t)d_sA;
    ALIGN_UP(offset, __alignof(ptr));
printf("offset (1):%d\n", offset);
    cutilDrvSafeCallNoSync(cuParamSetv( matrixMul, offset, &ptr, sizeof(ptr)));
    offset += sizeof(ptr);

    ptr = (void*)(size_t)d_B;
    ALIGN_UP(offset, __alignof(ptr));
printf("offset (2):%d\n", offset);
    cutilDrvSafeCallNoSync(cuParamSetv( matrixMul, offset, &ptr, sizeof(ptr)));
    offset += sizeof(ptr);

    ptr = (void*)(size_t)d_sB;
    ALIGN_UP(offset, __alignof(ptr));
printf("offset (3):%d\n", offset);
    cutilDrvSafeCallNoSync(cuParamSetv( matrixMul, offset, &ptr, sizeof(ptr)));
    offset += sizeof(ptr);

    ptr = (void*)(size_t)d_C;
    ALIGN_UP(offset, __alignof(ptr));
printf("offset (4):%d\n", offset);
    cutilDrvSafeCallNoSync(cuParamSetv( matrixMul, offset, &ptr, sizeof(ptr)));
    offset += sizeof(ptr);

    ptr = (void*)(size_t)d_sC;
    ALIGN_UP(offset, __alignof(ptr));
printf("offset (5):%d\n", offset);
    cutilDrvSafeCallNoSync(cuParamSetv( matrixMul, offset, &ptr, sizeof(ptr)));
    offset += sizeof(ptr);

    cutilDrvSafeCallNoSync(cuParamSetSize( matrixMul, offset ));
    cutilDrvSafeCallNoSync(cuFuncSetBlockShape( matrixMul, BLOCK_SIZE, BLOCK_SIZE, 1 ));
    cutilDrvSafeCallNoSync(cuFuncSetSharedSize( matrixMul, 2*BLOCK_SIZE*BLOCK_SIZE*sizeof(float) ) );

    // set execution configuration for the CUDA kernel
    cutilDrvSafeCallNoSync(cuLaunchGrid( matrixMul, WC / BLOCK_SIZE, HC / BLOCK_SIZE ));

    // allocate mem for the result on host side
    float* h_C = (float*) malloc(mem_size_C);

    // copy result from device to host
    cutilDrvSafeCallNoSync(cuMemcpyDtoH((void *) h_C, d_C, mem_size_C) );
    for(int i=0; i < count_C ; i++)
        printf ("gpuout[%d] = %f\n", i, h_C[i]);

    // stop and destroy timer
    cutilCheckError(cutStopTimer(timer));
    printf("Processing time: %f (ms)\n", cutGetTimerValue(timer));
    cutilCheckError(cutDeleteTimer(timer));

    // compute reference solution
    float* reference = (float*) malloc(mem_size_C);
    computeGold(reference, h_A, h_B, HA, WA, WB);
    for(int i=0; i < count_C ; i++)
        printf ("out[%d] = %f\n", i, reference[i]);

    // check result
    CUTBoolean res = cutCompareL2fe(reference, h_C, count_C, 1e-6f);
    printf("%s\n", (1 == res) ? "PASSED" : "FAILED");

    // clean up memory
    free(h_A);
    free(h_B);
    free(h_C);
    free(reference);

    cutilDrvSafeCallNoSync(cuMemFree(d_A));
    cutilDrvSafeCallNoSync(cuMemFree(d_B));
    cutilDrvSafeCallNoSync(cuMemFree(d_C));
    cutilDrvSafeCallNoSync(cuCtxDetach(cuContext));
}

// Allocates a matrix with random float entries.
void randomInit(float* data, int size)
{
    for (int i = 0; i < size; ++i)
        //data[i] = rand() / (float)RAND_MAX;
	data[i] = 0.1f * (1 + i);
}

static CUresult
initCUDA(int argc, char **argv, CUfunction *pMatrixMul )
{
    CUfunction cuFunction = 0;
	int file_size = 0;
	int major = 0, minor = 0;
	char deviceName[100];
    char* module_path;

    if(cutCheckCmdLineFlag(argc, (const char**)argv, "device"))
    {
        //v. 4.0 cutilDeviceInitDrv(argc, argv);
        //v. 3.2 cutilDeviceInitDrv(argc, argv);
        //v. 3.0 cutilDeviceInitDrv(cuDevice, argc, argv);
	cutilDeviceInitDrv(argc, argv);
	} else {
	  int dev = cutilDrvGetMaxGflopsDeviceId();
          cutilDrvSafeCallNoSync(cuDeviceGet(&cuDevice, dev));
	}
	
	// get compute capabilities and the devicename
	cutilDrvSafeCallNoSync( cuDeviceComputeCapability(&major, &minor, cuDevice) );
	cutilDrvSafeCallNoSync( cuDeviceGetName(deviceName, 256, cuDevice) );
	printf("> Device %d: \"%s\" with Compute %d.%d capability\n", cuDevice, deviceName, major, minor);

    CUresult status = cuCtxCreate( &cuContext, 0, cuDevice );
    printf ("print status:%d\n", status);
    if ( CUDA_SUCCESS != status )
        goto Error;

    // first search for the module path before we load the results
    module_path = cutFindFilePath ("matrixMul_kernel.sm_10.cubin", argv[0]);
    if (module_path == 0) {
      status = CUDA_ERROR_NOT_FOUND;
      printf("2:%d\n", status);
      goto Error;
    }

    printf ("Module_path = %s\n", module_path);

    status = cuModuleLoad(&cuModule, module_path);
    if ( CUDA_SUCCESS != status ) {
        goto Error;
    }

    status = cuModuleGetFunction( &cuFunction, cuModule, "matrixMul" );
    if ( CUDA_SUCCESS != status )
        goto Error;
	*pMatrixMul = cuFunction;
	
    return CUDA_SUCCESS;
Error:
	cuCtxDetach(cuContext);
    return status;
}


