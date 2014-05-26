
extern "C" {

#include <gstm_common.h>
#include <stdio.h>
#include <math.h>
#include <string.h>


// name: constraint name
// ps: pointer to var+const's, const is represented as byte(coefficient of base 2^8) (255 -> 0 0 255, if var_size_max = 3)
// 65791 variables (0 ~ 65790)
// const 65790 = 65536 + 254 = 1 * (2^8)^2 + 0 * (2^8)^1 + 254  => (1 0 254) 3 byte elements.
// (0 1 0 254) if var_size_max = 4.
// num_s: number of var:char*
void gen_a_constraint(int num_var, byte name, int num_const_var, size_t var_size_max, byte* ps, int is_uniform_var_width)
{
  ps[0] = name;

  size_t offset = (is_uniform_var_width)? var_size_max : 1;
//printf("gen_a_constraint = num_const_var:%d\n", num_const_var);
  int i, j;
  for(i=0;i < num_const_var;i++)
  {
    //int r = i;
    int r = rand(); //int r = 65791;// 1*2^8^2 + 254*2^8^0
    if(name=='B' && i==0) // test variable in conditional-prop
    	r = (int)fmod(r, (double)2);
    else
    	r = r % num_var;


//    printf("gen_a_constraint w/ var:%c, %dth = %d\n", name, i, r);
    byte* coeffs = (byte*)malloc(var_size_max * sizeof(byte));
    int2bytes(r, coeffs, var_size_max);



//    for(j=0;j < var_size_max;j++)
//      printf("given:%d,  following coeffs[%d]:=%d\t", r, j, coeffs[j]);
//    printf("\n");



    for(j=0;j < var_size_max;j++)
      ps[offset + i*var_size_max + j] = coeffs[j];

    free(coeffs);
  }

//  print_a_constraint(ps, var_size_max, is_uniform_var_width);


  return;
}

// ps is already allocated, this proc will fill it.
// ps is array of variable in integer form
void create_a_constraint(byte name, int* ps, int num_const_var, size_t var_size_max, byte* aconst_out, int is_uniform_var_width, int is_equal_const_size)
{
  aconst_out[0] = name;
  size_t offset = (is_uniform_var_width)? var_size_max : 1;

  int i,j;
  for(i=0;i<num_const_var;i++) {
    byte* input_bytes = (byte*) malloc(var_size_max);
    int2bytes(ps[i], input_bytes, var_size_max);
    for(j=0;j<var_size_max;j++){
      aconst_out[offset + i * var_size_max + j] = input_bytes[j];
    }
  }
}

void create_constraint_stream1(int num_var, size_t var_const_max,
		int* num_const, byte** constnames, byte** constm, int is_uniform_var_width, int is_equal_const_size)
{
  // num_const
  num_const[0] = 0;
  num_const[1] = 1;
  num_const[2] = 2;
  num_const[3] = 1;
  num_const[4] = 1;
  num_const[5] = 3;
  num_const[6] = 0;
  num_const[7] = 0;
  num_const[8] = 0;
  num_const[9] = 1;
  num_const[10] = 1;
  num_const[11] = 0;

  // constnames
  int i;
  for(i=0;i<num_var;i++)
    if(0 < num_const[i])
      constnames[i] = (byte*)malloc(sizeof(byte)*num_const[i]);

  constnames[0] = NULL;
  constnames[1][0] = 'c';
  constnames[2][0] = 'A'; constnames[2][1] = 'l';
  constnames[3][0] = 'v';
  constnames[4][0] = 'v';
  constnames[5][0] = 'B'; constnames[5][1] = 'B'; constnames[5][2] = 'b';
  constnames[6] = NULL;
  constnames[7] = NULL;
  constnames[8] = NULL;
  constnames[9][0] = 'v';
  constnames[10][0] = 'C';
  constnames[11] = NULL;

  // constm malloc
  int j,k,l,m;
  for(j=0;j<num_var;j++)
    if(0 < num_const[j]) {
      size_t sum_constbytes = sum_const_sizes(constnames[j], num_const[j], var_const_max);
      constm[j] = (byte*)malloc(sizeof(byte)*sum_constbytes);
    }

  int*** vars = (int***)malloc(sizeof(int**) * num_var);
  for(k=0;k<num_var;k++) {
    if(0 < num_const[k]) {
      vars[k] = (int**)malloc(sizeof(int*) * num_const[i]);

      for(l=0;l<num_const[k];l++) {
        int num_celt = constname2numconstvar(constnames[k][l]);
        //printf("const[%d][%d] need %d integer vars\n", k,l,num_celt);
        vars[k][l] = (int*)malloc(sizeof(int) * num_celt);
      }
    }
    else
      vars[k] = NULL;
  }

  // constm real data/usr/l
  int v10[2] = {0, 0};
  int v20[2] = {10, 9}; int v21[2] = {0, 1};
  int v30[1] = {1};
  int v40[1] = {2};
  int v50[3] = {0, 7, 8}; int v51[3] = {1, 6, 8}; int v52[1] = {0};
  int v90[1] = {2};
  int v100[1] = {11};

  size_t intsize = sizeof(int);
  memcpy(vars[1][0] , v10, intsize*2);
  memcpy(vars[2][0] , v20, intsize*2); memcpy(vars[2][1] , v21, intsize*2);
  memcpy(vars[3][0] , v30, intsize*1);
  memcpy(vars[4][0] , v40, intsize*1);
  memcpy(vars[5][0] , v50, intsize*3); memcpy(vars[5][1] , v51, intsize*3); memcpy(vars[5][2] , v52, intsize*1);
  memcpy(vars[9][0] , v90, intsize*1);
  memcpy(vars[10][0], v100, intsize*1);

  for(l=0;l<num_var;l++) {
    if(constnames[l] != NULL){
      int old_len = 0;
      for(m=0;m<num_const[l];m++) {
      //what 's output of this?
      //lsdkfja;dlkfjas;dlf
        size_t new_len = constraint_length (constnames[l][m], var_const_max, is_uniform_var_width);
        byte* a_constraint = (byte*) malloc(new_len);
        int num_celt = constname2numconstvar(constnames[l][m]);
        create_a_constraint(constnames[l][m], vars[l][m], num_celt, var_const_max, a_constraint, is_uniform_var_width, is_equal_const_size);
        memcpy(constm[l] + old_len, a_constraint, new_len);
        old_len += new_len;
      }
    }
  }
}

void create_constraint_stream2(int num_var, size_t var_const_max, int* num_const, byte** constnames, byte** constm, int is_uniform_var_width, int is_equal_const_size)
{
  // num_const
  num_const[0] = 0;
  num_const[1] = 1;
  num_const[2] = 3;
  num_const[3] = 1;
  num_const[4] = 0;
  num_const[5] = 1;
  num_const[6] = 1;
  num_const[7] = 0;

  // constnames
  int i;
  for(i=0;i<num_var;i++)
    if(0 < num_const[i])
      constnames[i] = (byte*)malloc(sizeof(byte)*num_const[i]);

  constnames[0] = NULL;
  constnames[1][0] = 'c';
  constnames[2][0] = 'A'; constnames[2][1] = 'A'; constnames[2][2] = 'l';
  constnames[3][0] = 'v';
  constnames[4] = NULL;
  constnames[5][0] = 'v';
  constnames[6][0] = 'C';
  constnames[7] = NULL;

  // constm malloc
  int j,k,l,m;
  for(j=0;j<num_var;j++)
    if(0 < num_const[j]) {
      size_t sum_constbytes = sum_const_sizes(constnames[j], num_const[j], var_const_max);
      constm[j] = (byte*)malloc(sizeof(byte)*sum_constbytes);
    }

  int*** vars = (int***)malloc(sizeof(int**) * num_var);
  for(k=0;k<num_var;k++) {
    if(0 < num_const[k]) {
      vars[k] = (int**)malloc(sizeof(int*) * num_const[i]);

      for(l=0;l<num_const[k];l++) {
        int num_celt = constname2numconstvar(constnames[k][l]);
        //printf("const[%d][%d] need %d integer vars\n", k,l,num_celt);
        vars[k][l] = (int*)malloc(sizeof(int) * num_celt);
      }
    }
    else
      vars[k] = NULL;
  }

  // constm real data
  int v10[2] = {0,0};
  int v20[2] = {6,5}; int v21[2] = {4,3}; int v22[2] = {0,1};
  int v30[1] = {1};
  int v50[1] = {2};
  int v60[1] = {7};

  size_t intsize = sizeof(int);
  memcpy(vars[1][0], v10, intsize*2);
  memcpy(vars[2][0], v20, intsize*2); memcpy(vars[2][1], v21, intsize*2); memcpy(vars[2][2], v22, intsize*2);
  memcpy(vars[3][0], v30, intsize*1);
  memcpy(vars[5][0], v50, intsize*1);
  memcpy(vars[6][0], v60, intsize*1);

  for(l=0;l<num_var;l++) {
    if(constnames[l] != NULL){
      int old_len = 0;
      for(m=0;m<num_const[l];m++) {
        //what 's output of this?
        size_t new_len = constraint_length (constnames[l][m], var_const_max, 1);
        byte* a_constraint = (byte*) malloc(new_len);
        int num_celt = constname2numconstvar(constnames[l][m]);
        create_a_constraint(constnames[l][m], vars[l][m], num_celt, var_const_max, a_constraint, is_uniform_var_width, is_equal_const_size);
        memcpy(constm[l] + old_len, a_constraint, new_len);
        old_len += new_len;
      }
    }
  }
}

void create_constraint_stream_if(int num_var, size_t var_const_max, int* num_const, byte** constnames, byte** constm, int is_uniform_var_width, int is_equal_const_size)
{
  // num_const
  num_const[0] = 3;
  num_const[1] = 1;
  num_const[2] = 0;
  num_const[3] = 1;
  num_const[4] = 3;
  num_const[5] = 0;
  num_const[6] = 0;
  num_const[7] = 0;

  // constnames
  int i;
  for(i=0;i<num_var;i++)
    if(0 < num_const[i])
      constnames[i] = (byte*) malloc(sizeof(byte)*num_const[i]);

  constnames[0][0] = 'B'; constnames[0][1] = 'B'; constnames[0][2] = 'v';
  constnames[1][0] = 'v';
  constnames[2] = NULL;
  constnames[3][0] = 'c';
  constnames[4][0] = 'A'; constnames[4][1] = 'A'; constnames[4][2] = 'l';
  constnames[5] = NULL;
  constnames[6] = NULL;
  constnames[7] = NULL;

  // constm malloc
  int j,k,l,m;
  for(j=0;j<num_var;j++)
    if(0 < num_const[j]) {
      size_t sum_constbytes = sum_const_sizes(constnames[j], num_const[j], var_const_max);
      constm[j] = (byte*) malloc(sizeof(byte)*sum_constbytes);
    }

  int*** vars = (int***) malloc(sizeof(int**) * num_var);
  for(k=0;k<num_var;k++) {
    if(0 < num_const[k]) {
      vars[k] = (int**) malloc(sizeof(int*) * num_const[i]);

      for(l=0;l<num_const[k];l++) {
        int num_celt = constname2numconstvar(constnames[k][l]);
        //printf("const[%d][%d] need %d integer vars\n", k,l,num_celt);
        vars[k][l] = (int*) malloc(sizeof(int) * num_celt);
      }
    }
    else
      vars[k] = NULL;
  }

  // constm real data
  int v00[3] = {0,6,7}; int v01[3] = {1,5,7}; int v02[1] = {0};
  int v10[1] = {1};
  int v30[2] = {2,2};
  int v40[2] = {6,1}; int v41[2] = {5,0}; int v42[2] = {2,3};

  size_t intsize = sizeof(int);
  memcpy(vars[0][0], v00, intsize*3); memcpy(vars[0][1], v01, intsize*3); memcpy(vars[0][2], v02, intsize*1);
  memcpy(vars[1][0], v10, intsize*1);
  memcpy(vars[3][0], v30, intsize*2);
  memcpy(vars[4][0], v40, intsize*2); memcpy(vars[4][1], v41, intsize*2); memcpy(vars[4][2], v42, intsize*2);

  for(l=0;l<num_var;l++) {
    if(constnames[l] != NULL){
      int old_len = 0;
      for(m=0;m<num_const[l];m++) {
      //what 's output of this?
        size_t new_len = constraint_length (constnames[l][m], var_const_max, 1);
        byte* a_constraint = (byte*) malloc(new_len);
        int num_celt = constname2numconstvar(constnames[l][m]);
        create_a_constraint(constnames[l][m], vars[l][m], num_celt, var_const_max, a_constraint, is_uniform_var_width, is_equal_const_size);
        memcpy(constm[l] + old_len, a_constraint, new_len);
        old_len += new_len;
      }
    }
  }
}


void create_random_constraint_stream(int n_var, int n_const, size_t var_max_size,
                                     int* num_const, byte** constnames, byte** constm,
                                     int is_uniform_var_width, int is_equal_const_size)
{
  int i, j;

  int tot_const = 0;

  // number of constraint on each var
  for(i=0;i<n_var;i++)
  {
    int r = rand();
    //num_const[i] = (int)fmod((double) r, (double)n_const);
    num_const[i] = r % (1 + n_const);
    //if(10 == i % 1000) printf ("number of constraints for %dth var = %d\n", i, num_const[i]);
  }

  // pointer of array of bytes
  for(i=0;i<n_var;i++)
  {
    int num_c = num_const[i];
    byte* byteptr = (byte*) malloc (num_c * sizeof(byte));
    for(j=0;j<num_c;j++) {
      byteptr[j] = getRandomConstraintName();
      //if(10 == i % 1000) printf ("constraint names:%c at var %d\n", byteptr[j], i);
    }

    constnames[i] = byteptr;
  }


  // constm
  for(i = 0;i < n_var;i++)
  {
    //printf ("variable-%d, num-constraint-%d\n", i, num_const[i]);

    // get length of stream for each variable
    size_t sz_var_all_const = 0; // sum of sizes of all constraints in var_i

//    printf("------------------------------------------------------\n");
//    printf("%d st variable with %d constraints\n", i, num_const[i]);
    for(j=0;j<num_const[i];j++) {
      // constraint name (uniform for now)
      byte cn = constnames[i][j];

      // number of variable in each constraint(variant)
      size_t sz_a_const;
      if(is_equal_const_size == 0)
    	  sz_a_const = constraint_length(cn, var_max_size, is_uniform_var_width);
      else
    	  sz_a_const = 4 * var_max_size;

      sz_var_all_const += sz_a_const;
    }

    //printf("%d the variable has %d byte in const\n", i, sz_var_all_const);


    constm[i] = (byte*) malloc (sz_var_all_const);
    int offset = 0;

    for(j=0;j<num_const[i];j++)
    {
      //conditional-prob 'B' b x y
      byte current_const = constnames[i][j];
      int num_ct = constname2numconstvar(current_const);
      if (num_ct == 0) {
        printf("In create-constraint stream, num_c=0 for const(name):%c---> exit\n", current_const);
        exit(1);
      }

      size_t sz_a_const;
      if(is_equal_const_size == 0)
    	  sz_a_const = constraint_length(current_const, var_max_size, is_uniform_var_width);
      else
    	  sz_a_const = 4 * var_max_size;

      byte* ps = (byte*) malloc (sz_a_const);
      memset(ps, NULL, sz_a_const);

      gen_a_constraint(n_var, current_const, num_ct, var_max_size, ps, is_uniform_var_width); // uniform width

//      if(j==0) {
//		  printf("\nsz_a_const:%d, i:%d, j:%d =>\t : ", sz_a_const,  i, j);
//		  int k;
//		  for(k=0;k<sz_a_const;k++) {
//			  if (k==0) printf("[%d]%c\t", k, ps[k]);
//			  else printf("[%d]%d\t", k, ps[k]);
//		  }
//		  printf("\n");
//      }

      memcpy(constm[i] + offset, ps, sz_a_const);
      tot_const++;

      free(ps);

      offset += sz_a_const;
    }

//    printf("constraint stream for %dth var:%s\n", i, constm[i]);
  }

  printf("const-gen-random, num_tot_const:%d\n", tot_const);

  return;
}


// var_const_byte: byte stream containing constraint with name in prefix
// num_var: total number of varialbes
// constnames: variable idx -> ptr for constraint names
// num_const: variable idx -> number of constraints
// out_analysis: solution stream
/*
void solver_constrainttype filter text_wrapper(byte** in_constraints,
                               int num_var,
                               byte** constname,
                               int* num_const,
                               size_t var_const_max,
                               byte** out_analysis) {
*/
void solver_constraint_wrapper_gpu(SbaStream* ss_in, int num_var, size_t var_const_max,
		SbaStream* ss_out_analysis, InitStruct ds, int is_uniform_var_width, int is_equal_const_size)
{
	switch(ds) {
	case 1://STM:
		printf("Wrapper -> STM solver\n");
		sba_solve_stm(ss_in, num_var, var_const_max, ss_out_analysis, is_uniform_var_width, is_equal_const_size);
		break;
	case 2://CSR:
		printf("Wrapper -> CSR solver\n");
		sba_solve_csr(ss_in, num_var, var_const_max, ss_out_analysis, is_uniform_var_width, is_equal_const_size);
		break;
	}

	return;
}
//
//int pow(int base, int exp)
//{
//	int ans = base;
//	int cnt = 1;
//	while(cnt==exp) {
//		ans = base * ans;
//		cnt++;
//	}
//
//	return ans;
//}

int main(int argc, char** argv)
{
	printf("XXXX");
	  int is_uniform_var_width = 1; // uniform width for name part in a constraint structure.
	  int is_equal_const_size = 1; // every constraints has same size= 4 * var_max_const(byte)

	  //const int NUM_CONST = 5;

	  // space for containing each variable
	  int exp0 = 3; // program of 8 variable will be generated.
	//  int exp0 = 14; // first integer over 10,000 - 11MB in global memory
	//  int exp0 = 20; // looks the maximum exponent of num_var - 716MB
	//  int exp0 = 15;  // 23 MB, 32768 num_var
	//  int exp0 = 18;	//179MB / num_var

	  //const int NUM_VAR = 12;
	  const int NUM_VAR = pow(2, exp0);
	  const int num_const_limit = (int) pow(2, 3); // per each variable

	  printf("Number of variable: %d\n", NUM_VAR);

	  size_t var_max_size = size2store(NUM_VAR); // b byte covers from 0 to 255 // 4 bytes covers from 0 to (2^8)^4-1.
	  // num_const[i] contains number of constraint in ith variable
	  int* num_const = (int*) malloc (sizeof(int) * NUM_VAR);
	  // constraint names for each variables
	  byte** constnames = (byte**) malloc (sizeof (byte*) * NUM_VAR);
	  // sequence of byte stream.
	  // each byte stream is a connected form of constraint in byte
	  byte** in_constraints = (byte**) malloc (sizeof (byte*) * NUM_VAR); //
	  //create_constraint_stream1(NUM_VAR, var_max_size, num_const, constnames, in_constraints, is_uniform_var_width, is_equal_const_size);
	  //create_constraint_stream2(NUM_VAR, var_max_size, num_const, constnames, in_constraints, is_uniform_var_width, is_equal_const_size);
	  //create_constraint_stream_if(NUM_VAR, var_max_size, num_const, constnames, in_constraints, is_uniform_var_width, is_equal_const_size);
	  create_random_constraint_stream(NUM_VAR, num_const_limit, var_max_size, num_const, constnames, in_constraints, is_uniform_var_width, is_equal_const_size);

	  SbaStream *ss_in = (SbaStream*)malloc(sizeof(SbaStream));
	    ss_in->num_const = num_const;
	    ss_in->constnames = constnames;
	    ss_in->constm = in_constraints;
	//  print_constraint_stream(NUM_VAR, var_max_size, ss_in, is_uniform_var_width, is_equal_const_size);

	  SbaStream *ss_out = SbaStream_init_empty(NUM_VAR);

	  // input data: in_constraints
	  // total number of variable: NUM_VAR
	  // constnames: variable(char) -> numbers of constraints(int) -> sizes of constraints (bytes)
	  // meta data: num_const(var->num of constraints)
	  // output pointer - for new_analysis

	  InitStruct ds = CSR;
	  solver_constraint_wrapper_gpu(ss_in, NUM_VAR, var_max_size, ss_out, ds, is_uniform_var_width, is_equal_const_size);

	  // free
	  free(ss_in);
	  free(ss_out);

	  return 0;
}

} // end of extern "C"