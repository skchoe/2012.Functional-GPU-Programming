# Add source files here
EXECUTABLE	:= simpleGLDrv
#EXECUTABLE	:= _test
# Cuda source files (compiled with cudacc)
CUBINFILES	:= simpleGLDrv_kernel.cu simpleGLDrv.cu
#CUBINFILES	:= _test_kernel.cu _test.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= 

USEDRVAPI     := 1
#lib to verify.
SOFILE	:=

include ../_common.mk


all:
	make clean
	nvcc  -o $(EXECUTABLE) -keep $(CUBIN_ARCH_FLAG) $(CUBINFILES) $(CCFILES) -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib -lcuda -lcutil_$(LIB_ARCH) -lGL -lGLU -lglut -lGLEW_$(LIB_ARCH)
	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c *.linkinfo *.*~
