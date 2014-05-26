#include <stdio.h>
#include "cutilc.h"

int main(int argc, char** argv)
{
  fprintf(stderr, "TEST\n");
  const char* filename = "data/lena.ppm";
  uint* h_img = NULL;
  uint width, height;
  int result = cutLoadPPM4ub(filename, (uchar**)&h_img, &width, &height);
  printf("result of loading  = %d: %d x %d\n", result, width, height);
  return 0;
}
