#ifndef __CU_LIB_H_
#define __CU_LIB_H_
#include "hashtab.h"

#define BLOCK_SIZE_X 8
#define BLOCK_SIZE_Y 1
extern "C" {
void solver_constraint_wrapper(hash_tab* c, char* out_analysis);
}

#endif
