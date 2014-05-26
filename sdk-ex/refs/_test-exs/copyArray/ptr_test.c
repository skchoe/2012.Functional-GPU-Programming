#include <stdio.h>
#include <stdlib.h>

#define ulong unsigned long

void set_location_dev(unsigned long *loc, int size)
{
  float* pos = malloc (size * sizeof(float));

  int i;
  for (i=0;i<size;i++) {
    pos[i] = 0.0002 * (float)i;
    printf("  set-location addr[%d]=%lu w/ val=%f\n", i, (size_t)(pos+i), *(pos+i));
  }

  unsigned long vos = (size_t)pos;
  *loc = vos;

  return;
}

void fill_location_dev(void* loc, int size, float* src)
{
  ulong* nloc = (ulong*)loc;
  float* ptr = (float*)*nloc;

  printf ("fill_location_dev/ loc:%lu\n", (size_t)loc);
  printf ("                 / ptr=loc:%lu\n", (size_t)ptr);
  printf ("                 / *dev_ptr:%f\n", *ptr);

  size_t j;
  for (j=0;j<size;j++){
    printf("src-def'd in fill_loc[%u] = %f, w/addr[%lu]:%f\n", 
      j, ((float*)(ptr))[j], (size_t)(ptr+j), *(ptr+j));
    printf("src-def'd in main[%u] = %f\n", j, (src)[j]);
  }

  size_t i;
  for (i=0;i<size;i++) 
  {
    printf("--   in fill_location_dev w/ ptr:%u=>%f w/addr[%lu]\n", i, ptr[i], (size_t)&(ptr[i]));
    ptr[i] = src[i];
    printf("--   in fill_location_dev w/ newptr:%u=>%f w/addr[%lu]\n", i, ptr[i], (size_t)&(ptr[i]));
  }
}

// we assume loc has float values
void show_location_dev(ulong loc_ptr, int size)
{
  int i;
  float* lp = (float*)(size_t)loc_ptr;
  for(i=0;i<size;i++)
    printf ("loc[%d]=%f, where?:%lu\n", i, lp[i], &(lp[i]));

  return;
}

void set_location(unsigned long** loc, int size)
{
  float* pos = malloc (size * sizeof(float));
  size_t i;
  for (i=0;i<size;i++) 
    pos[i] = 0.0002 * (float)i;
  *loc = pos;
  return;
}

void fill_location(void** here, int size, float* src)
{
  size_t i;
  for(i = 0 ; i < size ; i++)
  {
    printf("src[%d]=%f\n", i, src[i]);
    ((float*)*here)[i] = src[i];
  }
  unsigned long addr_a = (size_t)here;
  unsigned long addr_elt1 = (size_t)*here;
  printf("addr_array=%u\n", addr_a);
  printf("addr_1stelt=%u\n", addr_elt1);
}

int main(int argc, char** argv)
{
  int count = 5;
// data init
  float *src = malloc (sizeof(float)*count);
  size_t j;
  for (j=0;j<count;j++)
    src[j] = (float)j * 0.001f;

// storage init
  unsigned long *loc;
  set_location(&loc, count);

// define storage
  fill_location(&loc, count, src);


  /* Using CUdeviceptr */
  printf ("_________________________________________________________\n");
  ulong loc_dev;  // address of loc[0]
  set_location_dev(&loc_dev, count); //loc_dev:address of address of first elt
  ulong* ptr = (ulong*)(size_t)loc_dev;
  printf("init-alloc loc_dev:%lu, &loc_dev=%lu, loc_dev[0]=%f\n", loc_dev, &loc_dev, ptr[0]);
  printf("||||||||||loc_dev:%lu\n", loc_dev);
  printf("||||||||||ptr=loc_dev:%lu\n", ptr);
  printf("||||||||||*ptr=locdev[0]:%f\n", *ptr);
  printf("||||||||||&ptr=&locdev:%lu\n", &ptr);

  printf("sizeof uint:%lu, sizeof void*=%lu, sizeof unsigned long=%lu\n", 
    sizeof(uint), sizeof(void*), sizeof(ulong));
  printf ("sizeof float:%d, sizeof-ulong:%d\n", sizeof(float), sizeof (ulong));
  for (j=0;j<count;j++)
    printf("src-def'd[%d] = %f\n", j, ((float*)ptr)[j]);

  printf("orig .....cnt:%d\n", count);
  //fill_location_dev(&loc_dev, count, src);
  fill_location_dev(&ptr, count, src);


  printf("final .....ptr:%lu, ..*ptr:%lu\n", (size_t)ptr, *ptr);
  int l;
  for (l=0;l<count;l++)
    printf("filled[%d] = %f\n", l, ((float*)(ptr))[l]);

  return 0;
}
