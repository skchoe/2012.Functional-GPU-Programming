#ifndef __H_HASHTAB__
#define __H_HASHTAB__

#define SIZE_CONSTRAINT 8

typedef struct hashtab{
	int num_variable;
	int num_constraint;
	int size_constraint;
	char *ht;
} hash_tab;

hash_tab* init_hsahtab(int num_var, int num_const, int size_constraint, char* ht);
char* get_element(hash_tab* h, int key, int index, int c_size);
int put_element(hash_tab* h, int key, char* constraint, int c_size);

#endif
