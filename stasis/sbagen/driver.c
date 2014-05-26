#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include <cuda.h>
//#include <cutil.h>

#include "hashtab.h"
#include "def.h"

int main()
{
	char* h  =(char*) malloc(NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);
	bzero(h,NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);
/*
	hash_tab* ht = init_hashtab(4,2,h);
 	put_element(ht,0,strdup("_Ad b   ")); 
	put_element(ht,0,strdup("_lc a c "));
	put_element(ht,1,strdup("_v1     "));

	print_hashtab(ht); 

	hash_tab* ht2 = init_hashtab(10,3,h);
	put_element(ht2,0,"_Af d   ");
	put_element(ht2,0,"_Ai h   ");
	put_element(ht2,0,"_lj j j ");
	put_element(ht2,2,"_Cb     ");
	put_element(ht2,2,"_Dh     ");
	put_element(ht2,2,"_cd d   ");
	put_element(ht2,3,"_v1     ");
	put_element(ht2,4,"_v3     "); 
*/
	hash_tab* ht3 = init_hashtab(BLOCK_SIZE_X, BLOCK_SIZE_Y, h);

/*
put contraints into a constraint hash table.
this data is generated by racket program.
*/
put_element(ht3, 0, "_lj j j ");
put_element(ht3, 1, "_lj j j ");
put_element(ht3, 2, "_lj j j ");
put_element(ht3, 3, "_lj j j ");
put_element(ht3, 4, "_lj j j ");
put_element(ht3, 5, "_lj j j ");
put_element(ht3, 6, "_lj j j ");
put_element(ht3, 7, "_lj j j ");
put_element(ht3, 8, "_lj j j ");
put_element(ht3, 10, "_lj j j ");
put_element(ht3, 11, "_lj j j ");
put_element(ht3, 12, "_lj j j ");
put_element(ht3, 13, "_v1     ");
put_element(ht3, 0, "_Ao n   ");
put_element(ht3, 1, "_Ap o   ");
put_element(ht3, 2, "_Aq p   ");
put_element(ht3, 3, "_Ar q   ");
put_element(ht3, 4, "_As r   ");
put_element(ht3, 5, "_At s   ");
put_element(ht3, 6, "_Au t   ");
put_element(ht3, 7, "_Av u   ");
put_element(ht3, 8, "_Aw v   ");
put_element(ht3, 10, "_Ay w   ");
put_element(ht3, 11, "_Az y   ");
put_element(ht3, 26, "_co p   ");
put_element(ht3, 27, "_cq r   ");
put_element(ht3, 28, "_cs t   ");
put_element(ht3, 29, "_cu v   ");
put_element(ht3, 30, "_cw x   ");
put_element(ht3, 31, "_cy z   ");
put_element(ht3, 32, "_co z   ");
put_element(ht3, 33, "_cp y   ");
put_element(ht3, 34, "_cq x   ");
put_element(ht3, 35, "_cr w   ");
put_element(ht3, 36, "_cs v   ");
put_element(ht3, 37, "_ct u   ");
put_element(ht3, 26, "_CM     ");
put_element(ht3, 27, "_CN     ");
put_element(ht3, 28, "_CO     ");
put_element(ht3, 29, "_CP     ");
put_element(ht3, 30, "_CQ     ");
put_element(ht3, 31, "_CR     ");
put_element(ht3, 32, "_DS     ");
put_element(ht3, 33, "_DT     ");
put_element(ht3, 34, "_DU     ");
put_element(ht3, 35, "_DV     ");
put_element(ht3, 36, "_DW     ");
put_element(ht3, 37, "_DX     ");
put_element(ht3, 52, "_lj j j ");
put_element(ht3, 53, "_lj j j ");
put_element(ht3, 54, "_lj j j ");
put_element(ht3, 55, "_lj j j ");
put_element(ht3, 56, "_lj j j ");
put_element(ht3, 57, "_lj j j ");
put_element(ht3, 58, "_lj j j ");
put_element(ht3, 59, "_lj j j ");
put_element(ht3, 60, "_lj j j ");
put_element(ht3, 62, "_lj j j ");
put_element(ht3, 63, "_lj j j ");
put_element(ht3, 64, "_lj j j ");
put_element(ht3, 65, "_v1     ");
put_element(ht3, 52, "_Aaoan  ");
put_element(ht3, 53, "_Aapao  ");
put_element(ht3, 54, "_Aaqap  ");
put_element(ht3, 55, "_Aaraq  ");
put_element(ht3, 56, "_Aasar  ");
put_element(ht3, 57, "_Aatas  ");
put_element(ht3, 58, "_Aauat  ");
put_element(ht3, 59, "_Aavau  ");
put_element(ht3, 60, "_Aawav  ");
put_element(ht3, 62, "_Aayaw  ");
put_element(ht3, 63, "_Aazay  ");
put_element(ht3, 78, "_caoap  ");
put_element(ht3, 79, "_caqar  ");
put_element(ht3, 80, "_casat  ");
put_element(ht3, 81, "_cauav  ");
put_element(ht3, 82, "_cawax  ");
put_element(ht3, 83, "_cayaz  ");
put_element(ht3, 84, "_caoaz  ");
put_element(ht3, 85, "_capay  ");
put_element(ht3, 86, "_caqax  ");
put_element(ht3, 87, "_caraw  ");
put_element(ht3, 88, "_casav  ");
put_element(ht3, 89, "_catau  ");
put_element(ht3, 78, "_CaM    ");
put_element(ht3, 79, "_CaN    ");
put_element(ht3, 80, "_CaO    ");
put_element(ht3, 81, "_CaP    ");
put_element(ht3, 82, "_CaQ    ");
put_element(ht3, 83, "_CaR    ");
put_element(ht3, 84, "_DaS    ");
put_element(ht3, 85, "_DaT    ");
put_element(ht3, 86, "_DaU    ");
put_element(ht3, 87, "_DaV    ");
put_element(ht3, 88, "_DaW    ");
put_element(ht3, 89, "_DaX    ");

	char* out=(char*) malloc(NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);
	bzero(out,NUM_TOTAL_CONSTRAINT*SIZE_CONSTRAINT);

	printf("INPUT CONSTRAINTS:\n");
	print_hashtab(ht3);
	printf("\n\n");
	
	// Call a global function solving constraints
	solver_constraint_wrapper(ht3,out);

	return;
}
