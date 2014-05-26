#include <stdio.h>
#include <malloc.h>

extern "C"
int foo (int);
extern "C"
void add1f(float*);

extern "C"
int foo (int i)
{
   i=100;
   return 1;
}

extern "C"
void add1f(float* io)
{
   (*io) ++;
}

extern "C"
void vadd1f(float* vio, int n)
{
  for(int i = 0 ; i < n ; i ++)
    vio[i] ++;
}

extern "C"
void vadd1fm(float** vio, int n)
{
  for(int i = 0 ; i < n ; i ++)
    {
      vio[i] = (float*)malloc(sizeof(float)*n);
      (*vio[i]) = (float)(i+1);
    }
}

extern "C"
int main(int argc, char** argv)
{
	printf("output = %d\n", foo(1));

	float f = 200.0f;
	add1f(&f);
	printf("output = %f\n", f);

	int n=3;
	float* v = (float*)malloc(sizeof(float)*n);
	v[0] = 1;
	v[1] = 2;;
	v[2] = 3;

	vadd1f(v, n);

	printf("result = %f, %f, %f\n", v[0], v[1], v[2]);

	return 0;
}
