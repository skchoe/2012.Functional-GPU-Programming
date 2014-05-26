/* CUda UTility Library ported to C only file-handling part*/

/* Credit: Cuda team for the PGM file reader / writer code:original
           S. Choe  */

// includes, file
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// includes, cuda
#include "cutilc.h"


#ifndef max
#define max(a,b) (a < b ? b : a);
#endif

#define MIN_EPSILON_ERROR 1e-3f

// namespace unnamed (internal)
//namespace 
//{  
    // variables

    //! size of PGM file header 
    const unsigned int PGMHeaderSize = 0x40;

    // types

    //! Data converter from unsigned char / unsigned byte to type T
    /*
    template<class T>
    struct ConverterFromUByte;
    */

    //! Data converter from unsigned char / unsigned byte to unsigned int
    /*
    template<>
    struct ConverterFromUByte<unsigned int> 
    {
        //! Conversion operator
        //! @return converted value
        //! @param  val  value to convert
        unsigned int operator()( const unsigned char& val) {
            return static_cast<unsigned int>( val);
        }
    };
    */
/*
    uint converter_ubyte2uint (uchar & val)
    {
      return (uint)(val);
    }
*/  
    //! Data converter from unsigned char / unsigned byte to unsigned short
    /*
    template<>
    struct ConverterFromUByte<unsigned short> 
    {
        //! Conversion operator
        //! @return converted value
        //! @param  val  value to convert
        unsigned short operator()( const unsigned char& val) 
        {
            return static_cast<unsigned short>( val);
        }
    };
    */
/*
    unsigned short converter_ubyte2ushort(uchar & val)
    {
      return (unsigned short)(val);
    }
*/
    //! Data converter from unsigned char / unsigned byte to unsigned float
    /*
    template<>
    struct ConverterFromUByte<float> 
    {
        //! Conversion operator
        //! @return converted value
        //! @param  val  value to convert
        float operator()( const unsigned char& val) 
        {
            return static_cast<float>( val) / 255.0f;
        }
    };
    */
/*
    float converter_ubyte2float(uchar & val)
    {
      return (float)(val)/255.0f;
    }
*/
    //! Data converter from unsigned char / unsigned byte to type T
    /*
    template<class T>
    struct ConverterToUByte;
    */

    //! Data converter from unsigned char / unsigned byte to unsigned int
    /*
    template<>
    struct ConverterToUByte<unsigned int> 
    {
        //! Conversion operator
        //! @return converted value
        //! @param  val  value to convert
        unsigned char operator()( const unsigned int& val) 
        {
            return static_cast<unsigned char>( val);
        }
    };
    */

/*
    unsigned char converter_uint2ubyte(uint & val)
    {
      return (unsigned char)(val);
    }
*/
    //! Data converter from unsigned char / unsigned byte to unsigned short
    /*
    template<>
    struct ConverterToUByte<unsigned short> 
    {
        //! Conversion operator
        //! @return converted value
        //! @param  val  value to convert
        unsigned char operator()( const unsigned short& val) 
        {
            return static_cast<unsigned char>( val);
        }
    };
    */
/*
    unsigned char converter_ushort2ubyte(ushort & val)
    {
      return (unsigned char)(val);
    }
*/
    //! Data converter from unsigned char / unsigned byte to unsigned float
    /*
    template<>
    struct ConverterToUByte<float> 
    {
        //! Conversion operator
        //! @return converted value
        //! @param  val  value to convert
        unsigned char operator()( const float& val) 
        {
            return static_cast<unsigned char>( val * 255.0f);
        }
    };
    */
/*
    unsigned char converter_float2ubyte(float& val)
    {
      return (unsigned byte)(val*255.0f);
    }
*/

    // functions

    //////////////////////////////////////////////////////////////////////////////
    //! Load PGM or PPM file
    //! @note if data == NULL then the necessary memory is allocated in the 
    //!       function and w and h are initialized to the size of the image
    //! @return CUTTrue if the file loading succeeded, otherwise false
    //! @param file        name of the file to load
    //! @param data        handle to the memory for the image file data
    //! @param w        width of the image
    //! @param h        height of the image
    //! @param channels number of channels in image
    //////////////////////////////////////////////////////////////////////////////
    int
    loadPPM( const char* file, unsigned char** data, 
             unsigned int *w, unsigned int *h, unsigned int *channels ) 
    {
        FILE *fp = NULL;
        if(NULL == (fp = fopen(file, "rb"))) 
        {
	  //std::cerr << "cutLoadPPM() : Failed to open file: " << file << std::endl;
	  fprintf(stderr, "cutLoadPPM() : Failed to open file: %s\n", file);
	  return CUTFalse;
        }

        // check header
        char header[PGMHeaderSize];
        fgets( header, PGMHeaderSize, fp);
        if (strncmp(header, "P5", 2) == 0)
        {
            *channels = 1;
        }
        else if (strncmp(header, "P6", 2) == 0)
        {
            *channels = 3;
        }
        else {
	  //std::cerr << "cutLoadPPM() : File is not a PPM or PGM image" << std::endl;
            fprintf(stderr, "cutLoadPPM() : File is not a PPM or PGM image\n");
            *channels = 0;
            return CUTFalse;
        }

        // parse header, read maxval, width and height
        unsigned int width = 0;
        unsigned int height = 0;
        unsigned int maxval = 0;
        unsigned int i = 0;
        while(i < 3) 
        {
            fgets(header, PGMHeaderSize, fp);
            if(header[0] == '#') 
                continue;

            if(i == 0) 
            {
                i += sscanf( header, "%u %u %u", &width, &height, &maxval);
            }
            else if (i == 1) 
            {
                i += sscanf( header, "%u %u", &height, &maxval);
            }
            else if (i == 2) 
            {
                i += sscanf(header, "%u", &maxval);
            }
        }

        // check if given handle for the data is initialized
        if( NULL != *data) 
        {
            if (*w != width || *h != height) 
            {
	      //std::cerr << "cutLoadPPM() : Invalid image dimensions." << std::endl;
	      fprintf(stderr, "cutLoadPPM() : Invalid image dimensions.\n");
	      return CUTFalse;
            }
        } 
        else 
        {
	  *data = (unsigned char*) malloc( sizeof( unsigned char) * width * height * *channels);
	  *w = width;
	  *h = height;
        }

        // read adn close file
        fread( *data, sizeof(unsigned char), width * height * *channels, fp);
        fclose(fp);

        return CUTTrue;
    }

/*
    //////////////////////////////////////////////////////////////////////////////
    //! Generic PGM image file loader adapter for type T
    //! @return CUTTrue if the file loading succeeded, otherwise false
    //! @param file  name of the file to load
    //! @param data  handle to the memory for the image file data
    //! @param w     width of the image
    //! @param h     height of the image
    //////////////////////////////////////////////////////////////////////////////
    template<class T>
    CUTBoolean
    loadPGMt( const char* file, T** data, unsigned int *w, unsigned int *h) 
    {
        unsigned char* idata = NULL;
        unsigned int channels;
        if( CUTTrue != loadPPM(file, &idata, w, h, &channels)) 
        {
            return CUTFalse;
        }

        unsigned int size = *w * *h * channels;

        // initialize mem if necessary
        // the correct size is checked / set in loadPGMc()
        if( NULL == *data) 
        {
            *data = (T*) malloc( sizeof(T) * size);
        }

        // copy and cast data
        std::transform( idata, idata + size, *data, ConverterFromUByte<T>());

        free( idata);

        return CUTTrue;
    }
*/
/*
    //////////////////////////////////////////////////////////////////////////////
    //! Write / Save PPM or PGM file
    //! @note Internal usage only
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    //////////////////////////////////////////////////////////////////////////////  
    CUTBoolean
    savePPM( const char* file, unsigned char *data, 
             unsigned int w, unsigned int h, unsigned int channels) 
    {
        CUT_CONDITION( NULL != data);
        CUT_CONDITION( w > 0);
        CUT_CONDITION( h > 0);

        std::fstream fh( file, std::fstream::out | std::fstream::binary );
        if( fh.bad()) 
        {
	  //std::cerr << "savePPM() : Opening file failed." << std::endl;
          sprintf(stderr, "savePPM() : Opening file failed.\n");
	  return CUTFalse;
        }

        if (channels == 1)
        {
            fh << "P5\n";
        }
        else if (channels == 3) {
            fh << "P6\n";
        }
        else {
            std::cerr << "savePPM() : Invalid number of channels." << std::endl;
            return CUTFalse;
        }

        fh << w << "\n" << h << "\n" << 0xff << std::endl;

        for( unsigned int i = 0; (i < (w*h*channels)) && fh.good(); ++i) 
        {
            fh << data[i];
        }
        fh.flush();

        if( fh.bad()) 
        {
	  //std::cerr << "savePPM() : Writing data failed." << std::endl;
          sprintf(stderr, "savePPM() : Writing data failed.\n");
            return CUTFalse;
        } 
        fh.close();

        return CUTTrue;
    }
*/
/*
    //////////////////////////////////////////////////////////////////////////////
    //! Generic PGM file writer for input data of type T
    //! @note Internal usage only
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    //////////////////////////////////////////////////////////////////////////////
    template<class T>
    CUTBoolean
    savePGMt( const char* file, T *data, unsigned int w, unsigned int h) 
    {
        unsigned int size = w * h;
        unsigned char* idata = 
          (unsigned char*) malloc( sizeof(unsigned char) * size);

        std::transform( data, data + size, idata, ConverterToUByte<T>());

        // write file
        CUTBoolean result = savePPM(file, idata, w, h, 1);

        // cleanup
        free( idata);

        return result;
    }
*/

/*
    //////////////////////////////////////////////////////////////////////////////
    //! Generic PPM file writer for input data of type T
    //! @note Internal usage only
    //! @param file  name of the image file
    //! @param data  handle to the data read
    //! @param w     width of the image
    //! @param h     height of the image
    //////////////////////////////////////////////////////////////////////////////
    template<class T>
    CUTBoolean
    savePPMt( const char* file, T *data, unsigned int w, unsigned int h) 
    {
        unsigned int size = w * h * 3;
        unsigned char* idata = (unsigned char*) malloc( sizeof(unsigned char) * size);

        std::transform( data, data + size, idata, ConverterToUByte<T>());

        // write file
        CUTBoolean result = savePPM(file, idata, w, h, 3);

        // cleanup
        free(idata);

        return result;
    }
*/
//} // end, namespace unnamed
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//! Deallocate memory allocated within Cutil
//! @param  pointer to memory 
//////////////////////////////////////////////////////////////////////////////
void 
cutFree( void* ptr) {
  if( NULL != ptr) free( ptr);
}


////////////////////////////////////////////////////////////////////////////////
//! Load PGM image file (with unsigned char as data element type)
//! @return CUTTrue if reading the file succeeded, otherwise false
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
int 
cutLoadPGMub( const char* file, unsigned char** data, 
              unsigned int *w,unsigned int *h)
{
    unsigned int channels;
    return loadPPM( file, data, w, h, &channels);
}

////////////////////////////////////////////////////////////////////////////////
//! Load PPM image file (with unsigned char as data element type)
//! @return CUTTrue if reading the file succeeded, otherwise false
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
int 
cutLoadPPMub( const char* file, unsigned char** data, 
              unsigned int *w,unsigned int *h)
{
    unsigned int channels;
    return loadPPM( file, data, w, h, &channels);
}

////////////////////////////////////////////////////////////////////////////////
//! Load PPM image file (with unsigned char as data element type), padding 4th component
//! @return CUTTrue if reading the file succeeded, otherwise false
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
int 
cutLoadPPM4ub( const char* file, unsigned char** data, 
               unsigned int *w,unsigned int *h)
{
    unsigned char *idata = 0;
    unsigned int channels;
    
    if (loadPPM( file, &idata, w, h, &channels)) {
        // pad 4th component
        int size = *w * *h;
        // keep the original pointer
        unsigned char* idata_orig = idata;
        *data = (unsigned char*) malloc( sizeof(unsigned char) * size * 4);
        unsigned char *ptr = *data;
	int i;
        for(i=0; i<size; i++) {
            *ptr++ = *idata++;
            *ptr++ = *idata++;
            *ptr++ = *idata++;
            *ptr++ = 0;
        }
        free( idata_orig);
        return CUTTrue;
    }
    else
    {
        cutFree( idata);
        return CUTFalse;
    }
}

/*
////////////////////////////////////////////////////////////////////////////////
//! Load PGM image file (with unsigned int as data element type)
//! @return CUTTrue if reading the file succeeded, otherwise false
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutLoadPGMi( const char* file, unsigned int** data, 
             unsigned int *w, unsigned int *h) 
{
    return loadPGMt( file, data, w, h);
}

////////////////////////////////////////////////////////////////////////////////
//! Load PGM image file (with unsigned short as data element type)
//! @return CUTTrue if reading the file succeeded, otherwise false
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutLoadPGMs( const char* file, unsigned short** data, 
             unsigned int *w, unsigned int *h) 
{
    return loadPGMt( file, data, w, h);
}

////////////////////////////////////////////////////////////////////////////////
//! Load PGM image file (with float as data element type)
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutLoadPGMf( const char* file, float** data, 
             unsigned int *w, unsigned int *h) 
{
    return loadPGMt( file, data, w, h);
}
*/
/*
////////////////////////////////////////////////////////////////////////////////
//! Save PGM image file (with unsigned char as data element type)
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutSavePGMub( const char* file, unsigned char *data, 
              unsigned int w, unsigned int h) 
{
    return savePPM( file, data, w, h, 1);
}

////////////////////////////////////////////////////////////////////////////////
//! Save PPM image file (with unsigned char as data element type)
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutSavePPMub( const char* file, unsigned char *data, 
              unsigned int w, unsigned int h) 
{
    return savePPM( file, data, w, h, 3);
}

////////////////////////////////////////////////////////////////////////////////
//! Save PPM image file (with unsigned char as data element type, padded to 4 byte)
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutSavePPM4ub( const char* file, unsigned char *data, 
               unsigned int w, unsigned int h) 
{
    // strip 4th component
    int size = w * h;
    unsigned char *ndata = (unsigned char*) malloc( sizeof(unsigned char) * size*3);
    unsigned char *ptr = ndata;
    for(int i=0; i<size; i++) {
        *ptr++ = *data++;
        *ptr++ = *data++;
        *ptr++ = *data++;
        data++;
    }
    
    return savePPM( file, ndata, w, h, 3);
}
*/
/*
////////////////////////////////////////////////////////////////////////////////
//! Save PGM image file (with unsigned int as data element type)
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutSavePGMi( const char* file, unsigned int *data, 
             unsigned int w, unsigned int h) 
{
    return savePGMt( file, data, w, h);
}

////////////////////////////////////////////////////////////////////////////////
//! Save PGM image file (with unsigned short  as data element type)
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutSavePGMs( const char* file, unsigned short *data, 
             unsigned int w, unsigned int h) 
{
    return savePGMt( file, data, w, h);
}

////////////////////////////////////////////////////////////////////////////////
//! Save PGM image file (with unsigned int as data element type)
//! @param file  name of the image file
//! @param data  handle to the data read
//! @param w     width of the image
//! @param h     height of the image
////////////////////////////////////////////////////////////////////////////////
CUTBoolean CUTIL_API
cutSavePGMf( const char* file, float *data, 
             unsigned int w, unsigned int h) 
{
    return savePGMt( file, data, w, h);
}
*/

