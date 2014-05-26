
//#include <malloc.h>

#include <vector_types.h>

typedef float2 Complex; 
static inline Complex ComplexAdd(Complex, Complex);
static inline Complex ComplexMul(Complex, Complex);

extern "C"
void Convolve(const Complex*, int,
              const Complex*, int,
              Complex*);


////////////////////////////////////////////////////////////////////////////////
// Computes convolution on the host
void Convolve(const Complex* signal, int signal_size,
              const Complex* filter_kernel, int filter_kernel_size,
              Complex* filtered_signal)
{
    int minRadius = filter_kernel_size / 2;
    int maxRadius = filter_kernel_size - minRadius;
    // Loop over output element indices
    for (int i = 0; i < signal_size; ++i) {
        filtered_signal[i].x = filtered_signal[i].y = 0;
        // Loop over convolution indices
        for (int j = - maxRadius + 1; j <= minRadius; ++j) {
            int k = i + j;
            if (k >= 0 && k < signal_size) 
                filtered_signal[i] = ComplexAdd(filtered_signal[i], ComplexMul(signal[k], filter_kernel[minRadius - j]));
        }
    }
}

// Complex addition
static inline Complex ComplexAdd(Complex a, Complex b)
{
    Complex c;
    c.x = a.x + b.x;
    c.y = a.y + b.y;
    return c;
}

// Complex multiplication
static inline Complex ComplexMul(Complex a, Complex b)
{
    Complex c;
    c.x = a.x * b.x - a.y * b.y;
    c.y = a.x * b.y + a.y * b.x;
    return c;
}



extern "C"
//void test (int, int*);
int test (int);

//void test (int i, int* o)
int test (int i)
{
	i=100;
	//printf("input = %d\n", i);
	/*
	printf("output = %d\n", 4);
	o = (int*)malloc(sizeof(int));
	*o = 5;
	*/
	return 4;
}

extern "C"
void computeGold( float*, const float*, const float*, unsigned int, unsigned int, unsigned int);

void computeGold(float* C, const float* A, const float* B, unsigned int hA, unsigned int wA, unsigned int wB)
{
    for (unsigned int i = 0; i < hA; ++i)
      for (unsigned int j = 0; j < wB; ++j) {
        double sum = 0;
        for (unsigned int k = 0; k < wA; ++k) {
          double a = A[i * wA + k];
          double b = B[k * wB + j];
          sum += a * b;
        }
        C[i * wB + j] = (float)sum;
      }
}

