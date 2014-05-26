#include <stdio.h> 
#include "kernel.cu" 
#include <cutil_inline.h>


// kernels transpose/copy a tile of TILE_DIM x TILE_DIM elements 
// using a TILE_DIM x BLOCK_ROWS thread block, so that each thread 
// transposes TILE_DIM/BLOCK_ROWS elements.  TILE_DIM must be an  
// integral multiple of BLOCK_ROWS 
 
 
// Number of repetitions used for timing.   
 
#define NUM_REPS  100 


//extern "C" void (*computeTransposeGold)(float* transposeGold, float *h_idata, int size_x,int size_y);
 
void computeTransposeGold( float* transposeGold, float* h_idata, 
            const int size_x, const int size_y ) 
{
    // transpose matrix
    for( int y = 0; y < size_y; ++y) 
    {
        for(  int x = 0; x < size_x; ++x) 
        {
			transposeGold[(x * size_y) + y] = h_idata[(y * size_x) + x];
        }
    }  
}

int 
main( int argc, char** argv)  
{ 
  
	 /* printf("Enter the size_x and size_y\n");
	scanf("%d,%d", &size_x,size_y);*/
	// set matrix size 
	//int size_x = 1024 , size_y = 1024;  
	int size_x = 0, size_y = 0;
	int  temp_BLOCK_ROWS = 0;

	if(argc > 1)
	{
		size_x = atoi(argv[1]);
		size_y = atoi(argv[2]);
		//temp_TILE_DIM = atoi(argv[3]);
		temp_BLOCK_ROWS = atoi(argv[3]);
	}
    //const int TILE_DIM = temp_TILE_DIM;
	const int BLOCK_ROWS = temp_BLOCK_ROWS;
	// kernel pointer and descriptor 
  void (*kernel)(float *, float *,int,int,int,const int); 
  char *kernelName; 

const int mem_size = sizeof(float) * size_x*size_y; 
 
  // allocate host memory 
  float *h_idata = (float*) malloc(mem_size); 
  float *h_odata = (float*) malloc(mem_size); 
  float *transposeGold = (float *) malloc(mem_size);   
  float *gold; 
  
 // float *compareF(float *,float *,const int);
 
  // execution configuration parameters 
  dim3 grid(size_x/TILE_DIM, size_y/TILE_DIM),   
       threads(TILE_DIM,BLOCK_ROWS); 
 
  // CUDA events 
  cudaEvent_t start, stop; 
 
  // size of memory required to store the matrix 
  


 
  // allocate device memory 
  float *d_idata, *d_odata; 
  cudaMalloc( (void**) &d_idata, mem_size); 
  cudaMalloc( (void**) &d_odata, mem_size); 
 
  // initalize host data computeTransposeGold
  for(int i = 0; i < (size_x*size_y); ++i) 
    h_idata[i] = (float) i; 
   
  // copy host data to device 
  cudaMemcpy(d_idata, h_idata, mem_size,    
             cudaMemcpyHostToDevice ); 
  // Compute reference transpose solution 
  computeTransposeGold(transposeGold, h_idata, size_x, size_y);
 
  // print out common data for all kernels 
  printf("\nMatrix size: %dx%d, tile: %dx%d, block: %dx%d\n\n",  
  size_x, size_y, TILE_DIM, TILE_DIM, TILE_DIM, BLOCK_ROWS); 
   
  printf("Kernel\t\t\tLoop over kernel\tLoop within kernel\tLoop over kernel Time\t\tLoop within kernel Time\n"); 
  printf("------\t\t\t----------------\t------------------\t---------------------\t\t-----------------------\n"); 
 
  // 
  // loop over different kernels 
  // 
 
  for (int k = 0; k<8; k++) { 
    // set kernel pointer 
    switch (k) { 
    case 0: 
      kernel = &copy;  
      kernelName = "simple copy           "; break; 
    case 1: 
      kernel = &copySharedMem;                   
      kernelName = "shared memory copy    "; break; 
    case 2: 
		   kernel = &transposeCoalesced;              
      kernelName = "coalesced transpose   "; break;
      
    case 3: 
	  kernel = &transposeNaive;                  
      kernelName = "naive transpose       "; break; 
    case 4: 
    kernel = &transposeNoBankConflicts;        
      kernelName = "no bank conflict trans"; break; 
    case 5: 
      kernel = &transposeCoarseGrained;          
      kernelName = "coarse-grained        "; break; 
    case 6: 
      kernel = &transposeFineGrained;            
      kernelName = "fine-grained          "; break; 
    case 7: 
      kernel = &transposeDiagonal;               
      kernelName = "diagonal transpose    "; break; 
    }       
 
    // set reference solution 
    // NB: fine- and coarse-grained kernels are not full 
    //     transposes, so bypass check 
    if (kernel == &copy || kernel == &copySharedMem) { 
      gold = h_idata; 
    } else if (kernel == &transposeCoarseGrained ||  
               kernel == &transposeFineGrained) { 
      gold = h_odata; 
    } else { 
      gold = transposeGold; 
    } 
 
     
    // initialize events, EC parameters 
    cudaEventCreate(&start); 
    cudaEventCreate(&stop); 
 
    // warmup to avoid timing startup 

	 kernel<<<grid, threads>>>(d_odata, d_idata, size_x,size_y, 1, BLOCK_ROWS); 
 
    // take measurements for loop over kernel launches 
    cudaEventRecord(start, 0); 
    for (int i=0; i < NUM_REPS; i++) { 
      kernel<<<grid, threads>>>(d_odata, d_idata,size_x,size_y,1, BLOCK_ROWS); 
    } 
    cudaEventRecord(stop, 0); 
    cudaEventSynchronize(stop); 
    float outerTime; 
    cudaEventElapsedTime(&outerTime, start, stop);     
 
    cudaMemcpy(h_odata,d_odata, mem_size, cudaMemcpyDeviceToHost); 
    CUTBoolean res = cutComparef(gold, h_odata, size_x*size_y); 
    if (res != 1) 
      printf("*** %s kernel FAILED ***\n", kernelName); 
	else
		printf("***Loop over kernel test PASSED***\n");
 
    // take measurements for loop inside kernel 
    cudaEventRecord(start, 0); 
    kernel<<<grid,threads>>> 
        (d_odata, d_idata, size_x, size_y, NUM_REPS, BLOCK_ROWS); 
    cudaEventRecord(stop, 0); 
    cudaEventSynchronize(stop); 
    float innerTime; 
    cudaEventElapsedTime(&innerTime, start, stop);     
 
    cudaMemcpy(h_odata,d_odata, mem_size, cudaMemcpyDeviceToHost); 
    res = cutComparef(gold, h_odata, size_x*size_y); 
    if (res != 1) 
      printf("*** %s kernel FAILED ***\n", kernelName); 
	else
		printf("***Loop over kernel test PASSED***\n");
     
    // report effective bandwidths 
    float outerBandwidth =  
       2.0f*1000.0f*mem_size/(1024*1024*1024)/(outerTime/NUM_REPS); 
    float innerBandwidth =  
       2.0f*1000.0f*mem_size/(1024*1024*1024)/(innerTime/NUM_REPS); 
	float loopOuterTime = outerTime/(NUM_REPS);
	float loopInnerTime = innerTime/(NUM_REPS);
    printf("%s\t%5.2f GB/s\t\t%5.2f GB/s\t\t%.5f ms\t\t\t%.5f ms\n",  
       kernelName, outerBandwidth, innerBandwidth,loopOuterTime, loopInnerTime); 
  } 
   
  // cleanup 
 
  free(h_idata); free(h_odata); free(transposeGold); 
  cudaFree(d_idata); cudaFree(d_odata); 
  cudaEventDestroy(start); cudaEventDestroy(stop); 
   
  return 0; 
} 