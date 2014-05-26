/*
    Recursive Gaussian filter
    sgreen 8/1/08

    This code sample implements a Gaussian blur using Deriche's recursive method:
    http://citeseer.ist.psu.edu/deriche93recursively.html

    This is similar to the box filter sample in the SDK, but it uses the previous
    outputs of the filter as well as the previous inputs. This is also known as an
    IIR (infinite impulse response) filter, since its response to an input impulse
    can last forever.

    The main advantage of this method is that the execution time is independent of
    the filter width.
    
    The GPU processes columns of the image in parallel. To avoid uncoalesced reads
    for the row pass we transpose the image and then transpose it back again
    afterwards.

    The implementation is based on code from the CImg library:
    http://cimg.sourceforge.net/
    Thanks to David Tschumperlé and all the CImg contributors!
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <GL/glew.h>

#if defined (__APPLE__) || defined(MACOSX)
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include <cuda.h>
#include <cudaGL.h>
#include <cutil.h>

#include <cutil_math.h>

#define BLOCK_DIM 16 

typedef unsigned int uint;
typedef unsigned char uchar;

char *image_filename = "lena.ppm";
float sigma = 10.0f;
int order = 0;
int nthreads = 64;

unsigned int width, height;
uint* h_img = NULL;
CUdeviceptr d_img;
CUdeviceptr d_temp;

GLuint pbo = 0;     // OpenGL pixel buffer object
GLuint texid = 0;   // texture

unsigned int timer = 0;
int fpsCount = 0;        // FPS count for averaging
int fpsLimit = 1;        // FPS limit for sampling

CUfunction d_transpose;
CUfunction d_recursiveGaussian_rgba;

/*
    Transpose a 2D array (see SDK transpose example)
*/
void proc_transpose(CUdeviceptr d_dst, CUdeviceptr d_src, uint width, int height)
{
  //dim3 grid(width / BLOCK_DIM, height / BLOCK_DIM, 1);
  //dim3 threads(BLOCK_DIM, BLOCK_DIM, 1);
    CU_SAFE_CALL(cuFuncSetBlockShape(d_transpose, BLOCK_DIM, BLOCK_DIM, 1));
    CU_SAFE_CALL(cuParamSeti(d_transpose, 0, d_dst));
    CU_SAFE_CALL(cuParamSeti(d_transpose, 4, d_src));
    CU_SAFE_CALL(cuParamSeti(d_transpose, 8, width));
    CU_SAFE_CALL(cuParamSeti(d_transpose, 12,height));
    CU_SAFE_CALL(cuParamSetSize(d_transpose, 16));
    CU_SAFE_CALL(cuLaunchGrid(d_transpose, width / BLOCK_DIM, height / BLOCK_DIM));
    
    //d_transpose<<< grid, threads >>>(d_dest, d_src, width, height);
    CUT_CHECK_ERROR("Kernel execution failed");
}


/*
    Perform Gaussian filter on a 2D image using CUDA

    Parameters:
    d_src  - pointer to input image in device memory
    d_dest - pointer to destination image in device memory
    d_temp - pointer to temporary storage in device memory
    width  - image width
    height - image height
    sigma  - sigma of Gaussian
    order  - filter order (0, 1 or 2)
*/

void proc_gaussianFilter_rgba(CUdeviceptr d_src, CUdeviceptr d_dst, 
			      int length, int nthreads, 
			      float a0, float a1, float a2, float a3, 
			      float b1, float b2, float coefp, float coefn)
{
  int ngrid = length / nthreads;
  CU_SAFE_CALL(cuFuncSetBlockShape(d_recursiveGaussian_rgba, nthreads, 1, 1));
  CU_SAFE_CALL(cuParamSeti(d_recursiveGaussian_rgba, 0, d_src));
  CU_SAFE_CALL(cuParamSeti(d_recursiveGaussian_rgba, 4, d_dst));
  CU_SAFE_CALL(cuParamSeti(d_recursiveGaussian_rgba, 8, length));
  CU_SAFE_CALL(cuParamSeti(d_recursiveGaussian_rgba, 12, length));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 16, a0));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 20, a1));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 24, a2));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 28, a3));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 32, b1));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 36, b2));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 40, coefp));
  CU_SAFE_CALL(cuParamSetf(d_recursiveGaussian_rgba, 44, coefn));
  CU_SAFE_CALL(cuParamSetSize(d_recursiveGaussian_rgba, 48));
  CU_SAFE_CALL(cuLaunchGrid(d_recursiveGaussian_rgba, ngrid, 1));
}


// 8-bit RGBA version
void gaussianFilterRGBA(CUdeviceptr d_src, CUdeviceptr *pd_dest, CUdeviceptr d_temp, 
int width, int height, float sigma, int order)
{
    const float
        nsigma = sigma < 0.1f ? 0.1f : sigma,
        alpha = 1.695f / nsigma,
        ema = (float)std::exp(-alpha),
        ema2 = (float)std::exp(-2*alpha),
        b1 = -2*ema,
        b2 = ema2;

    float a0 = 0, a1 = 0, a2 = 0, a3 = 0, coefp = 0, coefn = 0;
    switch (order) {
    case 0: {
        const float k = (1-ema)*(1-ema)/(1+2*alpha*ema-ema2);
        a0 = k;
        a1 = k*(alpha-1)*ema;
        a2 = k*(alpha+1)*ema;
        a3 = -k*ema2;
    } break;

    case 1: {
        const float k = (1-ema)*(1-ema)/ema;
        a0 = k*ema;
        a1 = a3 = 0;
        a2 = -a0;
    } break;

    case 2: {
        const float
            ea = (float)std::exp(-alpha),
            k = -(ema2-1)/(2*alpha*ema),
            kn = (-2*(-1+3*ea-3*ea*ea+ea*ea*ea)/(3*ea+1+3*ea*ea+ea*ea*ea));
        a0 = kn;
        a1 = -kn*(1+k*alpha)*ema;
        a2 = kn*(1-k*alpha)*ema;
        a3 = -kn*ema2;
    } break;

    default:
        fprintf(stderr, "gaussianFilter: invalid order parameter!\n");
        return;
    }
    coefp = (a0+a1)/(1+b1+b2);
    coefn = (a2+a3)/(1+b1+b2);

    // process columns
//    d_simpleRecursive_rgba<<< width / nthreads, nthreads >>>(d_src, d_temp, width, height, sigma);

    proc_gaussianFilter_rgba(d_src, d_temp, width, nthreads, a0, a1, a2, a3, b1, b2, coefp, coefn);
    CUT_CHECK_ERROR("Kernel execution failed");

    proc_transpose(*pd_dest, d_temp, width, height);

    // process rows
//    d_simpleRecursive_rgba<<< width / nthreads, nthreads >>>(d_dest, d_temp, width, height, sigma);
    proc_gaussianFilter_rgba(*pd_dest, d_temp, height, nthreads, a0, a1, a2, a3, b1, b2, coefp, coefn);
    CUT_CHECK_ERROR("Kernel execution failed");

    proc_transpose(*pd_dest, d_temp, height, width);
}

// display results using OpenGL
void display()
{
    CUT_SAFE_CALL(cutStartTimer(timer));  

    // execute filter, writing results to pbo
    CUdeviceptr d_result;
    size_t size;
    CU_SAFE_CALL(cuGLMapBufferObject(&d_result, &size, pbo));
    //printf("**BO mapping done w/ %d, %d\n", d_result, size);
    gaussianFilterRGBA(d_img, &d_result, d_temp, width, height, sigma, order);
    CU_SAFE_CALL(cuGLUnmapBufferObject(pbo));
    //printf("**BO unmapping done\n");

    // load texture from pbo
    glBindBufferARB(GL_PIXEL_UNPACK_BUFFER_ARB, pbo);
    glBindTexture(GL_TEXTURE_2D, texid);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glBindBufferARB(GL_PIXEL_UNPACK_BUFFER_ARB, 0);

    // display results
    glClear(GL_COLOR_BUFFER_BIT);

    glEnable(GL_TEXTURE_2D);
    glDisable(GL_DEPTH_TEST);

    glBegin(GL_QUADS);
    glVertex2f(0, 0); glTexCoord2f(0, 0);
    glVertex2f(0, 1); glTexCoord2f(1, 0);
    glVertex2f(1, 1); glTexCoord2f(1, 1);
    glVertex2f(1, 0); glTexCoord2f(0, 1);
    glEnd();

    glDisable(GL_TEXTURE_2D);

    glutSwapBuffers();

    CUT_SAFE_CALL(cutStopTimer(timer));  

    fpsCount++;
    if (fpsCount == fpsLimit) {
        char fps[256];
        float ifps = 1.f / (cutGetAverageTimerValue(timer) / 1000.f);
        sprintf(fps, "CUDA Recursive Gaussian filter: %3.1f fps", ifps);
        glutSetWindowTitle(fps);
        fpsCount = 0; 
        fpsLimit = (int)max(ifps, 1.f);
        CUT_SAFE_CALL(cutResetTimer(timer));  
    }
}

void idle()
{
    glutPostRedisplay();
}

void keyboard(unsigned char key, int x, int y)
{
    switch(key) {
        case 27:
            exit(0);
            break;
        case '=':
        case '+':
            sigma+=0.1f;
            break;
        case '-':
            sigma-=0.1f;
            if (sigma < 0.0) sigma = 0.0f;
            break;
        case '0':
            order = 0;
            break;
        case '1':
            order = 1;
            sigma = 0.5f;
            break;
        case '2':
            order = 2;
            sigma = 0.5f;
            break;

        default:
            break;
    }
    printf("sigma = %f\n", sigma);
    glutPostRedisplay();
}

void reshape(int x, int y)
{
    glViewport(0, 0, x, y);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0, 1.0, 0.0, 1.0, 0.0, 1.0); 
}

void cleanup()
{
    CUT_SAFE_CALL( cutDeleteTimer( timer));
    free(h_img);

    CU_SAFE_CALL(cuMemFree(d_img));
    CU_SAFE_CALL(cuMemFree(d_temp));

    if (pbo) {
        CU_SAFE_CALL(cuGLUnregisterBufferObject(pbo));    
        glDeleteBuffersARB(1, &pbo);
    }
    if (texid) {
        glDeleteTextures(1, &texid);
    }
}

void initOpenGL()
{
    // create pixel buffer object to store final image
    glGenBuffersARB(1, &pbo);
    printf("pixel buffer id = %d\n", pbo);
    glBindBufferARB(GL_PIXEL_UNPACK_BUFFER_ARB, pbo);
    glBufferDataARB(GL_PIXEL_UNPACK_BUFFER_ARB, width*height*sizeof(GLubyte)*4, h_img, GL_STREAM_DRAW_ARB);
    glBindBufferARB(GL_PIXEL_UNPACK_BUFFER_ARB, 0);

    CU_SAFE_CALL(cuGLInit());
    CU_SAFE_CALL(cuGLRegisterBufferObject(pbo));

    // create texture for display
    glGenTextures(1, &texid);
    printf("tex-id  = %d\n", texid);
    glBindTexture(GL_TEXTURE_2D, texid);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glBindTexture(GL_TEXTURE_2D, 0);
}

void
benchmark(int iterations) 
{
    // allocate memory for result
    CUdeviceptr d_result;
    unsigned int size = width * height * sizeof(uint);
    printf("---begin benchmark\n");
    CU_SAFE_CALL(cuMemAlloc(&d_result, size));

    // warm-up
    gaussianFilterRGBA(d_img, &d_result, d_temp, width, height, sigma, order);

    CU_SAFE_CALL( cuCtxSynchronize() );
    CUT_SAFE_CALL( cutStartTimer( timer));

    // execute the kernel
    for(int i=0; i<iterations; i++) {
        gaussianFilterRGBA(d_img, &d_result, d_temp, width, height, sigma, order);
    }

    CU_SAFE_CALL( cuCtxSynchronize() );
    CUT_SAFE_CALL( cutStopTimer( timer));

    // check if kernel execution generated an error
    CUT_CHECK_ERROR("Kernel execution failed");

    printf("Processing time: %f (ms)\n", cutGetTimerValue( timer));
    printf("%.2f Mpixels/sec\n", (width*height*iterations / (cutGetTimerValue( timer) / 1000.0f)) / 1e6);

    CU_SAFE_CALL(cuMemFree(d_result));
    printf("--end benchmark\n");
}


////////////////////////////////////////////////////////////////////////////////
//! Init for CUDA
////////////////////////////////////////////////////////////////////////////////
//    CU_SAFE_CALL(initCudaContext(&cuDevice, &cuContext, argc, (char**)argv));
static CUresult
initCudaContext(CUcontext *pcuContext, CUdevice *pcuDevice,
        int argc, char** argv)
{
  //cuInit() is called by CUT_DEVICE_INIT_DRV
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

CUTBoolean initGL()
{
    // initialize necessary OpenGL extensions
    glewInit();
    if (! glewIsSupported( "GL_VERSION_2_0 " 
			   "GL_ARB_pixel_buffer_object")){
        fprintf( stderr, "ERROR: Support for necessary OpenGL extensions missing.");
        fflush( stderr);
        return CUTFalse;
    }
    return CUTTrue;
}

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main( int argc, char** argv) 
{

    CUT_DEVICE_INIT(argc, argv);

    char *filename;
    if (cutGetCmdLineArgumentstr(argc, (const char**) argv, "image", &filename)) {
        image_filename = filename;
    }
    cutGetCmdLineArgumenti(argc, (const char**) argv, "threads", &nthreads);
    cutGetCmdLineArgumentf(argc, (const char**) argv, "sigma", &sigma);
    CUTBoolean runBenchmark = cutCheckCmdLineFlag(argc, (const char**) argv, "bench");

    // load image from disk
    char* image_path = cutFindFilePath(image_filename, argv[0]);
    if (image_path == 0) {
        fprintf(stderr, "Error finding image file '%s'\n", image_filename);
        exit(EXIT_FAILURE);
    }

    CUT_SAFE_CALL( cutLoadPPM4ub(image_path, (unsigned char **) &h_img, &width, &height));
    if (!h_img) {
        printf("Error opening file '%s'\n", image_path);
        exit(-1);
    }
    printf("Loaded '%s', %d x %d pixels\n", image_path, width, height);

    // initialize cuda, module, kernel
    CUdevice cuDevice;
    CUcontext cuContext;
    CUmodule cuModule;
    initCudaContext(&cuContext, &cuDevice, argc, (char**)argv);
    loadModule(&cuModule, &cuContext, "data/recursiveGaussian_kernel.sm_10.cubin");
    loadKernel(&d_transpose, cuModule, "d_transpose");
    loadKernel(&d_recursiveGaussian_rgba, cuModule, "d_recursiveGaussian_rgba");
    printf("context Creation\n moduleLoading\ncalling kernel successful\n");

    // allocate device memory
    unsigned int size = width * height * sizeof(uint);
    /* runtime API
    CUDA_SAFE_CALL(cudaMalloc( (void**) &d_img, size));
    CUDA_SAFE_CALL(cudaMalloc( (void**) &d_temp, size));
    CUDA_SAFE_CALL(cudaMemcpy( d_img, h_img, size, cudaMemcpyHostToDevice));
    */
    // driver API
    CU_SAFE_CALL(cuMemAlloc(&d_img, size));
    CU_SAFE_CALL(cuMemAlloc(&d_temp, size));
    CU_SAFE_CALL(cuMemcpyHtoD(d_img, h_img, size));

    CUT_SAFE_CALL( cutCreateTimer( &timer));

    if (runBenchmark) {
        benchmark(100);
        cleanup();
        exit(0);
    }

    // initialize GLUT
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
    glutInitWindowSize(width, height);
    glutCreateWindow("CUDA Recursive Gaussian filter");

    // initialize GL
    if( CUTFalse == initGL() ) return 0;

    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);

    printf("Press '+' and '-' to change filter width\n");
    printf("0, 1, 2 - change filter order\n");

    glewInit();
    if (!glewIsSupported("GL_VERSION_2_0 GL_ARB_vertex_buffer_object GL_ARB_pixel_buffer_object")) {
        fprintf(stderr, "Required OpenGL extensions missing.");
        exit(-1);
    }
    else {printf("GLEW init detect Opengl 2.0 supported\n");}

    initOpenGL();

    atexit(cleanup);

    glutMainLoop();
    return 0;
}
