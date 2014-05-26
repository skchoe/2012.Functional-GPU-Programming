################################################################################
#
# Build script for project
#
################################################################################

# Add source files here
EXECUTABLE	:= imageDenoising
# CUDA source files (compiled with cudacc)
CUFILES		:= imageDenoising.cu
# CUDA dependency files
CU_DEPS		:= \
	imageDenoising_copy_kernel.cu \
	imageDenoising_knn_kernel.cu  \
	imageDenoising_nlm_kernel.cu  \
	imageDenoising_nlm2_kernel.cu

# C/C++ source files (compiled with gcc / c++)
CCFILES		:= imageDenoisingGL.cpp bmploader.cpp

USEGLLIB          := 1
USEGLUT           := 1
USERENDERCHECKGL  := 1

################################################################################
# Rules and targets

include ../_common.mk
all:
	make clean
	nvcc -o $(EXECUTABLE) -keep $(CUFILES) $(CUDEPS) -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib -lcuda -lcutil_$(LIB_ARCH) -lglut -lGLEW_$(LIB_ARCH)

	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *~

clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data/*.cubin obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx
