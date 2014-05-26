#include<stdio.h>
#include<stdlib.h>
#include<strings.h>
#include<math.h>
#include<time.h>
#include <stm_common.h>

void print_a_constraint(byte* aconst, int var_const_max)
{
  int num_var_inconst  = constname2numconstvar(aconst[0]);
  int i,j;
  printf("\tAConst %c\n", aconst[0]);
  for(i=0;i<num_var_inconst;i++) {
    for(j=0;j<var_const_max;j++) {
      printf("\t%d", aconst[1 + i*var_const_max + j]);
    }
    printf("\n");
  }
}
// ptr of array of constraint, num_constraint of the var.
void print_var_constraints (byte** ptr, int num_const)
{
  int j;
  for (j = 0 ; j < num_const ; j++)
    printf ("%d -> %d, with first letter:%c\n", j, (int)(ptr[j]), ptr[j][0]);

  return;
}

void print_all_constraints(int n_var, int* num_const, byte*** ptr_consts)
{
  int i, j;
  for(i = 0; i < n_var ; i++) // for each variable,
    print_var_constraints(ptr_consts[i], num_const[i]);

  return;
}

//(e0 e1 e2 ... ek-1) -> "e0e1...ek-1", k=num_elt
// where ej = "ch0 ... chj" num_char is num of char in ej.
byte* streamizer (byte* ptr, int num_char, int num_elt)
{
  byte* stm;
  return stm;
}

void int2pchar(int inv, byte* outp)
{
  outp[0] = 0;
  outp[1] = 1;
  outp[2] = 'A';
  outp[3] = 'a';
  return;
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


void int2bytes(int x, byte* p, int varsize_max)
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
void bytes2int(byte* p, int* x, int varsize_max)
{
  int i;
  int bs = pow(2,8);
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

int longest_constraint_byte(int var_max_byte)
{
  return 1 + constname2numconstvar('B') * var_max_byte; 
}

// output : byte of all element in constraint including name (initial byte)
int constraint_length(byte c, int var_max_byte)
{

  int numconstvar = constname2numconstvar(c);
  if (numconstvar == 0) {
    printf("In constraint length, charinput(%c), numconstvar=0 ----->exit\n", c);
    exit(1);
  }
  int var_part = var_max_byte * numconstvar;

  return sizeof(byte) + var_part;
}

int max_num_constraints(int* num_const, int size)
{
  int mx = num_const[0];
  int i, elt;
  for(i=1;i< size;i++) {
    if(mx < num_const[i]) mx = num_const[i];
  }
  return mx;
}
