#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hashtab.h"
#include "def.h"

//include the head

int main()
{
	unsigned int c_size = 8;
	char* h  =(char*) malloc(NUM_TOTAL_CONSTRAINT*c_size);
	bzero(h,NUM_TOTAL_CONSTRAINT*c_size);

	hash_tab* ht = (hash_tab*) init_hashtab(BLOCK_SIZE_X,BLOCK_SIZE_Y,c_size,h);

/* example 1
	put_element(ht, 0, "_lx x x ", c_size);
	put_element(ht, 1, "_v1     ", c_size);
	put_element(ht, 0, "_Ac b   ", c_size);
*/

///* example 2
	put_element(ht,0,"_Af d   ", c_size);
	put_element(ht,0,"_Ai h   ", c_size);
	put_element(ht,0,"_lj j j ", c_size);
	put_element(ht,2,"_Cb     ", c_size);
	put_element(ht,2,"_Dh     ", c_size);
	put_element(ht,2,"_cd d   ", c_size);
	put_element(ht,3,"_v1     ", c_size);
	put_element(ht,4,"_v3     ", c_size); 
//*/


/* example 3
put_element(ht, 0, "_lj j j ", c_size);
put_element(ht, 1, "_lj j j ", c_size);
put_element(ht, 2, "_lj j j ", c_size);
put_element(ht, 3, "_lj j j ", c_size);
put_element(ht, 4, "_lj j j ", c_size);
put_element(ht, 5, "_lj j j ", c_size);
put_element(ht, 6, "_lj j j ", c_size);
put_element(ht, 7, "_lj j j ", c_size);
put_element(ht, 8, "_lj j j ", c_size);
put_element(ht, 10, "_lj j j ", c_size);
put_element(ht, 11, "_lj j j ", c_size);
put_element(ht, 12, "_lj j j ", c_size);
put_element(ht, 13, "_v1     ", c_size);
put_element(ht, 0, "_Ao n   ", c_size);
put_element(ht, 1, "_Ap o   ", c_size);
put_element(ht, 2, "_Aq p   ", c_size);
put_element(ht, 3, "_Ar q   ", c_size);
put_element(ht, 4, "_As r   ", c_size);
put_element(ht, 5, "_At s   ", c_size);
put_element(ht, 6, "_Au t   ", c_size);
put_element(ht, 7, "_Av u   ", c_size);
put_element(ht, 8, "_Aw v   ", c_size);
put_element(ht, 10, "_Ay w   ", c_size);
put_element(ht, 11, "_Az y   ", c_size);
put_element(ht, 26, "_co p   ", c_size);
put_element(ht, 27, "_cq r   ", c_size);
put_element(ht, 28, "_cs t   ", c_size);
put_element(ht, 29, "_cu v   ", c_size);
put_element(ht, 30, "_cw x   ", c_size);
put_element(ht, 31, "_cy z   ", c_size);
put_element(ht, 32, "_co z   ", c_size);
put_element(ht, 33, "_cp y   ", c_size);
put_element(ht, 34, "_cq x   ", c_size);
put_element(ht, 35, "_cr w   ", c_size);
put_element(ht, 36, "_cs v   ", c_size);
put_element(ht, 37, "_ct u   ", c_size);
put_element(ht, 26, "_CM     ", c_size);
put_element(ht, 27, "_CN     ", c_size);
put_element(ht, 28, "_CO     ", c_size);
put_element(ht, 29, "_CP     ", c_size);
put_element(ht, 30, "_CQ     ", c_size);
put_element(ht, 31, "_CR     ", c_size);
put_element(ht, 32, "_DS     ", c_size);
put_element(ht, 33, "_DT     ", c_size);
put_element(ht, 34, "_DU     ", c_size);
put_element(ht, 35, "_DV     ", c_size);
put_element(ht, 36, "_DW     ", c_size);
put_element(ht, 37, "_DX     ", c_size);
put_element(ht, 52, "_lj j j ", c_size);
put_element(ht, 53, "_lj j j ", c_size);
put_element(ht, 54, "_lj j j ", c_size);
put_element(ht, 55, "_lj j j ", c_size);
put_element(ht, 56, "_lj j j ", c_size);
put_element(ht, 57, "_lj j j ", c_size);
put_element(ht, 58, "_lj j j ", c_size);
put_element(ht, 59, "_lj j j ", c_size);
put_element(ht, 60, "_lj j j ", c_size);
put_element(ht, 62, "_lj j j ", c_size);
put_element(ht, 63, "_lj j j ", c_size);
put_element(ht, 64, "_lj j j ", c_size);
put_element(ht, 65, "_v1     ", c_size);
put_element(ht, 52, "_Aaoan  ", c_size);
put_element(ht, 53, "_Aapao  ", c_size);
put_element(ht, 54, "_Aaqap  ", c_size);
put_element(ht, 55, "_Aaraq  ", c_size);
put_element(ht, 56, "_Aasar  ", c_size);
put_element(ht, 57, "_Aatas  ", c_size);
put_element(ht, 58, "_Aauat  ", c_size);
put_element(ht, 59, "_Aavau  ", c_size);
put_element(ht, 60, "_Aawav  ", c_size);
put_element(ht, 62, "_Aayaw  ", c_size);
put_element(ht, 63, "_Aazay  ", c_size);
put_element(ht, 78, "_caoap  ", c_size);
put_element(ht, 79, "_caqar  ", c_size);
put_element(ht, 80, "_casat  ", c_size);
put_element(ht, 81, "_cauav  ", c_size);
put_element(ht, 82, "_cawax  ", c_size);
put_element(ht, 83, "_cayaz  ", c_size);
put_element(ht, 84, "_caoaz  ", c_size);
put_element(ht, 85, "_capay  ", c_size);
put_element(ht, 86, "_caqax  ", c_size);
put_element(ht, 87, "_caraw  ", c_size);
put_element(ht, 88, "_casav  ", c_size);
put_element(ht, 89, "_catau  ", c_size);
put_element(ht, 78, "_CaM    ", c_size);
put_element(ht, 79, "_CaN    ", c_size);
put_element(ht, 80, "_CaO    ", c_size);
put_element(ht, 81, "_CaP    ", c_size);
put_element(ht, 82, "_CaQ    ", c_size);
put_element(ht, 83, "_CaR    ", c_size);
put_element(ht, 84, "_DaS    ", c_size);
put_element(ht, 85, "_DaT    ", c_size);
put_element(ht, 86, "_DaU    ", c_size);
put_element(ht, 87, "_DaV    ", c_size);
put_element(ht, 88, "_DaW    ", c_size);
put_element(ht, 89, "_DaX    ", c_size);
*/
  	printf ("Num total constraints = %d  as below:\n", NUM_TOTAL_CONSTRAINT);
	print_hashtab(ht); 
	printf("\n\n");

	char* out=(char*) malloc(NUM_TOTAL_CONSTRAINT*c_size);
	bzero(out,NUM_TOTAL_CONSTRAINT*c_size);
	
	// Call a global function solving constraints
	solver_constraint_wrapper(ht,out);

	free(out);
	return;
}
