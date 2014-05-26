
# detect OS
OSUPPER = $(shell uname -s 2>/dev/null | tr [:lower:] [:upper:])
OSLOWER = $(shell uname -s 2>/dev/null | tr [:upper:] [:lower:])

# 'linux' is output for Linux system, 'darwin' for OS X
DARWIN = $(strip $(findstring DARWIN, $(OSUPPER)))
ifneq ($(DARWIN),)
  HOME_PATH=/usr
  CUDAHOME=$(HOME_PATH)/local/cuda
  CUDALIB=$(CUDAHOME)/lib
  CUDASDKHOME=/Developer/GPU\ Computing/C
  CUDASDKSHDHOME=/Developer/GPU\ Computing/shared
else
  HOME_PATH=$(HOME)
  CUDAHOME=$(HOME_PATH)/local/cuda
  CUDALIB=$(CUDAHOME)/lib64
  CUDASDKHOME=$(HOME_PATH)/local/GPU_SDK/C
  CUDASDKSHDHOME=$(HOME_PATH)/local/GPU_SDK/shared
endif

GLEWHOME=$(HOME_PATH)/local/glew
CUTIL_STATIC=$(HOME_PATH)/local/GPU_SDK/C/lib/libcutil_x86_64.a


# detect if 32 bit or 64 bit system
HP_64 = $(shell uname -m | grep 64)
OSARCH = $(shell uname -m)
LIB_ARCH = $(OSARCH)
ifeq "$(strip $(HP_64))" ""
	CUBIN_ARCH_FLAG = -m32
else
	CUBIN_ARCH_FLAG = -m64
endif
