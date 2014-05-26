//#include "hashtab.h"
#include<stdio.h>

#define SIZE_CONSTRAINT 8

typedef struct hashtab{
	int num_variable;
	int num_constraint;
	char *ht;
} hash_tab;

hash_tab* init_hashtab(int num_var, int num_const, char* ht){
	hash_tab* h;
	h = (hash_tab*) malloc(sizeof(hash_tab));
	h->num_variable = num_var;
	h->num_constraint = num_const;
	h->ht = ht;
	return h;
}

char* get_element(hash_tab* h, int key, int index){
	char *start_addr = h->ht+ (key*h->num_variable*SIZE_CONSTRAINT);
	char *elem_addr = start_addr + index*h->num_variable*SIZE_CONSTRAINT;
	return elem_addr;
}

int put_element(hash_tab* h, int key, char* constraint){
	int i;
	char *start_addr = h->ht + (key*h->num_variable*SIZE_CONSTRAINT);
	for (i=0 ; i < h->num_constraint; i ++){
		char* temp = start_addr + i*h->num_variable*SIZE_CONSTRAINT;
		if (*temp == NULL){
			memcpy(temp, constraint, SIZE_CONSTRAINT);
			return 1;
		}
	}	
	return -1;
}

void print_hashtab(hash_tab* h){
	int i,j;
	printf("%s\n", h->ht);
	char* start = h->ht;
	for(i=0; i < h->num_variable; i++){
		printf("i:%d\n",i);
		for(j=0; j < h->num_constraint; j++){
			printf("j:%d\n",j);
			int addr = i*SIZE_CONSTRAINT+j*h->num_variable*SIZE_CONSTRAINT;
			printf("addr:%d\n", addr);
			char* taddr = start + addr;
			if ( taddr != NULL)
				printf("%s\n",taddr);
		}
	}
}

void free_hashtab(hash_tab* h){
	free(h->ht);
	free(h);
}

void main(){
	char* h  =(char*) malloc(4*SIZE_CONSTRAINT);
	memset(h,'\0',4*SIZE_CONSTRAINT);
	hash_tab* ht = init_hashtab(2,2,h);
	put_element(ht,0,(char*) "_Lx x x ");
	print_hashtab(ht);	
				   
}


