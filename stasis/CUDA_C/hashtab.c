#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hashtab.h"

hash_tab* init_hashtab(int num_var, int num_const, int size_constraint, char* ht){
	hash_tab* h;
	h = (hash_tab*) malloc(sizeof(hash_tab));
	h->num_variable = num_var;
	h->num_constraint = num_const;
	h->size_constraint = size_constraint;
	h->ht = ht;
	return h;
}

char* get_element(hash_tab* h, int key, int index, int c_size){
	int row = (key + index*h->num_variable)*c_size;
	char *elem_addr = h->ht + row;
	return strndup(elem_addr, c_size);
}


int put_element(hash_tab* h, int key, char* constraint, int c_size){
	int i;
	//printf("put_element:(key:%d, constraint:%s)\n", key, constraint);
	for (i=0 ; i < h->num_constraint; i++){
		int row = (key + i*h->num_variable)*c_size;
		char* temp = h->ht + row;
		//printf("at:%d %s\n", row, temp);
		if (*temp == '\0'){
			memcpy(temp, constraint, c_size);
			return 1;
		}
	}	
	return -1;
}

void print_hashtab(hash_tab* h, int c_size){
	int i,j;
	char* start = h->ht;
	for(i=0; i < h->num_variable; i++){
		for(j=0; j < h->num_constraint; j++){
			int addr = i*c_size+j*h->num_variable*c_size;
			printf("[%d,%d]",i,j);
			char* taddr = start + addr;
			if ( taddr != NULL)
				printf("%8s",get_element(h,i,j,c_size));
		}
		printf("\n");
	}
}

void free_hashtab(hash_tab* h){
	free(h->ht);
	free(h);
}
/*
void main(){
	int csize = 8;
	char* h  =(char*) malloc(6*csize);
	memset(h,'\0',4*csize);
	hash_tab* ht = init_hashtab(3,2,csize,h);
	put_element(ht,0,(char*) "_Lx x x ", c_size);
	put_element(ht,0,(char*) "_Ax z ", c_size);
	put_element(ht,1,(char*) "_cy1y2", c_size);
	put_element(ht,1,(char*) "_ax", c_size);
	put_element(ht,2,(char*) "_Px", c_size);	
	print_hashtab(ht, csize);	
} */


