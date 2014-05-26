// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <cuda.h>
#include <cutil.h>

extern "C"
////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest(int argc, char** argv, int N);
static CUresult initCuda(CUcontext cuContext, char*, CUfunction *mathop, int, char**);
CUresult Error(CUcontext cuContext, CUresult status);
void print_GetProperties(CUdevice cuDevice);

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main(int argc, char** argv)
{
    int N = 16;
    runTest(argc, argv, N);
    CUT_EXIT(argc, argv);
}

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA
////////////////////////////////////////////////////////////////////////////////
void
runTest(int argc, char** argv, int N)
{
    CUcontext cuContext;

    // initialize CUDA
    CUfunction cpyTest = NULL;
    CU_SAFE_CALL(initCuda(cuContext, argv[0], &cpyTest, argc, argv));

    int alloc_size = N * sizeof(int);

/// Decomposition is already define here 
//  size 16 -> 4 x 4 threads in a block
    int blocksizex = 4;
    int blocksizey = 4;
    int *h_0 = (int*) malloc(alloc_size);
    for(int i = 0 ; i < blocksizey ; i++)
      for(int j = 0 ; j < blocksizex ; j++)
      {
        int k = i * blocksizex + j;
        h_0[k] = k;//atof(argv[1]);
      }

    CUdeviceptr d_0;
    CU_SAFE_CALL(cuMemAlloc(&d_0, alloc_size));

    CUdeviceptr d_1;
    CU_SAFE_CALL(cuMemAlloc( &d_1, alloc_size));

    CU_SAFE_CALL(cuMemcpyHtoD(d_0, (void*)h_0, alloc_size));

    // create and start timer
    unsigned int timer = 0;
    CUT_SAFE_CALL(cutCreateTimer(&timer));
    CUT_SAFE_CALL(cutStartTimer(timer));
    
    // Calling kernel
    int offset = 0;
    int BLOCK_SIZE_X = blocksizex;
    int BLOCK_SIZE_Y = blocksizey;
    int GRID_SIZE = 1;
    CU_SAFE_CALL(cuFuncSetBlockShape(cpyTest, BLOCK_SIZE_X, BLOCK_SIZE_Y, 1));
    CU_SAFE_CALL(cuParamSeti(cpyTest, offset, d_0)); offset += sizeof(d_0);
    CU_SAFE_CALL(cuParamSeti(cpyTest, offset, d_1)); offset += sizeof(d_1);
    CU_SAFE_CALL(cuParamSetSize(cpyTest, offset));
    CU_SAFE_CALL(cuLaunchGrid(cpyTest, GRID_SIZE, GRID_SIZE));
    
    int *h_1 = (int*)malloc(alloc_size);
    CU_SAFE_CALL(cuMemcpyDtoH((void*)h_1, d_1, alloc_size));

    for(int i = 0 ; i < blocksizey ; i++)
      for(int j = 0 ; j < blocksizex ; j++)
      {
        int k = i * blocksizex + j;
        printf ("%d: %d => %d\n", k, h_0[k], h_1[k]);//atof(argv[1]);
      }

    CU_SAFE_CALL(cuMemFree(d_0));
    CU_SAFE_CALL(cuMemFree(d_1));
    free(h_0);
    free(h_1);

    CUT_SAFE_CALL(cutStopTimer(timer));
    printf("Processing time: %f (ms)\n", cutGetTimerValue(timer));
    CUT_SAFE_CALL(cutDeleteTimer(timer));

    CU_SAFE_CALL_NO_SYNC(cuCtxDetach(cuContext));
}

static CUresult
initCuda(CUcontext cuContext, char* executablePath, CUfunction *mathop, 
	int argc, char** argv)
{
    char* module_path;

    CUdevice cuDevice;
    CUT_DEVICE_INIT_DRV(cuDevice, argc, argv);
    print_GetProperties(cuDevice);

    CUresult status = cuCtxCreate( &cuContext, 0, cuDevice );
    if ( CUDA_SUCCESS != status ) {
        Error(cuContext, status);
    }
    else printf("context creation successful\n");

    module_path = cutFindFilePath("mf_kernel.cubin", executablePath);
    if (module_path == 0) {
        status = CUDA_ERROR_NOT_FOUND;
        Error(cuContext, status);
    }

    CUmodule cuModule;
    status = cuModuleLoad(&cuModule, module_path);
    cutFree(module_path);
    if ( CUDA_SUCCESS != status ) {
        Error(cuContext, status);
    }

    CUfunction cuFunction = 0;
    status = cuModuleGetFunction( &cuFunction, cuModule, "kernel" );
    if ( CUDA_SUCCESS != status) {
        Error(cuContext, status);
	}

    *mathop = cuFunction;

    return CUDA_SUCCESS;
}

CUresult Error(CUcontext cuContext, CUresult status)
{
    printf("initCuda is n't SUCESS, code=%d\n", status);
    cuCtxDetach(cuContext);
    return status;

}

void print_GetProperties(CUdevice cuDevice)
{
    int count = 0;
    cuDeviceGetCount(&count);
    printf ("cuDeviceGetCount = %d\n", count);

    int len = 1024;
    char* dev_name = (char*)malloc(sizeof(char) * len);
    cuDeviceGetName(dev_name, len, cuDevice);
    printf("cuda-devicename = %s\n", dev_name);
    free(dev_name);

    int mj_v = 0, mn_v = 0;
    cuDeviceComputeCapability(&mj_v, &mn_v, cuDevice);
    printf("compute capability = mj:%d, mn:%d\n", mj_v, mn_v);

    unsigned int byt_mem = 0;
    cuDeviceTotalMem(&byt_mem, cuDevice);
    printf("total mem = %d\n", byt_mem);
    CUdevprop cp;
    cuDeviceGetProperties(&cp, cuDevice);
    printf("Thd/blk = %d, thrdDim xyz = (%d, %d, %d:threads), GridSz xyz = (%d, %d, %d:blocks), shrdmem/blk = %d, constmem = %d bytes, simdwidth = %d, mempitch = %d, regsPerBlock = %d, clockRate = %d, textureAlign = %d \n",
        cp.maxThreadsPerBlock, cp.maxThreadsDim[0], cp.maxThreadsDim[1], cp.maxThreadsDim[2], cp.maxGridSize[0], cp.maxGridSize[1], cp.maxGridSize[2], cp.sharedMemPerBlock, cp.totalConstantMemory, cp.SIMDWidth, cp.memPitch, cp.regsPerBlock, cp.clockRate, cp.textureAlign);

    int ip;
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Y, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Y = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Z, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Z = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Y, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Y = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Z, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Z = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_SHARED_MEMORY_PER_BLOCK, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_SHARED_MEMORY_PER_BLOCK = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_WARP_SIZE, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_WARP_SIZE = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_MAX_PITCH, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_MAX_PITCH = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_REGISTERS_PER_BLOCK, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_REGISTERS_PER_BLOCK = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_CLOCK_RATE, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_CLOCK_RATE = %d\n", ip);
    cuDeviceGetAttribute(&ip, CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT, cuDevice);
    printf ("Attrib - CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT = %d\n", ip);
}
