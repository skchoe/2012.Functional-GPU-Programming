#include<stdio.h>
#include<cuda.h>
#include<cutil.h>
#include "def.h"
#include "hashtab.h"
#include "cu_lib.h"
//#include "lock.h"

#define islower(c) (((c) >= 'a') && ((c) <= 'b'))
#define isupper(c) (((c) >= 'A') && ((c) <= 'Z'))
#define isalpha(c) (islower(c) && isupper(c))
#define tolower(c) ((c)-'A'+'a')

// Hash Function

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

__device__ char* get_element2(char* h, int num_var, int key, int index){
	int row = (key + index*num_var)*SIZE_CONSTRAINT;
	char *elem_addr = h + row;
	return elem_addr;
}


char* get_element3(char* h, int num_var, int key, int index){
	int row = (key + index*num_var)*SIZE_CONSTRAINT;
	char *elem_addr = h + row;
	return elem_addr;
}

__device__ int put_element2(char* h, int num_var, int num_const, int key, char* constraint, /*Lock* lock,*/  int flag){
	int i;

	for (i=0 ; i < num_const; i++){
		int row = (key + i*num_var)*SIZE_CONSTRAINT;
		char* temp = h + row;
		if (*temp == '\0'){
			//lock[flag].lock();
			memcpy(temp, constraint, SIZE_CONSTRAINT);
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

extern "C"
__global__ void init_constraints_kernel(char *constraints, int num_var, int num_const, const int size_constraint, char* new_constraints, char* analysis, int* empty_contraint){
	int idx = threadIdx.x;
	int idy = threadIdx.y;
	
	char* a_constraint = get_element2(constraints,num_var,idx,idy);

	int pos = (idx + idy * num_var) * size_constraint;
	if( (constraints[pos] == '_') && ( constraints[pos+1] == 'v' || constraints[pos+1] == 'c' || constraints[pos+1] == 'l')){
       		memcpy(analysis+pos, a_constraint, size_constraint);
	} else {
       		memcpy(new_constraints+pos, a_constraint, size_constraint);
		*empty_contraint = 0;
	}
	__syncthreads();
}



extern "C"
__global__ void solve_constraints_kernel(char *reflection, char* constraint, int num_var, int num_const, char* new_constraints, char* analysis, int* empty_constraint, /*Lock* lock, */char* out1,char* out2){
	__shared__ char sh_constraints[BLOCK_SIZE_X*BLOCK_SIZE_Y*SIZE_CONSTRAINT];
	register char n_const[8];
	register char n_const2[8];
	register char value[8];

	int idx = threadIdx.x;
	int idy = threadIdx.y;
  	int i;


	char* sharemem_addr = sh_constraints; 
	sharemem_addr = sharemem_addr+idx*SIZE_CONSTRAINT*BLOCK_SIZE_X+idy*SIZE_CONSTRAINT;
	memcpy(sharemem_addr, get_element2(constraint, num_var,idx, idy), SIZE_CONSTRAINT);	

	memcpy(out1,sharemem_addr,SIZE_CONSTRAINT);
	for(i=0; i < num_const; i++){
		memcopy(value,get_element2(analysis, num_var, idx ,i),SIZE_CONSTRAINT);
		//memcopy(out2,value,SIZE_CONSTRAINT);	
		if (*value != '\0'){
			memset(n_const, '\0', 8);
			memset(n_const2, '\0', 8);
			if((*sharemem_addr=='_' && *(sharemem_addr+1)=='P') && (value[0]=='_' && value[1] == 'v')){
				int index = hashfunc(sharemem_addr+2);
				memcpy(n_const,value,8);
				put_element2(analysis,num_var,num_const, index,n_const,/*lock,*/0);
				int j;
				for(j=0;j <num_const; j++){
					char *c = get_element2(reflection,num_var,index, j);
					if (*c != '\0'){
						put_element2(new_constraints,num_var,num_const, index,c, /*lock,*/1);
						*empty_constraint = 0;
					}
				}
			} else if((*sharemem_addr=='_' && *(sharemem_addr+1)=='C') && (value[0]=='_' && value[1] == 'c')){
				int index = hashfunc(value+2);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,sharemem_addr+2,6);
				put_element2(new_constraints, num_var,num_const, index,n_const,/*lock*/1);
				*empty_constraint = 0;
			} else if(((*sharemem_addr=='_' && *(sharemem_addr+1)=='D')) && (value[0]=='_' && value[1] == 'c')){
				int index = hashfunc(value+4);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,sharemem_addr+2,6);
				put_element2(new_constraints, num_var, num_const, index, n_const, /*lock,*/0);
				*empty_constraint = 0;
			} else if((*sharemem_addr=='_' && *(sharemem_addr+1)=='A') && (value[0]=='_' && value[1] == 'l')){
				int index1 = hashfunc(value+6);
				int index2 = hashfunc(sharemem_addr +4);
				n_const[0] = '_';
				n_const2[0]= '_';
				n_const[1] = 'P';
				n_const2[1]= 'P';
				memcopy(n_const+2,sharemem_addr+2,2);
				memcopy(n_const2+2,value+2,2);
				put_element2(new_constraints, num_var, num_const, index1, n_const, /*lock,*/1);
				put_element2(new_constraints, num_var, num_const, index2, n_const2, /*lock,*/1);
				memcopy(out1,n_const,8);
				memcopy(out2,n_const2,8);
				*empty_constraint = 0;
			} else if((*sharemem_addr=='_' && *(sharemem_addr+1) =='A') && (value[0]=='_' && value[1] == 't')){
				int index = hashfunc(sharemem_addr+4);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,value+2,6);
				put_element2(new_constraints, num_var, num_const, index, n_const, /*lock,*/1);
				*empty_constraint = 0;
			} else {
				//*empty_constraint = 1;
			}
		}
	}

	__syncthreads();
}



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

	/* Call Kernel function */
	init_constraints_kernel<<< grid, threads >>>(c_array, num_var, num_const, SIZE_CONSTRAINT, c_new_array, analysis, d_empty_const); 

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
	
	while (!empty_const) {	
		empty_const = 1;
		CUDA_SAFE_CALL(cudaMemcpy(d_empty_const, &empty_const,size_int,cudaMemcpyHostToDevice));
		
		CUDA_SAFE_CALL(cudaMalloc(&out_c_new_array, size));
		CUDA_SAFE_CALL(cudaMemset(out_c_new_array, '\0', size));
	
		// call a kernel function
		solve_constraints_kernel<<< grid, threads>>> (reflection, c_new_array, num_var, num_const, out_c_new_array, analysis, d_empty_const,out1,out2); //dev_lock		//printf("debug11\n");
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


