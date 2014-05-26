
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* pragma for ignoring warning from MS c compiler */
//#pragma warning(disable: 4996)
/*
gcc -fPIC -shared -o libout.so string_test.c
*/

size_t size=512;
int j=0;

char* get_string()
{
	char * a = "go to school";
	return a;
}

void get_string_arg (char* str)
{
	char * a = "go to school";

    str = strcpy (str, a);
    printf ("In getstr = %s\n", str);
}

float get_float()
{
	return 10.0;
}

void get_float_arg (float* vft)
{
	size_t i = 0;
	for(i=0;i< 100 ; i++) {
		vft[i] = ((float)i)/100.0f;
	}
}

int main (int argc, char** argv)
{
	char* str;
	void* str1;
 	float* vft;
	int size = 100;
	
	str = get_string();
	printf("OUTPUT string = %s\n", str);

	str1 = malloc(size*sizeof(char));
	get_string_arg((float*)str1);
	printf("OUTPUT2= %s\n", str1);

	vft = (float*)malloc(size*sizeof(float));
	get_float_arg(vft);
	for(j=0;j<size;j++)
	printf("content = %f\t", vft[j]);
	printf("\n");

	printf ("FLOAT = %f\n", get_float());
	return 0;
}

