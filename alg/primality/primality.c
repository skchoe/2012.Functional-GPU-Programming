#include <stdio.h>
#include <stdlib.h>
#include <math.h>


// let's see 0 false, 1 true
int is_prime(unsigned long input)
{
  if(input <= 1) return 0;
  else {
    unsigned long sqr = (unsigned long) sqrt((double)input);
    printf ("sqr of input %d = %d\n", input, sqr);

    int k = 2;
    while(1) {

      if(k <= sqr) {
        lldiv_t quot_rem = lldiv(input, k);
        //printf("%d div by %d, quot:%d, rem:%d\n", input, k, quot_rem.quot, quot_rem.rem);

        if (quot_rem.rem == 0) return 0;
        else k++;
      }
      else return 1;
    }
  }

  return 1;
}




int main(int argc, char** argv)
{
  unsigned long input = atol(argv[1]);
  printf ("input = %d, %d\n", input, sizeof(unsigned long));

  int b = is_prime(input);
  if (b)
    printf("%d is prime\n", input);
  else
    printf("%d is not prime\n", input);

  return 0;
}
