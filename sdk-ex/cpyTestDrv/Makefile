
# Add source files here
EXECUTABLE	:= cpyTestDrv
# Cuda source files (compiled with cudacc)
CUBINFILES	:= cpyTestDrv_kernel.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= \
	cpyTestDrv.cpp
USEDRVAPI     := 1
#lib to verify.
SOFILE	:= #libmatrixMul_gold.so

################################################################################
# Rules and targets
include ../_common.mk

all:
	make clean
	nvcc -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I. -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil_$(LIB_ARCH)

	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c *.*~

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cu.c *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx
#gcc -fPIC -shared -o $(SOFILE) matrixMul_gold.cpp -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDAHOME)/lib -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil
