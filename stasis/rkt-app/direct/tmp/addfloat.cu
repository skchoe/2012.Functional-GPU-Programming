//#ifndef _MATRIXMUL_KERNEL_H_
//#define _MATRIXMUL_KERNEL_H_

#define BLOCK_SIZE_X 16
#define BLOCK_SIZE_Y 16
#define GRID_SIZE_X 8
#define GRID_SIZE_Y 8

extern "C"

/* Signature:
  float* d_array_in, int count, uint single_in 
  ->
  float* d_array_out, uint* d_array_len, int* memstruct, uint* single_out
*/
__global__ void
addfloat(
float* d_array_in, 
size_t count,
size_t width, size_t height, size_t depth,
float d_single_in, 
float* d_array_out,
size_t* d_array_out_len,
float val)
{

  int idx = threadIdx.x + BLOCK_SIZE_X * blockIdx.x;
  int idy = threadIdx.y + BLOCK_SIZE_Y * blockIdx.y;
  int thd_width = BLOCK_SIZE_X * GRID_SIZE_X;

  int linpos = thd_width * idy + idx;

  *(d_array_out+linpos) = d_array_in[linpos] + val;
  __syncthreads();
}

