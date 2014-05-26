#include <stdio.h>

// gpu - cuda includes
#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>

#include "cutil_common.h"
#include <gstm_common.h>
#include "gstm_kernel.h"

extern "C" int var_size_valid(byte name, int th)
{
	int num_var = constname2numconstvar(name);
	if(th < num_var) return 1;
	else return 0;
}

// const: pointer to a constraint [ name var1 var2 ...]
// th: order in sequence of variable
// var_const_max: bytes to represent the amount of variable name.
// 1) get name, 2) check range, 3) return ptr to the variable at th.(No conversion)
// output vpos: pointer to variable byte string or NULL
extern "C" void get_varstr_inconst(byte* aconst, int th, size_t var_const_max, byte* vpos, int is_uniform_var_width)
{
  byte constname = aconst[0];

  int offset = (is_uniform_var_width)? var_const_max : 1;

  if(var_size_valid(constname, th)) {
    int i;
    for(i=0;i<var_const_max;i++)
      vpos[i] = aconst[th * var_const_max + offset];
  }
  else {
    printf("Err: get_variable_inconst - th is bigg/equal to number of variable for given constraint. constname:%c, requested varidx:%d\n", constname, th);
    vpos = 0;
  }
}
// output: variable value (as integer).
extern "C" int get_variable_inconst(byte* aconst, int th, size_t var_const_max, int is_uniform_var_width)
{
	printf("get_variable in _const:%d\n", aconst[0]);
  print_a_constraint(aconst, var_const_max, is_uniform_var_width);

  // var_str: pointer to byte array where th'th variable sits
  byte* p_var_str = (byte*)malloc(sizeof(byte) * var_const_max);

  get_varstr_inconst(aconst, th, var_const_max, p_var_str, is_uniform_var_width);
  printf("-1, var_str:%s at %dth\n", p_var_str, th);
  int* p_var_num = (int*)malloc (sizeof(int));
  bytes2int(p_var_str, p_var_num, var_const_max);
  printf("-2, *p_var_num = %d\n", *p_var_num);

  return *p_var_num;
}


// output 0, if c is neither analysis name nor constraint name
// output 1, if either analysis name or constraint name
extern "C" int is_const_name(byte c)
{
  int var_size = constname2numconstvar(c);
  if(0 == var_size) return 0;
  else return 1;
}

extern "C" int is_constraintstream_empty(int num_var, size_t var_const_max, SbaStream* ss_const)
{
  int empty = 1; // set empty = TRUE.

  // check only num_const.
  int* num_const = ss_const->num_const;
  int j;
  for(j=0;j<num_var;j++) {
    if((num_const != 0) && (num_const[j] != 0)) empty = 0; // empty==FALSE -> not empty
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

      int const_length = (cname[l], var_const_max, 1); // uniform_width
      offset += const_length;
    }
  }

  // at this point, constraint is turned out to be empty.
  return empty;
  */
}

// allocate space as same as input arguments
extern "C" int* init_from_num_const(int num_var, int value, GpuFlag gpu_flag)
{
  int* out_num_const;
  size_t num_const_size = num_var * sizeof(int);

  if(gpu_flag) { // gpu
    CudaSafeCall(cudaMalloc((void**)&out_num_const, num_const_size));
    CudaSafeCall(cudaMemset((void*)out_num_const, value, num_const_size));
  }
  else {
    out_num_const = (int*)malloc(num_const_size);
    memset((void*) out_num_const, value, num_const_size);
  }
  return out_num_const;
}

// value is initial values in the new storage
extern "C" byte** init_from_constnames(int num_var, int* num_const, byte value, GpuFlag gpu_flag)
{
  int k;
  int mx_num_const;
  size_t sz_num_var = sizeof(int) * num_var;

  printf("-----1.2-----\n");

  if(gpu_flag) { // num_var is host, num_const : byte** points gpu location.
    int* h_num_const = (int*)malloc(sz_num_var);
    CudaSafeCall(cudaMemcpy(h_num_const, num_const, sz_num_var, cudaMemcpyDeviceToHost));
    mx_num_const = max_num_constraints(num_var, h_num_const);
  }
  else{
	mx_num_const = max_num_constraints(num_var, num_const);
  }

  size_t constnamesp_size = sizeof (byte*) * num_var;
  byte** out_constnames;

  if(gpu_flag) { // gpu
	byte** dcnp = (byte**)malloc(constnamesp_size);;
    int* nck = (int*)malloc(sz_num_var);
    cudaMemcpy((void*)nck, num_const, sz_num_var, cudaMemcpyDeviceToHost);

    for(k=0;k<num_var;k++)  {
      size_t constnames_size = sizeof(byte) * nck[k];
      CudaSafeCall(cudaMalloc((void**) dcnp + k, constnames_size));
      CudaSafeCall(cudaMemset((void*) *(dcnp + k), value, constnames_size));
	}
    CudaSafeCall(cudaMalloc((void**)&out_constnames, constnamesp_size));
    cudaMemcpy(out_constnames, dcnp, constnamesp_size, cudaMemcpyDeviceToDevice);
  }
  else {
    out_constnames = (byte**) malloc (constnamesp_size);
    for(k=0;k<num_var;k++) {
      out_constnames[k] = (byte*) malloc (sizeof(byte) * mx_num_const);
      memset((void*)out_constnames[k], value, (size_t)mx_num_const);
    }
  }
  return out_constnames;
}

// value is initial values in the new storage
// num_const is gpu address
extern "C" byte** init_from_constm(int num_var, int* num_const, size_t var_const_max, byte value, GpuFlag gf, int is_uniform_var_width)
{
  // preparing for answer storage by taking biggest constraint with maximum number of constraints
  // for every variable. (sufficiently large area)
  size_t sz_num_var = sizeof(int) * num_var;
  int mx_const_byte = longest_constraint_byte(var_const_max, is_uniform_var_width);
  int mx_num_const;
  if(gf) { // num_var is host, num_const : byte** points gpu location.
    int* h_num_const = (int*)malloc(sz_num_var);
    CudaSafeCall(cudaMemcpy(h_num_const, num_const, sz_num_var, cudaMemcpyDeviceToHost));
    mx_num_const = max_num_constraints(num_var, h_num_const);
  }
  else{
	mx_num_const = max_num_constraints(num_var, num_const);
  }
  size_t constmp_size = num_var*sizeof(byte*);
  byte** out_constm;
  int k;

  if(gf) { // gpu
	byte** dstmp = (byte**)malloc(constmp_size);;
    int* nck = (int*)malloc(sz_num_var);
    cudaMemcpy((void*)nck, num_const, sz_num_var, cudaMemcpyDeviceToHost);
	for(k=0;k<num_var;k++)  {

	  size_t constm_size = sizeof(byte) * nck[k] * mx_const_byte;
      CudaSafeCall(cudaMalloc((void**) dstmp + k, constm_size));
      CudaSafeCall(cudaMemset((void*) *(dstmp + k), value, constm_size));
	}
    CudaSafeCall(cudaMalloc((void***)&out_constm, constmp_size));
    cudaMemcpy(out_constm, dstmp, constmp_size, cudaMemcpyDeviceToDevice);
  }
  else {
    out_constm = (byte**) malloc (sizeof(byte*) * num_var);
    for(k=0;k<num_var;k++) {
      int size_out = mx_const_byte * mx_num_const;
      out_constm[k] = (byte*) malloc (sizeof (byte) * size_out);
      memset((void*)out_constm[k], value, (size_t)size_out);
    }
  }
  return out_constm;
}


extern "C" SbaStream* SbaStream_init_empty (int num_var)
{
  SbaStream *ss = (SbaStream*)malloc(sizeof(SbaStream));
  ss->num_const = (int*)malloc(sizeof(int) * num_var);
  ss->constnames = (byte**)malloc(sizeof(byte*) * num_var);
  ss->constm = (byte**)malloc(sizeof(byte*) * num_var);

  int i;
  for(i=0;i<num_var;i++) {
    ss->num_const[i] = 0;
    ss->constnames[i] = 0;
    ss->constm[i] = 0;
  }

  //printf ("ss:%p, num_const:%p, constnames:%p, constm:%p\n", ss, ss->num_const, ss->constnames, ss->constm);

  return ss;
}

// currently when gpu_flag==1,this proc doesn't do valid operation.
extern "C" void init_from_SbaStream(int num_var, size_t var_const_max, SbaStream* ss_in, SbaStream** ss_out, GpuFlag gf, int is_uniform_var_width)
{
  int value_int = 0;
  byte value_byte = 0;

  if(gf) // gpu initialization
  {
    int* num_const = init_from_num_const(num_var, value_int, gf);

    // constnames
    SbaStream* ssh_in = (SbaStream*)malloc(sizeof(SbaStream));
	CudaSafeCall(cudaMemcpy ((void*)ssh_in, ss_in, sizeof(SbaStream), cudaMemcpyDeviceToHost));
	  printf("---2---\n");

    byte** constnames = init_from_constnames(num_var, ssh_in->num_const, value_byte, gf);
	  printf("---3---\n");
    byte** constm = init_from_constm(num_var, ssh_in->num_const, var_const_max, value_byte, gf, is_uniform_var_width);
	  printf("---4---\n");

    SbaStream* ss_store;
    CudaSafeCall(cudaMalloc((void**) & ss_store, sizeof(SbaStream)));
	  printf("---5---\n");
    CudaSafeCall(cudaMemcpy((void*) ss_store->num_const, num_const, sizeof(int*), cudaMemcpyDeviceToDevice));
	  printf("---6---\n");
    CudaSafeCall(cudaMemcpy((void*) ss_store->constnames, constnames, sizeof(byte**), cudaMemcpyDeviceToDevice));
	  printf("---7---\n");
    CudaSafeCall(cudaMemcpy((void*) ss_store->constm, constm, sizeof(byte**), cudaMemcpyDeviceToDevice));
	  printf("---8---\n");

    CudaSafeCall(cudaMemcpy((void*) *ss_out, ss_store, sizeof(SbaStream*), cudaMemcpyDeviceToDevice));
  }
  else // gpu_flag==0 host
  {
    int* num_const = init_from_num_const(num_var, value_int, gf);
    byte** constnames = init_from_constnames(num_var, ss_in->num_const, value_byte, gf);
    byte** constm = init_from_constm(num_var, ss_in->num_const, var_const_max, value_byte, gf, is_uniform_var_width);

    SbaStream* ss_store = (SbaStream*)malloc(sizeof(SbaStream));
    ss_store->num_const = num_const;
    ss_store->constnames = constnames;
    ss_store->constm = constm;

    *ss_out = ss_store;
  }
  return;
}

extern "C" int* copy_from_num_const(int num_var, int* num_const)
{
  int i;
  int* out_num_const = (int*)malloc(sizeof(int) * num_var);
  for(i=0;i<num_var;i++)
    out_num_const[i] = num_const[i];

  return out_num_const;
}

extern "C" byte** copy_from_constnames(int num_var, int* num_const, byte** constnames)
{
  int i,j;
  byte** out_constnames = (byte**) malloc (sizeof(byte*) * num_var);
  for(i=0;i<num_var;i++) {
    out_constnames[i] = (byte*) malloc (sizeof(byte) * num_const[i]);
    for(j=0;j<num_const[i];j++)
      out_constnames[i][j] = constnames[i][j];
  }

  printf("copy_from_constnames:%p memcpyn", out_constnames);

  return out_constnames;
}

extern "C" byte** copy_from_constm(int num_var, int* num_const, byte** constname, size_t var_const_max, byte** constm)
{
  int i,j;
  byte** out_bytes = (byte**) malloc (sizeof(byte*) * num_var);
  size_t* vconstm_size = (size_t*) malloc (sizeof (size_t) * num_var);

  for(i=0;i<num_var;i++) {
    for(j=0;j<num_const[i];j++) 
      vconstm_size[i] += constraint_length(constname[i][j], var_const_max, 1);
  }

  for(i=0;i<num_var;i++) {
    int constsize_byte = vconstm_size[i];

    byte* vconst_src = constm[i];
    byte* vconst_dst = (byte*) malloc (sizeof(byte) * constsize_byte);

    memcpy(vconst_dst, vconst_src, constsize_byte);

    out_bytes[i] = vconst_dst;
  }

  return out_bytes;
}


// host code.
extern "C" SbaStream* copy_from_SbaStream(int num_var, size_t var_const_max, SbaStream* ss_in)
{
  //printf("-------reflection---------\n");
  int*   ref_num_const  = copy_from_num_const (num_var, ss_in->num_const);
  byte** ref_constnames = copy_from_constnames(num_var, ss_in->num_const,
                                             ss_in->constnames);
  byte** ref_constm     = copy_from_constm(num_var, ss_in->num_const,
                        ss_in->constnames, var_const_max, ss_in->constm);

  SbaStream *ss_out = (SbaStream*)malloc(sizeof(SbaStream));
    ss_out->num_const = ref_num_const;
    ss_out->constnames = ref_constnames;
    ss_out->constm = ref_constm;

  return ss_out;
}
// ss_f (from) --> ss_t (to)
// currently implemented from HOST to DEVICE
extern "C" void sbastream_alloc_copy(int num_var, size_t var_const_max, SbaStream* ss_f, SbaStream** ss_t, cudaMemcpyKind direction)
{
  // HOST -> Device
  if(direction == cudaMemcpyHostToDevice) {

    // Number of constraints ///////////////////////////////////////////
    int* num_const_f = ss_f->num_const; //array of number_of_constraints
    size_t num_const_size = num_var * sizeof(int);

    int* num_const_t = 0; // pointer to destination array of num_const
    CudaSafeCall(cudaMalloc((void**)&num_const_t,  num_const_size));

    cudaMemcpy(num_const_t,  num_const_f,  num_const_size, direction);
    printf("num_const:%p, %d\n", num_const_f, num_const_f[0]);

    size_t pconsts_size = num_var * sizeof(byte*);

    // Constraint Names ///////////////////////////////////////////
    byte** constnames_f = ss_f->constnames;
    byte** h_pcn = (byte**)malloc(num_var * sizeof (byte*));

    int i;
    for (i=0;i<num_var;i++) {
      size_t cnlength = num_const_f[i] * sizeof(byte);
      printf ("constname at %d(%d), %p \n", i, cnlength, constnames_f[i]);
      if(cnlength > 0) printf ("first char:%c\n", constnames_f[i][0]);

      cudaMalloc((void**) h_pcn+i, cnlength);
      cudaMemcpy(*(h_pcn+i), constnames_f[i], cnlength, cudaMemcpyHostToDevice);
    }
    byte** constnames_t;
    cudaMalloc((byte**) &constnames_t, pconsts_size);
    CudaSafeCall(cudaMemcpy(constnames_t, h_pcn, pconsts_size, cudaMemcpyHostToDevice));

    // constraint stream: constm ///////////////////////////////////////////
    byte** constm_f = ss_f->constm;
    byte** h_pctm = (byte**)malloc(num_var * sizeof (byte*));

    for (i=0;i<num_var;i++) {
      size_t constms_byte = sizeof(byte) * sum_const_sizes(constnames_f[i], num_const_f[i], var_const_max);
      cudaMalloc((void**) h_pctm + i, constms_byte);
      cudaMemcpy(*(h_pctm + i), constm_f[i], constms_byte, cudaMemcpyHostToDevice);
      if(constm_f[i] != 0) printf("constm(%d) first char:%c\n", i, constm_f[i][0]);
      else printf("cosntm(%d) is null\n", i);
    }
    byte** constm_t = 0; // device
    cudaMalloc((void**) &constm_t, pconsts_size);
    cudaMemcpy(constm_t, h_pctm, pconsts_size, cudaMemcpyHostToDevice);

    // SbaStream //////////////////////////////////////////////
    SbaStream* ss_htmp = (SbaStream*)malloc(sizeof(SbaStream));
    ss_htmp->num_const = num_const_t;
    ss_htmp->constnames = constnames_t;
    ss_htmp->constm = constm_t;
    printf("Sbastm is made, %p, %p, %p\n", ss_htmp->num_const, ss_htmp->constnames, ss_htmp->constm);
    cudaMalloc(ss_t, sizeof(SbaStream));
    cudaMemcpy((void*) *ss_t, ss_htmp, sizeof(SbaStream), cudaMemcpyHostToDevice);

  }
  // Device -> HOST
  else {
    SbaStream* tmp = (SbaStream*)malloc(sizeof(SbaStream));
    cudaMemcpy(tmp, ss_f, sizeof(SbaStream), cudaMemcpyDeviceToHost);
    printf("upto here, %p, %p, %p\n", tmp->num_const, tmp->constnames, tmp->constm);

    // num_const
    int num_const_size = sizeof(int) * num_var;
    int* num_const_h = (int*)malloc(num_const_size);
    cudaMemcpy(num_const_h, tmp->num_const, num_const_size, cudaMemcpyDeviceToHost);
    int i;
	for(i=0;i<num_var;i++) {
	  printf("numconst at %d = %d\n", i, num_const_h[i]);
	}

	// constnames
	int cnp_size = num_var* sizeof(byte*);
	byte** cn_ptr = (byte**)malloc(cnp_size);
	cudaMemcpy(cn_ptr, tmp->constnames, cnp_size, cudaMemcpyDeviceToHost);
	printf("ptr-cn fetch\n");
	byte** cnp = (byte**) malloc (num_var * sizeof(byte*));
	for(i=0;i<num_var;i++) {
	  size_t constnames_size = sizeof(byte) * num_const_h[i];
	  cnp[i] = (byte*) malloc (constnames_size);
	  cudaMemcpy(cnp[i], cn_ptr[i], constnames_size, cudaMemcpyDeviceToHost);
	  int j;
	  for(j=0;j<constnames_size;j++)
	    printf("%dth byte:%c\n", j, cnp[i][j]);
	}

	// constm
	byte** cstm_ptr = (byte**)malloc(cnp_size);
	cudaMemcpy(cstm_ptr, tmp->constm, cnp_size, cudaMemcpyDeviceToHost);  // pointers
	printf("ptr-stc fetch, %d\n", num_var);
	byte** cstmp = (byte**) malloc (num_var * sizeof(byte*));
	for(i=0;i<num_var;i++) {
	  size_t constms_byte = sizeof(byte) * sum_const_sizes(cnp[i], num_const_h[i], var_const_max);
	  cstmp[i] = (byte*) malloc (constms_byte);
	  cudaMemcpy(cstmp[i], cstm_ptr[i], constms_byte, cudaMemcpyDeviceToHost);
	  int j;
	  for(j=0;j<constms_byte;j++)
	    printf("%dth byte:%d\n", j, cstmp[i][j]);
	}

	printf("constm end\n");

    *ss_t = (SbaStream*)malloc(sizeof(SbaStream));
    (*ss_t)->num_const  = num_const_h;
    (*ss_t)->constnames = cnp;
    (*ss_t)->constm     = cstmp;
  }
  return;
}

//always Host to Device
extern "C" void csr_alloc_copy(int num_var, int num_tot_const, int max_num_const,
		int** d_ptr, int** d_indices, byte** d_data,
		int* s_ptr, int* s_indices, byte* s_data,
		size_t sz_a_const,
		cudaMemcpyKind direction) {
	// CSR structure
	size_t sz_ptr = sizeof(int) * (max_num_const + 1);
	size_t sz_indices = sizeof(int) * num_tot_const;
	size_t sz_data = sz_a_const * num_tot_const;

	printf(" csr_alloc_copy, sz_ptr:%d\n", sz_ptr);
	printf(" csr_alloc_copy, sz_indices:%d\n", sz_indices);
	printf(" csr_alloc_copy, sz_data:%d\n", sz_data);

	if(direction == cudaMemcpyHostToDevice) {
		CudaSafeCall(cudaMalloc(d_ptr, sz_ptr));
		CudaSafeCall(cudaMalloc(d_indices, sz_indices));
		CudaSafeCall(cudaMalloc(d_data, sz_data));
	}
	else if(direction == cudaMemcpyDeviceToHost) {
		*d_ptr = (int*) malloc(sz_ptr);
		*d_indices = (int*) malloc(sz_indices);
		*d_data = (byte*) malloc(sz_data);
	}
	else {
		printf("csr_alloc_copy() - error - csr_alloc_copy only supports H2D, D2H\n");
		exit(1);
	}

	CudaSafeCall(cudaMemcpy(*d_ptr, s_ptr, sz_ptr, direction));
	CudaSafeCall(cudaMemcpy(*d_indices, s_indices, sz_indices, direction));
	CudaSafeCall(cudaMemcpy(*d_data, s_data, sz_data, direction));


	return;
}

// input : uniform var-length, uniform constraint length
// 1 if constraint sizes are uniform
// 0 otherwise
extern "C" int warning_for_non_csr(int is_uniform_var_width, int is_equal_const_size) {
	// if all constraints are in equal length, then each variable in a constratint have equal length too.
	if(is_equal_const_size == 1) //is_uniform_var_width = 1;
		return 1;
	else if(is_uniform_var_width) {
		printf("sba_solver_csr: This case cannot happen:constraints are not same is length, and they have uniform width in variable\n");
		exit(1);
	}
	else {
		printf("sba_solver_csr: This routine only support - equal sized constraints -and- variable lengths in constraint are uniform\n");
		exit(1);
	}
	return 0;
}

// given input from Racket(list of list), produces CSR
// copy of code in project: xform_global_shared
extern "C" void transform_const_csr(int num_var, int num_tot_const, int max_num_const, int* num_const, byte** constm,
						int* ptr, int* indices, byte* data, size_t sz_a_const, int is_uniform_var_width, int is_equal_const_size)
{
	int new_uniform_var_width = warning_for_non_csr(is_uniform_var_width, is_equal_const_size);
	if(new_uniform_var_width) is_uniform_var_width = 1;

	int i,j,k,l;

	k=0, l=0;	// l: num of valid consts

//	for(i=0;i<num_var;i++)
//		for(j=0;j<num_const[i];j++) {
//			k++;
//			if(k>8389000) {
//				printf("srcccccc%d th \t", k);
//				print_a_constraint(&(constm[i][j]), 4, is_uniform_var_width);
//			}
//		}
//
//	k=0;

	for(i=0;i<max_num_const;i++) {
		for(j=0;j<num_var;j++) {
			if (i < num_const[j]) {
				byte* p_const = constm[j]+ i*sz_a_const;
				memcpy(data + k*sz_a_const, p_const, sz_a_const); // general version
				// data[k] = constm[j][i]; // valid only when sz_a_const = 1
				indices[k] = j;
				l++;
				k++;

//				if(k > 8389000) {
//					printf("src-const[%d]:\t", k);
//					print_a_constraint(p_const, 4, is_uniform_var_width);
//				}
			}
		}
		ptr[i+1] = l;
	}
//	for(k=0;k<num_var;k++)
//		printf("num const[%d:%d\n", k, num_const[k]);

//	for(j=0;j<=max_num_const;j++)
//		printf("transform_const's ptr[%d]:%d\n", j, ptr[j]);

	return;
}


// num_elt : length of input array in cpu
// gnum_elt: pointer to length of input arary in gpu
// g_elts: pointer to the array in GPU
// output: pointer to array that contains the sum at the first location in GPU

extern "C" int* sum_gpu_kernel_int32(int num_elt, int* gnum_elt, int* gelts)
{
	size_t sz_ull = sizeof(int);
	size_t sz_elts = sz_ull * num_elt;

	int* gnum_block;
	cudaMalloc(&gnum_block, sz_ull);
	cudaMemset(gnum_block, 0, sz_ull);

    dim3 block1 = dim3 ((int) fmin((double)512, (double)num_elt/2.0), 1); // 512 threads deals with 1024 data.
    int num_blk;
    num_blk = (num_elt > block1.x)? num_elt / (2 * block1.x): 1; // because each thread process 2 elements

	// return storage gsum
	size_t sz_gsum = sz_ull * num_blk;
	int *gsum;
	cudaMalloc(&gsum, sz_gsum);
	cudaMemset(gsum, 0, sz_gsum);

	/*
    unsigned int timerg_exe = 0;
    cutCreateTimer(&timerg_exe);
    cutResetTimer(timerg_exe);

	cutStartTimer(timerg_exe);
	*/
	// Timer Event Prepare
	cudaEvent_t kernel_start, kernel_stop;
	cudaEventCreate(&kernel_start);
	cudaEventCreate(&kernel_stop);
	// Start record
	cudaEventRecord(kernel_start, 0);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
    do {
//    	printf("--------------do-------------\nnumelt:%d\n", num_elt);
//    	int* tmpelt = (int*)malloc(sz_elts);
//    	cudaMemcpy(tmpelt, gelts, sz_elts, cudaMemcpyDeviceToHost);
//    	for(i=0;i<num_elt;i++)
//    		printf("tmpelt[%d] = %llu\n", i, tmpelt[i]);

        block1 = dim3 ((int) fmin((double)512, (double)num_elt/2.0), 1); // 512 threads deals with 1024 data.
        num_blk = (num_elt > block1.x)? num_elt / (2 * block1.x): 1; // because each thread process 2 elements

        int mxgrd [] = {65535, 65535, 1};
        printf("grid max = %d, %d blocks\n", mxgrd[0], mxgrd[1]);

        int gridx = (num_blk > mxgrd[0])? mxgrd[0] : num_blk;
        int gridy = (num_blk > mxgrd[0])? num_blk / mxgrd[0] + 1: 1;
        printf("num_blk:%d\n", num_blk);

        printf("grid dimension x, y = %d, %d\n", gridx, gridy);


        dim3 grid1 = dim3(gridx, gridy);
        size_t shds1 = 2 * block1.x * sizeof(int); // need factor 2 because a thread add 2 elements.

        printf("blockdim.x = %d threads, shd size = %d bytes\n", block1.x, shds1);

        // clear used location
		size_t sz_gsum = sz_ull * num_blk;

		// new grid, block, shds
		sum_kernel_int32<<<grid1, block1, shds1>>>(gnum_elt, gelts, gnum_block, gsum);

		num_elt = num_blk;
		sz_elts = sz_gsum;

		// interchange:
		int* tmp_num_elt = gnum_elt;
		int* tmp_elts = gelts;

		gnum_elt = gnum_block;
		gelts = gsum;

		gnum_block = tmp_num_elt;
		gsum = tmp_elts;

//		// copy output by printing next inputs
//		int* cnum_elt = (int*)malloc(sz_ull);
//		cudaMemcpy(cnum_elt, gnum_elt, sz_ull, cudaMemcpyDeviceToHost);
//		printf("next - numelt:%d\n", *cnum_elt);

//		int i;
//		int* celts = (int*)malloc(sz_elts);
//		cudaMemcpy(celts, gelts, sz_elts, cudaMemcpyDeviceToHost);
//		for(i=0;i<(int)*cnum_elt;i++)
//			printf("%d th next elt:%llu\n", i, celts[i]);

	} while (num_blk != 1);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    /*
    cutStopTimer(timerg_exe);
    double tvg = cutGetTimerValue(timerg_exe);
    printf("gpu time glb(kernel):\n %e \n(%f)(ms)\n", tvg, tvg);

    cutDeleteTimer(timerg_exe);
	*/

	// Stop event
	cudaEventRecord(kernel_stop, 0);
	cudaEventSynchronize(kernel_stop);
	float kernel_elapsedTime;
	cudaEventElapsedTime(&kernel_elapsedTime, kernel_start, kernel_stop); // that's our time!
	// Clean up:
	cudaEventDestroy(kernel_start);
	cudaEventDestroy(kernel_stop);

	printf("gpu time glb(kernel):\n %e \n(%f)(ms)\n", kernel_elapsedTime, kernel_elapsedTime);

	return gelts;
}


//__global__ void add1(int* x)
//{
//	*x = *x + 100;
//	return;
//}


// convert ss_in into CSR
// copy CSR
// return back ss_out_analysis
extern "C" void sba_solve_csr(SbaStream* ss_in, int num_var, size_t var_const_max, SbaStream* ss_out_analysis,
		int is_uniform_var_width, int is_equal_const_size)
{
	int i;

	int new_uniform_var_width = warning_for_non_csr(is_uniform_var_width, is_equal_const_size);
	if(new_uniform_var_width) is_uniform_var_width = 1;

	// uniform width for constraints
	size_t sz_a_const = var_const_max * 4; // name + 3 references to variables.

	// SbaStream -> num_tot_const
	int num_tot_const = 0;
	for(i=0;i<num_var;i++) {
		num_tot_const += ss_in->num_const[i];
	}

	printf("tot_const:%d before convert to ...\n", num_tot_const);

	// SbaStream -> max_num_const maximum number of constraints
	int max_num_const = ss_in->num_const[0];
	for(i=1;i<num_var;i++) {
		int numcst = ss_in->num_const[i];
		if(numcst > max_num_const) max_num_const = numcst;
	}

	// 3 vars for CSR structure.
	int* ptr = (int*)malloc(sizeof(int) * (1 + max_num_const));
	int* indices = (int*)malloc(sizeof(int) * num_tot_const);
	byte* data = (byte*)malloc(sizeof(byte) * num_tot_const * sz_a_const);

	//print_constraint_stream(num_var, var_const_max, ss_in, is_uniform_var_width, is_equal_const_size, 1000);

	transform_const_csr(num_var, num_tot_const, max_num_const, ss_in->num_const, ss_in->constm,
			ptr, indices, data, sz_a_const, is_uniform_var_width, is_equal_const_size);

	//print_constraints_csr(num_var, num_tot_const, var_const_max, ptr, indices, data, sz_a_const, is_uniform_var_width, is_equal_const_size, 1000);

	//////////////////////////////////////////////////////////////
	//begin gpu timer
	/*
    unsigned int timerg_all = 0;
    cutCreateTimer(&timerg_all);
    cutResetTimer(timerg_all);

    unsigned int timerg_exe = 0;
    cutCreateTimer(&timerg_exe);
    cutResetTimer(timerg_exe);

	cutStartTimer(timerg_all);
	*/
	// Timer Event Prepare
	cudaEvent_t all_start, all_stop;
	cudaEventCreate(&all_start);
	cudaEventCreate(&all_stop);
	// Start record
	cudaEventRecord(all_start, 0);



	// copy to gpu
	int* g_ptr;
	int* g_indices;
	byte* g_data;
	csr_alloc_copy(num_var, num_tot_const, max_num_const,
			&g_ptr, &g_indices, &g_data,
			ptr, indices, data,
			sz_a_const, cudaMemcpyHostToDevice);

//	// testing to gpu copy by copying back to cpu
//	int* h_ptr;
//	int* h_indices;
//	byte* h_data;
//	csr_alloc_copy(num_var, num_tot_const, max_num_const,
//				&h_ptr, &h_indices, &h_data,
//				g_ptr, g_indices, g_data,
//				sz_a_const, cudaMemcpyDeviceToHost);
//
//	printf("num_total constraints:%d\n", num_tot_const);
//	print_constraints_csr(num_var, num_tot_const, var_const_max, h_ptr, h_indices, h_data, sz_a_const, is_uniform_var_width, is_equal_const_size, 1000);
//

	// output matrices of init_constraints_kernel()
	size_t sz_mat = sz_a_const * num_var * max_num_const;

	byte* g_constm;
	CudaSafeCall(cudaMalloc(&g_constm, sz_mat));
	CudaSafeCall(cudaMemset(g_constm, 0, sz_mat));

	byte* g_asis;
	CudaSafeCall(cudaMalloc(&g_asis, sz_mat));
	CudaSafeCall(cudaMemset(g_asis, 0, sz_mat));

	// lock, varnum for matrices g_const, g_asis
	size_t sz_locks = sizeof(int) * num_var;
	size_t sz_varnums = sizeof(int) * num_var;

	int* g_lock_const;
	CudaSafeCall(cudaMalloc(&g_lock_const, sz_locks));
	CudaSafeCall(cudaMemset(g_lock_const, 0, sz_locks));

	int* g_varnum_const;
	CudaSafeCall(cudaMalloc(&g_varnum_const, sz_varnums));
	CudaSafeCall(cudaMemset(g_varnum_const, 0, sz_varnums));

	int* g_lock_asis;
	CudaSafeCall(cudaMalloc(&g_lock_asis, sz_locks));
	CudaSafeCall(cudaMemset(g_lock_asis, 0, sz_locks));

	int* g_varnum_asis;
	CudaSafeCall(cudaMalloc(&g_varnum_asis, sz_varnums));
	CudaSafeCall(cudaMemset(g_varnum_asis, 0, sz_varnums));

	int is_const_empty = 1;
	int *g_is_const_empty;
	CudaSafeCall(cudaMalloc(&g_is_const_empty, sizeof(int)));
	CudaSafeCall(cudaMemcpy(g_is_const_empty, &is_const_empty, sizeof(int), cudaMemcpyHostToDevice));

	// initialize const-mat, asis-mat from ptr, indices, data
	// each matrix is size (max_num_const x num_var),
	// iteration is as long as num_tot_const
	// read indices, data write to the matrix.
	// row in matrix is defined by 1) varnum[] - current empty sp in mat, 2)lock[] - gateway showing accessability.
	unsigned int binary_num_tot_const = least_upper_binary(num_tot_const);

//	printf("binary upper bound of total const: %d\n", binary_num_tot_const);

	/*
	size_t cpyamount_device =
			sizeof(int) * (max_num_const + 1) //ptr
			+ sizeof(int) * num_tot_const		//indices
			+ sz_a_const * num_tot_const		//data
			+ 2*sz_mat + 2*sz_locks + 2*sz_varnums;
	*/
	int max_threads = (int) fmin(binary_num_tot_const, (float)pow(2,8)); //256
	dim3 block_init(max_threads, 1);
	dim3 grid_init(binary_num_tot_const/max_threads,1);

//	if(block.x * grid.x >= 512*65536) {
//		printf("cuda hw cannot support so many constraints\n");
//		exit(1);
//	}
//	else
//		printf("global memory was occupied by copy: %d bytes\n", cpyamount_device);

	/*
	cutStartTimer(timerg_exe);
	*/

	init_constraints_kernel_csr<<<grid_init, block_init>>>(
			num_var, max_num_const, num_tot_const, sz_a_const, // num of variables, longest const, total const, single const size

			g_indices, g_data, // input data in CSR form

			g_lock_const, g_varnum_const, // lock, positioner for new constm
			g_constm, // storage for new constm

			g_lock_asis, g_varnum_asis, // lock, positioner for new asis
			g_asis,

			g_is_const_empty); // set to 0 (not empty) is kernel read constraint during initialization

	// solve_constraint kernel
	printf("INIT-> no constraint exist\n");

	size_t sz_num_var = sizeof(int) * num_var;

	int* h_varnum_const = (int*)malloc(sz_num_var);
	CudaSafeCall(cudaMemcpy(h_varnum_const, g_varnum_const, sz_num_var, cudaMemcpyDeviceToHost));

	for(i=0;i<num_var;i++)
		printf("org varnum_const[%d] = %d\n", i, h_varnum_const[i]);

	int* h_varnum_asis = (int*)malloc(sz_num_var);
	CudaSafeCall(cudaMemcpy(h_varnum_asis, g_varnum_asis, sz_num_var, cudaMemcpyDeviceToHost));

	for(i=0;i<num_var;i++)
		printf("org varnum_asis[%d] = %d\n", i, h_varnum_asis[i]);

	// reflection definition
	int* g_varnum_refl;
	CudaSafeCall(cudaMalloc(&g_varnum_refl, sz_varnums));
	CudaSafeCall(cudaMemcpy(g_varnum_refl, g_varnum_const, sz_varnums, cudaMemcpyDeviceToDevice));

	//printf("1\n");

	byte* g_reflection;
	CudaSafeCall(cudaMalloc(&g_reflection, sz_mat));
	CudaSafeCall(cudaMemcpy(g_reflection, g_constm, sz_mat, cudaMemcpyDeviceToDevice));
	//printf("2\n");

	CudaSafeCall(cudaMemcpy(&is_const_empty, g_is_const_empty, sizeof(int), cudaMemcpyDeviceToHost));

	if(is_const_empty)
		printf ("constraint is not empty");
	else printf ("constraint is empty");

	int* g_lock_new_const;
	int* g_varnum_new_const;
	byte* g_new_constm;

	int binary_max_num_const = least_upper_binary(max_num_const);
	int n_compare = binary_max_num_const * binary_max_num_const;
	int max_threads_block = 512;
	int bl = max_threads_block < n_compare;

	if(bl) {
		printf("constraint - comparisons (%d) are more than max number of threads(%d) -> exit",
				n_compare, max_threads_block);
		exit(1);
	}
	printf ("max num const: %d\n", binary_max_num_const);

	int blk_c = max_num_const;
	int blk_v = max_threads_block / n_compare;
	dim3 block_solve(blk_v, blk_c, blk_c);

	int gl = num_var / blk_v;
	int grd_x = (gl)? gl : 1;
	dim3 grid_solve(grd_x, 1, 1);

	// this is for collecting sum of varnums in each block.
	// we'll check if one of them are not zero -> iteration needed.
	int* gsum_varnum_grid;
	size_t sz_varnum_grid = sizeof(int) * grid_solve.x;
	CudaSafeCall(cudaMalloc(&gsum_varnum_grid, sz_varnum_grid));
	CudaSafeCall(cudaMemset(gsum_varnum_grid, 0, sz_varnum_grid));

	// Shared memory size definition // for first kernel (solve_constraints)
	size_t shd_solve = 2 * num_var * sizeof(int); // as big as to hold 2 arrays : lock_const, lock_asis

	// Shared memory size definition // for second kernel (or_varnum_grid)
	// for each block, we compute or_varnum_grid_kernel for the block
	// gather to global memory, apply(or_varnum_grid_kernel) again until only one elt left in global.

	//size_t shd_varnum = block_solve.x * sizeof(int);
	int* g_sum_varnum;
	CudaSafeCall(cudaMalloc(&g_sum_varnum, sizeof(int)));
	CudaSafeCall(cudaMemset(g_sum_varnum, 0, sizeof(int)));

	int cnt=0;
	while(!is_const_empty) {

		CudaSafeCall(cudaMemcpy(g_is_const_empty, &is_const_empty, sizeof(int), cudaMemcpyHostToDevice));

		// new constraint - pair
		CudaSafeCall(cudaMalloc(&g_lock_new_const, sz_varnums));
		CudaSafeCall(cudaMemset(g_lock_new_const, 0, sz_varnums));

		CudaSafeCall(cudaMalloc(&g_varnum_new_const, sz_varnums));
		CudaSafeCall(cudaMemset(g_varnum_new_const, 0, sz_varnums));

		CudaSafeCall(cudaMalloc(&g_new_constm, sz_mat));
		CudaSafeCall(cudaMemset(g_new_constm, 0, sz_mat));

		// testing sensor insertion
		int sensor = 101;
		int* g_sensor;
		CudaSafeCall(cudaMalloc(&g_sensor, sizeof(int)));
		CudaSafeCall(cudaMemcpy(g_sensor, &sensor, sizeof(int), cudaMemcpyHostToDevice));

//		// test for thread assignment
//		dim3 g(1,1);
//		dim3 b(1,1,1);
//		printf("is constraint empty? = %d\n", is_const_empty);
//		printf("grid x y = %d, %d\n", grid_solve.x, grid_solve.y);
//		printf("block x y z =  %d, %d, %d\n", block_solve.x, block_solve.y, block_solve.z);

		// g_const_sample to see throught the kernel inside.
		int* g_const_sample;
		CudaSafeCall(cudaMalloc(&g_const_sample, sz_a_const));

		// kernel
		solve_constraints_kernel<<<grid_solve, block_solve, shd_solve>>>(
				num_var, max_num_const, sz_a_const,
				g_varnum_refl, g_reflection,
				g_varnum_const, g_constm,
				g_lock_asis, g_varnum_asis, g_asis,
				g_lock_new_const, g_varnum_new_const, g_new_constm, g_sensor, g_const_sample);


		sensor = 99;
		CudaSafeCall(cudaMemcpy(&sensor, g_sensor, sizeof(int), cudaMemcpyDeviceToHost));
		printf("sensor = %d\n", sensor);

		byte* sample = (byte*)malloc(sz_a_const);
		CudaSafeCall(cudaMemcpy(sample, g_const_sample, sz_a_const, cudaMemcpyDeviceToHost));
		print_a_constraint(sample, var_const_max, is_uniform_var_width);

//		 check emptyness of constraints by adding them all and get is_const_emtpy
		printf("in while empty? = %d\n", is_const_empty);

		int* tmpvarnum = (int*)malloc(sz_varnums);
		CudaSafeCall(cudaMemcpy(tmpvarnum, g_varnum_new_const, sz_varnums, cudaMemcpyDeviceToHost));
		for(i=0;i<num_var;i++)
			printf("%d - varnum const [%d] = %d\n", cnt, i, tmpvarnum[i]);
		cnt++;

		int* gnum_var;
		CudaSafeCall(cudaMalloc(&gnum_var, sizeof(int)));
		CudaSafeCall(cudaMemcpy(gnum_var, &num_var, sizeof(int), cudaMemcpyHostToDevice));
		g_sum_varnum = sum_gpu_kernel_int32 (num_var, gnum_var, g_varnum_new_const);

		int* sum_varnum = (int*) malloc(sizeof(int));
		CudaSafeCall(cudaMemcpy(sum_varnum, g_sum_varnum, sizeof(int), cudaMemcpyDeviceToHost));
		printf("sum of all varnum_const = %d\n", *sum_varnum);

		is_const_empty = 1;//(*sum_varnum == 0) ? 1 : 0; // sun=0 -> empty const -> is_const_emtpy  = 1.
	}

	/*
    cutStopTimer(timerg_exe);
    cutStopTimer(timerg_all);
	*/
	printf("end of kernel invoke\n");

	// test g_varnum_const, g_varnum_asis
	int* varnum_const = (int*)malloc(sz_varnums);
	memset(varnum_const, 0, sz_varnums);
	CudaSafeCall(cudaMemcpy(varnum_const, g_varnum_const, sz_varnums, cudaMemcpyDeviceToHost));

	byte* h_constm = (byte*) malloc(sz_mat);
	CudaSafeCall(cudaMemcpy(h_constm, g_constm, sz_mat, cudaMemcpyDeviceToHost));

	int* varnum_asis = (int*)malloc(sz_varnums);
	memset(varnum_asis, 0, sz_varnums);
	CudaSafeCall(cudaMemcpy(varnum_asis, g_varnum_asis, sz_varnums, cudaMemcpyDeviceToHost));

	byte* h_asis = (byte*) malloc(sz_mat);
	CudaSafeCall(cudaMemcpy(h_asis, g_asis, sz_mat, cudaMemcpyDeviceToHost));

	printf("numvar:%d\n", num_var);
	for(i=0;i<num_var;i+=1) {
		printf("init -- var[%d], numconst:%d, num_ais:%d\n", i, varnum_const[i], varnum_asis[i]);
	}

	int* varnum_new_const = (int*)malloc(sz_varnums);
	memset(varnum_new_const, 0, sz_varnums);
	CudaSafeCall(cudaMemcpy(varnum_new_const, g_varnum_new_const, sz_varnums, cudaMemcpyDeviceToHost));
	for(i=0;i<num_var;i+=1) {
		printf("after exec -- var[%d], numconst:%d, num_ais:%d\n", i, varnum_new_const[i], varnum_asis[i]);
	}

	/*
    double tvg = cutGetTimerValue(timerg_exe);
    printf("gpu time glb(kernel):\n %e \n(%f)(ms)\n", tvg, tvg);
    cutDeleteTimer(timerg_exe);

    double tvga = cutGetTimerValue(timerg_all);
    printf("gpu time glb(kernel+in-copy):\n %e \n(%f)(ms)\n", tvga, tvga);
    cutDeleteTimer(timerg_all);
	*/
	// Stop event
	cudaEventRecord(all_stop, 0);
	cudaEventSynchronize(all_stop);
	float all_elapsedTime;
	cudaEventElapsedTime(&all_elapsedTime, all_start, all_stop); // that's our time!
	// Clean up:
	cudaEventDestroy(all_start);
	cudaEventDestroy(all_stop);

	printf("gpu time glb(all):\n %e \n(%f)(ms)\n", all_elapsedTime, all_elapsedTime);

//    printf("printing - constraints ...\n");
//	print_constraints_gpu(num_var, sz_a_const, varnum_const, h_constm, is_uniform_var_width);
//    printf("printing - asis ...\n");
//	print_constraints_gpu(num_var, sz_a_const, varnum_asis, h_asis, is_uniform_var_width);

	return;
}

extern "C" void sba_solve_stm(SbaStream* ss_in, int num_var, size_t var_const_max, SbaStream* ss_out_analysis,
		int is_uniform_var_width, int is_equal_const_size)
{
	// memalloc/memcpy for ss_in, ss_outconstraints, ss_out_analysis
	// ss_in : host
	SbaStream* ssg_in; //device
	sbastream_alloc_copy(num_var, var_const_max, ss_in, &ssg_in, cudaMemcpyHostToDevice);
	printf("ssg_in\n");

	//  printf("test-----------------------------------------------------------------------------\n");
	//  SbaStream* ssh_in;
	//  sbastream_alloc_copy(num_var, var_const_max, ssg_in, &ssh_in, cudaMemcpyDeviceToHost);
	//  print_constraint_stream(num_var, var_const_max, ssh_in, is_uniform_var_width, is_equal_const_size);
	//
	//  printf("alloc constraint/analysis--------------------------------------------------------\n");

	  // last arg 1 means copying at gpu
	  SbaStream* ss_dfields = (SbaStream*)malloc(sizeof(SbaStream));
	  CudaSafeCall(cudaMemcpy(ss_dfields, ssg_in, sizeof(SbaStream), cudaMemcpyDeviceToHost));

	  int* ssg_cst_num_var;
	  byte** ssg_cst_constnames;
	  byte** ssg_cst_constm;
	  ssg_cst_num_var = init_from_num_const(num_var, 0, GPU);
	  ssg_cst_constnames = init_from_constnames(num_var, ss_dfields->num_const, '\0', GPU);
	  ssg_cst_constm = init_from_constm(num_var, ss_dfields->num_const, var_const_max, '\0', GPU, is_uniform_var_width);

	  int* ssg_anlys_num_var;
	  byte** ssg_anlys_constnames;
	  byte** ssg_anlys_constm;
	  ssg_anlys_num_var = init_from_num_const(num_var, 0, GPU);
	  ssg_anlys_constnames = init_from_constnames(num_var, ss_dfields->num_const, '\0', GPU);
	  ssg_anlys_constm = init_from_constm(num_var, ss_dfields->num_const, var_const_max, '\0', GPU, is_uniform_var_width);

	/* Sbastream from given SbaStream at GPU is not dealt as it is, instead each field are created independently.
	  // ss_out_constraints : host
	  SbaStream* ssg_out_constraints; // ssg_out_constraints
	  sbastream_alloc_copy(num_var, var_const_max, ss_out_constraints, &ssg_out_constraints, cudaMemcpyHostToDevice);
	  printf("ssg_out\n");
	  // ss_out_analysis : host
	  SbaStream* ssg_out_analysis;  // device
	  sbastream_alloc_copy(num_var, var_const_max, ss_out_analysis, &ssg_out_analysis, cudaMemcpyHostToDevice);
	  printf("ssg_out_analysis\n");
	*/

	  int max_const_size = max_num_constraints(num_var, ss_in->num_const);
	  dim3 threads(num_var, max_const_size);
	  dim3 grid(1);

	  init_constraints_kernel_stm<<< grid, threads >>>(
			  ss_dfields->num_const, ss_dfields->constnames, ss_dfields->constm,
			  num_var, var_const_max,
			  ssg_cst_num_var, ssg_cst_constnames, ssg_cst_constm,
			  ssg_anlys_num_var, ssg_anlys_constnames, ssg_anlys_constm,
			  is_uniform_var_width, is_equal_const_size);


	  printf("-------original const---------\n");
	/*  print_constraint_stream(num_var, var_const_max, ss_in, is_uniform_var_width, is_equal_const_size);


	  SbaStream *ss_reflection = copy_from_SbaStream(num_var, var_const_max, ss_out_constraints);

	  printf("-------reflection---------\n");
	  print_constraint_stream(num_var, var_const_max, ss_reflection, is_uniform_var_width, is_equal_const_size);

	  printf("-------pure const---------\n");
	  print_constraint_stream(num_var, var_const_max, ss_out_constraints, is_uniform_var_width, is_equal_const_size);

	  printf("-------analysis-init--------\n");
	  print_constraint_stream(num_var, var_const_max, ss_out_analysis, is_uniform_var_width, is_equal_const_size);

	  // check if constraint stream is empty.
	  int empty_const = is_constraintstream_empty(num_var, var_const_max, ss_out_constraints);
	  printf("constraint is empty? %d\n", empty_const);

	  int while_iter_count = 0;

	  while(!empty_const)
	  {
	    int i;
	    byte* access_lock = (byte*) malloc (sizeof (byte) * num_var);
	    for(i=0;i<num_var;i++) {
	      access_lock[i] = '\0'; // lock deactivated -> okey to update.
	                             // lock activated if '\1'
	      //printf("lock[%d] = %c\n", i, access_lock[i]);
	    }

	    SbaStream *ss_out_new_constraints = SbaStream_init_empty(num_var);

	    //init_constraints_kernel<<grid, threads>>();
	    printf("%dth Iteration\n------------------------------------------------\nGiven ss_out_costraints:\n", while_iter_count);
	    print_constraint_stream(num_var, var_const_max, ss_out_constraints, is_uniform_var_width, is_equal_const_size);
	    print_constraint_stream(num_var, var_const_max, ss_out_analysis, is_uniform_var_width, is_equal_const_size);

	    //iterate for all var / constraints(var).-> fill up ss_out_new_constraints.
	    for(grid=0;grid < num_var;grid++) {
	      printf("-------------------------------------------\nVarNO:%d, NUMber of constraint:%d, w/ thread:%d\n",
	             grid, ss_out_constraints->num_const[grid], threads);

	      for(threads=0;threads < ss_out_constraints->num_const[grid];threads++) {
	        solve_constraints_kernel(ss_reflection, ss_out_constraints, num_var, access_lock,
	                                 ss_out_new_constraints, ss_out_analysis, grid, threads,
	                                 var_const_max, &empty_const);
	      }
	    }

	    //printf("------------------------------------------------\nNewly updated ss_out_costraints:");
	    //print_constraint_stream(num_var, var_const_max, ss_out_constraints, is_uniform_var_width, is_equal_const_size);

	    //printf("------------------------------------------------\nNewly updated ss_out_analysis:");
	    //print_constraint_stream(num_var, var_const_max, ss_out_analysis, is_uniform_var_width, is_equal_const_size);

	    ss_out_constraints = ss_out_new_constraints;

	    while_iter_count++;
	    empty_const = is_constraintstream_empty(num_var, var_const_max, ss_out_constraints);
	    printf("constraint is empty? or not? %d -> check below:\nFinal constraints:", empty_const);
	    //print_constraint_stream(num_var, var_const_max, ss_out_constraints);
	  }

	  printf("While loop ended:%d\n", empty_const);


	  printf("\nreflection printing\n");
	  print_constraint_stream(num_var, var_const_max, ss_reflection, is_uniform_var_width, is_equal_const_size);

	  //printf("\nout_constraint printing\n");
	  //print_constraint_stream(num_var, var_const_max, ss_out_constraints, is_uniform_var_width, is_equal_const_size);

	  printf("\nout_analysis printing\n");
	  print_constraint_stream(num_var, var_const_max, ss_out_analysis, is_uniform_var_width, is_equal_const_size);

	  printf ("Total iteration of kernel:%d\n", while_iter_count);

	*/
}


extern "C" int ffi_tester (int x)
{
  int i;
  for(i=0;i<x;i++) {
    printf("ffi on testing : %d\n", i);
  }
  return 0;
}



