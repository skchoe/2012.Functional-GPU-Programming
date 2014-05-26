# Add source files here
EXECUTABLE	:= _test
# Cuda source files (compiled with cudacc)
CUBINFILES	:= _test_kernel.cu _test.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= 

USEDRVAPI     := 1
#lib to verify.
SOFILE	:=

include ../../_common.mk


all:
	make clean
	nvcc  -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I$(CUDASDKHOME)/common/inc -L. -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib -lcuda -lcutil -lglut -lGLEW
	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx


clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c
