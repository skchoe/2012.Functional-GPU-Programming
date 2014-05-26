#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>
#include <driver_types.h>

#include <stdio.h>

#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <malloc.h>

#include <gstm_common.h>


void print_a_constraint(byte* aconst, size_t var_const_max, int is_uniform_var_width)
{
	size_t offset;
	if(is_uniform_var_width == 0)
		offset = 1; // 1 byte for constraint name
	else
		offset = var_const_max;

	unsigned int num_var_inconst  = constname2numconstvar(aconst[0]);
	unsigned int i,j;
	printf("%d variables in \tAConst %c\n", num_var_inconst, aconst[0]);
	for(i=0;i<num_var_inconst;i++) {
		for(j=0;j<var_const_max;j++) {
			printf("\t%d", aconst[offset + i*var_const_max + j]);
		}
		printf("\n");
	}
}


// ptr of array of constraint, num_constraint of the var.
void print_var_constraints (byte** ptr, int num_const)
{
	int j;
	for (j = 0 ; j < num_const ; j++)
		printf ("%d -> %p, with first letter:%c\n", j, ptr[j], ptr[j][0]);

	return;
}

void print_all_constraints(int n_var, int* num_const, byte*** ptr_consts)
{
	int i;
	for(i = 0; i < n_var ; i++) // for each variable,
		print_var_constraints(ptr_consts[i], num_const[i]);

	return;
}

void print_num_const(int num_var, int* num_const)
{
	int i;
	for(i=0;i<num_var;i++)
		printf("%d th var has %d constraints\n", i, num_const[i]);
}

void print_constraint_stream(int num_var, size_t var_const_max, SbaStream* ss, int is_uniform_var_width, int is_equal_const_size, int jump)
{
  printf("1\n");

  int* num_const = ss->num_const;
  byte** constnames = ss->constnames;
  byte** constm = ss->constm;
  printf("2\n");

  if((num_const == NULL) || (constnames==NULL) || (constm==NULL)) {
    printf("A field in SbaStream is NULL\n");
    return;
  }
  printf("3\n");

  int k, l;
  //print content.
  for(k=0;k<num_var;k += jump)
  {
	  byte* pstm = constm[k];
    int num_const_var = num_const[k];
    byte* cname = constnames[k];

    printf("VAR[%d]-------------\n", k);
    printf("\tnum_const[%d]: %d\n", k, num_const_var);

    size_t const_offset=0;
    for(l=0;l<num_const_var;l++)
    {
      printf("   ....>\n\tconstnames[%d][%d] : %c\n", k, l, cname[l]);
      printf("\tconstm[%d][%d]     : %c\n", k, l, *(pstm+const_offset));

      size_t const_length = constraint_length(cname[l], var_const_max, is_uniform_var_width); // uniform-width
      unsigned int m;
      for(m=0;m<const_length;m++) // printing individual bytes
        if(m==0) printf("\t[%d] -> %c\t", k, constm[k][const_offset+m]);
        else printf("\t[%d] -> %d\t", k, constm[k][const_offset+m]);

      printf("\n");

      if(is_equal_const_size==0)
    	  const_offset += const_length;
      else
    	  const_offset += var_const_max * 4; // because 4 is max space in constraint for either c-name or variable.

    }
    printf("\n");
  }
}

void print_constraints_csr(int num_var, int num_tot_const, size_t var_const_max,
		int* ptr, int* indices, byte* data, size_t sz_a_const,
		int is_uniform_var_width, int is_equal_const_size, int jump) {

	int new_uniform_var_width = warning_for_non_csr(is_uniform_var_width, is_equal_const_size);
	if(new_uniform_var_width) is_uniform_var_width = 1;

	int i, const_offset = 0;
	for(i=0;i<num_tot_const;i+=jump) {
		printf("%d th const - variable:%d, \t", i, indices[i]);
		print_a_constraint((byte*)(data + const_offset), var_const_max, is_uniform_var_width);
		const_offset += sz_a_const * jump;
	}

	return;
}

void print_constraints_gpu(int num_var, size_t sz_a_const, int* num_const, byte* constm, int is_uniform_var_width)
{
	if(is_uniform_var_width == 0) {
		printf ("print_constraints_gpu only support uniform width in variables\n");
		exit(1);
	}
	size_t var_const_max = sz_a_const / 4;

	int i, j;
	for(i=0;i<num_var;i++) {
		for(j=0;j < num_const[i];j++) {
			size_t offset = (i + num_var * j) * sz_a_const;
			printf("var[%d] has %d constraints ->\n", i, num_const[i]);
			byte* const_pos = (byte*) (constm + offset);
			print_a_constraint(const_pos, var_const_max, is_uniform_var_width);
		}
	}

	return;
}


//(e0 e1 e2 ... ek-1) -> "e0e1...ek-1", k=num_elt
// where ej = "ch0 ... chj" num_char is num of char in ej.
byte* streamizer (byte* ptr, int num_char, int num_elt)
{
  return NULL;
}

void int2pchar(int inv, byte* outp)
{
  outp[0] = 0;
  outp[1] = 1;
  outp[2] = 'A';
  outp[3] = 'a';
  return;
}

unsigned int least_upper_binary(float x)
{
	return (unsigned int)pow(2, ceil(log10(x) / log10(2)));
}

unsigned int size2store(float x)
{
	unsigned int lub = least_upper_binary(x);
	float bits = log10(lub) / log10(2);
	float bytes = ceil(bits / 8); // 8 bits for a byte.

	return least_upper_binary(bytes);
}

void array_num_const_to_string(int* arr_nconst, int num_nconst, int num_byte, byte* pnconst)
{
  int i,j;
  for(i = 0; i < num_nconst ; i++) {
    int nconst = arr_nconst[i];
    byte* nconstbyte = (byte*)malloc(num_byte * sizeof(byte));
    int2pchar(nconst, nconstbyte);

    for(j = 0; j < num_byte; j++)
      pnconst[i * num_byte + j] = nconstbyte[j]; 

    free(nconstbyte);
  }
  return;
}

void fill_char(int numchar, byte* poschar, char c)
{
  int i;
  for(i=0;i<numchar;i++)
    poschar[i] = c;

  return;
}


void int2bytes(int x, byte* p, size_t varsize_max)
{
  int i;
  int new_x = x;
  int div = pow(2,8);
  for(i=varsize_max-1;i>=0;i--)
  {
    int quo = new_x / div;
    p[i] = (byte)(new_x - div * quo);
    new_x = quo;
    //printf("%d div:%d, quo:%d, new_x:%d -> [%d] = %d\n", x, div, quo, new_x, i, p[i]);
  }
}

// p is input pointer to sequence of byte, as long as varsize_max
void bytes2int(byte* p, int* x, size_t varsize_max)
{
  int i;
  int bs = pow(2,8); // byte is a unit
  int ans = 0;
  for(i=0;i<varsize_max;i++) {
    ans += p[i] * pow(bs, varsize_max -1 - i);
  }

  *x = ans;
  return;
}


byte getRandomConstraintName()
{
  const int NUM_CONST = 9;
  byte b[] = {'v', 'b', 'c', 'l', 'P', 'C', 'D', 'B', 'A'};

  int r = rand();
  int c = (int)fmod((double) r, (double) NUM_CONST);
  return b[c];
}

int constname2numconstvar(byte c)
{ 
  switch (c)
  {
    case 'v': return 1;
    case 'b': return 1;
    case 'c': return 2;
    case 'l': return 2;
    case 'P': return 1;
    case 'C': return 1;
    case 'D': return 1;
    case 'B': return 3;
    case 'A': return 2;
    default : return 0;
  }
}

int longest_constraint_byte(size_t var_max_byte, int is_uniform_var_width)
{
	int num_var_long = constname2numconstvar('B');
	if(is_uniform_var_width == 0)
		return 1 + num_var_long * var_max_byte;
	else
		return (num_var_long + 1) * var_max_byte;
}

// output : byte of all element in constraint including name (initial byte)
size_t constraint_length(byte c, int var_max_byte, int is_uniform_var_width)
{
  int numconstvar = constname2numconstvar(c);
  if (numconstvar == 0) {
    printf("In constraint length, charinput(%c), numconstvar=0 ----->exit\n", c);
    exit(1);
  }
  if(is_uniform_var_width == 0) { //variable width between name and var parts
	  int var_part = var_max_byte * numconstvar;
  	  return sizeof(byte) + var_part;
  }
  else // name, vars are on same width of space
	  return var_max_byte * (1 + numconstvar);
}

int max_num_constraints(int size, int* num_const)
{
  int mx = num_const[0];
  int i;
  for(i=1;i< size;i++) {
    if(mx < num_const[i]) mx = num_const[i];
  }
  return mx;
}


/*
// return pointer to array of x y z.
int* max_grid()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.maxGridSize;
}

int max_thread()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, 0); // 0=dev single device
	return deviceProp.maxThreadsPerBlock;
}
*/

//} // end of extern "C"

