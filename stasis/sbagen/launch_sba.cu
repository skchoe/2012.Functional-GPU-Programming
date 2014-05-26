#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include <cuda.h>
#include <cuda_runtime.h>
#include <vector_types.h>
//#include <cutil.h>

#include "hashtab.h"
#include "def.h"

// include kernel
#include <cutil.h> 


//include the head
void print_memory(char* dish, int szx, int szy, int szelt)
{
  int i,j,k,pos;
  for(i = 0 ; i < szx ; i++) {
    for(j = 0 ; j < szy ; j++) {
      pos = (j*szx + i) * szelt;
      printf("[%d,%d]\t", i, j);
      for(k=0;k<szelt;k++)
        printf("%c", dish[pos+k]);
      printf("\t");
    }
    printf ("\n");
  }
  printf ("\n");
}

// those wrappers call kernel functions
void solver_constraint_wrapper(hash_tab* c, char* out_analysis){
	int num_var = c->num_variable;
	int num_const = c->num_constraint;
	int size = num_var * num_const * SIZE_CONSTRAINT;
	char *c_array;
	char *c_new_array;
	char *analysis;
	char *reflection;
	char *temp; // debug 
	/*Lock lock[2];
	Lock *dev_lock;

	CUDA_SAFE_CALL(cudaMalloc( (void**) &dev_lock, 2*sizeof(Lock)));
	CUDA_SAFE_CALL(cudaMemcpy(dev_lock, lock, 2*sizeof(Lock), cudaMemcpyHostToDevice));
	*/

	unsigned int timer = 0;

	CUDA_SAFE_CALL(cudaMalloc( (void**)&c_array, size));
	CUDA_SAFE_CALL(cudaMalloc( (void**)&c_new_array, size));
	CUDA_SAFE_CALL(cudaMalloc( (void**)&analysis, size));
	CUDA_SAFE_CALL(cudaMalloc( (void**)&reflection, size));


	temp = (char*) malloc(size);
	memset(temp,'\0',size);	

	CUDA_SAFE_CALL(cudaMemcpy(c_array, c->ht, size, cudaMemcpyHostToDevice));
	CUDA_SAFE_CALL(cudaMemset(c_new_array, '\0', size));
	CUDA_SAFE_CALL(cudaMemset(analysis, '\0', size));
		
	dim3 threads(BLOCK_SIZE_X, BLOCK_SIZE_Y);
	dim3 grid(1);

	int empty_const=1;
	int *d_empty_const;
	int size_int = sizeof(int);

	CUDA_SAFE_CALL(cudaMalloc((void**)&d_empty_const,size_int));
	CUDA_SAFE_CALL(cudaMemcpy(d_empty_const, &empty_const,size_int,cudaMemcpyHostToDevice));

	CUT_SAFE_CALL(cutCreateTimer(&timer));
	CUT_SAFE_CALL(cutStartTimer(timer));

	SizeType2* st_inc = (SizeType2*)malloc(sizeof (SizeType2));
	st_inc->w = num_const * SIZE_CONSTRAINT;
	st_inc->h = num_var;
	SizeType2* st_oc = (SizeType2*)malloc(sizeof (SizeType2));
	SizeType2* st_anl = (SizeType2*)malloc(sizeof (SizeType2));

	/* Call Kernel function */
	init_constraints_kernel<<< grid, threads >>>(c_array, st_inc, num_var, num_const, SIZE_CONSTRAINT, c_new_array, st_oc, analysis, st_anl, d_empty_const); 

	CUDA_SAFE_CALL(cudaMemcpy(&empty_const, d_empty_const,4,cudaMemcpyDeviceToHost));
	CUDA_SAFE_CALL(cudaMemcpy(reflection, c_new_array, size, cudaMemcpyDeviceToDevice));
	//printf("(let (a (lambda c c)) in\n (let b 1) in\n (app a b) \n");
	
	//printf("frist constraint \n" );
	CUDA_SAFE_CALL(cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost));
	//print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);
		
	char* out_c_new_array;
	char* out1,*out2;

	char* o1,*o2;

	o1 =(char*) malloc(9);
	o2 =(char*) malloc(9);
	bzero(o1,9);
	bzero(o2,9);	
	cudaMalloc(&out1,8);
	cudaMalloc(&out2,8);
	
	// SizeType2 arguments alloc
	SizeType2* st2_refl = (SizeType2*)malloc(sizeof (SizeType2));
	SizeType2* st2_c_in = (SizeType2*)malloc(sizeof (SizeType2));
	SizeType2* st2_c_out = (SizeType2*)malloc(sizeof (SizeType2));
	SizeType2* st2_anl = (SizeType2*)malloc(sizeof (SizeType2));

	while (!empty_const) {	
		empty_const = 1;
		CUDA_SAFE_CALL(cudaMemcpy(d_empty_const, &empty_const,size_int,cudaMemcpyHostToDevice));
		
		CUDA_SAFE_CALL(cudaMalloc(&out_c_new_array, size));
		CUDA_SAFE_CALL(cudaMemset(out_c_new_array, '\0', size));
	
		// call a kernel function
		solve_constraints_kernel<<< grid, threads>>> (reflection, st2_refl, c_new_array, st2_c_in, num_var, num_const, 
		                                 out_c_new_array, st2_c_out, analysis, st2_anl, d_empty_const,out1,out2); //dev_lock		//printf("debug11\n");
		CUDA_SAFE_CALL(cudaMemcpy(&empty_const, d_empty_const,size_int,cudaMemcpyDeviceToHost));

		//printf("new constraint1:\n");		
		cudaMemcpy(temp, out_c_new_array, size, cudaMemcpyDeviceToHost);
		//print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);

		cudaFree(c_new_array);

		c_new_array = out_c_new_array;	
		out_c_new_array = NULL;

		///printf("new analysis:\n");
		//cudaMemcpy(temp2, analysis, size, cudaMemcpyDeviceToHost);
		//print_memory(temp2, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);

		//printf("new constraint2:\n");
		cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost);
		//print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);
	}


	CUT_SAFE_CALL(cutStopTimer(timer));
	printf("Processing time:%f (ms)\n", cutGetTimerValue(timer));
	CUT_SAFE_CALL(cutDeleteTimer(timer));

        cudaMemcpy(o1, out1,8,cudaMemcpyDeviceToHost);
        cudaMemcpy(o2, out2,8,cudaMemcpyDeviceToHost);


 	// now analysis contains final answers at each colume(var).
	// Need to show them: var -> value mapping by having way of finding var from column index.
	
	CUDA_SAFE_CALL(cudaMemcpy(out_analysis, analysis, size, cudaMemcpyDeviceToHost));
	printf("\nSOLUTIONS=========\n");
	print_memory(out_analysis, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);
	cudaFree(c_array);
	cudaFree(c_new_array);
	cudaFree(analysis);
	//cudaFree(dev_lock);
	cudaFree(out_c_new_array);
}
