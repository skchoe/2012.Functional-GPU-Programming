/*
 * prints.c
 *
 *  Created on: Mar 15, 2012
 *      Author: u0332192
 */

/*
Type
Minimum Value
Maximum Value

signed char(1)
-127
127

unsigned char
0
255

short(2)
-32767
32767

unsigned short
0
65535

int(4)
-32767
32767

unsigned int
0
65535

long(8)
-2147483647
2147483647

unsigned long
0
4294967295

signed long long (16)
-9223372036854775807
9223372036854775807

unsigned long long
0
18446744073709551615
*/

#include <stdio.h>
#include <limits.h>

void main()
{
          printf("Signed char minimum value: %d\n", SCHAR_MIN );
          printf("Signed char maximum value: %d\n", SCHAR_MAX );
          printf("Unsigned char minimum value: %d\n", 0 );
          printf("Unsigned char maximum value: %d\n", UCHAR_MAX );
          printf("Char minimum value: %d\n", CHAR_MIN );
          printf("Char maximum value: %d\n", CHAR_MAX );
          printf("Signed short minimum value: %d\n", SHRT_MIN );
          printf("Signed short maximum value: %d\n", SHRT_MAX );
          printf("Unsigned short minimum value: %d\n", 0 );
          printf("Unsigned short maximum value: %d\n", USHRT_MAX );
          printf("Signed int minimum value: %d\n", INT_MIN );
          printf("Signed int maximum value: %d\n", INT_MAX );
          printf("Unsigned int minimum value: %u\n", 0 );
          printf("Unsigned int maximum value: %u\n", UINT_MAX );
          printf("Signed long minimum value: %ld\n", LONG_MIN );
          printf("Signed long maximum value: %ld\n", LONG_MAX );
          printf("Unsigned long minimum value: %lu\n", 0 );
          printf("Unsigned long maximum value: %lu\n", ULONG_MAX );
          printf("Signed long long minimum value: %lld\n", LLONG_MIN );
          printf("Signed long long maximum value: %lld\n", LLONG_MAX );
          printf("Unsigned long long minimum value: %lu\n", 0 );
          printf("Unsigned long long maximum value: %llu\n", ULLONG_MAX );

          return;
}
