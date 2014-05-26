# Add source files here
EXECUTABLE	:= simpleCUFFTDrv
#EXECUTABLE	:= _test
# Cuda source files (compiled with cudacc)
CUBINFILES	:= simpleCUFFTDrv_kernel.cu
#CUBINFILES	:= _test_kernel.cu _test.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= simpleCUFFTDrv.cpp
#CUFILES		:= main.cpp

USECUFFT     	:= 1
#lib to verify.
SOFILE	:= libsimple_gold.so

################################################################################
# Rules and targets

include ../_common.mk

INCDIR	:= -I. -I$(CUDASDKHOME)/common/inc -I$(CUDAHOME)/include

LIB	:= -lcuda -lcutil_$(LIB_ARCH) -lglut -lGLEW_$(LIB_ARCH)
LIBDIR	:= -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib 

ifeq ($(USECUFFT),1)	
  ifeq ($(emu),1)
    LIB += -lcufftemu
  else	
    LIB += -lcufft
  endif
endif

all:
	make clean
	gcc -fPIC -shared -o  $(SOFILE) simpleCUFFTDrv_gold.cpp $(INCDIR) $(LIBDIR) $(LIB)
	nvcc -o $(EXECUTABLE) -keep $(CUBIN_ARCH_FLAG) $(CCFILES) $(CUBINFILES) $(INCDIR) $(LIBDIR) $(LIB) -lsimple_gold
	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx


clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx
