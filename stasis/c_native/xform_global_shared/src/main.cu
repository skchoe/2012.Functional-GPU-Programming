/*
 * main.c
 *
 *  Created on: Feb 28, 2012
 *      Author: u0332192
 */

#include <stdio.h>
#include <time.h>
#include <stdint.h>

#include <cuda.h>
#include <cutil.h>
#include <device_functions.h>
#include <vector_types.h>
#include <cuda_runtime_api.h>

typedef unsigned char byte;


int64_t timespecDiffNano(struct timespec *timeA_p, struct timespec *timeB_p)
{
  return ((timeA_p->tv_sec * 1000000000) + timeA_p->tv_nsec) -
           ((timeB_p->tv_sec * 1000000000) + timeB_p->tv_nsec);
}

// output c_constraint, c_asis
void init_constraints_ptrptr_cpu(int num_var, int max_num_const, size_t const_size,
		int* num_const, byte** constm_org,
		int* var_nums_cc, byte* c_constm, int* var_nums_ca, byte* c_asis)
{
	//printf("num_var:%d, max_num_const:%d\n", num_var, max_num_const);
	int i, j;
	for(i=0;i<max_num_const;i++) {
		for(j=0;j<num_var;j++) {
			if (i < num_const[j]) {
				byte cst = constm_org[j][i]; /// assumption : constraint is just one byte.
				//printf("cpu - var:%d, const:%d, cst:%d\n", j, i, cst);
				if(cst == 2) {
					memcpy(&(c_constm[j + num_var * var_nums_cc[j]]), &cst, const_size);
					var_nums_cc[j]++;
				}
				else {// cst==1
					memcpy(&(c_asis[j + num_var * var_nums_ca[j]]), &cst, const_size);
					var_nums_ca[j]++;
				}
			}
		}
	}

	//printf("__________init_cpu done______--\n");
	return;
}

void init_constraints_csr_cpu(int num_var, int tot_num_const, size_t const_size,
		int* indices, byte* data,
		int* var_nums_cc, byte* c_constm, int* var_nums_ca, byte* c_asis)
{
	//printf("num_var:%d, max_num_const:%d\n", num_var, max_num_const);
	printf("csr: tot_num_const:%d\n", tot_num_const);
	int i, j;
	for(i=0;i<tot_num_const;i++) {
		int var = indices[i];
		byte cst = data[i]; /// assumption : constraint is just one byte.
		//printf("cpu - var:%d, const:%d, cst:%d\n", j, i, cst);
		if(cst == 2) {
			memcpy(&(c_constm[var + num_var * var_nums_cc[var]]), &cst, const_size);
			var_nums_cc[var]++;
		}
		else if(cst == 1){// cst==1
			memcpy(&(c_asis[var + num_var * var_nums_ca[var]]), &cst, const_size);
			var_nums_ca[var]++;
		}
		else {
		}
	}

	//printf("__________init_cpu done______--\n");
	return;
}

__device__ unsigned int* shared_part(unsigned int th, unsigned int spart_width,
		int block_width, int block_idx)
{
	extern __shared__ unsigned int s_lock_nums[];
	unsigned int offset = (th * spart_width) + (block_idx * block_width);
	return (unsigned int*) (s_lock_nums + offset);
}


// shared memory structure
// just lock, varnum, output submatrix in block.x range. - read from global memory
//int sz_shd = (block.x * 2 * sizeof(int) * 2); //num_var, 2(lock,varnum), int-content type
//		+ block.x * sizeof(int) // var_name set
//		+ 2 * block.x * max_num_const;  // output index, output data
__global__ void init_constraints_shared(
		size_t* const_size, int* num_var, int* max_num_const, int* num_tot_const,
		int* ptr, int* indices, byte* data,
		unsigned int* var_lock_constm, unsigned int* var_nums_constm,
		int* max_num_constm, int* num_constm, byte* constm,
		unsigned int* var_lock_asis, unsigned int* var_nums_asis,
		int* max_num_asis, int* num_asis, byte* asis)
{
	extern __shared__ byte shared_sp[];

	// copy from global to shared
	size_t loc_lock_constm = 0,                               sz_lock_constm = blockDim.x * sizeof(int);
	size_t loc_num_constm = sz_lock_constm,                   sz_num_constm = blockDim.x * sizeof(int);
	size_t loc_lock_asis = loc_num_constm + sz_num_constm,    sz_lock_asis   = blockDim.x * sizeof(int);
	size_t loc_num_asis = loc_lock_asis + sz_lock_asis,       sz_num_asis = blockDim.x + sizeof(int);

	__shared__ int* s_lock_constm;
	s_lock_constm = (int*) (shared_sp + loc_lock_constm);
	__shared__ int* s_num_constm;
	s_num_constm = (int*) (shared_sp + loc_num_constm);

	__shared__ int* s_lock_asis;
	s_lock_asis = (int*) (shared_sp + loc_lock_asis);
	__shared__ int* s_num_asis;
	s_num_asis = (int*) (shared_sp + loc_num_asis);

	memcpy(s_lock_constm, var_lock_constm, sz_lock_constm);
	memcpy(s_num_constm,  var_nums_constm, sz_num_constm);
	memcpy(s_lock_asis,   var_lock_asis,   sz_lock_asis);
	memcpy(s_num_asis,    var_nums_asis,   sz_num_asis);

	__syncthreads();

	// coordinates in global memory
	int csr_gidx = threadIdx.x + blockIdx.x * blockDim.x;
	int csr_sidx = threadIdx.x;

//	check indexing into target array!!!!!!!!!!

	if (csr_gidx < *num_tot_const)
	{
		int var_id = indices[csr_gidx];
		byte* input_constm = (byte*) &(data[csr_gidx * *const_size]);

		int pos_input;
		if(*input_constm == 2) { // constraint
			do {
				pos_input = var_id + var_nums_constm[var_id] * *num_var;
				//memcpy(&constm[pos_input], input_constm, *const_size);
				constm[pos_input] = *input_constm;
				var_nums_constm[var_id]++;
				num_constm[var_id]++;

				var_lock_constm[var_id] = 0;
			} while(atomicCAS(&(var_lock_constm[var_id]), 0, 1));
		}
		else if(*input_constm == 1) { // analysis
			do {
				pos_input = var_id + var_nums_asis[var_id] * *num_var;
				//memcpy(&asis[pos_input], input_constm, *const_size);
				asis[pos_input] = *input_constm;
				var_nums_asis[var_id]++;
				num_asis[var_id]++;

				var_lock_asis[var_id] = 0;
			} while(atomicCAS(&(var_lock_asis[var_id]), 0, 1));
		}
		else {
			pos_input = 0;
			int value = 88;
			memset(&constm[var_id + var_nums_constm[var_id] * *num_var], value, *const_size);
			memset(&asis[var_id + var_nums_asis[var_id] * *num_var], value, *const_size);
		}
	}

	__syncthreads();

	// copy to global memory

	return;
}

__global__ void init_constraints_global
		(size_t* const_size, int* num_var, int* max_num_const, int* num_tot_const,
		int* ptr, int* indices, byte* data,
		unsigned int* var_lock_constm, unsigned int* var_nums_constm,
		int* max_num_constm, int* num_constm, byte* constm,
		unsigned int* var_lock_asis, unsigned int* var_nums_asis,
		int* max_num_asis, int* num_asis, byte* asis)
{
	// coordinates in global memory
	int csr_idx = threadIdx.x + blockIdx.x * blockDim.x;

//	check indexing into target array!!!!!!!!!!

	if (csr_idx < *num_tot_const)
	{
		int var_id = indices[csr_idx];
		byte* input_constm = (byte*) &(data[csr_idx * *const_size]);

		int pos_input;
		if(*input_constm == 2) { // constraint
			do {
				pos_input = var_id + var_nums_constm[var_id] * *num_var;
				//memcpy(&constm[pos_input], input_constm, *const_size);
				constm[pos_input] = *input_constm;
				var_nums_constm[var_id]++;
				num_constm[var_id]++;

				var_lock_constm[var_id] = 0;
			} while(atomicCAS(&(var_lock_constm[var_id]), 0, 1));
		}
		else if(*input_constm == 1) { // analysis
			do {
				pos_input = var_id + var_nums_asis[var_id] * *num_var;
				//memcpy(&asis[pos_input], input_constm, *const_size);
				asis[pos_input] = *input_constm;
				var_nums_asis[var_id]++;
				num_asis[var_id]++;

				var_lock_asis[var_id] = 0;
			} while(atomicCAS(&(var_lock_asis[var_id]), 0, 1));
		}
		else {
			pos_input = 0;
			int value = 88;
			memset(&constm[var_id + var_nums_constm[var_id] * *num_var], value, *const_size);
			memset(&asis[var_id + var_nums_asis[var_id] * *num_var], value, *const_size);
		}
	}

	__syncthreads();

	return;
}


int sharedMemory()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.sharedMemPerBlock;
}

// given input from Racket(list of list), produces CSR
void transform_const_csr(int num_var, int num_tot_const, int max_num_const, int* num_const, byte** constm,
						int* ptr, int* indices, byte* data, size_t sz_const)
{
	int i,j,k,l;

	k=0, l=0;	// l: num of valid consts

	for(i=0;i<max_num_const;i++) {
		for(j=0;j<num_var;j++) {
			if (i < num_const[j]) {
				memcpy(&data[k], &(constm[j][i]), sz_const);
				data[k] = constm[j][i];
				indices[k] = j;
				l++;
				k++;
			}
		}
		ptr[i+1] = l;
	}
//	for(k=0;k<num_var;k++)
//		printf("num const[%d:%d\n", k, num_const[k]);
//
//	for(j=0;j<=max_num_const;j++)
//		printf("transform_const's ptr[%d]:%d\n", j, ptr[j]);

	return;
}

double ilog(double base, double x) {
	return log(x) / log(base);
}


int main(int argc, char** argv)
{
	int i, j, k;

	//create data
	int expo = 20;
	int num_var = (int) pow(2, expo);//16; // ; we'll 2^9/2^4 constraints in max
	int num_const_limit = (int) pow(2, 4); // per each variable


	size_t const_size = 1; // 1byte k spaces, k=1 for now
	size_t sz_num_const = sizeof(int) * num_var; // number of constraints for each variable

	// list of num_const for each var.
	int* num_const = (int*) malloc(sz_num_const);
	for(i=0;i<num_var;i++) {
		num_const[i] = (int) (rand() % (num_const_limit + 1));
//		printf("%d, %d / %d\n", i, num_const[i], num_const_limit);
	}

	int num_tot_const = 0;
	for(i=0;i<num_var;i++) {
		num_tot_const += num_const[i];
	}
//	printf("total num const:%d\n", num_tot_const);

	int max_num_const = 0;
	for(i=0;i<num_var;i++) {
		int n = num_const[i];
		if(n > max_num_const) max_num_const = n;
	}
	////////////////////////////////////////////////////////////////////////////////////////
	// fill constraint either 1 or 2.
	size_t sz_const = num_tot_const * const_size;
	byte* const_org = (byte*) malloc (sz_const);
	k = 0;
	for(i=0;i<num_var;i++) // height
		for(j=0;j<num_const[i];j++) {
			const_org[k] = rand() % 2 + 1;
			k++;
		}

	printf("num_tot_const:%d, const_size:%d, max_num_const:%d\n", num_tot_const, const_size, max_num_const);
//	k=0;
//	for(i=0;i<num_var;i++) // height
//		for(j=0;j<num_const[i];j++) {
//			printf("var:%d, const:%d, const_org[%d]: %d\n", i, j, k, const_org[k]);
//			k++;
//		}

	k=0;
	//// const_org -> constm: (array of byte) -> (array of pointer of byte)
	byte** constm_org = (byte**) malloc(sizeof(byte*) * num_var);
	for(i=0;i<num_var;i++)
		constm_org[i] = (byte*)malloc(num_const[i] * const_size);
	for(i=0;i<num_var;i++) // height
		for(j=0;j<num_const[i];j++) {
			memcpy(&constm_org[i][j], &const_org[k], const_size);
			k++;
		}



//	for(i=0;i<num_var;i++)  {// height
//		printf("num of constraint at %dth var:\n", i);
//		for(j=0;j<num_const[i];j++) {
//			printf("const[%d,%d] = %d\n", i, j, constm_org[i][j]);
//		}
//	}

	size_t sz_mat = const_size * num_var * max_num_const;
	size_t sz_var_num = sizeof(int) * num_var;

	//	// begin cpu time check
	timespec ts_start, ts_stop;
	printf("CLOCk:.....%d\n", CLOCK_MONOTONIC + 2);
	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_start))
	printf("taking clock - start successful\n");

	byte* c_constm = (byte*) malloc(sz_mat);
	memset(c_constm, NULL, sz_mat);

	int* var_nums_cc = (int*)malloc(sz_var_num);
	memset(var_nums_cc, 0, sz_var_num);

	byte* c_asis = (byte*) malloc(sz_mat);
	memset(c_asis, NULL, sz_mat);

	int* var_nums_ca = (int*)malloc(sz_var_num);
	memset(var_nums_ca, 0, sz_var_num);


	init_constraints_ptrptr_cpu(num_var, max_num_const, const_size,
			num_const, constm_org, var_nums_cc, c_constm, var_nums_ca, c_asis);

	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_stop))
		printf("taking clock - stop successful\n");
	uint64_t timeElapsedNano = timespecDiffNano(&ts_stop, &ts_start);


	// end cpu time check
	//clock_t tv_stop = clock();
	//double diff_ms = ((double)tv_stop - (double) tv_start) * 1000. / CLOCKS_PER_SEC;

	//printf("CPU(clock) (%d->%d)\nDIFF:%e (%f)(ms)\n\n", tv_start, tv_stop, diff_ms, diff_ms);
	printf("cpu - ptrptr (s):(%u->%u)\ncpu(ns):(%u->%u)\n cpu_elapsed(ms):%f \n\n",
			ts_start.tv_sec, ts_stop.tv_sec,
			ts_start.tv_nsec, ts_stop.tv_nsec, (double)timeElapsedNano/(double)1000000000);


//	for(i=0;i<num_var;i++) {
//		printf("var:%d ------- num_const:%d\n", i, var_nums_cc[i]);
//		for(j=0;j<var_nums_cc[i];j++) {
//			printf("var:%d, const:%d, byte-const:%d\n", i, j, c_constm[i + j * num_var]);
//		}
//	}
//
//	for(i=0;i<num_var;i++) {
//		printf("var:%d ------- num_asis:%d\n", i, var_nums_ca[i]);
//		for(j=0;j<var_nums_ca[i];j++) {
//			printf("var:%d, const:%d, byte-asis:%d\n", i, j, c_asis[i + j * num_var]);
//		}
//	}

	/// prepare for GPU compuatation.
	//////////////// CSR format conversion
	size_t sz_ptr = sizeof(int) * (max_num_const + 1);
	int* ptr = (int*) malloc(sz_ptr); // ptr is 1+max num_const
	for(i=0;i<=max_num_const;i++) ptr[i] = 0;
	size_t sz_indices = sizeof(int) * num_tot_const;
	int* indices = (int*) malloc(sz_indices);
	memset(indices, NULL, sz_indices);

	byte* data = (byte*) malloc(sz_const);
	memset(data, NULL, sz_const);
	transform_const_csr(num_var, num_tot_const, max_num_const, num_const, constm_org,
							ptr, indices, data, const_size);

	// check 2nd cpu init
	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_start))
		printf("taking clock - start successful\n");

	// iniitialize again
	memset(c_constm, NULL, sz_mat);
	memset(var_nums_cc, 0, sz_var_num);
	memset(c_asis, NULL, sz_mat);
	memset(var_nums_ca, 0, sz_var_num);

	// init_contraints_cpu by CSRint num_var, int tot_num_const, size_t const_size,
	init_constraints_csr_cpu(num_var, num_tot_const, const_size,
			indices, data, var_nums_cc, c_constm, var_nums_ca, c_asis);

	if(0==clock_gettime(CLOCK_MONOTONIC, &ts_stop))
		printf("taking clock - stop successful\n");
	timeElapsedNano = timespecDiffNano(&ts_stop, &ts_start);

	printf("cpu -csr (s):(%u->%u)\ncpu(ns):(%u->%u)\n cpu_elapsed(ms):%f \n\n",
			ts_start.tv_sec, ts_stop.tv_sec,
			ts_start.tv_nsec, ts_stop.tv_nsec, (double)timeElapsedNano/(double)1000000000);

	////////////////////////////////////////////////////////////////////////////////////////
	// GPU configuration
	// num_var:2^10, max_num_const
	int least_num_threadx = max(16, (int)(num_var/pow(2, 4)));
//	int num_thread_x = least_num_threadx;
	int num_thread_x = min(least_num_threadx , (int)pow(2, 8)); //maximum 256
	printf("decied thread.x = %d\n", num_thread_x);
	int num_thread_y = 1;
	int num_block_x = pow (2, ceil (ilog (2, num_tot_const / num_thread_x)));
	int num_block_y = 1;

	dim3 grid(num_block_x, num_block_y);
	dim3 block(num_thread_x, num_thread_y);

	printf("tot_const:%d, num_thd_x:%d __________________________>>>num_block_x : %d\n", num_tot_const, num_thread_x, num_block_x);


	////////////////////////////////////////////////////////////////////////////////////////
	// time to split from const_org into { constm, analysis }
	int SHD_CAP = sharedMemory();

	// just lock, varnum, output submatrix in block.x range. - read from global memory
	int sz_shd = (block.x * 2 * sizeof(int) * 2); //num_var, 2(lock,varnum), int-content type
//			+ (max_num_const + 1) * sizeof(int) // ptr
//			+ num_tot_const * (sizeof(int) + const_size) // indices and consts
			+ block.x * sizeof(int) // var_name set
			+ 2 * block.x * max_num_const;  // output index, output data

	printf("shared mem: required:%d bytes, cap:%d bytes\n", sz_shd, SHD_CAP);


	//begin gpu timer
    unsigned int timerg_all = 0;
    cutCreateTimer(&timerg_all);
    cutResetTimer(timerg_all);

    unsigned int timerg_exe = 0;
    cutCreateTimer(&timerg_exe);
    cutResetTimer(timerg_exe);

	cutStartTimer(timerg_all);

	// Basic inputs
	size_t* g_const_size;
	cudaMalloc(&g_const_size, sizeof(size_t));
	cudaMemcpy(g_const_size, &const_size, sizeof(size_t), cudaMemcpyHostToDevice);

	int* g_num_var;
	cudaMalloc(&g_num_var, sizeof(int));
	cudaMemcpy(g_num_var, &num_var, sizeof(int), cudaMemcpyHostToDevice);

	int* g_max_num_const;
	cudaMalloc(&g_max_num_const, sizeof(int));
	cudaMemcpy(g_max_num_const, &max_num_const, sizeof(int), cudaMemcpyHostToDevice);

	int* g_num_tot_const;
	cudaMalloc(&g_num_tot_const, sizeof(int));
	cudaMemcpy(g_num_tot_const, &num_tot_const, sizeof(int), cudaMemcpyHostToDevice);

	// CSR structure
	int* g_ptr;
	cudaMalloc(&g_ptr, sz_ptr);
	cudaMemcpy(g_ptr, ptr, sz_ptr, cudaMemcpyHostToDevice);

	int* g_indices;
	cudaMalloc(&g_indices, sz_indices);
	cudaMemcpy(g_indices, indices, sz_indices, cudaMemcpyHostToDevice);

	byte* g_data;
	cudaMalloc(&g_data, sz_const);
	cudaMemcpy(g_data, data, sz_const, cudaMemcpyHostToDevice);


	//output size
	size_t sz_constm = const_size * max_num_const * num_var; // used as matrix alloc for output
	////////////////////////////////////////////////////////////////////////////////////////
	// alloc constraints, & analysis
	// gpu containers for returns
	int* g_max_num_constm;
	cudaMalloc(&g_max_num_constm, sizeof(int));
	cudaMemset(g_max_num_constm, NULL, sizeof(int));

	int* g_num_constm;
	cudaMalloc(&g_num_constm, sz_num_const);
	cudaMemset(g_num_constm, NULL, sz_num_const);

	byte* g_constm;
	cudaMalloc(&g_constm, sz_constm);
	cudaMemset(g_constm, NULL, sz_constm);

	int* g_max_num_asis;
	cudaMalloc(&g_max_num_asis, sizeof(int));
	cudaMemset(g_max_num_asis, NULL, sizeof(int));

	int* g_num_asis;
	cudaMalloc(&g_num_asis, sz_num_const);
	cudaMemset(g_num_asis, NULL, sz_num_const);

	byte* g_asis;
	cudaMalloc(&g_asis, sz_constm);
	cudaMemset(g_asis, NULL, sz_constm);


	// lock for each column - constraint  (values 0 or 1)
	size_t sz_locks = num_var * sizeof(unsigned int);
	unsigned int* gvar_lock_constm;
	cudaMalloc(&gvar_lock_constm, sz_locks);
	cudaMemset(gvar_lock_constm, 0, sz_locks);

	// current column indicator - constraint
	unsigned int* gvar_nums_constm;
	cudaMalloc(&gvar_nums_constm, sz_locks);
	cudaMemset(gvar_nums_constm, NULL, sz_locks);

	// lock for each column - analysis (values 0 or 1)
	unsigned int* gvar_lock_asis;
	cudaMalloc(&gvar_lock_asis, sz_locks);
	cudaMemset(gvar_lock_asis, 0, sz_locks);

	// current column indicator - analysis
	unsigned int* gvar_nums_asis;
	cudaMalloc(&gvar_nums_asis, sz_locks);
	cudaMemset(gvar_nums_asis, NULL, sz_locks);

	cutStartTimer(timerg_exe);

//	if( SHD_CAP < sz_shd) {
//		printf("shared memory (lock+nums) is too small(%d byte) to be fit for num_var\n", sz_shd);
//

		init_constraints_global<<<grid, block>>>(g_const_size, g_num_var, g_max_num_const, g_num_tot_const,
										 g_ptr, g_indices, g_data,
										 gvar_lock_constm, gvar_nums_constm,
										 g_max_num_constm, g_num_constm, g_constm,
										 gvar_lock_asis, gvar_nums_asis,
										 g_max_num_asis, g_num_asis, g_asis);
//	}
//	else {
//
//		printf("--------shared memory (lock+nums) is can contain num_var (%d bytes=%d x %d)\n", sz_shd, max_num_const, block.x);
//		printf("grid dimx:%d, dimy:%d\n", grid.x, grid.y);
//		init_constraints_shared<<<grid, block, sz_shd>>>(g_const_size, g_num_var, g_max_num_const, g_num_tot_const,
//	 	 	 	 	 	 	 	 	 	 	 g_ptr, g_indices, g_data,
//							 	 	 	 	 gvar_lock_constm, gvar_nums_constm,
//	 	 	 	 	 	 	 	 	 	 	 g_max_num_constm, g_num_constm, g_constm,
//							 	 	 	 	 gvar_lock_asis, gvar_nums_asis,
//	 	 	 	 	 	 	 	 	 	 	 g_max_num_asis, g_num_asis, g_asis);
//	}

    cutStopTimer(timerg_exe);
    cutStopTimer(timerg_all);

//	int* num_constm = (int*) malloc (sz_num_const);
//	cudaMemcpy(num_constm, g_num_constm, sz_num_const, cudaMemcpyDeviceToHost);

	byte* new_constm = (byte*) malloc (sz_constm);
	cudaMemcpy(new_constm, g_constm, sz_constm, cudaMemcpyDeviceToHost);

//	int* num_asis = (int*) malloc (sz_num_const);
//	cudaMemcpy(num_asis, g_num_asis, sz_num_const, cudaMemcpyDeviceToHost);

	byte* asis = (byte*) malloc (sz_constm);
	cudaMemcpy(asis, g_asis, sz_constm, cudaMemcpyDeviceToHost);

//	for(i=0;i<num_var;i++)
//		for(j=0;j<max_num_const;j++)
//			printf("newconst[%d][%d]:%d\n", i, j, new_constm[j*num_var+i]);
//
//	for(i=0;i<num_var;i++)
//		for(j=0;j<max_num_const;j++)
//			printf("asis[%d][%d]:%d\n", i, j, asis[j*num_var+i]);

	// current column indicator - constraint
	unsigned int* var_nums_constm = (unsigned int*)malloc (sz_locks);
	cudaMemcpy(var_nums_constm, gvar_nums_constm, sz_locks, cudaMemcpyDeviceToHost);

	// current column indicator - analysis
	unsigned int* var_nums_asis = (unsigned int*)malloc (sz_locks);
	cudaMemcpy(var_nums_asis, gvar_nums_asis, sz_locks, cudaMemcpyDeviceToHost);



    double tvg = cutGetTimerValue(timerg_exe);
    printf("gpu time glb(kernel):\n %e \n(%f)(ms)\n", tvg, tvg);
    cutDeleteTimer(timerg_exe);

    double tvga = cutGetTimerValue(timerg_all);
    printf("gpu time glb(kernel+in-copy):\n %e \n(%f)(ms)\n", tvga, tvga);
    cutDeleteTimer(timerg_all);

//	for(i=0;i<num_var;i++) {
//		printf("var:%d, num_constm:%d\n", i, var_nums_constm[i]);
//	}
//
//	for(i=0;i<num_var;i++) {
//		printf("var:%d, num_asis:%d\n", i, var_nums_asis[i]);
//	}
//







	return 1;
}
