
/* Example showing the use of CUFFT for fast 1D-convolution using FFT. */

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

// includes, project
#include <cuda.h>
#include <cufft.h>
#include <cutil.h>


CUfunction kernel;
CUdevice cuDevice;
CUcontext cuContext;
CUmodule cuModule;

static CUresult initCUDA(char*, CUfunction *pMatrixMul, int, char**);

// Complex data type
typedef float2 Complex; 
static __host__ inline Complex ComplexMul(Complex, Complex);

// Filtering functions
extern "C"
void Convolve(const Complex*, int, const Complex*, int, Complex*);

// Padding functions
int PadData(const Complex*, Complex**, int,
            const Complex*, Complex**, int);

////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest(int argc, char** argv);

// The filter size is assumed to be a number smaller than the signal size
#define SIGNAL_SIZE        50
#define FILTER_KERNEL_SIZE 11

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int main(int argc, char** argv) 
{
    runTest(argc, argv);

    CUT_EXIT(argc, argv);
}

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA

////////////////////////////////////////////////////////////////////////////////
void runTest(int argc, char** argv) 
{

    CUfunction ComplexPointwiseMulAndScale = NULL;
    CU_SAFE_CALL(initCUDA(argv[0], & ComplexPointwiseMulAndScale, argc, argv));

//    CUT_DEVICE_INIT(argc, argv);


    // Allocate host memory for the signal
    Complex* h_signal = (Complex*)malloc(sizeof(Complex) * SIGNAL_SIZE);
    // Initalize the memory for the signal
    printf("d_signal_before padding-----------------\n");
    for (unsigned int i = 0; i < SIGNAL_SIZE; ++i) {
        h_signal[i].x = rand() / (float)RAND_MAX;
        h_signal[i].y = 0;
	printf("(%f, %f)\t", h_signal[i].x, h_signal[i].y);
    }

    // Allocate host memory for the filter
    Complex* h_filter_kernel = (Complex*)malloc(sizeof(Complex) * FILTER_KERNEL_SIZE);
    // Initalize the memory for the filter
    printf("d_filter_kernel_before padding----------------\n");
    for (unsigned int i = 0; i < FILTER_KERNEL_SIZE; ++i) {
        h_filter_kernel[i].x = rand() / (float)RAND_MAX;
        h_filter_kernel[i].y = 0;
	printf("(%f, %f)\t", h_filter_kernel[i].x, h_filter_kernel[i].y);
    }

    // Pad signal and filter kernel
    Complex* h_padded_signal;
    Complex* h_padded_filter_kernel;
    int new_size = PadData(h_signal, &h_padded_signal, SIGNAL_SIZE,
                           h_filter_kernel, &h_padded_filter_kernel, FILTER_KERNEL_SIZE);
    int mem_size = sizeof(Complex) * new_size;

    printf("newsize = %d\t, memsize = %d\n", new_size, mem_size);
    printf("h_padded_signal--------------------\n");
    for (unsigned int i = 0; i < new_size; ++i) {
      printf("(%f, %f)\t", h_padded_signal[i].x, h_padded_signal[i].y);
    }

    printf("h_padded_filter kernel--------------------\n");
    for (unsigned int i = 0; i < new_size; ++i) {
      printf("(%f, %f)\t", 
	     h_padded_filter_kernel[i].x, h_padded_filter_kernel[i].y);
    }

    // Allocate device memory for signal
    CUdeviceptr d_signal;
    CU_SAFE_CALL(cuMemAlloc(&d_signal, mem_size));
    // Copy host memory to device
    CU_SAFE_CALL(cuMemcpyHtoD(d_signal, h_padded_signal, mem_size));

    // Allocate device memory for filter kernel
    CUdeviceptr d_filter_kernel;
    CU_SAFE_CALL(cuMemAlloc(&d_filter_kernel, mem_size));

    // Copy host memory to device
    CU_SAFE_CALL(cuMemcpyHtoD(d_filter_kernel, h_padded_filter_kernel, mem_size));

    // CUFFT plan
    cufftHandle plan;  
    CUFFT_SAFE_CALL(cufftPlan1d(&plan, new_size, CUFFT_C2C, 1));
    printf("plan returned = %d\n", plan);

    // Transform signal and kernel
    CUFFT_SAFE_CALL(cufftExecC2C(plan, (cufftComplex *)d_signal, 
				 (cufftComplex *)d_signal, CUFFT_FORWARD));

    cufftComplex* z = (cufftComplex*)malloc(sizeof(cufftComplex) * new_size);
    cuMemcpyDtoH(z, d_signal, mem_size);
    /*
    for(int i = 0 ; i < new_size ; i++)
      {
	cufftComplex z1 = (cufftComplex)z[i];
	printf("read, img (%d)= %f, %f\n", i, z1.x, z1.y);
      }
    */
    CUFFT_SAFE_CALL(cufftExecC2C(plan, (cufftComplex *)d_filter_kernel, (cufftComplex *)d_filter_kernel, CUFFT_FORWARD));

    // Multiply the coefficients together and normalize the result
    //    ComplexPointwiseMulAndScale<<<32, 256>>>(d_signal, d_filter_kernel, new_size, 1.0f / new_size);
    CU_SAFE_CALL(cuFuncSetBlockShape (ComplexPointwiseMulAndScale, 256, 1, 1));
    CU_SAFE_CALL(cuParamSeti (ComplexPointwiseMulAndScale, 0, d_signal));
    CU_SAFE_CALL(cuParamSeti (ComplexPointwiseMulAndScale, 4, d_filter_kernel));
    CU_SAFE_CALL(cuParamSeti (ComplexPointwiseMulAndScale, 8, new_size));
    CU_SAFE_CALL(cuParamSetf (ComplexPointwiseMulAndScale, 12, 1.0f / new_size));
    CU_SAFE_CALL(cuParamSetSize (ComplexPointwiseMulAndScale, 16));
    CU_SAFE_CALL(cuLaunchGrid (ComplexPointwiseMulAndScale, 32, 1));

    // Check if kernel execution generated and error
    //CUT_CHECK_ERROR("Kernel execution failed [ ComplexPointwiseMulAndScale ]");

    // Transform signal back
    CUFFT_SAFE_CALL(cufftExecC2C(plan, (cufftComplex *)d_signal, (cufftComplex *)d_signal, CUFFT_INVERSE));

    // Copy device memory to host
    Complex* h_convolved_signal = h_padded_signal;
    CU_SAFE_CALL(cuMemcpyDtoH((void*)h_convolved_signal, d_signal, mem_size));

    // Allocate host memory for the convolution result
    Complex* h_convolved_signal_ref = (Complex*)malloc(sizeof(Complex) * SIGNAL_SIZE);

    // Convolve on the host
    Convolve(h_signal, SIGNAL_SIZE,
             h_filter_kernel, FILTER_KERNEL_SIZE,
             h_convolved_signal_ref);


    // check result
    for(int k = 0 ; k < SIGNAL_SIZE ; k++)
    {
      Complex cpxr = h_convolved_signal_ref[k];
      //      printf("h_convolved_Signal_ref (%f, %f)\t", cpxr.x, cpxr.y);
      Complex cpx = h_convolved_signal[k];
      //printf("h_convolved_Signal (%f, %f)\n", cpx.x, cpx.y);
    }
    CUTBoolean res = cutCompareL2fe((float*)h_convolved_signal_ref, (float*)h_convolved_signal, 2 * SIGNAL_SIZE, 1e-5f);
    printf("Test %s\n", (1 == res) ? "PASSED" : "FAILED");

    //Destroy CUFFT context
    CUFFT_SAFE_CALL(cufftDestroy(plan));

    // cleanup memory
    free(h_signal);
    free(h_filter_kernel);
    free(h_padded_signal);
    free(h_padded_filter_kernel);
    free(h_convolved_signal_ref);
    CU_SAFE_CALL(cuMemFree(d_signal));
    CU_SAFE_CALL(cuMemFree(d_filter_kernel));

}

// Pad data
int PadData(const Complex* signal, Complex** padded_signal, int signal_size,
            const Complex* filter_kernel, Complex** padded_filter_kernel, int filter_kernel_size)
{

    int minRadius = filter_kernel_size / 2;
    int maxRadius = filter_kernel_size - minRadius;
    int new_size = signal_size + maxRadius;
    
    printf("PadData: signal_size = %d, filter_kernel_size  =%d,  minR = %d maxR = %d, newsize = %d\n", signal_size, filter_kernel_size, minRadius, maxRadius, new_size);

    // Pad signal
    Complex* new_data = (Complex*)malloc(sizeof(Complex) * new_size);
    memcpy(new_data + 0, signal, signal_size * sizeof(Complex));
    memset(new_data + signal_size, 0, (new_size - signal_size) * sizeof(Complex));
    *padded_signal = new_data;
    
    // Pad filter
    new_data = (Complex*)malloc(sizeof(Complex) * new_size);  
    memcpy(new_data + 0, filter_kernel + minRadius, maxRadius * sizeof(Complex));
    memset(new_data + maxRadius, 0, (new_size - filter_kernel_size) * sizeof(Complex));   
    memcpy(new_data + new_size - minRadius, filter_kernel, minRadius * sizeof(Complex));
    *padded_filter_kernel = new_data;
    
    return new_size;
}
////////////////////////////////////////////////////////////////////////////////
// Complex operations
////////////////////////////////////////////////////////////////////////////////

// Complex multiplication
static inline Complex ComplexMul(Complex a, Complex b)
{
    Complex c;
    c.x = a.x * b.x - a.y * b.y;
    c.y = a.x * b.y + a.y * b.x;
    return c;
}

static CUresult
initCUDA(char* executablePath, CUfunction *pKernel, 
	int argc, char** argv)
{
    CUfunction cuFunction = 0;
    char* module_path;

    CUT_DEVICE_INIT_DRV(cuDevice, argc, argv);

    CUresult status = cuCtxCreate( &cuContext, 0, cuDevice );
    if ( CUDA_SUCCESS != status ) {
    	printf("1:%d\n", status);
        goto Error;
	}

    module_path = cutFindFilePath("simpleCUFFTDrv_kernel.cubin", executablePath);
    if (module_path == 0) {
        status = CUDA_ERROR_NOT_FOUND;
    	printf("2:%d\n", status);
        goto Error;
    }

    status = cuModuleLoad(&cuModule, module_path);
    cutFree(module_path);
    if ( CUDA_SUCCESS != status ) {
    	printf("3:%d\n", status);
        goto Error;
    }

    status = cuModuleGetFunction( &cuFunction, cuModule, "ComplexPointwiseMulAndScale" );
    if ( CUDA_SUCCESS != status) {
    	printf("4:%d\n", status);
        goto Error;
	}
    *pKernel = cuFunction;
    return CUDA_SUCCESS;
Error:
printf("initCuda is n't SUCESS, code=%d\n", status);
    cuCtxDetach(cuContext);
    return status;
}
