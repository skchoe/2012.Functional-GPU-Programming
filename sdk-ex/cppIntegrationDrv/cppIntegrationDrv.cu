/* Example of integrating CUDA functions into an existing 
 * application / framework.
 * Host part of the device code.
 * Compiled with Cuda compiler.
 */

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

// includes, project
#include <cuda.h>
#include <cutil.h>

// includes, kernels
#include <cppIntegration_kernel.cu>
//
////////////////////////////////////////////////////////////////////////////////
// declaration, forward

extern "C" void
computeGold(char* reference, char* idata, const unsigned int len);
extern "C" void
computeGold2(int2* reference, int2* idata, const unsigned int len);


////////////////////////////////////////////////////////////////////////////////
//! Init for CUDA
////////////////////////////////////////////////////////////////////////////////
//    CU_SAFE_CALL(initCudaContext(&cuDevice, &cuContext, argc, (char**)argv));
static CUresult
initCudaContext(CUcontext *pcuContext, CUdevice *pcuDevice,
	int argc, char** argv)
{
    CUT_DEVICE_INIT_DRV(*pcuDevice, argc, argv);

    CUresult status = cuCtxCreate( pcuContext, 0, *pcuDevice );
    printf ("Ctx Creation: %d\n", status);
    if ( CUDA_SUCCESS != status )
    {    
      cuCtxDetach(*pcuContext);
      return status;
    }
    return CUDA_SUCCESS;
}

static CUresult
loadModule(CUmodule* pcuModule, CUcontext* pcuContext, char* cubinName)
{
    CUresult status = cuModuleLoad(pcuModule, cubinName);
    printf ("ModuleLoad: %s: %d\n", cubinName, status);

    if ( CUDA_SUCCESS != status )
    {    
      cuCtxDetach(*pcuContext);
      return status;
    }
    return CUDA_SUCCESS;
}

static CUresult
loadKernel(CUfunction* pcuFunction, CUmodule cuModule, char* kernelName)
{
    // Global function
    CUfunction cuFunction;
    CUresult status = cuModuleGetFunction( &cuFunction, cuModule, kernelName);
    printf("function loading: %d\n", status);
    if ( CUDA_SUCCESS != status)
    {    
      *pcuFunction = NULL;
      return status;
    }     

    *pcuFunction = cuFunction;

    return CUDA_SUCCESS;
}


////////////////////////////////////////////////////////////////////////////////
//! Entry point for Cuda functionality on host side
//! @param argc  command line argument count
//! @param argv  command line arguments
//! @param data  data to process on the device
//! @param len   len of \a data
////////////////////////////////////////////////////////////////////////////////
extern "C" void
runTest(const int argc, const char** argv, char* data, int2* data_int2, unsigned int len)
{

    CUdevice cuDevice;
    CUcontext cuContext;
    CUmodule cuModule;

    initCudaContext(&cuContext, &cuDevice, argc, (char**)argv);
    loadModule(&cuModule, &cuContext, "data/cppIntegrationDrv.sm_10.cubin");

    CUfunction kernel, kernel2;
    loadKernel(&kernel, cuModule, "kernel");
    loadKernel(&kernel2, cuModule, "kernel2");

    CUT_DEVICE_INIT_DRV(cuDevice, argc, argv);

    const unsigned int num_threads = len / 4;
    CUT_CONDITION(0 == (len % 4));
    const unsigned int mem_size = sizeof(char) * len;
    const unsigned int mem_size_int2 = sizeof(int2) * len;

    // allocate device memory
    CUdeviceptr d_data;
    CU_SAFE_CALL(cuMemAlloc(&d_data, mem_size));
    // copy host memory to device
    CU_SAFE_CALL(cuMemcpyHtoD(d_data, data, mem_size));
printf("00\n");                             
    // allocate device memory for int2 version
    CUdeviceptr d_data_int2;
    CU_SAFE_CALL(cuMemAlloc(&d_data_int2, mem_size_int2));
    // copy host memory to device
    CU_SAFE_CALL(cuMemcpyHtoD(d_data_int2, data_int2, mem_size_int2));
printf("01\n");                             

    // kernel calling
    // setup execution parameters for kernel
    CU_SAFE_CALL(cuFuncSetBlockShape(kernel, num_threads, 1, 1));
    CU_SAFE_CALL(cuParamSeti(kernel, 0, d_data));
    CU_SAFE_CALL(cuParamSetSize(kernel, 4));
    CU_SAFE_CALL(cuLaunchGrid(kernel, 1, 1));
printf("02\n");                             

    // kernel2 calling
    // setup execution parameters for kernel
    CU_SAFE_CALL(cuFuncSetBlockShape(kernel2, len, 1, 1));
    CU_SAFE_CALL(cuParamSeti(kernel2, 0, d_data_int2));
    CU_SAFE_CALL(cuParamSetSize(kernel2, 4));
    CU_SAFE_CALL(cuLaunchGrid(kernel2, 1, 1));
printf("03\n");                             

    // check if kernel execution generated and error
    CUT_CHECK_ERROR("Kernel execution failed");

    // compute reference solutions
    char* reference = (char*) malloc(mem_size);
    computeGold(reference, data, len);
    int2* reference2 = (int2*) malloc(mem_size_int2);
    computeGold2(reference2, data_int2, len);

    // copy results from device to host
    CU_SAFE_CALL(cuMemcpyDtoH(data, d_data, mem_size));
    CU_SAFE_CALL(cuMemcpyDtoH(data_int2, d_data_int2, mem_size_int2));

    // check result
    bool success = true;
    for(unsigned int i = 0; i < len; i++ )
    {
        if( reference[i] != data[i] || 
	    reference2[i].x != data_int2[i].x || 
	    reference2[i].y != data_int2[i].y)
            success = false;
    }
    printf("Test %s\n", success ? "PASSED" : "FAILED");

    // cleanup memory
    CU_SAFE_CALL(cuMemFree(d_data));
    CU_SAFE_CALL(cuMemFree(d_data_int2));
    free(reference);
    free(reference2);
}
