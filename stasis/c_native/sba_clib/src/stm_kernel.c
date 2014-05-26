#include <stm_common.h>


// var_no const_no -> Xth byte
int const_pos(byte** constm, int* num_const, int var_no, int const_no, int var_const_max,
	    int uniform_width,
	    int equal_length)
{
  byte* vconstm = constm[var_no];
  int n_vconst = num_const[var_no];
  
  // find pointer of const_no th byte.
  int const_pos = 0;

  byte* p_const; // ptr to constraint name: byte

  int counter = 0;
  for(counter=0;counter < n_vconst;counter++) {
	p_const = &vconstm[const_pos];
	byte cname = p_const[var_const_max-1];
//    printf("const_pos - for: nvconst:%d, cnt:%d, const_no:%d, constname:%c\n",
//    		n_vconst, counter, const_no, cname);
    if (counter == const_no) return const_pos;
    else{
      const_pos += constraint_length(cname, var_const_max, uniform_width, equal_length);
    }
  }

  // no valid constraint found
  printf ("No constraint found: get_stream_element fail because it couldn't find ptr-constraint at %d %d\n", 
    var_no, const_no);

  return -1;
}

// var_no, num_const, constnames -> Xth byte
int const_pos_available(byte** constm, int* num_const, byte** constnames, int var_no, int var_const_max, int uniform_width, int equal_length)
{
  byte* vconstm = constm[var_no];
  int n_vconst = num_const[var_no];
  

  int counter = 0;
  int offset = 0;

  byte* ptr = & vconstm[var_const_max-1];
  for(counter=0;counter < n_vconst;counter++) {
    offset += constraint_length(*ptr, var_const_max, uniform_width, equal_length);
    ptr += offset;
  }

  return offset;
}

//output-> pointer to a constraint offset from the beginning of cosntm[var_no]
byte* get_constraint_ptr(byte** constm, int var_no, int byte_offset)
{
  byte* vconst = constm[var_no];

  byte* cpos = vconst + byte_offset;
  return cpos;
}

// constraint strm, var_no, const_no -> a pointer to constraint stm
//__device__ 
byte* get_stream_element(byte** constm, int* num_const, int var_no, int const_no, int var_const_max, int uniform_width, int equal_length)
{
  int offset = const_pos(constm, num_const, var_no, const_no, var_const_max, uniform_width, equal_length);
//  printf("Output of const_pos():%d where %c is in\n", offset, constm[var_no][offset]);
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
// output-> byte of sum of constraints pointed by pcnames.
size_t sum_const_sizes(byte* pcnames, int len, int var_const_max,
	    int uniform_width,
	    int equal_length)
{
  int i;
  size_t acc_constsize_byte = 0;
  for(i=0;i<len;i++) {
    acc_constsize_byte += constraint_length (pcnames[i], var_const_max, uniform_width, equal_length);
  }

  return acc_constsize_byte;
}

// elt is a pointer to new constraint [name][byte1] ... [byteN], where N=var_const_max
void ss_add_element(SbaStream* ss, int num_var, int var_no, int var_const_max, byte* elt,
	    int uniform_width,
	    int equal_length)
{
//  printf("-----------------------------------------ss_add_elt, varno:%d, constname:%c, p_ss:%d\n", var_no, elt[var_const_max-1], ss);
//  print_a_constraint(elt, var_const_max);

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

//  printf("ss_add_element: num_const done\n");

  // constnames
  byte** a_constnames = (byte**)malloc(bytep_num_var);
  for(i=0;i<num_var;i++) {

//	  printf("varidx:%d, ss_add_element: constnames starts, for const %c\n", i, elt[var_const_max-1]);
//	  printf("");

    if(ss->constnames[i] != NULL) {
      if(i!=var_no) {
        int num_const = ss->num_const[i];
        a_constnames[i] = (byte*)malloc(num_const * sizeof(byte));
        for(j=0;j<num_const;j++) a_constnames[i][j] = ss->constnames[i][j];
      }
      else {
        int num_const = ss->num_const[i] + 1; // newly adding a const.
        a_constnames[i] = (byte*)malloc(num_const * sizeof(byte));
        for(j=0;j<num_const-1;j++) a_constnames[i][j] = ss->constnames[i][j]; // byte copy
        a_constnames[i][num_const-1] = elt[var_const_max-1];
      }
    }
    else {
      if(i!=var_no) a_constnames[i] = NULL;
      else {
        a_constnames[var_no] = (byte*)malloc(sizeof(byte));
        a_constnames[var_no][0] = elt[var_const_max-1];
      }
    }
  }
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
  size_t const_size = constraint_length(elt[var_const_max-1], var_const_max, uniform_width, equal_length);
  
  byte** a_constm = (byte**)malloc(bytep_num_var);
  for(i=0;i<num_var;i++) {
    if(ss->constm[i] != NULL) {
      size_t acc_constsize_byte = sum_const_sizes(ss->constnames[i], ss->num_const[i], var_const_max, uniform_width, equal_length);

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

  //printf("________________\n");
  //print_constraint_stream(num_var, var_const_max, ss);
//  printf("ss_add_element are all done\n");
}

// input original constm, num_const: (var->num const), ??
// split constm into 2 pieces(output): new_constm, analysis
//__global__ 
void init_constraints_kernel(SbaStream* ss_in_constraints, 
                             int num_var, 
                             int var_const_max,
                             SbaStream* ss_out_constraints,
                             SbaStream* ss_out_analysis,
                             int var_no,
                             int const_no,
                             int uniform_width,
                             int equal_length)
{
/*
  // idx: index of which - variable
  // idy: order of constraints
  int var_no   = threadIdx.x;
  int const_no = threadIdx.y;
*/

  int* num_const    = ss_in_constraints->num_const;
  byte** constm     = ss_in_constraints->constm;

//  printf ("----------------------------------------------------------------------\n");
//
//  print_constraint_stream(num_var, var_const_max, ss_in_constraints, uniform_width, equal_length);
//
//  printf ("----------------------------------------------------------------------\n");

  // ptr-to current constraint
  byte* elt = get_stream_element(constm, num_const, var_no, const_no, var_const_max, uniform_width, equal_length);

  printf("constraint byte string(%d):%c\n", var_const_max, elt[0]);

  if(is_heap_constraint (elt[var_const_max-1])) {
    printf ("----to heap: %c\n", elt[var_const_max-1]);
    ss_add_element(ss_out_analysis, num_var, var_no, var_const_max, elt, uniform_width, equal_length);
    //print_constraint_stream(num_var, var_const_max, ss_out_analysis); 
    //printf("ptraddr:%d\n", ss_out_analysis->constnames);
  }
  else { 
    printf ("----to const: %c\n", elt[var_const_max-1]);
    ss_add_element(ss_out_constraints, num_var, var_no, var_const_max, elt, uniform_width, equal_length);
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
			      int thread,
			      int var_const_max, 
			      int* empty_const,
				    int uniform_width,
				    int equal_length)
{
  //int var_no = threadIdx.x;
  //int const_no = threadIdx.y;

  size_t width_const_name = var_const_max;

//  printf ("grid, thread: (%d, %d) w/ p_ss_in_constraints:%d, p_out_constraints:%d\n",
//          grid, thread, ss_in_constraints, ss_out_constraints);

  int* ref_num_const = ss_reflection->num_const;
  byte** ref_constm = ss_reflection->constm;

  int* num_const = ss_in_constraints->num_const;
  byte** constm = ss_in_constraints->constm;
//  printf("-----------------------constraint-stream: at var[%d], const[%d]\n", grid, thread);
//  print_constraint_stream(num_var, var_const_max, ss_out_constraints);
  
  // 1. get a constraint from grid/thread
  // ptr-to current constraint
  // printf("num_constraints[%d] = %d, first constname:%c\n", var_no, num_const[var_no], constnames[var_no][0]);
  if(num_const[grid] <= thread) {
    printf("constraint at (%d, %d) is null because num_const[%d]:%d\n", grid, thread, grid, num_const[grid]);
    return;// printf("constraint at (%d, %d) is null\n", grid, threads);
  }
  else
  {
    int var_no = grid;
    int const_no = thread;

    byte* cst = get_stream_element(constm, num_const, var_no, const_no, var_const_max, uniform_width, equal_length);
//    printf("constraint at (%d, %d) = %c\n", var_no, const_no, cst[width_const_name-1]);
//    print_a_constraint(cst, var_const_max);

    // 2. for variable [grid], iterate analysis 
    int* num_any = ss_out_analysis->num_const;

    byte** anystm = ss_out_analysis->constm;
    
//    printf("1, num_any[%d]:%d\n", var_no, num_any[var_no]);
    // get all analysis for var_no
    int any_no;
    for (any_no = 0 ; any_no < num_any[var_no] ; any_no++)
    {
      byte* any = get_stream_element(anystm, num_any, var_no, any_no, var_const_max, uniform_width, equal_length);
      byte any_nm = any[width_const_name-1];
      byte cst_nm = cst[width_const_name-1];

//      printf("analysis at (%d, %d) => \n", var_no, any_no);
//      print_a_constraint(any, var_const_max);


//      printf("2, with cst:%c, any:%c\n", cst_nm, any_nm);
      // 3. interprete const(1) - cst, analysis(2) - any, produce either constraint or analysis
      if (cst_nm == 'P' && (any_nm == 'v' || any_nm == 'c' || any_nm == 'l' || any_nm == 'b'))
      {
        // add any to analysis at var_num from cst.
        int var_num = get_variable_inconst(cst, 0, var_const_max); // get 0th variable from cst
//        printf("P-v pair:\n");
//        print_a_constraint(any, var_const_max);
//        printf(">>\n");
//        print_a_constraint(cst, var_const_max);
//        printf("--------------------------\nAnalysis update with P-v\n----val:%d-->pp2:%d-------------------\OLD:-\n", variableinany, var_num);
//        print_constraint_stream(num_var, var_const_max, ss_out_analysis);
        ss_add_element(ss_out_analysis, num_var, var_num, var_const_max, any, uniform_width, equal_length); // ss_out_analysis is updated
//        printf("New Analysis with P-v----the result\n");
//        print_constraint_stream(num_var, var_const_max, ss_out_analysis);

        // propagation of new value to ss_out_constraints
        // each const \in ref_constm(var_num), put to constraint
        int k;
        int num_cst = ref_num_const[var_num];
//        printf("var_num:%d, num_cst:%d\n", var_num, num_cst);
        for(k = 0 ; k < num_cst ; k++) {
          // const at var_no in reflection -> out_constraint at var_num
          byte* ct = get_stream_element(ref_constm, ref_num_const, var_num, k, var_const_max, uniform_width, equal_length);
//          print_a_constraint(ct, var_const_max);
//          printf("adding to constraint with P-v\n");
          ss_add_element(ss_out_constraints, num_var, var_num, var_const_max, ct, uniform_width, equal_length);
//          print_constraint_stream(num_var, var_const_max, ss_out_constraints);
        }
        //if(num_cst!=0) *empty_const = 1;
	    //else *empty_const = 0;
      }

      // (prop-car result) (y1 y2) =>y1 ->prop-to-> result: (new-const y1 (P result))
      else if (cst_nm == 'C' && any_nm == 'c')
      {
        // create new constraint `P[var_constm]
        byte* const_p = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max, uniform_width, equal_length));
        const_p[width_const_name-1] = 'P';
        
        byte* v = (byte*)malloc(sizeof(byte) * var_const_max);
        get_varstr_inconst(cst, 0, var_const_max, v);
//        printf("***C-c:%d\n", v[width_const_name-1]);
        memcpy(const_p+width_const_name, v, var_const_max);

        int var_num = get_variable_inconst(any, 0, var_const_max); // get 0th variable from cst
//        printf("adding to constraint with C-c\n");
        ss_add_element(ss_out_constraints, num_var, var_num, var_const_max, const_p, uniform_width, equal_length);
//        print_constraint_stream(num_var, var_const_max, ss_out_constraints);
        //*empty_const = 0;
      }

      else if (cst_nm == 'D' && any_nm == 'c')
      {
        // create new constraint `P[var_constm]
        // cons_elt2 -> "propagate to any"
        byte* const_p = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max, uniform_width, equal_length));
        const_p[width_const_name-1] = 'P';
        
        byte* v = (byte*)malloc(sizeof(byte) * var_const_max);
        get_varstr_inconst(cst, 0, var_const_max, v);
//        printf("***D-c:%d\n", v[width_const_name-1]);
        memcpy(const_p+width_const_name, v, var_const_max);

        int var_num = get_variable_inconst(any, 1, var_const_max); // get 1th variable from cst
//        printf("adding to constraint with D-c\n");
        ss_add_element(ss_out_constraints, num_var, var_num, var_const_max, const_p, uniform_width, equal_length);
        //*empty_const = 0;
      }

      else if (cst_nm == 'A' && any_nm == 'l')
      {
//        printf("interprete-constraint cst:A, any:l\n");
//        print_a_constraint(cst, var_const_max);
        print_a_constraint(any, var_const_max);

        // creating const_p_t as "final-var" -> "propagate to result"

        // 1.
        // put const_p_a at var_num_any
        int var_num_any = get_variable_inconst(any, 1, var_const_max);

        byte* const_p_a = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max, uniform_width, equal_length));
        const_p_a[width_const_name-1] = 'P';
        byte* vt = (byte*)malloc(sizeof(byte) * var_const_max);
        get_varstr_inconst(cst, 0, var_const_max, vt);
//        printf("***A-l-t:%d\n", vt[width_const_name-1]);
        memcpy(const_p_a+width_const_name, vt, var_const_max);

//        printf("Newly generated constraint at var_num_any:%d\n", var_num_any);
//        print_a_constraint(const_p_a, var_const_max);
//        printf("adding to constraint with A-l-1\n");
        ss_add_element(ss_out_constraints, num_var, var_num_any, var_const_max, const_p_a, uniform_width, equal_length);
//        print_constraint_stream(num_var, var_const_max, ss_out_constraints);

        // 2.
        // put const_p_c at var_num_cst
        int var_num_cst = get_variable_inconst(cst, 1, var_const_max);

        // creating const_p_t as "arg-var" -> "propagate to param"
        byte* const_p_c = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max, uniform_width, equal_length));
        const_p_c[width_const_name-1] = 'P';
        byte* vf = (byte*)malloc(sizeof(byte) * var_const_max);
        get_varstr_inconst(any, 0, var_const_max, vf);
//        printf("***A-l-f:%d\n", vf[width_const_name-1]);
        memcpy(const_p_c + width_const_name, vf, var_const_max);

//        printf("Newly generated constraint at var_num_cst:%d\n", var_num_cst);
//        print_a_constraint(const_p_c, var_const_max);
//        printf("adding to constraint with A-l-2\n");
        ss_add_element(ss_out_constraints, num_var, var_num_cst, var_const_max, const_p_c, uniform_width, equal_length);
//        print_constraint_stream(num_var, var_const_max, ss_out_constraints);

        //*empty_const = 0;
      }

      // Application and continuation  - not supported yet
      else if (cst_nm == 'A' && any_nm == 't')
      {
      }

      else if (cst_nm == 'B' && any_nm == 'v')
      {
        // creating const_f const_t as 'from' -> "propagate to 'to', respectively, with 'test'

        int var_value = get_variable_inconst(any, 0, var_const_max);
        int var_test =  get_variable_inconst(cst, 0, var_const_max);

        int var_from = get_variable_inconst(cst, 1, var_const_max);

//        print_a_constraint(cst, var_const_max);
//printf("cst:B, any:v, v-value:%d, v-test:%d, v-from:%d\n", var_value, var_test, var_from);
        byte* const_pt = (byte*)malloc(sizeof(byte) * constraint_length('P', var_const_max, uniform_width, equal_length));
        const_pt[width_const_name-1] = 'P';
        byte* vt = (byte*)malloc(sizeof(byte));
        get_varstr_inconst(cst, 2, var_const_max, vt);
//        printf("***B-v:%d\n", *vt);
        memcpy(const_pt+width_const_name, vt, var_const_max);
      
        // this logic is questionable. veryfy by example. 
        int b_null;
	    if(var_value == 0) b_null = 1;
	    else b_null = 0;

        if(b_null == var_test){
//	      printf("adding to constraint with B-v, at var:%d\n", var_from);
          ss_add_element(ss_out_constraints, num_var, var_from, var_const_max, const_pt, uniform_width, equal_length);
//          print_constraint_stream(num_var, var_const_max, ss_out_constraints);
          //*empty_const = 0;
	    }
      }
      else 
      {
        printf("No pair occurs for cst:%c, any:%c at var:%d th, const:%d th, any:%d th\n",
        		*cst, *any, var_no, const_no, any_no);
      }
      // 4. update either out_constraints or out_analysis
    }  
    printf("comparison for all analysis is done\n");
  //__synchthreads();
  }
  //
  return;
}
