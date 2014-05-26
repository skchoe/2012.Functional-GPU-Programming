HOME_PATH=/home/u0332192
CUDAHOME=$(HOME_PATH)/local/cuda
CUDASDKHOME=$(HOME_PATH)/local/GPU_SDK/C
GLEWHOME=$(HOME_PATH)/local/glew

# detect if 32 bit or 64 bit system
HP_64 = $(shell uname -m | grep 64)
ifeq "$(strip $(HP_64))" ""
	CUBIN_ARCH_FLAG = -m32
else
	CUBIN_ARCH_FLAG = -m64
endif
