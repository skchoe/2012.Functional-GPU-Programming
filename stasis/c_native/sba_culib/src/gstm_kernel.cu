#include <stdio.h>
#include <gstm_common.h>

const int SYS_MAX_A_CONST = 16; //system define maximum byte of a constraint. (variable's max cap is 4 byte)


// ptr-to constraint names (a byte)
// number-constraints : integer
extern "C" size_t sum_const_sizes(byte* pcnames, int len, size_t var_const_max)
{
  int i;
  size_t acc_constsize_byte = 0;
  for(i=0;i<len;i++) {
    //printf("sum_size(%d) = %d\n", i, acc_constsize_byte);
    acc_constsize_byte += constraint_length (pcnames[i], var_const_max, 1);
  }

  return acc_constsize_byte;
}

// elt is a pointer to new constraint [name][byte1] ... [byteN], where N=var_const_max
extern "C" void ss_add_element(SbaStream* ss, int num_var, int var_no, size_t var_const_max, byte* elt, int is_uniform_var_width)
{
//  printf("-----------------------------------------ss_add_elt, varno:%d, constname:%c, p_ss:%p\n", var_no, elt[0], ss);
//  print_a_constraint(elt, var_const_max, is_uniform_var_width);

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
//  printf("ss_add_element: constnames done, for const %c\n", elt[0]);
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
  size_t const_size = constraint_length(elt[0], var_const_max, 1);
  
  byte** a_constm = (byte**)malloc(bytep_num_var);
  for(i=0;i<num_var;i++) {
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

  //printf("________________\n");
  //print_constraint_stream(num_var, var_const_max, ss);
  printf("ss_add_element are all done\n");

  return;
}



//} // end of extern "C"
//



__device__
int constname2numconstvar_gpu(byte c)
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
// output : byte of all element in constraint including name (initial byte)
__device__
size_t constraint_length_gpu(byte c, int var_max_byte, int is_uniform_var_width)
{

  int numconstvar = constname2numconstvar_gpu(c);
  if (numconstvar == 0) {
    //printf("In constraint length, charinput(%c), numconstvar=0 ----->exit\n", c);
    //exit(1);
  }

  if(is_uniform_var_width == 0) {
	  int var_part = var_max_byte * numconstvar;
	  return sizeof(byte) + var_part;
  }
  else
	  return var_max_byte * (1 + numconstvar);
}

// var_no const_no -> Xth byte
__device__
int const_pos(byte** constm, int* num_const, int var_no, int const_no, size_t var_const_max)
{
  byte* vconstm = constm[var_no];
  int n_vconst = num_const[var_no];

  // find pointer of const_no th byte.
  int counter = 0;
  //int csizebyte = 0;
  int offset = 0;

  byte* ptr = vconstm;
  for(counter=0;counter < n_vconst;counter++){
    //printf("const_pos - for: nvconst:%d, cnt:%d, const_no:%d\n", n_vconst, counter, const_no);
    if (counter == const_no) return offset;
    else{
      offset += constraint_length_gpu(*ptr, var_const_max, 1);
      ptr += offset;
    }
  }

  return -1;
}

// var_no, num_const, constnames -> Xth byte
__device__
int const_pos_available(byte** constm, int* num_const, byte** constnames, int var_no, size_t var_const_max)
{
  byte* vconstm = constm[var_no];
  int n_vconst = num_const[var_no];

  int counter = 0;
  int offset = 0;

  byte* ptr = vconstm;
  for(counter=0;counter < n_vconst;counter++) {
    offset += constraint_length_gpu(*ptr, var_const_max, 1);
    ptr += offset;
  }

  return offset;
}

__device__
byte* get_constraint_ptr(byte** constm, int var_no, int byte_offset)
{
  byte* vconst = constm[var_no];

  byte* cpos = vconst + byte_offset;
  return cpos;
}

// constraint strm, var_no, const_no -> a pointer to constraint stm
__device__
byte* get_stream_element(byte** constm, int* num_const, int var_no, int const_no, size_t var_const_max)
{
  int offset = const_pos(constm, num_const, var_no, const_no, var_const_max);
  byte* ptr = get_constraint_ptr(constm, var_no, offset);

  return ptr;
}

__device__ int is_heap_constraint(byte cname)
{
  if (cname == 'v'|| cname == 'b' || cname == 'c' || cname == 'l') return 1;
  else return 0;
}

__device__ int is_constraint(byte cname)
{
  if (cname == 'P'|| cname == 'C'|| cname == 'D' || cname == 'B' || cname == 'A') return 1;
  else return 0;
}


__device__ int bytes2int(byte* p, size_t varsize_max)
{
	int i;
	int bs = (int)__powf(2, 8);
	int ans = 0;
	for(i=0;i<varsize_max;i++) {
		ans += p[i] * __powf(bs, varsize_max - 1 - i);
	}

	return ans;
}

// constraint with uniform width
__device__ int get_var_in_const(byte* t_const, int th, size_t sz_a_var) {

	int var_index = th + 1;
	int v = bytes2int(t_const + var_index * sz_a_var, sz_a_var);
	return v;
}

__device__ byte* get_elem(int num_var, size_t sz_a_const, byte* constm, int var, int th) {

	byte* con = constm + sz_a_const * (var + th * num_var);
	return con;
}

// num_var : total number of variables
// sz_a_const(byte): uniform size of each constraint
// g_lock: shared memory for locking access to varnum for variable within a block
// varnum: prospective index of the position for variable(t_var)
// t_var: Xth variable(identifier)
// t_new_const: constraint to insert
__device__ void put_elem(int num_var, size_t sz_a_const, byte* constm, int* g_lock, int* varnum, int t_var, byte*  t_new_const)
{
	int pos_input;
	do {
//		pos_input = (t_var + varnum[t_var] * num_var) * sz_a_const;
//		memcpy(&constm[pos_input], t_new_const, sz_a_const);
//		varnum[t_var]++;
		atomicExch(&g_lock[t_var], 0);
	} while(atomicCAS(&(g_lock[t_var]), 0, 1));

//	while(atomicCAS(&(g_lock[t_var]), 0, 1) != 0);
//	pos_input = (t_var + varnum[t_var] * num_var) * sz_a_const;
//	memcpy(&constm[pos_input], t_new_const, sz_a_const);
//	varnum[t_var]++;
//
////	g_lock[t_var] = 0;
//	atomicExch(&g_lock[t_var], 0);
	return;
}


// num_elt - number of elt in global memory
// elts array of elts
// gsum -storage in global memory for result of each block
/* Blelloch 1990
1:  for d = 0 to log_2^n ��� 1 do ;; d=0,1,2,3 if n=16
2:      for all k = 0 to (n ��� 1) by 2^(d+1) in parallel do (0, 2, 4, 8, as init pos), (1, 2, 4, 8: offsets)
3:           x[k] = x[k] + x[k + 2^d]
d=0 k:0,2,4,... (0,1),(2,3),(4,5),(6,7),(8,9),(10,11)...
d=1 k:0,4,8,... (0,2),      (4,6),      (8,10)
d=2 k:0,8,16,...(0,4),                  (8,16),
d=3 k:16,32,... (0,8),

For 1d block, it works
For 2d blocks, need to get block id considering gridDim.x
*/
__global__ void sum_kernel_int32(int *num_elt, int *elts, int* num_block, int *gsum)
{
	int x = threadIdx.x + blockDim.x * blockIdx.x;
	int y = blockIdx.y;
	int g_id = x + blockDim.x * gridDim.x * y; // position in global memory
	int t_id = threadIdx.x;

	// position of block
	int bidx = blockIdx.x + y * gridDim.x;

	int local_num_elt = (*num_elt > 2 * blockDim.x)? 2 * blockDim.x : *num_elt;
	*num_block = *num_elt / local_num_elt;

	// sum block is out of the range of numblocks
	if(bidx < *num_block) {

		extern __shared__ int shds_int32[];
		// 1 thread, 2 copy to shared memory
		shds_int32[2 * t_id]     = elts[2 * g_id];
		shds_int32[2 * t_id + 1] = elts[2 * g_id + 1];

		int i, from, to, offset = 1;
		for(i = local_num_elt >> 1; i > 0; i >>= 1) {
			__syncthreads();
			if(t_id < i) {
				from = offset * (2*t_id + 1) - 1;
				to   = offset * (2*t_id + 2) - 1;
				shds_int32[to] += shds_int32[from];
			}
			offset *= 2;
		}
		int result = shds_int32[to];
		gsum[bidx] = result;
	}

	__syncthreads();

	return;
}


// blockDim = <block.x, 1>
// gridDim  = <binary_num_var / block.x, 1>
__global__ void init_constraints_kernel_csr(
		int num_var, int max_num_const, int num_tot_const, size_t sz_a_const,
		int* indices, byte* data,
		int* lock_const, int* varnum_const,
		byte* constm,
		int* lock_asis, int* varnum_asis,
		byte* asis,
		int* is_const_empty)
{
	int csr_idx = threadIdx.x + blockDim.x * blockIdx.x;

	//	real valid range.
	if(csr_idx < num_tot_const) {
		int var_id = indices[csr_idx];

		byte* input_constm = (byte*) &(data[csr_idx * sz_a_const]); // coalescing too
		byte constname = input_constm[0];

		int pos_input;
		if(is_constraint(constname)) { // constraint
			*is_const_empty = 0;        // is_const_empty flag is OFF -> constraint found
			do {
				pos_input = ( var_id + varnum_const[var_id] * num_var ) * sz_a_const;
				memcpy(constm + pos_input, input_constm, sz_a_const);
				varnum_const[var_id]++;

				lock_const[var_id] = 0;
			} while(atomicCAS((int*)&(lock_const[var_id]), 0, 1));
		}
		else if(is_heap_constraint(constname)) { // analysis
			do {
				pos_input = ( var_id + varnum_asis[var_id] * num_var ) * sz_a_const;
				memcpy(asis + pos_input, input_constm, sz_a_const);
				varnum_asis[var_id]++;

				lock_asis[var_id] = 0;
			} while(atomicCAS((int*)&(lock_asis[var_id]), 0, 1));
		}
		else {
			// unknown constraint name!
			pos_input = 0;
			int value = 88;
			varnum_const[var_id] -= csr_idx;
			varnum_asis[var_id] -= var_id;
			memset(&constm[var_id + varnum_const[var_id] * num_var], value, sz_a_const);
			memset(&asis[var_id + varnum_asis[var_id] * num_var], value, sz_a_const);
		}
	}

	__syncthreads();
	return;
}

// input original constm, num_const: (var->num const), ??
// split constm into 2 pieces(output): new_constm, analysis
//__global__
__global__ void init_constraints_kernel_stm(
		int* ss_in_cst_num_const, byte** ss_in_cst_constnames,	byte** ss_in_cst_constm,
		int num_var, size_t var_const_max,
		int* ss_out_cst_num_const, byte** ss_out_cst_constnames, byte** ss_out_cst_constm,
		int* ss_out_anlys_num_const, byte** ss_out_anlys_constnames, byte** ss_out_anlys_constm,
		int is_uniform_var_width, int is_euqal_const_size)
{
  // idx: index of which - variable
  // idy: order of constraints
  int var_no   = threadIdx.x;
  int const_no = threadIdx.y;

  int const_count = ss_in_cst_num_const[var_no];

  // skip too big constraint number
  if(const_count < const_no) {
    __syncthreads();
    return;
  }

  int* num_const    = ss_in_cst_num_const;
  byte** constnames = ss_in_cst_constnames;
  byte** constm     = ss_in_cst_constm;

  // ptr-to current constraint
  byte* elt = get_stream_element(constm, num_const, var_no, const_no, var_const_max);

  if(is_heap_constraint (elt[0])) {
/*    printf ("----to heap: %c\n", elt[0]);
    ss_add_element(ss_out_analysis, num_var, var_no, var_const_max, elt);
    //print_constraint_stream(num_var, var_const_max, ss_out_analysis);
    //printf("ptraddr:%d\n", ss_out_analysis->constnames);
*/
  }
  else {
/*
    printf ("----to const: %c\n", elt[0]);
    ss_add_element(ss_out_constraints, num_var, var_no, var_const_max, elt);
    //print_constraint_stream(num_var, var_const_max, ss_out_constraints);
    //printf("ptraddr:%d\n", ss_out_constraints->constnames);
*/
  }

  __syncthreads();


  return;
}

__global__ void solve_constraints_kernel(
				int num_var, int max_num_const, size_t sz_a_const,
				int* g_varnum_refl,  byte* g_reflection,
				int* g_varnum_const,  byte* g_constm,
				int* g_lock_asis, int* g_varnum_asis,  byte* g_asis,
				int* g_lock_new_const, int* g_varnum_new_const, byte* g_new_constm,
				int* sensor, int* g_const_sample)
{
	int block_gidx = blockIdx.x  * blockDim.x;
	int var_id     = threadIdx.x + block_gidx;
	int const_id   = threadIdx.y + block_gidx;
	int asis_id    = threadIdx.z + block_gidx;

	if(var_id < num_var) {
		extern __shared__ int s_lock_asis_nconst[];

		int* p_slock_const = NULL;
		int* p_slock_asis = NULL;

		if(threadIdx.y == 0 && threadIdx.z == 0) { // initialize locks for asis, new_const at s_lock_asis_nconst.
			// 1 thread, 2 copy to shared memory
			s_lock_asis_nconst[var_id]           = g_lock_asis[var_id];
			s_lock_asis_nconst[num_var + var_id] = g_lock_new_const[var_id];

			p_slock_const = s_lock_asis_nconst;
			p_slock_asis = &(s_lock_asis_nconst[num_var]);
		}
		__syncthreads();


		int i;

		size_t sz_a_var = sz_a_const / 4;

		register byte r_new_const_0[SYS_MAX_A_CONST];
		memset(r_new_const_0, NULL, SYS_MAX_A_CONST);

		register byte r_new_const_1[SYS_MAX_A_CONST];
		memset(r_new_const_1, NULL, SYS_MAX_A_CONST);

		// total 16*4 bytes in register = 2 words, 2*16(core) regs < 8K (16, 32)
		// 2*512 (core at high end Fermi) = 1024 < 8K (16, 32)
		register byte r_const[SYS_MAX_A_CONST];
		byte* a_const = get_elem(num_var, sz_a_const, g_constm, var_id, const_id);
		memcpy(r_const, a_const, sz_a_const);

		register byte r_asis [SYS_MAX_A_CONST];
		byte* a_asis = get_elem(num_var, sz_a_const, g_asis, var_id, asis_id);
		memcpy(r_asis, a_asis, sz_a_const);

//		// testing for threads.x
//		if(threadIdx.x == 1 || threadIdx.y == 0 || threadIdx.z == 0) {
//			*sensor = g_varnum_const[var_id];//*sensor * 6;
//		}
//		// testing the access of constraint from register
//		if(threadIdx.x == 4 || threadIdx.y == 0 || threadIdx.z == 0) {
//			//memcpy(g_const_sample, a_const, sz_a_const);
//			memcpy(g_const_sample, &g_asis[threadIdx.x * sz_a_const], sz_a_const);
//		}

		// get const/asis, store to register: r_const, r_asis
		if(const_id < g_varnum_const[var_id] && asis_id < g_varnum_asis[var_id]) {
			int cpos = (var_id + const_id * num_var) * sz_a_const;
			memcpy(r_const, &g_constm[cpos], sz_a_const);

			int apos = (var_id + asis_id * num_var) * sz_a_const;
			memcpy(r_asis, &g_asis[apos], sz_a_const);

			// comparision between constraint and analysis
			byte c_name = r_const[0];
			byte a_name = r_asis[0];

			// testing elements
			if(threadIdx.x == 4 || threadIdx.y == 0 || threadIdx.z == 0)
				memcpy(g_const_sample, &g_asis[asis_id], sz_a_const);

			if(c_name == 'P' && (a_name == 'v' || a_name == 'c' ||  a_name == 'l' ||  a_name == 'b')) {

				memcpy(r_new_const_0, r_asis, sz_a_const);

				int c_var = get_var_in_const(r_const, 0, sz_a_var);

				//testing var value
				*sensor = c_var;

				// put new constraint into a_sis for new variable
				put_elem(num_var, sz_a_const, g_asis, g_lock_asis, g_varnum_asis, c_var, r_new_const_0);
				g_varnum_asis[c_var]++;

				// iterate reflection on r_var, propagate new constraint to the reflection
				for(i=0;i<g_varnum_refl[c_var];i++) {
					byte* refl_const = get_elem(num_var, sz_a_const, g_reflection, c_var, i);
					put_elem(num_var, sz_a_const, g_new_constm, g_lock_new_const, g_varnum_new_const, c_var, refl_const);
					g_varnum_new_const[c_var]++;
				}
			}
			else if(c_name == 'C' && a_name == 'c') {
				r_new_const_0[0] = 'P';
				memcpy(r_new_const_0 + 1 * sz_a_var, r_const + 1 * sz_a_var, sz_a_var); // car_part(1) -> 1 element + 2 empty space
				int c_var = get_var_in_const(r_asis, 0, sz_a_var); // get 0th variable from
				put_elem(num_var, sz_a_const, g_new_constm, g_lock_new_const, g_varnum_new_const, c_var, r_new_const_0);
			}
			else if(c_name == 'D' && a_name == 'c') {
				r_new_const_0[0] = 'P';
				memcpy(r_new_const_0 + 1 * sz_a_var, r_const + 2 * sz_a_var, sz_a_var); // cdr_part(1) -> 1 element + 2 empty space
				int c_var = get_var_in_const(r_asis, 1, sz_a_var); // get 1st variable from
				put_elem(num_var, sz_a_const, g_new_constm, g_lock_new_const, g_varnum_new_const, c_var, r_new_const_0);
			}
			else if(c_name == 'A' && a_name == 'l') {
				r_new_const_0[0] = 'P';
				memcpy(r_new_const_0 + 1 * sz_a_var, r_const + 2 * sz_a_var, sz_a_var); // (app, result, arg) -> (prop2 result)
				int r_var_0 = get_var_in_const(r_asis, 1, sz_a_var);
				put_elem(num_var, sz_a_const, g_new_constm, g_lock_new_const, g_varnum_new_const, r_var_0, r_new_const_0);

				r_new_const_1[0] = 'P';
				memcpy(r_new_const_1 + sz_a_var, r_const + 1 * sz_a_var, sz_a_var);
				int r_var_1 = get_var_in_const(r_const, 1, sz_a_var);
				put_elem(num_var, sz_a_const, g_new_constm, g_lock_new_const, g_varnum_new_const, r_var_1, r_new_const_1);
			}
			else if(c_name == 'A' && a_name == 't') { // continuation is not supported
				r_new_const_0[0] = 'P';
				memcpy(r_new_const_0 + 1 * sz_a_var, r_const + 1 * sz_a_var, sz_a_var); // (app, result, arg) -> (prop2 result)
				int c_var = get_var_in_const(r_const, 1, sz_a_var);
				put_elem(num_var, sz_a_const, g_new_constm, g_lock_new_const, g_varnum_new_const, c_var, r_new_const_0);
			}
			else if(c_name == 'B' && a_name == 'v') {
				int var_value = get_var_in_const(r_asis, 0, sz_a_var);
				int var_test = get_var_in_const(r_const, 0, sz_a_var);
				int b_null;
				if(var_value == 0) b_null = 1;
				else b_null = 0;

				if(b_null == var_test){
					r_new_const_0[0] = 'P';
					memcpy(r_new_const_0 + 1 * sz_a_var, r_const + 3 * sz_a_var, sz_a_var); // (app, result, arg) -> (prop2 result)
					int c_var = get_var_in_const(r_const, 1, sz_a_var);
					put_elem(num_var, sz_a_const, g_new_constm, g_lock_new_const, g_varnum_new_const, c_var, r_new_const_0);
				}
			}
			else {


			}
		}
	}

	__syncthreads();

	return;
}
