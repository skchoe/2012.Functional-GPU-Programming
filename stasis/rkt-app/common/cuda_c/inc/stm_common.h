#include<stdio.h>
#include<stdlib.h>
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
void print_var_constraints (byte** ptr, int num_const);
void print_all_constraints(int n_var, int* num_const, byte*** ptr_consts);

//(e0 e1 e2 ... ek-1) -> "e0e1...ek-1", k=num_elt
// where ej = "ch0 ... chj" num_char is num of byte in ej.
byte* streamizer (byte* ptr, int num_char, int num_elt);
void int2pchar(int inv, byte* outp);
byte* array_num_const_to_string(int* arr_nconst, int num_nconst, int num_byte, byte* pnconst);

void fill_char(int numchar, byte* poschar, char c);
void int2bytes(int x, byte* p, int varsize_max);

byte getRandomConstraintName();
int constname2numconstvar(byte c);
int longest_constraint_byte(int var_max_byte);
int constraint_length(byte c, int var_max_byte);
int max_num_constraints(int* num_const, int size);

SbaStream* SbaStream_init_empty(int num_var);

// stm_driver.c
void solver_constraint_wrapper(SbaStream* ss_in, 
                               int num_var,
			       int var_max_size,
			       SbaStream* ss_out_analysis);

