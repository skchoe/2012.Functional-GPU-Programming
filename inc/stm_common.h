
#ifndef _STM_COMMON_H_
#define _STM_COMMON_H_

extern "C"
{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<strings.h>
#include<math.h>
#include<time.h>
#include<malloc.h>

typedef unsigned char byte;

// stm_common.c
// var -> numconst, constnames, bytestream
typedef struct SbaStream
{
  int* num_const;
  byte** constnames;
  byte** constm;
} SbaStream;

// ptr of array of constraint, num_constraint of the var.
void print_var_constraints (byte** ptr, int num_const, size_t var_const_max);
void print_all_constraints(int n_var, int* num_const, byte*** ptr_consts, size_t var_const_max);
void print_a_constraint(byte* aconst, int var_const_max);

//(e0 e1 e2 ... ek-1) -> "e0e1...ek-1", k=num_elt
// where ej = "ch0 ... chj" num_char is num of byte in ej.
byte* streamizer (byte* ptr, int num_char, int num_elt);
void int2pchar(int inv, byte* outp);
// p is input pointer to sequence of byte, as long as varsize_max
void bytes2int(byte* p, int* x, int varsize_max);

void array_num_const_to_string(int* arr_nconst, int num_nconst, int num_byte, byte* pnconst);

void fill_char(int numchar, byte* poschar, char c);
void int2bytes(int x, byte* p, int varsize_max);

byte getRandomConstraintName();
int constname2numconstvar(byte c);
int longest_constraint_byte(int var_max_byte);
int constraint_length(byte c, int var_max_byte,
		int uniform_width,
		int equal_length);
int max_num_constraints(int* num_const, int size);

// stm_driver.c
SbaStream* SbaStream_init_empty(int num_var);

int get_variable_inconst(byte* aconst, int th, int var_const_max);


// const: pointer to a constraint [ name var1 var2 ...]
// th: order in sequence of variable
// var_const_max: bytes to represent the amount of variable name.
// 1) get name, 2) check range, 3) return ptr to the variable at th.(No conversion)
// output vpos: pointer to variable byte string or NULL
void get_varstr_inconst(byte* aconst, int th, int var_const_max, byte* vpos);

// stm_driver.c
void solver_constraint_wrapper(
		SbaStream* ss_in,
		int num_var,
		int var_max_size,
		SbaStream* ss_out_analysis,
		int uniform_width,
		int equal_length);

// stm_kernel.c
void init_constraints_kernel(SbaStream* ss_in_constraints,
                             int num_var,
                             int var_const_max,
                             SbaStream* ss_out_constraints,
                             SbaStream* ss_out_analysis,
                             int var_no,
                             int const_no,
                             int uniform_width,
                             int equal_length);

void solve_constraints_kernel(SbaStream* ss_reflection,
                              SbaStream* ss_in_constraints,
                              int num_var,
                              byte* access_lock,
                              SbaStream* ss_out_constraints,
                              SbaStream* ss_out_analysis,
                              int grid,
                              int thread,
                              int var_const_max,
                              int* empty_const,
                              int uniform_width,
                              int equal_length);

size_t sum_const_sizes(byte* pcnames, int len, int var_const_max,
	    int uniform_width,
	    int equal_length);

} // end of extern "C"
#endif
