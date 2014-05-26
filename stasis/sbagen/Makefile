
# Add source files here
EXECUTABLE	:= sbagen
# Cuda source files (compiled with cudacc)
CUBINFILES	:= launch_sba.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= \
	driver.c hashfunc.c hashtab.c
USEDRVAPI     := 1
#lib to verify.
SOFILE	:= #libmatrixMul_gold.so

################################################################################
# Rules and targets
CUDAHOME=$(HOME)/local/cuda
CUDASDKHOME=$(HOME)/local/GPU_SDK/C
CUDALIB=$(CUDAHOME)/lib64/linux
LIB_ARCH=x86_64

all:
	make clean
	nvcc -o launch_sba.cu.o $(CUBINFILES) 
	nvcc -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I. -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil_$(LIB_ARCH)

	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c *.*~

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cu.c *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx
#gcc -fPIC -shared -o $(SOFILE) matrixMul_gold.cpp -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDAHOME)/lib -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil
