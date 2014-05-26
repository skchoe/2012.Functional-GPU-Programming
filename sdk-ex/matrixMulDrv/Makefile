
# Add source files here
EXECUTABLE	:= matrixMulDrv
# Cuda source files (compiled with cudacc)
CUBINFILES	:= matrixMul_kernel.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= \
	matrixMul_gold.cpp matrixMulDrv.cpp
USEDRVAPI     := 1
#lib to verify.
SOFILE	:= libmatrixMul_gold.so

################################################################################
# Rules and targets
include ../_common.mk

all:
	make clean
	gcc -fPIC -shared -o $(SOFILE) matrixMul_gold.cpp -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib -lcuda -lcutil_x86_64 -lGL -lGLEW -lGLU -lglut
	nvcc -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I. -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDAHOME)/lib -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil_x86_64
	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c *.*~
