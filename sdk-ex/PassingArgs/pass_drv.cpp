// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <cuda.h>
#include <vector_types.h>
#include <cutil_inline.h>

extern "C"
#define NUM_ARG 9
CUresult Error(CUcontext ctx, CUresult status)
{
    printf("initCuda is n't SUCESS, code=%d\n", status);
    cuCtxDetach(ctx);
    return status;
}

void print_GetProperties(CUdevice cuDevice)
{
    int count = 0;
    cuDeviceGetCount(&count);
    printf ("cuDevice(%d)GetCount = %d\n", cuDevice, count);

    int len = 1024;
    char* dev_name = (char*)malloc(sizeof(char) * len);
    cuDeviceGetName(dev_name, len, cuDevice);
    printf("cuda-devicename = %s\n", dev_name);
    free(dev_name);

    int mj_v = 0, mn_v = 0;
    cuDeviceComputeCapability(&mj_v, &mn_v, cuDevice);
    printf("compute capability = mj:%d, mn:%d\n", mj_v, mn_v);

    size_t byt_mem = 0;
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


static CUresult
initCuda(CUcontext _cuContext, char* executablePath, CUfunction *mathop, 
	int argc, char** argv, const char* cubin_name, const char* kernel_name)
{
    CUdevice cuDevice;
    CUT_DEVICE_INIT_DRV(cuDevice, argc, argv);
    print_GetProperties(cuDevice);

    CUresult status = cuCtxCreate( &_cuContext, 0, cuDevice );
    if ( CUDA_SUCCESS != status ) {
        Error(_cuContext, status);
    }
    else printf("(1) context creation successful\n");

    char* module_path = cutFindFilePath(cubin_name, executablePath);
    printf ("\t cubin:%s, path:%s, mmp_ptr:%lu\n", cubin_name, executablePath, module_path);
    if(module_path != NULL)
      printf ("\t cubin:%s, path:%s, module_path:%c%c%c%c\n", cubin_name, executablePath, *module_path, *(module_path+1), *(module_path+2), *(module_path+3));
    char* data_path = "./data/";
    size_t len_path = strlen(data_path);
    size_t len_fn = strlen(cubin_name);
    // printf ("Sizes: data:%lu, cubinname:%lu\n", len_path, len_fn);

    char* module_path_new = (char*)malloc(sizeof(char) * (len_path + len_fn));
    strcpy(module_path_new, data_path);
    strcat(module_path_new, cubin_name);
    strcat(module_path_new, "\0");
    if (module_path_new == 0) {
        status = CUDA_ERROR_NOT_FOUND;
        Error(_cuContext, status);
    }
    FILE *fp = fopen(module_path_new,"r");
    if( fp ) {
	printf("(2) cubin_File found in modulepath:%s\n", module_path_new);
        fclose(fp);
    } else {
	printf("(2) cubin file not exist: %s\n", module_path_new);
    }
    CUmodule cuModule;
    status = cuModuleLoad(&cuModule, module_path_new);
    cutFree(module_path_new);
    if ( CUDA_SUCCESS != status ) {
        Error(_cuContext, status);
    }
    else printf ("(3) module Load successful\n");

    CUfunction cuFunction = 0;
    status = cuModuleGetFunction(&cuFunction, cuModule, kernel_name);
    if ( CUDA_SUCCESS != status) {
        Error(_cuContext, status);
    }
    else printf ("(4) getFunction successful w/cuFunction\n");

    *mathop = cuFunction;

    return CUDA_SUCCESS;

}

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA
////////////////////////////////////////////////////////////////////////////////
void
runTest(int argc, char** argv)
{
    CUcontext cuContext;

    // initialize CUDA
    CUfunction pk = NULL;
    const char cubin_name [] = "pass_kernel.cubin";
    const char kernel_name [] = "pass_kernel";

    CU_SAFE_CALL(initCuda(cuContext, argv[0], &pk, argc, argv, cubin_name, kernel_name));
    printf("initCuda-returned CUfunction:\n");

    // cuParamSetx, x=i f v
    // http://visionexperts.blogspot.com/2010/07/cuda-parameter-alignment.html - check alignment
    #define ALIGN_UP(offset, alignment)					\
        (offset) = ((offset) + (alignment) - 1) & ~((alignment) - 1)

    size_t offset = 0;

    // input integers
    // CU paramset i.
    for(int i = 0 ; i < NUM_ARG ; i++) 
    {
 	int align = __alignof(int);
	ALIGN_UP(offset, align);
	cuParamSeti(pk, offset, i);
	printf ("offset %d = %d\n", i, offset);
	offset += sizeof(int);
    }

    // return array for updated inputs
    int size_int = sizeof(int);

    int size_array = size_int * NUM_ARG;
    CUdeviceptr d_return_values;
    cuMemAlloc (&d_return_values, size_array);
    void* ptr = (void*)(size_t)d_return_values;
    int align = __alignof(ptr);
    ALIGN_UP(offset, align);
    cuParamSetv(pk, offset, &ptr, sizeof(ptr));
    printf("return values offset:%d\n", offset);
    offset += sizeof(ptr);

    CUdeviceptr d_return_N;
    cuMemAlloc(&d_return_N, size_int);
    void* ptrN = (void*)(size_t)d_return_N;
    int alignN = __alignof(ptrN);
    ALIGN_UP(offset, alignN);
    cuParamSetv(pk, offset, &ptrN, sizeof(ptr));
    printf("return int offset:%d\n", offset);
    offset += sizeof(ptrN);

    // Calling kernel
    int BLOCK_SIZE_X = NUM_ARG;
    int BLOCK_SIZE_Y = 1;
    int BLOCK_SIZE_Z = 1;
    int GRID_SIZE = 1;
    cutilDrvSafeCallNoSync(cuFuncSetBlockShape(pk, BLOCK_SIZE_X, BLOCK_SIZE_Y, BLOCK_SIZE_Z));
 
    printf("paramsetsize:%d\n", offset);
    CU_SAFE_CALL(cuParamSetSize(pk, offset));
    CU_SAFE_CALL(cuLaunchGrid(pk, GRID_SIZE, GRID_SIZE));

    int* h_return_values = (int*)malloc(NUM_ARG * sizeof(int));
    CU_SAFE_CALL(cuMemcpyDtoH((void*)h_return_values, d_return_values, size_array));
    CU_SAFE_CALL(cuMemFree(d_return_values));

    for(int i=0;i<NUM_ARG;i++)
        printf("%dth value = %d\n", i, h_return_values[i]);
    free(h_return_values);

    int* h_return_N = (int*)malloc(sizeof(int));
    CU_SAFE_CALL(cuMemcpyDtoH((void*)h_return_N, d_return_N, size_int));
    CU_SAFE_CALL(cuMemFree(d_return_N));

    printf("%d sizeof array\n", *h_return_N);

    if(cuContext !=NULL) cuCtxDetach(cuContext);
}


////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main(int argc, char** argv)
{
    runTest(argc, argv);

    CUT_EXIT(argc, argv);
}
