/* CUda UTility Library */

#ifndef _CUTIL_H_
#define _CUTIL_H_

#ifdef _WIN32
#   pragma warning( disable : 4996 ) // disable deprecated warning 
#endif

#include <stdbool.h>
typedef unsigned int uint;
typedef unsigned char uchar;
typedef unsigned short ushort;


#ifdef __cplusplus
extern "C" {
#endif

    ////////////////////////////////////////////////////////////////////////////
    //! CUT bool type
    ////////////////////////////////////////////////////////////////////////////
    enum CUTBoolean 
    {
        CUTFalse = 0,
        CUTTrue = 1
    };

    ////////////////////////////////////////////////////////////////////////////
    //! Deallocate memory allocated within Cutil
    //! @param  pointer to memory 
    ////////////////////////////////////////////////////////////////////////////
    void 
  	cutFree( void* ptr);

    ////////////////////////////////////////////////////////////////////////////
    //! Helper for bank conflict checking (should only be used with the
    //! CUT_BANK_CHECKER macro)
    //! @param tidx  thread id in x dimension of block
    //! @param tidy  thread id in y dimension of block
    //! @param tidz  thread id in z dimension of block
    //! @param bdimx block size in x dimension
    //! @param bdimy block size in y dimension
    //! @param bdimz block size in z dimension
    //! @param file  name of the source file where the access takes place
    //! @param line  line in the source file where the access takes place
    //! @param aname name of the array which is accessed
    //! @param index index into the array
    ////////////////////////////////////////////////////////////////////////////
    void 
    cutCheckBankAccess( unsigned int tidx, unsigned int tidy, unsigned int tidz,
                        unsigned int bdimx, unsigned int bdimy, 
                        unsigned int bdimz, const char* file, const int line,
                        const char* aname, const int index);

    ////////////////////////////////////////////////////////////////////////////
    //! Find the path for a filename
    //! @return the path if succeeded, otherwise 0
    //! @param filename        name of the file
    //! @param executablePath  optional absolute path of the executable
    ////////////////////////////////////////////////////////////////////////////
    char* 
    cutFindFilePath(const char* filename, const char* executablePath);

    ////////////////////////////////////////////////////////////////////////////
    //! Read file \filename containing single precision floating point data
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param filename name of the source file
    //! @param data  uninitialized pointer, returned initialized and pointing to
    //!        the data read
    //! @param len  number of data elements in data, -1 on error
    //! @note If a NULL pointer is passed to this function and it is
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    /*
    CUTBoolean  
    cutReadFilef( const char* filename, float** data, unsigned int* len, 
                  bool verbose = false);
		  */
    int cutReadFilef( const char* filename, float** data, uint* len, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Read file \filename containing double precision floating point data
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param filename name of the source file
    //! @param data  uninitialized pointer, returned initialized and pointing to
    //!        the data read
    //! @param len  number of data elements in data, -1 on error
    //! @note If a NULL pointer is passed to this function and it is
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutReadFiled( const char* filename, double** data, uint* len, 
                  bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Read file \filename containing integer data
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param filename name of the source file
    //! @param data  uninitialized pointer, returned initialized and pointing to
    //!        the data read
    //! @param len  number of data elements in data, -1 on error
    //! @note If a NULL pointer is passed to this function and it is
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutReadFilei( const char* filename, int** data, uint* len, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Read file \filename containing unsigned integer data
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param filename name of the source file
    //! @param data  uninitialized pointer, returned initialized and pointing to
    //!        the data read
    //! @param len  number of data elements in data, -1 on error
    //! @note If a NULL pointer is passed to this function and it is 
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutReadFileui( const char* filename, uint** data, 
                   uint* len, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Read file \filename containing char / byte data
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param filename name of the source file
    //! @param data  uninitialized pointer, returned initialized and pointing to
    //!        the data read
    //! @param len  number of data elements in data, -1 on error
    //! @note If a NULL pointer is passed to this function and it is 
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutReadFileb( const char* filename, char** data, uint* len, 
                  bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Read file \filename containing unsigned char / byte data
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param filename name of the source file
    //! @param data  uninitialized pointer, returned initialized and pointing to
    //!        the data read
    //! @param len  number of data elements in data, -1 on error
    //! @note If a NULL pointer is passed to this function and it is
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutReadFileub( const char* filename, uchar** data, 
                   uint* len, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Write a data file \filename containing single precision floating point 
    //! data
    //! @return CUTTrue if writing the file succeeded, otherwise false
    //! @param filename name of the file to write
    //! @param data  pointer to data to write
    //! @param len  number of data elements in data, -1 on error
    //! @param epsilon  epsilon for comparison
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutWriteFilef( const char* filename, const float* data, unsigned int len,
                   const float epsilon, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Write a data file \filename containing double precision floating point 
    //! data
    //! @return CUTTrue if writing the file succeeded, otherwise false
    //! @param filename name of the file to write
    //! @param data  pointer to data to write
    //! @param len  number of data elements in data, -1 on error
    //! @param epsilon  epsilon for comparison
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutWriteFiled( const char* filename, const float* data, unsigned int len,
                   const double epsilon, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Write a data file \filename containing integer data
    //! @return CUTTrue if writing the file succeeded, otherwise false
    //! @param filename name of the file to write
    //! @param data  pointer to data to write
    //! @param len  number of data elements in data, -1 on error
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutWriteFilei( const char* filename, const int* data, unsigned int len,
                   bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Write a data file \filename containing unsigned integer data
    //! @return CUTTrue if writing the file succeeded, otherwise false
    //! @param filename name of the file to write
    //! @param data  pointer to data to write
    //! @param len  number of data elements in data, -1 on error
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutWriteFileui( const char* filename,const uint* data, 
                    unsigned int len, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Write a data file \filename containing char / byte data
    //! @return CUTTrue if writing the file succeeded, otherwise false
    //! @param filename name of the file to write
    //! @param data  pointer to data to write
    //! @param len  number of data elements in data, -1 on error
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutWriteFileb( const char* filename, const char* data, unsigned int len, 
                   bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Write a data file \filename containing unsigned char / byte data
    //! @return CUTTrue if writing the file succeeded, otherwise false
    //! @param filename name of the file to write
    //! @param data  pointer to data to write
    //! @param len  number of data elements in data, -1 on error
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutWriteFileub( const char* filename,const uchar* data,
                    unsigned int len, bool verbose);

    ////////////////////////////////////////////////////////////////////////////
    //! Load PGM image file (with unsigned char as data element type)
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    //! @note If a NULL pointer is passed to this function and it is 
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutLoadPGMub( const char* file, uchar** data,
                  uint *w,uint *h);

    ////////////////////////////////////////////////////////////////////////////
    //! Load PPM image file (with unsigned char as data element type)
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutLoadPPMub( const char* file, uchar** data, 
                  uint *w,uint *h);

    ////////////////////////////////////////////////////////////////////////////
    //! Load PPM image file (with unsigned char as data element type), padding 
    //! 4th component
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutLoadPPM4ub( const char* file, uchar** data, 
                   uint *w,uint *h);

    ////////////////////////////////////////////////////////////////////////////
    //! Load PGM image file (with unsigned int as data element type)
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    //! @note If a NULL pointer is passed to this function and it is 
    //!       initialized within Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int 
        cutLoadPGMi( const char* file, uint** data, 
                     uint* w, uint* h);

    ////////////////////////////////////////////////////////////////////////////
    //! Load PGM image file (with unsigned short as data element type)
    //! @return CUTTrue if reading the file succeeded, otherwise false
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    //! @note If a NULL pointer is passed to this function and it is 
    //!       initialized  withing Cutil then cutFree() has to be used to
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int 
        cutLoadPGMs( const char* file, ushort** data, 
                     uint* w, uint* h);

    ////////////////////////////////////////////////////////////////////////////
    //! Load PGM image file (with float as data element type)
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    //! @note If a NULL pointer is passed to this function and it is 
    //!       initialized withing Cutil then cutFree() has to be used to 
    //!       deallocate the memory
    ////////////////////////////////////////////////////////////////////////////
    int 
        cutLoadPGMf( const char* file, float** data,
                     uint* w, uint* h);

    ////////////////////////////////////////////////////////////////////////////
    //! Save PGM image file (with unsigned char as data element type)
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
        cutSavePGMub( const char* file, unsigned char* data, 
                      uint w, uint h);

    ////////////////////////////////////////////////////////////////////////////
    //! Save PPM image file (with unsigned char as data element type)
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutSavePPMub( const char* file, unsigned char *data, 
                unsigned int w, unsigned int h);

    ////////////////////////////////////////////////////////////////////////////
    //! Save PPM image file (with unsigned char as data element type, padded to 
    //! 4 bytes)
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutSavePPM4ub( const char* file, unsigned char *data, 
                   unsigned int w, unsigned int h);

    ////////////////////////////////////////////////////////////////////////////
    //! Save PGM image file (with unsigned int as data element type)
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutSavePGMi( const char* file, uint* data,
                 unsigned int w, unsigned int h);

    ////////////////////////////////////////////////////////////////////////////
    //! Save PGM image file (with unsigned short as data element type)
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutSavePGMs( const char* file, ushort* data,
                 unsigned int w, unsigned int h);

    ////////////////////////////////////////////////////////////////////////////
    //! Save PGM image file (with float as data element type)
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutSavePGMf( const char* file, float* data,
                 unsigned int w, unsigned int h);

    ////////////////////////////////////////////////////////////////////////////
    // Command line arguments: General notes
    // * All command line arguments begin with '--' followed by the token; 
    //   token and value are seperated by '='; example --samples=50
    // * Arrays have the form --model=[one.obj,two.obj,three.obj] 
    //   (without whitespaces)
    ////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////
    //! Check if command line argument \a flag-name is given
    //! @return CUTTrue if command line argument \a flag_name has been given, 
    //!         otherwise 0
    //! @param argc  argc as passed to main()
    //! @param argv  argv as passed to main()
    //! @param flag_name  name of command line flag
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutCheckCmdLineFlag( const int argc, const char** argv, 
                         const char* flag_name);

    ////////////////////////////////////////////////////////////////////////////
    //! Get the value of a command line argument of type int
    //! @return CUTTrue if command line argument \a arg_name has been given and
    //!         is of the requested type, otherwise CUTFalse
    //! @param argc  argc as passed to main()
    //! @param argv  argv as passed to main()
    //! @param arg_name  name of the command line argument
    //! @param val  value of the command line argument
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutGetCmdLineArgumenti( const int argc, const char** argv, 
                            const char* arg_name, int* val);

    ////////////////////////////////////////////////////////////////////////////
    //! Get the value of a command line argument of type float
    //! @return CUTTrue if command line argument \a arg_name has been given and
    //!         is of the requested type, otherwise CUTFalse
    //! @param argc  argc as passed to main()
    //! @param argv  argv as passed to main()
    //! @param arg_name  name of the command line argument
    //! @param val  value of the command line argument
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutGetCmdLineArgumentf( const int argc, const char** argv, 
                            const char* arg_name, float* val);

    ////////////////////////////////////////////////////////////////////////////
    //! Get the value of a command line argument of type string
    //! @return CUTTrue if command line argument \a arg_name has been given and
    //!         is of the requested type, otherwise CUTFalse
    //! @param argc  argc as passed to main()
    //! @param argv  argv as passed to main()
    //! @param arg_name  name of the command line argument
    //! @param val  value of the command line argument
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutGetCmdLineArgumentstr( const int argc, const char** argv, 
                              const char* arg_name, char** val);

    ////////////////////////////////////////////////////////////////////////////
    //! Get the value of a command line argument list those element are strings
    //! @return CUTTrue if command line argument \a arg_name has been given and
    //!         is of the requested type, otherwise CUTFalse
    //! @param argc  argc as passed to main()
    //! @param argv  argv as passed to main()
    //! @param arg_name  name of the command line argument
    //! @param val  command line argument list
    //! @param len  length of the list / number of elements
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutGetCmdLineArgumentListstr( const int argc, const char** argv, 
                                  const char* arg_name, char** val, 
                                  unsigned int* len);

    ////////////////////////////////////////////////////////////////////////////
    //! Extended assert
    //! @return CUTTrue if the condition \a val holds, otherwise CUTFalse
    //! @param val  condition to test
    //! @param file  __FILE__ macro
    //! @param line  __LINE__ macro
    //! @note This function should be used via the CONDITION(val) macro
    ////////////////////////////////////////////////////////////////////////////
    int 
    cutCheckCondition( int val, const char* file, const int line);

    ////////////////////////////////////////////////////////////////////////////
    //! Compare two float arrays
    //! @return  CUTTrue if \a reference and \a data are identical, 
    //!          otherwise CUTFalse
    //! @param reference  handle to the reference data / gold image
    //! @param data       handle to the computed data
    //! @param len        number of elements in reference and data
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutComparef( const float* reference, const float* data,
                 const unsigned int len);

    ////////////////////////////////////////////////////////////////////////////
    //! Compare two integer arrays
    //! @return  CUTTrue if \a reference and \a data are identical, 
    //!          otherwise CUTFalse
    //! @param reference  handle to the reference data / gold image
    //! @param data       handle to the computed data
    //! @param len        number of elements in reference and data
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutComparei( const int* reference, const int* data, 
                 const unsigned int len ); 

    ////////////////////////////////////////////////////////////////////////////
    //! Compare two unsigned char arrays
    //! @return  CUTTrue if \a reference and \a data are identical, 
    //!          otherwise CUTFalse
    //! @param reference  handle to the reference data / gold image
    //! @param data       handle to the computed data
    //! @param len        number of elements in reference and data
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutCompareub( const unsigned char* reference, const unsigned char* data,
                  const unsigned int len ); 

    ////////////////////////////////////////////////////////////////////////////////
    //! Compare two integer arrays witha n epsilon tolerance for equality
    //! @return  CUTTrue if \a reference and \a data are identical, 
    //!          otherwise CUTFalse
    //! @param reference  handle to the reference data / gold image
    //! @param data       handle to the computed data
    //! @param len        number of elements in reference and data
    //! @param epsilon    epsilon to use for the comparison
    ////////////////////////////////////////////////////////////////////////////////
    int 
    cutCompareube( const unsigned char* reference, const unsigned char* data,
                 const unsigned int len, const int epsilon );

    ////////////////////////////////////////////////////////////////////////////
    //! Compare two float arrays with an epsilon tolerance for equality
    //! @return  CUTTrue if \a reference and \a data are identical, 
    //!          otherwise CUTFalse
    //! @param reference  handle to the reference data / gold image
    //! @param data       handle to the computed data
    //! @param len        number of elements in reference and data
    //! @param epsilon    epsilon to use for the comparison
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutComparefe( const float* reference, const float* data,
                  const unsigned int len, const float epsilon );

    ////////////////////////////////////////////////////////////////////////////
    //! Compare two float arrays using L2-norm with an epsilon tolerance for 
    //! equality
    //! @return  CUTTrue if \a reference and \a data are identical, 
    //!          otherwise CUTFalse
    //! @param reference  handle to the reference data / gold image
    //! @param data       handle to the computed data
    //! @param len        number of elements in reference and data
    //! @param epsilon    epsilon to use for the comparison
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutCompareL2fe( const float* reference, const float* data,
                    const unsigned int len, const float epsilon );

    ////////////////////////////////////////////////////////////////////////////
    //! Timer functionality

    ////////////////////////////////////////////////////////////////////////////
    //! Create a new timer
    //! @return CUTTrue if a time has been created, otherwise false
    //! @param  name of the new timer, 0 if the creation failed
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutCreateTimer( uint* name);

    ////////////////////////////////////////////////////////////////////////////
    //! Delete a timer
    //! @return CUTTrue if a time has been deleted, otherwise false
    //! @param  name of the timer to delete
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutDeleteTimer( unsigned int name);

    ////////////////////////////////////////////////////////////////////////////
    //! Start the time with name \a name
    //! @param name  name of the timer to start
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutStartTimer( const unsigned int name);

    ////////////////////////////////////////////////////////////////////////////
    //! Stop the time with name \a name. Does not reset.
    //! @param name  name of the timer to stop
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutStopTimer( const unsigned int name);

    ////////////////////////////////////////////////////////////////////////////
    //! Resets the timer's counter.
    //! @param name  name of the timer to reset.
    ////////////////////////////////////////////////////////////////////////////
    int  
    cutResetTimer( const unsigned int name);

    ////////////////////////////////////////////////////////////////////////////
    //! Returns total execution time in milliseconds for the timer over all 
    //! runs since the last reset or timer creation.
    //! @param name  name of the timer to return the time of
    ////////////////////////////////////////////////////////////////////////////
    float
    cutGetTimerValue( const unsigned int name);

    ////////////////////////////////////////////////////////////////////////////
    //! Return the average time in milliseconds for timer execution as the 
    //! total  time for the timer dividied by the number of completed (stopped)
    //! runs the timer has made.
    //! Excludes the current running time if the timer is currently running.
    //! @param name  name of the timer to return the time of
    ////////////////////////////////////////////////////////////////////////////
    float
    cutGetAverageTimerValue( const unsigned int name);

    ////////////////////////////////////////////////////////////////////////////
    //! Macros

#ifdef _DEBUG

#if __DEVICE_EMULATION__
    // Interface for bank conflict checker
#define CUT_BANK_CHECKER( array, index)                                      \
    (cutCheckBankAccess( threadIdx.x, threadIdx.y, threadIdx.z, blockDim.x,  \
    blockDim.y, blockDim.z,                                                  \
    __FILE__, __LINE__, #array, index ),                                     \
    array[index])
#else
#define CUT_BANK_CHECKER( array, index)  array[index]
#endif

#  define CU_SAFE_CALL_NO_SYNC( call ) do {                                  \
    CUresult err = call;                                                     \
    if( CUDA_SUCCESS != err) {                                               \
        fprintf(stderr, "Cuda driver error %x in file '%s' in line %i.\n",   \
                err, __FILE__, __LINE__ );                                   \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CU_SAFE_CALL( call ) do {                                          \
    CU_SAFE_CALL_NO_SYNC(call);                                              \
    CUresult err = cuCtxSynchronize();                                       \
    if( CUDA_SUCCESS != err) {                                               \
        fprintf(stderr, "Cuda driver error %x in file '%s' in line %i.\n",   \
                err, __FILE__, __LINE__ );                                   \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUDA_SAFE_CALL_NO_SYNC( call) do {                                 \
    cudaError err = call;                                                    \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString( err) );              \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUDA_SAFE_CALL( call) do {                                         \
    CUDA_SAFE_CALL_NO_SYNC(call);                                            \
    cudaError err = cudaThreadSynchronize();                                 \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString( err) );              \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUFFT_SAFE_CALL( call) do {                                        \
    cufftResult err = call;                                                  \
    if( CUFFT_SUCCESS != err) {                                              \
        fprintf(stderr, "CUFFT error in file '%s' in line %i.\n",            \
                __FILE__, __LINE__);                                         \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

#  define CUT_SAFE_CALL( call)                                               \
    if( CUTTrue != call) {                                                   \
        fprintf(stderr, "Cut error in file '%s' in line %i.\n",              \
                __FILE__, __LINE__);                                         \
        exit(EXIT_FAILURE);                                                  \
    } 

    //! Check for CUDA error
#  define CUT_CHECK_ERROR(errorMessage) do {                                 \
    cudaError_t err = cudaGetLastError();                                    \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error: %s in file '%s' in line %i : %s.\n",    \
                errorMessage, __FILE__, __LINE__, cudaGetErrorString( err) );\
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    err = cudaThreadSynchronize();                                           \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error: %s in file '%s' in line %i : %s.\n",    \
                errorMessage, __FILE__, __LINE__, cudaGetErrorString( err) );\
        exit(EXIT_FAILURE);                                                  \
    } } while (0)

    //! Check for malloc error
#  define CUT_SAFE_MALLOC( mallocCall ) do{                                  \
    if( !(mallocCall)) {                                                     \
        fprintf(stderr, "Host malloc failure in file '%s' in line %i\n",     \
                __FILE__, __LINE__);                                         \
        exit(EXIT_FAILURE);                                                  \
    } } while(0);

    //! Check if conditon is true (flexible assert)
#  define CUT_CONDITION( val)                                                \
    if( CUTFalse == cutCheckCondition( val, __FILE__, __LINE__)) {           \
        exit(EXIT_FAILURE);                                                  \
    }

#else  // not DEBUG

#define CUT_BANK_CHECKER( array, index)  array[index]

    // void macros for performance reasons
#  define CUT_CHECK_ERROR(errorMessage)
#  define CUT_CHECK_ERROR_GL()
#  define CUT_CONDITION( val) 
#  define CU_SAFE_CALL_NO_SYNC( call) call
#  define CU_SAFE_CALL( call) call
#  define CUDA_SAFE_CALL_NO_SYNC( call) call
#  define CUDA_SAFE_CALL( call) call
#  define CUT_SAFE_CALL( call) call
#  define CUFFT_SAFE_CALL( call) call
#  define CUT_SAFE_MALLOC( mallocCall ) mallocCall

#endif

#if __DEVICE_EMULATION__

#  define CUT_DEVICE_INIT(ARGC, ARGV)

#else

#  define CUT_DEVICE_INIT(ARGC, ARGV) {                                      \
    int deviceCount;                                                         \
    CUDA_SAFE_CALL_NO_SYNC(cudaGetDeviceCount(&deviceCount));                \
    if (deviceCount == 0) {                                                  \
        fprintf(stderr, "cutil error: no devices supporting CUDA.\n");       \
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    int dev = 0;                                                             \
    cutGetCmdLineArgumenti(ARGC, (const char **) ARGV, "device", &dev);      \
    if (dev > deviceCount-1) dev = deviceCount - 1;                          \
    cudaDeviceProp deviceProp;                                               \
    CUDA_SAFE_CALL_NO_SYNC(cudaGetDeviceProperties(&deviceProp, dev));       \
    if (deviceProp.major < 1) {                                              \
        fprintf(stderr, "cutil error: device does not support CUDA.\n");     \
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    if (cutCheckCmdLineFlag(ARGC, (const char **) ARGV, "quiet") == CUTFalse) \
        fprintf(stderr, "Using device %d: %s\n", dev, deviceProp.name);       \
    CUDA_SAFE_CALL(cudaSetDevice(dev));                                      \
}

#endif

#  define CUT_DEVICE_INIT_DRV(cuDevice, ARGC, ARGV) {                        \
    cuDevice = 0;                                                            \
    int deviceCount = 0;                                                     \
    CUresult err = cuInit(0);                                                \
    if (CUDA_SUCCESS == err)                                                 \
        CU_SAFE_CALL_NO_SYNC(cuDeviceGetCount(&deviceCount));                \
    if (deviceCount == 0) {                                                  \
        fprintf(stderr, "cutil error: no devices supporting CUDA\n");        \
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
    int dev = 0;                                                             \
    cutGetCmdLineArgumenti(ARGC, (const char **) ARGV, "device", &dev);      \
    if (dev > deviceCount-1) dev = deviceCount - 1;                          \
    CU_SAFE_CALL_NO_SYNC(cuDeviceGet(&cuDevice, dev));                       \
    char name[100];                                                          \
    cuDeviceGetName(name, 100, cuDevice);                                    \
    if (cutCheckCmdLineFlag(ARGC, (const char **) ARGV, "quiet") == CUTFalse) \
        fprintf(stderr, "Using device %d: %s\n", dev, name);                  \
}

#define CUT_EXIT(argc, argv)                                                 \
    if (!cutCheckCmdLineFlag(argc, (const char**)argv, "noprompt")) {        \
        printf("\nPress ENTER to exit...\n");                                \
        fflush( stdout);                                                     \
        fflush( stderr);                                                     \
        getchar();                                                           \
    }                                                                        \
    exit(EXIT_SUCCESS);


#ifdef __cplusplus
}
#endif  // #ifdef _DEBUG (else branch)

#endif  // #ifndef _CUTIL_H_
