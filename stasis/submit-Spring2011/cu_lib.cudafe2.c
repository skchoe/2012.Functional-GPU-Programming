# 1 "cu_lib.cudafe1.gpu"
# 211 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/stddef.h" 3
typedef unsigned long size_t;
#include "crt/host_runtime.h"
# 145 "/usr/include/bits/types.h" 3
typedef long __clock_t;
# 60 "/usr/include/time.h" 3
typedef __clock_t clock_t;
void *memcpy(void*, const void*, size_t); void *memset(void*, int, size_t);

#include "cu_lib.cudafe2.stub.c"
