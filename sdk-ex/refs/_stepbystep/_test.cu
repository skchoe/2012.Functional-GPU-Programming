#include <GL/glew.h>
#include <GL/glut.h>

#include <cuda.h>
#include <cutil.h>
#include <cudaGL.h>
#include <stdio.h>
#include <stdlib.h>

CUfunction kernel;
CUdevice cuDevice;
CUcontext cuContext;
CUmodule cuModule;

void display()
{
 glClearColor( 0.0, 0.0, 0.8, 1.0);
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 glutSwapBuffers();
}


////////////////////////////////////////////////////////////////////////////////
//! Init for CUDA
////////////////////////////////////////////////////////////////////////////////
static CUresult
initCuda(CUfunction *pKernel, 
	int argc, char** argv)
{
    CUfunction cuFunction = 0;

    CUT_DEVICE_INIT_DRV(cuDevice);

    CUresult status = cuCtxCreate( &cuContext, 0, cuDevice );
    printf ("Ctx Creation: %d\n", status);
    if ( CUDA_SUCCESS != status )
    {    
      cuCtxDetach(cuContext);
      return status;
    }

    status = cuModuleLoad(&cuModule, "data/_test_kernel.cubin");
    printf ("ModuleLoad: %d\n", status);

    if ( CUDA_SUCCESS != status )
    {    
      cuCtxDetach(cuContext);
      return status;
    }     

    // Global function
    status = cuModuleGetFunction( &cuFunction, cuModule, "kernel" );
    printf("function loading: %d\n", status);
    if ( CUDA_SUCCESS != status)
    {    
      cuCtxDetach(cuContext);
      return status;
    }     

    *pKernel = cuFunction;

    return CUDA_SUCCESS;
}

//----------------------------------------------------------------------
int main(int argc, char** argv)
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
  glutInitWindowSize(512, 512);
  glutCreateWindow("BasicGL");

  glutDisplayFunc(display);
            
  kernel=NULL;
  initCuda(&kernel, argc, argv); 

  glewInit();
printf("cuGLInit()\t");
  CU_SAFE_CALL(cuGLInit());
printf("\n");
                                
  int sz = 20000;
  float* ptr = new float[sz];
  unsigned int size = sz*sizeof(float);
                                                              
  unsigned int vbo;
  glGenBuffers(1, &vbo);
  printf("VbO = %d\n", vbo);

  glBindBuffer(GL_ARRAY_BUFFER, vbo);
  glBufferData(GL_ARRAY_BUFFER,  size, (const void*) ptr, GL_DYNAMIC_DRAW);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
                                                              
printf("CUT check error gl\t");
  CUT_CHECK_ERROR_GL();
printf("\n");
							   
  //glutPostRedisplay();
                                                              
  CUdeviceptr devPtr;
  unsigned int ssize;
                                                              
printf("registerbufferobject\t");
  CU_SAFE_CALL(cuGLRegisterBufferObject(vbo));
printf("\n");
printf("glmapbufferobject\t");
  CU_SAFE_CALL(cuGLMapBufferObject(&devPtr, &ssize, vbo));
printf("\n");
                                                              
  // <<<<   PAY ATTENTION ....
  CU_SAFE_CALL(cuGLMapBufferObject(&devPtr, &ssize, vbo));
  printf("- size= %d, ssize= %d, devPtr= %d\n", size, ssize, devPtr);
                                                              
  CU_SAFE_CALL(cuGLMapBufferObject(&ssize, &devPtr, vbo));
  printf("- size= %d, ssize= %d, devPtr= %d\n", size, ssize, devPtr);
                                    
  glutMainLoop();
  
}

