################################################################################
#
# Build script for project
#
###############################################################################

# Add source files here
EXECUTABLE	:= simpleTextureDrv
# Cuda source files (compiled with cudacc)
#CUFILES		:= simpleTexture.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= simpleTextureDrv.cpp
CUBINFILES      := simpleTexture_kernel.cu
USEDRVAPI     := 1


###############################################################################
# Rules and targets
include ../_common.mk

all:
	make clean
	nvcc -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I. -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil_$(LIB_ARCH)
	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data/*.cubin obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c
