#include "stm_common.h"


// name: constraint name
// ps: pointer to var+const's, const is represented as byte(coefficient of base 2^8) (255 -> 0 0 255, if var_size_max = 3)
// 65791 variables (0 ~ 65790)
// const 65790 = 65536 + 254 = 1 * (2^8)^2 + 0 * (2^8)^1 + 254  => (1 0 254) 3 byte elements.
// (0 1 0 254) if var_size_max = 4.
// num_s: number of var:char*
void gen_a_constraint(byte name, byte* ps, int num_const_var, int var_size_max)
{
/*
time_t seconds;
time(&seconds);
printf ("ctime:%d\n", ctime(&seconds));
srand((unsigned int) seconds);
*/
  ps[0] = name;

  int i,j,k;
  for(i=0;i < num_const_var;i++)
  {
    //int r = i;
    int r = rand(); //int r = 65791;// 1*2^8^2 + 254*2^8^0
    if(name=='B' && i==0) // test variable in conditional-prop
      r = (int)fmod(r, 2);

    //printf("gen_a_constraint w/ var:%c, %dth = %d\n", name, i, r); 
    byte* coeffs = (byte*)malloc(var_size_max * sizeof(byte));
    int2bytes(r, coeffs, var_size_max);


    /*
    for(j=0;j < var_size_max;j++)
      printf("  following coeffs[%d]:=%d\t", j, coeffs[j]);
    printf("\n");
    */


    for(j=0;j < var_size_max;j++)
      ps[1+ i*var_size_max + j] = coeffs[j];

    free(coeffs);
  }

  /*
  printf ("byte-stream: varsize:%d,\t num-const:%d\t", var_size_max, num_const_var);
  for(k=0;k<var_size_max * num_const_var + 1; k++)
    if(k==0) printf ("%c ", ps[k]);
    else printf ("%d ", ps[k]);

  printf ("\n");
  */

  return;
}

// ps is already allocated, this proc will fill it.
// ps is array of variable in integer form
void create_a_constraint(byte name, int* ps, int num_const_var, int var_size_max, byte* aconst_out)
{
  aconst_out[0] = name;

  int i,j;
  for(i=0;i<num_const_var;i++) {
    byte* input_bytes = (byte*) malloc(sizeof(byte) * var_size_max);
    int2bytes(ps[i], input_bytes, var_size_max);
    for(j=0;j<var_size_max;j++){
      aconst_out[1 + i * var_size_max + j] = input_bytes[j];
    }
  }
}

void create_constraint_stream1(int num_var, int var_const_max, int* num_const, byte** constnames, byte** constm)
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
      vars[k] = (int*)malloc(sizeof(int*) * num_const[i]);

      for(l=0;l<num_const[k];l++) {
        int num_celt = constname2numconstvar(constnames[k][l]);
        //printf("const[%d][%d] need %d integer vars\n", k,l,num_celt);
        vars[k][l] = (byte**)malloc(sizeof(int) * num_celt);
      }
    }
    else
      vars[k] = NULL;
  }

  // constm real data
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
        int new_len = constraint_length (constnames[l][m], var_const_max);
        byte* a_constraint = (byte*) malloc(new_len);
        int num_celt = constname2numconstvar(constnames[l][m]);
        create_a_constraint(constnames[l][m], vars[l][m], num_celt, var_const_max, a_constraint);
        memcpy(constm[l] + old_len, a_constraint, new_len);
        old_len += new_len;
      }
    }
  }
}

void create_constraint_stream2(int num_var, int var_const_max, int* num_const, byte** constnames, byte** constm)
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
 
 printf("1\n");
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
 printf("2\n");

  int*** vars = (int***)malloc(sizeof(int**) * num_var);
  for(k=0;k<num_var;k++) {
    if(0 < num_const[k]) {
      vars[k] = (int*)malloc(sizeof(int*) * num_const[i]);

      for(l=0;l<num_const[k];l++) {
        int num_celt = constname2numconstvar(constnames[k][l]);
        printf("const[%d][%d] need %d integer vars\n", k,l,num_celt);
        vars[k][l] = (byte**)malloc(sizeof(int) * num_celt);
      }
    }
    else
      vars[k] = NULL;
  }
 printf("3\n");

  // constm real data
  int v10[2] = {0,0};
  int v20[2] = {6,5}; int v21[2] = {4,3}; int v22[2] = {0,1};
  int v30[1] = {1};
  int v50[1] = {2};
  int v60[1] = {7};

 printf("3.1\n");
  size_t intsize = sizeof(int);
  memcpy(vars[1][0], v10, intsize*2);
 printf("3.2\n");
  memcpy(vars[2][0], v20, intsize*2); memcpy(vars[2][1], v21, intsize*2); memcpy(vars[2][2], v22, intsize*2);
 printf("3.3\n");
  memcpy(vars[3][0], v30, intsize*1);
 printf("3.4\n");
  memcpy(vars[5][0], v50, intsize*1);
  memcpy(vars[6][0], v60, intsize*1);
 printf("4\n");

  for(l=0;l<num_var;l++) {
    if(constnames[l] != NULL){
      int old_len = 0;
      for(m=0;m<num_const[l];m++) {
      //what 's output of this?
      //lsdkfja;dlkfjas;dlf
        int new_len = constraint_length (constnames[l][m], var_const_max);
        byte* a_constraint = (byte*) malloc(new_len);
        int num_celt = constname2numconstvar(constnames[l][m]);
        create_a_constraint(constnames[l][m], vars[l][m], num_celt, var_const_max, a_constraint);
        memcpy(constm[l] + old_len, a_constraint, new_len);
        old_len += new_len;
      }
    }
  }
 printf("5\n");
}

void create_random_constraint_stream(int n_var, int n_const, int var_max_size, 
                                     int* num_const, byte** constnames, byte** constm)
{

  int i, j, j1, k, l, o, m;

  // number of constraint on each var
  for(i=0;i<n_var;i++)
  {
    int r = rand();
    num_const[i] = (int)fmod((double) r, (double)n_const);
    //printf ("number of constraints for %dth var = %d\n", i, num_const[i]);
  }

  // pointer of array of bytes
  for(i=0;i<n_var;i++)
  {
    int num_c = num_const[i];
    byte* byteptr = (byte*) malloc (num_c * sizeof(byte));
    for(j=0;j<num_c;j++) {
      byteptr[j] = getRandomConstraintName();
      //printf ("constraint names:%c at var %d\n", byteptr[j], i);
    }
    
    constnames[i] = byteptr;
  }

  for(i = 0;i < n_var;i++)
  {

    //printf ("variable-%d, num-constraint-%d\n", i, num_const[i]);
    int var_strm_byte = 0;
    // print constraint length-in bytes
    for(j=0;j<num_const[i];j++)
    {
      // constraint name (uniform for now)
      byte cn = constnames[i][j];

      // number of variable in each constraint(variant)
      int num_const_var = constraint_length(cn, var_max_size);
  
      var_strm_byte += num_const_var;
    }

    constm[i] = (byte*) malloc (sizeof(byte) * var_strm_byte);
    int offset = 0;

    for(j=0;j<num_const[i];j++)
    {
      //conditional-prob 'B' b x y
      byte current_const = constnames[i][j];
      int num_ct = constname2numconstvar(current_const);
      if (num_ct == 0) {
        printf("In create-constraint stream, num_c=0 ---> exit\n");
        exit(1);
      }

      int num_cbyte = constraint_length(current_const, var_max_size);
      byte* ps = (byte*) malloc (sizeof(byte) * num_cbyte);
      gen_a_constraint(current_const, ps, num_ct, var_max_size);

      for(k=0;k<num_cbyte;k++)
      {
        constm[i][offset+k] = ps[k];
      }

      free(ps);

      offset += num_cbyte;
    }
  }

  return;
}

// ptr_consts -> l-var
// l-var[i] -> l-const-var
// l-const-var[j] -> variable_in_constraint
int main(int argc, char** argv)
{
  int i, j, j1, k0, k, l, o, m;
  const int NUM_CONST = 5;

  // space for containing each variable
  int var_max_size = 1; // b byte covers from 0 to 255 // 4 bytes covers from 0 to (2^8)^4-1.

  //const int NUM_VAR = 12;
  const int NUM_VAR = 8;
  // num_const[i] contains number of constraint in ith variable
  int* num_const = (int*) malloc (sizeof(int) * NUM_VAR); 
  // constraint names for each variables
  byte** constnames = (byte**) malloc (sizeof (byte*) * NUM_VAR);
  // sequence of byte stream.
  // each byte stream is a connected form of constraint in byte
  byte** in_constraints = (byte**) malloc (sizeof (byte*) * NUM_VAR); // 
  //create_constraint_stream1(NUM_VAR, var_max_size, num_const, constnames, in_constraints);
  create_constraint_stream2(NUM_VAR, var_max_size, num_const, constnames, in_constraints);
  //create_random_constraint_stream(NUM_VAR, NUM_CONST, var_max_size, num_const, constnames, in_constraints);

  SbaStream *ss_in = (SbaStream*)malloc(sizeof(SbaStream));
    ss_in->num_const = num_const;
    ss_in->constnames = constnames;
    ss_in->constm = in_constraints;
  //print_constraint_stream(NUM_VAR, var_max_size, ss_in);

  SbaStream *ss_out = SbaStream_init_empty(NUM_VAR);

  // input data: in_constraints
  // total number of variable: NUM_VAR
  // constnames: variable(char) -> numbers of constraints(int) -> sizes of constraints (bytes)
  // meta data: num_const(var->num of constraints)
  // output pointer - for new_analysis
  solver_constraint_wrapper(ss_in, NUM_VAR, var_max_size, ss_out);

  // free
  free(ss_in);
  free(ss_out);
  /*
  for(o=0;o<NUM_VAR;o++)
  {
    free(constnames[o]);
    free(in_constraints[o]);
  }
  free(constnames);
  free(in_constraints);
  */

  return 0;
}
