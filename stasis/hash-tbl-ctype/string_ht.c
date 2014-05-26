#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#define max_char 20
int M;

// hash table structure
// 1 dimensional array for with element size: max_char
// Insert e into hash table HT
void put(char* tbl, char* key, char* value) 
{
  int idx = hash(key);
  int length = strlen(value);
  strcpy(tbl+idx*max_char, value);
}


char* get(char* tbl, char* key)
{
  int idx = hash(key);
  return (char*)(tbl+idx*max_char);
}


// 48~122 ascii for digit to char.
int hash (char* x) {
  int n = 0;
  char str[10];
  strcpy(str, x);

  int i;
  for(i=0;i<strlen(str);i++)
  {
    n+=(str[i]-'0');
    //printf ("%c, %d, %d, %d\n", str[i], str[i], 0, str[i]-'0');
  }

  printf("%s, %lu\n%s, %lu\n%d\n", x, strlen(x), str, strlen(str),n);
  return n;
}

int main (int argc, char** argv)
{
  // sizeof table = number of possible values
  char* Max = "ZZ";
  int size = hash(Max);
  M = size;
  printf("size=%d\n", size);
  int i;
  char* ht;
  for(i=0;i<size;i++) 
  {
    ht = (char*) calloc (size, max_char*sizeof(char));
  }
  char key [] = "v1";
  char str [] = "TEST";
  put(ht, key, str);
  char* v = get(ht, key);

  printf("get char:%s\n", v);
}
