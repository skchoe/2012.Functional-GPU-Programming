#ifdef _WIN32
#  define WINDOWS_LEAN_AND_MEAN
#  define NOMINMAX
#  include <windows.h>
#endif

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

// includes, GL
#include <GL/glew.h>
#include <GL/glut.h>

// includes
#include <cuda.h>
#include <cutil.h>
#include <cutil_gl_error.h>
#include <cudaGL.h>


////////////////////////////////////////////////////////////////////////////////
// constants
const unsigned int window_width = 512;
const unsigned int window_height = 512;

const unsigned int mesh_width = 8;
const unsigned int mesh_height = 9;

// vbo variables
GLuint *vboId;

float anim = 0.0;

// mouse controls
int mouse_old_x, mouse_old_y;
int mouse_buttons = 0;
float rotate_x = 0.0, rotate_y = 0.0;
float translate_z = -3.0;

int flagG = 0;

const float vertices [] = 
{1.0, 1.0, 1.0,  -1.0, 1.0, 1.0,  -1.0, -1.0, 1.0,  1.0, -1.0, 1.0, //0-1-2-3
1.0, -1.0, -1.0,  -1.0, -1.0, -1.0,  -1.0, 1.0, -1.0,  1.0, 1.0, -1.0,//4-7-6-5
-1.0, -1.0, -1.0,  1.0, -1.0, -1.0,  1.0, -1.0, 1.0,  -1.0, -1.0, 1.0,//7-4-3-2
-1.0, 1.0, 1.0,  -1.0, 1.0, -1.0,  -1.0, -1.0, -1.0,  -1.0, -1.0, 1.0,//1-6-7-2
1.0, 1.0, 1.0,  1.0, 1.0, -1.0,  -1.0, 1.0, -1.0,  -1.0, 1.0, 1.0, //0-5-6-1
1.0, 1.0, 1.0,  1.0, -1.0, 1.0,  1.0, -1.0, -1.0,  1.0, 1.0, -1.0, //0-3-4-5
};

const float normals  [] = 
{0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0,// v0-v1-v2-v3
0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0,  0.0, -1.0, 0.0, 0.0, -1.0,// v4-v7-v6-v5
0.0, -1.0, 0.0, 0.0, -1.0,  0.0, 0.0, -1.0,  0.0, 0.0, -1.0, 0.0,// v7-v4-v3-v2
-1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0,// v1-v6-v7-v2
0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0,  0.0, 1.0, 0.0,// v0-v5-v6-v1
1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0,  1.0, 0.0, 0.0,// v0-v3-v4-v5
};

const float colors [] = 
{1.0, 1.0, 1.0,  1.0, 1.0, 0.0,  1.0, 0.0, 0.0,  1.0, 0.0, 1.0,// v0-v1-v2-v3
0.0, 0.0, 1.0,  0.0, 0.0, 0.0,  0.0, 1.0, 0.0,  0.0, 1.0, 1.0, // v4-v7-v6-v5
0.0, 0.0, 0.0,  0.0, 0.0, 1.0,  1.0, 0.0, 1.0,  1.0, 0.0, 0.0, // v7-v4-v3-v2
1.0, 1.0, 0.0,  0.0, 1.0, 0.0,  0.0, 0.0, 0.0,  1.0, 0.0, 0.0, // v1-v6-v7-v2
1.0, 1.0, 1.0,  0.0, 1.0, 1.0,  0.0, 1.0, 0.0,  1.0, 1.0, 0.0, // v0-v5-v6-v1
1.0, 1.0, 1.0,  1.0, 0.0, 1.0,  0.0, 0.0, 1.0,  0.0, 1.0, 1.0, // v0-v3-v4-v5
}; 
////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest( int argc, char** argv);

// GL functionality
CUTBoolean initGL();
void createVBO( GLuint* vbo);
void deleteVBO( GLuint* vbo);

// rendering callbacks
void display();
void keyboard( unsigned char key, int x, int y);
void mouse(int button, int state, int x, int y);
void motion(int x, int y);

// Cuda functionality
void runCuda( GLuint* vbo, CUfunction knl);

CUfunction kernel;
CUdevice cuDevice;
CUcontext cuContext;
CUmodule cuModule;

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int main( int argc, char** argv)
{
    runTest( argc, argv);

    CUT_EXIT(argc, argv);
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

    status = cuModuleLoad(&cuModule, "data/cube_kernel.cubin");
    printf ("ModuleLoad: %d\n", status);

//    cutFree(module_path);
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

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA
////////////////////////////////////////////////////////////////////////////////
void runTest( int argc, char** argv)
{
    CUT_DEVICE_INIT(argc, argv);

    // Create GL context
    glutInit( &argc, argv);
    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE);
    glutInitWindowSize( window_width, window_height);
    glutCreateWindow( "Cuda GL interop");

    // initialize GL
    if( CUTFalse == initGL()) {
        return;
    }

    // register callbacks
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glutMouseFunc(mouse);
    glutMotionFunc(motion);

    // Cuda Driver Init
    kernel = NULL;
    CU_SAFE_CALL(initCuda(&kernel, argc, argv));


    // create VBO
    createVBO(vboId);
    printf ("INITIALIZE OF SIMPLEL\n");
    // run the cuda part
    runCuda(vboId, kernel);

    // start rendering mainloop
    glutMainLoop();

}

////////////////////////////////////////////////////////////////////////////////
//! Run the Cuda part of the computation
////////////////////////////////////////////////////////////////////////////////
void runCuda( GLuint* vbo, CUfunction func)
{
    if(flagG==0) flagG = 1; 
    else flagG = 0;

    // map OpenGL buffer object for writing from CUDA
    CUdeviceptr dptr;
    unsigned int size;
    CU_SAFE_CALL(cuGLMapBufferObject( &dptr, &size, *vbo));

    //printf("runCuda (vbo, anim) = %d, %f\n", *vbo, anim);

    // execute the func
    int BLOCK_SIZE_X = 8;
    int BLOCK_SIZE_Y = 9;

    CUdeviceptr dim_dx;
    CUdeviceptr dim_dy;
    cuMemAlloc(&dim_dx, sizeof(float));
    cuMemAlloc(&dim_dy, sizeof(float));

    // setup execution parameters
    CU_SAFE_CALL(cuFuncSetBlockShape( func, BLOCK_SIZE_X, BLOCK_SIZE_Y, 1 ));
    CU_SAFE_CALL(cuFuncSetSharedSize( func,
	3*BLOCK_SIZE_X*BLOCK_SIZE_Y*sizeof(float) ) );

    CU_SAFE_CALL(cuParamSeti( func, 0,  dptr));
    CU_SAFE_CALL(cuParamSeti( func, 4,  BLOCK_SIZE_X ));
    CU_SAFE_CALL(cuParamSetf( func, 8,  0.5f));
    CU_SAFE_CALL(cuParamSeti( func, 12, flagG));
    CU_SAFE_CALL(cuParamSeti( func, 16, dim_dx));
    CU_SAFE_CALL(cuParamSeti( func, 20, dim_dy));
    CU_SAFE_CALL(cuParamSetSize( func, 24 ));
    CU_SAFE_CALL(cuLaunchGrid( func, 1, 1)); 

//;    dim3 block(8, 8, 1);
//;    dim3 grid(mesh_width / block.x, mesh_height / block.y, 1);
//;    kernel<<< grid, block>>>(dptr, mesh_width, mesh_height, anim);

    // unmap buffer object
    CU_SAFE_CALL(cuGLUnmapBufferObject(*vbo));
}

////////////////////////////////////////////////////////////////////////////////
//! Initialize GL
////////////////////////////////////////////////////////////////////////////////
CUTBoolean initGL()
{
    // initialize necessary OpenGL extensions

    glewInit();
    if (! glewIsSupported( "GL_VERSION_2_0 " 
        "GL_ARB_pixel_buffer_object"
		)) {
        fprintf( stderr, "ERROR: Support for necessary OpenGL extensions missing.");
        fflush( stderr);
        return CUTFalse;
    }

    // default initialization
    glClearColor( 0.8, 0.8, 0.8, 1.0);
    glDisable( GL_DEPTH_TEST);

    // viewport
    glViewport( 0, 0, window_width, window_height);

    // projection
    glMatrixMode( GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, (GLfloat)window_width / (GLfloat) window_height, 0.1, 10.0);

    CUT_CHECK_ERROR_GL();

    return CUTTrue;
}

////////////////////////////////////////////////////////////////////////////////
//! Create VBO
////////////////////////////////////////////////////////////////////////////////
void createVBO(GLuint* vbo)
{
    unsigned int size = mesh_width * mesh_height  * sizeof( float);

    // create buffer object
    glGenBuffers( 3, vbo);
printf("1: %d\n", 1);

    glBindBuffer( GL_ARRAY_BUFFER, *vbo);
    glBufferData( GL_ARRAY_BUFFER, size, vertices, GL_DYNAMIC_DRAW);
printf("2\n");

    glBindBuffer( GL_ARRAY_BUFFER, *(vbo+1));
    glBufferData( GL_ARRAY_BUFFER, size, normals, GL_DYNAMIC_DRAW);
printf("3\n");

    glBindBuffer( GL_ARRAY_BUFFER, *(vbo+2));
    glBufferData( GL_ARRAY_BUFFER, size, colors, GL_DYNAMIC_DRAW);
printf("4\n");

    glBindBuffer( GL_ARRAY_BUFFER, 0);
printf("5\n");
    // register buffer object with CUDA
    CU_SAFE_CALL(cuGLInit());
    CU_SAFE_CALL(cuGLRegisterBufferObject(*vbo));
printf("6\n");

    CUT_CHECK_ERROR_GL();
}

////////////////////////////////////////////////////////////////////////////////
//! Delete VBO
////////////////////////////////////////////////////////////////////////////////
void deleteVBO( GLuint* vbo)
{
    glBindBuffer( 1, *vbo);
    glDeleteBuffers( 1, vbo);

    CU_SAFE_CALL(cuGLUnregisterBufferObject(*vbo));

    *vbo = 0;
}

////////////////////////////////////////////////////////////////////////////////
//! Display callback
////////////////////////////////////////////////////////////////////////////////
void display()
{
    // run CUDA kernel to generate vertex positions
    runCuda(vboId, kernel);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // set view matrix
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0.0, 0.0, translate_z);
    glRotatef(rotate_x, 1.0, 0.0, 0.0);
    glRotatef(rotate_y, 0.0, 1.0, 0.0);

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);

    // render from the vbo
    glBindBuffer(GL_ARRAY_BUFFER, *(vboId+1));
    glNormalPointer(GL_FLOAT, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, *(vboId+2));
    glColorPointer(3, GL_FLOAT, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, *vboId);
    glVertexPointer(3, GL_FLOAT, 0, 0);

    glDrawArrays(GL_QUADS, 0, 24);

    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);

    glutSwapBuffers();
    glutPostRedisplay();

    anim += 1.0;
}

////////////////////////////////////////////////////////////////////////////////
//! Keyboard events handler
////////////////////////////////////////////////////////////////////////////////
void keyboard( unsigned char key, int /*x*/, int /*y*/)
{
    switch( key) {
    case( 27) :
        deleteVBO( vboId);
        exit( 0);
    }
}

////////////////////////////////////////////////////////////////////////////////
//! Mouse event handlers
////////////////////////////////////////////////////////////////////////////////
void mouse(int button, int state, int x, int y)
{
    if (state == GLUT_DOWN) {
        mouse_buttons |= 1<<button;
    } else if (state == GLUT_UP) {
        mouse_buttons = 0;
    }

    mouse_old_x = x;
    mouse_old_y = y;
    glutPostRedisplay();
}

void motion(int x, int y)
{
    float dx, dy;
    dx = x - mouse_old_x;
    dy = y - mouse_old_y;

    if (mouse_buttons & 1) {
        rotate_x += dy * 0.2;
        rotate_y += dx * 0.2;
    } else if (mouse_buttons & 4) {
        translate_z += dy * 0.01;
    }

    mouse_old_x = x;
    mouse_old_y = y;
}
