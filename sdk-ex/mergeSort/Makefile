
# Add source files here
EXECUTABLE	:= mergeSort

# CUDA source files (compiled with cudacc)
CUFILES         := bitonic.cu mergeSort.cu

# CUDA dependency files
CU_DEPS		:= mergeSort_common.h 

# C/C++ source files (compiled with gcc / c++)
CCFILES		:= main.cpp mergeSort_host.cpp mergeSort_validate.cpp 

include ../_common.mk
################################################################################
# Rules and targets

all:
	make clean
	nvcc -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I$(CUDASDKHOME)/common/inc -I$(CUDASDKSHDHOME)/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib -lcuda -lcutil_$(LIB_ARCH) -lglut -lGLEW
	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c
