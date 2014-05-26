#ifndef _STM_COMMON_H_
#define _STM_COMMON_H_

extern "C"
{


#include <stdlib.h>

typedef unsigned char byte;
typedef unsigned long long ullong;

// gstm_common.cu
// var -> numconst, constnames, bytestream
typedef struct SbaStream
{
  int* num_const;
  byte** constnames;
  byte** constm;
} SbaStream;


typedef enum InitStruct {
	STM = 1,
	CSR
} InitStruct;

typedef enum GpuFlag {
	CPU = 0,
	GPU
} GpuFlag;

// given num_var, used to define number of bytes (as power of 2)
unsigned int size2store(float x);
unsigned int least_upper_binary(float x);


// ptr of array of constraint, num_constraint of the var.
void print_var_constraints (byte** ptr, int num_const);
void print_all_var_constraints(int n_var, int* num_const, byte*** ptr_consts);
void print_a_constraint(byte* aconst, size_t var_const_max, int is_uniform_var_width);
void print_constraint_stream(int num_var, size_t var_const_max, SbaStream* ss,
		int is_uniform_var_width, int is_equal_const_size, int jump);
void print_constraints_csr(int num_var, int num_tot_const, size_t var_const_max,
		int* ptr, int* indices, byte* data, size_t sz_a_const,
		int is_uniform_var_width, int is_equal_const_size, int jump);
void print_constraints_gpu(int num_var, size_t sz_a_const,
		int* num_const, byte* constm, int is_uniform_var_width);

void bytes2int(byte* p, int* x, size_t varsize_max);

//(e0 e1 e2 ... ek-1) -> "e0e1...ek-1", k=num_elt
// where ej = "ch0 ... chj" num_char is num of byte in ej.
byte* streamizer (byte* ptr, int num_char, int num_elt);
void int2pchar(int inv, byte* outp);
void array_num_const_to_string(int* arr_nconst, int num_nconst, int num_byte, byte* pnconst);

void fill_char(int numchar, byte* poschar, char c);
void int2bytes(int x, byte* p, size_t varsize_max);

byte getRandomConstraintName();
int constname2numconstvar(byte c);
int longest_constraint_byte(size_t var_max_byte, int is_uniform_var_width);
size_t constraint_length(byte c, int var_max_byte, int is_uniform_var_width);
int max_num_constraints(int size, int* num_const);

// stm_driver.c
void get_varstr_inconst(byte* aconst, int th, size_t var_const_max, byte* vpos, int is_uniform_var_width);
int get_variable_inconst(byte* aconst, int th, size_t var_const_max, int is_uniform_var_width);
int warning_for_non_csr(int is_uniform_var_width, int is_equal_const_size);

void sba_solve_stm(SbaStream* ss_in, int num_var, size_t var_const_max, SbaStream* ss_out_analysis,
		int is_uniform_var_width, int is_equal_const_size);
void sba_solve_csr(SbaStream* ss_in, int num_var, size_t var_const_max, SbaStream* ss_out_analysis,
		int is_uniform_var_width, int is_equal_const_size);


// stm_kernel.c
size_t sum_const_sizes(byte* pcnames, int len, size_t var_const_max);


SbaStream* SbaStream_init_empty(int num_var);


// return pointer to array of x y z.
//int* max_grid();
//int max_thread();
// stm_driver.c
void solver_constraint_wrapper_gpu(SbaStream* ss_in, int num_var, size_t var_max_size,
		SbaStream* ss_out, InitStruct ds, int is_uniform_var_width, int is_equal_const_size);

} // end of extern "C"

#endif
