###############################################################################
# Build script for project
###############################################################################

# Add source files here
EXECUTABLE	:= recursiveGaussianDrv
# Cuda source files (compiled with cudacc)
CUFILES		:= recursiveGaussianDrv.cu
CUDEPS		:= recursiveGaussian_kernel.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= \

USEGLLIB	:= 1
USEGLUT		:= 1


###############################################################################
# Rules and targets

include ../_common.mk


all:
	make clean
	nvcc -o $(EXECUTABLE) -keep $(CUBIN_ARCH_FLAG) $(CUDEPS) $(CUFILES) -I$(CUDASDKHOME)/common/inc -L. -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib -lcuda -lcutil_$(LIB_ARCH) -lglut -lGLEW

	mv *.cubin data
	rm *.cu~ *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data/*.cubin obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c
