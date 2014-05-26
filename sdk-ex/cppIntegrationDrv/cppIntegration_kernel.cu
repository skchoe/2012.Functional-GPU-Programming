/* Example of integrating CUDA functions into an existing 
 * application / framework.
 * Device code.
 */

#ifndef _CPP_INTEGRATION_KERNEL_H_
#define _CPP_INTEGRATION_KERNEL_H_

///////////////////////////////////////////////////////////////////////////////
//! Simple test kernel for device functionality
//! @param g_odata  memory to process (in and out)
///////////////////////////////////////////////////////////////////////////////
extern "C"
__global__ void
kernel( int* g_data )
{
    // write data to global memory
    const unsigned int tid = threadIdx.x;
    int data = g_data[tid];

    // use integer arithmetic to process all four bytes with one thread
    // this serializes the execution, but is the simplest solutions to avoid 
    // bank conflicts for this very low number of threads
    // in general it is more efficient to process each byte by a separate thread,
    // to avoid bank conflicts the access pattern should be 
    // g_data[4 * wtid + wid], where wtid is the thread id within the half warp 
    // and wid is the warp id
    // see also the programming guide for a more in depth discussion.
    g_data[tid] = ((((data <<  0) >> 24) - 10) << 24)
                | ((((data <<  8) >> 24) - 10) << 16)
                | ((((data << 16) >> 24) - 10) <<  8)
                | ((((data << 24) >> 24) - 10) <<  0);
}

///////////////////////////////////////////////////////////////////////////////
//! Demonstration that int2 data can be used in the cpp code
//! @param g_odata  memory to process (in and out)
///////////////////////////////////////////////////////////////////////////////
extern "C"
__global__ void
kernel2( int2* g_data )
{
    // write data to global memory
    const unsigned int tid = threadIdx.x;
    int2 data = g_data[tid];

    // use integer arithmetic to process all four bytes with one thread
    // this serializes the execution, but is the simplest solutions to avoid 
    // bank conflicts for this very low number of threads
    // in general it is more efficient to process each byte by a separate thread,
    // to avoid bank conflicts the access pattern should be 
    // g_data[4 * wtid + wid], where wtid is the thread id within the half warp 
    // and wid is the warp id
    // see also the programming guide for a more in depth discussion.
    g_data[tid].x = data.x - data.y;
}

#endif // #ifndef _CPP_INTEGRATION_KERNEL_H_
