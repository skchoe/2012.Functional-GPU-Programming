/*
 * gstm_kernel.h
 *
 *  Created on: Apr 23, 2012
 *      Author: u0332192
 */

#ifndef GSTM_KERNEL_H_
#define GSTM_KERNEL_H_

#include <stdio.h>
#include <stdlib.h>
//#include <strings.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <malloc.h>

__global__ void sum_kernel_int32(int *num_elt, int *elts, int* num_block, int *gsum);
ullong* sum_gpu_kernel(ullong num_elt, ullong* gnum_elt, ullong* gelts);




__global__ void init_constraints_kernel_stm(
		int* ss_in_num_const, byte** ss_in_constnames, byte** ss_in_constm,
		int num_var, size_t var_const_max,
		int* ss_out_cst_num_const, byte** ss_out_cst_constnames, byte** ss_out_cst_constm,
		int* ss_out_anly_num_const, byte** ss_out_anly_constnames, byte** ss_out_anly_constm,
		int is_uniform_var_width, int is_euqal_const_size);

__global__ void init_constraints_kernel_csr(
		int num_var, int max_num_const, int num_tot_const, size_t sz_a_const,
		int* indices, byte* data,
		int* lock_const, int* varnum_const,
		byte* constm,
		int* lock_asis, int* varnum_asis,
		byte* asis,
		int* is_const_empty);

__global__ void solve_constraints_kernel(
				int num_var, int max_num_const, size_t sz_a_const,
				int* g_varnum_refl,  byte* g_reflection,
				int* g_varnum_const,  byte* g_constm,
				int* g_lock_asis, int* g_varnum_asis,  byte* g_asis,
				int* g_lock_new_const, int* g_varnum_new_const, byte* g_new_constm,
				int* sensor, int* g_const_sample);

#endif /* GSTM_KERNEL_H_ */
