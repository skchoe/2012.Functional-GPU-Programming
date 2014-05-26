/*
 * main.c
 *
 *  Created on: Mar 8, 2012
 *      Author: u0332192
 */


#include <stdio.h>
#include <math.h>

unsigned int least_upper_binary(float x)
{
	return (unsigned int)pow(2, ceil(log10(x) / log10(2)));
}

unsigned int size2store(float x)
{
	unsigned int lub = least_upper_binary(x);
	float bits = log10(lub) / log10(2);
	float bytes = ceil(bits / 8); // 8 bits for a byte.

	return least_upper_binary(bytes);
}


int main(int argc, char** argv)
{
	float x = 7.5;

	float y = log10(x) / log10(2);
	float z = ceil(y);
	float w = pow (2, z);

	printf("input:%f, \nans:%f, %f, %d\n", x, y, z, (int)w);
	printf("ans:%d\n", least_upper_binary(x));

	int exp = 20;
	int num_var = pow(2, 20);
	int by = size2store(num_var);
	printf("num_var = %d, bytes4store = %d\n", num_var, by);

	printf("remainder between integer: %d %d - %d\n", 100, 3, 100 % 3);
	return 0;
}
