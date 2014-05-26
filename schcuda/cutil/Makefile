# Add source files here
EXECUTABLE	:= cutil_image
#EXECUTABLE	:= _test
# Cuda source files (compiled with cudacc)
#CUBINFILES	:= _test_kernel.cu _test.cu
# C/C++ source files (compiled with gcc / c++)
CCLIBSRC	:= cutil_image.c
CCAPPSRC	:= cutil_image.c cutil_app.c

SOFILE=libcutil_image.so

USEDRVAPI     := 1
#lib to verify.
SOFILE	:=

include ../../sdk-ex/_common.mk

all:
	make clean
	gcc  -fPIC -shared -o libcutil_image.so $(SOFILE) $(CCLIBSRC) -I$(CUDASDKHOME)/common/inc -I$(CUDAHOME)/include
	gcc  -o $(EXECUTABLE) $(CCAPPSRC) -I$(CUDASDKHOME)/common/inc -I$(CUDAHOME)/include -L. -lcutil_image
	mv *.cubin data
	rm *.c~ *.h~ *.cu~ *.cpp~ *.o *.cu.cpp *.cu.c *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx


clean:
	rm -rf $(SOFILE) $(EXECUTABLE) data/*.cubin obj *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c *.so
