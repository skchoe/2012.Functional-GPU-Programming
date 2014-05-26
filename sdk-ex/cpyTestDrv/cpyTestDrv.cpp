// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <cuda.h>
#include <vector_types.h>
#include <cutil_inline.h>

extern "C"

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
initCuda(CUcontext cuContext, char* executablePath, CUfunction *mathop, 
	int argc, char** argv, const char* cubin_name, const char* kernel_name)
{
    CUdevice cuDevice;
    CUT_DEVICE_INIT_DRV(cuDevice, argc, argv);
    print_GetProperties(cuDevice);

    CUresult status = cuCtxCreate( &cuContext, 0, cuDevice );
    if ( CUDA_SUCCESS != status ) {
        Error(cuContext, status);
    }
    else printf("(1) context creation successful\n");

/*
    char* module_path = cutFindFilePath(cubin_name, executablePath);
    printf ("\t cubin:%s, path:%s, mmp_ptr:%lu\n", cubin_name, executablePath, module_path);
    printf ("\t cubin:%s, path:%s, module_path:%s\n", cubin_name, executablePath, *module_path);
*/
    char* data_path = "./data/";
    size_t len_path = strlen(data_path);
    size_t len_fn = strlen(cubin_name);
    // printf ("Sizes: data:%lu, cubinname:%lu\n", len_path, len_fn);

    char* module_path = (char*)malloc(sizeof(char) * (len_path + len_fn));
    strcpy(module_path, data_path);
    strcat(module_path, cubin_name);
    strcat(module_path, "\0");
    if (module_path == 0) {
        status = CUDA_ERROR_NOT_FOUND;
        Error(cuContext, status);
    }
    FILE *fp = fopen(module_path,"r");
    if( fp ) {
	printf("(2) cubin_File found in modulepath:%s\n", module_path);
        fclose(fp);
    } else {
	printf("(2) cubin file not exist: %s\n", module_path);
    }
    CUmodule cuModule;
    status = cuModuleLoad(&cuModule, module_path);
    cutFree(module_path);
    if ( CUDA_SUCCESS != status ) {
        Error(cuContext, status);
    }
    else printf ("(3) module Load successful\n");

    CUfunction cuFunction = 0;
    status = cuModuleGetFunction(&cuFunction, cuModule, kernel_name);
    if ( CUDA_SUCCESS != status) {
        Error(cuContext, status);
    }
    else printf ("(4) getFunction successful w/cuFunction:\n");

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
    CUfunction cpyTest = NULL;
    const char cubin_name [] = "cpyTestDrv_kernel.sm_10.cubin";
    const char kernel_name [] = "cpyTestDrv_kernel";

    CU_SAFE_CALL(initCuda(cuContext, argv[0], &cpyTest, argc, argv, cubin_name, kernel_name));
    printf("initCuda-returned CUfunction:\n");


    // Calling kernel
    int BLOCK_SIZE = 2;
    int GRID_SIZE = 2;
    cutilDrvSafeCallNoSync(cuFuncSetBlockShape(cpyTest, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE));

    // cuParamSetx, x=i f v
    // http://visionexperts.blogspot.com/2010/07/cuda-parameter-alignment.html - check alignment
    #define ALIGN_UP(offset, alignment)					\
        (offset) = ((offset) + (alignment) - 1) & ~((alignment) - 1)

    size_t count = 0;
    void* ptr;
    size_t offset = 0;

    int array_count = 5;
    int mem_size = array_count * sizeof(float);

    // receiver d_array_out
    CUdeviceptr d_array_out;
    cuMemAlloc(&d_array_out, mem_size);
    ptr = (void*) (size_t) d_array_out;
    printf("ptr=%p, \t &ptr=%p\n", ptr, &ptr);
    ALIGN_UP(offset, __alignof(ptr));
    CU_SAFE_CALL(cuParamSetv(cpyTest, offset, &ptr, sizeof(ptr)));
    printf("________d_array_out:offset:%lu, size:%lu\n", offset, sizeof(ptr));
    offset += sizeof(ptr);

    // sender h_array_in
    float* h_array_in = (float*)malloc(mem_size);
    for(int i = 0 ; i < array_count ; i++){
      *(h_array_in+i) = rand()/(float)RAND_MAX;
      printf ("<%d>=%f\t", i, *(h_array_in+i));
    }
    printf("\n");

    CUdeviceptr d_array_in;
    cuMemAlloc(&d_array_in, mem_size);
    cuMemcpyHtoD(d_array_in, (void*)h_array_in, mem_size);

    // sender d_array_in
    ptr = (void*)(size_t)d_array_in;
    ALIGN_UP(offset, __alignof(ptr));
    CU_SAFE_CALL(cuParamSetv(cpyTest, offset, &ptr, sizeof(ptr)));
    printf("________d_array_in:offset:%lu, size:%lu\n", offset, sizeof(ptr));
    offset +=sizeof(ptr);

    //size of array in d_array_in
    printf("align of integer = %lu, alignof ptr of integer=%lu\n", __alignof(count), __alignof(&count));
    printf("sizeof of ptr = %lu, alignof ptr of size_t=%lu\n", sizeof(ptr), __alignof(ptr));
    ALIGN_UP(offset, __alignof(count));
    CU_SAFE_CALL(cuParamSeti(cpyTest, offset, array_count));
    printf("________count:offset:%lu, count:%d\n", offset, array_count);
    offset +=sizeof(array_count);

    // mem1 for return value
    CUdeviceptr d_memst;
    size_t memst_size = 12 * sizeof (size_t);
    CU_SAFE_CALL(cuMemAlloc(&d_memst, memst_size));
    printf("device pointer = %d\n", d_memst);

    ptr = (void*)(size_t)d_memst;
    ALIGN_UP(offset, __alignof(ptr));
    printf("offset:%lu, align:%lu, sizeof_ptr:%lu, align_256:%lu\n", offset, __alignof(ptr), sizeof(ptr), __alignof(256));
    CU_SAFE_CALL(cuParamSetv(cpyTest, offset, &ptr, sizeof(ptr))); 
    printf("________d_memst:offset:%lu, size:%lu\n", offset, sizeof(ptr));
    offset += sizeof(ptr);

    // receiver d_single
    CUdeviceptr d_single;
    count = 1;
    size_t isize = count * sizeof(int);
    cutilDrvSafeCallNoSync(cuMemAlloc(&d_single, isize));
    printf("device pointer = %d\n", d_single);

    ptr = (void*)(size_t)d_single;
    ALIGN_UP(offset, __alignof(ptr));
    CU_SAFE_CALL(cuParamSeti(cpyTest, offset, d_single));
    printf("________d_single:offset:%lu, d_single:%u\n", offset, d_single);
    offset += sizeof(ptr);

    // sender h_single
    size_t h_single_in;
    h_single_in = 256;//atof(argv[1]);
    ALIGN_UP(offset, __alignof(h_single_in));
    CU_SAFE_CALL(cuParamSeti(cpyTest, offset, h_single_in));
    printf("________h_single_in:offset:%lu, d_single:%d\n", offset, h_single_in);
    offset += sizeof(h_single_in);

    CU_SAFE_CALL(cuParamSetSize(cpyTest, offset));
    CU_SAFE_CALL(cuLaunchGrid(cpyTest, GRID_SIZE, GRID_SIZE));

    size_t* h_memst = (size_t*) malloc (memst_size);
    cuMemcpyDtoH((void*)h_memst, d_memst, memst_size);
    //CU_SAFE_CALL(cuMemcpyDtoH((void*)h_memst, d_memst, memst_size));
    for(int j = 0 ; j < 12 ; j++)
      printf("memst [%d] = %u\n", j, h_memst[j]);

    //CU_SAFE_CALL(cuMemFree(d_memst));
    cuMemFree(d_memst);

    size_t* h_single_out = (size_t*) malloc (isize);
    cuMemcpyDtoH((void*)h_single_out, d_single, isize);
    printf("hout  = %u\n", *h_single_out);
    cuMemFree(d_single);

    //check if d_array_in has right valuse
    float* h_array_out = (float*)malloc(mem_size);
    cuMemcpyDtoH((void*)h_array_out, d_array_out, mem_size);

    for(int i = 0 ; i < array_count ; i++){
      float value_d = *(h_array_out+i);
      printf ("[%d]=%f\t", i, value_d);
    }
    printf("\n");
    // end of checking
    //

    //check if d_array_in has right valuse
    float* h_array_newin = (float*)malloc(mem_size);
    cuMemcpyDtoH((void*)h_array_newin, d_array_in, mem_size);

    for(int i = 0 ; i < array_count ; i++){
      float value_d = *(h_array_newin+i);
      printf ("[%d]=%f\t", i, value_d);
    }
    printf("\n");
    free(h_array_newin);
    // end of checking
    
    free(h_array_in);
    free(h_array_out);
    free(h_memst);

    //CU_SAFE_CALL_NO_SYNC(cuCtxDetach(cuContext));
    cuCtxDetach(cuContext);
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
