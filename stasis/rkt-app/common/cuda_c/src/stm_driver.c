#include <stm_common.h>

int var_size_valid(byte name, int th)
{
  int num_var = constname2numconstvar(name);
  if(th < num_var) return 1;
  else return NULL;
}

// const: pointer to a constraint [ name var1 var2 ...]
// th: order in sequence of variable
// var_const_max: bytes to represent the amount of variable name.
// 1) get name, 2) check range, 3) return ptr to the variable at th.(No conversion)
// output vpos: pointer to variable byte string or NULL
void get_varstr_inconst(byte* aconst, int th, int var_const_max, byte* vpos)
{
  byte constname = aconst[0];

  if(var_size_valid(constname, th)) {
    vpos = aconst + th * var_const_max + 1;
  }
  else {
    printf("Err: get_variable_inconst - th is bigg/equal to number of variable for given constraint. constname:%c, requested varidx:%d\n", constname, th);
    vpos = NULL;
  }
}

// output: variable value (as integer).
int get_variable_inconst(byte* aconst, int th, int var_const_max)
{
  print_a_constraint(aconst, var_const_max);

  // var_str: pointer to byte array where th'th variable sits
  byte* p_var_str = (byte*)malloc(sizeof(byte));

  get_varstr_inconst(aconst, th, var_const_max, p_var_str);
  printf("-1, var_str:%d at %dth\n", p_var_str[0], th);
  int* p_var_num = (int*)malloc (sizeof(int));
  bytes2int(p_var_str, p_var_num, var_const_max);
  printf("-2, *p_var_num = %d\n", *p_var_num);

  return *p_var_num;
}


void print_constraint_stream(int num_var, int var_const_max, SbaStream* ss)
{
  int* num_const = ss->num_const;
  byte** constnames = ss->constnames;
  byte** constm = ss->constm;

  if((num_const == NULL) || (constnames==NULL) || (constm==NULL)) {
    printf("A field in SbaStream is NULL\n");
    return;
  }

  int k, l, m;
  //print content. 
  for(k=0;k<num_var;k++)
  {
    printf("VAR[%d]-------------\n", k);
    int num_const_var = num_const[k];
    printf("\tnum_const[%d]: %d\n", k, num_const_var);
    byte* cname = constnames[k];

    int offset=0;
    for(l=0;l<num_const_var;l++)
    {
      printf("   ....>\n\tconstnames[%d][%d] : %c\n", k, l, cname[l]);
      printf("\tconstm[%d][%d]     : %c\n", k, l, constm[k][offset]);

      int const_length = constraint_length(cname[l], var_const_max);
      for(m=0;m<const_length;m++)
        if(m==0) printf("\t[%d] -> %c\t", constm[k][offset+m]);
        else printf("[%d] -> %d\t", constm[k][offset+m]);
 
      printf("\n");

      offset += const_length;
    }
    printf("\n");
  }
}

// output 0, if c is neither analysis name nor constraint name
// output 1, if either analysis name or constraint name
int is_const_name(byte c)
{
  int var_size = constname2numconstvar(c);
  if(0 == var_size) return 0;
  else return 1;
}

int is_constraintstream_empty(int num_var, int var_const_max, SbaStream* ss_const)
{
  int empty = 1; // set empty = TRUE.

  // check only num_const.
  int* num_const = ss_const->num_const;
  int j;
  for(j=0;j<num_var;j++) {
    if((num_const != NULL) && (num_const[j] != 0)) empty = 0; // empty==FALSE -> not empty
  }

  return empty;

  /*
  byte** constnames = ss_const->constnames;
  byte** constm = ss_const->constm;

  int k, l, m;
  //check content. 
  for(k=0;k<num_var;k++) {
    int offset = 0;
    int num_const_var = num_const[k];
    byte* cname = constnames[k];
    
    for(l=0;l<num_const_var;l++) {

      // is either analysis or constraint name, then empty = 0 (means not empty).
      if (is_const_name (constm[k][offset])) {
        empty = 0;
        return empty;
      }

      int const_length = constraint_length(cname[l], var_const_max);
      offset += const_length;
    }
  }

  // at this point, constraint is turned out to be empty.
  return empty;
  */
}


byte** init_from_constraint(int num_var, int* num_const, int var_const_max, byte value)
{
  // preparing for answer storage by taking biggest constraint with maximum number of constraints
  // for every variable. (sufficiently large area)
  int mx_const_byte = longest_constraint_byte(var_const_max);
  int mx_num_const = max_num_constraints(num_const, num_var);

  int k;
  byte** out_bytes = (byte**) malloc (sizeof(byte*) * num_var);
  for(k=0;k<num_var;k++) {
    int size_out = mx_const_byte * mx_num_const;
    out_bytes[k] = (byte*) malloc (sizeof (byte) * size_out);
    memset((void*)out_bytes[k], value, (size_t)size_out);
  }

  return out_bytes;
}

byte** init_from_constnames(int num_var, int* num_const, byte value)
{
  int mx_num_const = max_num_constraints(num_const, num_var);
  int k,l;
  byte** out_constnames = (byte**) malloc (sizeof (byte*) * num_var);
  for(k=0;k<num_var;k++) {
    out_constnames[k] = (byte*) malloc (sizeof(byte) * mx_num_const);
    memset((void*)out_constnames[k], value, (size_t)mx_num_const);
  }

/*
  for(k=0;k<num_var;k++)
  {
    printf("k=%d\n", k);
    for(l=0;l<mx_num_const;l++)
      printf("%c[%d]\t", out_constnames[k][l], l);
    printf("\n");
  }
  */
  return out_constnames;
}

int* copy_from_num_const(int num_var, int* num_const)
{
  int i;
  int* out_num_const = (int*)malloc(sizeof(int) * num_var);
  for(i=0;i<num_var;i++)
    out_num_const[i] = num_const[i];

  return out_num_const;
}

byte** copy_from_constnames(int num_var, int* num_const, byte** constnames)
{
  int i,j;
  byte** out_constnames = (byte**) malloc (sizeof(byte*) * num_var);
  for(i=0;i<num_var;i++) {
    out_constnames[i] = (byte*) malloc (sizeof(byte) * num_const[i]);
    for(j=0;j<num_const[i];j++)
      out_constnames[i][j] = constnames[i][j];
  }

  printf("copy_from_constnames:%d\n", out_constnames);
  return out_constnames;
}

byte** copy_from_constraint(int num_var, int* num_const, byte** constname, int var_const_max, byte** constm)
{
  int i,j,k;
  byte** out_bytes = (byte**) malloc (sizeof(byte*) * num_var);
  size_t* vconstm_size = (size_t) malloc (sizeof (size_t) * num_var);

  for(i=0;i<num_var;i++) {
    for(j=0;j<num_const[i];j++) 
      vconstm_size[i] += constraint_length(constname[i][j], var_const_max);
  }

  for(i=0;i<num_var;i++) {
    int constsize_byte = vconstm_size[i];

    byte* vconst_src = constm[i];
    byte* vconst_dst = (byte*) malloc (sizeof(byte) * constsize_byte);

    memcpy(vconst_dst, vconst_src, constsize_byte);
    printf ("copy_from constraint: first constname for each var:%c\n", vconst_dst[0]);

    out_bytes[i] = vconst_dst;
  }

  return out_bytes;
}


// var_const_byte: byte stream containing constraint with name in prefix
// num_var: total number of varialbes
// constnames: variable idx -> ptr for constraint names
// num_const: variable idx -> number of constraints
// out_analysis: solution stream
/*
void solver_constraint_wrapper(byte** in_constraints, 
                               int num_var, 
                               byte** constname, 
                               int* num_const, 
                               int var_const_max,
                               byte** out_analysis) {
			       */
void solver_constraint_wrapper(SbaStream* ss_in, 
                               int num_var,
			       int var_const_max,
			       SbaStream* ss_out_analysis) {

  byte** in_constraints = ss_in->constm;
  byte** constnames = ss_in->constnames;
  int* num_const = ss_in->num_const; // original constraint size  that affects all new allocation.

  // test core
  int grid;
  int threads;

/*
  printf("wrapper: numvar:%d\n", num_var);
  for(grid=0;grid < num_var;grid++) 
    for(threads=0;threads < num_const[grid];threads++)
    {
      printf("var:%d, thread:%d\n", grid, threads);
    }
*/

  SbaStream *ss_out_constraints = SbaStream_init_empty(num_var);

  //init_constraints_kernel<<grid, threads>>();
  for(grid=0;grid < num_var;grid++) 
    for(threads=0;threads < num_const[grid];threads++) {
      init_constraints_kernel(ss_in, num_var, var_const_max, ss_out_constraints, ss_out_analysis, grid, threads);
    }


  //printf("-------original const---------\n");
  //print_constraint_stream(num_var, var_const_max, ss_in);

  //printf("-------reflection---------\n");
  int* ref_num_const = copy_from_num_const(num_var, ss_out_constraints->num_const);
  byte** ref_constnames = copy_from_constnames(num_var, ss_out_constraints->num_const, 
                                                        ss_out_constraints->constnames);
  byte** ref_constm = copy_from_constraint(num_var, ss_out_constraints->num_const, 
                      ss_out_constraints->constnames, var_const_max, ss_out_constraints->constm);

  SbaStream *ss_reflection = (SbaStream*)malloc(sizeof(SbaStream));
    ss_reflection->num_const = ref_num_const;
    ss_reflection->constnames = ref_constnames;
    ss_reflection->constm = ref_constm;
  //print_constraint_stream(num_var, var_const_max, ss_reflection);

  printf("-------pure const---------\n");
  print_constraint_stream(num_var, var_const_max, ss_out_constraints);

  printf("-------analysis---------\n");
  print_constraint_stream(num_var, var_const_max, ss_out_analysis); 

  // check if constraint stream is empty.
  int empty_const = is_constraintstream_empty(num_var, var_const_max, ss_out_constraints);
  printf("constraint is empty? %d\n", empty_const);



  int while_iter_count = 0;

  while(!empty_const) 
  {
    SbaStream *ss_out_new_constraints = SbaStream_init_empty(num_var);

    int i;
    byte* access_lock = (byte*) malloc (sizeof (byte) * num_var);
    for(i=0;i<num_var;i++) {
      access_lock[i] = '\0'; // lock deactivated -> okey to update.
                             // lock activated if '\1'
      //printf("lock[%d] = %c\n", i, access_lock[i]);
    }

    printf("p_ss_out_constraints:%d\n", ss_out_constraints);
    printf("p_ss_out_new_constraints:%d\n", ss_out_new_constraints);
    print_constraint_stream(num_var, var_const_max, ss_out_constraints);
    // init_constraints_kernel<<grid, threads>>();
    for(grid=0;grid < num_var;grid++) {
      printf("-------------------------------------------\nVarNO:%d, NUMber of constraint:%d, w/ thread:%d\n", 
             grid, num_const[grid], threads);
      for(threads=0;threads < num_const[grid];threads++) {
        solve_constraints_kernel(ss_reflection, ss_out_constraints, num_var, access_lock, 
	                         ss_out_new_constraints, ss_out_analysis, grid, threads, 
				 var_const_max, &empty_const);
      }
    }
    printf("solve_constraints_kernel done see new_constraint:\n");
    print_constraint_stream(num_var, var_const_max, ss_out_new_constraints);

    ss_out_constraints = ss_out_new_constraints;

    while_iter_count++;
    empty_const = is_constraintstream_empty(num_var, var_const_max, ss_out_constraints);
    printf("constraint is empty? or not? %d -> check below:\n", empty_const);
    print_constraint_stream(num_var, var_const_max, ss_out_constraints);
  }

  printf("While loop ended:%d\n", empty_const);


/*
  printf("\nreflection printing\n");
  print_constraint_stream(num_var, var_const_max, ss_reflection); 
  */
  printf("\nout_constraint printing\n");
  print_constraint_stream(num_var, var_const_max, ss_out_constraints);
  /*
  printf("\nout_analysis printing\n");
  print_constraint_stream(num_var, var_const_max, ss_out_analysis); 
  */
  printf ("Total iteration of kernel:%d\n", while_iter_count);
}

SbaStream* SbaStream_init_empty(int num_var)
{
  SbaStream *ss = (SbaStream*)malloc(sizeof(SbaStream));
  ss->num_const = (int*)malloc(sizeof(int) * num_var);
  ss->constnames = (byte**)malloc(sizeof(byte*) * num_var);
  ss->constm = (byte**)malloc(sizeof(byte*) * num_var);

  int i;
  for(i=0;i<num_var;i++) {
    ss->num_const[i] = 0;
    ss->constnames[i] = NULL;
    ss->constm[i] = NULL;
  }

  return ss;
}
