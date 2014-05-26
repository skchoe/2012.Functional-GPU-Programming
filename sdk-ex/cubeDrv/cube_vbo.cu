
/* Copyright (c) Mark J. Kilgard, 1997. */

/* This program is freely distributable without licensing fees 
   and is provided without guarantee or warrantee expressed or 
   implied. This program is -not- in the public domain. */

/* This program was requested by Patrick Earl; hopefully someone else
   will write the equivalent Direct3D immediate mode program. */

/* Seungkeol Choe modify the code to support vbo, CUDA */

#define GL_GLEXT_PROTOTYPES

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <GL/gl.h>
#include <GL/glut.h>
#include <GL/glext.h>

// includes
#include <cuda.h>
#include <cutil.h>
#include <cutil_gl_error.h>
#include <cudaGL.h>

// cube ///////////////////////////////////////////////////////////////////////
//    v6----- v5
//   /|      /|
//  v1------v0|
//  | |     | |
//  | |v7---|-|v4
//  |/      |/
//  v2------v3

// vertex coords array
GLfloat vertices[] = {1,1,1,  -1,1,1,  -1,-1,1,  1,-1,1,        // v0-v1-v2-v3
                      1,1,1,  1,-1,1,  1,-1,-1,  1,1,-1,        // v0-v3-v4-v5
                      1,1,1,  1,1,-1,  -1,1,-1,  -1,1,1,        // v0-v5-v6-v1
                      -1,1,1,  -1,1,-1,  -1,-1,-1,  -1,-1,1,    // v1-v6-v7-v2
                      -1,-1,-1,  1,-1,-1,  1,-1,1,  -1,-1,1,    // v7-v4-v3-v2
                      1,-1,-1,  -1,-1,-1,  -1,1,-1,  1,1,-1
		      
		      };   // v4-v7-v6-v5

// normal array
GLfloat normals[] = {0,0,1,  0,0,1,  0,0,1,  0,0,1,             // v0-v1-v2-v3
		     1,0,0,  1,0,0,  1,0,0, 1,0,0,              // v0-v3-v4-v5
                     0,1,0,  0,1,0,  0,1,0, 0,1,0,              // v0-v5-v6-v1
                     -1,0,0,  -1,0,0, -1,0,0,  -1,0,0,          // v1-v6-v7-v2
                     0,-1,0,  0,-1,0,  0,-1,0,  0,-1,0,         // v7-v4-v3-v2
                     0,0,-1,  0,0,-1,  0,0,-1,  0,0,-1
		     
};        // v4-v7-v6-v5

// color array
GLfloat colors[] = {1,1,1,  1,1,0,  1,0,0,  1,0,1,              // v0-v1-v2-v3
                    1,1,1,  1,0,1,  0,0,1,  0,1,1,              // v0-v3-v4-v5
                    1,1,1,  0,1,1,  0,1,0,  1,1,0,              // v0-v5-v6-v1
                    1,1,0,  0,1,0,  0,0,0,  1,0,0,              // v1-v6-v7-v2
                    0,0,0,  0,0,1,  1,0,1,  1,0,0,              // v7-v4-v3-v2
                    0,0,1,  0,0,0,  0,1,0,  0,1,1               // v4-v7-v6-v5
		    };             


GLuint vboId = 0;

// prototypes
void display(void);
void reshape(int w, int h);
void init(void);
void initVBO(void);

CUfunction kernel;
CUdevice cuDevice;
CUcontext cuContext;
CUmodule cuModule;

int flagG = 1;

void runCuda( GLuint vbo, CUfunction func)
{

    // flag control
    float var;
    if(flagG==0){ var = 0.5f; flagG=1;}
    else{ var = 2.0f;  flagG=0;}

    // map OpenGL buffer object for writing from CUDA
    CUdeviceptr dptr;
    unsigned int size;
    CU_SAFE_CALL(cuGLMapBufferObject( &dptr, &size, vbo));

    printf("runCuda (vbo, anim) = %d\n", vbo);

    // execute the func
    int BLOCK_SIZE_X = 8;
    int BLOCK_SIZE_Y = 9;

    // idx vars
    CUdeviceptr dim_dx;
    CUdeviceptr dim_dy;

    // random gen.
    float rd = (float)((double)rand()/((double)(RAND_MAX)+(double)(1)));
    printf ("random no = %f\n", rd);


    CU_SAFE_CALL(cuMemAlloc(&dim_dx, (BLOCK_SIZE_X * sizeof(int))));
    CU_SAFE_CALL(cuMemAlloc(&dim_dy, (BLOCK_SIZE_Y * sizeof(int))));

    // setup execution parameters
    CU_SAFE_CALL(cuFuncSetBlockShape( func, BLOCK_SIZE_X, BLOCK_SIZE_Y, 1 ));
    CU_SAFE_CALL(cuParamSeti( func, 0,  dptr));
    CU_SAFE_CALL(cuParamSeti( func, 4,  BLOCK_SIZE_X));
    CU_SAFE_CALL(cuParamSetf( func, 8,  rd));
    CU_SAFE_CALL(cuParamSetf( func, 12, var));
    CU_SAFE_CALL(cuParamSeti( func, 16, dim_dx));
    CU_SAFE_CALL(cuParamSeti( func, 20, dim_dy));
    CU_SAFE_CALL(cuParamSetSize( func, 24 ));

//    CU_SAFE_CALL(cuFuncSetSharedSize( func,
//        3*BLOCK_SIZE_X*BLOCK_SIZE_Y*sizeof(float) ) );

    CU_SAFE_CALL(cuLaunchGrid( func, 1, 1));

    int* dim_hx = (int*)malloc(BLOCK_SIZE_X * sizeof(int));
    int* dim_hy = (int*)malloc(BLOCK_SIZE_Y * sizeof(int));
    CU_SAFE_CALL(cuMemcpyDtoH((void *)dim_hx, dim_dx, (BLOCK_SIZE_X) * sizeof(int)));
    CU_SAFE_CALL(cuMemcpyDtoH(dim_hy, dim_dy, (BLOCK_SIZE_Y) * sizeof(int)));

    int j;
    for(j=0;j < BLOCK_SIZE_X; j++)
      printf ("Index X = %d\t", *(dim_hx + j));
    printf ("\n");
    for(j=0;j < BLOCK_SIZE_Y; j++)
      printf ("Index Y = %d\t", *(dim_hy + j));
    printf ("\n");


    // unmap buffer object
    CU_SAFE_CALL(cuGLUnmapBufferObject(vbo));
}

void
display(void)
{
  runCuda(vboId, kernel);

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

  glPushMatrix();
  
  glTranslatef(-.5, -.5, -.5);

  // bind VBOs with IDs and set the buffer offsets of the bound VBOs
  // When buffer object is bound with its ID, all pointers in gl*Pointer()
  // are treated as offset instead of real pointer.
  //  glBindBufferARB(GL_ARRAY_BUFFER_ARB, vboId);
  glBindBuffer(GL_ARRAY_BUFFER_ARB, vboId);

  printf ("glBindBuffer -> vboId = %d\n", vboId);

  // enable vertex arrays
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);
  
  // before draw, specify vertex and index arrays with their offsets
  glNormalPointer(GL_FLOAT, 0, (void*)sizeof(vertices));
  glColorPointer(3, GL_FLOAT, 0, (void*)(sizeof(vertices)+sizeof(normals)));
  glVertexPointer(3, GL_FLOAT, 0, 0);

  glDrawArrays(GL_QUADS, 0, 24);

  glDisableClientState(GL_VERTEX_ARRAY);  // disable vertex arrays
  glDisableClientState(GL_COLOR_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);

  // it is good idea to release VBOs with ID 0 after use.
  // Once bound with 0, all pointers in gl*Pointer() behave as real
  // pointer, so, normal vertex array operations are re-activated
  glBindBuffer(GL_ARRAY_BUFFER_ARB, 0);

  glPopMatrix();

  glutSwapBuffers();
}
void 
reshape(int w, int h)
{
    // set viewport to be the entire window
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);

    // set perspective viewing frustum
    // float aspectRatio = (float)w / h;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0f, (float)(w)/h, 1.0f, 1000.0f); // FOV, AspectRatio, NearClip, FarClip

    // switch to modelview matrix in order to set scene
    glMatrixMode(GL_MODELVIEW);
}

void
init(void)
{
  glShadeModel(GL_SMOOTH);
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  glClearColor(0, 0, 0, 1);

  // set up light colors (ambient, diffuse, specular)
  GLfloat lightKa[] = {.2f, .2f, .2f, 1.0f};  // ambient light
  GLfloat lightKd[] = {.7f, .7f, .7f, 1.0f};  // diffuse light
  GLfloat lightKs[] = {1, 1, 1, 1};           // specular light
  glLightfv(GL_LIGHT0, GL_AMBIENT, lightKa);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, lightKd);
  glLightfv(GL_LIGHT0, GL_SPECULAR, lightKs);

  // position the light
  float lightPos[4] = {0, 0, 20, 1}; // positional light
  glLightfv(GL_LIGHT0, GL_POSITION, lightPos);
  
  glEnable(GL_LIGHT0); // MUST enable each light source after configuration

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  int posX=0, posY=0, posZ=5;
  int targetX=0, targetY=0, targetZ=0;
  int upX=0, upY=1, upZ=0;
  gluLookAt(posX, posY, posZ, targetX, targetY, targetZ, upX, upY, upZ);

}

void
initVBO(void)
{
  // create vertex buffer objects, you need to delete them when program exits
  // Try to put both vertex coords array, vertex normal array and vertex color 
  //   in the same buffer object.
  // glBufferDataARB with NULL pointer reserves only memory space.
  // Copy actual data with 2 calls of glBufferSubDataARB, one for vertex coords 
  //   and one for normals.
  // target flag is GL_ARRAY_BUFFER_ARB, and usage flag is GL_STATIC_DRAW_ARB
  //  glGenBuffersARB(1, &vboId);
  glGenBuffers(1, &vboId);

  printf ("glGenBuffers -> vboId = %d\n", vboId);

  glBindBuffer(GL_ARRAY_BUFFER_ARB, vboId);

  glBufferData(GL_ARRAY_BUFFER_ARB, sizeof(vertices)
                                   +sizeof(normals)   
                                   +sizeof(colors), 
		  0, GL_DYNAMIC_DRAW_ARB);

  // copy vertices starting from 0 offest  
  glBufferSubData(GL_ARRAY_BUFFER_ARB, 0, sizeof(vertices), vertices);

  // copy normals after vertices
  glBufferSubData(GL_ARRAY_BUFFER_ARB, sizeof(vertices), sizeof(normals), normals);

  // copy colours after normals
  glBufferSubData(GL_ARRAY_BUFFER_ARB, sizeof(vertices)+sizeof(normals), 
		     sizeof(colors), colors);

  glBindBuffer (GL_ARRAY_BUFFER_ARB, 0);


  // register buffer object with CUDA
  CU_SAFE_CALL(cuGLInit());
  CU_SAFE_CALL(cuGLRegisterBufferObject(vboId));

  CUT_CHECK_ERROR_GL();
}

static CUresult
initCuda(CUfunction *pKernel,
        int argc, char** argv)
{
    CUfunction cuFunction = 0;

    CUT_DEVICE_INIT_DRV(cuDevice, argc, argv);

    CUresult status = cuCtxCreate( &cuContext, 0, cuDevice );
    printf ("Ctx Creation: %d\n", status);
    if ( CUDA_SUCCESS != status )
    {
      cuCtxDetach(cuContext);
      return status;
    }

    status = cuModuleLoad(&cuModule, "data/cube_kernel.cubin");
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



int
main(int argc, char **argv)
{
  CUT_DEVICE_INIT(argc, argv);

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
  glutInitWindowSize(800, 600);
  glutInitWindowPosition(400, 300);
  glutCreateWindow("color cube by vertex buffer object");
  glutDisplayFunc(display);
  glutReshapeFunc(reshape);
  init();

  kernel = NULL;
  CU_SAFE_CALL(initCuda(&kernel, argc, argv));

  initVBO();

  int seed = 1000;
  srand(seed);

  runCuda(vboId, kernel);

  glutMainLoop();
  return 0;             /* ANSI C requires main to return int. */
}
