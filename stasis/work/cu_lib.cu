#include<stdio.h>
#include<cuda.h>
#include<cutil.h>
#include "hashtab.h"
#include "cu_lib.h"

// return pointer of h[key,index]

extern "C"
__device__ int hashfunc(char *to){
	return *to -'a';	
}

extern "C"
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

extern "C"
__device__ int put_element2(char* h, int num_var, int num_const, int key, char* constraint){
	int i;
	for (i=0 ; i < num_const; i++){
		int row = (key + i*num_var)*SIZE_CONSTRAINT;
		char* temp = h + row;
		if (*temp == '\0'){
			memcpy(temp, constraint, SIZE_CONSTRAINT);
			return 1;
		}
	}	return -1; 
} 
	

extern "C"
__device__ void memcopy(char* dest, char* sour, int size){
	int i;
	for(i=0; i < size; i++)
		dest[i] = sour[i];

}

extern "C"
__global__ void test0(char *constraints, int num_var, int num_const, int sz, char* new_const, char* analysis, char* extra)
{
}
extern "C"
__global__ void test1(int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, 
char* byteset, char* byte_return, int* bargs)
{
    int i = threadIdx.x;

    // byte_return
    byte_return[i*4] = byteset[i*4];
    byte_return[i*4+1] = byteset[i*4+1];
    byte_return[i*4+2] = byteset[i*4+2];
    byte_return[i*4+3] = byteset[i*4+3];

    // bargs
    switch (i) {
    case 0:
            bargs[0] = arg1 * 10;
            break;
    case 1:
	    bargs[1] = arg2 * 10;
      	    break;
    case 2:
            bargs[2] = arg3 * 10;
            break;
    case 3:
   	bargs[3] = arg4 * 10;
    	break;
    case 4:
        bargs[4] = arg5 * 10;
        break;
    case 5:
        bargs[5] = arg6 * 10;
        break;
    case 6:
        bargs[6] = arg7 * 10;
           break;
    case 7:
        bargs[7] = arg8 * 10;
        break;
    case 8:
        bargs[8] = arg9 * 10;
     	break;
     }
}


extern "C"
__global__ void init_constraints_kernel(char *constraints, int num_var, int num_const, const int size_constraint, char* new_constraints, char* analysis, int* empty_contraint){

	int idx = threadIdx.x;
	int idy = threadIdx.y;
	
	char* a_constraint = get_element2(constraints,num_var,idx,idy);

	int pos = (idx + idy * num_var) * size_constraint;

/////////////////////////////input checker///////////////////////////
//       	memcpy(analysis+pos, "_|_|_|_|", size_constraint);
//       	memcpy(new_constraints+pos, "_|_|_|_|", size_constraint);
//	*empty_contraint = 0;

/////////////////////////////original///////////////////////////

	if( (constraints[pos] == '_') && ( constraints[pos+1] == 'v' || constraints[pos+1] == 'c' || constraints[pos+1] == 'l')){
       		memcpy(analysis+pos, a_constraint, size_constraint);
	} else {
       		memcpy(new_constraints+pos, a_constraint, size_constraint);
		*empty_contraint = 0;
	}

	__syncthreads();
}



extern "C"
__global__ void solve_constraints_kernel(char *reflection, char* constraint, int num_var, int num_const, char* new_constraints, char* analysis, int* empty_constraint,char* out1,char* out2){
	__shared__ char sh_constraints[BLOCK_SIZE_X * BLOCK_SIZE_Y * SIZE_CONSTRAINT];
	register char n_const[8];
	register char n_const2[8];
	register char value[8];

	int idx = threadIdx.x;
	int idy = threadIdx.y;
  	int i;

	//int z=2;
	//int x = idy*SIZE_CONSTRAINT;
	//int y = idx*SIZE_CONSTRAINT;	

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
				put_element2(analysis,num_var,num_const, index,n_const);
				//*empty_constraint = 1;
			} else if((*sharemem_addr=='_' && *(sharemem_addr+1)=='C') && (value[0]=='_' && value[1] == 'c')){
				int index = hashfunc(value+2);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,sharemem_addr+2,6);
				put_element2(new_constraints, num_var,num_const, index,n_const);
				*empty_constraint = 0;
			} else if(((*sharemem_addr=='_' && *(sharemem_addr+1)=='D')) && (value[0]=='_' && value[1] == 'c')){
				int index = hashfunc(value+4);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,sharemem_addr+2,6);
				put_element2(new_constraints, num_var, num_const, index, n_const);
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
				put_element2(new_constraints, num_var, num_const, index1, n_const);
				put_element2(new_constraints, num_var, num_const, index2, n_const2);
				memcopy(out1,n_const,8);
				memcopy(out2,n_const2,8);
				*empty_constraint = 0;
			} else if((*sharemem_addr=='_' && *(sharemem_addr+1) =='A') && (value[0]=='_' && value[1] == 't')){
				int index = hashfunc(sharemem_addr+4);
				n_const[0] = '_';
				n_const[1] = 'P';
				memcpy(n_const+2,value+2,6);
				put_element2(new_constraints, num_var, num_const, index, n_const);
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
  for(i = 0 ; i < szx ; i++)
  for(j = 0 ; j < szy ; j++) {
    pos = (j*szx + i) * szelt;
    printf("[%d,%d]\t", i, j);
    for(k=0;k<szelt;k++)
      printf("%c", dish[pos+k]);
    printf("\t");
  }
  printf ("\n");
}

// those wrappers call kernel functions
void solver_constraint_wrapper(hash_tab* c, char* out_analysis){
	int num_var = c->num_variable;
	int num_const = c->num_constraint;
	int size = num_var * num_const * SIZE_CONSTRAINT;
	//int i;
	char *c_array;
	char *c_new_array;
	char *analysis;
	char *temp; 
	char *reflection;

	cudaMalloc( (void**)&c_array, size);
	cudaMalloc( (void**)&c_new_array, size);
	cudaMalloc( (void**)&analysis, size);
	cudaMalloc( (void**)&reflection, size);


	temp = (char*) malloc(size);
	memset(temp,'\0',size);	

	cudaMemcpy(c_array, c->ht, size, cudaMemcpyHostToDevice);
	cudaMemcpy(reflection, c->ht, size, cudaMemcpyHostToDevice);
	cudaMemset(c_new_array, '\0', size);
	cudaMemset(analysis, '\0', size);
		
	dim3 threads(BLOCK_SIZE_X, BLOCK_SIZE_Y);
	dim3 grid(1);

	int empty_const=1;
	int *d_empty_const;
	int size_int = sizeof(int);
	cudaMalloc((void**)&d_empty_const,size_int);
	cudaMemcpy(d_empty_const, &empty_const,size_int,cudaMemcpyHostToDevice);

	init_constraints_kernel<<< grid, threads >>>(c_array, num_var, num_const, SIZE_CONSTRAINT, c_new_array, analysis, d_empty_const); 

	cudaMemcpy(&empty_const, d_empty_const,4,cudaMemcpyDeviceToHost);
	printf("(let (a (lambda c c)) in\n (let b 1) in\n (app a b) \n");
	
	printf("frist constraint \n" );
	cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost);
	print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);
		
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
		cudaMemcpy(d_empty_const, &empty_const,size_int,cudaMemcpyHostToDevice);
		
		cudaMalloc(&out_c_new_array, size);
		cudaMemset(out_c_new_array, '\0', size);
		
		solve_constraints_kernel<<< grid, threads>>> (reflection, c_new_array, num_var, num_const, out_c_new_array, analysis, d_empty_const,out1,out2);
		//printf("debug1\n");
		cudaMemcpy(&empty_const, d_empty_const,size_int,cudaMemcpyDeviceToHost);

		//printf("new constraint1:\n");		
		//cudaMemcpy(temp, out_c_new_array, size, cudaMemcpyDeviceToHost);
		//print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);

		cudaFree(c_new_array);

		c_new_array = out_c_new_array;	
		out_c_new_array = NULL;

		///printf("new analysis:\n");
		//cudaMemcpy(temp2, analysis, size, cudaMemcpyDeviceToHost);
		//print_memory(temp2, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);

		printf("new constraint2:\n");
		cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost);
		print_memory(temp, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);
	}

        cudaMemcpy(o1, out1,8,cudaMemcpyDeviceToHost);
        cudaMemcpy(o2, out2,8,cudaMemcpyDeviceToHost);
	printf("debug:::<%s> %s\n",o1,o2);


 	// now analysis contains final answers at each colume(var).
	// Need to show them: var -> value mapping by having way of finding var from column index.
	
	cudaMemcpy(out_analysis, analysis, size, cudaMemcpyDeviceToHost);
	printf("\nSOLUTIONS=========\n");
	print_memory(out_analysis, BLOCK_SIZE_X, BLOCK_SIZE_Y, SIZE_CONSTRAINT);
	cudaFree(c_array);
	cudaFree(c_new_array);
	cudaFree(analysis);
	cudaFree(out_c_new_array);
	
}


