/*
 Copyright Ramtin Shams (hereafter referred to as 'the author'). All rights 
 reserved. **Citation required in derived works or publications** 
 
 NOTICE TO USER:   
 
 Users and possessors of this source code are hereby granted a nonexclusive, 
 royalty-free license to use this source code for non-commercial purposes only, 
 as long as the author is appropriately acknowledged by inclusion of this 
 notice in derived works and citation of appropriate publication(s) listed 
 at the end of this notice in any derived works or publications that use 
 or have benefited from this source code in its entirety or in part.
   
 
 THE AUTHOR MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE 
 CODE FOR ANY PURPOSE.  IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR 
 IMPLIED WARRANTY OF ANY KIND.  THE AUTHOR DISCLAIMS ALL WARRANTIES WITH 
 REGARD TO THIS SOURCE CODE, INCLUDING ALL IMPLIED WARRANTIES OF 
 MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL, 
 OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS 
 OF USE, DATA OR PROFITS,  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE 
 OR OTHER TORTIOUS ACTION,  ARISING OUT OF OR IN CONNECTION WITH THE USE 
 OR PERFORMANCE OF THIS SOURCE CODE.  
 
 Relevant publicationB(s):
	@inproceedings{Shams_ICSPCS_2007,
		author        = "R. Shams and R. A. Kennedy",
		title         = "Efficient Histogram Algorithms for {NVIDIA} {CUDA} Compatible Devices",
		booktitle     = "Proc. Int. Conf. on Signal Processing and Communications Systems ({ICSPCS})",
		address       = "Gold Coast, Australia",
		month         = dec,
		year          = "2007",
		pages         = "418-422",
	}

	@inproceedings{Shams_DICTA_2007a,
		author        = "R. Shams and N. Barnes",
		title         = "Speeding up Mutual Information Computation Using {NVIDIA} {CUDA} Hardware",
		booktitle     = "Proc. Digital Image Computing: Techniques and Applications ({DICTA})",
		address       = "Adelaide, Australia",
		month         = dec,
		year          = "2007",
		pages         = "555-560",
		doi           = "10.1109/DICTA.2007.4426846",
	};
*/

/**
	\file
		hist_example.cpp
	\brief
		Demonstrates use of GPU-based histogram methods in a simple C++ application.

	\remark
		This code has been optimized and tested on nVidia 8800 GTX. If used a different
		card, the execution configuration (i.e. the number of threads and blocks) may 
		have to be modified from the default value for best performance.
*/
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
/* 
	Include NVidia Cuda Utility header file. Make sure $(CUDA_INC_PATH) and
	$(NVSDKCUDA_ROOT)/common/inc are the include path of the project.
*/
#include <cutil.h>
/*
	Incldue GPU implementation headers
*/
#include "..\cuda\cuda_basics.h"
#include "..\cuda\cuda_hist.h"

#define BUFFER_LEN			10000000
#define	BINS				512

struct Options 
{
	int bins;
	unsigned int len;
	int threads, blocks;
};

Options ReadOptions(int argc, char *argv[])
{
	Options opts = {BINS, BUFFER_LEN, 0, 0};
	for (int i = 1; i < argc; i++)
	{
		if (strnicmp(argv[i], "-h", 2) == 0)
		{
			printf("Usage:\n");
			printf("hist_example [-b<number of bins>] [-l<data length>] [-k<number of GPU blocks>] [-t<threads per block>]\n");
			exit(0);
		}
		else if (strnicmp(argv[i], "-b", 2) == 0)
			opts.bins = strtol(argv[i] + 2, 0, 10); 
		else if (strnicmp(argv[i], "-l", 2) == 0)
			opts.len = strtol(argv[i] + 2, 0, 10); 
		else if (strnicmp(argv[i], "-t", 2) == 0)
			opts.threads = strtol(argv[i] + 2, 0, 10); 
		else if (strnicmp(argv[i], "-k", 2) == 0)
			opts.blocks = strtol(argv[i] + 2, 0, 10); 
		else
		{
			printf("Invalid input argument. Use -h for help.");
			exit(1);
		}
	}

	return opts;
}

double cpuHist(float *src, unsigned int *hist, int length, int bins)
{
	double time = 0;
	unsigned int hTimer;
    CUT_SAFE_CALL(cutCreateTimer(&hTimer));

	CUT_SAFE_CALL(cutStartTimer(hTimer));								
	memset(hist, 0, sizeof(unsigned int) * bins);
	for (int i = 0 ; i < length; i++)
		hist[(unsigned int)(src[i] * (bins - 1) + 0.5f)]++;

	CUT_SAFE_CALL(cutStopTimer(hTimer));
	time = cutGetTimerValue(hTimer);
	CUT_SAFE_CALL(cutDeleteTimer(hTimer));		

	return time;
}

float error(float *arr1, unsigned int *arr2, int len)
{
	float err = 0;

	for (int i = 0; i < len; i++)
		err += fabs(arr1[i] - (float) arr2[i]);

	return err;
}

float normalized_error(float *arr1, unsigned int *arr2, int len)
{
	float sum1 = 0, sum2 = 0, err = 0;

	for (int i = 0; i < len; i++)
		sum1 += arr1[i], sum2 += (float) arr2[i];

	for (int i = 0; i < len; i++)
		err += fabs(arr1[i] / sum1 - (float) arr2[i] / sum2);

	return err;
}

int main(int argc, char* argv[])
{
	// Read input options
	Options opt = ReadOptions(argc, argv);

	// Allocate a buffer for storage of randomly created input data
	float *buf = new float [opt.len];
	// Allocate a buffer for the GPU histogram
	float *hist = new float [opt.bins];
	// Allocate a buffer for the CPU histogram
	unsigned int *cpu_hist = new unsigned int [opt.bins];

	// Change the random sequence everytime
	srand((unsigned)time(0));			

	// Initialize the buffer with random values in [0,1] range
	// Note that the histogram methods expect normalized data in [0,1]
	// range. The behavior of the methods is undefined if the input
	// contains out of range values.
	printf("Initializing an array of %d elements...\n", opt.len);
	for (unsigned int i = 0; i < opt.len; i++)
		buf[i] = (float) rand() / RAND_MAX;

	double t;
	cudaHistOptions *p_opt = 0;
	if (opt.threads != 0)
	{
		p_opt = new cudaHistOptions;
		p_opt->blocks = opt.blocks;
		p_opt->threads = opt.threads;
	}

	t = cpuHist(buf, cpu_hist, opt.len, opt.bins);
	printf("cpuHist (%d bins): %.3f ms, %.1f MB/s\n", opt.bins, t, opt.len * sizeof(unsigned int) / t*1e-3);

	t = cudaHista(buf, hist, opt.len, opt.bins, p_opt);
	printf("cudaHista (%d bins): %.3f ms, %.1f MB/s\n", opt.bins, t, opt.len * sizeof(float) / t*1e-3);
	printf("Error in GPU calculation: %f\n", error(hist, cpu_hist, opt.bins));

	t = cudaHistb(buf, hist, opt.len, opt.bins, p_opt);
	printf("cudaHistb (%d bins): %.3f ms, %.1f MB/s\n", opt.bins, t, opt.len * sizeof(float) / t*1e-3);
	printf("Error in GPU calculation: %f\n", error(hist, cpu_hist, opt.bins));

	t = cudaHist_Approx(buf, hist, opt.len, opt.bins, p_opt);
	printf("cudaHist_Approx (%d bins): %.3f ms, %.1f MB/s\n", opt.bins, t, opt.len * sizeof(float) / t*1e-3);
	printf("Normalized error in GPU calculation: %f\n", normalized_error(hist, cpu_hist, opt.bins));

	delete [] buf;
	delete [] hist;
	delete [] cpu_hist;
	if (p_opt) delete p_opt;
	return 0;
}

