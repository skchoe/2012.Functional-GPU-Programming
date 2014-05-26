#ifndef _CUBE_KERNEL_H_
#define _CUBE_KERNEL_H_
extern "C"
///////////////////////////////////////////////////////////////////////////////
//! Simple kernel to modify vertex positions in sine wave pattern
//! @param data  data in global memory
///////////////////////////////////////////////////////////////////////////////
// random change
__global__ void kernel(float* inout, int width, float deg, float var, int* dimx, int* dimy)
{
  unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;
  unsigned int y = blockIdx.y * blockDim.y + threadIdx.y;

  //dimx[y*width+x] = x;
  //*(dimy) = y;

/*
  float value = inout[y*width+x];
  inout[y*width+x] = (value > 0)? deg: -1.0 * deg; 
*/
  inout[y*width+x] *= var;
  __syncthreads();
}
/*
// random change
__global__ void kernel(float* inout, int width, int flag)
{

  unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;
  unsigned int y = blockIdx.y * blockDim.y + threadIdx.y;

  int var;
  if(flag==0) var=0.5f;
  else if(flag==1) var=-0.5f;


  inout[y*width+x] = 1.0;//var;

}
*/
/*
__global__ void kernel(float* inout, int size)
{
}
*/
/*
__global__ void kernel(float* inout)
{
}
*/

#endif // #ifndef _CUBE_KERNEL_H_
