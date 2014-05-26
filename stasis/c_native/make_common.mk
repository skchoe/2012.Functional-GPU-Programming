
#http://forums.nvidia.com/index.php?showtopic=193550

CUDAHOME=$(HOME)/local/cuda
CUDASDKHOME=$(HOME)/local/GPU_SDK/C
CUDALIB=$(CUDAHOME)/lib64/linux
LIB_ARCH=x86_64

SRCDIR	?=

# Common flags
COMMONFLAGS += $(INCLUDES) -DUNIX

# Compilers
NVCC       := nvcc
CXX        := g++ -fPIC
CC         := gcc -fPIC
LINK       := g++ -fPIC

# detect 32-bit or 64-bit platform
HP_64 = $(shell uname -m | grep 64)
OSARCH= $(shell uname -m)

# Debug/release configuration
#ifeq ($(dbg),1)
	COMMONFLAGS += -g
	NVCCFLAGS   += -D_DEBUG -G
	CXXFLAGS    += -D_DEBUG -G
	CFLAGS      += -D_DEBUG -G
	BINSUBDIR   := debug
	LIBSUFFIX   := D
#else 
#	COMMONFLAGS += -O2 
#	BINSUBDIR   := release
#	LIBSUFFIX   := 
#	NVCCFLAGS   += --compiler-options -fno-strict-aliasing
#	CXXFLAGS    += -fno-strict-aliasing
#	CFLAGS      += -fno-strict-aliasing
#endif

# Determining the necessary Cross-Compilation Flags
# 32-bit OS, but we target 64-bit cross compilation
ifeq ($(x86_64),1) 
    NVCCFLAGS       += -m64
    LIB_ARCH         = x86_64
    CUDPPLIB_SUFFIX  = x86_64
    ifneq ($(DARWIN),)
         CXX_ARCH_FLAGS += -arch x86_64
    else
         CXX_ARCH_FLAGS += -m64
    endif
else 
# 64-bit OS, and we target 32-bit cross compilation
    ifeq ($(i386),1)
        NVCCFLAGS       += -m32
        LIB_ARCH         = i386
        CUDPPLIB_SUFFIX  = i386
        ifneq ($(DARWIN),)
             CXX_ARCH_FLAGS += -arch i386
        else
             CXX_ARCH_FLAGS += -m32
        endif
    else 
        ifeq "$(strip $(HP_64))" ""
            LIB_ARCH        = i386
            CUDPPLIB_SUFFIX = i386
            NVCCFLAGS      += -m32
            ifneq ($(DARWIN),)
               CXX_ARCH_FLAGS += -arch i386
            else
               CXX_ARCH_FLAGS += -m32
            endif
        else
            LIB_ARCH        = x86_64
            CUDPPLIB_SUFFIX = x86_64
            NVCCFLAGS      += -m64
            ifneq ($(DARWIN),)
               CXX_ARCH_FLAGS += -arch x86_64
            else
               CXX_ARCH_FLAGS += -m64
            endif
        endif
    endif
endif

# architecture flag for cubin build
CUBIN_ARCH_FLAG :=
ifneq "$(strip $(HP_64))" ""
	CUBIN_ARCH_FLAG := -m64
else
	CUBIN_ARCH_FLAG := -m32
endif

BINDIR    := .
COMMONDIR := $(CUDA_SDK_HOME)/common
SHAREDDIR := $(CUDA_SDK_HOME)/../shared
OSLOWER = $(shell uname -s 2>/dev/null | tr [:upper:] [:lower:])


# Libs
ifneq ($(DARWIN),)
    #LIB       := -L$(CUDAHOME)/lib -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(SHAREDDIR)/lib $(NVCUVIDLIB) 
    LIB       += -L$(CUDAHOME)/lib -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(COMMONDIR)/lib/darwin -lcuda -lcudart

else
  ifeq "$(strip $(HP_64))" ""
    ifeq ($(x86_64),1)
       #LIB       := -L$(CUDAHOME)/lib64 -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(SHAREDDIR)/lib 
       LIB       += -L$(CUDAHOME)/lib64 -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(SHAREDDIR)/lib -L$(COMMONDIR)/lib/linux  -lcuda -lcudart
        
    else
       #LIB       := -L$(CUDAHOME)/lib -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(SHAREDDIR)/lib
       LIB       += -L$(CUDAHOME)/lib -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(SHAREDDIR)/lib -L$(COMMONDIR)/lib/linux  -lcuda -lcudart

    endif
  else
    ifeq ($(i386),1)
       LIB       := -L$(CUDAHOME)/lib -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(SHAREDDIR)/lib
    else
       LIB       := -L$(CUDAHOME)/lib64 -L$(LIBDIR) -L$(COMMONDIR)/lib/$(OSLOWER) -L$(SHAREDDIR)/lib
    endif
  endif
endif

# If dynamically linking to CUDA and CUDART, we exclude the libraries from the LIB
ifeq ($(USECUDADYNLIB),1)
     LIB += ${OPENGLLIB} $(PARAMGLLIB) $(RENDERCHECKGLLIB) $(CUDPPLIB) ${LIB} -ldl -rdynamic 
else
# static linking, we will statically link against CUDA and CUDART
  ifeq ($(USEDRVAPI),1)
     LIB += -lcuda   ${OPENGLLIB} $(PARAMGLLIB) $(RENDERCHECKGLLIB) $(CUDPPLIB) ${LIB} 
  else
     ifeq ($(emu),1) 
         LIB += -lcudartemu
     else 
         LIB += -lcudart
     endif
     LIB += ${OPENGLLIB} $(PARAMGLLIB) $(RENDERCHECKGLLIB) $(CUDPPLIB) ${LIB}
  endif
endif

ifeq ($(USECUFFT),1)
  ifeq ($(emu),1)
    LIB += -lcufftemu
  else
    LIB += -lcufft
  endif
endif

ifeq ($(USECUBLAS),1)
  ifeq ($(emu),1)
    LIB += -lcublasemu
  else
    LIB += -lcublas
  endif
endif

ifeq ($(USECURAND),1)
    LIB += -lcurand
endif

ifeq ($(USECUSPARSE),1)
  LIB += -lcusparse
endif

# Lib/exe configuration
ifneq ($(STATIC_LIB),)
	TARGETDIR := $(LIBDIR)
	TARGET   := $(subst .a,_$(LIB_ARCH)$(LIBSUFFIX).a,$(LIBDIR)/$(STATIC_LIB))
	LINKLINE  = ar rucv $(TARGET) $(OBJS)
else
	ifneq ($(DYNAMIC_LIB_BASE_NAME),)
		TARGETDIR := $(LIBDIR)
                TARGET    := $(TARGETDIR)/$(DYNAMIC_LIB)
		LINKLINE   = $(LINK) $(CUBIN_ARCH_FLAG) -shared -o $(TARGET)  $(OBJS) $(LIB)
	else
		ifneq ($(OMIT_CUTIL_LIB),1)
			LIB += -lcutil_$(LIB_ARCH)$(LIBSUFFIX) -lshrutil_$(LIB_ARCH)$(LIBSUFFIX)
		endif
		# Device emulation configuration
		ifeq ($(emu), 1)
			NVCCFLAGS   += -deviceemu
			CUDACCFLAGS += 
			BINSUBDIR   := emu$(BINSUBDIR)
       	       		LIBSUFFIX   := _$(LIB_ARCH)$(LIBSUFFIX)_emu
			# consistency, makes developing easier
			CXXFLAGS    += -D__DEVICE_EMULATION__
			CFLAGS	    += -D__DEVICE_EMULATION__
		endif
		TARGETDIR := $(BINDIR)/$(BINSUBDIR)
		TARGET    := $(TARGETDIR)/$(EXECUTABLE)
		LINKLINE  = $(LINK) -o $(TARGET) $(OBJS) $(LIB)
	endif
endif

################################################################################
# Rules and targets
OBJDIR   := $(SRCDIR)obj
CUBINDIR := $(SRCDIR)data

OBJS   += $(patsubst %.cpp,$(OBJDIR)/%.cpp.o,$(notdir $(CCFILES)))
OBJS   += $(patsubst %.c,$(OBJDIR)/%.c.o,$(notdir $(CFILES)))
OBJS   += $(patsubst %.cu,$(OBJDIR)/%.cu.o,$(notdir $(CUFILES)))

################################################################################
# Set up cubin output files
################################################################################
CUBINS +=  $(patsubst %.cu,$(CUBINDIR)/%.cubin,$(notdir $(CUBINFILES)))

################################################################################
# Set up PTX output files
################################################################################
PTXDIR := $(SRCDIR)data
PTXBINS +=  $(patsubst %.cu,$(PTXDIR)/%.ptx,$(notdir $(PTXFILES)))

################################################################################
# Rules
################################################################################
INCLUDE := -I. -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc
MYLIB   := -L. -L./$(OBJDIR) -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux
MYLNK   :=  -lcuda -lcutil_$(LIB_ARCH)

$(OBJDIR)/%.c.o : $(SRCDIR)%.c $(C_DEPS)
	$(VERBOSE)$(CC) $(CFLAGS) -o $@ -c $< $(INCLUDE) $(MYLIB) $(MYLNK)

$(OBJDIR)/%.cpp.o : $(SRCDIR)%.cpp $(C_DEPS)
	$(VERBOSE)$(CXX) $(CXXFLAGS) -o $@ -c $< $(INCLUDE) $(MYLIB) $(MYLNK)

# Compiler-specific flags (by default, we always use sm_10 and sm_20), unless we use the SMVERSION template
GENCODE_SM10 := -gencode=arch=compute_10,code=\"sm_10,compute_10\"
GENCODE_SM20 := -gencode=arch=compute_20,code=\"sm_20,compute_20\"
SIMPLE_GENCODE_SM20 := -gencode=arch=compute_20,code=sm_20


# Default arch includes gencode for sm_10, sm_20, and other archs from GENCODE_ARCH declared in the makefile
$(OBJDIR)/%.cu.o : $(SRCDIR)%.cu $(CU_DEPS)
#	$(VERBOSE)$(NVCC) $(GENCODE_SM10) $(GENCODE_ARCH) $(GENCODE_SM20) $(NVCCFLAGS) $(SMVERSIONFLAGS) -o $@ -c $< $(INCLUDE) $(MYLIB) $(MYLNK)
	$(VERBOSE)$(NVCC) $(NVCCFLAGS) $(SMVERSIONFLAGS) -o $@ -c $< $(INCLUDE) $(MYLIB) $(MYLNK)

# Default arch includes gencode for sm_10, sm_20, and other archs from GENCODE_ARCH declared in the makefile

$(CUBINDIR)/%.cubin : $(SRCDIR)%.cu cubindirectory
	$(VERBOSE)$(NVCC) $(CUBIN_ARCH_FLAG) $(NVCCFLAGS) $(SMVERSIONFLAGS) -o $@ -cubin $< $(INCLUDE) $(MYLIB) $(MYLNK)
#	$(VERBOSE)$(NVCC) $(GENCODE_ARCH) $(SIMPLE_GENCODE_SM20) $(CUBIN_ARCH_FLAG) $(NVCCFLAGS) $(SMVERSIONFLAGS) -o $@ -cubin $< $(INCLUDE) $(MYLIB) $(MYLNK)

$(PTXDIR)/%.ptx : ptxdirectory %.cu
	$(VERBOSE)$(NVCC) $(CUBIN_ARCH_FLAG) $(NVCCFLAGS) $(SMVERSIONFLAGS) -o $@ -ptx $<

#$(EXECUTABLE): makedirectory
	$(EXECUTABLE): makedirectory cubindirectory $(OBJS) $(CUBINS) $(PTXBINS) Makefile
	$(VERBOSE)$(NVCC) -o $(EXECUTABLE) -keep $(OBJS) $(INCLUDE) $(MYLIB) $(MYLNK)
#	$(VERBOSE)$(NVCC) $(GENCODE_ARCH) $(SIMPLE_GENCODE_SM20) -o $(CUBINDIR)/cu_lib.cubin -cubin $(SRCDIR)cu_lib.cu $(INCLUDE) $(MYLIB) $(MYLNK)
	$(VERBOSE)$(NVCC) -o $(CUBINDIR)/cu_lib.cubin -cubin $(SRCDIR)cu_lib.cu $(INCLUDE) $(MYLIB) $(MYLNK)

cubindirectory:
	mkdir -p $(CUBINDIR)

ptxdirectory:
	mkdir -p $(PTXDIR)

makedirectory:
	mkdir -p $(OBJDIR)

clean : 
	rm -rf $(SOFILE) $(EXECUTABLE) $(CUBINDIR) $(OBJDIR) *.o *.cu.cpp *.cu.c *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx
#gcc -fPIC -shared -o $(SOFILE) matrixMul_gold.cpp -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDAHOME)/lib -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil
