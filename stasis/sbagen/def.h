#ifndef _H_DEF__
#define _H_DEF__

#include <stdio.h>
#include "hashtab.h"
#include "../../inc/sizetype2.h"

#define NUM_TOTAL_CONSTRAINT 312

#define BLOCK_SIZE_X 104
#define BLOCK_SIZE_Y 3

#ifdef __cplusplus 
extern "C" {
void solver_constraint_wrapper(hash_tab* c, char* out_analysis);
}
#endif


#endif



