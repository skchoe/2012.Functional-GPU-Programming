#include <stm_common.h>


/*
//__device__ 
int constraint_length(char c)
{
}
*/

// var_no const_no -> Xth byte
int const_pos(byte** constm, int* num_const, int var_no, int const_no, int var_const_max)
{
  byte* vconstm = constm[var_no];
  int n_vconst = num_const[var_no];
  
  // find pointer of const_no th byte.
  int counter = 0;
  int csizebyte = 0;
  int offset = 0;

  byte* ptr = vconstm;
  for(counter=0;counter < n_vconst;counter++){
    //printf("const_pos - for: nvconst:%d, cnt:%d, const_no:%d\n", n_vconst, counter, const_no);
    if (counter == const_no) return offset;
    else{
      offset += constraint_length(*ptr, var_const_max);
      ptr += offset;
    }
  }

  // no valid constraint found
  printf ("No constraint found: get_stream_element fail because it couldn't find ptr-constraint at %d %d\n", 
    var_no, const_no);

  return -1;
}

// var_no, num_const, constnames -> Xth byte
int const_pos_available(byte** constm, int* num_const, byte** constnames, int var_no, int var_const_max)
{
  byte* vconstm = constm[var_no];
  int n_vconst = num_const[var_no];
  
  byte* vconstnames = constnames[var_no];

  int counter = 0;
  int offset = 0;

  byte* ptr = vconstm;
  for(counter=0;counter < n_vconst;counter++) {
    offset += constraint_length(*ptr, var_const_max);
    ptr += offset;
  }

  return offset;
}

byte* get_constraint_ptr(byte** constm, int var_no, int byte_offset)
{
  byte* vconst = constm[var_no];

  byte* cpos = vconst + byte_offset;
  return cpos;
}

// constraint strm, var_no, const_no -> a pointer to constraint stm
//__device__ 
byte* get_stream_element(byte** constm, int* num_const, int var_no, int const_no, int var_const_max)
{
  int offset = const_pos(constm, num_const, var_no, const_no, var_const_max);
  printf("Output of const_pos() :%d where %c is in\n", offset, constm[var_no][offset]);
  byte* ptr = get_constraint_ptr(constm, var_no, offset);

  return ptr;
}

int is_heap_constraint(byte cname)
{
  if (cname == 'v'|| cname == 'b' || cname == 'c' || cname == 'l') return 1;
  else return 0;
}

// ptr-to constraint names (a byte)
// number-constraints : integer
size_t sum_const_sizes(byte* pcnames, int len, int var_const_max) 
{
  int i;
  size_t acc_constsize_byte = 0;
  for(i=0;i<len;i++) {
    acc_constsize_byte += constraint_length (pcnames[i], var_const_max);
    printf("cum_const_Sizes: %dth, %c--->acc byte:%d\n", i, pcnames[i], acc_constsize_byte);
  }

  return acc_constsize_byte;
}

// elt is a pointer to new constraint [name][byte1] ... [byteN], where N=var_const_max
void ss_add_element(SbaStream* ss, int num_var, int var_no, int var_const_max, byte* elt)
{
  printf("-----------------------------------------ss_add_elt, varno:%d, constname:%c, p_ss:%d\n", var_no, elt[0], ss);
  print_a_constraint(elt, var_const_max);

  // range check of var_no in num_var variables
  if(num_var <= var_no)
  { 
    printf("varno:%d is larger than variable range [0, %d]---> exit\n", var_no, num_var-1);
    exit(1);
  }

  int i, j;

  // num_const
  int* a_num_const;
  size_t int_num_var = num_var * sizeof(int);
  a_num_const = (int*)malloc(int_num_var);
  for(i=0;i<num_var;i++) {
    if (i==var_no) a_num_const[i] = 1 + ss->num_const[i];
    else a_num_const[i] = ss->num_const[i];
  }

  size_t bytep_num_var = num_var * sizeof(byte*);

  printf("ss_add_element: num_const done\n");

  // constnames
  byte** a_constnames = (byte**)malloc(bytep_num_var);
  for(i=0;i<num_var;i++) {

    if(ss->constnames[i] != NULL){
      if(i!=var_no) {
        int num_const = ss->num_const[i];
        a_constnames[i] = (byte*)malloc(num_const * sizeof(byte));
        for(j=0;j<num_const;j++) a_constnames[i][j] = ss->constnames[i][j];
      }
      else{
        int num_const = ss->num_const[i] + 1;
        a_constnames[i] = (byte*)malloc(num_const * sizeof(byte));
        for(j=0;j<num_const-1;j++) a_constnames[i][j] = ss->constnames[i][j];
	a_constnames[i][num_const-1] = elt[0];
      }
    }
    else {
      if(i!=var_no) a_constnames[i] = NULL;
      else {
        a_constnames[var_no] = (byte*)malloc(sizeof(byte));
        a_constnames[var_no][0] = elt[0];
      }
    }
  }
  printf("ss_add_element: constnames done, for const %c\n", elt[0]);
/*
  for(i=0;i<num_var;i++)  {
    printf("numvar:%d, numconst[%d]:%d\n", num_var, i, a_num_const[i]);
    for(j=0;j<a_num_const[i];j++) {
      printf("ptr:%d,   var:%d, constraint:%d -> constname:%c\n", a_constnames, i, j, a_constnames[i][j]);
      printf("first constname in constm[%d][%d] = %c\n", i, j, ss->constnames[i][j]);
    }
  }
*/
  // constm
  size_t const_size = constraint_length(elt[0], var_const_max);
  
  byte** a_constm = (byte**)malloc(bytep_num_var);
  for(i=0;i<num_var;i++) {
    printf("var idx:%d, outof %d\n", i, num_var);
    if(ss->constm[i] != NULL) {
      size_t acc_constsize_byte = sum_const_sizes(ss->constnames[i], ss->num_const[i], var_const_max); 

      if(i!=var_no) {
        // just copy from ss->constm[i] -> a_constm[i]
        a_constm[i] = (byte*)malloc(acc_constsize_byte);
        memcpy(a_constm[i], ss->constm[i], acc_constsize_byte);
      }
      else {
        // copy ss->constm[var_no] U elt -> a_costm[var_no]
        a_constm[var_no] = (byte*)malloc(const_size + acc_constsize_byte);
        if(0 < acc_constsize_byte)
          memcpy(a_constm[var_no], ss->constm[var_no], acc_constsize_byte);

        memcpy(a_constm[var_no]+acc_constsize_byte, elt, const_size);
      }
    }
    else {
      if(i!=var_no)  a_constm[i] = NULL;
      else {
        a_constm[var_no] = (byte*)malloc(const_size);
	memcpy(a_constm[var_no], elt, const_size);
      }
    }
  }
  ss->num_const = a_num_const;
  ss->constnames = a_constnames;
  ss->constm = a_constm;

  printf("________________\n");
  print_constraint_stream(num_var, var_const_max, ss); 
  printf("ss_add_element are all done\n");
}

// input original constm, num_const: (var->num const), ??
// split constm into 2 pieces(output): new_constm, analysis
//__global__ 
/*
void init_constraints_kernel(byte** constm, 
                             int num_var, 
			     int var_const_max,
			     byte** constnames, 
                             int* num_const, 
			     byte** out_constm, 
			     byte** out_analysis, 
			     int var_no, 
			     int const_no)
*/
void init_constraints_kernel(SbaStream* ss_in_constraints, 
                             int num_var, 
			     int var_const_max,
			     SbaStream* ss_out_constraints,
			     SbaStream* ss_out_analysis,
			     int var_no,
			     int const_no)
{
/*
  // idx: index of which - variable
  // idy: order of constraints
  int var_no   = threadIdx.x;
  int const_no = threadIdx.y;
*/

  int* num_const    = ss_in_constraints->num_const;
  byte** constnames = ss_in_constraints->constnames;
  byte** constm     = ss_in_constraints->constm;
  //print_constraint_stream(num_var, var_const_max, ss_in_constraints);

  printf ("----------------------------------------------------------------------\n");

  // ptr-to current constraint
  byte* elt = get_stream_element(constm, num_const, var_no, const_no, var_const_max);


  int i;
  if(is_heap_constraint (elt[0])) { 
    printf ("----to heap: %c\n", elt[0]); 
    ss_add_element(ss_out_analysis, num_var, var_no, var_const_max, elt);
    //print_constraint_stream(num_var, var_const_max, ss_out_analysis); 
    //printf("ptraddr:%d\n", ss_out_analysis->constnames);
  }
  else { 
    printf ("----to const: %c\n", elt[0]); 
    ss_add_element(ss_out_constraints, num_var, var_no, var_const_max, elt);
    //print_constraint_stream(num_var, var_const_max, ss_out_constraints); 
    //printf("ptraddr:%d\n", ss_out_constraints->constnames);
  }

  //__synchthreads();
  return;
}


//__global__ 
/*
void solve_constraints_kernel(byte** reflection, 
                              byte** out_constraints, 
			      int num_var, 
			      byte* constnames, 
			      int* num_const, 
			      byte** out_new_constraints, 
			      byte** out_analysis, 
			      int grid, 
			      int threads, 
			      int var_const_max, 
			      int* empty_const)
			      */
void solve_constraints_kernel(SbaStream* ss_reflection,
                              SbaStream* ss_in_constraints, 
			      int num_var, 
			      byte* access_lock,
			      SbaStream* ss_out_constraints, 
			      SbaStream* ss_out_analysis, 
			      int grid, 
			      int threads, 
			      int var_const_max, 
			      int* empty_const)
{
  //int var_no = threadIdx.x;
  int var_no = grid;
  //int const_no = threadIdx.y;
  int const_no = threads;

  printf ("grid, thread: (%d, %d) w/ p_ss_in_constraints:%d, p_out_constraints:%d\n", 
          var_no, const_no, ss_in_constraints, ss_out_constraints);

  int* ref_num_const = ss_reflection->num_const;
  byte** ref_constnames = ss_reflection->constnames;
  byte** ref_constm = ss_reflection->constm;

  int* num_const = ss_in_constraints->num_const;
  byte** constnames = ss_in_constraints->constnames;
  byte** constm = ss_in_constraints->constm;
  printf("-----------------------constraint-stream: at var[%d], const[%d]\n", var_no, const_no);
  print_constraint_stream(num_var, var_const_max, ss_in_constraints);
  
  // 1. get a constraint from grid/thread
  // ptr-to current constraint
  //
  //printf("num_constraints[%d] = %d, first constname:%c\n", var_no, num_const[var_no], constnames[var_no][0]);
  if(num_const[var_no] <= const_no) {
    printf("constraint at (%d, %d) is null\n", grid, threads);
    return;// printf("constraint at (%d, %d) is null\n", grid, threads);
  }
  else
  {
    byte* cst = get_stream_element(constm, num_const, var_no, const_no, var_const_max);
    printf("constraint at (%d, %d) = %c\n", grid, threads, cst[0]);
    print_a_constraint(cst, var_const_max);

    // 2. for variable [grid], iterate analysis 
    int* num_any = ss_out_analysis->num_const;
    byte** anynames = ss_out_analysis->constnames;
    byte** anystm = ss_out_analysis->constm;
    
    printf("1, num_any[%d]:%d\n", var_no, num_any[var_no]);
    // get all analysis for var_no
    int any_no;
    for (any_no = 0 ; any_no < num_any[var_no] ; any_no++)
    {
      byte anyname = anynames[var_no][any_no];
      byte* any = get_stream_element(anystm, num_any, var_no, any_no, var_const_max);
      printf("analysis at (%d, %d) = %c\n", var_no, any_no, any[any_no]);
      print_a_constraint(any, var_const_max);

      printf("2, with cst:%c, any:%c\n", *cst, *any);
      // 3. interprete const(1) - cst, analysis(2) - any, produce either constraint or analysis
      if (*cst == 'P' && *any == 'v')
      {
        // add any to analysis at var_num from cst.
	int var_num = get_variable_inconst(cst, 0, var_const_max); // get 0th variable from cst
	print_constraint_stream(num_var, var_const_max, ss_out_analysis);
	printf("adding to analysis with P-v\n");
        ss_add_element(ss_out_analysis, num_var, var_num, var_const_max, any); // ss_out_analysis is updated
	printf("adding to analysis with P-v----the result\n");
	print_constraint_stream(num_var, var_const_max, ss_out_analysis);

	// propagation of new value to ss_out_constraints
	// each const \in ref_constm(var_num), put to constraint
	int k;
	int num_cst = ref_num_const[var_num];
	printf("num_cst:%d\n", num_cst);
	for(k = 0 ; k < num_cst ; k++) {
	  // const at var_no in reflection -> out_constraint at var_num
	  byte* ct = get_stream_element(ref_constm, ref_num_const, var_no, k, var_const_max);
	  print_a_constraint(ct, var_const_max);
	  printf("adding to constraint with P-v\n");
          ss_add_element(ss_out_constraints, num_var, var_num, var_const_max, ct);
	}
        //if(num_cst!=0) *empty_const = 1;
	//else *empty_const = 0;
      }

      else if (*cst == 'C' && *any == 'c')
      {
	// create new constraint `P[var_constm]
	byte* const_p = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max));
	const_p[0] = 'P';
        
	byte* v = (byte*)malloc(sizeof(byte) * var_const_max);
	get_varstr_inconst(cst, 0, var_const_max, v);
	printf("***C-c:%d\n", *v);
	memcpy(const_p+1, v, var_const_max);

	int var_num = get_variable_inconst(any, 0, var_const_max); // get 0th variable from cst
	printf("adding to constraint with C-c\n");
        ss_add_element(ss_out_constraints, num_var, var_num, var_const_max, const_p);
        //*empty_const = 0;
      }

      else if (*cst == 'D' && *any == 'c')
      {
	// create new constraint `P[var_constm]
	// cons_elt2 -> "propagate to any"
	byte* const_p = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max));
	const_p[0] = 'P';
        
	byte* v = (byte*)malloc(sizeof(byte) * var_const_max);
	get_varstr_inconst(cst, 1, var_const_max, v);
	printf("***D-c:%d\n", *v);
	memcpy(const_p+1, v, var_const_max);

	int var_num = get_variable_inconst(any, 0, var_const_max); // get 0th variable from cst
	printf("adding to constraint with D-c\n");
        ss_add_element(ss_out_constraints, num_var, var_num, var_const_max, const_p);
        //*empty_const = 0;
      }

      else if (*cst == 'A' && *any == 'l')
      {
        printf("interprete-constraint cst:A, any:l\n");
	print_a_constraint(cst, var_const_max);
	print_a_constraint(any, var_const_max);
        // creating const_p_t as "final-var" -> "propagate to result"
	byte* const_p_a = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max));
	const_p_a[0] = 'P';
	byte* vt = (byte*)malloc(sizeof(byte) * var_const_max);
	get_varstr_inconst(cst, 0, var_const_max, vt);
	
	printf("***A-l-t:%d\n", *vt);
	memcpy(const_p_a+1, vt, var_const_max);

        // creating const_p_t as "arg-var" -> "propagate to param"
	byte* const_p_c = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max));
	const_p_c[0] = 'P';
	byte* vf = (byte*)malloc(sizeof(byte) * var_const_max);
	get_varstr_inconst(any, 0, var_const_max, vf);
	printf("***A-l-f:%d\n", *vf);
	printf("0th var at Application-any:%d\n", *vf);
	memcpy(const_p_c + 1, vf, var_const_max);
        
	printf("XXXXXXXbefore adding cst for A-lXXXXXXXXXXXX\n");
	print_constraint_stream(num_var, var_const_max, ss_out_constraints);

	// put const_p_a at var_num_any
        int var_num_any = get_variable_inconst(any, 1, var_const_max);

	printf("Newly generated constraint at var_num_any:%d\n", var_num_any);
	print_a_constraint(const_p_a, var_const_max);
	printf("adding to constraint with A-l-1\n");
        ss_add_element(ss_out_constraints, num_var, var_num_any, var_const_max, const_p_a);

	printf("XXXXXXXafter adding cst for A-lXXXXXXXXXXXX\n");
	print_constraint_stream(num_var, var_const_max, ss_out_constraints);

	// put const_p_c at var_num_cst
	int var_num_cst = get_variable_inconst(cst, 1, var_const_max);

	printf("Newly generated constraint at var_num_cst:%d\n", var_num_cst);
	print_a_constraint(const_p_c, var_const_max);
	printf("adding to constraint with A-l-2\n");
        ss_add_element(ss_out_constraints, num_var, var_num_cst, var_const_max, const_p_c);


        //*empty_const = 0;
      }

      // Application and continuation  - not supported yet
      else if (*cst == 'A' && *any == 't')
      {
      }

      else if (*cst == 'B' && *any == 'v')
      {
        // creating const_f const_t as 'from' -> "propagate to 'to', respectively, with 'test'
        // test, value
//printf("1:%c\n", any[0]);
//int* testval = (int*)malloc(sizeof(int));
//bytes2int(cst+1, testval, var_const_max);
//printf("test value:%d\n", *testval);
//printf("11:%d, %d, %d, %d\n", any[1], any[2], any[3], any[4]);

        int var_value = get_variable_inconst(any, 0, var_const_max);
//printf("2\n");
        int var_test =  get_variable_inconst(cst, 0, var_const_max);

//printf("3\n");
        int var_from = get_variable_inconst(cst, 1, var_const_max);

//printf("cst:B, any:v, v-value:%d, v-test:%d, v-from:%d\n", var_value, var_test, var_from);
        byte* const_pt = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max));
//printf("4\n");
        const_pt[0] = 'P';
        byte* vt = (byte*)malloc(sizeof(byte));
        get_varstr_inconst(cst, 2, var_const_max, &vt);
	printf("***B-v:%d\n", *vt);
        memcpy(const_pt+1, vt, var_const_max);
//printf("5\n");
      
        // this logic is questionable. veryfy by example. 
        int b_null;
	if(var_value == 0) b_null = 1; 
	else b_null = 0;

        if(b_null == var_test){
	  printf("adding to constraint with B-v, at var:%d\n", var_from);
          ss_add_element(ss_out_constraints, num_var, var_from, var_const_max, const_pt);
          //*empty_const = 0;
	}
      }
      else 
      {
      }
      // 4. update either out_constraints or out_analysis
    }  
    printf("comparison for all analysis is done\n");
  //__synchthreads();
  }
  //
  return;
}
