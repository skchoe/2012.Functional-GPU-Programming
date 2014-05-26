/* Test of binary tree summation */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include "bin_tree_sum.h"


main(int argc, char *argv[])
{
  int    max_size, i, n;
  float  val, sum1=0.0f, sum3=0.0f;
  double sum2=0.0;

  max_size = 1000000;
  bin_tree_sum_init(max_size);

  for (i=0; i<max_size; i++) {
    val = ((float)rand()) / ((float)RAND_MAX);
    sum1 += val;
    sum2 += val;
    bin_tree_sum_inc(val);
  }
  sum3 = bin_tree_sum_value();

  printf("tree factor = %d \n",bin_tree_factor);
  printf("float accumulator sum  = %f \n",sum1);
  printf("double accumulator sum = %f \n",sum2);
  printf("float binary tree sum  = %f \n",sum3);
}

