#include <stdio.h>
extern int add1(int x);
int main(int argc, char** argv)
{
  int a;
  a = 1;
  int b;
  b = add1(a);
  printf ("Org:%d, output:%d\n", a, b);
  return 0;
}
