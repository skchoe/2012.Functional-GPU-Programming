
	#define TILE_DIM 24
	//#define BLOCK_ROWS 16 

__global__ void copy(float *odata, float* idata, int width,  
                                     int height, int nreps, const int BLOCK_ROWS) 
{ 
  int xIndex = blockIdx.x*TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx.y*TILE_DIM + threadIdx.y; 
 
  int index  = xIndex + width*yIndex; 
  for (int r=0; r < nreps; r++) { 
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      odata[index+i*width] = idata[index+i*width]; 
    } 
  } 
} 

__global__ void copySharedMem(float *odata, float *idata,  
                          int width, int height, int nreps,const int BLOCK_ROWS) 
{ 
	__shared__ float tile[TILE_DIM][TILE_DIM]; 
 
  int xIndex = blockIdx.x*TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx.y*TILE_DIM + threadIdx.y; 
   
  int index  = xIndex + width*yIndex; 
  for (int r=0; r < nreps; r++) { 
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      tile[threadIdx.y+i][threadIdx.x] =  
        idata[index+i*width]; 
    } 
   
    __syncthreads(); 
   
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      odata[index+i*width] =  
        tile[threadIdx.y+i][threadIdx.x]; 
    } 
  } 
}


__global__ void transposeNaive(float *odata, float* idata,  
                         int width, int height, int nreps,const int BLOCK_ROWS) 
{ 
  int xIndex = blockIdx.x*TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx.y*TILE_DIM + threadIdx.y; 
 
  int index_in  = xIndex + width * yIndex; 
  int index_out = yIndex + height * xIndex; 
  for (int r=0; r < nreps; r++) { 
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      odata[index_out+i] = idata[index_in+i*width]; 
    } 
  } 
}

__global__ void transposeCoalesced(float *odata,  
            float *idata, int width, int height, int nreps,const int BLOCK_ROWS) 
{ 
  __shared__ float tile[TILE_DIM][TILE_DIM]; 
 
  int xIndex = blockIdx.x*TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx.y*TILE_DIM + threadIdx.y;   
  int index_in = xIndex + (yIndex)*width; 
 
  xIndex = blockIdx.y * TILE_DIM + threadIdx.x; 
  yIndex = blockIdx.x * TILE_DIM + threadIdx.y; 
  int index_out = xIndex + (yIndex)*height; 
 
  for (int r=0; r < nreps; r++) { 
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      tile[threadIdx.y+i][threadIdx.x] =  
        idata[index_in+i*width]; 
    } 
   
    __syncthreads(); 
   
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      odata[index_out+i*height] =  
        tile[threadIdx.x][threadIdx.y+i]; 
    } 
  } 
}

__global__ void transposeNoBankConflicts(float *odata,  
            float *idata, int width, int height, int nreps,const int BLOCK_ROWS) 
{ 
  __shared__ float tile[TILE_DIM][TILE_DIM+1]; 
 
  int xIndex = blockIdx.x*TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx.y*TILE_DIM + threadIdx.y;   
  int index_in = xIndex + (yIndex)*width; 
 
  xIndex = blockIdx.y * TILE_DIM + threadIdx.x; 
  yIndex = blockIdx.x * TILE_DIM + threadIdx.y; 
  int index_out = xIndex + (yIndex)*height; 
 
  for (int r=0; r < nreps; r++) { 
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      tile[threadIdx.y+i][threadIdx.x] =  
        idata[index_in+i*width]; 
    } 
   
    __syncthreads(); 
   
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      odata[index_out+i*height] =  
        tile[threadIdx.x][threadIdx.y+i]; 
    } 
  } 
}

__global__ void transposeFineGrained(float *odata,  
           float *idata, int width, int height,  int nreps,const int BLOCK_ROWS) 
{ 
  __shared__ float block[TILE_DIM][TILE_DIM+1]; 
 
  int xIndex = blockIdx.x * TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx.y * TILE_DIM + threadIdx.y; 
  int index = xIndex + (yIndex)*width; 
 
  for (int r=0; r<nreps; r++) { 
    for (int i=0; i < TILE_DIM; i += BLOCK_ROWS) { 
      block[threadIdx.y+i][threadIdx.x] =  
        idata[index+i*width]; 
    }   
      
    __syncthreads(); 
 
    for (int i=0; i < TILE_DIM; i += BLOCK_ROWS) { 
      odata[index+i*height] =  
        block[threadIdx.x][threadIdx.y+i]; 
    } 
  } 
}

__global__ void transposeCoarseGrained(float *odata,  
      float *idata, int width, int height, int nreps,const int BLOCK_ROWS) 
{ 
  __shared__ float block[TILE_DIM][TILE_DIM+1]; 
 
  int xIndex = blockIdx.x * TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx.y * TILE_DIM + threadIdx.y; 
  int index_in = xIndex + (yIndex)*width; 
 
  xIndex = blockIdx.y * TILE_DIM + threadIdx.x; 
  yIndex = blockIdx.x * TILE_DIM + threadIdx.y; 
  int index_out = xIndex + (yIndex)*height; 
 
  for (int r=0; r<nreps; r++) { 
    for (int i=0; i<TILE_DIM; i += BLOCK_ROWS) { 
      block[threadIdx.y+i][threadIdx.x] =  
        idata[index_in+i*width]; 
    } 
   
    __syncthreads(); 
 
    for (int i=0; i<TILE_DIM; i += BLOCK_ROWS) { 
      odata[index_out+i*height] =  
        block[threadIdx.y+i][threadIdx.x]; 
    } 
  } 
}

__global__ void transposeDiagonal(float *odata,  
            float *idata, int width, int height, int nreps,const int BLOCK_ROWS) 
{ 
  __shared__ float tile[TILE_DIM][TILE_DIM+1]; 
 
  int blockIdx_x, blockIdx_y; 
 
  // diagonal reordering 
  if (width == height) { 
    blockIdx_y = blockIdx.x; 
    blockIdx_x = (blockIdx.x+blockIdx.y)%gridDim.x; 
  } else { 
    int bid = blockIdx.x + gridDim.x*blockIdx.y; 
    blockIdx_y = bid%gridDim.y; 
    blockIdx_x = ((bid/gridDim.y)+blockIdx_y)%gridDim.x; 
  }     
 
  int xIndex = blockIdx_x*TILE_DIM + threadIdx.x; 
  int yIndex = blockIdx_y*TILE_DIM + threadIdx.y;   
  int index_in = xIndex + (yIndex)*width; 
 
  xIndex = blockIdx_y*TILE_DIM + threadIdx.x; 
  yIndex = blockIdx_x*TILE_DIM + threadIdx.y; 
  int index_out = xIndex + (yIndex)*height; 
 
  for (int r=0; r < nreps; r++) { 
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      tile[threadIdx.y+i][threadIdx.x] =  
        idata[index_in+i*width]; 
    } 
   
    __syncthreads(); 
   
    for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) { 
      odata[index_out+i*height] =  
        tile[threadIdx.x][threadIdx.y+i]; 
    } 
  } 
}

