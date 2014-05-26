/*
 * test.c
 *
 *  Created on: Feb 1, 2012
 *      Author: u0332192
 */

#include <stdio.h>


int ffi_tester (int x)
{
  int i;
  for(i=0;i<x;i++) {
    printf("ffi on testing : %d\n", i);
  }
  return 0;
}

int main(int argc, char** argv)
{

	int x;
	x = ffi_tester (1);

	printf("%d\n", x);

	return 0;
}
