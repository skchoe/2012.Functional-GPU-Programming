# Add source files here
EXECUTABLE	:= simpleCUBLAS
#EXECUTABLE	:= _test
# Cuda source files (compiled with cudacc)
# C/C++ source files (compiled with gcc / c++)
CCFILES		:= simpleCUBLAS.c
#CUFILES		:= main.cpp

USECUFFT     	:= 1
USECUBLAS     	:= 1
#lib to verify.
SONAME	:= simple_gold
SOFILE	:= lib$(SONAME).so

################################################################################
# Rules and targets

include ../_common.mk

INCDIR	:= -I. -I$(CUDASDKHOME)/common/inc -I$(CUDAHOME)/include

LIB	:= -lcuda -lcutil_$(LIB_ARCH) -lglut -lGLEW_$(LIB_ARCH)
LIBDIR	:= -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -L$(GLEWHOME)/lib 

ifeq ($(USECUBLAS),1)	
  ifeq ($(emu),1)
    LIB += -lcublasemu
  else	
    LIB += -lcublas
  endif
endif

all:
	make clean
	gcc -fPIC -shared -o  $(SOFILE) simpleCUBLAS_gold.c $(INCDIR) $(LIBDIR) $(LIB)
	nvcc -o $(EXECUTABLE) -keep $(CUBIN_ARCH_FLAG) $(CCFILES) $(INCDIR) $(LIBDIR) $(LIB) -l$(SONAME)
	mkdir data
	mv *.cubin data
	rm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.c~ *.cpp~


clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.c~
