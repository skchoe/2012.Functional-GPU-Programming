#include<stdio.h>
#include<cuda.h>
#include<cutil.h>
#include<boolean.h>
#include "def.h"
#include "hashtab.h"
#include "cu_lib.h"
//#include "lock.h"

#define islower(c) (((c) >= 'a') && ((c) <= 'b'))
#define isupper(c) (((c) >= 'A') && ((c) <= 'Z'))
#define isalpha(c) (islower(c) && isupper(c))
#define tolower(c) ((c)-'A'+'a')

// Hash Function

extern "C" {

__device__ int get_hash_from_char(char c){
        if (isalpha(c)){
                if (isupper(c)){
                        return tolower(c) - 'a' + 26;
                } else {
                        return c - 'a';
                }
        }
        return -1;
}

__device__ int hashfunc(char *to){
        int v1 = get_hash_from_char(*to);
        if (v1 == -1) return -1;
        if ( *(to+1) == ' ' || *(to+1) == '\0')
        {
                return v1;
        }

        int v2 = get_hash_from_char(*(to+1));
        if (v2 == -1) return -1;

        return (1+v1)*52 + v2;
}

// return pointer of h[key,index]

__device__ char* get_element2(char* h, int num_var, int key, int index, int c_size){
	int row = (key + index*num_var)*c_size;
	char *elem_addr = h + row;
	return elem_addr;
}


char* get_element3(char* h, int num_var, int key, int index, int c_size){
	int row = (key + index*num_var)*c_size;
	char *elem_addr = h + row;
	return elem_addr;
}

__device__ int put_element2(char* h, int num_var, int num_const, int c_size, int key, char* constraint, /*Lock* lock,*/  int flag){
	int i;

	for (i=0 ; i < num_const; i++){
		int row = (key + i*num_var)*c_size;
		char* temp = h + row;
		if (*temp == '\0'){
			//lock[flag].lock();
			memcpy(temp, constraint, c_size);
			//lock[flag].unlock();
			return 1;
		}
	}
	return -1;
}
 

__device__ void memcopy(char* dest, char* sour, int size){
	int i;
	for(i=0; i < size; i++)
		dest[i] = sour[i];

}

__global__ void init_constraints_kernel(char *constraints, 
                                        int num_var, 
					int num_const, 
					int size_constraint, 
					char* new_constraints, 
					char* analysis, 
					int* empty_constraint)
{
	int idx = threadIdx.x;
	int idy = threadIdx.y;
	
	char* a_constraint = get_element2(constraints, num_var, idx, idy, size_constraint);

	int pos = (idx + idy * num_var) * size_constraint;
	if( (constraints[pos] == '_') 
		&& ( constraints[pos+1] == 'v' || constraints[pos+1] == 'c' || constraints[pos+1] == 'l')){
       		memcpy(analysis+pos, a_constraint, size_constraint);
	} 
	else {
       		memcpy(new_constraints+pos, a_constraint, size_constraint);
		*empty_constraint = 0; // constraint is not empty now.
	}
	__syncthreads();
}

extern	__shared__ char sh_array[];
					 
__global__ void solve_constraints_kernel(char* reflection, 
                                         char* constraint, 
					 int num_var, 
					 int num_const, 
					 int size_constraint, 
					 char* new_constraints, 
					 char* analysis, 
					 int* empty_constraint, 
					 //Lock* lock,
					 char* out1,
					 char* out2)
{
	char* sh_constraints = (char*)sh_array;
	register char n_const[8];
	register char n_const2[8];
	register char value[8];

	int idx = threadIdx.x;
	int idy = threadIdx.y;
  	int i;

	char* sharemem_addr = sh_constraints; 
	sharemem_addr = sharemem_addr + idx * size_constraint * BLOCK_SIZE_X + idy * size_constraint;

	memcpy(sharemem_addr, get_element2(constraint, num_var, idx, idy, size_constraint), size_constraint);	
	memcpy(out1, sharemem_addr, size_constraint);


	for(i=0; i < num_const; i++)
	{
		memcopy(value, get_element2(analysis, num_var, idx ,i, size_constraint), size_constraint);
		//memcopy(out2,value,size_constraint);	
		if (*value != '\0')
		{
			memset(n_const, '\0', 8);
			memset(n_const2, '\0', 8);
			if((*sharemem_addr=='_' && *(sharemem_addr+1)=='P') && (value[0]=='_' && value[1] == 'v'))
			{
				int index = hashfunc(sharemem_addr+2);
				memcpy(n_const,value,8);
				put_element2(analysis,num_var,num_const, size_constraint, index,n_const,0); //lock,0);
				int j;
				for(j=0;j <num_const; j++){
					char *c = get_element2(reflection,num_var,index, j, size_constraint);
					if (*c != '\0'){
						put_element2(new_constraints,num_var,num_const, size_constraint, index,c, 1);//lock,1);
						*empty_constraint = 0;
					}
					else *empty_constraint = 50;
				}
			} 
			else if((*sharemem_addr=='_' && *(sharemem_addr+1)=='C') && (value[0]=='_' && value[1] == 'c'))
			{
				int index = hashfunc(value+2);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,sharemem_addr+2,6);
				put_element2(new_constraints, num_var,num_const, size_constraint, index,n_const,1);//lock,1);
				*empty_constraint = 0;
			} 
			else if(((*sharemem_addr=='_' && *(sharemem_addr+1)=='D')) && (value[0]=='_' && value[1] == 'c'))
			{
				int index = hashfunc(value+4);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,sharemem_addr+2,6);
				put_element2(new_constraints, num_var, num_const, size_constraint, index, n_const, 0); //lock,0);
				*empty_constraint = 0;
			} 
			else if((*sharemem_addr=='_' && *(sharemem_addr+1)=='A') && (value[0]=='_' && value[1] == 'l'))
			{
				int index1 = hashfunc(value+6);
				int index2 = hashfunc(sharemem_addr +4);
				n_const[0] = '_';
				n_const2[0]= '_';
				n_const[1] = 'P';
				n_const2[1]= 'P';
				memcopy(n_const+2,sharemem_addr+2,2);
				memcopy(n_const2+2,value+2,2);
				put_element2(new_constraints, num_var, num_const, size_constraint, index1, n_const, 1);//lock,1);
				put_element2(new_constraints, num_var, num_const, size_constraint, index2, n_const2, 1);//lock,1);
				memcopy(out1,n_const,8);
				memcopy(out2,n_const2,8);
				*empty_constraint = 0;
			} 
			else if((*sharemem_addr=='_' && *(sharemem_addr+1) =='A') && (value[0]=='_' && value[1] == 't'))
			{
				int index = hashfunc(sharemem_addr+4);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,value+2,6);
				put_element2(new_constraints, num_var, num_const, size_constraint, index, n_const, 1);//lock,1);
				*empty_constraint = 0;
			} 
			else 
			{
				// *empty_constraint = 100; // - should never used.
			}
		}
		else 
		{
			// *empty_constraint = 200;
		}
	}

	__syncthreads();
}
} // end of extern "C"



extern "C"
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
extern "C"
void solver_constraint_wrapper(hash_tab* c, char* out_analysis){
	int num_var = c->num_variable;
	int num_const = c->num_constraint;
	int size_constraint = c->size_constraint;
	int size = num_var * num_const * size_constraint; // bytes(char=1byte)
	char *c_array;
	char *c_new_array;
	char *analysis;
	char *reflection;
	char *temp; // debug 
	char *temp2; // debug 
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

	temp2 = (char*) malloc(size);
	memset(temp2,'\0',size);	

	CUDA_SAFE_CALL(cudaMemcpy(c_array, c->ht, size, cudaMemcpyHostToDevice));
	CUDA_SAFE_CALL(cudaMemset(c_new_array, '\0', size));
	CUDA_SAFE_CALL(cudaMemset(analysis, '\0', size));
		
	dim3 threads(BLOCK_SIZE_X, BLOCK_SIZE_Y);
	dim3 grid(1);

	int empty_const= 1; // initialize that yes, it's empty. ->turn to false if put_element() occured
	int *d_empty_const; // global var on gpu as a flag of constraint_emptyness
	int size_int = sizeof(int);

	CUDA_SAFE_CALL(cudaMalloc((void**)&d_empty_const, size_int));
	CUDA_SAFE_CALL(cudaMemcpy(d_empty_const, &empty_const, size_int, cudaMemcpyHostToDevice));

	CUT_SAFE_CALL(cutCreateTimer(&timer));
	CUT_SAFE_CALL(cutStartTimer(timer));

	/* Call Kernel function */
	init_constraints_kernel<<< grid, threads >>>(c_array, 
	                                             num_var, 
						     num_const, 
						     size_constraint, 
						     c_new_array, 
						     analysis, 
						     d_empty_const); 

	CUDA_SAFE_CALL(cudaMemcpy(&empty_const, d_empty_const, 4, cudaMemcpyDeviceToHost));
	printf("INIT-const : emptyconst flag: %d , zero means not-empty\n", empty_const);

	CUDA_SAFE_CALL(cudaMemcpy(reflection, c_new_array, size, cudaMemcpyDeviceToDevice));
	//printf("(let (a (lambda c c)) in\n (let b 1) in\n (app a b) \n");
	
	printf("first constraint \n");
	CUDA_SAFE_CALL(cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost));
	//print_memory(c->ht, BLOCK_SIZE_X, BLOCK_SIZE_Y, size_constraint);
	print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, size_constraint);
		
	printf("first analysis \n");
	CUDA_SAFE_CALL(cudaMemcpy(temp2, analysis, size, cudaMemcpyDeviceToHost));
	print_memory(temp2, BLOCK_SIZE_X, BLOCK_SIZE_Y, size_constraint);
		
	char* out_c_new_array;
	char* out1, *out2;

	char* o1,*o2;

	o1 =(char*) malloc(9);
	o2 =(char*) malloc(9);
	bzero(o1,9);
	bzero(o2,9);	

	cudaMalloc(&out1,8);
	cudaMalloc(&out2,8);

        int shared_size = BLOCK_SIZE_X * BLOCK_SIZE_Y * size_constraint;

	while (!empty_const) 
	{
		// TODO: we set constraint is empty and see whether new constraint is generated inside or not.
		empty_const = 10; 
		CUDA_SAFE_CALL(cudaMemcpy(d_empty_const, &empty_const, size_int, cudaMemcpyHostToDevice));
		
		CUDA_SAFE_CALL(cudaMalloc(&out_c_new_array, size));
		CUDA_SAFE_CALL(cudaMemset(out_c_new_array, '\0', size));
	
		// call a kernel function
		solve_constraints_kernel<<< grid, threads, shared_size>>> (
			reflection, 
			c_new_array, 
			num_var, 
			num_const, 
			size_constraint,
			out_c_new_array, 
			analysis, 
			d_empty_const,
			out1,
			out2); //dev_lock		//printf("debug11\n");

		CUDA_SAFE_CALL(cudaMemcpy(&empty_const, d_empty_const, size_int, cudaMemcpyDeviceToHost));
		printf ("empty_constraint flag returned = %d\n", empty_const);
		
        	cudaMemcpy(o1, out1, 8, cudaMemcpyDeviceToHost);
        	cudaMemcpy(o2, out2, 8, cudaMemcpyDeviceToHost);
		printf ("output o1, o2: %s, %s \n", o1, o2);

		printf("new constraint1:\n");		
		cudaMemcpy(temp, out_c_new_array, size, cudaMemcpyDeviceToHost);
		print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, size_constraint);

		cudaFree(c_new_array);

		c_new_array = out_c_new_array;	
		out_c_new_array = NULL;

		printf("new analysis:\n");
		cudaMemcpy(temp2, analysis, size, cudaMemcpyDeviceToHost);
		print_memory(temp2, BLOCK_SIZE_X, BLOCK_SIZE_Y, size_constraint);

		printf("new constraint2:\n");
		cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost);
		print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, size_constraint);
	}


	CUT_SAFE_CALL(cutStopTimer(timer));
	printf("Processing time:%f (ms)\n", cutGetTimerValue(timer));
	CUT_SAFE_CALL(cutDeleteTimer(timer));

 	// now analysis contains final answers at each colume(var).
	// Need to show them: var -> value mapping by having way of finding var from column index.
	


	printf("\nSOLUTIONS=========\n");
	CUDA_SAFE_CALL(cudaMemcpy(out_analysis, analysis, size, cudaMemcpyDeviceToHost));
	print_memory(out_analysis, BLOCK_SIZE_X, BLOCK_SIZE_Y, size_constraint);


	cudaFree(c_array);
	cudaFree(c_new_array);
	cudaFree(analysis);
	//cudaFree(dev_lock);

	cudaFree(out_c_new_array);

	free(temp);
	free(temp2);
	free(o1);
	free(o2);
/*
*/
}
