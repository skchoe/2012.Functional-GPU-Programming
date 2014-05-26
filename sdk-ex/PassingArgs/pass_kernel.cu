//#ifndef _MATRIXMUL_KERNEL_H_
//#define _MATRIXMUL_KERNEL_H_

extern "C"

/* Signature:
*/
__global__ void
pass_kernel(
int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, 
int* bargs,
int* barg1)
{
    int i = threadIdx.x;
    switch (i) {
    case 0:
	bargs[0] = arg1 * 10;
	break;
    case 1:
	bargs[1] = arg2 * 10;
	break;
    case 2:
	bargs[2] = arg3 * 10;
	break;
    case 3:
	bargs[3] = arg4 * 10;
	break;
    case 4:
	bargs[4] = arg5 * 10;
	break;
    case 5:
	bargs[5] = arg6 * 10;
	break;
    case 6:
	bargs[6] = arg7 * 10;
	break;
    case 7:
	bargs[7] = arg8 * 10;
	break;
    case 8:
	bargs[8] = arg9 * 10;
	break;
    }

    *barg1 = arg9;
}
