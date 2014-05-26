#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hashtab.h"

#define SIZE_CONSTRAINT 8

hash_tab* init_hashtab(int num_var, int num_const, char* ht){
	hash_tab* h;
	h = (hash_tab*) malloc(sizeof(hash_tab));
	h->num_variable = num_var;
	h->num_constraint = num_const;
	h->ht = ht;
	return h;
}

char* get_element(hash_tab* h, int key, int index){
	int row = (key + index*h->num_variable)*SIZE_CONSTRAINT;
	char *elem_addr = h->ht + row;
	return strndup(elem_addr, SIZE_CONSTRAINT);
}


int put_element(hash_tab* h, int key, char* constraint){
	int i;
	//printf("put_element:(key:%d, constraint:%s)\n", key, constraint);
	for (i=0 ; i < h->num_constraint; i++){
		int row = (key + i*h->num_variable)*SIZE_CONSTRAINT;
		char* temp = h->ht + row;
		//printf("at:%d %s\n", row, temp);
		if (*temp == '\0'){
			memcpy(temp, constraint, SIZE_CONSTRAINT);
			return 1;
		}
	}	
	return -1;
}

void print_hashtab(hash_tab* h){
	int i,j;
	char* start = h->ht;
	for(i=0; i < h->num_variable; i++){
		for(j=0; j < h->num_constraint; j++){
			int addr = i*SIZE_CONSTRAINT+j*h->num_variable*SIZE_CONSTRAINT;
			printf("[%d,%d]",i,j);
			char* taddr = start + addr;
			if ( taddr != NULL)
				printf("%8s",get_element(h,i,j));
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
	char* h  =(char*) malloc(6*SIZE_CONSTRAINT);
	memset(h,'\0',4*SIZE_CONSTRAINT);
	hash_tab* ht = init_hashtab(3,2,h);
	put_element(ht,0,(char*) "_Lx x x ");
	put_element(ht,0,(char*) "_Ax z ");
	put_element(ht,1,(char*) "_cy1y2");
	put_element(ht,1,(char*) "_ax");
	put_element(ht,2,(char*) "_Px");	
	print_hashtab(ht);	
} */


