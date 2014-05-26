# Add source files here
EXECUTABLE	:= simpleGL
#EXECUTABLE	:= _test
# Cuda source files (compiled with cudacc)
CUBINFILES	:= simpleGL.cu
#CUBINFILES	:= _test_kernel.cu _test.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= 

USEDRVAPI     := 1
#lib to verify.
SOFILE	:=

################################################################################
# Rules and targets

include ../_common.mk

#CUBIN_ARCH_FLAG
all:
	make clean
	nvcc -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I$(CUDASDKHOME)/common/inc -I$(GLEWHOME)/include -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib -lcuda -lcutil_$(LIB_ARCH) -lGL -lGLU -lglut -lGLEW_$(LIB_ARCH)
	mkdir data
	mv *.cubin *.ptx data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* 


clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c
