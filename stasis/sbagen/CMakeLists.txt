cmake_minimum_required(VERSION 2.6.2)
project (sba_prog)

find_package(CUDA REQUIRED)


if( CUDA_CUDA_LIBRARY)
 message(STATUS " CUDA  found on this system")

	find_path(CUDA_CUT_INCLUDE_DIR
	cutil.h
	PATHS ${CUDA_SDK_SEARCH_PATH}
	PATH_SUFFIXES "common/inc"
	DOC "Location of cutil.h"
	NO_DEFAULT_PATH
	)

 # Now search system paths
    find_path(CUDA_CUT_INCLUDE_DIR cutil.h DOC "Location of cutil.h")

    mark_as_advanced(CUDA_CUT_INCLUDE_DIR)
    # Example of how to find a library in the CUDA_SDK_ROOT_DIR

    # cutil library is called cutil64 for 64 bit builds on windows.  We don't want
    # to get these confused, so we are setting the name based on the word size of
    # the build.

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(cuda_cutil_name cutil64)
    else(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(cuda_cutil_name cutil32)
    endif(CMAKE_SIZEOF_VOID_P EQUAL 8)

    find_library(CUDA_CUT_LIBRARY
    NAMES cutil ${cuda_cutil_name}
    PATHS ${CUDA_SDK_SEARCH_PATH}
    # The new version of the sdk shows up in common/lib, but the old one is in lib
    PATH_SUFFIXES "lib" "lib"
    DOC "Location of cutil library"
    NO_DEFAULT_PATH
    )

    # Now search system paths
    find_library(CUDA_CUT_LIBRARY NAMES cutil ${cuda_cutil_name} DOC "Location of cutil library")
    mark_as_advanced(CUDA_CUT_LIBRARY)
    set(CUDA_CUT_LIBRARIES ${CUDA_CUT_LIBRARY})
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -arch=sm_11)

    #this block sets up the shared library called prog1
    set (CUDA_NVCC_FLAGS --shared  --compiler-options;'-fPIC' )
    include_directories(${CUDA_INCLUDE_DIRS} ${CUDA_CUT_INCLUDE_DIR}) 
    cuda_add_library(sba_prog SHARED cu_lib.cu)
    target_link_libraries(sba_prog ${CUDA_LIBRARIES} ${CUDA_CUT_LIBRARY})

    #this compiles and links the binary, which is called sba
    include_directories(${CMAKE_SOURCE_DIR}) 
    add_executable(sba driver.c hashtab.c )
    set (libs_to_link sba_prog ${CUDA_LIBRARIES})
    target_link_libraries(sba ${libs_to_link})
	
	


    else( CUDA_CUDA_LIBRARY)
	 message(STATUS "oops CUDA not found on this system")
    endif(CUDA_CUDA_LIBRARY)
