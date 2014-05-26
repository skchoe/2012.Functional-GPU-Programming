//#ifndef _MATRIXMUL_KERNEL_H_
//#define _MATRIXMUL_KERNEL_H_

/*

(define (gpu-info)
  (let* ([info (cuGPUinfo)])
    (values (gridDim-x info) ......)))

(: cpyTestDrv_kernel ((Listof Float) Integer -> (Listof Float) (Listof Integer) Integer)
(define (cpyTestDrv_kernel d_array_in d_single_in)
  (let*-values  ([(d_array_out) (take d_array_in 0)]
         	[(memstruct) (gpu-info)]
         	[(d_single_out) d_single_in])
    (values d_array_out memstruct d_single_out)))


*/

extern "C"

/* Signature:
  float* d_array_in, int count, uint single_in 
  ->
  float* d_array_out, int* memstruct, uint* single_out
*/
__global__ void
cpyTestDrv_kernel(float* d_array_out, float* d_array_in, int count,
        unsigned int* memstruct,
        unsigned int* d_single_out, unsigned int d_single_in)
{
    // copy - single value
    *d_single_out = d_single_in;

    // copy of default variables
    unsigned int gdm_x = gridDim.x;
    unsigned int gdm_y = gridDim.y;
    unsigned int gdm_z = gridDim.z;
    unsigned int bdm_x = blockDim.x;
    unsigned int bdm_y = blockDim.y;
    unsigned int bdm_z = blockDim.z;
    unsigned int bid_x = blockIdx.x;
    unsigned int bid_y = blockIdx.y;
    unsigned int bid_z = blockIdx.z;
    unsigned int tid_x = threadIdx.x;
    unsigned int tid_y = threadIdx.y;
    unsigned int tid_z = threadIdx.z;

    *memstruct = gdm_x;
    *(memstruct+1) = gdm_y;
    *(memstruct+2) = gdm_z;
    *(memstruct+3) = bdm_x;
    *(memstruct+4) = bdm_y;
    *(memstruct+5) = bdm_z;
    *(memstruct+6) = bid_x;
    *(memstruct+7) = bid_y;
    *(memstruct+8) = bid_z;
    *(memstruct+9) = tid_x;
    *(memstruct+10) = tid_y;
    *(memstruct+11) = tid_z;

    // copy of array variables
    for(int j = 0 ; j < count ; j++)
    {
      *(d_array_out+j) = d_array_in[j];
      *(d_array_out+j) = j;
    }
}
