/* 
    This example demonstrates how to use the Cuda OpenGL bindings to
    dynamically modify a vertex buffer using a Cuda kernel.

    The steps are:
    1. Create an empty vertex buffer object (VBO)
    2. Register the VBO with Cuda
    3. Map the VBO for writing from Cuda
    4. Run Cuda kernel to modify the vertex positions
    5. Unmap the VBO
    6. Render the results using OpenGL

    Host code
*/

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

const unsigned int mesh_width = 256;
const unsigned int mesh_height = 256;

// vbo variables
GLuint vbo;

float anim = 0.0;

// mouse controls
int mouse_old_x, mouse_old_y;
int mouse_buttons = 0;
float rotate_x = 0.0, rotate_y = 0.0;
float translate_z = -3.0;

////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest(int argc, char** argv);

// GL functionality
CUTBoolean initGL();
void createVBO(GLuint* vbo);
void deleteVBO(GLuint* vbo);

// rendering callbacks
void display();
void keyboard( unsigned char key, int x, int y);
void mouse(int button, int state, int x, int y);
void motion(int x, int y);

// Cuda functionality
void runCuda(GLuint vbo, CUfunction knl);
void checkResultCuda( int argc, char** argv, const GLuint& vbo);

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
initCuda_getKernel(CUfunction *pKernel, 
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

    status = cuModuleLoad(&cuModule, "data/simpleGLDrv_kernel.sm_10.cubin");
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
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
    glutInitWindowSize(window_width, window_height);
    glutCreateWindow("Cuda GL interop");

    // initialize GL
    if( CUTFalse == initGL()) return;

    // register callbacks
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glutMouseFunc(mouse);
    glutMotionFunc(motion);

    // Cuda Driver Init
    kernel = NULL;
    CU_SAFE_CALL(initCuda_getKernel(&kernel, argc, argv));

    // create VBO
    createVBO(&vbo);
    printf ("INITIALIZE OF SIMPLEL\n");
    // run the cuda part
    runCuda(vbo, kernel);

    // check result of Cuda step
    checkResultCuda(argc, argv, vbo);

    // start rendering mainloop
    glutMainLoop();
}

////////////////////////////////////////////////////////////////////////////////
//! Run the Cuda part of the computation
////////////////////////////////////////////////////////////////////////////////
void runCuda( GLuint vbo, CUfunction func)
{
    // map OpenGL buffer object for writing from CUDA
    CUdeviceptr dptr;
    unsigned int size;
    CU_SAFE_CALL(cuGLMapBufferObject( &dptr, &size, vbo));

    //printf("runCuda (vbo, anim) = %d, %f\n", vbo, anim);

    // execute the func
    int BLOCK_SIZE = 8;
    // setup execution parameters
    CU_SAFE_CALL(cuFuncSetBlockShape( func, BLOCK_SIZE, BLOCK_SIZE, 1 ));
    CU_SAFE_CALL(cuFuncSetSharedSize( func,
	4*BLOCK_SIZE*BLOCK_SIZE*sizeof(float) ) );
    CU_SAFE_CALL(cuParamSeti( func, 0,  dptr));
    CU_SAFE_CALL(cuParamSeti( func, 4,  mesh_width ));
    CU_SAFE_CALL(cuParamSeti( func, 8,  mesh_height));
    CU_SAFE_CALL(cuParamSetf( func, 12, anim));
    CU_SAFE_CALL(cuParamSetSize( func, 16 ));
    CU_SAFE_CALL(cuLaunchGrid( func, 
	mesh_width / BLOCK_SIZE, mesh_height / BLOCK_SIZE ));

//;    dim3 block(8, 8, 1);
//;    dim3 grid(mesh_width / block.x, mesh_height / block.y, 1);
//;    kernel<<< grid, block>>>(dptr, mesh_width, mesh_height, anim);

    // unmap buffer object
    CU_SAFE_CALL(cuGLUnmapBufferObject(vbo));
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
    // create buffer object
    glGenBuffers( 1, vbo);
    glBindBuffer( GL_ARRAY_BUFFER, *vbo);

    // initialize buffer object
    unsigned int size = mesh_width * mesh_height * 4 * sizeof( float);
    glBufferData( GL_ARRAY_BUFFER, size, 0, GL_DYNAMIC_DRAW);

    glBindBuffer( GL_ARRAY_BUFFER, 0);

    // register buffer object with CUDA
    CU_SAFE_CALL(cuGLInit());
    CU_SAFE_CALL(cuGLRegisterBufferObject(*vbo));

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
    runCuda(vbo, kernel);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // set view matrix
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0.0, 0.0, translate_z);
    glRotatef(rotate_x, 1.0, 0.0, 0.0);
    glRotatef(rotate_y, 0.0, 1.0, 0.0);

    // render from the vbo
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glVertexPointer(4, GL_FLOAT, 0, 0);

    glEnableClientState(GL_VERTEX_ARRAY);
    glColor3f(1.0, 0.0, 0.0);
    glDrawArrays(GL_POINTS, 0, mesh_width * mesh_height);
    glDisableClientState(GL_VERTEX_ARRAY);

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
        deleteVBO( &vbo);
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

////////////////////////////////////////////////////////////////////////////////
//! Check if the result is correct or write data to file for external
//! regression testing
////////////////////////////////////////////////////////////////////////////////
void checkResultCuda( int argc, char** argv, const GLuint& vbo)
{
    printf ("check Result cuda called\n");
/*
    CU_SAFE_CALL(cuGLUnregisterBufferObject(vbo));

    // map buffer object
    glBindBuffer( GL_ARRAY_BUFFER_ARB, vbo );
    float* data = (float*) glMapBuffer( GL_ARRAY_BUFFER, GL_READ_ONLY);

    // check result
    if( cutCheckCmdLineFlag( argc, (const char**) argv, "regression")) {
        // write file for regression test
        CUT_SAFE_CALL( cutWriteFilef( "./data/regression.dat",
            data, mesh_width * mesh_height * 3, 0.0));
    }

    // unmap GL buffer object
    if( ! glUnmapBuffer( GL_ARRAY_BUFFER)) {
        fprintf( stderr, "Unmap buffer failed.\n");
        fflush( stderr);
    }

    CU_SAFE_CALL(cuGLRegisterBufferObject(vbo));

    CUT_CHECK_ERROR_GL();
*/
}
