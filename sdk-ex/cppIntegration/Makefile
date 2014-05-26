################################################################################
#
# Build script for project
#
################################################################################

# Add source files here
EXECUTABLE	:= cppIntegration
# Cuda source files (compiled with cudacc)
CUFILES		:= cppIntegration.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= \
	main.cpp \
	cppIntegration_gold.cpp 
SOFILE		:= libcppIntegration_gold.so


################################################################################
# Rules and targets

include ../_common.mk


all:
	make clean
	nvcc -o $(EXECUTABLE) -keep $(CUFILES) $(CCFILES) -I. -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil_$(LIB_ARCH)
	gcc -fPIC -shared -o $(SOFILE) cppIntegration_gold.cpp -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil_$(LIB_ARCH)
	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx
