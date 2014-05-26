#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "hashtab.h"
//include the head
#define NUM_TOTAL_CONSTRAINT 8

int main()
{
	char* h  =(char*) malloc(NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);
	bzero(h,NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);
	hash_tab* ht = init_hashtab(4,2,h);
 	put_element(ht,0,strdup("_Ad b   ")); 
	put_element(ht,0,strdup("_lc a c "));
	put_element(ht,1,strdup("_v1     "));

	print_hashtab(ht); 

	char* out=(char*) malloc(NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);
	bzero(out,NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);
	solver_constraint_wrapper(ht,out);
}
