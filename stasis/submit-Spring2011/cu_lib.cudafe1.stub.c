#include "crt/host_runtime.h"
#include "cu_lib.fatbin.c"
extern void __device_stub__Z23init_constraints_kernelPciiiS_S_Pi(char *, int, int, const int, char *, char *, int *);
extern void __device_stub__Z24solve_constraints_kernelPcS_iiS_S_PiS_S_(char *, char *, int, int, char *, char *, int *, char *, char *);
static void __sti____cudaRegisterAll_14_cu_lib_cpp1_ii_4113a743(void) __attribute__((__constructor__));
void __device_stub__Z23init_constraints_kernelPciiiS_S_Pi(char *__par0, int __par1, int __par2, const int __par3, char *__par4, char *__par5, int *__par6){__cudaSetupArgSimple(__par0, 0UL);__cudaSetupArgSimple(__par1, 8UL);__cudaSetupArgSimple(__par2, 12UL);__cudaSetupArgSimple(__par3, 16UL);__cudaSetupArgSimple(__par4, 24UL);__cudaSetupArgSimple(__par5, 32UL);__cudaSetupArgSimple(__par6, 40UL);__cudaLaunch(((char *)((void ( *)(char *, int, int, const int, char *, char *, int *))init_constraints_kernel)));}
void init_constraints_kernel( char *__cuda_0,int __cuda_1,int __cuda_2,const int __cuda_3,char *__cuda_4,char *__cuda_5,int *__cuda_6)
# 81 "cu_lib.cu"
{__device_stub__Z23init_constraints_kernelPciiiS_S_Pi( __cuda_0,__cuda_1,__cuda_2,__cuda_3,__cuda_4,__cuda_5,__cuda_6);
# 95 "cu_lib.cu"
}
# 1 "cu_lib.cudafe1.stub.c"
void __device_stub__Z24solve_constraints_kernelPcS_iiS_S_PiS_S_( char *__par0,  char *__par1,  int __par2,  int __par3,  char *__par4,  char *__par5,  int *__par6,  char *__par7,  char *__par8) {  __cudaSetupArgSimple(__par0, 0UL); __cudaSetupArgSimple(__par1, 8UL); __cudaSetupArgSimple(__par2, 16UL); __cudaSetupArgSimple(__par3, 20UL); __cudaSetupArgSimple(__par4, 24UL); __cudaSetupArgSimple(__par5, 32UL); __cudaSetupArgSimple(__par6, 40UL); __cudaSetupArgSimple(__par7, 48UL); __cudaSetupArgSimple(__par8, 56UL); __cudaLaunch(((char *)((void ( *)(char *, char *, int, int, char *, char *, int *, char *, char *))solve_constraints_kernel))); }
void solve_constraints_kernel( char *__cuda_0,char *__cuda_1,int __cuda_2,int __cuda_3,char *__cuda_4,char *__cuda_5,int *__cuda_6,char *__cuda_7,char *__cuda_8)
# 100 "cu_lib.cu"
{__device_stub__Z24solve_constraints_kernelPcS_iiS_S_PiS_S_( __cuda_0,__cuda_1,__cuda_2,__cuda_3,__cuda_4,__cuda_5,__cuda_6,__cuda_7,__cuda_8);
# 176 "cu_lib.cu"
}
# 1 "cu_lib.cudafe1.stub.c"
static void __sti____cudaRegisterAll_14_cu_lib_cpp1_ii_4113a743(void) {  __cudaRegisterBinary(); __cudaRegisterEntry(((void ( *)(char *, char *, int, int, char *, char *, int *, char *, char *))solve_constraints_kernel), solve_constraints_kernel, (-1)); __cudaRegisterEntry(((void ( *)(char *, int, int, const int, char *, char *, int *))init_constraints_kernel), init_constraints_kernel, (-1));  }
