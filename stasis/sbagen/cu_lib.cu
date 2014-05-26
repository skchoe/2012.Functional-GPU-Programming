#include<stdio.h>
#include<cuda.h>
#include<cutil.h>
#include "def.h"
#include "hashtab.h"
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
__global__ void init_constraints_kernel(char *constraints, SizeType2* st2_inc, int num_var, int num_const, const int size_constraint, char* new_constraints, SizeType2* st2_outc, char* analysis, SizeType2* st2_an, int* empty_contraint)
{
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
__global__ void solve_constraints_kernel(char* reflection, SizeType2* st2_inr, char* constraint, SizeType2* st2_inc, int num_var, int num_const, 
                                         char* new_constraints, SizeType2* st2_outc, char* analysis, SizeType2* st2_anl, int* empty_constraint, /*Lock* lock, */char* out1,char* out2)
{
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

