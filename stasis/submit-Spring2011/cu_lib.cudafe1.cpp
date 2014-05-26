# 1 "cu_lib.cu"
# 60 "/home/u0332192/local/cuda/include/device_types.h"
#if 0
# 60
enum cudaRoundMode { 
# 62
cudaRoundNearest, 
# 63
cudaRoundZero, 
# 64
cudaRoundPosInf, 
# 65
cudaRoundMinInf
# 66
}; 
#endif
# 149 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/stddef.h" 3
typedef long ptrdiff_t; 
# 211 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/stddef.h" 3
typedef unsigned long size_t; 
#include "crt/host_runtime.h"
# 118 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 118
enum cudaError { 
# 125
cudaSuccess, 
# 131
cudaErrorMissingConfiguration, 
# 137
cudaErrorMemoryAllocation, 
# 143
cudaErrorInitializationError, 
# 153
cudaErrorLaunchFailure, 
# 162
cudaErrorPriorLaunchFailure, 
# 172
cudaErrorLaunchTimeout, 
# 181
cudaErrorLaunchOutOfResources, 
# 187
cudaErrorInvalidDeviceFunction, 
# 196
cudaErrorInvalidConfiguration, 
# 202
cudaErrorInvalidDevice, 
# 208
cudaErrorInvalidValue, 
# 214
cudaErrorInvalidPitchValue, 
# 220
cudaErrorInvalidSymbol, 
# 225
cudaErrorMapBufferObjectFailed, 
# 230
cudaErrorUnmapBufferObjectFailed, 
# 236
cudaErrorInvalidHostPointer, 
# 242
cudaErrorInvalidDevicePointer, 
# 248
cudaErrorInvalidTexture, 
# 254
cudaErrorInvalidTextureBinding, 
# 261
cudaErrorInvalidChannelDescriptor, 
# 267
cudaErrorInvalidMemcpyDirection, 
# 277
cudaErrorAddressOfConstant, 
# 286
cudaErrorTextureFetchFailed, 
# 295
cudaErrorTextureNotBound, 
# 304
cudaErrorSynchronizationError, 
# 310
cudaErrorInvalidFilterSetting, 
# 316
cudaErrorInvalidNormSetting, 
# 324
cudaErrorMixedDeviceExecution, 
# 332
cudaErrorCudartUnloading, 
# 337
cudaErrorUnknown, 
# 343
cudaErrorNotYetImplemented, 
# 352
cudaErrorMemoryValueTooLarge, 
# 359
cudaErrorInvalidResourceHandle, 
# 367
cudaErrorNotReady, 
# 374
cudaErrorInsufficientDriver, 
# 387
cudaErrorSetOnActiveProcess, 
# 393
cudaErrorInvalidSurface, 
# 399
cudaErrorNoDevice, 
# 405
cudaErrorECCUncorrectable, 
# 410
cudaErrorSharedObjectSymbolNotFound, 
# 415
cudaErrorSharedObjectInitFailed, 
# 421
cudaErrorUnsupportedLimit, 
# 427
cudaErrorDuplicateVariableName, 
# 433
cudaErrorDuplicateTextureName, 
# 439
cudaErrorDuplicateSurfaceName, 
# 449
cudaErrorDevicesUnavailable, 
# 454
cudaErrorInvalidKernelImage, 
# 462
cudaErrorNoKernelImageForDevice, 
# 475
cudaErrorIncompatibleDriverContext, 
# 482
cudaErrorPeerAccessAlreadyEnabled, 
# 489
cudaErrorPeerAccessNotEnabled, 
# 495
cudaErrorDeviceAlreadyInUse = 54, 
# 503
cudaErrorProfilerDisabled, 
# 510
cudaErrorProfilerNotInitialized, 
# 517
cudaErrorProfilerAlreadyStarted, 
# 523
cudaErrorProfilerAlreadyStopped, 
# 528
cudaErrorStartupFailure = 127, 
# 534
cudaErrorApiFailureBase = 10000
# 535
}; 
#endif
# 541 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 541
enum cudaChannelFormatKind { 
# 543
cudaChannelFormatKindSigned, 
# 544
cudaChannelFormatKindUnsigned, 
# 545
cudaChannelFormatKindFloat, 
# 546
cudaChannelFormatKindNone
# 547
}; 
#endif
# 553 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 553
struct cudaChannelFormatDesc { 
# 555
int x; 
# 556
int y; 
# 557
int z; 
# 558
int w; 
# 559
cudaChannelFormatKind f; 
# 560
}; 
#endif
# 566 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
struct cudaArray; 
#endif
# 572 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 572
enum cudaMemoryType { 
# 574
cudaMemoryTypeHost = 1, 
# 575
cudaMemoryTypeDevice
# 576
}; 
#endif
# 582 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 582
enum cudaMemcpyKind { 
# 584
cudaMemcpyHostToHost, 
# 585
cudaMemcpyHostToDevice, 
# 586
cudaMemcpyDeviceToHost, 
# 587
cudaMemcpyDeviceToDevice, 
# 588
cudaMemcpyDefault
# 589
}; 
#endif
# 596 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 596
struct cudaPitchedPtr { 
# 598
void *ptr; 
# 599
size_t pitch; 
# 600
size_t xsize; 
# 601
size_t ysize; 
# 602
}; 
#endif
# 609 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 609
struct cudaExtent { 
# 611
size_t width; 
# 612
size_t height; 
# 613
size_t depth; 
# 614
}; 
#endif
# 621 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 621
struct cudaPos { 
# 623
size_t x; 
# 624
size_t y; 
# 625
size_t z; 
# 626
}; 
#endif
# 632 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 632
struct cudaMemcpy3DParms { 
# 634
cudaArray *srcArray; 
# 635
cudaPos srcPos; 
# 636
cudaPitchedPtr srcPtr; 
# 638
cudaArray *dstArray; 
# 639
cudaPos dstPos; 
# 640
cudaPitchedPtr dstPtr; 
# 642
cudaExtent extent; 
# 643
cudaMemcpyKind kind; __pad__(volatile char:8;)__pad__(volatile char:8;)__pad__(volatile char:8;)__pad__(volatile char:8;)
# 644
}; 
#endif
# 650 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 650
struct cudaMemcpy3DPeerParms { 
# 652
cudaArray *srcArray; 
# 653
cudaPos srcPos; 
# 654
cudaPitchedPtr srcPtr; 
# 655
int srcDevice; 
# 657
cudaArray *dstArray; 
# 658
cudaPos dstPos; 
# 659
cudaPitchedPtr dstPtr; 
# 660
int dstDevice; 
# 662
cudaExtent extent; 
# 663
}; 
#endif
# 669 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
struct cudaGraphicsResource; 
#endif
# 675 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 675
enum cudaGraphicsRegisterFlags { 
# 677
cudaGraphicsRegisterFlagsNone, 
# 678
cudaGraphicsRegisterFlagsReadOnly, 
# 679
cudaGraphicsRegisterFlagsWriteDiscard, 
# 680
cudaGraphicsRegisterFlagsSurfaceLoadStore = 4
# 681
}; 
#endif
# 687 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 687
enum cudaGraphicsMapFlags { 
# 689
cudaGraphicsMapFlagsNone, 
# 690
cudaGraphicsMapFlagsReadOnly, 
# 691
cudaGraphicsMapFlagsWriteDiscard
# 692
}; 
#endif
# 698 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 698
enum cudaGraphicsCubeFace { 
# 699
cudaGraphicsCubeFacePositiveX, 
# 700
cudaGraphicsCubeFaceNegativeX, 
# 701
cudaGraphicsCubeFacePositiveY, 
# 702
cudaGraphicsCubeFaceNegativeY, 
# 703
cudaGraphicsCubeFacePositiveZ, 
# 704
cudaGraphicsCubeFaceNegativeZ
# 705
}; 
#endif
# 711 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 711
struct cudaPointerAttributes { 
# 717
cudaMemoryType memoryType; 
# 728
int device; 
# 734
void *devicePointer; 
# 740
void *hostPointer; 
# 741
}; 
#endif
# 747 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 747
struct cudaFuncAttributes { 
# 754
size_t sharedSizeBytes; 
# 760
size_t constSizeBytes; 
# 765
size_t localSizeBytes; 
# 772
int maxThreadsPerBlock; 
# 777
int numRegs; 
# 784
int ptxVersion; 
# 791
int binaryVersion; 
# 792
}; 
#endif
# 798 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 798
enum cudaFuncCache { 
# 800
cudaFuncCachePreferNone, 
# 801
cudaFuncCachePreferShared, 
# 802
cudaFuncCachePreferL1
# 803
}; 
#endif
# 809 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 809
enum cudaComputeMode { 
# 811
cudaComputeModeDefault, 
# 812
cudaComputeModeExclusive, 
# 813
cudaComputeModeProhibited, 
# 814
cudaComputeModeExclusiveProcess
# 815
}; 
#endif
# 821 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 821
enum cudaLimit { 
# 823
cudaLimitStackSize, 
# 824
cudaLimitPrintfFifoSize, 
# 825
cudaLimitMallocHeapSize
# 826
}; 
#endif
# 832 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 832
enum cudaOutputMode { 
# 834
cudaKeyValuePair, 
# 835
cudaCSV
# 836
}; 
#endif
# 842 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
# 842
struct cudaDeviceProp { 
# 844
char name[256]; 
# 845
size_t totalGlobalMem; 
# 846
size_t sharedMemPerBlock; 
# 847
int regsPerBlock; 
# 848
int warpSize; 
# 849
size_t memPitch; 
# 850
int maxThreadsPerBlock; 
# 851
int maxThreadsDim[3]; 
# 852
int maxGridSize[3]; 
# 853
int clockRate; 
# 854
size_t totalConstMem; 
# 855
int major; 
# 856
int minor; 
# 857
size_t textureAlignment; 
# 858
int deviceOverlap; 
# 859
int multiProcessorCount; 
# 860
int kernelExecTimeoutEnabled; 
# 861
int integrated; 
# 862
int canMapHostMemory; 
# 863
int computeMode; 
# 864
int maxTexture1D; 
# 865
int maxTexture2D[2]; 
# 866
int maxTexture3D[3]; 
# 867
int maxTexture1DLayered[2]; 
# 868
int maxTexture2DLayered[3]; 
# 869
size_t surfaceAlignment; 
# 870
int concurrentKernels; 
# 871
int ECCEnabled; 
# 872
int pciBusID; 
# 873
int pciDeviceID; 
# 874
int pciDomainID; 
# 875
int tccDriver; 
# 876
int asyncEngineCount; 
# 877
int unifiedAddressing; 
# 878
int memoryClockRate; 
# 879
int memoryBusWidth; 
# 880
int l2CacheSize; 
# 881
int maxThreadsPerMultiProcessor; 
# 882
}; 
#endif
# 936 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
typedef cudaError 
# 936
cudaError_t; 
#endif
# 942 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
typedef struct CUstream_st *
# 942
cudaStream_t; 
#endif
# 948 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
typedef struct CUevent_st *
# 948
cudaEvent_t; 
#endif
# 954 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
typedef cudaGraphicsResource *
# 954
cudaGraphicsResource_t; 
#endif
# 960 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
typedef struct CUuuid_st 
# 960
cudaUUID_t; 
#endif
# 966 "/home/u0332192/local/cuda/include/driver_types.h"
#if 0
typedef cudaOutputMode 
# 966
cudaOutputMode_t; 
#endif
# 77 "/home/u0332192/local/cuda/include/surface_types.h"
#if 0
# 77
enum cudaSurfaceBoundaryMode { 
# 79
cudaBoundaryModeZero, 
# 80
cudaBoundaryModeClamp, 
# 81
cudaBoundaryModeTrap
# 82
}; 
#endif
# 88 "/home/u0332192/local/cuda/include/surface_types.h"
#if 0
# 88
enum cudaSurfaceFormatMode { 
# 90
cudaFormatModeForced, 
# 91
cudaFormatModeAuto
# 92
}; 
#endif
# 98 "/home/u0332192/local/cuda/include/surface_types.h"
#if 0
# 98
struct surfaceReference { 
# 103
cudaChannelFormatDesc channelDesc; 
# 104
}; 
#endif
# 83 "/home/u0332192/local/cuda/include/texture_types.h"
#if 0
# 83
enum cudaTextureAddressMode { 
# 85
cudaAddressModeWrap, 
# 86
cudaAddressModeClamp, 
# 87
cudaAddressModeMirror, 
# 88
cudaAddressModeBorder
# 89
}; 
#endif
# 95 "/home/u0332192/local/cuda/include/texture_types.h"
#if 0
# 95
enum cudaTextureFilterMode { 
# 97
cudaFilterModePoint, 
# 98
cudaFilterModeLinear
# 99
}; 
#endif
# 105 "/home/u0332192/local/cuda/include/texture_types.h"
#if 0
# 105
enum cudaTextureReadMode { 
# 107
cudaReadModeElementType, 
# 108
cudaReadModeNormalizedFloat
# 109
}; 
#endif
# 115 "/home/u0332192/local/cuda/include/texture_types.h"
#if 0
# 115
struct textureReference { 
# 120
int normalized; 
# 124
cudaTextureFilterMode filterMode; 
# 128
cudaTextureAddressMode addressMode[3]; 
# 132
cudaChannelFormatDesc channelDesc; 
# 136
int sRGB; 
# 137
int __cudaReserved[15]; 
# 138
}; 
#endif
# 92 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 92
struct char1 { 
# 94
signed char x; 
# 95
}; 
#endif
# 98 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 98
struct uchar1 { 
# 100
unsigned char x; 
# 101
}; 
#endif
# 104 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 104
struct __attribute((aligned(2))) char2 { 
# 106
signed char x, y; 
# 107
}; 
#endif
# 110 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 110
struct __attribute((aligned(2))) uchar2 { 
# 112
unsigned char x, y; 
# 113
}; 
#endif
# 116 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 116
struct char3 { 
# 118
signed char x, y, z; 
# 119
}; 
#endif
# 122 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 122
struct uchar3 { 
# 124
unsigned char x, y, z; 
# 125
}; 
#endif
# 128 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 128
struct __attribute((aligned(4))) char4 { 
# 130
signed char x, y, z, w; 
# 131
}; 
#endif
# 134 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 134
struct __attribute((aligned(4))) uchar4 { 
# 136
unsigned char x, y, z, w; 
# 137
}; 
#endif
# 140 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 140
struct short1 { 
# 142
short x; 
# 143
}; 
#endif
# 146 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 146
struct ushort1 { 
# 148
unsigned short x; 
# 149
}; 
#endif
# 152 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 152
struct __attribute((aligned(4))) short2 { 
# 154
short x, y; 
# 155
}; 
#endif
# 158 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 158
struct __attribute((aligned(4))) ushort2 { 
# 160
unsigned short x, y; 
# 161
}; 
#endif
# 164 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 164
struct short3 { 
# 166
short x, y, z; 
# 167
}; 
#endif
# 170 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 170
struct ushort3 { 
# 172
unsigned short x, y, z; 
# 173
}; 
#endif
# 176 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 176
struct __attribute((aligned(8))) short4 { short x; short y; short z; short w; }; 
#endif
# 179 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 179
struct __attribute((aligned(8))) ushort4 { unsigned short x; unsigned short y; unsigned short z; unsigned short w; }; 
#endif
# 182 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 182
struct int1 { 
# 184
int x; 
# 185
}; 
#endif
# 188 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 188
struct uint1 { 
# 190
unsigned x; 
# 191
}; 
#endif
# 194 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 194
struct __attribute((aligned(8))) int2 { int x; int y; }; 
#endif
# 197 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 197
struct __attribute((aligned(8))) uint2 { unsigned x; unsigned y; }; 
#endif
# 200 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 200
struct int3 { 
# 202
int x, y, z; 
# 203
}; 
#endif
# 206 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 206
struct uint3 { 
# 208
unsigned x, y, z; 
# 209
}; 
#endif
# 212 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 212
struct __attribute((aligned(16))) int4 { 
# 214
int x, y, z, w; 
# 215
}; 
#endif
# 218 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 218
struct __attribute((aligned(16))) uint4 { 
# 220
unsigned x, y, z, w; 
# 221
}; 
#endif
# 224 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 224
struct long1 { 
# 226
long x; 
# 227
}; 
#endif
# 230 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 230
struct ulong1 { 
# 232
unsigned long x; 
# 233
}; 
#endif
# 246 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 246
struct __attribute((aligned((2) * sizeof(long)))) long2 { 
# 248
long x, y; 
# 249
}; 
#endif
# 252 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 252
struct __attribute((aligned((2) * sizeof(unsigned long)))) ulong2 { 
# 254
unsigned long x, y; 
# 255
}; 
#endif
# 260 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 260
struct long3 { 
# 262
long x, y, z; 
# 263
}; 
#endif
# 266 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 266
struct ulong3 { 
# 268
unsigned long x, y, z; 
# 269
}; 
#endif
# 272 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 272
struct __attribute((aligned(16))) long4 { 
# 274
long x, y, z, w; 
# 275
}; 
#endif
# 278 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 278
struct __attribute((aligned(16))) ulong4 { 
# 280
unsigned long x, y, z, w; 
# 281
}; 
#endif
# 284 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 284
struct float1 { 
# 286
float x; 
# 287
}; 
#endif
# 290 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 290
struct __attribute((aligned(8))) float2 { float x; float y; }; 
#endif
# 293 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 293
struct float3 { 
# 295
float x, y, z; 
# 296
}; 
#endif
# 299 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 299
struct __attribute((aligned(16))) float4 { 
# 301
float x, y, z, w; 
# 302
}; 
#endif
# 305 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 305
struct longlong1 { 
# 307
long long x; 
# 308
}; 
#endif
# 311 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 311
struct ulonglong1 { 
# 313
unsigned long long x; 
# 314
}; 
#endif
# 317 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 317
struct __attribute((aligned(16))) longlong2 { 
# 319
long long x, y; 
# 320
}; 
#endif
# 323 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 323
struct __attribute((aligned(16))) ulonglong2 { 
# 325
unsigned long long x, y; 
# 326
}; 
#endif
# 329 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 329
struct longlong3 { 
# 331
long long x, y, z; 
# 332
}; 
#endif
# 335 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 335
struct ulonglong3 { 
# 337
unsigned long long x, y, z; 
# 338
}; 
#endif
# 341 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 341
struct __attribute((aligned(16))) longlong4 { 
# 343
long long x, y, z, w; 
# 344
}; 
#endif
# 347 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 347
struct __attribute((aligned(16))) ulonglong4 { 
# 349
unsigned long long x, y, z, w; 
# 350
}; 
#endif
# 353 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 353
struct double1 { 
# 355
double x; 
# 356
}; 
#endif
# 359 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 359
struct __attribute((aligned(16))) double2 { 
# 361
double x, y; 
# 362
}; 
#endif
# 365 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 365
struct double3 { 
# 367
double x, y, z; 
# 368
}; 
#endif
# 371 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 371
struct __attribute((aligned(16))) double4 { 
# 373
double x, y, z, w; 
# 374
}; 
#endif
# 390 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef char1 
# 390
char1; 
#endif
# 392 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uchar1 
# 392
uchar1; 
#endif
# 394 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef char2 
# 394
char2; 
#endif
# 396 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uchar2 
# 396
uchar2; 
#endif
# 398 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef char3 
# 398
char3; 
#endif
# 400 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uchar3 
# 400
uchar3; 
#endif
# 402 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef char4 
# 402
char4; 
#endif
# 404 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uchar4 
# 404
uchar4; 
#endif
# 406 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef short1 
# 406
short1; 
#endif
# 408 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ushort1 
# 408
ushort1; 
#endif
# 410 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef short2 
# 410
short2; 
#endif
# 412 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ushort2 
# 412
ushort2; 
#endif
# 414 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef short3 
# 414
short3; 
#endif
# 416 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ushort3 
# 416
ushort3; 
#endif
# 418 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef short4 
# 418
short4; 
#endif
# 420 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ushort4 
# 420
ushort4; 
#endif
# 422 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef int1 
# 422
int1; 
#endif
# 424 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uint1 
# 424
uint1; 
#endif
# 426 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef int2 
# 426
int2; 
#endif
# 428 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uint2 
# 428
uint2; 
#endif
# 430 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef int3 
# 430
int3; 
#endif
# 432 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uint3 
# 432
uint3; 
#endif
# 434 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef int4 
# 434
int4; 
#endif
# 436 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef uint4 
# 436
uint4; 
#endif
# 438 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef long1 
# 438
long1; 
#endif
# 440 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulong1 
# 440
ulong1; 
#endif
# 442 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef long2 
# 442
long2; 
#endif
# 444 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulong2 
# 444
ulong2; 
#endif
# 446 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef long3 
# 446
long3; 
#endif
# 448 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulong3 
# 448
ulong3; 
#endif
# 450 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef long4 
# 450
long4; 
#endif
# 452 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulong4 
# 452
ulong4; 
#endif
# 454 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef float1 
# 454
float1; 
#endif
# 456 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef float2 
# 456
float2; 
#endif
# 458 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef float3 
# 458
float3; 
#endif
# 460 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef float4 
# 460
float4; 
#endif
# 462 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef longlong1 
# 462
longlong1; 
#endif
# 464 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulonglong1 
# 464
ulonglong1; 
#endif
# 466 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef longlong2 
# 466
longlong2; 
#endif
# 468 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulonglong2 
# 468
ulonglong2; 
#endif
# 470 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef longlong3 
# 470
longlong3; 
#endif
# 472 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulonglong3 
# 472
ulonglong3; 
#endif
# 474 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef longlong4 
# 474
longlong4; 
#endif
# 476 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef ulonglong4 
# 476
ulonglong4; 
#endif
# 478 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef double1 
# 478
double1; 
#endif
# 480 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef double2 
# 480
double2; 
#endif
# 482 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef double3 
# 482
double3; 
#endif
# 484 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef double4 
# 484
double4; 
#endif
# 493 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
# 493
struct dim3 { 
# 495
unsigned x, y, z; 
# 501
}; 
#endif
# 504 "/home/u0332192/local/cuda/include/vector_types.h"
#if 0
typedef dim3 
# 504
dim3; 
#endif
# 134 "/home/u0332192/local/cuda/include/cuda_runtime_api.h"
extern "C" cudaError_t cudaDeviceReset(); 
# 151
extern "C" cudaError_t cudaDeviceSynchronize(); 
# 203
extern "C" cudaError_t cudaDeviceSetLimit(cudaLimit , size_t ); 
# 227
extern "C" cudaError_t cudaDeviceGetLimit(size_t * , cudaLimit ); 
# 257
extern "C" cudaError_t cudaDeviceGetCacheConfig(cudaFuncCache * ); 
# 298
extern "C" cudaError_t cudaDeviceSetCacheConfig(cudaFuncCache ); 
# 332
extern "C" cudaError_t cudaThreadExit(); 
# 356
extern "C" cudaError_t cudaThreadSynchronize(); 
# 415
extern "C" cudaError_t cudaThreadSetLimit(cudaLimit , size_t ); 
# 446
extern "C" cudaError_t cudaThreadGetLimit(size_t * , cudaLimit ); 
# 481
extern "C" cudaError_t cudaThreadGetCacheConfig(cudaFuncCache * ); 
# 527
extern "C" cudaError_t cudaThreadSetCacheConfig(cudaFuncCache ); 
# 581
extern "C" cudaError_t cudaGetLastError(); 
# 624
extern "C" cudaError_t cudaPeekAtLastError(); 
# 638
extern "C" const char *cudaGetErrorString(cudaError_t ); 
# 668
extern "C" cudaError_t cudaGetDeviceCount(int * ); 
# 829
extern "C" cudaError_t cudaGetDeviceProperties(cudaDeviceProp * , int ); 
# 848
extern "C" cudaError_t cudaChooseDevice(int * , const cudaDeviceProp * ); 
# 881
extern "C" cudaError_t cudaSetDevice(int ); 
# 898
extern "C" cudaError_t cudaGetDevice(int * ); 
# 927
extern "C" cudaError_t cudaSetValidDevices(int * , int ); 
# 987
extern "C" cudaError_t cudaSetDeviceFlags(unsigned ); 
# 1013
extern "C" cudaError_t cudaStreamCreate(cudaStream_t * ); 
# 1034
extern "C" cudaError_t cudaStreamDestroy(cudaStream_t ); 
# 1070
extern "C" cudaError_t cudaStreamWaitEvent(cudaStream_t , cudaEvent_t , unsigned ); 
# 1089
extern "C" cudaError_t cudaStreamSynchronize(cudaStream_t ); 
# 1107
extern "C" cudaError_t cudaStreamQuery(cudaStream_t ); 
# 1139
extern "C" cudaError_t cudaEventCreate(cudaEvent_t * ); 
# 1170
extern "C" cudaError_t cudaEventCreateWithFlags(cudaEvent_t * , unsigned ); 
# 1203
extern "C" cudaError_t cudaEventRecord(cudaEvent_t , cudaStream_t  = 0); 
# 1232
extern "C" cudaError_t cudaEventQuery(cudaEvent_t ); 
# 1264
extern "C" cudaError_t cudaEventSynchronize(cudaEvent_t ); 
# 1289
extern "C" cudaError_t cudaEventDestroy(cudaEvent_t ); 
# 1330
extern "C" cudaError_t cudaEventElapsedTime(float * , cudaEvent_t , cudaEvent_t ); 
# 1369
extern "C" cudaError_t cudaConfigureCall(dim3 , dim3 , size_t  = (0), cudaStream_t  = 0); 
# 1396
extern "C" cudaError_t cudaSetupArgument(const void * , size_t , size_t ); 
# 1442
extern "C" cudaError_t cudaFuncSetCacheConfig(const char * , cudaFuncCache ); 
# 1477
extern "C" cudaError_t cudaLaunch(const char * ); 
# 1510
extern "C" cudaError_t cudaFuncGetAttributes(cudaFuncAttributes * , const char * ); 
# 1532
extern "C" cudaError_t cudaSetDoubleForDevice(double * ); 
# 1554
extern "C" cudaError_t cudaSetDoubleForHost(double * ); 
# 1586
extern "C" cudaError_t cudaMalloc(void ** , size_t ); 
# 1615
extern "C" cudaError_t cudaMallocHost(void ** , size_t ); 
# 1654
extern "C" cudaError_t cudaMallocPitch(void ** , size_t * , size_t , size_t ); 
# 1693
extern "C" cudaError_t cudaMallocArray(cudaArray ** , const cudaChannelFormatDesc * , size_t , size_t  = (0), unsigned  = (0)); 
# 1717
extern "C" cudaError_t cudaFree(void * ); 
# 1737
extern "C" cudaError_t cudaFreeHost(void * ); 
# 1759
extern "C" cudaError_t cudaFreeArray(cudaArray * ); 
# 1818
extern "C" cudaError_t cudaHostAlloc(void ** , size_t , unsigned ); 
# 1874
extern "C" cudaError_t cudaHostRegister(void * , size_t , unsigned ); 
# 1893
extern "C" cudaError_t cudaHostUnregister(void * ); 
# 1920
extern "C" cudaError_t cudaHostGetDevicePointer(void ** , void * , unsigned ); 
# 1939
extern "C" cudaError_t cudaHostGetFlags(unsigned * , void * ); 
# 1974
extern "C" cudaError_t cudaMalloc3D(cudaPitchedPtr * , cudaExtent ); 
# 2035
extern "C" cudaError_t cudaMalloc3DArray(cudaArray ** , const cudaChannelFormatDesc * , cudaExtent , unsigned  = (0)); 
# 2132
extern "C" cudaError_t cudaMemcpy3D(const cudaMemcpy3DParms * ); 
# 2159
extern "C" cudaError_t cudaMemcpy3DPeer(const cudaMemcpy3DPeerParms * ); 
# 2264
extern "C" cudaError_t cudaMemcpy3DAsync(const cudaMemcpy3DParms * , cudaStream_t  = 0); 
# 2285
extern "C" cudaError_t cudaMemcpy3DPeerAsync(const cudaMemcpy3DPeerParms * , cudaStream_t  = 0); 
# 2304
extern "C" cudaError_t cudaMemGetInfo(size_t * , size_t * ); 
# 2337
extern "C" cudaError_t cudaMemcpy(void * , const void * , size_t , cudaMemcpyKind ); 
# 2368
extern "C" cudaError_t cudaMemcpyPeer(void * , int , const void * , int , size_t ); 
# 2401
extern "C" cudaError_t cudaMemcpyToArray(cudaArray * , size_t , size_t , const void * , size_t , cudaMemcpyKind ); 
# 2434
extern "C" cudaError_t cudaMemcpyFromArray(void * , const cudaArray * , size_t , size_t , size_t , cudaMemcpyKind ); 
# 2469
extern "C" cudaError_t cudaMemcpyArrayToArray(cudaArray * , size_t , size_t , const cudaArray * , size_t , size_t , size_t , cudaMemcpyKind  = cudaMemcpyDeviceToDevice); 
# 2511
extern "C" cudaError_t cudaMemcpy2D(void * , size_t , const void * , size_t , size_t , size_t , cudaMemcpyKind ); 
# 2552
extern "C" cudaError_t cudaMemcpy2DToArray(cudaArray * , size_t , size_t , const void * , size_t , size_t , size_t , cudaMemcpyKind ); 
# 2593
extern "C" cudaError_t cudaMemcpy2DFromArray(void * , size_t , const cudaArray * , size_t , size_t , size_t , size_t , cudaMemcpyKind ); 
# 2632
extern "C" cudaError_t cudaMemcpy2DArrayToArray(cudaArray * , size_t , size_t , const cudaArray * , size_t , size_t , size_t , size_t , cudaMemcpyKind  = cudaMemcpyDeviceToDevice); 
# 2667
extern "C" cudaError_t cudaMemcpyToSymbol(const char * , const void * , size_t , size_t  = (0), cudaMemcpyKind  = cudaMemcpyHostToDevice); 
# 2701
extern "C" cudaError_t cudaMemcpyFromSymbol(void * , const char * , size_t , size_t  = (0), cudaMemcpyKind  = cudaMemcpyDeviceToHost); 
# 2744
extern "C" cudaError_t cudaMemcpyAsync(void * , const void * , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 2774
extern "C" cudaError_t cudaMemcpyPeerAsync(void * , int , const void * , int , size_t , cudaStream_t  = 0); 
# 2816
extern "C" cudaError_t cudaMemcpyToArrayAsync(cudaArray * , size_t , size_t , const void * , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 2858
extern "C" cudaError_t cudaMemcpyFromArrayAsync(void * , const cudaArray * , size_t , size_t , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 2909
extern "C" cudaError_t cudaMemcpy2DAsync(void * , size_t , const void * , size_t , size_t , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 2959
extern "C" cudaError_t cudaMemcpy2DToArrayAsync(cudaArray * , size_t , size_t , const void * , size_t , size_t , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 3009
extern "C" cudaError_t cudaMemcpy2DFromArrayAsync(void * , size_t , const cudaArray * , size_t , size_t , size_t , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 3053
extern "C" cudaError_t cudaMemcpyToSymbolAsync(const char * , const void * , size_t , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 3096
extern "C" cudaError_t cudaMemcpyFromSymbolAsync(void * , const char * , size_t , size_t , cudaMemcpyKind , cudaStream_t  = 0); 
# 3118
extern "C" cudaError_t cudaMemset(void * , int , size_t ); 
# 3144
extern "C" cudaError_t cudaMemset2D(void * , size_t , int , size_t , size_t ); 
# 3183
extern "C" cudaError_t cudaMemset3D(cudaPitchedPtr , int , cudaExtent ); 
# 3210
extern "C" cudaError_t cudaMemsetAsync(void * , int , size_t , cudaStream_t  = 0); 
# 3242
extern "C" cudaError_t cudaMemset2DAsync(void * , size_t , int , size_t , size_t , cudaStream_t  = 0); 
# 3287
extern "C" cudaError_t cudaMemset3DAsync(cudaPitchedPtr , int , cudaExtent , cudaStream_t  = 0); 
# 3314
extern "C" cudaError_t cudaGetSymbolAddress(void ** , const char * ); 
# 3337
extern "C" cudaError_t cudaGetSymbolSize(size_t * , const char * ); 
# 3482
extern "C" cudaError_t cudaPointerGetAttributes(cudaPointerAttributes * , void * ); 
# 3516
extern "C" cudaError_t cudaDeviceCanAccessPeer(int * , int , int ); 
# 3557
extern "C" cudaError_t cudaDeviceEnablePeerAccess(int , unsigned ); 
# 3582
extern "C" cudaError_t cudaDeviceDisablePeerAccess(int ); 
# 3628
extern "C" cudaError_t cudaGraphicsUnregisterResource(cudaGraphicsResource_t ); 
# 3660
extern "C" cudaError_t cudaGraphicsResourceSetMapFlags(cudaGraphicsResource_t , unsigned ); 
# 3695
extern "C" cudaError_t cudaGraphicsMapResources(int , cudaGraphicsResource_t * , cudaStream_t  = 0); 
# 3726
extern "C" cudaError_t cudaGraphicsUnmapResources(int , cudaGraphicsResource_t * , cudaStream_t  = 0); 
# 3755
extern "C" cudaError_t cudaGraphicsResourceGetMappedPointer(void ** , size_t * , cudaGraphicsResource_t ); 
# 3789
extern "C" cudaError_t cudaGraphicsSubResourceGetMappedArray(cudaArray ** , cudaGraphicsResource_t , unsigned , unsigned ); 
# 3822
extern "C" cudaError_t cudaGetChannelDesc(cudaChannelFormatDesc * , const cudaArray * ); 
# 3857
extern "C" cudaChannelFormatDesc cudaCreateChannelDesc(int , int , int , int , cudaChannelFormatKind ); 
# 3899
extern "C" cudaError_t cudaBindTexture(size_t * , const textureReference * , const void * , const cudaChannelFormatDesc * , size_t  = (((2147483647) * 2U) + 1U)); 
# 3942
extern "C" cudaError_t cudaBindTexture2D(size_t * , const textureReference * , const void * , const cudaChannelFormatDesc * , size_t , size_t , size_t ); 
# 3970
extern "C" cudaError_t cudaBindTextureToArray(const textureReference * , const cudaArray * , const cudaChannelFormatDesc * ); 
# 3991
extern "C" cudaError_t cudaUnbindTexture(const textureReference * ); 
# 4016
extern "C" cudaError_t cudaGetTextureAlignmentOffset(size_t * , const textureReference * ); 
# 4040
extern "C" cudaError_t cudaGetTextureReference(const textureReference ** , const char * ); 
# 4073
extern "C" cudaError_t cudaBindSurfaceToArray(const surfaceReference * , const cudaArray * , const cudaChannelFormatDesc * ); 
# 4091
extern "C" cudaError_t cudaGetSurfaceReference(const surfaceReference ** , const char * ); 
# 4118
extern "C" cudaError_t cudaDriverGetVersion(int * ); 
# 4135
extern "C" cudaError_t cudaRuntimeGetVersion(int * ); 
# 4140
extern "C" cudaError_t cudaGetExportTable(const void ** , const cudaUUID_t * ); 
# 107 "/home/u0332192/local/cuda/include/channel_descriptor.h"
template< class T> inline cudaChannelFormatDesc cudaCreateChannelDesc() 
# 108
{ 
# 109
return cudaCreateChannelDesc(0, 0, 0, 0, cudaChannelFormatKindNone); 
# 110
} 
# 112
static inline cudaChannelFormatDesc cudaCreateChannelDescHalf() 
# 113
{ 
# 114
int e = (((int)sizeof(unsigned short)) * 8); 
# 116
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindFloat); 
# 117
} 
# 119
static inline cudaChannelFormatDesc cudaCreateChannelDescHalf1() 
# 120
{ 
# 121
int e = (((int)sizeof(unsigned short)) * 8); 
# 123
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindFloat); 
# 124
} 
# 126
static inline cudaChannelFormatDesc cudaCreateChannelDescHalf2() 
# 127
{ 
# 128
int e = (((int)sizeof(unsigned short)) * 8); 
# 130
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindFloat); 
# 131
} 
# 133
static inline cudaChannelFormatDesc cudaCreateChannelDescHalf4() 
# 134
{ 
# 135
int e = (((int)sizeof(unsigned short)) * 8); 
# 137
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindFloat); 
# 138
} 
# 140
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< char> () 
# 141
{ 
# 142
int e = (((int)sizeof(char)) * 8); 
# 147
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindSigned); 
# 149
} 
# 151
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< signed char> () 
# 152
{ 
# 153
int e = (((int)sizeof(signed char)) * 8); 
# 155
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindSigned); 
# 156
} 
# 158
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< unsigned char> () 
# 159
{ 
# 160
int e = (((int)sizeof(unsigned char)) * 8); 
# 162
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindUnsigned); 
# 163
} 
# 165
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< char1> () 
# 166
{ 
# 167
int e = (((int)sizeof(signed char)) * 8); 
# 169
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindSigned); 
# 170
} 
# 172
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< uchar1> () 
# 173
{ 
# 174
int e = (((int)sizeof(unsigned char)) * 8); 
# 176
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindUnsigned); 
# 177
} 
# 179
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< char2> () 
# 180
{ 
# 181
int e = (((int)sizeof(signed char)) * 8); 
# 183
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindSigned); 
# 184
} 
# 186
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< uchar2> () 
# 187
{ 
# 188
int e = (((int)sizeof(unsigned char)) * 8); 
# 190
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindUnsigned); 
# 191
} 
# 193
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< char4> () 
# 194
{ 
# 195
int e = (((int)sizeof(signed char)) * 8); 
# 197
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindSigned); 
# 198
} 
# 200
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< uchar4> () 
# 201
{ 
# 202
int e = (((int)sizeof(unsigned char)) * 8); 
# 204
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindUnsigned); 
# 205
} 
# 207
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< short> () 
# 208
{ 
# 209
int e = (((int)sizeof(short)) * 8); 
# 211
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindSigned); 
# 212
} 
# 214
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< unsigned short> () 
# 215
{ 
# 216
int e = (((int)sizeof(unsigned short)) * 8); 
# 218
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindUnsigned); 
# 219
} 
# 221
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< short1> () 
# 222
{ 
# 223
int e = (((int)sizeof(short)) * 8); 
# 225
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindSigned); 
# 226
} 
# 228
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< ushort1> () 
# 229
{ 
# 230
int e = (((int)sizeof(unsigned short)) * 8); 
# 232
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindUnsigned); 
# 233
} 
# 235
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< short2> () 
# 236
{ 
# 237
int e = (((int)sizeof(short)) * 8); 
# 239
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindSigned); 
# 240
} 
# 242
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< ushort2> () 
# 243
{ 
# 244
int e = (((int)sizeof(unsigned short)) * 8); 
# 246
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindUnsigned); 
# 247
} 
# 249
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< short4> () 
# 250
{ 
# 251
int e = (((int)sizeof(short)) * 8); 
# 253
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindSigned); 
# 254
} 
# 256
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< ushort4> () 
# 257
{ 
# 258
int e = (((int)sizeof(unsigned short)) * 8); 
# 260
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindUnsigned); 
# 261
} 
# 263
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< int> () 
# 264
{ 
# 265
int e = (((int)sizeof(int)) * 8); 
# 267
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindSigned); 
# 268
} 
# 270
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< unsigned> () 
# 271
{ 
# 272
int e = (((int)sizeof(unsigned)) * 8); 
# 274
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindUnsigned); 
# 275
} 
# 277
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< int1> () 
# 278
{ 
# 279
int e = (((int)sizeof(int)) * 8); 
# 281
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindSigned); 
# 282
} 
# 284
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< uint1> () 
# 285
{ 
# 286
int e = (((int)sizeof(unsigned)) * 8); 
# 288
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindUnsigned); 
# 289
} 
# 291
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< int2> () 
# 292
{ 
# 293
int e = (((int)sizeof(int)) * 8); 
# 295
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindSigned); 
# 296
} 
# 298
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< uint2> () 
# 299
{ 
# 300
int e = (((int)sizeof(unsigned)) * 8); 
# 302
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindUnsigned); 
# 303
} 
# 305
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< int4> () 
# 306
{ 
# 307
int e = (((int)sizeof(int)) * 8); 
# 309
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindSigned); 
# 310
} 
# 312
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< uint4> () 
# 313
{ 
# 314
int e = (((int)sizeof(unsigned)) * 8); 
# 316
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindUnsigned); 
# 317
} 
# 379 "/home/u0332192/local/cuda/include/channel_descriptor.h"
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< float> () 
# 380
{ 
# 381
int e = (((int)sizeof(float)) * 8); 
# 383
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindFloat); 
# 384
} 
# 386
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< float1> () 
# 387
{ 
# 388
int e = (((int)sizeof(float)) * 8); 
# 390
return cudaCreateChannelDesc(e, 0, 0, 0, cudaChannelFormatKindFloat); 
# 391
} 
# 393
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< float2> () 
# 394
{ 
# 395
int e = (((int)sizeof(float)) * 8); 
# 397
return cudaCreateChannelDesc(e, e, 0, 0, cudaChannelFormatKindFloat); 
# 398
} 
# 400
template<> inline cudaChannelFormatDesc cudaCreateChannelDesc< float4> () 
# 401
{ 
# 402
int e = (((int)sizeof(float)) * 8); 
# 404
return cudaCreateChannelDesc(e, e, e, e, cudaChannelFormatKindFloat); 
# 405
} 
# 79 "/home/u0332192/local/cuda/include/driver_functions.h"
static inline cudaPitchedPtr make_cudaPitchedPtr(void *d, size_t p, size_t xsz, size_t ysz) 
# 80
{ 
# 81
cudaPitchedPtr s; 
# 83
(s.ptr) = d; 
# 84
(s.pitch) = p; 
# 85
(s.xsize) = xsz; 
# 86
(s.ysize) = ysz; 
# 88
return s; 
# 89
} 
# 106
static inline cudaPos make_cudaPos(size_t x, size_t y, size_t z) 
# 107
{ 
# 108
cudaPos p; 
# 110
(p.x) = x; 
# 111
(p.y) = y; 
# 112
(p.z) = z; 
# 114
return p; 
# 115
} 
# 132
static inline cudaExtent make_cudaExtent(size_t w, size_t h, size_t d) 
# 133
{ 
# 134
cudaExtent e; 
# 136
(e.width) = w; 
# 137
(e.height) = h; 
# 138
(e.depth) = d; 
# 140
return e; 
# 141
} 
# 69 "/home/u0332192/local/cuda/include/vector_functions.h"
static inline char1 make_char1(signed char x) 
# 70
{ 
# 71
char1 t; (t.x) = x; return t; 
# 72
} 
# 74
static inline uchar1 make_uchar1(unsigned char x) 
# 75
{ 
# 76
uchar1 t; (t.x) = x; return t; 
# 77
} 
# 79
static inline char2 make_char2(signed char x, signed char y) 
# 80
{ 
# 81
char2 t; (t.x) = x; (t.y) = y; return t; 
# 82
} 
# 84
static inline uchar2 make_uchar2(unsigned char x, unsigned char y) 
# 85
{ 
# 86
uchar2 t; (t.x) = x; (t.y) = y; return t; 
# 87
} 
# 89
static inline char3 make_char3(signed char x, signed char y, signed char z) 
# 90
{ 
# 91
char3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 92
} 
# 94
static inline uchar3 make_uchar3(unsigned char x, unsigned char y, unsigned char z) 
# 95
{ 
# 96
uchar3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 97
} 
# 99
static inline char4 make_char4(signed char x, signed char y, signed char z, signed char w) 
# 100
{ 
# 101
char4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 102
} 
# 104
static inline uchar4 make_uchar4(unsigned char x, unsigned char y, unsigned char z, unsigned char w) 
# 105
{ 
# 106
uchar4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 107
} 
# 109
static inline short1 make_short1(short x) 
# 110
{ 
# 111
short1 t; (t.x) = x; return t; 
# 112
} 
# 114
static inline ushort1 make_ushort1(unsigned short x) 
# 115
{ 
# 116
ushort1 t; (t.x) = x; return t; 
# 117
} 
# 119
static inline short2 make_short2(short x, short y) 
# 120
{ 
# 121
short2 t; (t.x) = x; (t.y) = y; return t; 
# 122
} 
# 124
static inline ushort2 make_ushort2(unsigned short x, unsigned short y) 
# 125
{ 
# 126
ushort2 t; (t.x) = x; (t.y) = y; return t; 
# 127
} 
# 129
static inline short3 make_short3(short x, short y, short z) 
# 130
{ 
# 131
short3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 132
} 
# 134
static inline ushort3 make_ushort3(unsigned short x, unsigned short y, unsigned short z) 
# 135
{ 
# 136
ushort3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 137
} 
# 139
static inline short4 make_short4(short x, short y, short z, short w) 
# 140
{ 
# 141
short4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 142
} 
# 144
static inline ushort4 make_ushort4(unsigned short x, unsigned short y, unsigned short z, unsigned short w) 
# 145
{ 
# 146
ushort4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 147
} 
# 149
static inline int1 make_int1(int x) 
# 150
{ 
# 151
int1 t; (t.x) = x; return t; 
# 152
} 
# 154
static inline uint1 make_uint1(unsigned x) 
# 155
{ 
# 156
uint1 t; (t.x) = x; return t; 
# 157
} 
# 159
static inline int2 make_int2(int x, int y) 
# 160
{ 
# 161
int2 t; (t.x) = x; (t.y) = y; return t; 
# 162
} 
# 164
static inline uint2 make_uint2(unsigned x, unsigned y) 
# 165
{ 
# 166
uint2 t; (t.x) = x; (t.y) = y; return t; 
# 167
} 
# 169
static inline int3 make_int3(int x, int y, int z) 
# 170
{ 
# 171
int3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 172
} 
# 174
static inline uint3 make_uint3(unsigned x, unsigned y, unsigned z) 
# 175
{ 
# 176
uint3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 177
} 
# 179
static inline int4 make_int4(int x, int y, int z, int w) 
# 180
{ 
# 181
int4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 182
} 
# 184
static inline uint4 make_uint4(unsigned x, unsigned y, unsigned z, unsigned w) 
# 185
{ 
# 186
uint4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 187
} 
# 189
static inline long1 make_long1(long x) 
# 190
{ 
# 191
long1 t; (t.x) = x; return t; 
# 192
} 
# 194
static inline ulong1 make_ulong1(unsigned long x) 
# 195
{ 
# 196
ulong1 t; (t.x) = x; return t; 
# 197
} 
# 199
static inline long2 make_long2(long x, long y) 
# 200
{ 
# 201
long2 t; (t.x) = x; (t.y) = y; return t; 
# 202
} 
# 204
static inline ulong2 make_ulong2(unsigned long x, unsigned long y) 
# 205
{ 
# 206
ulong2 t; (t.x) = x; (t.y) = y; return t; 
# 207
} 
# 209
static inline long3 make_long3(long x, long y, long z) 
# 210
{ 
# 211
long3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 212
} 
# 214
static inline ulong3 make_ulong3(unsigned long x, unsigned long y, unsigned long z) 
# 215
{ 
# 216
ulong3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 217
} 
# 219
static inline long4 make_long4(long x, long y, long z, long w) 
# 220
{ 
# 221
long4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 222
} 
# 224
static inline ulong4 make_ulong4(unsigned long x, unsigned long y, unsigned long z, unsigned long w) 
# 225
{ 
# 226
ulong4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 227
} 
# 229
static inline float1 make_float1(float x) 
# 230
{ 
# 231
float1 t; (t.x) = x; return t; 
# 232
} 
# 234
static inline float2 make_float2(float x, float y) 
# 235
{ 
# 236
float2 t; (t.x) = x; (t.y) = y; return t; 
# 237
} 
# 239
static inline float3 make_float3(float x, float y, float z) 
# 240
{ 
# 241
float3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 242
} 
# 244
static inline float4 make_float4(float x, float y, float z, float w) 
# 245
{ 
# 246
float4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 247
} 
# 249
static inline longlong1 make_longlong1(long long x) 
# 250
{ 
# 251
longlong1 t; (t.x) = x; return t; 
# 252
} 
# 254
static inline ulonglong1 make_ulonglong1(unsigned long long x) 
# 255
{ 
# 256
ulonglong1 t; (t.x) = x; return t; 
# 257
} 
# 259
static inline longlong2 make_longlong2(long long x, long long y) 
# 260
{ 
# 261
longlong2 t; (t.x) = x; (t.y) = y; return t; 
# 262
} 
# 264
static inline ulonglong2 make_ulonglong2(unsigned long long x, unsigned long long y) 
# 265
{ 
# 266
ulonglong2 t; (t.x) = x; (t.y) = y; return t; 
# 267
} 
# 269
static inline longlong3 make_longlong3(long long x, long long y, long long z) 
# 270
{ 
# 271
longlong3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 272
} 
# 274
static inline ulonglong3 make_ulonglong3(unsigned long long x, unsigned long long y, unsigned long long z) 
# 275
{ 
# 276
ulonglong3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 277
} 
# 279
static inline longlong4 make_longlong4(long long x, long long y, long long z, long long w) 
# 280
{ 
# 281
longlong4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 282
} 
# 284
static inline ulonglong4 make_ulonglong4(unsigned long long x, unsigned long long y, unsigned long long z, unsigned long long w) 
# 285
{ 
# 286
ulonglong4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 287
} 
# 289
static inline double1 make_double1(double x) 
# 290
{ 
# 291
double1 t; (t.x) = x; return t; 
# 292
} 
# 294
static inline double2 make_double2(double x, double y) 
# 295
{ 
# 296
double2 t; (t.x) = x; (t.y) = y; return t; 
# 297
} 
# 299
static inline double3 make_double3(double x, double y, double z) 
# 300
{ 
# 301
double3 t; (t.x) = x; (t.y) = y; (t.z) = z; return t; 
# 302
} 
# 304
static inline double4 make_double4(double x, double y, double z, double w) 
# 305
{ 
# 306
double4 t; (t.x) = x; (t.y) = y; (t.z) = z; (t.w) = w; return t; 
# 307
} 
# 44 "/usr/include/string.h" 3
extern "C" void *memcpy(void *__restrict__ , const void *__restrict__ , size_t ) throw()
# 46
 __attribute((__nonnull__(1, 2))); 
# 49
extern "C" void *memmove(void * , const void * , size_t ) throw()
# 50
 __attribute((__nonnull__(1, 2))); 
# 57
extern "C" void *memccpy(void *__restrict__ , const void *__restrict__ , int , size_t ) throw()
# 59
 __attribute((__nonnull__(1, 2))); 
# 65
extern "C" void *memset(void * , int , size_t ) throw() __attribute((__nonnull__(1))); 
# 68
extern "C" int memcmp(const void * , const void * , size_t ) throw()
# 69
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 75
extern void *memchr(void * , int , size_t ) throw() __asm__("memchr")
# 76
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 77
extern const void *memchr(const void * , int , size_t ) throw() __asm__("memchr")
# 78
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 104 "/usr/include/string.h" 3
void *rawmemchr(void * , int ) throw() __asm__("rawmemchr")
# 105
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 106
const void *rawmemchr(const void * , int ) throw() __asm__("rawmemchr")
# 107
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 115
void *memrchr(void * , int , size_t ) throw() __asm__("memrchr")
# 116
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 117
const void *memrchr(const void * , int , size_t ) throw() __asm__("memrchr")
# 118
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 128
extern "C" char *strcpy(char *__restrict__ , const char *__restrict__ ) throw()
# 129
 __attribute((__nonnull__(1, 2))); 
# 131
extern "C" char *strncpy(char *__restrict__ , const char *__restrict__ , size_t ) throw()
# 133
 __attribute((__nonnull__(1, 2))); 
# 136
extern "C" char *strcat(char *__restrict__ , const char *__restrict__ ) throw()
# 137
 __attribute((__nonnull__(1, 2))); 
# 139
extern "C" char *strncat(char *__restrict__ , const char *__restrict__ , size_t ) throw()
# 140
 __attribute((__nonnull__(1, 2))); 
# 143
extern "C" int strcmp(const char * , const char * ) throw()
# 144
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 146
extern "C" int strncmp(const char * , const char * , size_t ) throw()
# 147
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 150
extern "C" int strcoll(const char * , const char * ) throw()
# 151
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 153
extern "C" size_t strxfrm(char *__restrict__ , const char *__restrict__ , size_t ) throw()
# 155
 __attribute((__nonnull__(2))); 
# 40 "/usr/include/xlocale.h" 3
extern "C" { typedef 
# 28
struct __locale_struct { 
# 31
struct __locale_data *__locales[13]; 
# 34
const unsigned short *__ctype_b; 
# 35
const int *__ctype_tolower; 
# 36
const int *__ctype_toupper; 
# 39
const char *__names[13]; 
# 40
} *__locale_t; }
# 43
extern "C" { typedef __locale_t locale_t; }
# 165 "/usr/include/string.h" 3
extern "C" int strcoll_l(const char * , const char * , __locale_t ) throw()
# 166
 __attribute((__pure__)) __attribute((__nonnull__(1, 2, 3))); 
# 168
extern "C" size_t strxfrm_l(char * , const char * , size_t , __locale_t ) throw()
# 169
 __attribute((__nonnull__(2, 4))); 
# 175
extern "C" char *strdup(const char * ) throw()
# 176
 __attribute((__malloc__)) __attribute((__nonnull__(1))); 
# 183
extern "C" char *strndup(const char * , size_t ) throw()
# 184
 __attribute((__malloc__)) __attribute((__nonnull__(1))); 
# 215 "/usr/include/string.h" 3
extern char *strchr(char * , int ) throw() __asm__("strchr")
# 216
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 217
extern const char *strchr(const char * , int ) throw() __asm__("strchr")
# 218
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 242 "/usr/include/string.h" 3
extern char *strrchr(char * , int ) throw() __asm__("strrchr")
# 243
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 244
extern const char *strrchr(const char * , int ) throw() __asm__("strrchr")
# 245
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 271 "/usr/include/string.h" 3
char *strchrnul(char * , int ) throw() __asm__("strchrnul")
# 272
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 273
const char *strchrnul(const char * , int ) throw() __asm__("strchrnul")
# 274
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 284
extern "C" size_t strcspn(const char * , const char * ) throw()
# 285
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 288
extern "C" size_t strspn(const char * , const char * ) throw()
# 289
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 294
extern char *strpbrk(char * , const char * ) throw() __asm__("strpbrk")
# 295
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 296
extern const char *strpbrk(const char * , const char * ) throw() __asm__("strpbrk")
# 297
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 321 "/usr/include/string.h" 3
extern char *strstr(char * , const char * ) throw() __asm__("strstr")
# 322
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 323
extern const char *strstr(const char * , const char * ) throw() __asm__("strstr")
# 325
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 348 "/usr/include/string.h" 3
extern "C" char *strtok(char *__restrict__ , const char *__restrict__ ) throw()
# 349
 __attribute((__nonnull__(2))); 
# 354
extern "C" char *__strtok_r(char *__restrict__ , const char *__restrict__ , char **__restrict__ ) throw()
# 357
 __attribute((__nonnull__(2, 3))); 
# 359
extern "C" char *strtok_r(char *__restrict__ , const char *__restrict__ , char **__restrict__ ) throw()
# 361
 __attribute((__nonnull__(2, 3))); 
# 367
char *strcasestr(char * , const char * ) throw() __asm__("strcasestr")
# 368
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 369
const char *strcasestr(const char * , const char * ) throw() __asm__("strcasestr")
# 371
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 382
extern "C" void *memmem(const void * , size_t , const void * , size_t ) throw()
# 384
 __attribute((__pure__)) __attribute((__nonnull__(1, 3))); 
# 388
extern "C" void *__mempcpy(void *__restrict__ , const void *__restrict__ , size_t ) throw()
# 390
 __attribute((__nonnull__(1, 2))); 
# 391
extern "C" void *mempcpy(void *__restrict__ , const void *__restrict__ , size_t ) throw()
# 393
 __attribute((__nonnull__(1, 2))); 
# 399
extern "C" size_t strlen(const char * ) throw()
# 400
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 406
extern "C" size_t strnlen(const char * , size_t ) throw()
# 407
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 413
extern "C" char *strerror(int ) throw(); 
# 438 "/usr/include/string.h" 3
extern "C" char *strerror_r(int , char * , size_t ) throw()
# 439
 __attribute((__nonnull__(2))); 
# 445
extern "C" char *strerror_l(int , __locale_t ) throw(); 
# 451
extern "C" void __bzero(void * , size_t ) throw() __attribute((__nonnull__(1))); 
# 455
extern "C" void bcopy(const void * , void * , size_t ) throw()
# 456
 __attribute((__nonnull__(1, 2))); 
# 459
extern "C" void bzero(void * , size_t ) throw() __attribute((__nonnull__(1))); 
# 462
extern "C" int bcmp(const void * , const void * , size_t ) throw()
# 463
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 469
extern char *index(char * , int ) throw() __asm__("index")
# 470
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 471
extern const char *index(const char * , int ) throw() __asm__("index")
# 472
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 497 "/usr/include/string.h" 3
extern char *rindex(char * , int ) throw() __asm__("rindex")
# 498
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 499
extern const char *rindex(const char * , int ) throw() __asm__("rindex")
# 500
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 523 "/usr/include/string.h" 3
extern "C" int ffs(int ) throw() __attribute((const)); 
# 528
extern "C" int ffsl(long ) throw() __attribute((const)); 
# 530
extern "C" int ffsll(long long ) throw()
# 531
 __attribute((const)); 
# 536
extern "C" int strcasecmp(const char * , const char * ) throw()
# 537
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 540
extern "C" int strncasecmp(const char * , const char * , size_t ) throw()
# 541
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 547
extern "C" int strcasecmp_l(const char * , const char * , __locale_t ) throw()
# 549
 __attribute((__pure__)) __attribute((__nonnull__(1, 2, 3))); 
# 551
extern "C" int strncasecmp_l(const char * , const char * , size_t , __locale_t ) throw()
# 553
 __attribute((__pure__)) __attribute((__nonnull__(1, 2, 4))); 
# 559
extern "C" char *strsep(char **__restrict__ , const char *__restrict__ ) throw()
# 561
 __attribute((__nonnull__(1, 2))); 
# 566
extern "C" char *strsignal(int ) throw(); 
# 569
extern "C" char *__stpcpy(char *__restrict__ , const char *__restrict__ ) throw()
# 570
 __attribute((__nonnull__(1, 2))); 
# 571
extern "C" char *stpcpy(char *__restrict__ , const char *__restrict__ ) throw()
# 572
 __attribute((__nonnull__(1, 2))); 
# 576
extern "C" char *__stpncpy(char *__restrict__ , const char *__restrict__ , size_t ) throw()
# 578
 __attribute((__nonnull__(1, 2))); 
# 579
extern "C" char *stpncpy(char *__restrict__ , const char *__restrict__ , size_t ) throw()
# 581
 __attribute((__nonnull__(1, 2))); 
# 586
extern "C" int strverscmp(const char * , const char * ) throw()
# 587
 __attribute((__pure__)) __attribute((__nonnull__(1, 2))); 
# 590
extern "C" char *strfry(char * ) throw() __attribute((__nonnull__(1))); 
# 593
extern "C" void *memfrob(void * , size_t ) throw() __attribute((__nonnull__(1))); 
# 601
char *basename(char * ) throw() __asm__("basename")
# 602
 __attribute((__nonnull__(1))); 
# 603
const char *basename(const char * ) throw() __asm__("basename")
# 604
 __attribute((__nonnull__(1))); 
# 31 "/usr/include/bits/types.h" 3
extern "C" { typedef unsigned char __u_char; }
# 32
extern "C" { typedef unsigned short __u_short; }
# 33
extern "C" { typedef unsigned __u_int; }
# 34
extern "C" { typedef unsigned long __u_long; }
# 37
extern "C" { typedef signed char __int8_t; }
# 38
extern "C" { typedef unsigned char __uint8_t; }
# 39
extern "C" { typedef signed short __int16_t; }
# 40
extern "C" { typedef unsigned short __uint16_t; }
# 41
extern "C" { typedef signed int __int32_t; }
# 42
extern "C" { typedef unsigned __uint32_t; }
# 44
extern "C" { typedef signed long __int64_t; }
# 45
extern "C" { typedef unsigned long __uint64_t; }
# 53
extern "C" { typedef long __quad_t; }
# 54
extern "C" { typedef unsigned long __u_quad_t; }
# 134 "/usr/include/bits/types.h" 3
extern "C" { typedef unsigned long __dev_t; }
# 135
extern "C" { typedef unsigned __uid_t; }
# 136
extern "C" { typedef unsigned __gid_t; }
# 137
extern "C" { typedef unsigned long __ino_t; }
# 138
extern "C" { typedef unsigned long __ino64_t; }
# 139
extern "C" { typedef unsigned __mode_t; }
# 140
extern "C" { typedef unsigned long __nlink_t; }
# 141
extern "C" { typedef long __off_t; }
# 142
extern "C" { typedef long __off64_t; }
# 143
extern "C" { typedef int __pid_t; }
# 144
extern "C" { typedef struct { int __val[2]; } __fsid_t; }
# 145
extern "C" { typedef long __clock_t; }
# 146
extern "C" { typedef unsigned long __rlim_t; }
# 147
extern "C" { typedef unsigned long __rlim64_t; }
# 148
extern "C" { typedef unsigned __id_t; }
# 149
extern "C" { typedef long __time_t; }
# 150
extern "C" { typedef unsigned __useconds_t; }
# 151
extern "C" { typedef long __suseconds_t; }
# 153
extern "C" { typedef int __daddr_t; }
# 154
extern "C" { typedef long __swblk_t; }
# 155
extern "C" { typedef int __key_t; }
# 158
extern "C" { typedef int __clockid_t; }
# 161
extern "C" { typedef void *__timer_t; }
# 164
extern "C" { typedef long __blksize_t; }
# 169
extern "C" { typedef long __blkcnt_t; }
# 170
extern "C" { typedef long __blkcnt64_t; }
# 173
extern "C" { typedef unsigned long __fsblkcnt_t; }
# 174
extern "C" { typedef unsigned long __fsblkcnt64_t; }
# 177
extern "C" { typedef unsigned long __fsfilcnt_t; }
# 178
extern "C" { typedef unsigned long __fsfilcnt64_t; }
# 180
extern "C" { typedef long __ssize_t; }
# 184
extern "C" { typedef __off64_t __loff_t; }
# 185
extern "C" { typedef __quad_t *__qaddr_t; }
# 186
extern "C" { typedef char *__caddr_t; }
# 189
extern "C" { typedef long __intptr_t; }
# 192
extern "C" { typedef unsigned __socklen_t; }
# 60 "/usr/include/time.h" 3
extern "C" { typedef __clock_t clock_t; }
# 76 "/usr/include/time.h" 3
extern "C" { typedef __time_t time_t; }
# 92 "/usr/include/time.h" 3
extern "C" { typedef __clockid_t clockid_t; }
# 104 "/usr/include/time.h" 3
extern "C" { typedef __timer_t timer_t; }
# 120 "/usr/include/time.h" 3
extern "C" { struct timespec { 
# 122
__time_t tv_sec; 
# 123
long tv_nsec; 
# 124
}; }
# 133
extern "C" { struct tm { 
# 135
int tm_sec; 
# 136
int tm_min; 
# 137
int tm_hour; 
# 138
int tm_mday; 
# 139
int tm_mon; 
# 140
int tm_year; 
# 141
int tm_wday; 
# 142
int tm_yday; 
# 143
int tm_isdst; 
# 146
long tm_gmtoff; 
# 147
const char *tm_zone; 
# 152
}; }
# 161
extern "C" { struct itimerspec { 
# 163
timespec it_interval; 
# 164
timespec it_value; 
# 165
}; }
# 168
struct sigevent; 
# 174
extern "C" { typedef __pid_t pid_t; }
# 183
extern "C" clock_t clock() throw(); 
# 186
extern "C" time_t time(time_t * ) throw(); 
# 189
extern "C" double difftime(time_t , time_t ) throw()
# 190
 __attribute((const)); 
# 193
extern "C" time_t mktime(tm * ) throw(); 
# 199
extern "C" size_t strftime(char *__restrict__ , size_t , const char *__restrict__ , const tm *__restrict__ ) throw(); 
# 207
extern "C" char *strptime(const char *__restrict__ , const char *__restrict__ , tm * ) throw(); 
# 217 "/usr/include/time.h" 3
extern "C" size_t strftime_l(char *__restrict__ , size_t , const char *__restrict__ , const tm *__restrict__ , __locale_t ) throw(); 
# 224
extern "C" char *strptime_l(const char *__restrict__ , const char *__restrict__ , tm * , __locale_t ) throw(); 
# 233
extern "C" tm *gmtime(const time_t * ) throw(); 
# 237
extern "C" tm *localtime(const time_t * ) throw(); 
# 243
extern "C" tm *gmtime_r(const time_t *__restrict__ , tm *__restrict__ ) throw(); 
# 248
extern "C" tm *localtime_r(const time_t *__restrict__ , tm *__restrict__ ) throw(); 
# 255
extern "C" char *asctime(const tm * ) throw(); 
# 258
extern "C" char *ctime(const time_t * ) throw(); 
# 266
extern "C" char *asctime_r(const tm *__restrict__ , char *__restrict__ ) throw(); 
# 270
extern "C" char *ctime_r(const time_t *__restrict__ , char *__restrict__ ) throw(); 
# 276
extern "C" { extern char *__tzname[2]; } 
# 277
extern "C" { extern int __daylight; } 
# 278
extern "C" { extern long __timezone; } 
# 283
extern "C" { extern char *tzname[2]; } 
# 287
extern "C" void tzset() throw(); 
# 291
extern "C" { extern int daylight; } 
# 292
extern "C" { extern long timezone; } 
# 298
extern "C" int stime(const time_t * ) throw(); 
# 313
extern "C" time_t timegm(tm * ) throw(); 
# 316
extern "C" time_t timelocal(tm * ) throw(); 
# 319
extern "C" int dysize(int ) throw() __attribute((const)); 
# 328
extern "C" int nanosleep(const timespec * , timespec * ); 
# 333
extern "C" int clock_getres(clockid_t , timespec * ) throw(); 
# 336
extern "C" int clock_gettime(clockid_t , timespec * ) throw(); 
# 339
extern "C" int clock_settime(clockid_t , const timespec * ) throw(); 
# 347
extern "C" int clock_nanosleep(clockid_t , int , const timespec * , timespec * ); 
# 352
extern "C" int clock_getcpuclockid(pid_t , clockid_t * ) throw(); 
# 357
extern "C" int timer_create(clockid_t , sigevent *__restrict__ , timer_t *__restrict__ ) throw(); 
# 362
extern "C" int timer_delete(timer_t ) throw(); 
# 365
extern "C" int timer_settime(timer_t , int , const itimerspec *__restrict__ , itimerspec *__restrict__ ) throw(); 
# 370
extern "C" int timer_gettime(timer_t , itimerspec * ) throw(); 
# 374
extern "C" int timer_getoverrun(timer_t ) throw(); 
# 390
extern "C" { extern int getdate_err; } 
# 399
extern "C" tm *getdate(const char * ); 
# 413
extern "C" int getdate_r(const char *__restrict__ , tm *__restrict__ ); 
# 71 "/home/u0332192/local/cuda/include/common_functions.h"
extern "C" clock_t clock() throw(); 
# 73
extern "C" void *memset(void *, int, size_t) throw(); 
# 75
extern "C" void *memcpy(void *, const void *, size_t) throw(); 
# 31 "/usr/include/bits/mathdef.h" 3
extern "C" { typedef float float_t; }
# 32
extern "C" { typedef double double_t; }
# 55 "/usr/include/bits/mathcalls.h" 3
extern "C" double acos(double ) throw(); extern "C" double __acos(double ) throw(); 
# 57
extern "C" double asin(double ) throw(); extern "C" double __asin(double ) throw(); 
# 59
extern "C" double atan(double ) throw(); extern "C" double __atan(double ) throw(); 
# 61
extern "C" double atan2(double , double ) throw(); extern "C" double __atan2(double , double ) throw(); 
# 64
extern "C" double cos(double ) throw(); extern "C" double __cos(double ) throw(); 
# 66
extern "C" double sin(double ) throw(); extern "C" double __sin(double ) throw(); 
# 68
extern "C" double tan(double ) throw(); extern "C" double __tan(double ) throw(); 
# 73
extern "C" double cosh(double ) throw(); extern "C" double __cosh(double ) throw(); 
# 75
extern "C" double sinh(double ) throw(); extern "C" double __sinh(double ) throw(); 
# 77
extern "C" double tanh(double ) throw(); extern "C" double __tanh(double ) throw(); 
# 82
extern "C" void sincos(double , double * , double * ) throw(); extern "C" void __sincos(double , double * , double * ) throw(); 
# 89
extern "C" double acosh(double ) throw(); extern "C" double __acosh(double ) throw(); 
# 91
extern "C" double asinh(double ) throw(); extern "C" double __asinh(double ) throw(); 
# 93
extern "C" double atanh(double ) throw(); extern "C" double __atanh(double ) throw(); 
# 101
extern "C" double exp(double ) throw(); extern "C" double __exp(double ) throw(); 
# 104
extern "C" double frexp(double , int * ) throw(); extern "C" double __frexp(double , int * ) throw(); 
# 107
extern "C" double ldexp(double , int ) throw(); extern "C" double __ldexp(double , int ) throw(); 
# 110
extern "C" double log(double ) throw(); extern "C" double __log(double ) throw(); 
# 113
extern "C" double log10(double ) throw(); extern "C" double __log10(double ) throw(); 
# 116
extern "C" double modf(double , double * ) throw(); extern "C" double __modf(double , double * ) throw(); 
# 121
extern "C" double exp10(double ) throw(); extern "C" double __exp10(double ) throw(); 
# 123
extern "C" double pow10(double ) throw(); extern "C" double __pow10(double ) throw(); 
# 129
extern "C" double expm1(double ) throw(); extern "C" double __expm1(double ) throw(); 
# 132
extern "C" double log1p(double ) throw(); extern "C" double __log1p(double ) throw(); 
# 135
extern "C" double logb(double ) throw(); extern "C" double __logb(double ) throw(); 
# 142
extern "C" double exp2(double ) throw(); extern "C" double __exp2(double ) throw(); 
# 145
extern "C" double log2(double ) throw(); extern "C" double __log2(double ) throw(); 
# 154
extern "C" double pow(double , double ) throw(); extern "C" double __pow(double , double ) throw(); 
# 157
extern "C" double sqrt(double ) throw(); extern "C" double __sqrt(double ) throw(); 
# 163
extern "C" double hypot(double , double ) throw(); extern "C" double __hypot(double , double ) throw(); 
# 170
extern "C" double cbrt(double ) throw(); extern "C" double __cbrt(double ) throw(); 
# 179
extern "C" double ceil(double ) throw() __attribute((const)); extern "C" double __ceil(double ) throw() __attribute((const)); 
# 182
extern "C" double fabs(double ) throw() __attribute((const)); extern "C" double __fabs(double ) throw() __attribute((const)); 
# 185
extern "C" double floor(double ) throw() __attribute((const)); extern "C" double __floor(double ) throw() __attribute((const)); 
# 188
extern "C" double fmod(double , double ) throw(); extern "C" double __fmod(double , double ) throw(); 
# 193
extern "C" int __isinf(double ) throw() __attribute((const)); 
# 196
extern "C" int __finite(double ) throw() __attribute((const)); 
# 202
extern "C" int isinf(double ) throw() __attribute((const)); 
# 205
extern "C" int finite(double ) throw() __attribute((const)); 
# 208
extern "C" double drem(double , double ) throw(); extern "C" double __drem(double , double ) throw(); 
# 212
extern "C" double significand(double ) throw(); extern "C" double __significand(double ) throw(); 
# 218
extern "C" double copysign(double , double ) throw() __attribute((const)); extern "C" double __copysign(double , double ) throw() __attribute((const)); 
# 225
extern "C" double nan(const char * ) throw() __attribute((const)); extern "C" double __nan(const char * ) throw() __attribute((const)); 
# 231
extern "C" int __isnan(double ) throw() __attribute((const)); 
# 235
extern "C" int isnan(double ) throw() __attribute((const)); 
# 238
extern "C" double j0(double) throw(); extern "C" double __j0(double) throw(); 
# 239
extern "C" double j1(double) throw(); extern "C" double __j1(double) throw(); 
# 240
extern "C" double jn(int, double) throw(); extern "C" double __jn(int, double) throw(); 
# 241
extern "C" double y0(double) throw(); extern "C" double __y0(double) throw(); 
# 242
extern "C" double y1(double) throw(); extern "C" double __y1(double) throw(); 
# 243
extern "C" double yn(int, double) throw(); extern "C" double __yn(int, double) throw(); 
# 250
extern "C" double erf(double) throw(); extern "C" double __erf(double) throw(); 
# 251
extern "C" double erfc(double) throw(); extern "C" double __erfc(double) throw(); 
# 252
extern "C" double lgamma(double) throw(); extern "C" double __lgamma(double) throw(); 
# 259
extern "C" double tgamma(double) throw(); extern "C" double __tgamma(double) throw(); 
# 265
extern "C" double gamma(double) throw(); extern "C" double __gamma(double) throw(); 
# 272
extern "C" double lgamma_r(double, int * ) throw(); extern "C" double __lgamma_r(double, int * ) throw(); 
# 280
extern "C" double rint(double ) throw(); extern "C" double __rint(double ) throw(); 
# 283
extern "C" double nextafter(double , double ) throw() __attribute((const)); extern "C" double __nextafter(double , double ) throw() __attribute((const)); 
# 285
extern "C" double nexttoward(double , long double ) throw() __attribute((const)); extern "C" double __nexttoward(double , long double ) throw() __attribute((const)); 
# 289
extern "C" double remainder(double , double ) throw(); extern "C" double __remainder(double , double ) throw(); 
# 293
extern "C" double scalbn(double , int ) throw(); extern "C" double __scalbn(double , int ) throw(); 
# 297
extern "C" int ilogb(double ) throw(); extern "C" int __ilogb(double ) throw(); 
# 302
extern "C" double scalbln(double , long ) throw(); extern "C" double __scalbln(double , long ) throw(); 
# 306
extern "C" double nearbyint(double ) throw(); extern "C" double __nearbyint(double ) throw(); 
# 310
extern "C" double round(double ) throw() __attribute((const)); extern "C" double __round(double ) throw() __attribute((const)); 
# 314
extern "C" double trunc(double ) throw() __attribute((const)); extern "C" double __trunc(double ) throw() __attribute((const)); 
# 319
extern "C" double remquo(double , double , int * ) throw(); extern "C" double __remquo(double , double , int * ) throw(); 
# 326
extern "C" long lrint(double ) throw(); extern "C" long __lrint(double ) throw(); 
# 327
extern "C" long long llrint(double ) throw(); extern "C" long long __llrint(double ) throw(); 
# 331
extern "C" long lround(double ) throw(); extern "C" long __lround(double ) throw(); 
# 332
extern "C" long long llround(double ) throw(); extern "C" long long __llround(double ) throw(); 
# 336
extern "C" double fdim(double , double ) throw(); extern "C" double __fdim(double , double ) throw(); 
# 339
extern "C" double fmax(double , double ) throw(); extern "C" double __fmax(double , double ) throw(); 
# 342
extern "C" double fmin(double , double ) throw(); extern "C" double __fmin(double , double ) throw(); 
# 346
extern "C" int __fpclassify(double ) throw()
# 347
 __attribute((const)); 
# 350
extern "C" int __signbit(double ) throw()
# 351
 __attribute((const)); 
# 355
extern "C" double fma(double , double , double ) throw(); extern "C" double __fma(double , double , double ) throw(); 
# 364
extern "C" double scalb(double , double ) throw(); extern "C" double __scalb(double , double ) throw(); 
# 55 "/usr/include/bits/mathcalls.h" 3
extern "C" float acosf(float ) throw(); extern "C" float __acosf(float ) throw(); 
# 57
extern "C" float asinf(float ) throw(); extern "C" float __asinf(float ) throw(); 
# 59
extern "C" float atanf(float ) throw(); extern "C" float __atanf(float ) throw(); 
# 61
extern "C" float atan2f(float , float ) throw(); extern "C" float __atan2f(float , float ) throw(); 
# 64
extern "C" float cosf(float ) throw(); 
# 66
extern "C" float sinf(float ) throw(); 
# 68
extern "C" float tanf(float ) throw(); 
# 73
extern "C" float coshf(float ) throw(); extern "C" float __coshf(float ) throw(); 
# 75
extern "C" float sinhf(float ) throw(); extern "C" float __sinhf(float ) throw(); 
# 77
extern "C" float tanhf(float ) throw(); extern "C" float __tanhf(float ) throw(); 
# 82
extern "C" void sincosf(float , float * , float * ) throw(); 
# 89
extern "C" float acoshf(float ) throw(); extern "C" float __acoshf(float ) throw(); 
# 91
extern "C" float asinhf(float ) throw(); extern "C" float __asinhf(float ) throw(); 
# 93
extern "C" float atanhf(float ) throw(); extern "C" float __atanhf(float ) throw(); 
# 101
extern "C" float expf(float ) throw(); 
# 104
extern "C" float frexpf(float , int * ) throw(); extern "C" float __frexpf(float , int * ) throw(); 
# 107
extern "C" float ldexpf(float , int ) throw(); extern "C" float __ldexpf(float , int ) throw(); 
# 110
extern "C" float logf(float ) throw(); 
# 113
extern "C" float log10f(float ) throw(); 
# 116
extern "C" float modff(float , float * ) throw(); extern "C" float __modff(float , float * ) throw(); 
# 121
extern "C" float exp10f(float ) throw(); 
# 123
extern "C" float pow10f(float ) throw(); extern "C" float __pow10f(float ) throw(); 
# 129
extern "C" float expm1f(float ) throw(); extern "C" float __expm1f(float ) throw(); 
# 132
extern "C" float log1pf(float ) throw(); extern "C" float __log1pf(float ) throw(); 
# 135
extern "C" float logbf(float ) throw(); extern "C" float __logbf(float ) throw(); 
# 142
extern "C" float exp2f(float ) throw(); extern "C" float __exp2f(float ) throw(); 
# 145
extern "C" float log2f(float ) throw(); 
# 154
extern "C" float powf(float , float ) throw(); 
# 157
extern "C" float sqrtf(float ) throw(); extern "C" float __sqrtf(float ) throw(); 
# 163
extern "C" float hypotf(float , float ) throw(); extern "C" float __hypotf(float , float ) throw(); 
# 170
extern "C" float cbrtf(float ) throw(); extern "C" float __cbrtf(float ) throw(); 
# 179
extern "C" float ceilf(float ) throw() __attribute((const)); extern "C" float __ceilf(float ) throw() __attribute((const)); 
# 182
extern "C" float fabsf(float ) throw() __attribute((const)); extern "C" float __fabsf(float ) throw() __attribute((const)); 
# 185
extern "C" float floorf(float ) throw() __attribute((const)); extern "C" float __floorf(float ) throw() __attribute((const)); 
# 188
extern "C" float fmodf(float , float ) throw(); extern "C" float __fmodf(float , float ) throw(); 
# 193
extern "C" int __isinff(float ) throw() __attribute((const)); 
# 196
extern "C" int __finitef(float ) throw() __attribute((const)); 
# 202
extern "C" int isinff(float ) throw() __attribute((const)); 
# 205
extern "C" int finitef(float ) throw() __attribute((const)); 
# 208
extern "C" float dremf(float , float ) throw(); extern "C" float __dremf(float , float ) throw(); 
# 212
extern "C" float significandf(float ) throw(); extern "C" float __significandf(float ) throw(); 
# 218
extern "C" float copysignf(float , float ) throw() __attribute((const)); extern "C" float __copysignf(float , float ) throw() __attribute((const)); 
# 225
extern "C" float nanf(const char * ) throw() __attribute((const)); extern "C" float __nanf(const char * ) throw() __attribute((const)); 
# 231
extern "C" int __isnanf(float ) throw() __attribute((const)); 
# 235
extern "C" int isnanf(float ) throw() __attribute((const)); 
# 238
extern "C" float j0f(float) throw(); extern "C" float __j0f(float) throw(); 
# 239
extern "C" float j1f(float) throw(); extern "C" float __j1f(float) throw(); 
# 240
extern "C" float jnf(int, float) throw(); extern "C" float __jnf(int, float) throw(); 
# 241
extern "C" float y0f(float) throw(); extern "C" float __y0f(float) throw(); 
# 242
extern "C" float y1f(float) throw(); extern "C" float __y1f(float) throw(); 
# 243
extern "C" float ynf(int, float) throw(); extern "C" float __ynf(int, float) throw(); 
# 250
extern "C" float erff(float) throw(); extern "C" float __erff(float) throw(); 
# 251
extern "C" float erfcf(float) throw(); extern "C" float __erfcf(float) throw(); 
# 252
extern "C" float lgammaf(float) throw(); extern "C" float __lgammaf(float) throw(); 
# 259
extern "C" float tgammaf(float) throw(); extern "C" float __tgammaf(float) throw(); 
# 265
extern "C" float gammaf(float) throw(); extern "C" float __gammaf(float) throw(); 
# 272
extern "C" float lgammaf_r(float, int * ) throw(); extern "C" float __lgammaf_r(float, int * ) throw(); 
# 280
extern "C" float rintf(float ) throw(); extern "C" float __rintf(float ) throw(); 
# 283
extern "C" float nextafterf(float , float ) throw() __attribute((const)); extern "C" float __nextafterf(float , float ) throw() __attribute((const)); 
# 285
extern "C" float nexttowardf(float , long double ) throw() __attribute((const)); extern "C" float __nexttowardf(float , long double ) throw() __attribute((const)); 
# 289
extern "C" float remainderf(float , float ) throw(); extern "C" float __remainderf(float , float ) throw(); 
# 293
extern "C" float scalbnf(float , int ) throw(); extern "C" float __scalbnf(float , int ) throw(); 
# 297
extern "C" int ilogbf(float ) throw(); extern "C" int __ilogbf(float ) throw(); 
# 302
extern "C" float scalblnf(float , long ) throw(); extern "C" float __scalblnf(float , long ) throw(); 
# 306
extern "C" float nearbyintf(float ) throw(); extern "C" float __nearbyintf(float ) throw(); 
# 310
extern "C" float roundf(float ) throw() __attribute((const)); extern "C" float __roundf(float ) throw() __attribute((const)); 
# 314
extern "C" float truncf(float ) throw() __attribute((const)); extern "C" float __truncf(float ) throw() __attribute((const)); 
# 319
extern "C" float remquof(float , float , int * ) throw(); extern "C" float __remquof(float , float , int * ) throw(); 
# 326
extern "C" long lrintf(float ) throw(); extern "C" long __lrintf(float ) throw(); 
# 327
extern "C" long long llrintf(float ) throw(); extern "C" long long __llrintf(float ) throw(); 
# 331
extern "C" long lroundf(float ) throw(); extern "C" long __lroundf(float ) throw(); 
# 332
extern "C" long long llroundf(float ) throw(); extern "C" long long __llroundf(float ) throw(); 
# 336
extern "C" float fdimf(float , float ) throw(); extern "C" float __fdimf(float , float ) throw(); 
# 339
extern "C" float fmaxf(float , float ) throw(); extern "C" float __fmaxf(float , float ) throw(); 
# 342
extern "C" float fminf(float , float ) throw(); extern "C" float __fminf(float , float ) throw(); 
# 346
extern "C" int __fpclassifyf(float ) throw()
# 347
 __attribute((const)); 
# 350
extern "C" int __signbitf(float ) throw()
# 351
 __attribute((const)); 
# 355
extern "C" float fmaf(float , float , float ) throw(); extern "C" float __fmaf(float , float , float ) throw(); 
# 364
extern "C" float scalbf(float , float ) throw(); extern "C" float __scalbf(float , float ) throw(); 
# 55 "/usr/include/bits/mathcalls.h" 3
extern "C" long double acosl(long double ) throw(); extern "C" long double __acosl(long double ) throw(); 
# 57
extern "C" long double asinl(long double ) throw(); extern "C" long double __asinl(long double ) throw(); 
# 59
extern "C" long double atanl(long double ) throw(); extern "C" long double __atanl(long double ) throw(); 
# 61
extern "C" long double atan2l(long double , long double ) throw(); extern "C" long double __atan2l(long double , long double ) throw(); 
# 64
extern "C" long double cosl(long double ) throw(); extern "C" long double __cosl(long double ) throw(); 
# 66
extern "C" long double sinl(long double ) throw(); extern "C" long double __sinl(long double ) throw(); 
# 68
extern "C" long double tanl(long double ) throw(); extern "C" long double __tanl(long double ) throw(); 
# 73
extern "C" long double coshl(long double ) throw(); extern "C" long double __coshl(long double ) throw(); 
# 75
extern "C" long double sinhl(long double ) throw(); extern "C" long double __sinhl(long double ) throw(); 
# 77
extern "C" long double tanhl(long double ) throw(); extern "C" long double __tanhl(long double ) throw(); 
# 82
extern "C" void sincosl(long double , long double * , long double * ) throw(); extern "C" void __sincosl(long double , long double * , long double * ) throw(); 
# 89
extern "C" long double acoshl(long double ) throw(); extern "C" long double __acoshl(long double ) throw(); 
# 91
extern "C" long double asinhl(long double ) throw(); extern "C" long double __asinhl(long double ) throw(); 
# 93
extern "C" long double atanhl(long double ) throw(); extern "C" long double __atanhl(long double ) throw(); 
# 101
extern "C" long double expl(long double ) throw(); extern "C" long double __expl(long double ) throw(); 
# 104
extern "C" long double frexpl(long double , int * ) throw(); extern "C" long double __frexpl(long double , int * ) throw(); 
# 107
extern "C" long double ldexpl(long double , int ) throw(); extern "C" long double __ldexpl(long double , int ) throw(); 
# 110
extern "C" long double logl(long double ) throw(); extern "C" long double __logl(long double ) throw(); 
# 113
extern "C" long double log10l(long double ) throw(); extern "C" long double __log10l(long double ) throw(); 
# 116
extern "C" long double modfl(long double , long double * ) throw(); extern "C" long double __modfl(long double , long double * ) throw(); 
# 121
extern "C" long double exp10l(long double ) throw(); extern "C" long double __exp10l(long double ) throw(); 
# 123
extern "C" long double pow10l(long double ) throw(); extern "C" long double __pow10l(long double ) throw(); 
# 129
extern "C" long double expm1l(long double ) throw(); extern "C" long double __expm1l(long double ) throw(); 
# 132
extern "C" long double log1pl(long double ) throw(); extern "C" long double __log1pl(long double ) throw(); 
# 135
extern "C" long double logbl(long double ) throw(); extern "C" long double __logbl(long double ) throw(); 
# 142
extern "C" long double exp2l(long double ) throw(); extern "C" long double __exp2l(long double ) throw(); 
# 145
extern "C" long double log2l(long double ) throw(); extern "C" long double __log2l(long double ) throw(); 
# 154
extern "C" long double powl(long double , long double ) throw(); extern "C" long double __powl(long double , long double ) throw(); 
# 157
extern "C" long double sqrtl(long double ) throw(); extern "C" long double __sqrtl(long double ) throw(); 
# 163
extern "C" long double hypotl(long double , long double ) throw(); extern "C" long double __hypotl(long double , long double ) throw(); 
# 170
extern "C" long double cbrtl(long double ) throw(); extern "C" long double __cbrtl(long double ) throw(); 
# 179
extern "C" long double ceill(long double ) throw() __attribute((const)); extern "C" long double __ceill(long double ) throw() __attribute((const)); 
# 182
extern "C" long double fabsl(long double ) throw() __attribute((const)); extern "C" long double __fabsl(long double ) throw() __attribute((const)); 
# 185
extern "C" long double floorl(long double ) throw() __attribute((const)); extern "C" long double __floorl(long double ) throw() __attribute((const)); 
# 188
extern "C" long double fmodl(long double , long double ) throw(); extern "C" long double __fmodl(long double , long double ) throw(); 
# 193
extern "C" int __isinfl(long double ) throw() __attribute((const)); 
# 196
extern "C" int __finitel(long double ) throw() __attribute((const)); 
# 202
extern "C" int isinfl(long double ) throw() __attribute((const)); 
# 205
extern "C" int finitel(long double ) throw() __attribute((const)); 
# 208
extern "C" long double dreml(long double , long double ) throw(); extern "C" long double __dreml(long double , long double ) throw(); 
# 212
extern "C" long double significandl(long double ) throw(); extern "C" long double __significandl(long double ) throw(); 
# 218
extern "C" long double copysignl(long double , long double ) throw() __attribute((const)); extern "C" long double __copysignl(long double , long double ) throw() __attribute((const)); 
# 225
extern "C" long double nanl(const char * ) throw() __attribute((const)); extern "C" long double __nanl(const char * ) throw() __attribute((const)); 
# 231
extern "C" int __isnanl(long double ) throw() __attribute((const)); 
# 235
extern "C" int isnanl(long double ) throw() __attribute((const)); 
# 238
extern "C" long double j0l(long double) throw(); extern "C" long double __j0l(long double) throw(); 
# 239
extern "C" long double j1l(long double) throw(); extern "C" long double __j1l(long double) throw(); 
# 240
extern "C" long double jnl(int, long double) throw(); extern "C" long double __jnl(int, long double) throw(); 
# 241
extern "C" long double y0l(long double) throw(); extern "C" long double __y0l(long double) throw(); 
# 242
extern "C" long double y1l(long double) throw(); extern "C" long double __y1l(long double) throw(); 
# 243
extern "C" long double ynl(int, long double) throw(); extern "C" long double __ynl(int, long double) throw(); 
# 250
extern "C" long double erfl(long double) throw(); extern "C" long double __erfl(long double) throw(); 
# 251
extern "C" long double erfcl(long double) throw(); extern "C" long double __erfcl(long double) throw(); 
# 252
extern "C" long double lgammal(long double) throw(); extern "C" long double __lgammal(long double) throw(); 
# 259
extern "C" long double tgammal(long double) throw(); extern "C" long double __tgammal(long double) throw(); 
# 265
extern "C" long double gammal(long double) throw(); extern "C" long double __gammal(long double) throw(); 
# 272
extern "C" long double lgammal_r(long double, int * ) throw(); extern "C" long double __lgammal_r(long double, int * ) throw(); 
# 280
extern "C" long double rintl(long double ) throw(); extern "C" long double __rintl(long double ) throw(); 
# 283
extern "C" long double nextafterl(long double , long double ) throw() __attribute((const)); extern "C" long double __nextafterl(long double , long double ) throw() __attribute((const)); 
# 285
extern "C" long double nexttowardl(long double , long double ) throw() __attribute((const)); extern "C" long double __nexttowardl(long double , long double ) throw() __attribute((const)); 
# 289
extern "C" long double remainderl(long double , long double ) throw(); extern "C" long double __remainderl(long double , long double ) throw(); 
# 293
extern "C" long double scalbnl(long double , int ) throw(); extern "C" long double __scalbnl(long double , int ) throw(); 
# 297
extern "C" int ilogbl(long double ) throw(); extern "C" int __ilogbl(long double ) throw(); 
# 302
extern "C" long double scalblnl(long double , long ) throw(); extern "C" long double __scalblnl(long double , long ) throw(); 
# 306
extern "C" long double nearbyintl(long double ) throw(); extern "C" long double __nearbyintl(long double ) throw(); 
# 310
extern "C" long double roundl(long double ) throw() __attribute((const)); extern "C" long double __roundl(long double ) throw() __attribute((const)); 
# 314
extern "C" long double truncl(long double ) throw() __attribute((const)); extern "C" long double __truncl(long double ) throw() __attribute((const)); 
# 319
extern "C" long double remquol(long double , long double , int * ) throw(); extern "C" long double __remquol(long double , long double , int * ) throw(); 
# 326
extern "C" long lrintl(long double ) throw(); extern "C" long __lrintl(long double ) throw(); 
# 327
extern "C" long long llrintl(long double ) throw(); extern "C" long long __llrintl(long double ) throw(); 
# 331
extern "C" long lroundl(long double ) throw(); extern "C" long __lroundl(long double ) throw(); 
# 332
extern "C" long long llroundl(long double ) throw(); extern "C" long long __llroundl(long double ) throw(); 
# 336
extern "C" long double fdiml(long double , long double ) throw(); extern "C" long double __fdiml(long double , long double ) throw(); 
# 339
extern "C" long double fmaxl(long double , long double ) throw(); extern "C" long double __fmaxl(long double , long double ) throw(); 
# 342
extern "C" long double fminl(long double , long double ) throw(); extern "C" long double __fminl(long double , long double ) throw(); 
# 346
extern "C" int __fpclassifyl(long double ) throw()
# 347
 __attribute((const)); 
# 350
extern "C" int __signbitl(long double ) throw()
# 351
 __attribute((const)); 
# 355
extern "C" long double fmal(long double , long double , long double ) throw(); extern "C" long double __fmal(long double , long double , long double ) throw(); 
# 364
extern "C" long double scalbl(long double , long double ) throw(); extern "C" long double __scalbl(long double , long double ) throw(); 
# 157 "/usr/include/math.h" 3
extern "C" { extern int signgam; } 
# 199
enum { 
# 200
FP_NAN, 
# 202
FP_INFINITE, 
# 204
FP_ZERO, 
# 206
FP_SUBNORMAL, 
# 208
FP_NORMAL
# 210
}; 
# 298 "/usr/include/math.h" 3
extern "C" { typedef 
# 292
enum { 
# 293
_IEEE_ = (-1), 
# 294
_SVID_ = 0, 
# 295
_XOPEN_, 
# 296
_POSIX_, 
# 297
_ISOC_
# 298
} _LIB_VERSION_TYPE; }
# 303
extern "C" { extern _LIB_VERSION_TYPE _LIB_VERSION; } 
# 314
extern "C" { struct __exception { 
# 319
int type; 
# 320
char *name; 
# 321
double arg1; 
# 322
double arg2; 
# 323
double retval; 
# 324
}; }
# 327
extern "C" int matherr(__exception * ) throw(); 
# 67 "/usr/include/bits/waitstatus.h" 3
extern "C" { union wait { 
# 69
int w_status; 
# 71
struct { 
# 73
unsigned __w_termsig:7; 
# 74
unsigned __w_coredump:1; 
# 75
unsigned __w_retcode:8; 
# 76
unsigned:16; 
# 84
} __wait_terminated; 
# 86
struct { 
# 88
unsigned __w_stopval:8; 
# 89
unsigned __w_stopsig:8; 
# 90
unsigned:16; 
# 97
} __wait_stopped; 
# 98
}; }
# 102 "/usr/include/stdlib.h" 3
extern "C" { typedef 
# 99
struct { 
# 100
int quot; 
# 101
int rem; 
# 102
} div_t; }
# 110
extern "C" { typedef 
# 107
struct { 
# 108
long quot; 
# 109
long rem; 
# 110
} ldiv_t; }
# 122
extern "C" { typedef 
# 119
struct { 
# 120
long long quot; 
# 121
long long rem; 
# 122
} lldiv_t; }
# 140
extern "C" size_t __ctype_get_mb_cur_max() throw(); 
# 145
extern "C" double atof(const char * ) throw()
# 146
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 148
extern "C" int atoi(const char * ) throw()
# 149
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 151
extern "C" long atol(const char * ) throw()
# 152
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 158
extern "C" long long atoll(const char * ) throw()
# 159
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 165
extern "C" double strtod(const char *__restrict__ , char **__restrict__ ) throw()
# 167
 __attribute((__nonnull__(1))); 
# 173
extern "C" float strtof(const char *__restrict__ , char **__restrict__ ) throw()
# 174
 __attribute((__nonnull__(1))); 
# 176
extern "C" long double strtold(const char *__restrict__ , char **__restrict__ ) throw()
# 178
 __attribute((__nonnull__(1))); 
# 184
extern "C" long strtol(const char *__restrict__ , char **__restrict__ , int ) throw()
# 186
 __attribute((__nonnull__(1))); 
# 188
extern "C" unsigned long strtoul(const char *__restrict__ , char **__restrict__ , int ) throw()
# 190
 __attribute((__nonnull__(1))); 
# 196
extern "C" long long strtoq(const char *__restrict__ , char **__restrict__ , int ) throw()
# 198
 __attribute((__nonnull__(1))); 
# 201
extern "C" unsigned long long strtouq(const char *__restrict__ , char **__restrict__ , int ) throw()
# 203
 __attribute((__nonnull__(1))); 
# 210
extern "C" long long strtoll(const char *__restrict__ , char **__restrict__ , int ) throw()
# 212
 __attribute((__nonnull__(1))); 
# 215
extern "C" unsigned long long strtoull(const char *__restrict__ , char **__restrict__ , int ) throw()
# 217
 __attribute((__nonnull__(1))); 
# 240 "/usr/include/stdlib.h" 3
extern "C" long strtol_l(const char *__restrict__ , char **__restrict__ , int , __locale_t ) throw()
# 242
 __attribute((__nonnull__(1, 4))); 
# 244
extern "C" unsigned long strtoul_l(const char *__restrict__ , char **__restrict__ , int , __locale_t ) throw()
# 247
 __attribute((__nonnull__(1, 4))); 
# 250
extern "C" long long strtoll_l(const char *__restrict__ , char **__restrict__ , int , __locale_t ) throw()
# 253
 __attribute((__nonnull__(1, 4))); 
# 256
extern "C" unsigned long long strtoull_l(const char *__restrict__ , char **__restrict__ , int , __locale_t ) throw()
# 259
 __attribute((__nonnull__(1, 4))); 
# 261
extern "C" double strtod_l(const char *__restrict__ , char **__restrict__ , __locale_t ) throw()
# 263
 __attribute((__nonnull__(1, 3))); 
# 265
extern "C" float strtof_l(const char *__restrict__ , char **__restrict__ , __locale_t ) throw()
# 267
 __attribute((__nonnull__(1, 3))); 
# 269
extern "C" long double strtold_l(const char *__restrict__ , char **__restrict__ , __locale_t ) throw()
# 272
 __attribute((__nonnull__(1, 3))); 
# 311 "/usr/include/stdlib.h" 3
extern "C" char *l64a(long ) throw(); 
# 314
extern "C" long a64l(const char * ) throw()
# 315
 __attribute((__pure__)) __attribute((__nonnull__(1))); 
# 34 "/usr/include/sys/types.h" 3
extern "C" { typedef __u_char u_char; }
# 35
extern "C" { typedef __u_short u_short; }
# 36
extern "C" { typedef __u_int u_int; }
# 37
extern "C" { typedef __u_long u_long; }
# 38
extern "C" { typedef __quad_t quad_t; }
# 39
extern "C" { typedef __u_quad_t u_quad_t; }
# 40
extern "C" { typedef __fsid_t fsid_t; }
# 45
extern "C" { typedef __loff_t loff_t; }
# 49
extern "C" { typedef __ino_t ino_t; }
# 56
extern "C" { typedef __ino64_t ino64_t; }
# 61
extern "C" { typedef __dev_t dev_t; }
# 66
extern "C" { typedef __gid_t gid_t; }
# 71
extern "C" { typedef __mode_t mode_t; }
# 76
extern "C" { typedef __nlink_t nlink_t; }
# 81
extern "C" { typedef __uid_t uid_t; }
# 87
extern "C" { typedef __off_t off_t; }
# 94
extern "C" { typedef __off64_t off64_t; }
# 105 "/usr/include/sys/types.h" 3
extern "C" { typedef __id_t id_t; }
# 110
extern "C" { typedef __ssize_t ssize_t; }
# 116
extern "C" { typedef __daddr_t daddr_t; }
# 117
extern "C" { typedef __caddr_t caddr_t; }
# 123
extern "C" { typedef __key_t key_t; }
# 137 "/usr/include/sys/types.h" 3
extern "C" { typedef __useconds_t useconds_t; }
# 141
extern "C" { typedef __suseconds_t suseconds_t; }
# 151 "/usr/include/sys/types.h" 3
extern "C" { typedef unsigned long ulong; }
# 152
extern "C" { typedef unsigned short ushort; }
# 153
extern "C" { typedef unsigned uint; }
# 195 "/usr/include/sys/types.h" 3
extern "C" { typedef signed char int8_t __attribute((__mode__(__QI__))); }
# 196
extern "C" { typedef short int16_t __attribute((__mode__(__HI__))); }
# 197
extern "C" { typedef int int32_t __attribute((__mode__(__SI__))); }
# 198
extern "C" { typedef long int64_t __attribute((__mode__(__DI__))); }
# 201
extern "C" { typedef unsigned char u_int8_t __attribute((__mode__(__QI__))); }
# 202
extern "C" { typedef unsigned short u_int16_t __attribute((__mode__(__HI__))); }
# 203
extern "C" { typedef unsigned u_int32_t __attribute((__mode__(__SI__))); }
# 204
extern "C" { typedef unsigned long u_int64_t __attribute((__mode__(__DI__))); }
# 206
extern "C" { typedef long register_t __attribute((__mode__(__word__))); }
# 24 "/usr/include/bits/sigset.h" 3
extern "C" { typedef int __sig_atomic_t; }
# 32
extern "C" { typedef 
# 30
struct { 
# 31
unsigned long __val[(1024) / ((8) * sizeof(unsigned long))]; 
# 32
} __sigset_t; }
# 38 "/usr/include/sys/select.h" 3
extern "C" { typedef __sigset_t sigset_t; }
# 75 "/usr/include/bits/time.h" 3
extern "C" { struct timeval { 
# 77
__time_t tv_sec; 
# 78
__suseconds_t tv_usec; 
# 79
}; }
# 55 "/usr/include/sys/select.h" 3
extern "C" { typedef long __fd_mask; }
# 78
extern "C" { typedef 
# 68
struct { 
# 72
__fd_mask fds_bits[1024 / (8 * ((int)sizeof(__fd_mask)))]; 
# 78
} fd_set; }
# 85
extern "C" { typedef __fd_mask fd_mask; }
# 109
extern "C" int select(int , fd_set *__restrict__ , fd_set *__restrict__ , fd_set *__restrict__ , timeval *__restrict__ ); 
# 121
extern "C" int pselect(int , fd_set *__restrict__ , fd_set *__restrict__ , fd_set *__restrict__ , const timespec *__restrict__ , const __sigset_t *__restrict__ ); 
# 31 "/usr/include/sys/sysmacros.h" 3
extern "C" unsigned gnu_dev_major(unsigned long long ) throw(); 
# 34
extern "C" unsigned gnu_dev_minor(unsigned long long ) throw(); 
# 37
extern "C" unsigned long long gnu_dev_makedev(unsigned , unsigned ) throw(); 
# 229 "/usr/include/sys/types.h" 3
extern "C" { typedef __blksize_t blksize_t; }
# 236
extern "C" { typedef __blkcnt_t blkcnt_t; }
# 240
extern "C" { typedef __fsblkcnt_t fsblkcnt_t; }
# 244
extern "C" { typedef __fsfilcnt_t fsfilcnt_t; }
# 263 "/usr/include/sys/types.h" 3
extern "C" { typedef __blkcnt64_t blkcnt64_t; }
# 264
extern "C" { typedef __fsblkcnt64_t fsblkcnt64_t; }
# 265
extern "C" { typedef __fsfilcnt64_t fsfilcnt64_t; }
# 50 "/usr/include/bits/pthreadtypes.h" 3
extern "C" { typedef unsigned long pthread_t; }
# 57
extern "C" { typedef 
# 54
union { 
# 55
char __size[56]; 
# 56
long __align; 
# 57
} pthread_attr_t; }
# 65
extern "C" { typedef 
# 61
struct __pthread_internal_list { 
# 63
__pthread_internal_list *__prev; 
# 64
__pthread_internal_list *__next; 
# 65
} __pthread_list_t; }
# 104 "/usr/include/bits/pthreadtypes.h" 3
extern "C" { typedef 
# 77 "/usr/include/bits/pthreadtypes.h" 3
union { 
# 78
struct __pthread_mutex_s { 
# 80
int __lock; 
# 81
unsigned __count; 
# 82
int __owner; 
# 84
unsigned __nusers; 
# 88
int __kind; 
# 90
int __spins; 
# 91
__pthread_list_t __list; 
# 101 "/usr/include/bits/pthreadtypes.h" 3
} __data; 
# 102
char __size[40]; 
# 103
long __align; 
# 104
} pthread_mutex_t; }
# 110
extern "C" { typedef 
# 107
union { 
# 108
char __size[4]; 
# 109
int __align; 
# 110
} pthread_mutexattr_t; }
# 130
extern "C" { typedef 
# 116
union { 
# 118
struct { 
# 119
int __lock; 
# 120
unsigned __futex; 
# 121
__extension__ unsigned long long __total_seq; 
# 122
__extension__ unsigned long long __wakeup_seq; 
# 123
__extension__ unsigned long long __woken_seq; 
# 124
void *__mutex; 
# 125
unsigned __nwaiters; 
# 126
unsigned __broadcast_seq; 
# 127
} __data; 
# 128
char __size[48]; 
# 129
__extension__ long long __align; 
# 130
} pthread_cond_t; }
# 136
extern "C" { typedef 
# 133
union { 
# 134
char __size[4]; 
# 135
int __align; 
# 136
} pthread_condattr_t; }
# 140
extern "C" { typedef unsigned pthread_key_t; }
# 144
extern "C" { typedef int pthread_once_t; }
# 189 "/usr/include/bits/pthreadtypes.h" 3
extern "C" { typedef 
# 151 "/usr/include/bits/pthreadtypes.h" 3
union { 
# 154
struct { 
# 155
int __lock; 
# 156
unsigned __nr_readers; 
# 157
unsigned __readers_wakeup; 
# 158
unsigned __writer_wakeup; 
# 159
unsigned __nr_readers_queued; 
# 160
unsigned __nr_writers_queued; 
# 161
int __writer; 
# 162
int __shared; 
# 163
unsigned long __pad1; 
# 164
unsigned long __pad2; 
# 167
unsigned __flags; 
# 168
} __data; 
# 187 "/usr/include/bits/pthreadtypes.h" 3
char __size[56]; 
# 188
long __align; 
# 189
} pthread_rwlock_t; }
# 195
extern "C" { typedef 
# 192
union { 
# 193
char __size[8]; 
# 194
long __align; 
# 195
} pthread_rwlockattr_t; }
# 201
extern "C" { typedef volatile int pthread_spinlock_t; }
# 210
extern "C" { typedef 
# 207
union { 
# 208
char __size[32]; 
# 209
long __align; 
# 210
} pthread_barrier_t; }
# 216
extern "C" { typedef 
# 213
union { 
# 214
char __size[4]; 
# 215
int __align; 
# 216
} pthread_barrierattr_t; }
# 327 "/usr/include/stdlib.h" 3
extern "C" long random() throw(); 
# 330
extern "C" void srandom(unsigned ) throw(); 
# 336
extern "C" char *initstate(unsigned , char * , size_t ) throw()
# 337
 __attribute((__nonnull__(2))); 
# 341
extern "C" char *setstate(char * ) throw() __attribute((__nonnull__(1))); 
# 349
extern "C" { struct random_data { 
# 351
int32_t *fptr; 
# 352
int32_t *rptr; 
# 353
int32_t *state; 
# 354
int rand_type; 
# 355
int rand_deg; 
# 356
int rand_sep; 
# 357
int32_t *end_ptr; 
# 358
}; }
# 360
extern "C" int random_r(random_data *__restrict__ , int32_t *__restrict__ ) throw()
# 361
 __attribute((__nonnull__(1, 2))); 
# 363
extern "C" int srandom_r(unsigned , random_data * ) throw()
# 364
 __attribute((__nonnull__(2))); 
# 366
extern "C" int initstate_r(unsigned , char *__restrict__ , size_t , random_data *__restrict__ ) throw()
# 369
 __attribute((__nonnull__(2, 4))); 
# 371
extern "C" int setstate_r(char *__restrict__ , random_data *__restrict__ ) throw()
# 373
 __attribute((__nonnull__(1, 2))); 
# 380
extern "C" int rand() throw(); 
# 382
extern "C" void srand(unsigned ) throw(); 
# 387
extern "C" int rand_r(unsigned * ) throw(); 
# 395
extern "C" double drand48() throw(); 
# 396
extern "C" double erand48(unsigned short  [3]) throw() __attribute((__nonnull__(1))); 
# 399
extern "C" long lrand48() throw(); 
# 400
extern "C" long nrand48(unsigned short  [3]) throw()
# 401
 __attribute((__nonnull__(1))); 
# 404
extern "C" long mrand48() throw(); 
# 405
extern "C" long jrand48(unsigned short  [3]) throw()
# 406
 __attribute((__nonnull__(1))); 
# 409
extern "C" void srand48(long ) throw(); 
# 410
extern "C" unsigned short *seed48(unsigned short  [3]) throw()
# 411
 __attribute((__nonnull__(1))); 
# 412
extern "C" void lcong48(unsigned short  [7]) throw() __attribute((__nonnull__(1))); 
# 418
extern "C" { struct drand48_data { 
# 420
unsigned short __x[3]; 
# 421
unsigned short __old_x[3]; 
# 422
unsigned short __c; 
# 423
unsigned short __init; 
# 424
unsigned long long __a; 
# 425
}; }
# 428
extern "C" int drand48_r(drand48_data *__restrict__ , double *__restrict__ ) throw()
# 429
 __attribute((__nonnull__(1, 2))); 
# 430
extern "C" int erand48_r(unsigned short  [3], drand48_data *__restrict__ , double *__restrict__ ) throw()
# 432
 __attribute((__nonnull__(1, 2))); 
# 435
extern "C" int lrand48_r(drand48_data *__restrict__ , long *__restrict__ ) throw()
# 437
 __attribute((__nonnull__(1, 2))); 
# 438
extern "C" int nrand48_r(unsigned short  [3], drand48_data *__restrict__ , long *__restrict__ ) throw()
# 441
 __attribute((__nonnull__(1, 2))); 
# 444
extern "C" int mrand48_r(drand48_data *__restrict__ , long *__restrict__ ) throw()
# 446
 __attribute((__nonnull__(1, 2))); 
# 447
extern "C" int jrand48_r(unsigned short  [3], drand48_data *__restrict__ , long *__restrict__ ) throw()
# 450
 __attribute((__nonnull__(1, 2))); 
# 453
extern "C" int srand48_r(long , drand48_data * ) throw()
# 454
 __attribute((__nonnull__(2))); 
# 456
extern "C" int seed48_r(unsigned short  [3], drand48_data * ) throw()
# 457
 __attribute((__nonnull__(1, 2))); 
# 459
extern "C" int lcong48_r(unsigned short  [7], drand48_data * ) throw()
# 461
 __attribute((__nonnull__(1, 2))); 
# 471
extern "C" void *malloc(size_t ) throw() __attribute((__malloc__)); 
# 473
extern "C" void *calloc(size_t , size_t ) throw()
# 474
 __attribute((__malloc__)); 
# 485
extern "C" void *realloc(void * , size_t ) throw()
# 486
 __attribute((__warn_unused_result__)); 
# 488
extern "C" void free(void * ) throw(); 
# 493
extern "C" void cfree(void * ) throw(); 
# 33 "/usr/include/alloca.h" 3
extern "C" void *alloca(size_t ) throw(); 
# 503 "/usr/include/stdlib.h" 3
extern "C" void *valloc(size_t ) throw() __attribute((__malloc__)); 
# 508
extern "C" int posix_memalign(void ** , size_t , size_t ) throw()
# 509
 __attribute((__nonnull__(1))); 
# 514
extern "C" void abort() throw() __attribute((__noreturn__)); 
# 518
extern "C" int atexit(void (* )(void)) throw() __attribute((__nonnull__(1))); 
# 525
int at_quick_exit(void (* )(void)) throw() __asm__("at_quick_exit")
# 526
 __attribute((__nonnull__(1))); 
# 536
extern "C" int on_exit(void (* )(int , void * ), void * ) throw()
# 537
 __attribute((__nonnull__(1))); 
# 544
extern "C" void exit(int ) throw() __attribute((__noreturn__)); 
# 552
extern "C" void quick_exit(int ) throw() __attribute((__noreturn__)); 
# 560
extern "C" void _Exit(int ) throw() __attribute((__noreturn__)); 
# 567
extern "C" char *getenv(const char * ) throw() __attribute((__nonnull__(1))); 
# 572
extern "C" char *__secure_getenv(const char * ) throw()
# 573
 __attribute((__nonnull__(1))); 
# 579
extern "C" int putenv(char * ) throw() __attribute((__nonnull__(1))); 
# 585
extern "C" int setenv(const char * , const char * , int ) throw()
# 586
 __attribute((__nonnull__(2))); 
# 589
extern "C" int unsetenv(const char * ) throw() __attribute((__nonnull__(1))); 
# 596
extern "C" int clearenv() throw(); 
# 606
extern "C" char *mktemp(char * ) throw() __attribute((__nonnull__(1))); 
# 620
extern "C" int mkstemp(char * ) __attribute((__nonnull__(1))); 
# 630 "/usr/include/stdlib.h" 3
extern "C" int mkstemp64(char * ) __attribute((__nonnull__(1))); 
# 642
extern "C" int mkstemps(char * , int ) __attribute((__nonnull__(1))); 
# 652 "/usr/include/stdlib.h" 3
extern "C" int mkstemps64(char * , int )
# 653
 __attribute((__nonnull__(1))); 
# 663
extern "C" char *mkdtemp(char * ) throw() __attribute((__nonnull__(1))); 
# 674
extern "C" int mkostemp(char * , int ) __attribute((__nonnull__(1))); 
# 684 "/usr/include/stdlib.h" 3
extern "C" int mkostemp64(char * , int ) __attribute((__nonnull__(1))); 
# 694
extern "C" int mkostemps(char * , int , int )
# 695
 __attribute((__nonnull__(1))); 
# 706 "/usr/include/stdlib.h" 3
extern "C" int mkostemps64(char * , int , int )
# 707
 __attribute((__nonnull__(1))); 
# 717
extern "C" int system(const char * ); 
# 724
extern "C" char *canonicalize_file_name(const char * ) throw()
# 725
 __attribute((__nonnull__(1))); 
# 734
extern "C" char *realpath(const char *__restrict__ , char *__restrict__ ) throw(); 
# 742
extern "C" { typedef int (*__compar_fn_t)(const void *, const void *); }
# 745
extern "C" { typedef __compar_fn_t comparison_fn_t; }
# 749
extern "C" { typedef int (*__compar_d_fn_t)(const void *, const void *, void *); }
# 755
extern "C" void *bsearch(const void * , const void * , size_t , size_t , __compar_fn_t )
# 757
 __attribute((__nonnull__(1, 2, 5))); 
# 761
extern "C" void qsort(void * , size_t , size_t , __compar_fn_t )
# 762
 __attribute((__nonnull__(1, 4))); 
# 764
extern "C" void qsort_r(void * , size_t , size_t , __compar_d_fn_t , void * )
# 766
 __attribute((__nonnull__(1, 4))); 
# 771
extern "C" int abs(int ) throw() __attribute((const)); 
# 772
extern "C" long labs(long ) throw() __attribute((const)); 
# 776
extern "C" long long llabs(long long ) throw()
# 777
 __attribute((const)); 
# 785
extern "C" div_t div(int , int ) throw()
# 786
 __attribute((const)); 
# 787
extern "C" ldiv_t ldiv(long , long ) throw()
# 788
 __attribute((const)); 
# 793
extern "C" lldiv_t lldiv(long long , long long ) throw()
# 795
 __attribute((const)); 
# 808
extern "C" char *ecvt(double , int , int *__restrict__ , int *__restrict__ ) throw()
# 809
 __attribute((__nonnull__(3, 4))); 
# 814
extern "C" char *fcvt(double , int , int *__restrict__ , int *__restrict__ ) throw()
# 815
 __attribute((__nonnull__(3, 4))); 
# 820
extern "C" char *gcvt(double , int , char * ) throw()
# 821
 __attribute((__nonnull__(3))); 
# 826
extern "C" char *qecvt(long double , int , int *__restrict__ , int *__restrict__ ) throw()
# 828
 __attribute((__nonnull__(3, 4))); 
# 829
extern "C" char *qfcvt(long double , int , int *__restrict__ , int *__restrict__ ) throw()
# 831
 __attribute((__nonnull__(3, 4))); 
# 832
extern "C" char *qgcvt(long double , int , char * ) throw()
# 833
 __attribute((__nonnull__(3))); 
# 838
extern "C" int ecvt_r(double , int , int *__restrict__ , int *__restrict__ , char *__restrict__ , size_t ) throw()
# 840
 __attribute((__nonnull__(3, 4, 5))); 
# 841
extern "C" int fcvt_r(double , int , int *__restrict__ , int *__restrict__ , char *__restrict__ , size_t ) throw()
# 843
 __attribute((__nonnull__(3, 4, 5))); 
# 845
extern "C" int qecvt_r(long double , int , int *__restrict__ , int *__restrict__ , char *__restrict__ , size_t ) throw()
# 848
 __attribute((__nonnull__(3, 4, 5))); 
# 849
extern "C" int qfcvt_r(long double , int , int *__restrict__ , int *__restrict__ , char *__restrict__ , size_t ) throw()
# 852
 __attribute((__nonnull__(3, 4, 5))); 
# 860
extern "C" int mblen(const char * , size_t ) throw(); 
# 863
extern "C" int mbtowc(wchar_t *__restrict__ , const char *__restrict__ , size_t ) throw(); 
# 867
extern "C" int wctomb(char * , wchar_t ) throw(); 
# 871
extern "C" size_t mbstowcs(wchar_t *__restrict__ , const char *__restrict__ , size_t ) throw(); 
# 874
extern "C" size_t wcstombs(char *__restrict__ , const wchar_t *__restrict__ , size_t ) throw(); 
# 885
extern "C" int rpmatch(const char * ) throw() __attribute((__nonnull__(1))); 
# 896
extern "C" int getsubopt(char **__restrict__ , char *const *__restrict__ , char **__restrict__ ) throw()
# 899
 __attribute((__nonnull__(1, 2, 3))); 
# 905
extern "C" void setkey(const char * ) throw() __attribute((__nonnull__(1))); 
# 913
extern "C" int posix_openpt(int ); 
# 921
extern "C" int grantpt(int ) throw(); 
# 925
extern "C" int unlockpt(int ) throw(); 
# 930
extern "C" char *ptsname(int ) throw(); 
# 937
extern "C" int ptsname_r(int , char * , size_t ) throw()
# 938
 __attribute((__nonnull__(2))); 
# 941
extern "C" int getpt(); 
# 948
extern "C" int getloadavg(double  [], int ) throw()
# 949
 __attribute((__nonnull__(1))); 
# 69 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
namespace __gnu_cxx __attribute((__visibility__("default"))) { 
# 71
template< class _Iterator, class _Container> class __normal_iterator; 
# 74
}
# 76
namespace std __attribute((__visibility__("default")))
# 77 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cmath" 3
 __attribute((__visibility__("default")))
# 492 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cmath" 3
 __attribute((__visibility__("default")))
# 35 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cmath.tcc" 3
 __attribute((__visibility__("default")))
# 49 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstddef" 3
 __attribute((__visibility__("default")))
# 100 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default")))
# 199 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default"))) { 
# 78 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
struct __true_type { }; 
# 79
struct __false_type { }; 
# 81
template< bool __T0> 
# 82
struct __truth_type { 
# 83
typedef __false_type __type; }; 
# 86
template<> struct __truth_type< true>  { 
# 87
typedef __true_type __type; }; 
# 91
template< class _Sp, class _Tp> 
# 92
struct __traitor { 
# 94
enum { __value = (((bool)_Sp::__value) || ((bool)_Tp::__value))}; 
# 95
typedef typename __truth_type< __value> ::__type __type; 
# 96
}; 
# 99
template< class , class > 
# 100
struct __are_same { 
# 102
enum { __value}; 
# 103
typedef __false_type __type; 
# 104
}; 
# 106
template< class _Tp> 
# 107
struct __are_same< _Tp, _Tp>  { 
# 109
enum { __value = 1}; 
# 110
typedef __true_type __type; 
# 111
}; 
# 114
template< class _Tp> 
# 115
struct __is_void { 
# 117
enum { __value}; 
# 118
typedef __false_type __type; 
# 119
}; 
# 122
template<> struct __is_void< void>  { 
# 124
enum { __value = 1}; 
# 125
typedef __true_type __type; 
# 126
}; 
# 131
template< class _Tp> 
# 132
struct __is_integer { 
# 134
enum { __value}; 
# 135
typedef __false_type __type; 
# 136
}; 
# 142
template<> struct __is_integer< bool>  { 
# 144
enum { __value = 1}; 
# 145
typedef __true_type __type; 
# 146
}; 
# 149
template<> struct __is_integer< char>  { 
# 151
enum { __value = 1}; 
# 152
typedef __true_type __type; 
# 153
}; 
# 156
template<> struct __is_integer< signed char>  { 
# 158
enum { __value = 1}; 
# 159
typedef __true_type __type; 
# 160
}; 
# 163
template<> struct __is_integer< unsigned char>  { 
# 165
enum { __value = 1}; 
# 166
typedef __true_type __type; 
# 167
}; 
# 171
template<> struct __is_integer< wchar_t>  { 
# 173
enum { __value = 1}; 
# 174
typedef __true_type __type; 
# 175
}; 
# 195 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
template<> struct __is_integer< short>  { 
# 197
enum { __value = 1}; 
# 198
typedef __true_type __type; 
# 199
}; 
# 202
template<> struct __is_integer< unsigned short>  { 
# 204
enum { __value = 1}; 
# 205
typedef __true_type __type; 
# 206
}; 
# 209
template<> struct __is_integer< int>  { 
# 211
enum { __value = 1}; 
# 212
typedef __true_type __type; 
# 213
}; 
# 216
template<> struct __is_integer< unsigned>  { 
# 218
enum { __value = 1}; 
# 219
typedef __true_type __type; 
# 220
}; 
# 223
template<> struct __is_integer< long>  { 
# 225
enum { __value = 1}; 
# 226
typedef __true_type __type; 
# 227
}; 
# 230
template<> struct __is_integer< unsigned long>  { 
# 232
enum { __value = 1}; 
# 233
typedef __true_type __type; 
# 234
}; 
# 237
template<> struct __is_integer< long long>  { 
# 239
enum { __value = 1}; 
# 240
typedef __true_type __type; 
# 241
}; 
# 244
template<> struct __is_integer< unsigned long long>  { 
# 246
enum { __value = 1}; 
# 247
typedef __true_type __type; 
# 248
}; 
# 253
template< class _Tp> 
# 254
struct __is_floating { 
# 256
enum { __value}; 
# 257
typedef __false_type __type; 
# 258
}; 
# 262
template<> struct __is_floating< float>  { 
# 264
enum { __value = 1}; 
# 265
typedef __true_type __type; 
# 266
}; 
# 269
template<> struct __is_floating< double>  { 
# 271
enum { __value = 1}; 
# 272
typedef __true_type __type; 
# 273
}; 
# 276
template<> struct __is_floating< long double>  { 
# 278
enum { __value = 1}; 
# 279
typedef __true_type __type; 
# 280
}; 
# 285
template< class _Tp> 
# 286
struct __is_pointer { 
# 288
enum { __value}; 
# 289
typedef __false_type __type; 
# 290
}; 
# 292
template< class _Tp> 
# 293
struct __is_pointer< _Tp *>  { 
# 295
enum { __value = 1}; 
# 296
typedef __true_type __type; 
# 297
}; 
# 302
template< class _Tp> 
# 303
struct __is_normal_iterator { 
# 305
enum { __value}; 
# 306
typedef __false_type __type; 
# 307
}; 
# 309
template< class _Iterator, class _Container> 
# 310
struct __is_normal_iterator< __gnu_cxx::__normal_iterator< _Iterator, _Container> >  { 
# 313
enum { __value = 1}; 
# 314
typedef __true_type __type; 
# 315
}; 
# 320
template< class _Tp> 
# 321
struct __is_arithmetic : public __traitor< __is_integer< _Tp> , __is_floating< _Tp> >  { 
# 323
}; 
# 328
template< class _Tp> 
# 329
struct __is_fundamental : public __traitor< __is_void< _Tp> , __is_arithmetic< _Tp> >  { 
# 331
}; 
# 336
template< class _Tp> 
# 337
struct __is_scalar : public __traitor< __is_arithmetic< _Tp> , __is_pointer< _Tp> >  { 
# 339
}; 
# 344
template< class _Tp> 
# 345
struct __is_char { 
# 347
enum { __value}; 
# 348
typedef __false_type __type; 
# 349
}; 
# 352
template<> struct __is_char< char>  { 
# 354
enum { __value = 1}; 
# 355
typedef __true_type __type; 
# 356
}; 
# 360
template<> struct __is_char< wchar_t>  { 
# 362
enum { __value = 1}; 
# 363
typedef __true_type __type; 
# 364
}; 
# 367
template< class _Tp> 
# 368
struct __is_byte { 
# 370
enum { __value}; 
# 371
typedef __false_type __type; 
# 372
}; 
# 375
template<> struct __is_byte< char>  { 
# 377
enum { __value = 1}; 
# 378
typedef __true_type __type; 
# 379
}; 
# 382
template<> struct __is_byte< signed char>  { 
# 384
enum { __value = 1}; 
# 385
typedef __true_type __type; 
# 386
}; 
# 389
template<> struct __is_byte< unsigned char>  { 
# 391
enum { __value = 1}; 
# 392
typedef __true_type __type; 
# 393
}; 
# 398
template< class _Tp> 
# 399
struct __is_move_iterator { 
# 401
enum { __value}; 
# 402
typedef __false_type __type; 
# 403
}; 
# 417 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
}
# 37 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/ext/type_traits.h" 3
namespace __gnu_cxx __attribute((__visibility__("default")))
# 157 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default"))) { 
# 40 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/ext/type_traits.h" 3
template< bool __T1, class > 
# 41
struct __enable_if { 
# 42
}; 
# 44
template< class _Tp> 
# 45
struct __enable_if< true, _Tp>  { 
# 46
typedef _Tp __type; }; 
# 50
template< bool _Cond, class _Iftrue, class _Iffalse> 
# 51
struct __conditional_type { 
# 52
typedef _Iftrue __type; }; 
# 54
template< class _Iftrue, class _Iffalse> 
# 55
struct __conditional_type< false, _Iftrue, _Iffalse>  { 
# 56
typedef _Iffalse __type; }; 
# 60
template< class _Tp> 
# 61
struct __add_unsigned { 
# 64
private: typedef __enable_if< std::__is_integer< _Tp> ::__value, _Tp>  __if_type; 
# 67
public: typedef typename __enable_if< std::__is_integer< _Tp> ::__value, _Tp> ::__type __type; 
# 68
}; 
# 71
template<> struct __add_unsigned< char>  { 
# 72
typedef unsigned char __type; }; 
# 75
template<> struct __add_unsigned< signed char>  { 
# 76
typedef unsigned char __type; }; 
# 79
template<> struct __add_unsigned< short>  { 
# 80
typedef unsigned short __type; }; 
# 83
template<> struct __add_unsigned< int>  { 
# 84
typedef unsigned __type; }; 
# 87
template<> struct __add_unsigned< long>  { 
# 88
typedef unsigned long __type; }; 
# 91
template<> struct __add_unsigned< long long>  { 
# 92
typedef unsigned long long __type; }; 
# 96
template<> struct __add_unsigned< bool> ; 
# 99
template<> struct __add_unsigned< wchar_t> ; 
# 103
template< class _Tp> 
# 104
struct __remove_unsigned { 
# 107
private: typedef __enable_if< std::__is_integer< _Tp> ::__value, _Tp>  __if_type; 
# 110
public: typedef typename __enable_if< std::__is_integer< _Tp> ::__value, _Tp> ::__type __type; 
# 111
}; 
# 114
template<> struct __remove_unsigned< char>  { 
# 115
typedef signed char __type; }; 
# 118
template<> struct __remove_unsigned< unsigned char>  { 
# 119
typedef signed char __type; }; 
# 122
template<> struct __remove_unsigned< unsigned short>  { 
# 123
typedef short __type; }; 
# 126
template<> struct __remove_unsigned< unsigned>  { 
# 127
typedef int __type; }; 
# 130
template<> struct __remove_unsigned< unsigned long>  { 
# 131
typedef long __type; }; 
# 134
template<> struct __remove_unsigned< unsigned long long>  { 
# 135
typedef long long __type; }; 
# 139
template<> struct __remove_unsigned< bool> ; 
# 142
template<> struct __remove_unsigned< wchar_t> ; 
# 146
template < typename _Type >
    inline bool
    __is_null_pointer ( _Type * __ptr )
    { return __ptr == 0; }
# 151
template < typename _Type >
    inline bool
    __is_null_pointer ( _Type )
    { return false; }
# 158
template< class _Tp, bool __T2 = std::__is_integer< _Tp> ::__value> 
# 159
struct __promote { 
# 160
typedef double __type; }; 
# 162
template< class _Tp> 
# 163
struct __promote< _Tp, false>  { 
# 164
typedef _Tp __type; }; 
# 166
template< class _Tp, class _Up> 
# 167
struct __promote_2 { 
# 170
private: typedef typename __promote< _Tp, std::__is_integer< _Tp> ::__value> ::__type __type1; 
# 171
typedef typename __promote< _Up, std::__is_integer< _Up> ::__value> ::__type __type2; 
# 174
public: typedef __typeof__((__type1() + __type2())) __type; 
# 175
}; 
# 177
template< class _Tp, class _Up, class _Vp> 
# 178
struct __promote_3 { 
# 181
private: typedef typename __promote< _Tp, std::__is_integer< _Tp> ::__value> ::__type __type1; 
# 182
typedef typename __promote< _Up, std::__is_integer< _Up> ::__value> ::__type __type2; 
# 183
typedef typename __promote< _Vp, std::__is_integer< _Vp> ::__value> ::__type __type3; 
# 186
public: typedef __typeof__(((__type1() + __type2()) + __type3())) __type; 
# 187
}; 
# 189
template< class _Tp, class _Up, class _Vp, class _Wp> 
# 190
struct __promote_4 { 
# 193
private: typedef typename __promote< _Tp, std::__is_integer< _Tp> ::__value> ::__type __type1; 
# 194
typedef typename __promote< _Up, std::__is_integer< _Up> ::__value> ::__type __type2; 
# 195
typedef typename __promote< _Vp, std::__is_integer< _Vp> ::__value> ::__type __type3; 
# 196
typedef typename __promote< _Wp, std::__is_integer< _Wp> ::__value> ::__type __type4; 
# 199
public: typedef __typeof__((((__type1() + __type2()) + __type3()) + __type4())) __type; 
# 200
}; 
# 202
}
# 77 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cmath" 3
namespace std __attribute((__visibility__("default")))
# 492 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cmath" 3
 __attribute((__visibility__("default")))
# 35 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cmath.tcc" 3
 __attribute((__visibility__("default")))
# 49 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstddef" 3
 __attribute((__visibility__("default")))
# 100 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default")))
# 199 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default"))) { 
# 81 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cmath" 3
template < typename _Tp >
    _Tp __cmath_power ( _Tp, unsigned int );
# 84
template < typename _Tp >
    inline _Tp
    __pow_helper ( _Tp __x, int __n )
    {
      return __n < 0
        ? _Tp ( 1 ) / __cmath_power ( __x, - __n )
        : __cmath_power ( __x, __n );
    }
# 94
inline double abs(double __x) 
# 95
{ return __builtin_fabs(__x); } 
# 98
inline float abs(float __x) 
# 99
{ return __builtin_fabsf(__x); } 
# 102
inline long double abs(long double __x) 
# 103
{ return __builtin_fabsl(__x); } 
# 105
using ::acos;
# 108
inline float acos(float __x) 
# 109
{ return __builtin_acosf(__x); } 
# 112
inline long double acos(long double __x) 
# 113
{ return __builtin_acosl(__x); } 
# 115
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    acos ( _Tp __x )
    { return __builtin_acos ( __x ); }
# 121
using ::asin;
# 124
inline float asin(float __x) 
# 125
{ return __builtin_asinf(__x); } 
# 128
inline long double asin(long double __x) 
# 129
{ return __builtin_asinl(__x); } 
# 131
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    asin ( _Tp __x )
    { return __builtin_asin ( __x ); }
# 137
using ::atan;
# 140
inline float atan(float __x) 
# 141
{ return __builtin_atanf(__x); } 
# 144
inline long double atan(long double __x) 
# 145
{ return __builtin_atanl(__x); } 
# 147
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    atan ( _Tp __x )
    { return __builtin_atan ( __x ); }
# 153
using ::atan2;
# 156
inline float atan2(float __y, float __x) 
# 157
{ return __builtin_atan2f(__y, __x); } 
# 160
inline long double atan2(long double __y, long double __x) 
# 161
{ return __builtin_atan2l(__y, __x); } 
# 163
template < typename _Tp, typename _Up >
    inline
    typename __gnu_cxx :: __promote_2 <
    typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value
        && __is_arithmetic < _Up > :: __value,
        _Tp > :: __type, _Up > :: __type
    atan2 ( _Tp __y, _Up __x )
    {
      typedef typename __gnu_cxx :: __promote_2 < _Tp, _Up > :: __type __type;
      return atan2 ( __type ( __y ), __type ( __x ) );
    }
# 175
using ::ceil;
# 178
inline float ceil(float __x) 
# 179
{ return __builtin_ceilf(__x); } 
# 182
inline long double ceil(long double __x) 
# 183
{ return __builtin_ceill(__x); } 
# 185
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    ceil ( _Tp __x )
    { return __builtin_ceil ( __x ); }
# 191
using ::cos;
# 194
inline float cos(float __x) 
# 195
{ return __builtin_cosf(__x); } 
# 198
inline long double cos(long double __x) 
# 199
{ return __builtin_cosl(__x); } 
# 201
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    cos ( _Tp __x )
    { return __builtin_cos ( __x ); }
# 207
using ::cosh;
# 210
inline float cosh(float __x) 
# 211
{ return __builtin_coshf(__x); } 
# 214
inline long double cosh(long double __x) 
# 215
{ return __builtin_coshl(__x); } 
# 217
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    cosh ( _Tp __x )
    { return __builtin_cosh ( __x ); }
# 223
using ::exp;
# 226
inline float exp(float __x) 
# 227
{ return __builtin_expf(__x); } 
# 230
inline long double exp(long double __x) 
# 231
{ return __builtin_expl(__x); } 
# 233
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    exp ( _Tp __x )
    { return __builtin_exp ( __x ); }
# 239
using ::fabs;
# 242
inline float fabs(float __x) 
# 243
{ return __builtin_fabsf(__x); } 
# 246
inline long double fabs(long double __x) 
# 247
{ return __builtin_fabsl(__x); } 
# 249
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    fabs ( _Tp __x )
    { return __builtin_fabs ( __x ); }
# 255
using ::floor;
# 258
inline float floor(float __x) 
# 259
{ return __builtin_floorf(__x); } 
# 262
inline long double floor(long double __x) 
# 263
{ return __builtin_floorl(__x); } 
# 265
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    floor ( _Tp __x )
    { return __builtin_floor ( __x ); }
# 271
using ::fmod;
# 274
inline float fmod(float __x, float __y) 
# 275
{ return __builtin_fmodf(__x, __y); } 
# 278
inline long double fmod(long double __x, long double __y) 
# 279
{ return __builtin_fmodl(__x, __y); } 
# 281
using ::frexp;
# 284
inline float frexp(float __x, int *__exp) 
# 285
{ return __builtin_frexpf(__x, __exp); } 
# 288
inline long double frexp(long double __x, int *__exp) 
# 289
{ return __builtin_frexpl(__x, __exp); } 
# 291
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    frexp ( _Tp __x, int * __exp )
    { return __builtin_frexp ( __x, __exp ); }
# 297
using ::ldexp;
# 300
inline float ldexp(float __x, int __exp) 
# 301
{ return __builtin_ldexpf(__x, __exp); } 
# 304
inline long double ldexp(long double __x, int __exp) 
# 305
{ return __builtin_ldexpl(__x, __exp); } 
# 307
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
  ldexp ( _Tp __x, int __exp )
  { return __builtin_ldexp ( __x, __exp ); }
# 313
using ::log;
# 316
inline float log(float __x) 
# 317
{ return __builtin_logf(__x); } 
# 320
inline long double log(long double __x) 
# 321
{ return __builtin_logl(__x); } 
# 323
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    log ( _Tp __x )
    { return __builtin_log ( __x ); }
# 329
using ::log10;
# 332
inline float log10(float __x) 
# 333
{ return __builtin_log10f(__x); } 
# 336
inline long double log10(long double __x) 
# 337
{ return __builtin_log10l(__x); } 
# 339
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    log10 ( _Tp __x )
    { return __builtin_log10 ( __x ); }
# 345
using ::modf;
# 348
inline float modf(float __x, float *__iptr) 
# 349
{ return __builtin_modff(__x, __iptr); } 
# 352
inline long double modf(long double __x, long double *__iptr) 
# 353
{ return __builtin_modfl(__x, __iptr); } 
# 355
using ::pow;
# 358
inline float pow(float __x, float __y) 
# 359
{ return __builtin_powf(__x, __y); } 
# 362
inline long double pow(long double __x, long double __y) 
# 363
{ return __builtin_powl(__x, __y); } 
# 369
inline double pow(double __x, int __i) 
# 370
{ return __builtin_powi(__x, __i); } 
# 373
inline float pow(float __x, int __n) 
# 374
{ return __builtin_powif(__x, __n); } 
# 377
inline long double pow(long double __x, int __n) 
# 378
{ return __builtin_powil(__x, __n); } 
# 381
template < typename _Tp, typename _Up >
    inline
    typename __gnu_cxx :: __promote_2 <
    typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value
        && __is_arithmetic < _Up > :: __value,
        _Tp > :: __type, _Up > :: __type
    pow ( _Tp __x, _Up __y )
    {
      typedef typename __gnu_cxx :: __promote_2 < _Tp, _Up > :: __type __type;
      return pow ( __type ( __x ), __type ( __y ) );
    }
# 393
using ::sin;
# 396
inline float sin(float __x) 
# 397
{ return __builtin_sinf(__x); } 
# 400
inline long double sin(long double __x) 
# 401
{ return __builtin_sinl(__x); } 
# 403
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    sin ( _Tp __x )
    { return __builtin_sin ( __x ); }
# 409
using ::sinh;
# 412
inline float sinh(float __x) 
# 413
{ return __builtin_sinhf(__x); } 
# 416
inline long double sinh(long double __x) 
# 417
{ return __builtin_sinhl(__x); } 
# 419
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    sinh ( _Tp __x )
    { return __builtin_sinh ( __x ); }
# 425
using ::sqrt;
# 428
inline float sqrt(float __x) 
# 429
{ return __builtin_sqrtf(__x); } 
# 432
inline long double sqrt(long double __x) 
# 433
{ return __builtin_sqrtl(__x); } 
# 435
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    sqrt ( _Tp __x )
    { return __builtin_sqrt ( __x ); }
# 441
using ::tan;
# 444
inline float tan(float __x) 
# 445
{ return __builtin_tanf(__x); } 
# 448
inline long double tan(long double __x) 
# 449
{ return __builtin_tanl(__x); } 
# 451
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    tan ( _Tp __x )
    { return __builtin_tan ( __x ); }
# 457
using ::tanh;
# 460
inline float tanh(float __x) 
# 461
{ return __builtin_tanhf(__x); } 
# 464
inline long double tanh(long double __x) 
# 465
{ return __builtin_tanhl(__x); } 
# 467
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_integer < _Tp > :: __value,
        double > :: __type
    tanh ( _Tp __x )
    { return __builtin_tanh ( __x ); }
# 473
}
# 492 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cmath" 3
namespace std __attribute((__visibility__("default")))
# 35 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cmath.tcc" 3
 __attribute((__visibility__("default")))
# 49 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstddef" 3
 __attribute((__visibility__("default")))
# 100 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default")))
# 199 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default"))) { 
# 494 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cmath" 3
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    fpclassify ( _Tp __f )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_fpclassify ( FP_NAN, FP_INFINITE, FP_NORMAL,
      FP_SUBNORMAL, FP_ZERO, __type ( __f ) );
    }
# 504
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isfinite ( _Tp __f )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isfinite ( __type ( __f ) );
    }
# 513
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isinf ( _Tp __f )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isinf ( __type ( __f ) );
    }
# 522
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isnan ( _Tp __f )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isnan ( __type ( __f ) );
    }
# 531
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isnormal ( _Tp __f )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isnormal ( __type ( __f ) );
    }
# 540
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    signbit ( _Tp __f )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_signbit ( __type ( __f ) );
    }
# 549
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isgreater ( _Tp __f1, _Tp __f2 )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isgreater ( __type ( __f1 ), __type ( __f2 ) );
    }
# 558
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isgreaterequal ( _Tp __f1, _Tp __f2 )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isgreaterequal ( __type ( __f1 ), __type ( __f2 ) );
    }
# 567
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isless ( _Tp __f1, _Tp __f2 )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isless ( __type ( __f1 ), __type ( __f2 ) );
    }
# 576
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    islessequal ( _Tp __f1, _Tp __f2 )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_islessequal ( __type ( __f1 ), __type ( __f2 ) );
    }
# 585
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    islessgreater ( _Tp __f1, _Tp __f2 )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_islessgreater ( __type ( __f1 ), __type ( __f2 ) );
    }
# 594
template < typename _Tp >
    inline typename __gnu_cxx :: __enable_if < __is_arithmetic < _Tp > :: __value,
        int > :: __type
    isunordered ( _Tp __f1, _Tp __f2 )
    {
      typedef typename __gnu_cxx :: __promote < _Tp > :: __type __type;
      return __builtin_isunordered ( __type ( __f1 ), __type ( __f2 ) );
    }
# 603
}
# 35 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cmath.tcc" 3
namespace std __attribute((__visibility__("default")))
# 49 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstddef" 3
 __attribute((__visibility__("default")))
# 100 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default")))
# 199 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default"))) { 
# 37 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cmath.tcc" 3
template < typename _Tp >
    inline _Tp
    __cmath_power ( _Tp __x, unsigned int __n )
    {
      _Tp __y = __n % 2 ? __x : _Tp ( 1 );

      while ( __n >>= 1 )
        {
          __x = __x * __x;
          if ( __n % 2 )
            __y = __y * __x;
        }

      return __y;
    }
# 53
}
# 49 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstddef" 3
namespace std __attribute((__visibility__("default")))
# 100 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default")))
# 199 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default"))) { 
# 51 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstddef" 3
using ::ptrdiff_t;
# 52
using ::size_t;
# 54
}
# 100 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
namespace std __attribute((__visibility__("default")))
# 199 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
 __attribute((__visibility__("default"))) { 
# 102 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
using ::div_t;
# 103
using ::ldiv_t;
# 105
using ::abort;
# 106
using ::abs;
# 107
using ::atexit;
# 108
using ::atof;
# 109
using ::atoi;
# 110
using ::atol;
# 111
using ::bsearch;
# 112
using ::calloc;
# 113
using ::div;
# 114
using ::exit;
# 115
using ::free;
# 116
using ::getenv;
# 117
using ::labs;
# 118
using ::ldiv;
# 119
using ::malloc;
# 121
using ::mblen;
# 122
using ::mbstowcs;
# 123
using ::mbtowc;
# 125
using ::qsort;
# 126
using ::rand;
# 127
using ::realloc;
# 128
using ::srand;
# 129
using ::strtod;
# 130
using ::strtol;
# 131
using ::strtoul;
# 132
using ::system;
# 134
using ::wcstombs;
# 135
using ::wctomb;
# 139
inline long abs(long __i) { return labs(__i); } 
# 142
inline ldiv_t div(long __i, long __j) { return ldiv(__i, __j); } 
# 144
}
# 157 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
namespace __gnu_cxx __attribute((__visibility__("default"))) { 
# 160
using ::lldiv_t;
# 166
using ::_Exit;
# 170
inline long long abs(long long __x) { return (__x >= (0)) ? __x : (-__x); } 
# 173
using ::llabs;
# 176
inline lldiv_t div(long long __n, long long __d) 
# 177
{ lldiv_t __q; (__q.quot) = (__n / __d); (__q.rem) = (__n % __d); return __q; } 
# 179
using ::lldiv;
# 190 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/cstdlib" 3
using ::atoll;
# 191
using ::strtoll;
# 192
using ::strtoull;
# 194
using ::strtof;
# 195
using ::strtold;
# 197
}
# 199
namespace std __attribute((__visibility__("default"))) { 
# 202
using __gnu_cxx::lldiv_t;
# 204
using __gnu_cxx::_Exit;
# 205
using __gnu_cxx::abs;
# 207
using __gnu_cxx::llabs;
# 208
using __gnu_cxx::div;
# 209
using __gnu_cxx::lldiv;
# 211
using __gnu_cxx::atoll;
# 212
using __gnu_cxx::strtof;
# 213
using __gnu_cxx::strtoll;
# 214
using __gnu_cxx::strtoull;
# 215
using __gnu_cxx::strtold;
# 217
}
# 85 "/home/u0332192/local/cuda/include/math_functions.h"
extern "C" int abs(int) throw(); 
# 87
extern "C" long labs(long) throw(); 
# 89
extern "C" long long llabs(long long) throw(); 
# 91
extern "C" double fabs(double) throw(); 
# 93
extern "C" float fabsf(float) throw(); 
# 96
extern "C" int min(int, int); 
# 98
extern "C" unsigned umin(unsigned, unsigned); 
# 100
extern "C" long long llmin(long long, long long); 
# 102
extern "C" unsigned long long ullmin(unsigned long long, unsigned long long); 
# 104
extern "C" float fminf(float, float) throw(); 
# 106
extern "C" double fmin(double, double) throw(); 
# 109
extern "C" int max(int, int); 
# 111
extern "C" unsigned umax(unsigned, unsigned); 
# 113
extern "C" long long llmax(long long, long long); 
# 115
extern "C" unsigned long long ullmax(unsigned long long, unsigned long long); 
# 117
extern "C" float fmaxf(float, float) throw(); 
# 119
extern "C" double fmax(double, double) throw(); 
# 122
extern "C" double sin(double) throw(); 
# 125
extern "C" double cos(double) throw(); 
# 128
extern "C" void sincos(double, double *, double *) throw(); 
# 130
extern "C" void sincosf(float, float *, float *) throw(); 
# 133
extern "C" double tan(double) throw(); 
# 136
extern "C" double sqrt(double) throw(); 
# 139
extern "C" double rsqrt(double); 
# 141
extern "C" float rsqrtf(float); 
# 144
extern "C" double exp2(double) throw(); 
# 146
extern "C" float exp2f(float) throw(); 
# 149
extern "C" double exp10(double) throw(); 
# 151
extern "C" float exp10f(float) throw(); 
# 154
extern "C" double expm1(double) throw(); 
# 156
extern "C" float expm1f(float) throw(); 
# 159
extern "C" double log2(double) throw(); 
# 161
extern "C" float log2f(float) throw(); 
# 164
extern "C" double log10(double) throw(); 
# 167
extern "C" double log(double) throw(); 
# 170
extern "C" double log1p(double) throw(); 
# 172
extern "C" float log1pf(float) throw(); 
# 175
extern "C" double floor(double) throw(); 
# 178
extern "C" double exp(double) throw(); 
# 181
extern "C" double cosh(double) throw(); 
# 184
extern "C" double sinh(double) throw(); 
# 187
extern "C" double tanh(double) throw(); 
# 190
extern "C" double acosh(double) throw(); 
# 192
extern "C" float acoshf(float) throw(); 
# 195
extern "C" double asinh(double) throw(); 
# 197
extern "C" float asinhf(float) throw(); 
# 200
extern "C" double atanh(double) throw(); 
# 202
extern "C" float atanhf(float) throw(); 
# 205
extern "C" double ldexp(double, int) throw(); 
# 207
extern "C" float ldexpf(float, int) throw(); 
# 210
extern "C" double logb(double) throw(); 
# 212
extern "C" float logbf(float) throw(); 
# 215
extern "C" int ilogb(double) throw(); 
# 217
extern "C" int ilogbf(float) throw(); 
# 220
extern "C" double scalbn(double, int) throw(); 
# 222
extern "C" float scalbnf(float, int) throw(); 
# 225
extern "C" double scalbln(double, long) throw(); 
# 227
extern "C" float scalblnf(float, long) throw(); 
# 230
extern "C" double frexp(double, int *) throw(); 
# 232
extern "C" float frexpf(float, int *) throw(); 
# 235
extern "C" double round(double) throw(); 
# 237
extern "C" float roundf(float) throw(); 
# 240
extern "C" long lround(double) throw(); 
# 242
extern "C" long lroundf(float) throw(); 
# 245
extern "C" long long llround(double) throw(); 
# 247
extern "C" long long llroundf(float) throw(); 
# 250
extern "C" double rint(double) throw(); 
# 252
extern "C" float rintf(float) throw(); 
# 255
extern "C" long lrint(double) throw(); 
# 257
extern "C" long lrintf(float) throw(); 
# 260
extern "C" long long llrint(double) throw(); 
# 262
extern "C" long long llrintf(float) throw(); 
# 265
extern "C" double nearbyint(double) throw(); 
# 267
extern "C" float nearbyintf(float) throw(); 
# 270
extern "C" double ceil(double) throw(); 
# 273
extern "C" double trunc(double) throw(); 
# 275
extern "C" float truncf(float) throw(); 
# 278
extern "C" double fdim(double, double) throw(); 
# 280
extern "C" float fdimf(float, float) throw(); 
# 283
extern "C" double atan2(double, double) throw(); 
# 286
extern "C" double atan(double) throw(); 
# 289
extern "C" double asin(double) throw(); 
# 292
extern "C" double acos(double) throw(); 
# 296
extern "C" double hypot(double, double) throw(); 
# 302
extern "C" float hypotf(float, float) throw(); 
# 305
extern "C" double cbrt(double) throw(); 
# 307
extern "C" float cbrtf(float) throw(); 
# 310
extern "C" double rcbrt(double); 
# 312
extern "C" float rcbrtf(float); 
# 315
extern "C" double sinpi(double); 
# 317
extern "C" float sinpif(float); 
# 320
extern "C" double cospi(double); 
# 322
extern "C" float cospif(float); 
# 325
extern "C" double pow(double, double) throw(); 
# 328
extern "C" double modf(double, double *) throw(); 
# 331
extern "C" double fmod(double, double) throw(); 
# 334
extern "C" double remainder(double, double) throw(); 
# 336
extern "C" float remainderf(float, float) throw(); 
# 339
extern "C" double remquo(double, double, int *) throw(); 
# 341
extern "C" float remquof(float, float, int *) throw(); 
# 344
extern "C" double erf(double) throw(); 
# 346
extern "C" float erff(float) throw(); 
# 349
extern "C" double erfinv(double); 
# 351
extern "C" float erfinvf(float); 
# 354
extern "C" double erfc(double) throw(); 
# 356
extern "C" float erfcf(float) throw(); 
# 359
extern "C" double erfcinv(double); 
# 361
extern "C" float erfcinvf(float); 
# 364
extern "C" double lgamma(double) throw(); 
# 366
extern "C" float lgammaf(float) throw(); 
# 369
extern "C" double tgamma(double) throw(); 
# 371
extern "C" float tgammaf(float) throw(); 
# 374
extern "C" double copysign(double, double) throw(); 
# 376
extern "C" float copysignf(float, float) throw(); 
# 379
extern "C" double nextafter(double, double) throw(); 
# 381
extern "C" float nextafterf(float, float) throw(); 
# 384
extern "C" double nan(const char *) throw(); 
# 386
extern "C" float nanf(const char *) throw(); 
# 389
extern "C" int __isinf(double) throw(); 
# 391
extern "C" int __isinff(float) throw(); 
# 394
extern "C" int __isnan(double) throw(); 
# 397
extern "C" int __isnanf(float) throw(); 
# 411 "/home/u0332192/local/cuda/include/math_functions.h"
extern "C" int __finite(double) throw(); 
# 414
extern "C" int __finitef(float) throw(); 
# 418
extern "C" int __signbit(double) throw(); 
# 423
extern "C" int __signbitf(float) throw(); 
# 426
extern "C" double fma(double, double, double) throw(); 
# 428
extern "C" float fmaf(float, float, float) throw(); 
# 436
extern "C" int __signbitl(long double) throw(); 
# 438
extern "C" int __isinfl(long double) throw(); 
# 440
extern "C" int __isnanl(long double) throw(); 
# 450 "/home/u0332192/local/cuda/include/math_functions.h"
extern "C" int __finitel(long double) throw(); 
# 516 "/home/u0332192/local/cuda/include/math_functions.h"
extern "C" float acosf(float) throw(); 
# 519
extern "C" float asinf(float) throw(); 
# 522
extern "C" float atanf(float) throw(); 
# 525
extern "C" float atan2f(float, float) throw(); 
# 528
extern "C" float cosf(float) throw(); 
# 531
extern "C" float sinf(float) throw(); 
# 534
extern "C" float tanf(float) throw(); 
# 537
extern "C" float coshf(float) throw(); 
# 540
extern "C" float sinhf(float) throw(); 
# 543
extern "C" float tanhf(float) throw(); 
# 546
extern "C" float expf(float) throw(); 
# 549
extern "C" float logf(float) throw(); 
# 552
extern "C" float log10f(float) throw(); 
# 555
extern "C" float modff(float, float *) throw(); 
# 558
extern "C" float powf(float, float) throw(); 
# 561
extern "C" float sqrtf(float) throw(); 
# 564
extern "C" float ceilf(float) throw(); 
# 567
extern "C" float floorf(float) throw(); 
# 570
extern "C" float fmodf(float, float) throw(); 
# 605 "/home/u0332192/local/cuda/include/math_functions.h"
namespace __gnu_cxx { 
# 607
extern inline long long abs(long long); 
# 608
}
# 610
namespace std { 
# 612
template< class T> extern inline T __pow_helper(T, int); 
# 613
template< class T> extern inline T __cmath_power(T, unsigned); 
# 614
}
# 616
using std::abs;
# 617
using std::fabs;
# 618
using std::ceil;
# 619
using std::floor;
# 620
using std::sqrt;
# 621
using std::pow;
# 622
using std::log;
# 623
using std::log10;
# 624
using std::fmod;
# 625
using std::modf;
# 626
using std::exp;
# 627
using std::frexp;
# 628
using std::ldexp;
# 629
using std::asin;
# 630
using std::sin;
# 631
using std::sinh;
# 632
using std::acos;
# 633
using std::cos;
# 634
using std::cosh;
# 635
using std::atan;
# 636
using std::atan2;
# 637
using std::tan;
# 638
using std::tanh;
# 695 "/home/u0332192/local/cuda/include/math_functions.h"
namespace std { 
# 698
extern inline long abs(long); 
# 699
extern inline float abs(float); 
# 700
extern inline double abs(double); 
# 701
extern inline float fabs(float); 
# 702
extern inline float ceil(float); 
# 703
extern inline float floor(float); 
# 704
extern inline float sqrt(float); 
# 705
extern inline float pow(float, float); 
# 706
extern inline float pow(float, int); 
# 707
extern inline double pow(double, int); 
# 708
extern inline float log(float); 
# 709
extern inline float log10(float); 
# 710
extern inline float fmod(float, float); 
# 711
extern inline float modf(float, float *); 
# 712
extern inline float exp(float); 
# 713
extern inline float frexp(float, int *); 
# 714
extern inline float ldexp(float, int); 
# 715
extern inline float asin(float); 
# 716
extern inline float sin(float); 
# 717
extern inline float sinh(float); 
# 718
extern inline float acos(float); 
# 719
extern inline float cos(float); 
# 720
extern inline float cosh(float); 
# 721
extern inline float atan(float); 
# 722
extern inline float atan2(float, float); 
# 723
extern inline float tan(float); 
# 724
extern inline float tanh(float); 
# 727
}
# 730
static inline float logb(float a) 
# 731
{ 
# 732
return logbf(a); 
# 733
} 
# 735
static inline int ilogb(float a) 
# 736
{ 
# 737
return ilogbf(a); 
# 738
} 
# 740
static inline float scalbn(float a, int b) 
# 741
{ 
# 742
return scalbnf(a, b); 
# 743
} 
# 745
static inline float scalbln(float a, long b) 
# 746
{ 
# 747
return scalblnf(a, b); 
# 748
} 
# 750
static inline float exp2(float a) 
# 751
{ 
# 752
return exp2f(a); 
# 753
} 
# 755
static inline float exp10(float a) 
# 756
{ 
# 757
return exp10f(a); 
# 758
} 
# 760
static inline float expm1(float a) 
# 761
{ 
# 762
return expm1f(a); 
# 763
} 
# 765
static inline float log2(float a) 
# 766
{ 
# 767
return log2f(a); 
# 768
} 
# 770
static inline float log1p(float a) 
# 771
{ 
# 772
return log1pf(a); 
# 773
} 
# 775
static inline float rsqrt(float a) 
# 776
{ 
# 777
return rsqrtf(a); 
# 778
} 
# 780
static inline float acosh(float a) 
# 781
{ 
# 782
return acoshf(a); 
# 783
} 
# 785
static inline float asinh(float a) 
# 786
{ 
# 787
return asinhf(a); 
# 788
} 
# 790
static inline float atanh(float a) 
# 791
{ 
# 792
return atanhf(a); 
# 793
} 
# 795
static inline float hypot(float a, float b) 
# 796
{ 
# 797
return hypotf(a, b); 
# 798
} 
# 800
static inline float cbrt(float a) 
# 801
{ 
# 802
return cbrtf(a); 
# 803
} 
# 805
static inline float rcbrt(float a) 
# 806
{ 
# 807
return rcbrtf(a); 
# 808
} 
# 810
static inline float sinpi(float a) 
# 811
{ 
# 812
return sinpif(a); 
# 813
} 
# 815
static inline float cospi(float a) 
# 816
{ 
# 817
return cospif(a); 
# 818
} 
# 820
static inline void sincos(float a, float *sptr, float *cptr) 
# 821
{ 
# 822
sincosf(a, sptr, cptr); 
# 823
} 
# 825
static inline float erf(float a) 
# 826
{ 
# 827
return erff(a); 
# 828
} 
# 830
static inline float erfinv(float a) 
# 831
{ 
# 832
return erfinvf(a); 
# 833
} 
# 835
static inline float erfc(float a) 
# 836
{ 
# 837
return erfcf(a); 
# 838
} 
# 840
static inline float erfcinv(float a) 
# 841
{ 
# 842
return erfcinvf(a); 
# 843
} 
# 845
static inline float lgamma(float a) 
# 846
{ 
# 847
return lgammaf(a); 
# 848
} 
# 850
static inline float tgamma(float a) 
# 851
{ 
# 852
return tgammaf(a); 
# 853
} 
# 855
static inline float copysign(float a, float b) 
# 856
{ 
# 857
return copysignf(a, b); 
# 858
} 
# 860
static inline double copysign(double a, float b) 
# 861
{ 
# 862
return copysign(a, (double)b); 
# 863
} 
# 865
static inline float copysign(float a, double b) 
# 866
{ 
# 867
return copysignf(a, (float)b); 
# 868
} 
# 870
static inline float nextafter(float a, float b) 
# 871
{ 
# 872
return nextafterf(a, b); 
# 873
} 
# 875
static inline float remainder(float a, float b) 
# 876
{ 
# 877
return remainderf(a, b); 
# 878
} 
# 880
static inline float remquo(float a, float b, int *quo) 
# 881
{ 
# 882
return remquof(a, b, quo); 
# 883
} 
# 885
static inline float round(float a) 
# 886
{ 
# 887
return roundf(a); 
# 888
} 
# 890
static inline long lround(float a) 
# 891
{ 
# 892
return lroundf(a); 
# 893
} 
# 895
static inline long long llround(float a) 
# 896
{ 
# 897
return llroundf(a); 
# 898
} 
# 900
static inline float trunc(float a) 
# 901
{ 
# 902
return truncf(a); 
# 903
} 
# 905
static inline float rint(float a) 
# 906
{ 
# 907
return rintf(a); 
# 908
} 
# 910
static inline long lrint(float a) 
# 911
{ 
# 912
return lrintf(a); 
# 913
} 
# 915
static inline long long llrint(float a) 
# 916
{ 
# 917
return llrintf(a); 
# 918
} 
# 920
static inline float nearbyint(float a) 
# 921
{ 
# 922
return nearbyintf(a); 
# 923
} 
# 925
static inline float fdim(float a, float b) 
# 926
{ 
# 927
return fdimf(a, b); 
# 928
} 
# 930
static inline float fma(float a, float b, float c) 
# 931
{ 
# 932
return fmaf(a, b, c); 
# 933
} 
# 935
static inline float fmax(float a, float b) 
# 936
{ 
# 937
return fmaxf(a, b); 
# 938
} 
# 940
static inline float fmin(float a, float b) 
# 941
{ 
# 942
return fminf(a, b); 
# 943
} 
# 945
static inline unsigned min(unsigned a, unsigned b) 
# 946
{ 
# 947
return umin(a, b); 
# 948
} 
# 950
static inline unsigned min(int a, unsigned b) 
# 951
{ 
# 952
return umin((unsigned)a, b); 
# 953
} 
# 955
static inline unsigned min(unsigned a, int b) 
# 956
{ 
# 957
return umin(a, (unsigned)b); 
# 958
} 
# 960
static inline long long min(long long a, long long b) 
# 961
{ 
# 962
return llmin(a, b); 
# 963
} 
# 965
static inline unsigned long long min(unsigned long long a, unsigned long long b) 
# 966
{ 
# 967
return ullmin(a, b); 
# 968
} 
# 970
static inline unsigned long long min(long long a, unsigned long long b) 
# 971
{ 
# 972
return ullmin((unsigned long long)a, b); 
# 973
} 
# 975
static inline unsigned long long min(unsigned long long a, long long b) 
# 976
{ 
# 977
return ullmin(a, (unsigned long long)b); 
# 978
} 
# 980
static inline float min(float a, float b) 
# 981
{ 
# 982
return fminf(a, b); 
# 983
} 
# 985
static inline double min(double a, double b) 
# 986
{ 
# 987
return fmin(a, b); 
# 988
} 
# 990
static inline double min(float a, double b) 
# 991
{ 
# 992
return fmin((double)a, b); 
# 993
} 
# 995
static inline double min(double a, float b) 
# 996
{ 
# 997
return fmin(a, (double)b); 
# 998
} 
# 1000
static inline unsigned max(unsigned a, unsigned b) 
# 1001
{ 
# 1002
return umax(a, b); 
# 1003
} 
# 1005
static inline unsigned max(int a, unsigned b) 
# 1006
{ 
# 1007
return umax((unsigned)a, b); 
# 1008
} 
# 1010
static inline unsigned max(unsigned a, int b) 
# 1011
{ 
# 1012
return umax(a, (unsigned)b); 
# 1013
} 
# 1015
static inline long long max(long long a, long long b) 
# 1016
{ 
# 1017
return llmax(a, b); 
# 1018
} 
# 1020
static inline unsigned long long max(unsigned long long a, unsigned long long b) 
# 1021
{ 
# 1022
return ullmax(a, b); 
# 1023
} 
# 1025
static inline unsigned long long max(long long a, unsigned long long b) 
# 1026
{ 
# 1027
return ullmax((unsigned long long)a, b); 
# 1028
} 
# 1030
static inline unsigned long long max(unsigned long long a, long long b) 
# 1031
{ 
# 1032
return ullmax(a, (unsigned long long)b); 
# 1033
} 
# 1035
static inline float max(float a, float b) 
# 1036
{ 
# 1037
return fmaxf(a, b); 
# 1038
} 
# 1040
static inline double max(double a, double b) 
# 1041
{ 
# 1042
return fmax(a, b); 
# 1043
} 
# 1045
static inline double max(float a, double b) 
# 1046
{ 
# 1047
return fmax((double)a, b); 
# 1048
} 
# 1050
static inline double max(double a, float b) 
# 1051
{ 
# 1052
return fmax(a, (double)b); 
# 1053
} 
# 74 "/home/u0332192/local/cuda/include/cuda_surface_types.h"
template< class T, int dim = 1> 
# 75
struct surface : public surfaceReference { 
# 77
surface() 
# 78
{ 
# 79
(channelDesc) = cudaCreateChannelDesc< T> (); 
# 80
} 
# 82
surface(cudaChannelFormatDesc desc) 
# 83
{ 
# 84
(channelDesc) = desc; 
# 85
} 
# 86
}; 
# 89
template< int dim> 
# 90
struct surface< void, dim>  : public surfaceReference { 
# 92
surface() 
# 93
{ 
# 94
(channelDesc) = cudaCreateChannelDesc< void> (); 
# 95
} 
# 96
}; 
# 74 "/home/u0332192/local/cuda/include/cuda_texture_types.h"
template< class T, int texType = 1, cudaTextureReadMode mode = cudaReadModeElementType> 
# 75
struct texture : public textureReference { 
# 77
texture(int norm = 0, cudaTextureFilterMode 
# 78
fMode = cudaFilterModePoint, cudaTextureAddressMode 
# 79
aMode = cudaAddressModeClamp) 
# 80
{ 
# 81
(normalized) = norm; 
# 82
(filterMode) = fMode; 
# 83
((addressMode)[0]) = aMode; 
# 84
((addressMode)[1]) = aMode; 
# 85
((addressMode)[2]) = aMode; 
# 86
(channelDesc) = cudaCreateChannelDesc< T> (); 
# 87
(sRGB) = 0; 
# 88
} 
# 90
texture(int norm, cudaTextureFilterMode 
# 91
fMode, cudaTextureAddressMode 
# 92
aMode, cudaChannelFormatDesc 
# 93
desc) 
# 94
{ 
# 95
(normalized) = norm; 
# 96
(filterMode) = fMode; 
# 97
((addressMode)[0]) = aMode; 
# 98
((addressMode)[1]) = aMode; 
# 99
((addressMode)[2]) = aMode; 
# 100
(channelDesc) = desc; 
# 101
(sRGB) = 0; 
# 102
} 
# 103
}; 
# 338 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline int mulhi(int a, int b) 
# 339
{int volatile ___ = 1;(void)a;(void)b;
# 341
exit(___);}
#if 0
# 339
{ 
# 340
return __mulhi(a, b); 
# 341
} 
#endif
# 343 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned mulhi(unsigned a, unsigned b) 
# 344
{int volatile ___ = 1;(void)a;(void)b;
# 346
exit(___);}
#if 0
# 344
{ 
# 345
return __umulhi(a, b); 
# 346
} 
#endif
# 348 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned mulhi(int a, unsigned b) 
# 349
{int volatile ___ = 1;(void)a;(void)b;
# 351
exit(___);}
#if 0
# 349
{ 
# 350
return __umulhi((unsigned)a, b); 
# 351
} 
#endif
# 353 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned mulhi(unsigned a, int b) 
# 354
{int volatile ___ = 1;(void)a;(void)b;
# 356
exit(___);}
#if 0
# 354
{ 
# 355
return __umulhi(a, (unsigned)b); 
# 356
} 
#endif
# 358 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline long long mul64hi(long long a, long long b) 
# 359
{int volatile ___ = 1;(void)a;(void)b;
# 361
exit(___);}
#if 0
# 359
{ 
# 360
return __mul64hi(a, b); 
# 361
} 
#endif
# 363 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned long long mul64hi(unsigned long long a, unsigned long long b) 
# 364
{int volatile ___ = 1;(void)a;(void)b;
# 366
exit(___);}
#if 0
# 364
{ 
# 365
return __umul64hi(a, b); 
# 366
} 
#endif
# 368 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned long long mul64hi(long long a, unsigned long long b) 
# 369
{int volatile ___ = 1;(void)a;(void)b;
# 371
exit(___);}
#if 0
# 369
{ 
# 370
return __umul64hi((unsigned long long)a, b); 
# 371
} 
#endif
# 373 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned long long mul64hi(unsigned long long a, long long b) 
# 374
{int volatile ___ = 1;(void)a;(void)b;
# 376
exit(___);}
#if 0
# 374
{ 
# 375
return __umul64hi(a, (unsigned long long)b); 
# 376
} 
#endif
# 378 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline int float_as_int(float a) 
# 379
{int volatile ___ = 1;(void)a;
# 381
exit(___);}
#if 0
# 379
{ 
# 380
return __float_as_int(a); 
# 381
} 
#endif
# 383 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline float int_as_float(int a) 
# 384
{int volatile ___ = 1;(void)a;
# 386
exit(___);}
#if 0
# 384
{ 
# 385
return __int_as_float(a); 
# 386
} 
#endif
# 388 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline float saturate(float a) 
# 389
{int volatile ___ = 1;(void)a;
# 391
exit(___);}
#if 0
# 389
{ 
# 390
return __saturatef(a); 
# 391
} 
#endif
# 393 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline int mul24(int a, int b) 
# 394
{int volatile ___ = 1;(void)a;(void)b;
# 396
exit(___);}
#if 0
# 394
{ 
# 395
return __mul24(a, b); 
# 396
} 
#endif
# 398 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned umul24(unsigned a, unsigned b) 
# 399
{int volatile ___ = 1;(void)a;(void)b;
# 401
exit(___);}
#if 0
# 399
{ 
# 400
return __umul24(a, b); 
# 401
} 
#endif
# 403 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline void trap() 
# 404
{int volatile ___ = 1;
# 406
exit(___);}
#if 0
# 404
{ 
# 405
__trap(); 
# 406
} 
#endif
# 409 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline void brkpt(int c = 0) 
# 410
{int volatile ___ = 1;(void)c;
# 412
exit(___);}
#if 0
# 410
{ 
# 411
__brkpt(c); 
# 412
} 
#endif
# 414 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline void syncthreads() 
# 415
{int volatile ___ = 1;
# 417
exit(___);}
#if 0
# 415
{ 
# 416
__syncthreads(); 
# 417
} 
#endif
# 419 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline void prof_trigger(int e) 
# 420
{int volatile ___ = 1;(void)e;
# 437
exit(___);}
#if 0
# 420
{ 
# 421
if (e == 0) { __prof_trigger(0); } else { 
# 422
if (e == 1) { __prof_trigger(1); } else { 
# 423
if (e == 2) { __prof_trigger(2); } else { 
# 424
if (e == 3) { __prof_trigger(3); } else { 
# 425
if (e == 4) { __prof_trigger(4); } else { 
# 426
if (e == 5) { __prof_trigger(5); } else { 
# 427
if (e == 6) { __prof_trigger(6); } else { 
# 428
if (e == 7) { __prof_trigger(7); } else { 
# 429
if (e == 8) { __prof_trigger(8); } else { 
# 430
if (e == 9) { __prof_trigger(9); } else { 
# 431
if (e == 10) { __prof_trigger(10); } else { 
# 432
if (e == 11) { __prof_trigger(11); } else { 
# 433
if (e == 12) { __prof_trigger(12); } else { 
# 434
if (e == 13) { __prof_trigger(13); } else { 
# 435
if (e == 14) { __prof_trigger(14); } else { 
# 436
if (e == 15) { __prof_trigger(15); }  }  }  }  }  }  }  }  }  }  }  }  }  }  }  }  
# 437
} 
#endif
# 439 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline void threadfence(bool global = true) 
# 440
{int volatile ___ = 1;(void)global;
# 442
exit(___);}
#if 0
# 440
{ 
# 441
global ? __threadfence() : __threadfence_block(); 
# 442
} 
#endif
# 444 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline int float2int(float a, cudaRoundMode mode = cudaRoundZero) 
# 445
{int volatile ___ = 1;(void)a;(void)mode;
# 450
exit(___);}
#if 0
# 445
{ 
# 446
return (mode == (cudaRoundNearest)) ? __float2int_rn(a) : ((mode == (cudaRoundPosInf)) ? __float2int_ru(a) : ((mode == (cudaRoundMinInf)) ? __float2int_rd(a) : __float2int_rz(a))); 
# 450
} 
#endif
# 452 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline unsigned float2uint(float a, cudaRoundMode mode = cudaRoundZero) 
# 453
{int volatile ___ = 1;(void)a;(void)mode;
# 458
exit(___);}
#if 0
# 453
{ 
# 454
return (mode == (cudaRoundNearest)) ? __float2uint_rn(a) : ((mode == (cudaRoundPosInf)) ? __float2uint_ru(a) : ((mode == (cudaRoundMinInf)) ? __float2uint_rd(a) : __float2uint_rz(a))); 
# 458
} 
#endif
# 460 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline float int2float(int a, cudaRoundMode mode = cudaRoundNearest) 
# 461
{int volatile ___ = 1;(void)a;(void)mode;
# 466
exit(___);}
#if 0
# 461
{ 
# 462
return (mode == (cudaRoundZero)) ? __int2float_rz(a) : ((mode == (cudaRoundPosInf)) ? __int2float_ru(a) : ((mode == (cudaRoundMinInf)) ? __int2float_rd(a) : __int2float_rn(a))); 
# 466
} 
#endif
# 468 "/home/u0332192/local/cuda/include/device_functions.h"
__attribute__((unused)) static inline float uint2float(unsigned a, cudaRoundMode mode = cudaRoundNearest) 
# 469
{int volatile ___ = 1;(void)a;(void)mode;
# 474
exit(___);}
#if 0
# 469
{ 
# 470
return (mode == (cudaRoundZero)) ? __uint2float_rz(a) : ((mode == (cudaRoundPosInf)) ? __uint2float_ru(a) : ((mode == (cudaRoundMinInf)) ? __uint2float_rd(a) : __uint2float_rn(a))); 
# 474
} 
#endif
# 116 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicAdd(int *address, int val) 
# 117
{int volatile ___ = 1;(void)address;(void)val;
# 119
exit(___);}
#if 0
# 117
{ 
# 118
return __iAtomicAdd(address, val); 
# 119
} 
#endif
# 121 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicAdd(unsigned *address, unsigned val) 
# 122
{int volatile ___ = 1;(void)address;(void)val;
# 124
exit(___);}
#if 0
# 122
{ 
# 123
return __uAtomicAdd(address, val); 
# 124
} 
#endif
# 126 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicSub(int *address, int val) 
# 127
{int volatile ___ = 1;(void)address;(void)val;
# 129
exit(___);}
#if 0
# 127
{ 
# 128
return __iAtomicAdd(address, (unsigned)(-((int)val))); 
# 129
} 
#endif
# 131 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicSub(unsigned *address, unsigned val) 
# 132
{int volatile ___ = 1;(void)address;(void)val;
# 134
exit(___);}
#if 0
# 132
{ 
# 133
return __uAtomicAdd(address, (unsigned)(-((int)val))); 
# 134
} 
#endif
# 136 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicExch(int *address, int val) 
# 137
{int volatile ___ = 1;(void)address;(void)val;
# 139
exit(___);}
#if 0
# 137
{ 
# 138
return __iAtomicExch(address, val); 
# 139
} 
#endif
# 141 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicExch(unsigned *address, unsigned val) 
# 142
{int volatile ___ = 1;(void)address;(void)val;
# 144
exit(___);}
#if 0
# 142
{ 
# 143
return __uAtomicExch(address, val); 
# 144
} 
#endif
# 146 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline float atomicExch(float *address, float val) 
# 147
{int volatile ___ = 1;(void)address;(void)val;
# 149
exit(___);}
#if 0
# 147
{ 
# 148
return __fAtomicExch(address, val); 
# 149
} 
#endif
# 151 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicMin(int *address, int val) 
# 152
{int volatile ___ = 1;(void)address;(void)val;
# 154
exit(___);}
#if 0
# 152
{ 
# 153
return __iAtomicMin(address, val); 
# 154
} 
#endif
# 156 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicMin(unsigned *address, unsigned val) 
# 157
{int volatile ___ = 1;(void)address;(void)val;
# 159
exit(___);}
#if 0
# 157
{ 
# 158
return __uAtomicMin(address, val); 
# 159
} 
#endif
# 161 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicMax(int *address, int val) 
# 162
{int volatile ___ = 1;(void)address;(void)val;
# 164
exit(___);}
#if 0
# 162
{ 
# 163
return __iAtomicMax(address, val); 
# 164
} 
#endif
# 166 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicMax(unsigned *address, unsigned val) 
# 167
{int volatile ___ = 1;(void)address;(void)val;
# 169
exit(___);}
#if 0
# 167
{ 
# 168
return __uAtomicMax(address, val); 
# 169
} 
#endif
# 171 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicInc(unsigned *address, unsigned val) 
# 172
{int volatile ___ = 1;(void)address;(void)val;
# 174
exit(___);}
#if 0
# 172
{ 
# 173
return __uAtomicInc(address, val); 
# 174
} 
#endif
# 176 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicDec(unsigned *address, unsigned val) 
# 177
{int volatile ___ = 1;(void)address;(void)val;
# 179
exit(___);}
#if 0
# 177
{ 
# 178
return __uAtomicDec(address, val); 
# 179
} 
#endif
# 181 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicAnd(int *address, int val) 
# 182
{int volatile ___ = 1;(void)address;(void)val;
# 184
exit(___);}
#if 0
# 182
{ 
# 183
return __iAtomicAnd(address, val); 
# 184
} 
#endif
# 186 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicAnd(unsigned *address, unsigned val) 
# 187
{int volatile ___ = 1;(void)address;(void)val;
# 189
exit(___);}
#if 0
# 187
{ 
# 188
return __uAtomicAnd(address, val); 
# 189
} 
#endif
# 191 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicOr(int *address, int val) 
# 192
{int volatile ___ = 1;(void)address;(void)val;
# 194
exit(___);}
#if 0
# 192
{ 
# 193
return __iAtomicOr(address, val); 
# 194
} 
#endif
# 196 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicOr(unsigned *address, unsigned val) 
# 197
{int volatile ___ = 1;(void)address;(void)val;
# 199
exit(___);}
#if 0
# 197
{ 
# 198
return __uAtomicOr(address, val); 
# 199
} 
#endif
# 201 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicXor(int *address, int val) 
# 202
{int volatile ___ = 1;(void)address;(void)val;
# 204
exit(___);}
#if 0
# 202
{ 
# 203
return __iAtomicXor(address, val); 
# 204
} 
#endif
# 206 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicXor(unsigned *address, unsigned val) 
# 207
{int volatile ___ = 1;(void)address;(void)val;
# 209
exit(___);}
#if 0
# 207
{ 
# 208
return __uAtomicXor(address, val); 
# 209
} 
#endif
# 211 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline int atomicCAS(int *address, int compare, int val) 
# 212
{int volatile ___ = 1;(void)address;(void)compare;(void)val;
# 214
exit(___);}
#if 0
# 212
{ 
# 213
return __iAtomicCAS(address, compare, val); 
# 214
} 
#endif
# 216 "/home/u0332192/local/cuda/include/sm_11_atomic_functions.h"
__attribute__((unused)) static inline unsigned atomicCAS(unsigned *address, unsigned compare, unsigned val) 
# 217
{int volatile ___ = 1;(void)address;(void)compare;(void)val;
# 219
exit(___);}
#if 0
# 217
{ 
# 218
return __uAtomicCAS(address, compare, val); 
# 219
} 
#endif
# 89 "/home/u0332192/local/cuda/include/sm_12_atomic_functions.h"
__attribute__((unused)) static inline unsigned long long atomicAdd(unsigned long long *address, unsigned long long val) 
# 90
{int volatile ___ = 1;(void)address;(void)val;
# 92
exit(___);}
#if 0
# 90
{ 
# 91
return __ullAtomicAdd(address, val); 
# 92
} 
#endif
# 94 "/home/u0332192/local/cuda/include/sm_12_atomic_functions.h"
__attribute__((unused)) static inline unsigned long long atomicExch(unsigned long long *address, unsigned long long val) 
# 95
{int volatile ___ = 1;(void)address;(void)val;
# 97
exit(___);}
#if 0
# 95
{ 
# 96
return __ullAtomicExch(address, val); 
# 97
} 
#endif
# 99 "/home/u0332192/local/cuda/include/sm_12_atomic_functions.h"
__attribute__((unused)) static inline unsigned long long atomicCAS(unsigned long long *address, unsigned long long compare, unsigned long long val) 
# 100
{int volatile ___ = 1;(void)address;(void)compare;(void)val;
# 102
exit(___);}
#if 0
# 100
{ 
# 101
return __ullAtomicCAS(address, compare, val); 
# 102
} 
#endif
# 104 "/home/u0332192/local/cuda/include/sm_12_atomic_functions.h"
__attribute__((unused)) static inline bool any(bool cond) 
# 105
{int volatile ___ = 1;(void)cond;
# 107
exit(___);}
#if 0
# 105
{ 
# 106
return (bool)__any((int)cond); 
# 107
} 
#endif
# 109 "/home/u0332192/local/cuda/include/sm_12_atomic_functions.h"
__attribute__((unused)) static inline bool all(bool cond) 
# 110
{int volatile ___ = 1;(void)cond;
# 112
exit(___);}
#if 0
# 110
{ 
# 111
return (bool)__all((int)cond); 
# 112
} 
#endif
# 184 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double fma(double a, double b, double c, cudaRoundMode mode) 
# 185
{int volatile ___ = 1;(void)a;(void)b;(void)c;(void)mode;
# 190
exit(___);}
#if 0
# 185
{ 
# 186
return (mode == (cudaRoundZero)) ? __fma_rz(a, b, c) : ((mode == (cudaRoundPosInf)) ? __fma_ru(a, b, c) : ((mode == (cudaRoundMinInf)) ? __fma_rd(a, b, c) : __fma_rn(a, b, c))); 
# 190
} 
#endif
# 192 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double dmul(double a, double b, cudaRoundMode mode = cudaRoundNearest) 
# 193
{int volatile ___ = 1;(void)a;(void)b;(void)mode;
# 198
exit(___);}
#if 0
# 193
{ 
# 194
return (mode == (cudaRoundZero)) ? __dmul_rz(a, b) : ((mode == (cudaRoundPosInf)) ? __dmul_ru(a, b) : ((mode == (cudaRoundMinInf)) ? __dmul_rd(a, b) : __dmul_rn(a, b))); 
# 198
} 
#endif
# 200 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double dadd(double a, double b, cudaRoundMode mode = cudaRoundNearest) 
# 201
{int volatile ___ = 1;(void)a;(void)b;(void)mode;
# 206
exit(___);}
#if 0
# 201
{ 
# 202
return (mode == (cudaRoundZero)) ? __dadd_rz(a, b) : ((mode == (cudaRoundPosInf)) ? __dadd_ru(a, b) : ((mode == (cudaRoundMinInf)) ? __dadd_rd(a, b) : __dadd_rn(a, b))); 
# 206
} 
#endif
# 208 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline int double2int(double a, cudaRoundMode mode = cudaRoundZero) 
# 209
{int volatile ___ = 1;(void)a;(void)mode;
# 214
exit(___);}
#if 0
# 209
{ 
# 210
return (mode == (cudaRoundNearest)) ? __double2int_rn(a) : ((mode == (cudaRoundPosInf)) ? __double2int_ru(a) : ((mode == (cudaRoundMinInf)) ? __double2int_rd(a) : __double2int_rz(a))); 
# 214
} 
#endif
# 216 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline unsigned double2uint(double a, cudaRoundMode mode = cudaRoundZero) 
# 217
{int volatile ___ = 1;(void)a;(void)mode;
# 222
exit(___);}
#if 0
# 217
{ 
# 218
return (mode == (cudaRoundNearest)) ? __double2uint_rn(a) : ((mode == (cudaRoundPosInf)) ? __double2uint_ru(a) : ((mode == (cudaRoundMinInf)) ? __double2uint_rd(a) : __double2uint_rz(a))); 
# 222
} 
#endif
# 224 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline long long double2ll(double a, cudaRoundMode mode = cudaRoundZero) 
# 225
{int volatile ___ = 1;(void)a;(void)mode;
# 230
exit(___);}
#if 0
# 225
{ 
# 226
return (mode == (cudaRoundNearest)) ? __double2ll_rn(a) : ((mode == (cudaRoundPosInf)) ? __double2ll_ru(a) : ((mode == (cudaRoundMinInf)) ? __double2ll_rd(a) : __double2ll_rz(a))); 
# 230
} 
#endif
# 232 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline unsigned long long double2ull(double a, cudaRoundMode mode = cudaRoundZero) 
# 233
{int volatile ___ = 1;(void)a;(void)mode;
# 238
exit(___);}
#if 0
# 233
{ 
# 234
return (mode == (cudaRoundNearest)) ? __double2ull_rn(a) : ((mode == (cudaRoundPosInf)) ? __double2ull_ru(a) : ((mode == (cudaRoundMinInf)) ? __double2ull_rd(a) : __double2ull_rz(a))); 
# 238
} 
#endif
# 240 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double ll2double(long long a, cudaRoundMode mode = cudaRoundNearest) 
# 241
{int volatile ___ = 1;(void)a;(void)mode;
# 246
exit(___);}
#if 0
# 241
{ 
# 242
return (mode == (cudaRoundZero)) ? __ll2double_rz(a) : ((mode == (cudaRoundPosInf)) ? __ll2double_ru(a) : ((mode == (cudaRoundMinInf)) ? __ll2double_rd(a) : __ll2double_rn(a))); 
# 246
} 
#endif
# 248 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double ull2double(unsigned long long a, cudaRoundMode mode = cudaRoundNearest) 
# 249
{int volatile ___ = 1;(void)a;(void)mode;
# 254
exit(___);}
#if 0
# 249
{ 
# 250
return (mode == (cudaRoundZero)) ? __ull2double_rz(a) : ((mode == (cudaRoundPosInf)) ? __ull2double_ru(a) : ((mode == (cudaRoundMinInf)) ? __ull2double_rd(a) : __ull2double_rn(a))); 
# 254
} 
#endif
# 256 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double int2double(int a, cudaRoundMode mode = cudaRoundNearest) 
# 257
{int volatile ___ = 1;(void)a;(void)mode;
# 259
exit(___);}
#if 0
# 257
{ 
# 258
return (double)a; 
# 259
} 
#endif
# 261 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double uint2double(unsigned a, cudaRoundMode mode = cudaRoundNearest) 
# 262
{int volatile ___ = 1;(void)a;(void)mode;
# 264
exit(___);}
#if 0
# 262
{ 
# 263
return (double)a; 
# 264
} 
#endif
# 266 "/home/u0332192/local/cuda/include/sm_13_double_functions.h"
__attribute__((unused)) static inline double float2double(float a, cudaRoundMode mode = cudaRoundNearest) 
# 267
{int volatile ___ = 1;(void)a;(void)mode;
# 269
exit(___);}
#if 0
# 267
{ 
# 268
return (double)a; 
# 269
} 
#endif
# 80 "/home/u0332192/local/cuda/include/sm_20_atomic_functions.h"
__attribute__((unused)) static inline float atomicAdd(float *address, float val) 
# 81
{int volatile ___ = 1;(void)address;(void)val;
# 83
exit(___);}
#if 0
# 81
{ 
# 82
return __fAtomicAdd(address, val); 
# 83
} 
#endif
# 138 "/home/u0332192/local/cuda/include/sm_20_intrinsics.h"
__attribute__((unused)) static inline unsigned ballot(bool pred) 
# 139
{int volatile ___ = 1;(void)pred;
# 141
exit(___);}
#if 0
# 139
{ 
# 140
return __ballot((int)pred); 
# 141
} 
#endif
# 143 "/home/u0332192/local/cuda/include/sm_20_intrinsics.h"
__attribute__((unused)) static inline int syncthreads_count(bool pred) 
# 144
{int volatile ___ = 1;(void)pred;
# 146
exit(___);}
#if 0
# 144
{ 
# 145
return __syncthreads_count((int)pred); 
# 146
} 
#endif
# 148 "/home/u0332192/local/cuda/include/sm_20_intrinsics.h"
__attribute__((unused)) static inline bool syncthreads_and(bool pred) 
# 149
{int volatile ___ = 1;(void)pred;
# 151
exit(___);}
#if 0
# 149
{ 
# 150
return (bool)__syncthreads_and((int)pred); 
# 151
} 
#endif
# 153 "/home/u0332192/local/cuda/include/sm_20_intrinsics.h"
__attribute__((unused)) static inline bool syncthreads_or(bool pred) 
# 154
{int volatile ___ = 1;(void)pred;
# 156
exit(___);}
#if 0
# 154
{ 
# 155
return (bool)__syncthreads_or((int)pred); 
# 156
} 
#endif
# 111 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 112
surf1Dread(T *res, surface< void, 1>  surf, int x, int s, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 113
{int volatile ___ = 1;(void)res;(void)surf;(void)x;(void)s;(void)mode;
# 120
exit(___);}
#if 0
# 113
{ 
# 114
(s == 1) ? ((void)((*((uchar1 *)res)) = __surf1Dreadc1(surf, x, cudaBoundaryModeTrap))) : ((s == 2) ? ((void)((*((ushort1 *)res)) = __surf1Dreads1(surf, x, cudaBoundaryModeTrap))) : ((s == 4) ? ((void)((*((uint1 *)res)) = __surf1Dreadu1(surf, x, cudaBoundaryModeTrap))) : ((s == 8) ? ((void)((*((uint2 *)res)) = __surf1Dreadu2(surf, x, cudaBoundaryModeTrap))) : ((s == 16) ? ((void)((*((uint4 *)res)) = __surf1Dreadu4(surf, x, cudaBoundaryModeTrap))) : ((void)0))))); 
# 120
} 
#endif
# 122 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline T 
# 123
surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 124
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 130
exit(___);}
#if 0
# 124
{ 
# 125
T tmp; 
# 127
surf1Dread(&tmp, surf, x, (int)sizeof(T), mode); 
# 129
return tmp; 
# 130
} 
#endif
# 132 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 133
surf1Dread(T *res, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 134
{int volatile ___ = 1;(void)res;(void)surf;(void)x;(void)mode;
# 136
exit(___);}
#if 0
# 134
{ 
# 135
(*res) = surf1Dread< T> (surf, x, mode); 
# 136
} 
#endif
# 139 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 140
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 142
exit(___);}
#if 0
# 140
{ 
# 141
return (char)(__surf1Dreadc1(surf, x, cudaBoundaryModeTrap).x); 
# 142
} 
#endif
# 145 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline signed char surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 146
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 148
exit(___);}
#if 0
# 146
{ 
# 147
return (signed char)(__surf1Dreadc1(surf, x, cudaBoundaryModeTrap).x); 
# 148
} 
#endif
# 151 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned char surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 152
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 154
exit(___);}
#if 0
# 152
{ 
# 153
return __surf1Dreadc1(surf, x, cudaBoundaryModeTrap).x; 
# 154
} 
#endif
# 157 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 158
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 160
exit(___);}
#if 0
# 158
{ 
# 159
return make_char1((signed char)(__surf1Dreadc1(surf, x, cudaBoundaryModeTrap).x)); 
# 160
} 
#endif
# 163 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uchar1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 164
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 166
exit(___);}
#if 0
# 164
{ 
# 165
return __surf1Dreadc1(surf, x, cudaBoundaryModeTrap); 
# 166
} 
#endif
# 169 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 170
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 174
exit(___);}
#if 0
# 170
{ 
# 171
uchar2 tmp = __surf1Dreadc2(surf, x, cudaBoundaryModeTrap); 
# 173
return make_char2((signed char)(tmp.x), (signed char)(tmp.y)); 
# 174
} 
#endif
# 177 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uchar2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 178
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 180
exit(___);}
#if 0
# 178
{ 
# 179
return __surf1Dreadc2(surf, x, cudaBoundaryModeTrap); 
# 180
} 
#endif
# 183 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char4 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 184
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 188
exit(___);}
#if 0
# 184
{ 
# 185
uchar4 tmp = __surf1Dreadc4(surf, x, cudaBoundaryModeTrap); 
# 187
return make_char4((signed char)(tmp.x), (signed char)(tmp.y), (signed char)(tmp.z), (signed char)(tmp.w)); 
# 188
} 
#endif
# 191 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uchar4 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 192
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 194
exit(___);}
#if 0
# 192
{ 
# 193
return __surf1Dreadc4(surf, x, cudaBoundaryModeTrap); 
# 194
} 
#endif
# 197 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 198
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 200
exit(___);}
#if 0
# 198
{ 
# 199
return (short)(__surf1Dreads1(surf, x, cudaBoundaryModeTrap).x); 
# 200
} 
#endif
# 203 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned short surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 204
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 206
exit(___);}
#if 0
# 204
{ 
# 205
return __surf1Dreads1(surf, x, cudaBoundaryModeTrap).x; 
# 206
} 
#endif
# 209 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 210
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 212
exit(___);}
#if 0
# 210
{ 
# 211
return make_short1((signed short)(__surf1Dreads1(surf, x, cudaBoundaryModeTrap).x)); 
# 212
} 
#endif
# 215 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ushort1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 216
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 218
exit(___);}
#if 0
# 216
{ 
# 217
return __surf1Dreads1(surf, x, cudaBoundaryModeTrap); 
# 218
} 
#endif
# 221 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 222
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 226
exit(___);}
#if 0
# 222
{ 
# 223
ushort2 tmp = __surf1Dreads2(surf, x, cudaBoundaryModeTrap); 
# 225
return make_short2((signed short)(tmp.x), (signed short)(tmp.y)); 
# 226
} 
#endif
# 229 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ushort2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 230
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 232
exit(___);}
#if 0
# 230
{ 
# 231
return __surf1Dreads2(surf, x, cudaBoundaryModeTrap); 
# 232
} 
#endif
# 235 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short4 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 236
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 240
exit(___);}
#if 0
# 236
{ 
# 237
ushort4 tmp = __surf1Dreads4(surf, x, cudaBoundaryModeTrap); 
# 239
return make_short4((signed short)(tmp.x), (signed short)(tmp.y), (signed short)(tmp.z), (signed short)(tmp.w)); 
# 240
} 
#endif
# 243 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ushort4 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 244
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 246
exit(___);}
#if 0
# 244
{ 
# 245
return __surf1Dreads4(surf, x, cudaBoundaryModeTrap); 
# 246
} 
#endif
# 249 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 250
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 252
exit(___);}
#if 0
# 250
{ 
# 251
return (int)(__surf1Dreadu1(surf, x, cudaBoundaryModeTrap).x); 
# 252
} 
#endif
# 255 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 256
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 258
exit(___);}
#if 0
# 256
{ 
# 257
return __surf1Dreadu1(surf, x, cudaBoundaryModeTrap).x; 
# 258
} 
#endif
# 261 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 262
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 264
exit(___);}
#if 0
# 262
{ 
# 263
return make_int1((signed int)(__surf1Dreadu1(surf, x, cudaBoundaryModeTrap).x)); 
# 264
} 
#endif
# 267 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uint1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 268
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 270
exit(___);}
#if 0
# 268
{ 
# 269
return __surf1Dreadu1(surf, x, cudaBoundaryModeTrap); 
# 270
} 
#endif
# 273 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 274
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 278
exit(___);}
#if 0
# 274
{ 
# 275
uint2 tmp = __surf1Dreadu2(surf, x, cudaBoundaryModeTrap); 
# 277
return make_int2((int)(tmp.x), (int)(tmp.y)); 
# 278
} 
#endif
# 281 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uint2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 282
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 284
exit(___);}
#if 0
# 282
{ 
# 283
return __surf1Dreadu2(surf, x, cudaBoundaryModeTrap); 
# 284
} 
#endif
# 287 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int4 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 288
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 292
exit(___);}
#if 0
# 288
{ 
# 289
uint4 tmp = __surf1Dreadu4(surf, x, cudaBoundaryModeTrap); 
# 291
return make_int4((int)(tmp.x), (int)(tmp.y), (int)(tmp.z), (int)(tmp.w)); 
# 292
} 
#endif
# 295 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uint4 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 296
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 298
exit(___);}
#if 0
# 296
{ 
# 297
return __surf1Dreadu4(surf, x, cudaBoundaryModeTrap); 
# 298
} 
#endif
# 301 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline long long surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 302
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 304
exit(___);}
#if 0
# 302
{ 
# 303
return (long long)(__surf1Dreadl1(surf, x, cudaBoundaryModeTrap).x); 
# 304
} 
#endif
# 307 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned long long surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 308
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 310
exit(___);}
#if 0
# 308
{ 
# 309
return __surf1Dreadl1(surf, x, cudaBoundaryModeTrap).x; 
# 310
} 
#endif
# 313 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline longlong1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 314
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 316
exit(___);}
#if 0
# 314
{ 
# 315
return make_longlong1((long long)(__surf1Dreadl1(surf, x, cudaBoundaryModeTrap).x)); 
# 316
} 
#endif
# 319 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ulonglong1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 320
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 322
exit(___);}
#if 0
# 320
{ 
# 321
return __surf1Dreadl1(surf, x, cudaBoundaryModeTrap); 
# 322
} 
#endif
# 325 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline longlong2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 326
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 330
exit(___);}
#if 0
# 326
{ 
# 327
ulonglong2 tmp = __surf1Dreadl2(surf, x, cudaBoundaryModeTrap); 
# 329
return make_longlong2((long long)(tmp.x), (long long)(tmp.y)); 
# 330
} 
#endif
# 333 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ulonglong2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 334
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 336
exit(___);}
#if 0
# 334
{ 
# 335
return __surf1Dreadl2(surf, x, cudaBoundaryModeTrap); 
# 336
} 
#endif
# 399 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 400
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 402
exit(___);}
#if 0
# 400
{ 
# 401
return __int_as_float((int)(__surf1Dreadu1(surf, x, cudaBoundaryModeTrap).x)); 
# 402
} 
#endif
# 405 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float1 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 406
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 408
exit(___);}
#if 0
# 406
{ 
# 407
return make_float1(__int_as_float((int)(__surf1Dreadu1(surf, x, cudaBoundaryModeTrap).x))); 
# 408
} 
#endif
# 411 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float2 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 412
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 416
exit(___);}
#if 0
# 412
{ 
# 413
uint2 tmp = __surf1Dreadu2(surf, x, cudaBoundaryModeTrap); 
# 415
return make_float2(__int_as_float((int)(tmp.x)), __int_as_float((int)(tmp.y))); 
# 416
} 
#endif
# 419 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float4 surf1Dread(surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode) 
# 420
{int volatile ___ = 1;(void)surf;(void)x;(void)mode;
# 424
exit(___);}
#if 0
# 420
{ 
# 421
uint4 tmp = __surf1Dreadu4(surf, x, cudaBoundaryModeTrap); 
# 423
return make_float4(__int_as_float((int)(tmp.x)), __int_as_float((int)(tmp.y)), __int_as_float((int)(tmp.z)), __int_as_float((int)(tmp.w))); 
# 424
} 
#endif
# 471 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 472
surf2Dread(T *res, surface< void, 2>  surf, int x, int y, int s, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 473
{int volatile ___ = 1;(void)res;(void)surf;(void)x;(void)y;(void)s;(void)mode;
# 480
exit(___);}
#if 0
# 473
{ 
# 474
(s == 1) ? ((void)((*((uchar1 *)res)) = __surf2Dreadc1(surf, x, y, cudaBoundaryModeTrap))) : ((s == 2) ? ((void)((*((ushort1 *)res)) = __surf2Dreads1(surf, x, y, cudaBoundaryModeTrap))) : ((s == 4) ? ((void)((*((uint1 *)res)) = __surf2Dreadu1(surf, x, y, cudaBoundaryModeTrap))) : ((s == 8) ? ((void)((*((uint2 *)res)) = __surf2Dreadu2(surf, x, y, cudaBoundaryModeTrap))) : ((s == 16) ? ((void)((*((uint4 *)res)) = __surf2Dreadu4(surf, x, y, cudaBoundaryModeTrap))) : ((void)0))))); 
# 480
} 
#endif
# 482 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline T 
# 483
surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 484
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 490
exit(___);}
#if 0
# 484
{ 
# 485
T tmp; 
# 487
surf2Dread(&tmp, surf, x, y, (int)sizeof(T), mode); 
# 489
return tmp; 
# 490
} 
#endif
# 492 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 493
surf2Dread(T *res, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 494
{int volatile ___ = 1;(void)res;(void)surf;(void)x;(void)y;(void)mode;
# 496
exit(___);}
#if 0
# 494
{ 
# 495
(*res) = surf2Dread< T> (surf, x, y, mode); 
# 496
} 
#endif
# 499 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 500
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 502
exit(___);}
#if 0
# 500
{ 
# 501
return (char)(__surf2Dreadc1(surf, x, y, cudaBoundaryModeTrap).x); 
# 502
} 
#endif
# 505 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline signed char surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 506
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 508
exit(___);}
#if 0
# 506
{ 
# 507
return (signed char)(__surf2Dreadc1(surf, x, y, cudaBoundaryModeTrap).x); 
# 508
} 
#endif
# 511 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned char surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 512
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 514
exit(___);}
#if 0
# 512
{ 
# 513
return __surf2Dreadc1(surf, x, y, cudaBoundaryModeTrap).x; 
# 514
} 
#endif
# 517 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 518
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 520
exit(___);}
#if 0
# 518
{ 
# 519
return make_char1((signed char)(__surf2Dreadc1(surf, x, y, cudaBoundaryModeTrap).x)); 
# 520
} 
#endif
# 523 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uchar1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 524
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 526
exit(___);}
#if 0
# 524
{ 
# 525
return __surf2Dreadc1(surf, x, y, cudaBoundaryModeTrap); 
# 526
} 
#endif
# 529 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 530
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 534
exit(___);}
#if 0
# 530
{ 
# 531
uchar2 tmp = __surf2Dreadc2(surf, x, y, cudaBoundaryModeTrap); 
# 533
return make_char2((signed char)(tmp.x), (signed char)(tmp.y)); 
# 534
} 
#endif
# 537 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uchar2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 538
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 540
exit(___);}
#if 0
# 538
{ 
# 539
return __surf2Dreadc2(surf, x, y, cudaBoundaryModeTrap); 
# 540
} 
#endif
# 543 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline char4 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 544
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 548
exit(___);}
#if 0
# 544
{ 
# 545
uchar4 tmp = __surf2Dreadc4(surf, x, y, cudaBoundaryModeTrap); 
# 547
return make_char4((signed char)(tmp.x), (signed char)(tmp.y), (signed char)(tmp.z), (signed char)(tmp.w)); 
# 548
} 
#endif
# 551 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uchar4 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 552
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 554
exit(___);}
#if 0
# 552
{ 
# 553
return __surf2Dreadc4(surf, x, y, cudaBoundaryModeTrap); 
# 554
} 
#endif
# 557 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 558
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 560
exit(___);}
#if 0
# 558
{ 
# 559
return (short)(__surf2Dreads1(surf, x, y, cudaBoundaryModeTrap).x); 
# 560
} 
#endif
# 563 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned short surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 564
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 566
exit(___);}
#if 0
# 564
{ 
# 565
return __surf2Dreads1(surf, x, y, cudaBoundaryModeTrap).x; 
# 566
} 
#endif
# 569 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 570
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 572
exit(___);}
#if 0
# 570
{ 
# 571
return make_short1((signed short)(__surf2Dreads1(surf, x, y, cudaBoundaryModeTrap).x)); 
# 572
} 
#endif
# 575 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ushort1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 576
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 578
exit(___);}
#if 0
# 576
{ 
# 577
return __surf2Dreads1(surf, x, y, cudaBoundaryModeTrap); 
# 578
} 
#endif
# 581 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 582
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 586
exit(___);}
#if 0
# 582
{ 
# 583
ushort2 tmp = __surf2Dreads2(surf, x, y, cudaBoundaryModeTrap); 
# 585
return make_short2((signed short)(tmp.x), (signed short)(tmp.y)); 
# 586
} 
#endif
# 589 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ushort2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 590
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 592
exit(___);}
#if 0
# 590
{ 
# 591
return __surf2Dreads2(surf, x, y, cudaBoundaryModeTrap); 
# 592
} 
#endif
# 595 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline short4 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 596
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 600
exit(___);}
#if 0
# 596
{ 
# 597
ushort4 tmp = __surf2Dreads4(surf, x, y, cudaBoundaryModeTrap); 
# 599
return make_short4((signed short)(tmp.x), (signed short)(tmp.y), (signed short)(tmp.z), (signed short)(tmp.w)); 
# 600
} 
#endif
# 603 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ushort4 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 604
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 606
exit(___);}
#if 0
# 604
{ 
# 605
return __surf2Dreads4(surf, x, y, cudaBoundaryModeTrap); 
# 606
} 
#endif
# 609 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 610
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 612
exit(___);}
#if 0
# 610
{ 
# 611
return (int)(__surf2Dreadu1(surf, x, y, cudaBoundaryModeTrap).x); 
# 612
} 
#endif
# 615 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 616
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 618
exit(___);}
#if 0
# 616
{ 
# 617
return __surf2Dreadu1(surf, x, y, cudaBoundaryModeTrap).x; 
# 618
} 
#endif
# 621 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 622
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 624
exit(___);}
#if 0
# 622
{ 
# 623
return make_int1((signed int)(__surf2Dreadu1(surf, x, y, cudaBoundaryModeTrap).x)); 
# 624
} 
#endif
# 627 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uint1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 628
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 630
exit(___);}
#if 0
# 628
{ 
# 629
return __surf2Dreadu1(surf, x, y, cudaBoundaryModeTrap); 
# 630
} 
#endif
# 633 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 634
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 638
exit(___);}
#if 0
# 634
{ 
# 635
uint2 tmp = __surf2Dreadu2(surf, x, y, cudaBoundaryModeTrap); 
# 637
return make_int2((int)(tmp.x), (int)(tmp.y)); 
# 638
} 
#endif
# 641 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uint2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 642
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 644
exit(___);}
#if 0
# 642
{ 
# 643
return __surf2Dreadu2(surf, x, y, cudaBoundaryModeTrap); 
# 644
} 
#endif
# 647 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline int4 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 648
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 652
exit(___);}
#if 0
# 648
{ 
# 649
uint4 tmp = __surf2Dreadu4(surf, x, y, cudaBoundaryModeTrap); 
# 651
return make_int4((int)(tmp.x), (int)(tmp.y), (int)(tmp.z), (int)(tmp.w)); 
# 652
} 
#endif
# 655 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline uint4 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 656
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 658
exit(___);}
#if 0
# 656
{ 
# 657
return __surf2Dreadu4(surf, x, y, cudaBoundaryModeTrap); 
# 658
} 
#endif
# 661 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline long long surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 662
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 664
exit(___);}
#if 0
# 662
{ 
# 663
return (long long)(__surf2Dreadl1(surf, x, y, cudaBoundaryModeTrap).x); 
# 664
} 
#endif
# 667 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline unsigned long long surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 668
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 670
exit(___);}
#if 0
# 668
{ 
# 669
return __surf2Dreadl1(surf, x, y, cudaBoundaryModeTrap).x; 
# 670
} 
#endif
# 673 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline longlong1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 674
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 676
exit(___);}
#if 0
# 674
{ 
# 675
return make_longlong1((long long)(__surf2Dreadl1(surf, x, y, cudaBoundaryModeTrap).x)); 
# 676
} 
#endif
# 679 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ulonglong1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 680
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 682
exit(___);}
#if 0
# 680
{ 
# 681
return __surf2Dreadl1(surf, x, y, cudaBoundaryModeTrap); 
# 682
} 
#endif
# 685 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline longlong2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 686
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 690
exit(___);}
#if 0
# 686
{ 
# 687
ulonglong2 tmp = __surf2Dreadl2(surf, x, y, cudaBoundaryModeTrap); 
# 689
return make_longlong2((long long)(tmp.x), (long long)(tmp.y)); 
# 690
} 
#endif
# 693 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline ulonglong2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 694
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 696
exit(___);}
#if 0
# 694
{ 
# 695
return __surf2Dreadl2(surf, x, y, cudaBoundaryModeTrap); 
# 696
} 
#endif
# 759 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 760
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 762
exit(___);}
#if 0
# 760
{ 
# 761
return __int_as_float((int)(__surf2Dreadu1(surf, x, y, cudaBoundaryModeTrap).x)); 
# 762
} 
#endif
# 765 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float1 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 766
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 768
exit(___);}
#if 0
# 766
{ 
# 767
return make_float1(__int_as_float((int)(__surf2Dreadu1(surf, x, y, cudaBoundaryModeTrap).x))); 
# 768
} 
#endif
# 771 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float2 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 772
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 776
exit(___);}
#if 0
# 772
{ 
# 773
uint2 tmp = __surf2Dreadu2(surf, x, y, cudaBoundaryModeTrap); 
# 775
return make_float2(__int_as_float((int)(tmp.x)), __int_as_float((int)(tmp.y))); 
# 776
} 
#endif
# 779 "/home/u0332192/local/cuda/include/surface_functions.h"
template<> __attribute__((unused)) __specialization_static inline float4 surf2Dread(surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode) 
# 780
{int volatile ___ = 1;(void)surf;(void)x;(void)y;(void)mode;
# 784
exit(___);}
#if 0
# 780
{ 
# 781
uint4 tmp = __surf2Dreadu4(surf, x, y, cudaBoundaryModeTrap); 
# 783
return make_float4(__int_as_float((int)(tmp.x)), __int_as_float((int)(tmp.y)), __int_as_float((int)(tmp.z)), __int_as_float((int)(tmp.w))); 
# 784
} 
#endif
# 831 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 832
surf1Dwrite(T val, surface< void, 1>  surf, int x, int s, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 833
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)s;(void)mode;
# 851
exit(___);}
#if 0
# 833
{ 
# 834
union { 
# 835
T val; 
# 836
uchar1 c1; 
# 837
ushort1 s1; 
# 838
uint1 u1; 
# 839
uint2 u2; 
# 840
uint4 u4; 
# 841
} tmp; 
# 843
(tmp.val) = val; 
# 845
(s == 1) ? ((void)__surf1Dwritec1(tmp.c1, surf, x, cudaBoundaryModeTrap)) : ((s == 2) ? ((void)__surf1Dwrites1(tmp.s1, surf, x, cudaBoundaryModeTrap)) : ((s == 4) ? ((void)__surf1Dwriteu1(tmp.u1, surf, x, cudaBoundaryModeTrap)) : ((s == 8) ? ((void)__surf1Dwriteu2(tmp.u2, surf, x, cudaBoundaryModeTrap)) : ((s == 16) ? ((void)__surf1Dwriteu4(tmp.u4, surf, x, cudaBoundaryModeTrap)) : ((void)0))))); 
# 851
} 
#endif
# 853 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 854
surf1Dwrite(T val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 855
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 857
exit(___);}
#if 0
# 855
{ ; 
# 856
surf1Dwrite(val, surf, x, (int)sizeof(T), mode); 
# 857
} 
#endif
# 860 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(char val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 861
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 863
exit(___);}
#if 0
# 861
{ 
# 862
__surf1Dwritec1(make_uchar1((unsigned char)val), surf, x, cudaBoundaryModeTrap); 
# 863
} 
#endif
# 865 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(signed char val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 866
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 868
exit(___);}
#if 0
# 866
{ 
# 867
__surf1Dwritec1(make_uchar1((unsigned char)val), surf, x, cudaBoundaryModeTrap); 
# 868
} 
#endif
# 870 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(unsigned char val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 871
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 873
exit(___);}
#if 0
# 871
{ 
# 872
__surf1Dwritec1(make_uchar1(val), surf, x, cudaBoundaryModeTrap); 
# 873
} 
#endif
# 875 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(char1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 876
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 878
exit(___);}
#if 0
# 876
{ 
# 877
__surf1Dwritec1(make_uchar1((unsigned char)(val.x)), surf, x, cudaBoundaryModeTrap); 
# 878
} 
#endif
# 880 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(uchar1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 881
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 883
exit(___);}
#if 0
# 881
{ 
# 882
__surf1Dwritec1(val, surf, x, cudaBoundaryModeTrap); 
# 883
} 
#endif
# 885 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(char2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 886
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 888
exit(___);}
#if 0
# 886
{ 
# 887
__surf1Dwritec2(make_uchar2((unsigned char)(val.x), (unsigned char)(val.y)), surf, x, cudaBoundaryModeTrap); 
# 888
} 
#endif
# 890 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(uchar2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 891
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 893
exit(___);}
#if 0
# 891
{ 
# 892
__surf1Dwritec2(val, surf, x, cudaBoundaryModeTrap); 
# 893
} 
#endif
# 895 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(char4 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 896
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 898
exit(___);}
#if 0
# 896
{ 
# 897
__surf1Dwritec4(make_uchar4((unsigned char)(val.x), (unsigned char)(val.y), (unsigned char)(val.z), (unsigned char)(val.w)), surf, x, cudaBoundaryModeTrap); 
# 898
} 
#endif
# 900 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(uchar4 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 901
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 903
exit(___);}
#if 0
# 901
{ 
# 902
__surf1Dwritec4(val, surf, x, cudaBoundaryModeTrap); 
# 903
} 
#endif
# 905 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(short val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 906
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 908
exit(___);}
#if 0
# 906
{ 
# 907
__surf1Dwrites1(make_ushort1((unsigned short)val), surf, x, cudaBoundaryModeTrap); 
# 908
} 
#endif
# 910 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(unsigned short val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 911
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 913
exit(___);}
#if 0
# 911
{ 
# 912
__surf1Dwrites1(make_ushort1(val), surf, x, cudaBoundaryModeTrap); 
# 913
} 
#endif
# 915 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(short1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 916
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 918
exit(___);}
#if 0
# 916
{ 
# 917
__surf1Dwrites1(make_ushort1((unsigned short)(val.x)), surf, x, cudaBoundaryModeTrap); 
# 918
} 
#endif
# 920 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(ushort1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 921
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 923
exit(___);}
#if 0
# 921
{ 
# 922
__surf1Dwrites1(val, surf, x, cudaBoundaryModeTrap); 
# 923
} 
#endif
# 925 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(short2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 926
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 928
exit(___);}
#if 0
# 926
{ 
# 927
__surf1Dwrites2(make_ushort2((unsigned short)(val.x), (unsigned short)(val.y)), surf, x, cudaBoundaryModeTrap); 
# 928
} 
#endif
# 930 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(ushort2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 931
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 933
exit(___);}
#if 0
# 931
{ 
# 932
__surf1Dwrites2(val, surf, x, cudaBoundaryModeTrap); 
# 933
} 
#endif
# 935 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(short4 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 936
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 938
exit(___);}
#if 0
# 936
{ 
# 937
__surf1Dwrites4(make_ushort4((unsigned short)(val.x), (unsigned short)(val.y), (unsigned short)(val.z), (unsigned short)(val.w)), surf, x, cudaBoundaryModeTrap); 
# 938
} 
#endif
# 940 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(ushort4 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 941
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 943
exit(___);}
#if 0
# 941
{ 
# 942
__surf1Dwrites4(val, surf, x, cudaBoundaryModeTrap); 
# 943
} 
#endif
# 945 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(int val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 946
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 948
exit(___);}
#if 0
# 946
{ 
# 947
__surf1Dwriteu1(make_uint1((unsigned)val), surf, x, cudaBoundaryModeTrap); 
# 948
} 
#endif
# 950 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(unsigned val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 951
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 953
exit(___);}
#if 0
# 951
{ 
# 952
__surf1Dwriteu1(make_uint1(val), surf, x, cudaBoundaryModeTrap); 
# 953
} 
#endif
# 955 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(int1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 956
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 958
exit(___);}
#if 0
# 956
{ 
# 957
__surf1Dwriteu1(make_uint1((unsigned)(val.x)), surf, x, cudaBoundaryModeTrap); 
# 958
} 
#endif
# 960 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(uint1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 961
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 963
exit(___);}
#if 0
# 961
{ 
# 962
__surf1Dwriteu1(val, surf, x, cudaBoundaryModeTrap); 
# 963
} 
#endif
# 965 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(int2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 966
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 968
exit(___);}
#if 0
# 966
{ 
# 967
__surf1Dwriteu2(make_uint2((unsigned)(val.x), (unsigned)(val.y)), surf, x, cudaBoundaryModeTrap); 
# 968
} 
#endif
# 970 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(uint2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 971
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 973
exit(___);}
#if 0
# 971
{ 
# 972
__surf1Dwriteu2(val, surf, x, cudaBoundaryModeTrap); 
# 973
} 
#endif
# 975 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(int4 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 976
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 978
exit(___);}
#if 0
# 976
{ 
# 977
__surf1Dwriteu4(make_uint4((unsigned)(val.x), (unsigned)(val.y), (unsigned)(val.z), (unsigned)(val.w)), surf, x, cudaBoundaryModeTrap); 
# 978
} 
#endif
# 980 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(uint4 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 981
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 983
exit(___);}
#if 0
# 981
{ 
# 982
__surf1Dwriteu4(val, surf, x, cudaBoundaryModeTrap); 
# 983
} 
#endif
# 985 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(long long val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 986
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 988
exit(___);}
#if 0
# 986
{ 
# 987
__surf1Dwritel1(make_ulonglong1((unsigned long long)val), surf, x, cudaBoundaryModeTrap); 
# 988
} 
#endif
# 990 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(unsigned long long val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 991
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 993
exit(___);}
#if 0
# 991
{ 
# 992
__surf1Dwritel1(make_ulonglong1(val), surf, x, cudaBoundaryModeTrap); 
# 993
} 
#endif
# 995 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(longlong1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 996
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 998
exit(___);}
#if 0
# 996
{ 
# 997
__surf1Dwritel1(make_ulonglong1((unsigned long long)(val.x)), surf, x, cudaBoundaryModeTrap); 
# 998
} 
#endif
# 1000 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(ulonglong1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1001
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 1003
exit(___);}
#if 0
# 1001
{ 
# 1002
__surf1Dwritel1(val, surf, x, cudaBoundaryModeTrap); 
# 1003
} 
#endif
# 1005 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(longlong2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1006
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 1008
exit(___);}
#if 0
# 1006
{ 
# 1007
__surf1Dwritel2(make_ulonglong2((unsigned long long)(val.x), (unsigned long long)(val.y)), surf, x, cudaBoundaryModeTrap); 
# 1008
} 
#endif
# 1010 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(ulonglong2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1011
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 1013
exit(___);}
#if 0
# 1011
{ 
# 1012
__surf1Dwritel2(val, surf, x, cudaBoundaryModeTrap); 
# 1013
} 
#endif
# 1059 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(float val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1060
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 1062
exit(___);}
#if 0
# 1060
{ 
# 1061
__surf1Dwriteu1(make_uint1((unsigned)__float_as_int(val)), surf, x, cudaBoundaryModeTrap); 
# 1062
} 
#endif
# 1064 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(float1 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1065
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 1067
exit(___);}
#if 0
# 1065
{ 
# 1066
__surf1Dwriteu1(make_uint1((unsigned)__float_as_int(val.x)), surf, x, cudaBoundaryModeTrap); 
# 1067
} 
#endif
# 1069 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(float2 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1070
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 1072
exit(___);}
#if 0
# 1070
{ 
# 1071
__surf1Dwriteu2(make_uint2((unsigned)__float_as_int(val.x), __float_as_int((unsigned)(val.y))), surf, x, cudaBoundaryModeTrap); 
# 1072
} 
#endif
# 1074 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf1Dwrite(float4 val, surface< void, 1>  surf, int x, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1075
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)mode;
# 1077
exit(___);}
#if 0
# 1075
{ 
# 1076
__surf1Dwriteu4(make_uint4((unsigned)__float_as_int(val.x), (unsigned)__float_as_int(val.y), (unsigned)__float_as_int(val.z), (unsigned)__float_as_int(val.w)), surf, x, cudaBoundaryModeTrap); 
# 1077
} 
#endif
# 1124 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 1125
surf2Dwrite(T val, surface< void, 2>  surf, int x, int y, int s, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1126
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)s;(void)mode;
# 1144
exit(___);}
#if 0
# 1126
{ 
# 1127
union { 
# 1128
T val; 
# 1129
uchar1 c1; 
# 1130
ushort1 s1; 
# 1131
uint1 u1; 
# 1132
uint2 u2; 
# 1133
uint4 u4; 
# 1134
} tmp; 
# 1136
(tmp.val) = val; 
# 1138
(s == 1) ? ((void)__surf2Dwritec1(tmp.c1, surf, x, y, cudaBoundaryModeTrap)) : ((s == 2) ? ((void)__surf2Dwrites1(tmp.s1, surf, x, y, cudaBoundaryModeTrap)) : ((s == 4) ? ((void)__surf2Dwriteu1(tmp.u1, surf, x, y, cudaBoundaryModeTrap)) : ((s == 8) ? ((void)__surf2Dwriteu2(tmp.u2, surf, x, y, cudaBoundaryModeTrap)) : ((s == 16) ? ((void)__surf2Dwriteu4(tmp.u4, surf, x, y, cudaBoundaryModeTrap)) : ((void)0))))); 
# 1144
} 
#endif
# 1146 "/home/u0332192/local/cuda/include/surface_functions.h"
template< class T> __attribute__((unused)) static inline void 
# 1147
surf2Dwrite(T val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1148
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1150
exit(___);}
#if 0
# 1148
{ ; 
# 1149
surf2Dwrite(val, surf, x, y, (int)sizeof(T), mode); 
# 1150
} 
#endif
# 1153 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(char val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1154
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1156
exit(___);}
#if 0
# 1154
{ 
# 1155
__surf2Dwritec1(make_uchar1((unsigned char)val), surf, x, y, cudaBoundaryModeTrap); 
# 1156
} 
#endif
# 1158 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(signed char val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1159
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1161
exit(___);}
#if 0
# 1159
{ 
# 1160
__surf2Dwritec1(make_uchar1((unsigned char)val), surf, x, y, cudaBoundaryModeTrap); 
# 1161
} 
#endif
# 1163 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(unsigned char val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1164
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1166
exit(___);}
#if 0
# 1164
{ 
# 1165
__surf2Dwritec1(make_uchar1(val), surf, x, y, cudaBoundaryModeTrap); 
# 1166
} 
#endif
# 1168 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(char1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1169
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1171
exit(___);}
#if 0
# 1169
{ 
# 1170
__surf2Dwritec1(make_uchar1((unsigned char)(val.x)), surf, x, y, cudaBoundaryModeTrap); 
# 1171
} 
#endif
# 1173 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(uchar1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1174
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1176
exit(___);}
#if 0
# 1174
{ 
# 1175
__surf2Dwritec1(val, surf, x, y, cudaBoundaryModeTrap); 
# 1176
} 
#endif
# 1178 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(char2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1179
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1181
exit(___);}
#if 0
# 1179
{ 
# 1180
__surf2Dwritec2(make_uchar2((unsigned char)(val.x), (unsigned char)(val.y)), surf, x, y, cudaBoundaryModeTrap); 
# 1181
} 
#endif
# 1183 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(uchar2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1184
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1186
exit(___);}
#if 0
# 1184
{ 
# 1185
__surf2Dwritec2(val, surf, x, y, cudaBoundaryModeTrap); 
# 1186
} 
#endif
# 1188 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(char4 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1189
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1191
exit(___);}
#if 0
# 1189
{ 
# 1190
__surf2Dwritec4(make_uchar4((unsigned char)(val.x), (unsigned char)(val.y), (unsigned char)(val.z), (unsigned char)(val.w)), surf, x, y, cudaBoundaryModeTrap); 
# 1191
} 
#endif
# 1193 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(uchar4 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1194
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1196
exit(___);}
#if 0
# 1194
{ 
# 1195
__surf2Dwritec4(val, surf, x, y, cudaBoundaryModeTrap); 
# 1196
} 
#endif
# 1198 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(short val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1199
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1201
exit(___);}
#if 0
# 1199
{ 
# 1200
__surf2Dwrites1(make_ushort1((unsigned short)val), surf, x, y, cudaBoundaryModeTrap); 
# 1201
} 
#endif
# 1203 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(unsigned short val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1204
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1206
exit(___);}
#if 0
# 1204
{ 
# 1205
__surf2Dwrites1(make_ushort1(val), surf, x, y, cudaBoundaryModeTrap); 
# 1206
} 
#endif
# 1208 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(short1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1209
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1211
exit(___);}
#if 0
# 1209
{ 
# 1210
__surf2Dwrites1(make_ushort1((unsigned short)(val.x)), surf, x, y, cudaBoundaryModeTrap); 
# 1211
} 
#endif
# 1213 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(ushort1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1214
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1216
exit(___);}
#if 0
# 1214
{ 
# 1215
__surf2Dwrites1(val, surf, x, y, cudaBoundaryModeTrap); 
# 1216
} 
#endif
# 1218 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(short2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1219
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1221
exit(___);}
#if 0
# 1219
{ 
# 1220
__surf2Dwrites2(make_ushort2((unsigned short)(val.x), (unsigned short)(val.y)), surf, x, y, cudaBoundaryModeTrap); 
# 1221
} 
#endif
# 1223 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(ushort2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1224
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1226
exit(___);}
#if 0
# 1224
{ 
# 1225
__surf2Dwrites2(val, surf, x, y, cudaBoundaryModeTrap); 
# 1226
} 
#endif
# 1228 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(short4 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1229
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1231
exit(___);}
#if 0
# 1229
{ 
# 1230
__surf2Dwrites4(make_ushort4((unsigned short)(val.x), (unsigned short)(val.y), (unsigned short)(val.z), (unsigned short)(val.w)), surf, x, y, cudaBoundaryModeTrap); 
# 1231
} 
#endif
# 1233 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(ushort4 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1234
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1236
exit(___);}
#if 0
# 1234
{ 
# 1235
__surf2Dwrites4(val, surf, x, y, cudaBoundaryModeTrap); 
# 1236
} 
#endif
# 1238 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(int val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1239
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1241
exit(___);}
#if 0
# 1239
{ 
# 1240
__surf2Dwriteu1(make_uint1((unsigned)val), surf, x, y, cudaBoundaryModeTrap); 
# 1241
} 
#endif
# 1243 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(unsigned val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1244
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1246
exit(___);}
#if 0
# 1244
{ 
# 1245
__surf2Dwriteu1(make_uint1(val), surf, x, y, cudaBoundaryModeTrap); 
# 1246
} 
#endif
# 1248 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(int1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1249
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1251
exit(___);}
#if 0
# 1249
{ 
# 1250
__surf2Dwriteu1(make_uint1((unsigned)(val.x)), surf, x, y, cudaBoundaryModeTrap); 
# 1251
} 
#endif
# 1253 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(uint1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1254
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1256
exit(___);}
#if 0
# 1254
{ 
# 1255
__surf2Dwriteu1(val, surf, x, y, cudaBoundaryModeTrap); 
# 1256
} 
#endif
# 1258 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(int2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1259
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1261
exit(___);}
#if 0
# 1259
{ 
# 1260
__surf2Dwriteu2(make_uint2((unsigned)(val.x), (unsigned)(val.y)), surf, x, y, cudaBoundaryModeTrap); 
# 1261
} 
#endif
# 1263 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(uint2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1264
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1266
exit(___);}
#if 0
# 1264
{ 
# 1265
__surf2Dwriteu2(val, surf, x, y, cudaBoundaryModeTrap); 
# 1266
} 
#endif
# 1268 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(int4 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1269
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1271
exit(___);}
#if 0
# 1269
{ 
# 1270
__surf2Dwriteu4(make_uint4((unsigned)(val.x), (unsigned)(val.y), (unsigned)(val.z), (unsigned)(val.w)), surf, x, y, cudaBoundaryModeTrap); 
# 1271
} 
#endif
# 1273 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(uint4 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1274
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1276
exit(___);}
#if 0
# 1274
{ 
# 1275
__surf2Dwriteu4(val, surf, x, y, cudaBoundaryModeTrap); 
# 1276
} 
#endif
# 1278 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(long long val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1279
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1281
exit(___);}
#if 0
# 1279
{ 
# 1280
__surf2Dwritel1(make_ulonglong1((unsigned long long)val), surf, x, y, cudaBoundaryModeTrap); 
# 1281
} 
#endif
# 1283 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(unsigned long long val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1284
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1286
exit(___);}
#if 0
# 1284
{ 
# 1285
__surf2Dwritel1(make_ulonglong1(val), surf, x, y, cudaBoundaryModeTrap); 
# 1286
} 
#endif
# 1288 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(longlong1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1289
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1291
exit(___);}
#if 0
# 1289
{ 
# 1290
__surf2Dwritel1(make_ulonglong1((unsigned long long)(val.x)), surf, x, y, cudaBoundaryModeTrap); 
# 1291
} 
#endif
# 1293 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(ulonglong1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1294
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1296
exit(___);}
#if 0
# 1294
{ 
# 1295
__surf2Dwritel1(val, surf, x, y, cudaBoundaryModeTrap); 
# 1296
} 
#endif
# 1298 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(longlong2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1299
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1301
exit(___);}
#if 0
# 1299
{ 
# 1300
__surf2Dwritel2(make_ulonglong2((unsigned long long)(val.x), (unsigned long long)(val.y)), surf, x, y, cudaBoundaryModeTrap); 
# 1301
} 
#endif
# 1303 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(ulonglong2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1304
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1306
exit(___);}
#if 0
# 1304
{ 
# 1305
__surf2Dwritel2(val, surf, x, y, cudaBoundaryModeTrap); 
# 1306
} 
#endif
# 1352 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(float val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1353
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1355
exit(___);}
#if 0
# 1353
{ 
# 1354
__surf2Dwriteu1(make_uint1((unsigned)__float_as_int(val)), surf, x, y, cudaBoundaryModeTrap); 
# 1355
} 
#endif
# 1357 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(float1 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1358
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1360
exit(___);}
#if 0
# 1358
{ 
# 1359
__surf2Dwriteu1(make_uint1((unsigned)__float_as_int(val.x)), surf, x, y, cudaBoundaryModeTrap); 
# 1360
} 
#endif
# 1362 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(float2 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1363
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1365
exit(___);}
#if 0
# 1363
{ 
# 1364
__surf2Dwriteu2(make_uint2((unsigned)__float_as_int(val.x), __float_as_int((unsigned)(val.y))), surf, x, y, cudaBoundaryModeTrap); 
# 1365
} 
#endif
# 1367 "/home/u0332192/local/cuda/include/surface_functions.h"
__attribute__((unused)) static inline void surf2Dwrite(float4 val, surface< void, 2>  surf, int x, int y, cudaSurfaceBoundaryMode mode = cudaBoundaryModeTrap) 
# 1368
{int volatile ___ = 1;(void)val;(void)surf;(void)x;(void)y;(void)mode;
# 1370
exit(___);}
#if 0
# 1368
{ 
# 1369
__surf2Dwriteu4(make_uint4((unsigned)__float_as_int(val.x), (unsigned)__float_as_int(val.y), (unsigned)__float_as_int(val.z), (unsigned)__float_as_int(val.w)), surf, x, y, cudaBoundaryModeTrap); 
# 1370
} 
#endif
# 75 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
template< class T, cudaTextureReadMode readMode> __attribute__((unused)) extern uint4 __utexfetchi(texture< T, 1, readMode>  , int4 ); 
# 77
template< class T, cudaTextureReadMode readMode> __attribute__((unused)) extern int4 __itexfetchi(texture< T, 1, readMode>  , int4 ); 
# 79
template< class T, cudaTextureReadMode readMode> __attribute__((unused)) extern float4 __ftexfetchi(texture< T, 1, readMode>  , int4 ); 
# 82
template< class T, int texType, cudaTextureReadMode readMode> __attribute__((unused)) extern uint4 __utexfetch(texture< T, texType, readMode>  , float4 , int  = texType); 
# 84
template< class T, int texType, cudaTextureReadMode readMode> __attribute__((unused)) extern int4 __itexfetch(texture< T, texType, readMode>  , float4 , int  = texType); 
# 86
template< class T, int texType, cudaTextureReadMode readMode> __attribute__((unused)) extern float4 __ftexfetch(texture< T, texType, readMode>  , float4 , int  = texType); 
# 89
template< class T, int texType, cudaTextureReadMode readMode> __attribute__((unused)) extern uint4 __utexfetchl(texture< T, texType, readMode>  , float4 , int , int  = (texType & 15)); 
# 91
template< class T, int texType, cudaTextureReadMode readMode> __attribute__((unused)) extern int4 __itexfetchl(texture< T, texType, readMode>  , float4 , int , int  = (texType & 15)); 
# 93
template< class T, int texType, cudaTextureReadMode readMode> __attribute__((unused)) extern float4 __ftexfetchl(texture< T, texType, readMode>  , float4 , int , int  = (texType & 15)); 
# 101
__attribute__((unused)) static inline char tex1Dfetch(texture< char, 1, cudaReadModeElementType>  t, int x) 
# 102
{int volatile ___ = 1;(void)t;(void)x;
# 110
exit(___);}
#if 0
# 102
{ 
# 106
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 109
return (char)(v.x); 
# 110
} 
#endif
# 112 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline signed char tex1Dfetch(texture< signed char, 1, cudaReadModeElementType>  t, int x) 
# 113
{int volatile ___ = 1;(void)t;(void)x;
# 117
exit(___);}
#if 0
# 113
{ 
# 114
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 116
return (signed char)(v.x); 
# 117
} 
#endif
# 119 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned char tex1Dfetch(texture< unsigned char, 1, cudaReadModeElementType>  t, int x) 
# 120
{int volatile ___ = 1;(void)t;(void)x;
# 124
exit(___);}
#if 0
# 120
{ 
# 121
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 123
return (unsigned char)(v.x); 
# 124
} 
#endif
# 126 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char1 tex1Dfetch(texture< char1, 1, cudaReadModeElementType>  t, int x) 
# 127
{int volatile ___ = 1;(void)t;(void)x;
# 131
exit(___);}
#if 0
# 127
{ 
# 128
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 130
return make_char1(v.x); 
# 131
} 
#endif
# 133 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar1 tex1Dfetch(texture< uchar1, 1, cudaReadModeElementType>  t, int x) 
# 134
{int volatile ___ = 1;(void)t;(void)x;
# 138
exit(___);}
#if 0
# 134
{ 
# 135
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 137
return make_uchar1(v.x); 
# 138
} 
#endif
# 140 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char2 tex1Dfetch(texture< char2, 1, cudaReadModeElementType>  t, int x) 
# 141
{int volatile ___ = 1;(void)t;(void)x;
# 145
exit(___);}
#if 0
# 141
{ 
# 142
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 144
return make_char2(v.x, v.y); 
# 145
} 
#endif
# 147 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar2 tex1Dfetch(texture< uchar2, 1, cudaReadModeElementType>  t, int x) 
# 148
{int volatile ___ = 1;(void)t;(void)x;
# 152
exit(___);}
#if 0
# 148
{ 
# 149
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 151
return make_uchar2(v.x, v.y); 
# 152
} 
#endif
# 154 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char4 tex1Dfetch(texture< char4, 1, cudaReadModeElementType>  t, int x) 
# 155
{int volatile ___ = 1;(void)t;(void)x;
# 159
exit(___);}
#if 0
# 155
{ 
# 156
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 158
return make_char4(v.x, v.y, v.z, v.w); 
# 159
} 
#endif
# 161 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar4 tex1Dfetch(texture< uchar4, 1, cudaReadModeElementType>  t, int x) 
# 162
{int volatile ___ = 1;(void)t;(void)x;
# 166
exit(___);}
#if 0
# 162
{ 
# 163
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 165
return make_uchar4(v.x, v.y, v.z, v.w); 
# 166
} 
#endif
# 174 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short tex1Dfetch(texture< short, 1, cudaReadModeElementType>  t, int x) 
# 175
{int volatile ___ = 1;(void)t;(void)x;
# 179
exit(___);}
#if 0
# 175
{ 
# 176
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 178
return (short)(v.x); 
# 179
} 
#endif
# 181 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned short tex1Dfetch(texture< unsigned short, 1, cudaReadModeElementType>  t, int x) 
# 182
{int volatile ___ = 1;(void)t;(void)x;
# 186
exit(___);}
#if 0
# 182
{ 
# 183
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 185
return (unsigned short)(v.x); 
# 186
} 
#endif
# 188 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short1 tex1Dfetch(texture< short1, 1, cudaReadModeElementType>  t, int x) 
# 189
{int volatile ___ = 1;(void)t;(void)x;
# 193
exit(___);}
#if 0
# 189
{ 
# 190
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 192
return make_short1(v.x); 
# 193
} 
#endif
# 195 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort1 tex1Dfetch(texture< ushort1, 1, cudaReadModeElementType>  t, int x) 
# 196
{int volatile ___ = 1;(void)t;(void)x;
# 200
exit(___);}
#if 0
# 196
{ 
# 197
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 199
return make_ushort1(v.x); 
# 200
} 
#endif
# 202 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short2 tex1Dfetch(texture< short2, 1, cudaReadModeElementType>  t, int x) 
# 203
{int volatile ___ = 1;(void)t;(void)x;
# 207
exit(___);}
#if 0
# 203
{ 
# 204
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 206
return make_short2(v.x, v.y); 
# 207
} 
#endif
# 209 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort2 tex1Dfetch(texture< ushort2, 1, cudaReadModeElementType>  t, int x) 
# 210
{int volatile ___ = 1;(void)t;(void)x;
# 214
exit(___);}
#if 0
# 210
{ 
# 211
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 213
return make_ushort2(v.x, v.y); 
# 214
} 
#endif
# 216 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short4 tex1Dfetch(texture< short4, 1, cudaReadModeElementType>  t, int x) 
# 217
{int volatile ___ = 1;(void)t;(void)x;
# 221
exit(___);}
#if 0
# 217
{ 
# 218
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 220
return make_short4(v.x, v.y, v.z, v.w); 
# 221
} 
#endif
# 223 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort4 tex1Dfetch(texture< ushort4, 1, cudaReadModeElementType>  t, int x) 
# 224
{int volatile ___ = 1;(void)t;(void)x;
# 228
exit(___);}
#if 0
# 224
{ 
# 225
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 227
return make_ushort4(v.x, v.y, v.z, v.w); 
# 228
} 
#endif
# 236 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int tex1Dfetch(texture< int, 1, cudaReadModeElementType>  t, int x) 
# 237
{int volatile ___ = 1;(void)t;(void)x;
# 241
exit(___);}
#if 0
# 237
{ 
# 238
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 240
return (int)(v.x); 
# 241
} 
#endif
# 243 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned tex1Dfetch(texture< unsigned, 1, cudaReadModeElementType>  t, int x) 
# 244
{int volatile ___ = 1;(void)t;(void)x;
# 248
exit(___);}
#if 0
# 244
{ 
# 245
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 247
return (unsigned)(v.x); 
# 248
} 
#endif
# 250 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int1 tex1Dfetch(texture< int1, 1, cudaReadModeElementType>  t, int x) 
# 251
{int volatile ___ = 1;(void)t;(void)x;
# 255
exit(___);}
#if 0
# 251
{ 
# 252
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 254
return make_int1(v.x); 
# 255
} 
#endif
# 257 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint1 tex1Dfetch(texture< uint1, 1, cudaReadModeElementType>  t, int x) 
# 258
{int volatile ___ = 1;(void)t;(void)x;
# 262
exit(___);}
#if 0
# 258
{ 
# 259
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 261
return make_uint1(v.x); 
# 262
} 
#endif
# 264 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int2 tex1Dfetch(texture< int2, 1, cudaReadModeElementType>  t, int x) 
# 265
{int volatile ___ = 1;(void)t;(void)x;
# 269
exit(___);}
#if 0
# 265
{ 
# 266
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 268
return make_int2(v.x, v.y); 
# 269
} 
#endif
# 271 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint2 tex1Dfetch(texture< uint2, 1, cudaReadModeElementType>  t, int x) 
# 272
{int volatile ___ = 1;(void)t;(void)x;
# 276
exit(___);}
#if 0
# 272
{ 
# 273
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 275
return make_uint2(v.x, v.y); 
# 276
} 
#endif
# 278 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int4 tex1Dfetch(texture< int4, 1, cudaReadModeElementType>  t, int x) 
# 279
{int volatile ___ = 1;(void)t;(void)x;
# 283
exit(___);}
#if 0
# 279
{ 
# 280
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 282
return make_int4(v.x, v.y, v.z, v.w); 
# 283
} 
#endif
# 285 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint4 tex1Dfetch(texture< uint4, 1, cudaReadModeElementType>  t, int x) 
# 286
{int volatile ___ = 1;(void)t;(void)x;
# 290
exit(___);}
#if 0
# 286
{ 
# 287
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 289
return make_uint4(v.x, v.y, v.z, v.w); 
# 290
} 
#endif
# 364 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1Dfetch(texture< float, 1, cudaReadModeElementType>  t, int x) 
# 365
{int volatile ___ = 1;(void)t;(void)x;
# 369
exit(___);}
#if 0
# 365
{ 
# 366
float4 v = __ftexfetchi(t, make_int4(x, 0, 0, 0)); 
# 368
return v.x; 
# 369
} 
#endif
# 371 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1Dfetch(texture< float1, 1, cudaReadModeElementType>  t, int x) 
# 372
{int volatile ___ = 1;(void)t;(void)x;
# 376
exit(___);}
#if 0
# 372
{ 
# 373
float4 v = __ftexfetchi(t, make_int4(x, 0, 0, 0)); 
# 375
return make_float1(v.x); 
# 376
} 
#endif
# 378 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1Dfetch(texture< float2, 1, cudaReadModeElementType>  t, int x) 
# 379
{int volatile ___ = 1;(void)t;(void)x;
# 383
exit(___);}
#if 0
# 379
{ 
# 380
float4 v = __ftexfetchi(t, make_int4(x, 0, 0, 0)); 
# 382
return make_float2(v.x, v.y); 
# 383
} 
#endif
# 385 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1Dfetch(texture< float4, 1, cudaReadModeElementType>  t, int x) 
# 386
{int volatile ___ = 1;(void)t;(void)x;
# 390
exit(___);}
#if 0
# 386
{ 
# 387
float4 v = __ftexfetchi(t, make_int4(x, 0, 0, 0)); 
# 389
return make_float4(v.x, v.y, v.z, v.w); 
# 390
} 
#endif
# 398 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1Dfetch(texture< char, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 399
{int volatile ___ = 1;(void)t;(void)x;
# 408
exit(___);}
#if 0
# 399
{ 
# 403
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 405
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 407
return w.x; 
# 408
} 
#endif
# 410 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1Dfetch(texture< signed char, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 411
{int volatile ___ = 1;(void)t;(void)x;
# 416
exit(___);}
#if 0
# 411
{ 
# 412
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 413
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 415
return w.x; 
# 416
} 
#endif
# 418 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1Dfetch(texture< unsigned char, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 419
{int volatile ___ = 1;(void)t;(void)x;
# 424
exit(___);}
#if 0
# 419
{ 
# 420
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 421
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 423
return w.x; 
# 424
} 
#endif
# 426 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1Dfetch(texture< char1, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 427
{int volatile ___ = 1;(void)t;(void)x;
# 432
exit(___);}
#if 0
# 427
{ 
# 428
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 429
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 431
return make_float1(w.x); 
# 432
} 
#endif
# 434 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1Dfetch(texture< uchar1, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 435
{int volatile ___ = 1;(void)t;(void)x;
# 440
exit(___);}
#if 0
# 435
{ 
# 436
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 437
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 439
return make_float1(w.x); 
# 440
} 
#endif
# 442 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1Dfetch(texture< char2, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 443
{int volatile ___ = 1;(void)t;(void)x;
# 448
exit(___);}
#if 0
# 443
{ 
# 444
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 445
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 447
return make_float2(w.x, w.y); 
# 448
} 
#endif
# 450 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1Dfetch(texture< uchar2, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 451
{int volatile ___ = 1;(void)t;(void)x;
# 456
exit(___);}
#if 0
# 451
{ 
# 452
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 453
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 455
return make_float2(w.x, w.y); 
# 456
} 
#endif
# 458 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1Dfetch(texture< char4, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 459
{int volatile ___ = 1;(void)t;(void)x;
# 464
exit(___);}
#if 0
# 459
{ 
# 460
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 461
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 463
return make_float4(w.x, w.y, w.z, w.w); 
# 464
} 
#endif
# 466 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1Dfetch(texture< uchar4, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 467
{int volatile ___ = 1;(void)t;(void)x;
# 472
exit(___);}
#if 0
# 467
{ 
# 468
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 469
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 471
return make_float4(w.x, w.y, w.z, w.w); 
# 472
} 
#endif
# 480 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1Dfetch(texture< short, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 481
{int volatile ___ = 1;(void)t;(void)x;
# 486
exit(___);}
#if 0
# 481
{ 
# 482
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 483
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 485
return w.x; 
# 486
} 
#endif
# 488 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1Dfetch(texture< unsigned short, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 489
{int volatile ___ = 1;(void)t;(void)x;
# 494
exit(___);}
#if 0
# 489
{ 
# 490
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 491
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 493
return w.x; 
# 494
} 
#endif
# 496 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1Dfetch(texture< short1, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 497
{int volatile ___ = 1;(void)t;(void)x;
# 502
exit(___);}
#if 0
# 497
{ 
# 498
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 499
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 501
return make_float1(w.x); 
# 502
} 
#endif
# 504 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1Dfetch(texture< ushort1, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 505
{int volatile ___ = 1;(void)t;(void)x;
# 510
exit(___);}
#if 0
# 505
{ 
# 506
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 507
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 509
return make_float1(w.x); 
# 510
} 
#endif
# 512 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1Dfetch(texture< short2, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 513
{int volatile ___ = 1;(void)t;(void)x;
# 518
exit(___);}
#if 0
# 513
{ 
# 514
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 515
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 517
return make_float2(w.x, w.y); 
# 518
} 
#endif
# 520 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1Dfetch(texture< ushort2, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 521
{int volatile ___ = 1;(void)t;(void)x;
# 526
exit(___);}
#if 0
# 521
{ 
# 522
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 523
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 525
return make_float2(w.x, w.y); 
# 526
} 
#endif
# 528 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1Dfetch(texture< short4, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 529
{int volatile ___ = 1;(void)t;(void)x;
# 534
exit(___);}
#if 0
# 529
{ 
# 530
int4 v = __itexfetchi(t, make_int4(x, 0, 0, 0)); 
# 531
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 533
return make_float4(w.x, w.y, w.z, w.w); 
# 534
} 
#endif
# 536 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1Dfetch(texture< ushort4, 1, cudaReadModeNormalizedFloat>  t, int x) 
# 537
{int volatile ___ = 1;(void)t;(void)x;
# 542
exit(___);}
#if 0
# 537
{ 
# 538
uint4 v = __utexfetchi(t, make_int4(x, 0, 0, 0)); 
# 539
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 541
return make_float4(w.x, w.y, w.z, w.w); 
# 542
} 
#endif
# 550 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char tex1D(texture< char, 1, cudaReadModeElementType>  t, float x) 
# 551
{int volatile ___ = 1;(void)t;(void)x;
# 559
exit(___);}
#if 0
# 551
{ 
# 555
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 558
return (char)(v.x); 
# 559
} 
#endif
# 561 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline signed char tex1D(texture< signed char, 1, cudaReadModeElementType>  t, float x) 
# 562
{int volatile ___ = 1;(void)t;(void)x;
# 566
exit(___);}
#if 0
# 562
{ 
# 563
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 565
return (signed char)(v.x); 
# 566
} 
#endif
# 568 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned char tex1D(texture< unsigned char, 1, cudaReadModeElementType>  t, float x) 
# 569
{int volatile ___ = 1;(void)t;(void)x;
# 573
exit(___);}
#if 0
# 569
{ 
# 570
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 572
return (unsigned char)(v.x); 
# 573
} 
#endif
# 575 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char1 tex1D(texture< char1, 1, cudaReadModeElementType>  t, float x) 
# 576
{int volatile ___ = 1;(void)t;(void)x;
# 580
exit(___);}
#if 0
# 576
{ 
# 577
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 579
return make_char1(v.x); 
# 580
} 
#endif
# 582 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar1 tex1D(texture< uchar1, 1, cudaReadModeElementType>  t, float x) 
# 583
{int volatile ___ = 1;(void)t;(void)x;
# 587
exit(___);}
#if 0
# 583
{ 
# 584
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 586
return make_uchar1(v.x); 
# 587
} 
#endif
# 589 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char2 tex1D(texture< char2, 1, cudaReadModeElementType>  t, float x) 
# 590
{int volatile ___ = 1;(void)t;(void)x;
# 594
exit(___);}
#if 0
# 590
{ 
# 591
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 593
return make_char2(v.x, v.y); 
# 594
} 
#endif
# 596 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar2 tex1D(texture< uchar2, 1, cudaReadModeElementType>  t, float x) 
# 597
{int volatile ___ = 1;(void)t;(void)x;
# 601
exit(___);}
#if 0
# 597
{ 
# 598
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 600
return make_uchar2(v.x, v.y); 
# 601
} 
#endif
# 603 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char4 tex1D(texture< char4, 1, cudaReadModeElementType>  t, float x) 
# 604
{int volatile ___ = 1;(void)t;(void)x;
# 608
exit(___);}
#if 0
# 604
{ 
# 605
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 607
return make_char4(v.x, v.y, v.z, v.w); 
# 608
} 
#endif
# 610 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar4 tex1D(texture< uchar4, 1, cudaReadModeElementType>  t, float x) 
# 611
{int volatile ___ = 1;(void)t;(void)x;
# 615
exit(___);}
#if 0
# 611
{ 
# 612
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 614
return make_uchar4(v.x, v.y, v.z, v.w); 
# 615
} 
#endif
# 623 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short tex1D(texture< short, 1, cudaReadModeElementType>  t, float x) 
# 624
{int volatile ___ = 1;(void)t;(void)x;
# 628
exit(___);}
#if 0
# 624
{ 
# 625
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 627
return (short)(v.x); 
# 628
} 
#endif
# 630 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned short tex1D(texture< unsigned short, 1, cudaReadModeElementType>  t, float x) 
# 631
{int volatile ___ = 1;(void)t;(void)x;
# 635
exit(___);}
#if 0
# 631
{ 
# 632
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 634
return (unsigned short)(v.x); 
# 635
} 
#endif
# 637 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short1 tex1D(texture< short1, 1, cudaReadModeElementType>  t, float x) 
# 638
{int volatile ___ = 1;(void)t;(void)x;
# 642
exit(___);}
#if 0
# 638
{ 
# 639
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 641
return make_short1(v.x); 
# 642
} 
#endif
# 644 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort1 tex1D(texture< ushort1, 1, cudaReadModeElementType>  t, float x) 
# 645
{int volatile ___ = 1;(void)t;(void)x;
# 649
exit(___);}
#if 0
# 645
{ 
# 646
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 648
return make_ushort1(v.x); 
# 649
} 
#endif
# 651 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short2 tex1D(texture< short2, 1, cudaReadModeElementType>  t, float x) 
# 652
{int volatile ___ = 1;(void)t;(void)x;
# 656
exit(___);}
#if 0
# 652
{ 
# 653
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 655
return make_short2(v.x, v.y); 
# 656
} 
#endif
# 658 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort2 tex1D(texture< ushort2, 1, cudaReadModeElementType>  t, float x) 
# 659
{int volatile ___ = 1;(void)t;(void)x;
# 663
exit(___);}
#if 0
# 659
{ 
# 660
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 662
return make_ushort2(v.x, v.y); 
# 663
} 
#endif
# 665 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short4 tex1D(texture< short4, 1, cudaReadModeElementType>  t, float x) 
# 666
{int volatile ___ = 1;(void)t;(void)x;
# 670
exit(___);}
#if 0
# 666
{ 
# 667
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 669
return make_short4(v.x, v.y, v.z, v.w); 
# 670
} 
#endif
# 672 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort4 tex1D(texture< ushort4, 1, cudaReadModeElementType>  t, float x) 
# 673
{int volatile ___ = 1;(void)t;(void)x;
# 677
exit(___);}
#if 0
# 673
{ 
# 674
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 676
return make_ushort4(v.x, v.y, v.z, v.w); 
# 677
} 
#endif
# 685 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int tex1D(texture< int, 1, cudaReadModeElementType>  t, float x) 
# 686
{int volatile ___ = 1;(void)t;(void)x;
# 690
exit(___);}
#if 0
# 686
{ 
# 687
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 689
return (int)(v.x); 
# 690
} 
#endif
# 692 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned tex1D(texture< unsigned, 1, cudaReadModeElementType>  t, float x) 
# 693
{int volatile ___ = 1;(void)t;(void)x;
# 697
exit(___);}
#if 0
# 693
{ 
# 694
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 696
return (unsigned)(v.x); 
# 697
} 
#endif
# 699 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int1 tex1D(texture< int1, 1, cudaReadModeElementType>  t, float x) 
# 700
{int volatile ___ = 1;(void)t;(void)x;
# 704
exit(___);}
#if 0
# 700
{ 
# 701
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 703
return make_int1(v.x); 
# 704
} 
#endif
# 706 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint1 tex1D(texture< uint1, 1, cudaReadModeElementType>  t, float x) 
# 707
{int volatile ___ = 1;(void)t;(void)x;
# 711
exit(___);}
#if 0
# 707
{ 
# 708
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 710
return make_uint1(v.x); 
# 711
} 
#endif
# 713 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int2 tex1D(texture< int2, 1, cudaReadModeElementType>  t, float x) 
# 714
{int volatile ___ = 1;(void)t;(void)x;
# 718
exit(___);}
#if 0
# 714
{ 
# 715
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 717
return make_int2(v.x, v.y); 
# 718
} 
#endif
# 720 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint2 tex1D(texture< uint2, 1, cudaReadModeElementType>  t, float x) 
# 721
{int volatile ___ = 1;(void)t;(void)x;
# 725
exit(___);}
#if 0
# 721
{ 
# 722
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 724
return make_uint2(v.x, v.y); 
# 725
} 
#endif
# 727 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int4 tex1D(texture< int4, 1, cudaReadModeElementType>  t, float x) 
# 728
{int volatile ___ = 1;(void)t;(void)x;
# 732
exit(___);}
#if 0
# 728
{ 
# 729
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 731
return make_int4(v.x, v.y, v.z, v.w); 
# 732
} 
#endif
# 734 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint4 tex1D(texture< uint4, 1, cudaReadModeElementType>  t, float x) 
# 735
{int volatile ___ = 1;(void)t;(void)x;
# 739
exit(___);}
#if 0
# 735
{ 
# 736
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 738
return make_uint4(v.x, v.y, v.z, v.w); 
# 739
} 
#endif
# 819 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1D(texture< float, 1, cudaReadModeElementType>  t, float x) 
# 820
{int volatile ___ = 1;(void)t;(void)x;
# 824
exit(___);}
#if 0
# 820
{ 
# 821
float4 v = __ftexfetch(t, make_float4(x, 0, 0, 0)); 
# 823
return v.x; 
# 824
} 
#endif
# 826 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1D(texture< float1, 1, cudaReadModeElementType>  t, float x) 
# 827
{int volatile ___ = 1;(void)t;(void)x;
# 831
exit(___);}
#if 0
# 827
{ 
# 828
float4 v = __ftexfetch(t, make_float4(x, 0, 0, 0)); 
# 830
return make_float1(v.x); 
# 831
} 
#endif
# 833 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1D(texture< float2, 1, cudaReadModeElementType>  t, float x) 
# 834
{int volatile ___ = 1;(void)t;(void)x;
# 838
exit(___);}
#if 0
# 834
{ 
# 835
float4 v = __ftexfetch(t, make_float4(x, 0, 0, 0)); 
# 837
return make_float2(v.x, v.y); 
# 838
} 
#endif
# 840 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1D(texture< float4, 1, cudaReadModeElementType>  t, float x) 
# 841
{int volatile ___ = 1;(void)t;(void)x;
# 845
exit(___);}
#if 0
# 841
{ 
# 842
float4 v = __ftexfetch(t, make_float4(x, 0, 0, 0)); 
# 844
return make_float4(v.x, v.y, v.z, v.w); 
# 845
} 
#endif
# 853 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1D(texture< char, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 854
{int volatile ___ = 1;(void)t;(void)x;
# 863
exit(___);}
#if 0
# 854
{ 
# 858
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 860
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 862
return w.x; 
# 863
} 
#endif
# 865 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1D(texture< signed char, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 866
{int volatile ___ = 1;(void)t;(void)x;
# 871
exit(___);}
#if 0
# 866
{ 
# 867
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 868
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 870
return w.x; 
# 871
} 
#endif
# 873 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1D(texture< unsigned char, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 874
{int volatile ___ = 1;(void)t;(void)x;
# 879
exit(___);}
#if 0
# 874
{ 
# 875
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 876
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 878
return w.x; 
# 879
} 
#endif
# 881 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1D(texture< char1, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 882
{int volatile ___ = 1;(void)t;(void)x;
# 887
exit(___);}
#if 0
# 882
{ 
# 883
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 884
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 886
return make_float1(w.x); 
# 887
} 
#endif
# 889 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1D(texture< uchar1, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 890
{int volatile ___ = 1;(void)t;(void)x;
# 895
exit(___);}
#if 0
# 890
{ 
# 891
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 892
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 894
return make_float1(w.x); 
# 895
} 
#endif
# 897 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1D(texture< char2, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 898
{int volatile ___ = 1;(void)t;(void)x;
# 903
exit(___);}
#if 0
# 898
{ 
# 899
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 900
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 902
return make_float2(w.x, w.y); 
# 903
} 
#endif
# 905 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1D(texture< uchar2, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 906
{int volatile ___ = 1;(void)t;(void)x;
# 911
exit(___);}
#if 0
# 906
{ 
# 907
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 908
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 910
return make_float2(w.x, w.y); 
# 911
} 
#endif
# 913 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1D(texture< char4, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 914
{int volatile ___ = 1;(void)t;(void)x;
# 919
exit(___);}
#if 0
# 914
{ 
# 915
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 916
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 918
return make_float4(w.x, w.y, w.z, w.w); 
# 919
} 
#endif
# 921 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1D(texture< uchar4, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 922
{int volatile ___ = 1;(void)t;(void)x;
# 927
exit(___);}
#if 0
# 922
{ 
# 923
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 924
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 926
return make_float4(w.x, w.y, w.z, w.w); 
# 927
} 
#endif
# 935 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1D(texture< short, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 936
{int volatile ___ = 1;(void)t;(void)x;
# 941
exit(___);}
#if 0
# 936
{ 
# 937
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 938
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 940
return w.x; 
# 941
} 
#endif
# 943 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1D(texture< unsigned short, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 944
{int volatile ___ = 1;(void)t;(void)x;
# 949
exit(___);}
#if 0
# 944
{ 
# 945
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 946
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 948
return w.x; 
# 949
} 
#endif
# 951 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1D(texture< short1, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 952
{int volatile ___ = 1;(void)t;(void)x;
# 957
exit(___);}
#if 0
# 952
{ 
# 953
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 954
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 956
return make_float1(w.x); 
# 957
} 
#endif
# 959 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1D(texture< ushort1, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 960
{int volatile ___ = 1;(void)t;(void)x;
# 965
exit(___);}
#if 0
# 960
{ 
# 961
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 962
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 964
return make_float1(w.x); 
# 965
} 
#endif
# 967 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1D(texture< short2, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 968
{int volatile ___ = 1;(void)t;(void)x;
# 973
exit(___);}
#if 0
# 968
{ 
# 969
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 970
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 972
return make_float2(w.x, w.y); 
# 973
} 
#endif
# 975 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1D(texture< ushort2, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 976
{int volatile ___ = 1;(void)t;(void)x;
# 981
exit(___);}
#if 0
# 976
{ 
# 977
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 978
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 980
return make_float2(w.x, w.y); 
# 981
} 
#endif
# 983 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1D(texture< short4, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 984
{int volatile ___ = 1;(void)t;(void)x;
# 989
exit(___);}
#if 0
# 984
{ 
# 985
int4 v = __itexfetch(t, make_float4(x, 0, 0, 0)); 
# 986
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 988
return make_float4(w.x, w.y, w.z, w.w); 
# 989
} 
#endif
# 991 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1D(texture< ushort4, 1, cudaReadModeNormalizedFloat>  t, float x) 
# 992
{int volatile ___ = 1;(void)t;(void)x;
# 997
exit(___);}
#if 0
# 992
{ 
# 993
uint4 v = __utexfetch(t, make_float4(x, 0, 0, 0)); 
# 994
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 996
return make_float4(w.x, w.y, w.z, w.w); 
# 997
} 
#endif
# 1005 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char tex2D(texture< char, 2, cudaReadModeElementType>  t, float x, float y) 
# 1006
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1014
exit(___);}
#if 0
# 1006
{ 
# 1010
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1013
return (char)(v.x); 
# 1014
} 
#endif
# 1016 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline signed char tex2D(texture< signed char, 2, cudaReadModeElementType>  t, float x, float y) 
# 1017
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1021
exit(___);}
#if 0
# 1017
{ 
# 1018
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1020
return (signed char)(v.x); 
# 1021
} 
#endif
# 1023 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned char tex2D(texture< unsigned char, 2, cudaReadModeElementType>  t, float x, float y) 
# 1024
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1028
exit(___);}
#if 0
# 1024
{ 
# 1025
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1027
return (unsigned char)(v.x); 
# 1028
} 
#endif
# 1030 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char1 tex2D(texture< char1, 2, cudaReadModeElementType>  t, float x, float y) 
# 1031
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1035
exit(___);}
#if 0
# 1031
{ 
# 1032
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1034
return make_char1(v.x); 
# 1035
} 
#endif
# 1037 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar1 tex2D(texture< uchar1, 2, cudaReadModeElementType>  t, float x, float y) 
# 1038
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1042
exit(___);}
#if 0
# 1038
{ 
# 1039
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1041
return make_uchar1(v.x); 
# 1042
} 
#endif
# 1044 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char2 tex2D(texture< char2, 2, cudaReadModeElementType>  t, float x, float y) 
# 1045
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1049
exit(___);}
#if 0
# 1045
{ 
# 1046
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1048
return make_char2(v.x, v.y); 
# 1049
} 
#endif
# 1051 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar2 tex2D(texture< uchar2, 2, cudaReadModeElementType>  t, float x, float y) 
# 1052
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1056
exit(___);}
#if 0
# 1052
{ 
# 1053
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1055
return make_uchar2(v.x, v.y); 
# 1056
} 
#endif
# 1058 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char4 tex2D(texture< char4, 2, cudaReadModeElementType>  t, float x, float y) 
# 1059
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1063
exit(___);}
#if 0
# 1059
{ 
# 1060
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1062
return make_char4(v.x, v.y, v.z, v.w); 
# 1063
} 
#endif
# 1065 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar4 tex2D(texture< uchar4, 2, cudaReadModeElementType>  t, float x, float y) 
# 1066
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1070
exit(___);}
#if 0
# 1066
{ 
# 1067
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1069
return make_uchar4(v.x, v.y, v.z, v.w); 
# 1070
} 
#endif
# 1078 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short tex2D(texture< short, 2, cudaReadModeElementType>  t, float x, float y) 
# 1079
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1083
exit(___);}
#if 0
# 1079
{ 
# 1080
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1082
return (short)(v.x); 
# 1083
} 
#endif
# 1085 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned short tex2D(texture< unsigned short, 2, cudaReadModeElementType>  t, float x, float y) 
# 1086
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1090
exit(___);}
#if 0
# 1086
{ 
# 1087
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1089
return (unsigned short)(v.x); 
# 1090
} 
#endif
# 1092 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short1 tex2D(texture< short1, 2, cudaReadModeElementType>  t, float x, float y) 
# 1093
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1097
exit(___);}
#if 0
# 1093
{ 
# 1094
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1096
return make_short1(v.x); 
# 1097
} 
#endif
# 1099 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort1 tex2D(texture< ushort1, 2, cudaReadModeElementType>  t, float x, float y) 
# 1100
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1104
exit(___);}
#if 0
# 1100
{ 
# 1101
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1103
return make_ushort1(v.x); 
# 1104
} 
#endif
# 1106 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short2 tex2D(texture< short2, 2, cudaReadModeElementType>  t, float x, float y) 
# 1107
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1111
exit(___);}
#if 0
# 1107
{ 
# 1108
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1110
return make_short2(v.x, v.y); 
# 1111
} 
#endif
# 1113 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort2 tex2D(texture< ushort2, 2, cudaReadModeElementType>  t, float x, float y) 
# 1114
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1118
exit(___);}
#if 0
# 1114
{ 
# 1115
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1117
return make_ushort2(v.x, v.y); 
# 1118
} 
#endif
# 1120 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short4 tex2D(texture< short4, 2, cudaReadModeElementType>  t, float x, float y) 
# 1121
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1125
exit(___);}
#if 0
# 1121
{ 
# 1122
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1124
return make_short4(v.x, v.y, v.z, v.w); 
# 1125
} 
#endif
# 1127 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort4 tex2D(texture< ushort4, 2, cudaReadModeElementType>  t, float x, float y) 
# 1128
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1132
exit(___);}
#if 0
# 1128
{ 
# 1129
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1131
return make_ushort4(v.x, v.y, v.z, v.w); 
# 1132
} 
#endif
# 1140 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int tex2D(texture< int, 2, cudaReadModeElementType>  t, float x, float y) 
# 1141
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1145
exit(___);}
#if 0
# 1141
{ 
# 1142
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1144
return (int)(v.x); 
# 1145
} 
#endif
# 1147 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned tex2D(texture< unsigned, 2, cudaReadModeElementType>  t, float x, float y) 
# 1148
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1152
exit(___);}
#if 0
# 1148
{ 
# 1149
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1151
return (unsigned)(v.x); 
# 1152
} 
#endif
# 1154 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int1 tex2D(texture< int1, 2, cudaReadModeElementType>  t, float x, float y) 
# 1155
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1159
exit(___);}
#if 0
# 1155
{ 
# 1156
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1158
return make_int1(v.x); 
# 1159
} 
#endif
# 1161 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint1 tex2D(texture< uint1, 2, cudaReadModeElementType>  t, float x, float y) 
# 1162
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1166
exit(___);}
#if 0
# 1162
{ 
# 1163
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1165
return make_uint1(v.x); 
# 1166
} 
#endif
# 1168 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int2 tex2D(texture< int2, 2, cudaReadModeElementType>  t, float x, float y) 
# 1169
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1173
exit(___);}
#if 0
# 1169
{ 
# 1170
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1172
return make_int2(v.x, v.y); 
# 1173
} 
#endif
# 1175 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint2 tex2D(texture< uint2, 2, cudaReadModeElementType>  t, float x, float y) 
# 1176
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1180
exit(___);}
#if 0
# 1176
{ 
# 1177
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1179
return make_uint2(v.x, v.y); 
# 1180
} 
#endif
# 1182 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int4 tex2D(texture< int4, 2, cudaReadModeElementType>  t, float x, float y) 
# 1183
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1187
exit(___);}
#if 0
# 1183
{ 
# 1184
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1186
return make_int4(v.x, v.y, v.z, v.w); 
# 1187
} 
#endif
# 1189 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint4 tex2D(texture< uint4, 2, cudaReadModeElementType>  t, float x, float y) 
# 1190
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1194
exit(___);}
#if 0
# 1190
{ 
# 1191
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1193
return make_uint4(v.x, v.y, v.z, v.w); 
# 1194
} 
#endif
# 1268 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2D(texture< float, 2, cudaReadModeElementType>  t, float x, float y) 
# 1269
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1273
exit(___);}
#if 0
# 1269
{ 
# 1270
float4 v = __ftexfetch(t, make_float4(x, y, 0, 0)); 
# 1272
return v.x; 
# 1273
} 
#endif
# 1275 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2D(texture< float1, 2, cudaReadModeElementType>  t, float x, float y) 
# 1276
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1280
exit(___);}
#if 0
# 1276
{ 
# 1277
float4 v = __ftexfetch(t, make_float4(x, y, 0, 0)); 
# 1279
return make_float1(v.x); 
# 1280
} 
#endif
# 1282 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2D(texture< float2, 2, cudaReadModeElementType>  t, float x, float y) 
# 1283
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1287
exit(___);}
#if 0
# 1283
{ 
# 1284
float4 v = __ftexfetch(t, make_float4(x, y, 0, 0)); 
# 1286
return make_float2(v.x, v.y); 
# 1287
} 
#endif
# 1289 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2D(texture< float4, 2, cudaReadModeElementType>  t, float x, float y) 
# 1290
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1294
exit(___);}
#if 0
# 1290
{ 
# 1291
float4 v = __ftexfetch(t, make_float4(x, y, 0, 0)); 
# 1293
return make_float4(v.x, v.y, v.z, v.w); 
# 1294
} 
#endif
# 1302 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2D(texture< char, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1303
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1312
exit(___);}
#if 0
# 1303
{ 
# 1307
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1309
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1311
return w.x; 
# 1312
} 
#endif
# 1314 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2D(texture< signed char, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1315
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1320
exit(___);}
#if 0
# 1315
{ 
# 1316
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1317
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1319
return w.x; 
# 1320
} 
#endif
# 1322 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2D(texture< unsigned char, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1323
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1328
exit(___);}
#if 0
# 1323
{ 
# 1324
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1325
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1327
return w.x; 
# 1328
} 
#endif
# 1330 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2D(texture< char1, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1331
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1336
exit(___);}
#if 0
# 1331
{ 
# 1332
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1333
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1335
return make_float1(w.x); 
# 1336
} 
#endif
# 1338 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2D(texture< uchar1, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1339
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1344
exit(___);}
#if 0
# 1339
{ 
# 1340
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1341
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1343
return make_float1(w.x); 
# 1344
} 
#endif
# 1346 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2D(texture< char2, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1347
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1352
exit(___);}
#if 0
# 1347
{ 
# 1348
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1349
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1351
return make_float2(w.x, w.y); 
# 1352
} 
#endif
# 1354 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2D(texture< uchar2, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1355
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1360
exit(___);}
#if 0
# 1355
{ 
# 1356
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1357
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1359
return make_float2(w.x, w.y); 
# 1360
} 
#endif
# 1362 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2D(texture< char4, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1363
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1368
exit(___);}
#if 0
# 1363
{ 
# 1364
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1365
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1367
return make_float4(w.x, w.y, w.z, w.w); 
# 1368
} 
#endif
# 1370 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2D(texture< uchar4, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1371
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1376
exit(___);}
#if 0
# 1371
{ 
# 1372
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1373
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1375
return make_float4(w.x, w.y, w.z, w.w); 
# 1376
} 
#endif
# 1384 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2D(texture< short, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1385
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1390
exit(___);}
#if 0
# 1385
{ 
# 1386
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1387
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1389
return w.x; 
# 1390
} 
#endif
# 1392 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2D(texture< unsigned short, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1393
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1398
exit(___);}
#if 0
# 1393
{ 
# 1394
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1395
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1397
return w.x; 
# 1398
} 
#endif
# 1400 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2D(texture< short1, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1401
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1406
exit(___);}
#if 0
# 1401
{ 
# 1402
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1403
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1405
return make_float1(w.x); 
# 1406
} 
#endif
# 1408 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2D(texture< ushort1, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1409
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1414
exit(___);}
#if 0
# 1409
{ 
# 1410
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1411
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1413
return make_float1(w.x); 
# 1414
} 
#endif
# 1416 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2D(texture< short2, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1417
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1422
exit(___);}
#if 0
# 1417
{ 
# 1418
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1419
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1421
return make_float2(w.x, w.y); 
# 1422
} 
#endif
# 1424 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2D(texture< ushort2, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1425
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1430
exit(___);}
#if 0
# 1425
{ 
# 1426
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1427
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1429
return make_float2(w.x, w.y); 
# 1430
} 
#endif
# 1432 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2D(texture< short4, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1433
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1438
exit(___);}
#if 0
# 1433
{ 
# 1434
int4 v = __itexfetch(t, make_float4(x, y, 0, 0)); 
# 1435
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1437
return make_float4(w.x, w.y, w.z, w.w); 
# 1438
} 
#endif
# 1440 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2D(texture< ushort4, 2, cudaReadModeNormalizedFloat>  t, float x, float y) 
# 1441
{int volatile ___ = 1;(void)t;(void)x;(void)y;
# 1446
exit(___);}
#if 0
# 1441
{ 
# 1442
uint4 v = __utexfetch(t, make_float4(x, y, 0, 0)); 
# 1443
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1445
return make_float4(w.x, w.y, w.z, w.w); 
# 1446
} 
#endif
# 1454 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char tex1DLayered(texture< char, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1455
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1463
exit(___);}
#if 0
# 1455
{ 
# 1459
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1462
return (char)(v.x); 
# 1463
} 
#endif
# 1465 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline signed char tex1DLayered(texture< signed char, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1466
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1470
exit(___);}
#if 0
# 1466
{ 
# 1467
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1469
return (signed char)(v.x); 
# 1470
} 
#endif
# 1472 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned char tex1DLayered(texture< unsigned char, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1473
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1477
exit(___);}
#if 0
# 1473
{ 
# 1474
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1476
return (unsigned char)(v.x); 
# 1477
} 
#endif
# 1479 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char1 tex1DLayered(texture< char1, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1480
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1484
exit(___);}
#if 0
# 1480
{ 
# 1481
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1483
return make_char1(v.x); 
# 1484
} 
#endif
# 1486 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar1 tex1DLayered(texture< uchar1, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1487
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1491
exit(___);}
#if 0
# 1487
{ 
# 1488
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1490
return make_uchar1(v.x); 
# 1491
} 
#endif
# 1493 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char2 tex1DLayered(texture< char2, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1494
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1498
exit(___);}
#if 0
# 1494
{ 
# 1495
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1497
return make_char2(v.x, v.y); 
# 1498
} 
#endif
# 1500 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar2 tex1DLayered(texture< uchar2, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1501
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1505
exit(___);}
#if 0
# 1501
{ 
# 1502
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1504
return make_uchar2(v.x, v.y); 
# 1505
} 
#endif
# 1507 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char4 tex1DLayered(texture< char4, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1508
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1512
exit(___);}
#if 0
# 1508
{ 
# 1509
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1511
return make_char4(v.x, v.y, v.z, v.w); 
# 1512
} 
#endif
# 1514 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar4 tex1DLayered(texture< uchar4, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1515
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1519
exit(___);}
#if 0
# 1515
{ 
# 1516
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1518
return make_uchar4(v.x, v.y, v.z, v.w); 
# 1519
} 
#endif
# 1527 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short tex1DLayered(texture< short, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1528
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1532
exit(___);}
#if 0
# 1528
{ 
# 1529
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1531
return (short)(v.x); 
# 1532
} 
#endif
# 1534 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned short tex1DLayered(texture< unsigned short, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1535
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1539
exit(___);}
#if 0
# 1535
{ 
# 1536
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1538
return (unsigned short)(v.x); 
# 1539
} 
#endif
# 1541 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short1 tex1DLayered(texture< short1, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1542
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1546
exit(___);}
#if 0
# 1542
{ 
# 1543
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1545
return make_short1(v.x); 
# 1546
} 
#endif
# 1548 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort1 tex1DLayered(texture< ushort1, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1549
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1553
exit(___);}
#if 0
# 1549
{ 
# 1550
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1552
return make_ushort1(v.x); 
# 1553
} 
#endif
# 1555 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short2 tex1DLayered(texture< short2, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1556
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1560
exit(___);}
#if 0
# 1556
{ 
# 1557
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1559
return make_short2(v.x, v.y); 
# 1560
} 
#endif
# 1562 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort2 tex1DLayered(texture< ushort2, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1563
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1567
exit(___);}
#if 0
# 1563
{ 
# 1564
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1566
return make_ushort2(v.x, v.y); 
# 1567
} 
#endif
# 1569 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short4 tex1DLayered(texture< short4, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1570
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1574
exit(___);}
#if 0
# 1570
{ 
# 1571
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1573
return make_short4(v.x, v.y, v.z, v.w); 
# 1574
} 
#endif
# 1576 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort4 tex1DLayered(texture< ushort4, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1577
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1581
exit(___);}
#if 0
# 1577
{ 
# 1578
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1580
return make_ushort4(v.x, v.y, v.z, v.w); 
# 1581
} 
#endif
# 1589 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int tex1DLayered(texture< int, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1590
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1594
exit(___);}
#if 0
# 1590
{ 
# 1591
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1593
return (int)(v.x); 
# 1594
} 
#endif
# 1596 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned tex1DLayered(texture< unsigned, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1597
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1601
exit(___);}
#if 0
# 1597
{ 
# 1598
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1600
return (unsigned)(v.x); 
# 1601
} 
#endif
# 1603 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int1 tex1DLayered(texture< int1, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1604
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1608
exit(___);}
#if 0
# 1604
{ 
# 1605
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1607
return make_int1(v.x); 
# 1608
} 
#endif
# 1610 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint1 tex1DLayered(texture< uint1, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1611
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1615
exit(___);}
#if 0
# 1611
{ 
# 1612
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1614
return make_uint1(v.x); 
# 1615
} 
#endif
# 1617 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int2 tex1DLayered(texture< int2, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1618
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1622
exit(___);}
#if 0
# 1618
{ 
# 1619
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1621
return make_int2(v.x, v.y); 
# 1622
} 
#endif
# 1624 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint2 tex1DLayered(texture< uint2, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1625
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1629
exit(___);}
#if 0
# 1625
{ 
# 1626
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1628
return make_uint2(v.x, v.y); 
# 1629
} 
#endif
# 1631 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int4 tex1DLayered(texture< int4, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1632
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1636
exit(___);}
#if 0
# 1632
{ 
# 1633
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1635
return make_int4(v.x, v.y, v.z, v.w); 
# 1636
} 
#endif
# 1638 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint4 tex1DLayered(texture< uint4, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1639
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1643
exit(___);}
#if 0
# 1639
{ 
# 1640
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1642
return make_uint4(v.x, v.y, v.z, v.w); 
# 1643
} 
#endif
# 1717 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1DLayered(texture< float, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1718
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1722
exit(___);}
#if 0
# 1718
{ 
# 1719
float4 v = __ftexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1721
return v.x; 
# 1722
} 
#endif
# 1724 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1DLayered(texture< float1, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1725
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1729
exit(___);}
#if 0
# 1725
{ 
# 1726
float4 v = __ftexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1728
return make_float1(v.x); 
# 1729
} 
#endif
# 1731 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1DLayered(texture< float2, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1732
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1736
exit(___);}
#if 0
# 1732
{ 
# 1733
float4 v = __ftexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1735
return make_float2(v.x, v.y); 
# 1736
} 
#endif
# 1738 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1DLayered(texture< float4, 241, cudaReadModeElementType>  t, float x, int layer) 
# 1739
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1743
exit(___);}
#if 0
# 1739
{ 
# 1740
float4 v = __ftexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1742
return make_float4(v.x, v.y, v.z, v.w); 
# 1743
} 
#endif
# 1751 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1DLayered(texture< char, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1752
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1761
exit(___);}
#if 0
# 1752
{ 
# 1756
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1758
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1760
return w.x; 
# 1761
} 
#endif
# 1763 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1DLayered(texture< signed char, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1764
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1769
exit(___);}
#if 0
# 1764
{ 
# 1765
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1766
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1768
return w.x; 
# 1769
} 
#endif
# 1771 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1DLayered(texture< unsigned char, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1772
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1777
exit(___);}
#if 0
# 1772
{ 
# 1773
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1774
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1776
return w.x; 
# 1777
} 
#endif
# 1779 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1DLayered(texture< char1, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1780
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1785
exit(___);}
#if 0
# 1780
{ 
# 1781
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1782
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1784
return make_float1(w.x); 
# 1785
} 
#endif
# 1787 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1DLayered(texture< uchar1, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1788
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1793
exit(___);}
#if 0
# 1788
{ 
# 1789
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1790
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1792
return make_float1(w.x); 
# 1793
} 
#endif
# 1795 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1DLayered(texture< char2, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1796
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1801
exit(___);}
#if 0
# 1796
{ 
# 1797
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1798
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1800
return make_float2(w.x, w.y); 
# 1801
} 
#endif
# 1803 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1DLayered(texture< uchar2, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1804
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1809
exit(___);}
#if 0
# 1804
{ 
# 1805
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1806
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1808
return make_float2(w.x, w.y); 
# 1809
} 
#endif
# 1811 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1DLayered(texture< char4, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1812
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1817
exit(___);}
#if 0
# 1812
{ 
# 1813
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1814
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1816
return make_float4(w.x, w.y, w.z, w.w); 
# 1817
} 
#endif
# 1819 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1DLayered(texture< uchar4, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1820
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1825
exit(___);}
#if 0
# 1820
{ 
# 1821
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1822
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1824
return make_float4(w.x, w.y, w.z, w.w); 
# 1825
} 
#endif
# 1833 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1DLayered(texture< short, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1834
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1839
exit(___);}
#if 0
# 1834
{ 
# 1835
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1836
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1838
return w.x; 
# 1839
} 
#endif
# 1841 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex1DLayered(texture< unsigned short, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1842
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1847
exit(___);}
#if 0
# 1842
{ 
# 1843
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1844
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1846
return w.x; 
# 1847
} 
#endif
# 1849 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1DLayered(texture< short1, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1850
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1855
exit(___);}
#if 0
# 1850
{ 
# 1851
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1852
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1854
return make_float1(w.x); 
# 1855
} 
#endif
# 1857 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex1DLayered(texture< ushort1, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1858
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1863
exit(___);}
#if 0
# 1858
{ 
# 1859
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1860
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1862
return make_float1(w.x); 
# 1863
} 
#endif
# 1865 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1DLayered(texture< short2, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1866
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1871
exit(___);}
#if 0
# 1866
{ 
# 1867
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1868
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1870
return make_float2(w.x, w.y); 
# 1871
} 
#endif
# 1873 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex1DLayered(texture< ushort2, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1874
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1879
exit(___);}
#if 0
# 1874
{ 
# 1875
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1876
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1878
return make_float2(w.x, w.y); 
# 1879
} 
#endif
# 1881 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1DLayered(texture< short4, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1882
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1887
exit(___);}
#if 0
# 1882
{ 
# 1883
int4 v = __itexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1884
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1886
return make_float4(w.x, w.y, w.z, w.w); 
# 1887
} 
#endif
# 1889 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex1DLayered(texture< ushort4, 241, cudaReadModeNormalizedFloat>  t, float x, int layer) 
# 1890
{int volatile ___ = 1;(void)t;(void)x;(void)layer;
# 1895
exit(___);}
#if 0
# 1890
{ 
# 1891
uint4 v = __utexfetchl(t, make_float4(x, 0, 0, 0), layer); 
# 1892
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 1894
return make_float4(w.x, w.y, w.z, w.w); 
# 1895
} 
#endif
# 1903 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char tex2DLayered(texture< char, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1904
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1912
exit(___);}
#if 0
# 1904
{ 
# 1908
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1911
return (char)(v.x); 
# 1912
} 
#endif
# 1914 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline signed char tex2DLayered(texture< signed char, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1915
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1919
exit(___);}
#if 0
# 1915
{ 
# 1916
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1918
return (signed char)(v.x); 
# 1919
} 
#endif
# 1921 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned char tex2DLayered(texture< unsigned char, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1922
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1926
exit(___);}
#if 0
# 1922
{ 
# 1923
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1925
return (unsigned char)(v.x); 
# 1926
} 
#endif
# 1928 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char1 tex2DLayered(texture< char1, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1929
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1933
exit(___);}
#if 0
# 1929
{ 
# 1930
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1932
return make_char1(v.x); 
# 1933
} 
#endif
# 1935 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar1 tex2DLayered(texture< uchar1, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1936
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1940
exit(___);}
#if 0
# 1936
{ 
# 1937
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1939
return make_uchar1(v.x); 
# 1940
} 
#endif
# 1942 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char2 tex2DLayered(texture< char2, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1943
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1947
exit(___);}
#if 0
# 1943
{ 
# 1944
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1946
return make_char2(v.x, v.y); 
# 1947
} 
#endif
# 1949 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar2 tex2DLayered(texture< uchar2, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1950
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1954
exit(___);}
#if 0
# 1950
{ 
# 1951
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1953
return make_uchar2(v.x, v.y); 
# 1954
} 
#endif
# 1956 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char4 tex2DLayered(texture< char4, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1957
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1961
exit(___);}
#if 0
# 1957
{ 
# 1958
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1960
return make_char4(v.x, v.y, v.z, v.w); 
# 1961
} 
#endif
# 1963 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar4 tex2DLayered(texture< uchar4, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1964
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1968
exit(___);}
#if 0
# 1964
{ 
# 1965
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1967
return make_uchar4(v.x, v.y, v.z, v.w); 
# 1968
} 
#endif
# 1976 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short tex2DLayered(texture< short, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1977
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1981
exit(___);}
#if 0
# 1977
{ 
# 1978
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1980
return (short)(v.x); 
# 1981
} 
#endif
# 1983 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned short tex2DLayered(texture< unsigned short, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1984
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1988
exit(___);}
#if 0
# 1984
{ 
# 1985
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1987
return (unsigned short)(v.x); 
# 1988
} 
#endif
# 1990 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short1 tex2DLayered(texture< short1, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1991
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 1995
exit(___);}
#if 0
# 1991
{ 
# 1992
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 1994
return make_short1(v.x); 
# 1995
} 
#endif
# 1997 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort1 tex2DLayered(texture< ushort1, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 1998
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2002
exit(___);}
#if 0
# 1998
{ 
# 1999
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2001
return make_ushort1(v.x); 
# 2002
} 
#endif
# 2004 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short2 tex2DLayered(texture< short2, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2005
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2009
exit(___);}
#if 0
# 2005
{ 
# 2006
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2008
return make_short2(v.x, v.y); 
# 2009
} 
#endif
# 2011 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort2 tex2DLayered(texture< ushort2, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2012
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2016
exit(___);}
#if 0
# 2012
{ 
# 2013
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2015
return make_ushort2(v.x, v.y); 
# 2016
} 
#endif
# 2018 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short4 tex2DLayered(texture< short4, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2019
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2023
exit(___);}
#if 0
# 2019
{ 
# 2020
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2022
return make_short4(v.x, v.y, v.z, v.w); 
# 2023
} 
#endif
# 2025 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort4 tex2DLayered(texture< ushort4, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2026
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2030
exit(___);}
#if 0
# 2026
{ 
# 2027
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2029
return make_ushort4(v.x, v.y, v.z, v.w); 
# 2030
} 
#endif
# 2038 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int tex2DLayered(texture< int, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2039
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2043
exit(___);}
#if 0
# 2039
{ 
# 2040
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2042
return (int)(v.x); 
# 2043
} 
#endif
# 2045 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned tex2DLayered(texture< unsigned, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2046
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2050
exit(___);}
#if 0
# 2046
{ 
# 2047
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2049
return (unsigned)(v.x); 
# 2050
} 
#endif
# 2052 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int1 tex2DLayered(texture< int1, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2053
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2057
exit(___);}
#if 0
# 2053
{ 
# 2054
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2056
return make_int1(v.x); 
# 2057
} 
#endif
# 2059 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint1 tex2DLayered(texture< uint1, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2060
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2064
exit(___);}
#if 0
# 2060
{ 
# 2061
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2063
return make_uint1(v.x); 
# 2064
} 
#endif
# 2066 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int2 tex2DLayered(texture< int2, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2067
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2071
exit(___);}
#if 0
# 2067
{ 
# 2068
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2070
return make_int2(v.x, v.y); 
# 2071
} 
#endif
# 2073 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint2 tex2DLayered(texture< uint2, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2074
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2078
exit(___);}
#if 0
# 2074
{ 
# 2075
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2077
return make_uint2(v.x, v.y); 
# 2078
} 
#endif
# 2080 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int4 tex2DLayered(texture< int4, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2081
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2085
exit(___);}
#if 0
# 2081
{ 
# 2082
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2084
return make_int4(v.x, v.y, v.z, v.w); 
# 2085
} 
#endif
# 2087 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint4 tex2DLayered(texture< uint4, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2088
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2092
exit(___);}
#if 0
# 2088
{ 
# 2089
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2091
return make_uint4(v.x, v.y, v.z, v.w); 
# 2092
} 
#endif
# 2166 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2DLayered(texture< float, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2167
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2171
exit(___);}
#if 0
# 2167
{ 
# 2168
float4 v = __ftexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2170
return v.x; 
# 2171
} 
#endif
# 2173 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2DLayered(texture< float1, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2174
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2178
exit(___);}
#if 0
# 2174
{ 
# 2175
float4 v = __ftexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2177
return make_float1(v.x); 
# 2178
} 
#endif
# 2180 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2DLayered(texture< float2, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2181
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2185
exit(___);}
#if 0
# 2181
{ 
# 2182
float4 v = __ftexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2184
return make_float2(v.x, v.y); 
# 2185
} 
#endif
# 2187 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2DLayered(texture< float4, 242, cudaReadModeElementType>  t, float x, float y, int layer) 
# 2188
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2192
exit(___);}
#if 0
# 2188
{ 
# 2189
float4 v = __ftexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2191
return make_float4(v.x, v.y, v.z, v.w); 
# 2192
} 
#endif
# 2200 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2DLayered(texture< char, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2201
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2210
exit(___);}
#if 0
# 2201
{ 
# 2205
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2207
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2209
return w.x; 
# 2210
} 
#endif
# 2212 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2DLayered(texture< signed char, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2213
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2218
exit(___);}
#if 0
# 2213
{ 
# 2214
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2215
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2217
return w.x; 
# 2218
} 
#endif
# 2220 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2DLayered(texture< unsigned char, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2221
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2226
exit(___);}
#if 0
# 2221
{ 
# 2222
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2223
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2225
return w.x; 
# 2226
} 
#endif
# 2228 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2DLayered(texture< char1, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2229
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2234
exit(___);}
#if 0
# 2229
{ 
# 2230
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2231
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2233
return make_float1(w.x); 
# 2234
} 
#endif
# 2236 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2DLayered(texture< uchar1, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2237
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2242
exit(___);}
#if 0
# 2237
{ 
# 2238
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2239
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2241
return make_float1(w.x); 
# 2242
} 
#endif
# 2244 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2DLayered(texture< char2, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2245
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2250
exit(___);}
#if 0
# 2245
{ 
# 2246
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2247
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2249
return make_float2(w.x, w.y); 
# 2250
} 
#endif
# 2252 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2DLayered(texture< uchar2, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2253
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2258
exit(___);}
#if 0
# 2253
{ 
# 2254
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2255
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2257
return make_float2(w.x, w.y); 
# 2258
} 
#endif
# 2260 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2DLayered(texture< char4, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2261
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2266
exit(___);}
#if 0
# 2261
{ 
# 2262
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2263
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2265
return make_float4(w.x, w.y, w.z, w.w); 
# 2266
} 
#endif
# 2268 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2DLayered(texture< uchar4, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2269
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2274
exit(___);}
#if 0
# 2269
{ 
# 2270
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2271
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2273
return make_float4(w.x, w.y, w.z, w.w); 
# 2274
} 
#endif
# 2282 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2DLayered(texture< short, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2283
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2288
exit(___);}
#if 0
# 2283
{ 
# 2284
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2285
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2287
return w.x; 
# 2288
} 
#endif
# 2290 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex2DLayered(texture< unsigned short, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2291
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2296
exit(___);}
#if 0
# 2291
{ 
# 2292
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2293
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2295
return w.x; 
# 2296
} 
#endif
# 2298 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2DLayered(texture< short1, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2299
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2304
exit(___);}
#if 0
# 2299
{ 
# 2300
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2301
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2303
return make_float1(w.x); 
# 2304
} 
#endif
# 2306 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex2DLayered(texture< ushort1, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2307
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2312
exit(___);}
#if 0
# 2307
{ 
# 2308
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2309
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2311
return make_float1(w.x); 
# 2312
} 
#endif
# 2314 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2DLayered(texture< short2, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2315
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2320
exit(___);}
#if 0
# 2315
{ 
# 2316
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2317
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2319
return make_float2(w.x, w.y); 
# 2320
} 
#endif
# 2322 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex2DLayered(texture< ushort2, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2323
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2328
exit(___);}
#if 0
# 2323
{ 
# 2324
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2325
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2327
return make_float2(w.x, w.y); 
# 2328
} 
#endif
# 2330 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2DLayered(texture< short4, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2331
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2336
exit(___);}
#if 0
# 2331
{ 
# 2332
int4 v = __itexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2333
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2335
return make_float4(w.x, w.y, w.z, w.w); 
# 2336
} 
#endif
# 2338 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex2DLayered(texture< ushort4, 242, cudaReadModeNormalizedFloat>  t, float x, float y, int layer) 
# 2339
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)layer;
# 2344
exit(___);}
#if 0
# 2339
{ 
# 2340
uint4 v = __utexfetchl(t, make_float4(x, y, 0, 0), layer); 
# 2341
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2343
return make_float4(w.x, w.y, w.z, w.w); 
# 2344
} 
#endif
# 2352 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char tex3D(texture< char, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2353
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2361
exit(___);}
#if 0
# 2353
{ 
# 2357
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2360
return (char)(v.x); 
# 2361
} 
#endif
# 2363 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline signed char tex3D(texture< signed char, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2364
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2368
exit(___);}
#if 0
# 2364
{ 
# 2365
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2367
return (signed char)(v.x); 
# 2368
} 
#endif
# 2370 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned char tex3D(texture< unsigned char, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2371
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2375
exit(___);}
#if 0
# 2371
{ 
# 2372
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2374
return (unsigned char)(v.x); 
# 2375
} 
#endif
# 2377 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char1 tex3D(texture< char1, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2378
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2382
exit(___);}
#if 0
# 2378
{ 
# 2379
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2381
return make_char1(v.x); 
# 2382
} 
#endif
# 2384 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar1 tex3D(texture< uchar1, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2385
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2389
exit(___);}
#if 0
# 2385
{ 
# 2386
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2388
return make_uchar1(v.x); 
# 2389
} 
#endif
# 2391 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char2 tex3D(texture< char2, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2392
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2396
exit(___);}
#if 0
# 2392
{ 
# 2393
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2395
return make_char2(v.x, v.y); 
# 2396
} 
#endif
# 2398 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar2 tex3D(texture< uchar2, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2399
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2403
exit(___);}
#if 0
# 2399
{ 
# 2400
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2402
return make_uchar2(v.x, v.y); 
# 2403
} 
#endif
# 2405 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline char4 tex3D(texture< char4, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2406
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2410
exit(___);}
#if 0
# 2406
{ 
# 2407
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2409
return make_char4(v.x, v.y, v.z, v.w); 
# 2410
} 
#endif
# 2412 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uchar4 tex3D(texture< uchar4, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2413
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2417
exit(___);}
#if 0
# 2413
{ 
# 2414
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2416
return make_uchar4(v.x, v.y, v.z, v.w); 
# 2417
} 
#endif
# 2425 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short tex3D(texture< short, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2426
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2430
exit(___);}
#if 0
# 2426
{ 
# 2427
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2429
return (short)(v.x); 
# 2430
} 
#endif
# 2432 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned short tex3D(texture< unsigned short, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2433
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2437
exit(___);}
#if 0
# 2433
{ 
# 2434
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2436
return (unsigned short)(v.x); 
# 2437
} 
#endif
# 2439 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short1 tex3D(texture< short1, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2440
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2444
exit(___);}
#if 0
# 2440
{ 
# 2441
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2443
return make_short1(v.x); 
# 2444
} 
#endif
# 2446 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort1 tex3D(texture< ushort1, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2447
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2451
exit(___);}
#if 0
# 2447
{ 
# 2448
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2450
return make_ushort1(v.x); 
# 2451
} 
#endif
# 2453 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short2 tex3D(texture< short2, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2454
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2458
exit(___);}
#if 0
# 2454
{ 
# 2455
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2457
return make_short2(v.x, v.y); 
# 2458
} 
#endif
# 2460 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort2 tex3D(texture< ushort2, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2461
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2465
exit(___);}
#if 0
# 2461
{ 
# 2462
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2464
return make_ushort2(v.x, v.y); 
# 2465
} 
#endif
# 2467 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline short4 tex3D(texture< short4, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2468
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2472
exit(___);}
#if 0
# 2468
{ 
# 2469
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2471
return make_short4(v.x, v.y, v.z, v.w); 
# 2472
} 
#endif
# 2474 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline ushort4 tex3D(texture< ushort4, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2475
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2479
exit(___);}
#if 0
# 2475
{ 
# 2476
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2478
return make_ushort4(v.x, v.y, v.z, v.w); 
# 2479
} 
#endif
# 2487 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int tex3D(texture< int, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2488
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2492
exit(___);}
#if 0
# 2488
{ 
# 2489
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2491
return (int)(v.x); 
# 2492
} 
#endif
# 2494 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline unsigned tex3D(texture< unsigned, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2495
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2499
exit(___);}
#if 0
# 2495
{ 
# 2496
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2498
return (unsigned)(v.x); 
# 2499
} 
#endif
# 2501 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int1 tex3D(texture< int1, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2502
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2506
exit(___);}
#if 0
# 2502
{ 
# 2503
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2505
return make_int1(v.x); 
# 2506
} 
#endif
# 2508 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint1 tex3D(texture< uint1, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2509
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2513
exit(___);}
#if 0
# 2509
{ 
# 2510
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2512
return make_uint1(v.x); 
# 2513
} 
#endif
# 2515 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int2 tex3D(texture< int2, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2516
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2520
exit(___);}
#if 0
# 2516
{ 
# 2517
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2519
return make_int2(v.x, v.y); 
# 2520
} 
#endif
# 2522 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint2 tex3D(texture< uint2, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2523
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2527
exit(___);}
#if 0
# 2523
{ 
# 2524
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2526
return make_uint2(v.x, v.y); 
# 2527
} 
#endif
# 2529 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline int4 tex3D(texture< int4, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2530
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2534
exit(___);}
#if 0
# 2530
{ 
# 2531
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2533
return make_int4(v.x, v.y, v.z, v.w); 
# 2534
} 
#endif
# 2536 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline uint4 tex3D(texture< uint4, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2537
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2541
exit(___);}
#if 0
# 2537
{ 
# 2538
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2540
return make_uint4(v.x, v.y, v.z, v.w); 
# 2541
} 
#endif
# 2615 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex3D(texture< float, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2616
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2620
exit(___);}
#if 0
# 2616
{ 
# 2617
float4 v = __ftexfetch(t, make_float4(x, y, z, 0)); 
# 2619
return v.x; 
# 2620
} 
#endif
# 2622 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex3D(texture< float1, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2623
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2627
exit(___);}
#if 0
# 2623
{ 
# 2624
float4 v = __ftexfetch(t, make_float4(x, y, z, 0)); 
# 2626
return make_float1(v.x); 
# 2627
} 
#endif
# 2629 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex3D(texture< float2, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2630
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2634
exit(___);}
#if 0
# 2630
{ 
# 2631
float4 v = __ftexfetch(t, make_float4(x, y, z, 0)); 
# 2633
return make_float2(v.x, v.y); 
# 2634
} 
#endif
# 2636 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex3D(texture< float4, 3, cudaReadModeElementType>  t, float x, float y, float z) 
# 2637
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2641
exit(___);}
#if 0
# 2637
{ 
# 2638
float4 v = __ftexfetch(t, make_float4(x, y, z, 0)); 
# 2640
return make_float4(v.x, v.y, v.z, v.w); 
# 2641
} 
#endif
# 2649 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex3D(texture< char, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2650
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2659
exit(___);}
#if 0
# 2650
{ 
# 2654
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2656
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2658
return w.x; 
# 2659
} 
#endif
# 2661 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex3D(texture< signed char, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2662
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2667
exit(___);}
#if 0
# 2662
{ 
# 2663
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2664
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2666
return w.x; 
# 2667
} 
#endif
# 2669 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex3D(texture< unsigned char, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2670
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2675
exit(___);}
#if 0
# 2670
{ 
# 2671
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2672
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2674
return w.x; 
# 2675
} 
#endif
# 2677 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex3D(texture< char1, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2678
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2683
exit(___);}
#if 0
# 2678
{ 
# 2679
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2680
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2682
return make_float1(w.x); 
# 2683
} 
#endif
# 2685 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex3D(texture< uchar1, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2686
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2691
exit(___);}
#if 0
# 2686
{ 
# 2687
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2688
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2690
return make_float1(w.x); 
# 2691
} 
#endif
# 2693 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex3D(texture< char2, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2694
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2699
exit(___);}
#if 0
# 2694
{ 
# 2695
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2696
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2698
return make_float2(w.x, w.y); 
# 2699
} 
#endif
# 2701 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex3D(texture< uchar2, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2702
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2707
exit(___);}
#if 0
# 2702
{ 
# 2703
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2704
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2706
return make_float2(w.x, w.y); 
# 2707
} 
#endif
# 2709 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex3D(texture< char4, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2710
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2715
exit(___);}
#if 0
# 2710
{ 
# 2711
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2712
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2714
return make_float4(w.x, w.y, w.z, w.w); 
# 2715
} 
#endif
# 2717 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex3D(texture< uchar4, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2718
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2723
exit(___);}
#if 0
# 2718
{ 
# 2719
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2720
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2722
return make_float4(w.x, w.y, w.z, w.w); 
# 2723
} 
#endif
# 2731 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex3D(texture< short, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2732
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2737
exit(___);}
#if 0
# 2732
{ 
# 2733
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2734
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2736
return w.x; 
# 2737
} 
#endif
# 2739 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float tex3D(texture< unsigned short, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2740
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2745
exit(___);}
#if 0
# 2740
{ 
# 2741
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2742
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2744
return w.x; 
# 2745
} 
#endif
# 2747 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex3D(texture< short1, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2748
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2753
exit(___);}
#if 0
# 2748
{ 
# 2749
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2750
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2752
return make_float1(w.x); 
# 2753
} 
#endif
# 2755 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float1 tex3D(texture< ushort1, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2756
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2761
exit(___);}
#if 0
# 2756
{ 
# 2757
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2758
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2760
return make_float1(w.x); 
# 2761
} 
#endif
# 2763 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex3D(texture< short2, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2764
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2769
exit(___);}
#if 0
# 2764
{ 
# 2765
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2766
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2768
return make_float2(w.x, w.y); 
# 2769
} 
#endif
# 2771 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float2 tex3D(texture< ushort2, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2772
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2777
exit(___);}
#if 0
# 2772
{ 
# 2773
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2774
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2776
return make_float2(w.x, w.y); 
# 2777
} 
#endif
# 2779 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex3D(texture< short4, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2780
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2785
exit(___);}
#if 0
# 2780
{ 
# 2781
int4 v = __itexfetch(t, make_float4(x, y, z, 0)); 
# 2782
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2784
return make_float4(w.x, w.y, w.z, w.w); 
# 2785
} 
#endif
# 2787 "/home/u0332192/local/cuda/include/texture_fetch_functions.h"
__attribute__((unused)) static inline float4 tex3D(texture< ushort4, 3, cudaReadModeNormalizedFloat>  t, float x, float y, float z) 
# 2788
{int volatile ___ = 1;(void)t;(void)x;(void)y;(void)z;
# 2793
exit(___);}
#if 0
# 2788
{ 
# 2789
uint4 v = __utexfetch(t, make_float4(x, y, z, 0)); 
# 2790
float4 w = make_float4(__int_as_float(v.x), __int_as_float(v.y), __int_as_float(v.z), __int_as_float(v.w)); 
# 2792
return make_float4(w.x, w.y, w.z, w.w); 
# 2793
} 
#endif
# 67 "/home/u0332192/local/cuda/include/device_launch_parameters.h"
extern "C" { extern const uint3 threadIdx; } 
# 69
extern "C" { extern const uint3 blockIdx; } 
# 71
extern "C" { extern const dim3 blockDim; } 
# 73
extern "C" { extern const dim3 gridDim; } 
# 75
extern "C" { extern const int warpSize; } 
# 120 "/home/u0332192/local/cuda/include/cuda_runtime.h"
template< class T> inline cudaError_t 
# 121
cudaSetupArgument(T 
# 122
arg, size_t 
# 123
offset) 
# 125
{ 
# 126
return cudaSetupArgument((const void *)(&arg), sizeof(T), offset); 
# 127
} 
# 159
static inline cudaError_t cudaEventCreate(cudaEvent_t *
# 160
event, unsigned 
# 161
flags) 
# 163
{ 
# 164
return cudaEventCreateWithFlags(event, flags); 
# 165
} 
# 222
static inline cudaError_t cudaMallocHost(void **
# 223
ptr, size_t 
# 224
size, unsigned 
# 225
flags) 
# 227
{ 
# 228
return cudaHostAlloc(ptr, size, flags); 
# 229
} 
# 231
template< class T> inline cudaError_t 
# 232
cudaHostAlloc(T **
# 233
ptr, size_t 
# 234
size, unsigned 
# 235
flags) 
# 237
{ 
# 238
return cudaHostAlloc((void **)((void *)ptr), size, flags); 
# 239
} 
# 241
template< class T> inline cudaError_t 
# 242
cudaHostGetDevicePointer(T **
# 243
pDevice, void *
# 244
pHost, unsigned 
# 245
flags) 
# 247
{ 
# 248
return cudaHostGetDevicePointer((void **)((void *)pDevice), pHost, flags); 
# 249
} 
# 251
template< class T> inline cudaError_t 
# 252
cudaMalloc(T **
# 253
devPtr, size_t 
# 254
size) 
# 256
{ 
# 257
return cudaMalloc((void **)((void *)devPtr), size); 
# 258
} 
# 260
template< class T> inline cudaError_t 
# 261
cudaMallocHost(T **
# 262
ptr, size_t 
# 263
size, unsigned 
# 264
flags = (0)) 
# 266
{ 
# 267
return cudaMallocHost((void **)((void *)ptr), size, flags); 
# 268
} 
# 270
template< class T> inline cudaError_t 
# 271
cudaMallocPitch(T **
# 272
devPtr, size_t *
# 273
pitch, size_t 
# 274
width, size_t 
# 275
height) 
# 277
{ 
# 278
return cudaMallocPitch((void **)((void *)devPtr), pitch, width, height); 
# 279
} 
# 289
static inline cudaError_t cudaMemcpyToSymbol(char *
# 290
symbol, const void *
# 291
src, size_t 
# 292
count, size_t 
# 293
offset = (0), cudaMemcpyKind 
# 294
kind = cudaMemcpyHostToDevice) 
# 296
{ 
# 297
return cudaMemcpyToSymbol((const char *)symbol, src, count, offset, kind); 
# 298
} 
# 300
template< class T> inline cudaError_t 
# 301
cudaMemcpyToSymbol(const T &
# 302
symbol, const void *
# 303
src, size_t 
# 304
count, size_t 
# 305
offset = (0), cudaMemcpyKind 
# 306
kind = cudaMemcpyHostToDevice) 
# 308
{ 
# 309
return cudaMemcpyToSymbol((const char *)(&symbol), src, count, offset, kind); 
# 310
} 
# 312
static inline cudaError_t cudaMemcpyToSymbolAsync(char *
# 313
symbol, const void *
# 314
src, size_t 
# 315
count, size_t 
# 316
offset = (0), cudaMemcpyKind 
# 317
kind = cudaMemcpyHostToDevice, cudaStream_t 
# 318
stream = 0) 
# 320
{ 
# 321
return cudaMemcpyToSymbolAsync((const char *)symbol, src, count, offset, kind, stream); 
# 322
} 
# 324
template< class T> inline cudaError_t 
# 325
cudaMemcpyToSymbolAsync(const T &
# 326
symbol, const void *
# 327
src, size_t 
# 328
count, size_t 
# 329
offset = (0), cudaMemcpyKind 
# 330
kind = cudaMemcpyHostToDevice, cudaStream_t 
# 331
stream = 0) 
# 333
{ 
# 334
return cudaMemcpyToSymbolAsync((const char *)(&symbol), src, count, offset, kind, stream); 
# 335
} 
# 343
static inline cudaError_t cudaMemcpyFromSymbol(void *
# 344
dst, char *
# 345
symbol, size_t 
# 346
count, size_t 
# 347
offset = (0), cudaMemcpyKind 
# 348
kind = cudaMemcpyDeviceToHost) 
# 350
{ 
# 351
return cudaMemcpyFromSymbol(dst, (const char *)symbol, count, offset, kind); 
# 352
} 
# 354
template< class T> inline cudaError_t 
# 355
cudaMemcpyFromSymbol(void *
# 356
dst, const T &
# 357
symbol, size_t 
# 358
count, size_t 
# 359
offset = (0), cudaMemcpyKind 
# 360
kind = cudaMemcpyDeviceToHost) 
# 362
{ 
# 363
return cudaMemcpyFromSymbol(dst, (const char *)(&symbol), count, offset, kind); 
# 364
} 
# 366
static inline cudaError_t cudaMemcpyFromSymbolAsync(void *
# 367
dst, char *
# 368
symbol, size_t 
# 369
count, size_t 
# 370
offset = (0), cudaMemcpyKind 
# 371
kind = cudaMemcpyDeviceToHost, cudaStream_t 
# 372
stream = 0) 
# 374
{ 
# 375
return cudaMemcpyFromSymbolAsync(dst, (const char *)symbol, count, offset, kind, stream); 
# 376
} 
# 378
template< class T> inline cudaError_t 
# 379
cudaMemcpyFromSymbolAsync(void *
# 380
dst, const T &
# 381
symbol, size_t 
# 382
count, size_t 
# 383
offset = (0), cudaMemcpyKind 
# 384
kind = cudaMemcpyDeviceToHost, cudaStream_t 
# 385
stream = 0) 
# 387
{ 
# 388
return cudaMemcpyFromSymbolAsync(dst, (const char *)(&symbol), count, offset, kind, stream); 
# 389
} 
# 391
static inline cudaError_t cudaGetSymbolAddress(void **
# 392
devPtr, char *
# 393
symbol) 
# 395
{ 
# 396
return cudaGetSymbolAddress(devPtr, (const char *)symbol); 
# 397
} 
# 424
template< class T> inline cudaError_t 
# 425
cudaGetSymbolAddress(void **
# 426
devPtr, const T &
# 427
symbol) 
# 429
{ 
# 430
return cudaGetSymbolAddress(devPtr, (const char *)(&symbol)); 
# 431
} 
# 439
static inline cudaError_t cudaGetSymbolSize(size_t *
# 440
size, char *
# 441
symbol) 
# 443
{ 
# 444
return cudaGetSymbolSize(size, (const char *)symbol); 
# 445
} 
# 472
template< class T> inline cudaError_t 
# 473
cudaGetSymbolSize(size_t *
# 474
size, const T &
# 475
symbol) 
# 477
{ 
# 478
return cudaGetSymbolSize(size, (const char *)(&symbol)); 
# 479
} 
# 521
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 522
cudaBindTexture(size_t *
# 523
offset, const texture< T, dim, readMode>  &
# 524
tex, const void *
# 525
devPtr, const cudaChannelFormatDesc &
# 526
desc, size_t 
# 527
size = (((2147483647) * 2U) + 1U)) 
# 529
{ 
# 530
return cudaBindTexture(offset, &tex, devPtr, &desc, size); 
# 531
} 
# 566
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 567
cudaBindTexture(size_t *
# 568
offset, const texture< T, dim, readMode>  &
# 569
tex, const void *
# 570
devPtr, size_t 
# 571
size = (((2147483647) * 2U) + 1U)) 
# 573
{ 
# 574
return cudaBindTexture(offset, tex, devPtr, (tex.channelDesc), size); 
# 575
} 
# 622
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 623
cudaBindTexture2D(size_t *
# 624
offset, const texture< T, dim, readMode>  &
# 625
tex, const void *
# 626
devPtr, const cudaChannelFormatDesc &
# 627
desc, size_t 
# 628
width, size_t 
# 629
height, size_t 
# 630
pitch) 
# 632
{ 
# 633
return cudaBindTexture2D(offset, &tex, devPtr, &desc, width, height, pitch); 
# 634
} 
# 680
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 681
cudaBindTexture2D(size_t *
# 682
offset, const texture< T, dim, readMode>  &
# 683
tex, const void *
# 684
devPtr, size_t 
# 685
width, size_t 
# 686
height, size_t 
# 687
pitch) 
# 689
{ 
# 690
return cudaBindTexture2D(offset, &tex, devPtr, &(tex.texture< T, dim, readMode> ::channelDesc), width, height, pitch); 
# 691
} 
# 722
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 723
cudaBindTextureToArray(const texture< T, dim, readMode>  &
# 724
tex, const cudaArray *
# 725
array, const cudaChannelFormatDesc &
# 726
desc) 
# 728
{ 
# 729
return cudaBindTextureToArray(&tex, array, &desc); 
# 730
} 
# 760
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 761
cudaBindTextureToArray(const texture< T, dim, readMode>  &
# 762
tex, const cudaArray *
# 763
array) 
# 765
{ 
# 766
cudaChannelFormatDesc desc; 
# 767
cudaError_t err = cudaGetChannelDesc(&desc, array); 
# 769
return (err == (cudaSuccess)) ? cudaBindTextureToArray(tex, array, desc) : err; 
# 770
} 
# 799
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 800
cudaUnbindTexture(const texture< T, dim, readMode>  &
# 801
tex) 
# 803
{ 
# 804
return cudaUnbindTexture(&tex); 
# 805
} 
# 839
template< class T, int dim, cudaTextureReadMode readMode> inline cudaError_t 
# 840
cudaGetTextureAlignmentOffset(size_t *
# 841
offset, const texture< T, dim, readMode>  &
# 842
tex) 
# 844
{ 
# 845
return cudaGetTextureAlignmentOffset(offset, &tex); 
# 846
} 
# 900
template< class T> inline cudaError_t 
# 901
cudaFuncSetCacheConfig(T *
# 902
func, cudaFuncCache 
# 903
cacheConfig) 
# 905
{ 
# 906
return cudaFuncSetCacheConfig((const char *)func, cacheConfig); 
# 907
} 
# 944
template< class T> inline cudaError_t 
# 945
cudaLaunch(T *
# 946
entry) 
# 948
{ 
# 949
return cudaLaunch((const char *)entry); 
# 950
} 
# 984
template< class T> inline cudaError_t 
# 985
cudaFuncGetAttributes(cudaFuncAttributes *
# 986
attr, T *
# 987
entry) 
# 989
{ 
# 990
return cudaFuncGetAttributes(attr, (const char *)entry); 
# 991
} 
# 1013
template< class T, int dim> inline cudaError_t 
# 1014
cudaBindSurfaceToArray(const surface< T, dim>  &
# 1015
surf, const cudaArray *
# 1016
array, const cudaChannelFormatDesc &
# 1017
desc) 
# 1019
{ 
# 1020
return cudaBindSurfaceToArray(&surf, array, &desc); 
# 1021
} 
# 1042
template< class T, int dim> inline cudaError_t 
# 1043
cudaBindSurfaceToArray(const surface< T, dim>  &
# 1044
surf, const cudaArray *
# 1045
array) 
# 1047
{ 
# 1048
cudaChannelFormatDesc desc; 
# 1049
cudaError_t err = cudaGetChannelDesc(&desc, array); 
# 1051
return (err == (cudaSuccess)) ? cudaBindSurfaceToArray(surf, array, desc) : err; 
# 1052
} 
# 45 "/usr/include/stdio.h" 3
struct _IO_FILE; 
# 49
extern "C" { typedef _IO_FILE FILE; }
# 65 "/usr/include/stdio.h" 3
extern "C" { typedef _IO_FILE __FILE; }
# 95 "/usr/include/wchar.h" 3
extern "C" { typedef 
# 84
struct { 
# 85
int __count; 
# 87
union { 
# 89
unsigned __wch; 
# 93
char __wchb[4]; 
# 94
} __value; 
# 95
} __mbstate_t; }
# 26 "/usr/include/_G_config.h" 3
extern "C" { typedef 
# 23
struct { 
# 24
__off_t __pos; 
# 25
__mbstate_t __state; 
# 26
} _G_fpos_t; }
# 31
extern "C" { typedef 
# 28
struct { 
# 29
__off64_t __pos; 
# 30
__mbstate_t __state; 
# 31
} _G_fpos64_t; }
# 53 "/usr/include/_G_config.h" 3
extern "C" { typedef short _G_int16_t __attribute((__mode__(__HI__))); }
# 54
extern "C" { typedef int _G_int32_t __attribute((__mode__(__SI__))); }
# 55
extern "C" { typedef unsigned short _G_uint16_t __attribute((__mode__(__HI__))); }
# 56
extern "C" { typedef unsigned _G_uint32_t __attribute((__mode__(__SI__))); }
# 40 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/stdarg.h" 3
extern "C" { typedef __builtin_va_list __gnuc_va_list; }
# 170 "/usr/include/libio.h" 3
struct _IO_jump_t; struct _IO_FILE; 
# 180
extern "C" { typedef void _IO_lock_t; }
# 186
extern "C" { struct _IO_marker { 
# 187
_IO_marker *_next; 
# 188
_IO_FILE *_sbuf; 
# 192
int _pos; 
# 203 "/usr/include/libio.h" 3
}; }
# 206
enum __codecvt_result { 
# 208
__codecvt_ok, 
# 209
__codecvt_partial, 
# 210
__codecvt_error, 
# 211
__codecvt_noconv
# 212
}; 
# 271 "/usr/include/libio.h" 3
extern "C" { struct _IO_FILE { 
# 272
int _flags; 
# 277
char *_IO_read_ptr; 
# 278
char *_IO_read_end; 
# 279
char *_IO_read_base; 
# 280
char *_IO_write_base; 
# 281
char *_IO_write_ptr; 
# 282
char *_IO_write_end; 
# 283
char *_IO_buf_base; 
# 284
char *_IO_buf_end; 
# 286
char *_IO_save_base; 
# 287
char *_IO_backup_base; 
# 288
char *_IO_save_end; 
# 290
_IO_marker *_markers; 
# 292
_IO_FILE *_chain; 
# 294
int _fileno; 
# 298
int _flags2; 
# 300
__off_t _old_offset; 
# 304
unsigned short _cur_column; 
# 305
signed char _vtable_offset; 
# 306
char _shortbuf[1]; 
# 310
_IO_lock_t *_lock; 
# 319 "/usr/include/libio.h" 3
__off64_t _offset; 
# 328 "/usr/include/libio.h" 3
void *__pad1; 
# 329
void *__pad2; 
# 330
void *__pad3; 
# 331
void *__pad4; 
# 332
size_t __pad5; 
# 334
int _mode; 
# 336
char _unused2[(((15) * sizeof(int)) - ((4) * sizeof(void *))) - sizeof(size_t)]; 
# 338
}; }
# 344
struct _IO_FILE_plus; 
# 346
extern "C" { extern _IO_FILE_plus _IO_2_1_stdin_; } 
# 347
extern "C" { extern _IO_FILE_plus _IO_2_1_stdout_; } 
# 348
extern "C" { extern _IO_FILE_plus _IO_2_1_stderr_; } 
# 364 "/usr/include/libio.h" 3
extern "C" { typedef __ssize_t __io_read_fn(void * , char * , size_t ); }
# 372
extern "C" { typedef __ssize_t __io_write_fn(void * , const char * , size_t ); }
# 381
extern "C" { typedef int __io_seek_fn(void * , __off64_t * , int ); }
# 384
extern "C" { typedef int __io_close_fn(void * ); }
# 389
extern "C" { typedef __io_read_fn cookie_read_function_t; }
# 390
extern "C" { typedef __io_write_fn cookie_write_function_t; }
# 391
extern "C" { typedef __io_seek_fn cookie_seek_function_t; }
# 392
extern "C" { typedef __io_close_fn cookie_close_function_t; }
# 401
extern "C" { typedef 
# 396
struct { 
# 397
__io_read_fn *read; 
# 398
__io_write_fn *write; 
# 399
__io_seek_fn *seek; 
# 400
__io_close_fn *close; 
# 401
} _IO_cookie_io_functions_t; }
# 402
extern "C" { typedef _IO_cookie_io_functions_t cookie_io_functions_t; }
# 404
struct _IO_cookie_file; 
# 407
extern "C" void _IO_cookie_init(_IO_cookie_file * , int , void * , _IO_cookie_io_functions_t ); 
# 416
extern "C" int __underflow(_IO_FILE *); 
# 417
extern "C" int __uflow(_IO_FILE *); 
# 418
extern "C" int __overflow(_IO_FILE *, int); 
# 460 "/usr/include/libio.h" 3
extern "C" int _IO_getc(_IO_FILE * ); 
# 461
extern "C" int _IO_putc(int , _IO_FILE * ); 
# 462
extern "C" int _IO_feof(_IO_FILE * ) throw(); 
# 463
extern "C" int _IO_ferror(_IO_FILE * ) throw(); 
# 465
extern "C" int _IO_peekc_locked(_IO_FILE * ); 
# 471
extern "C" void _IO_flockfile(_IO_FILE *) throw(); 
# 472
extern "C" void _IO_funlockfile(_IO_FILE *) throw(); 
# 473
extern "C" int _IO_ftrylockfile(_IO_FILE *) throw(); 
# 490 "/usr/include/libio.h" 3
extern "C" int _IO_vfscanf(_IO_FILE *__restrict__, const char *__restrict__, __gnuc_va_list, int *__restrict__); 
# 492
extern "C" int _IO_vfprintf(_IO_FILE *__restrict__, const char *__restrict__, __gnuc_va_list); 
# 494
extern "C" __ssize_t _IO_padn(_IO_FILE *, int, __ssize_t); 
# 495
extern "C" size_t _IO_sgetn(_IO_FILE *, void *, size_t); 
# 497
extern "C" __off64_t _IO_seekoff(_IO_FILE *, __off64_t, int, int); 
# 498
extern "C" __off64_t _IO_seekpos(_IO_FILE *, __off64_t, int); 
# 500
extern "C" void _IO_free_backup_area(_IO_FILE *) throw(); 
# 80 "/usr/include/stdio.h" 3
extern "C" { typedef __gnuc_va_list va_list; }
# 111 "/usr/include/stdio.h" 3
extern "C" { typedef _G_fpos_t fpos_t; }
# 117
extern "C" { typedef _G_fpos64_t fpos64_t; }
# 165 "/usr/include/stdio.h" 3
extern "C" { extern _IO_FILE *stdin; } 
# 166
extern "C" { extern _IO_FILE *stdout; } 
# 167
extern "C" { extern _IO_FILE *stderr; } 
# 175
extern "C" int remove(const char * ) throw(); 
# 177
extern "C" int rename(const char * , const char * ) throw(); 
# 182
extern "C" int renameat(int , const char * , int , const char * ) throw(); 
# 192
extern "C" FILE *tmpfile(); 
# 202 "/usr/include/stdio.h" 3
extern "C" FILE *tmpfile64(); 
# 206
extern "C" char *tmpnam(char * ) throw(); 
# 212
extern "C" char *tmpnam_r(char * ) throw(); 
# 224
extern "C" char *tempnam(const char * , const char * ) throw()
# 225
 __attribute((__malloc__)); 
# 234
extern "C" int fclose(FILE * ); 
# 239
extern "C" int fflush(FILE * ); 
# 249
extern "C" int fflush_unlocked(FILE * ); 
# 259
extern "C" int fcloseall(); 
# 269
extern "C" FILE *fopen(const char *__restrict__ , const char *__restrict__ ); 
# 275
extern "C" FILE *freopen(const char *__restrict__ , const char *__restrict__ , FILE *__restrict__ ); 
# 294 "/usr/include/stdio.h" 3
extern "C" FILE *fopen64(const char *__restrict__ , const char *__restrict__ ); 
# 296
extern "C" FILE *freopen64(const char *__restrict__ , const char *__restrict__ , FILE *__restrict__ ); 
# 303
extern "C" FILE *fdopen(int , const char * ) throw(); 
# 309
extern "C" FILE *fopencookie(void *__restrict__ , const char *__restrict__ , _IO_cookie_io_functions_t ) throw(); 
# 316
extern "C" FILE *fmemopen(void * , size_t , const char * ) throw(); 
# 322
extern "C" FILE *open_memstream(char ** , size_t * ) throw(); 
# 329
extern "C" void setbuf(FILE *__restrict__ , char *__restrict__ ) throw(); 
# 333
extern "C" int setvbuf(FILE *__restrict__ , char *__restrict__ , int , size_t ) throw(); 
# 340
extern "C" void setbuffer(FILE *__restrict__ , char *__restrict__ , size_t ) throw(); 
# 344
extern "C" void setlinebuf(FILE * ) throw(); 
# 353
extern "C" int fprintf(FILE *__restrict__ , const char *__restrict__ , ...); 
# 359
extern "C" int printf(const char *__restrict__ , ...); 
# 361
extern "C" int sprintf(char *__restrict__ , const char *__restrict__ , ...) throw(); 
# 368
extern "C" int vfprintf(FILE *__restrict__ , const char *__restrict__ , __gnuc_va_list ); 
# 374
extern "C" int vprintf(const char *__restrict__ , __gnuc_va_list ); 
# 376
extern "C" int vsprintf(char *__restrict__ , const char *__restrict__ , __gnuc_va_list ) throw(); 
# 383
extern "C" int snprintf(char *__restrict__ , size_t , const char *__restrict__ , ...) throw()
# 385
 __attribute((__format__(__printf__, 3, 4))); 
# 387
extern "C" int vsnprintf(char *__restrict__ , size_t , const char *__restrict__ , __gnuc_va_list ) throw()
# 389
 __attribute((__format__(__printf__, 3, 0))); 
# 396
extern "C" int vasprintf(char **__restrict__ , const char *__restrict__ , __gnuc_va_list ) throw()
# 398
 __attribute((__format__(__printf__, 2, 0))); 
# 399
extern "C" int __asprintf(char **__restrict__ , const char *__restrict__ , ...) throw()
# 401
 __attribute((__format__(__printf__, 2, 3))); 
# 402
extern "C" int asprintf(char **__restrict__ , const char *__restrict__ , ...) throw()
# 404
 __attribute((__format__(__printf__, 2, 3))); 
# 414
extern "C" int vdprintf(int , const char *__restrict__ , __gnuc_va_list )
# 416
 __attribute((__format__(__printf__, 2, 0))); 
# 417
extern "C" int dprintf(int , const char *__restrict__ , ...)
# 418
 __attribute((__format__(__printf__, 2, 3))); 
# 427
extern "C" int fscanf(FILE *__restrict__ , const char *__restrict__ , ...); 
# 433
extern "C" int scanf(const char *__restrict__ , ...); 
# 435
extern "C" int sscanf(const char *__restrict__ , const char *__restrict__ , ...) throw(); 
# 473 "/usr/include/stdio.h" 3
extern "C" int vfscanf(FILE *__restrict__ , const char *__restrict__ , __gnuc_va_list )
# 475
 __attribute((__format__(__scanf__, 2, 0))); 
# 481
extern "C" int vscanf(const char *__restrict__ , __gnuc_va_list )
# 482
 __attribute((__format__(__scanf__, 1, 0))); 
# 485
extern "C" int vsscanf(const char *__restrict__ , const char *__restrict__ , __gnuc_va_list ) throw()
# 487
 __attribute((__format__(__scanf__, 2, 0))); 
# 533 "/usr/include/stdio.h" 3
extern "C" int fgetc(FILE * ); 
# 534
extern "C" int getc(FILE * ); 
# 540
extern "C" int getchar(); 
# 552
extern "C" int getc_unlocked(FILE * ); 
# 553
extern "C" int getchar_unlocked(); 
# 563
extern "C" int fgetc_unlocked(FILE * ); 
# 575
extern "C" int fputc(int , FILE * ); 
# 576
extern "C" int putc(int , FILE * ); 
# 582
extern "C" int putchar(int ); 
# 596
extern "C" int fputc_unlocked(int , FILE * ); 
# 604
extern "C" int putc_unlocked(int , FILE * ); 
# 605
extern "C" int putchar_unlocked(int ); 
# 612
extern "C" int getw(FILE * ); 
# 615
extern "C" int putw(int , FILE * ); 
# 624
extern "C" char *fgets(char *__restrict__ , int , FILE *__restrict__ ); 
# 632
extern "C" char *gets(char * ); 
# 642
extern "C" char *fgets_unlocked(char *__restrict__ , int , FILE *__restrict__ ); 
# 658
extern "C" __ssize_t __getdelim(char **__restrict__ , size_t *__restrict__ , int , FILE *__restrict__ ); 
# 661
extern "C" __ssize_t getdelim(char **__restrict__ , size_t *__restrict__ , int , FILE *__restrict__ ); 
# 671
extern "C" __ssize_t getline(char **__restrict__ , size_t *__restrict__ , FILE *__restrict__ ); 
# 682
extern "C" int fputs(const char *__restrict__ , FILE *__restrict__ ); 
# 688
extern "C" int puts(const char * ); 
# 695
extern "C" int ungetc(int , FILE * ); 
# 702
extern "C" size_t fread(void *__restrict__ , size_t , size_t , FILE *__restrict__ ); 
# 708
extern "C" size_t fwrite(const void *__restrict__ , size_t , size_t , FILE *__restrict__ ); 
# 719
extern "C" int fputs_unlocked(const char *__restrict__ , FILE *__restrict__ ); 
# 730
extern "C" size_t fread_unlocked(void *__restrict__ , size_t , size_t , FILE *__restrict__ ); 
# 732
extern "C" size_t fwrite_unlocked(const void *__restrict__ , size_t , size_t , FILE *__restrict__ ); 
# 742
extern "C" int fseek(FILE * , long , int ); 
# 747
extern "C" long ftell(FILE * ); 
# 752
extern "C" void rewind(FILE * ); 
# 766
extern "C" int fseeko(FILE * , __off_t , int ); 
# 771
extern "C" __off_t ftello(FILE * ); 
# 791 "/usr/include/stdio.h" 3
extern "C" int fgetpos(FILE *__restrict__ , fpos_t *__restrict__ ); 
# 796
extern "C" int fsetpos(FILE * , const fpos_t * ); 
# 811 "/usr/include/stdio.h" 3
extern "C" int fseeko64(FILE * , __off64_t , int ); 
# 812
extern "C" __off64_t ftello64(FILE * ); 
# 813
extern "C" int fgetpos64(FILE *__restrict__ , fpos64_t *__restrict__ ); 
# 814
extern "C" int fsetpos64(FILE * , const fpos64_t * ); 
# 819
extern "C" void clearerr(FILE * ) throw(); 
# 821
extern "C" int feof(FILE * ) throw(); 
# 823
extern "C" int ferror(FILE * ) throw(); 
# 828
extern "C" void clearerr_unlocked(FILE * ) throw(); 
# 829
extern "C" int feof_unlocked(FILE * ) throw(); 
# 830
extern "C" int ferror_unlocked(FILE * ) throw(); 
# 839
extern "C" void perror(const char * ); 
# 27 "/usr/include/bits/sys_errlist.h" 3
extern "C" { extern int sys_nerr; } 
# 28
extern "C" { extern const char *const sys_errlist[]; } 
# 31
extern "C" { extern int _sys_nerr; } 
# 32
extern "C" { extern const char *const _sys_errlist[]; } 
# 851 "/usr/include/stdio.h" 3
extern "C" int fileno(FILE * ) throw(); 
# 856
extern "C" int fileno_unlocked(FILE * ) throw(); 
# 866
extern "C" FILE *popen(const char * , const char * ); 
# 872
extern "C" int pclose(FILE * ); 
# 878
extern "C" char *ctermid(char * ) throw(); 
# 884
extern "C" char *cuserid(char * ); 
# 889
struct obstack; 
# 892
extern "C" int obstack_printf(obstack *__restrict__ , const char *__restrict__ , ...) throw()
# 894
 __attribute((__format__(__printf__, 2, 3))); 
# 895
extern "C" int obstack_vprintf(obstack *__restrict__ , const char *__restrict__ , __gnuc_va_list ) throw()
# 898
 __attribute((__format__(__printf__, 2, 0))); 
# 906
extern "C" void flockfile(FILE * ) throw(); 
# 910
extern "C" int ftrylockfile(FILE * ) throw(); 
# 913
extern "C" void funlockfile(FILE * ) throw(); 
# 149 "/home/u0332192/local/cuda/include/cuda.h"
extern "C" { typedef unsigned long long CUdeviceptr; }
# 156
extern "C" { typedef int CUdevice; }
# 157
extern "C" { typedef struct CUctx_st *CUcontext; }
# 158
extern "C" { typedef struct CUmod_st *CUmodule; }
# 159
extern "C" { typedef struct CUfunc_st *CUfunction; }
# 160
extern "C" { typedef struct CUarray_st *CUarray; }
# 161
extern "C" { typedef struct CUtexref_st *CUtexref; }
# 162
extern "C" { typedef struct CUsurfref_st *CUsurfref; }
# 163
extern "C" { typedef CUevent_st *CUevent; }
# 164
extern "C" { typedef CUstream_st *CUstream; }
# 165
extern "C" { typedef struct CUgraphicsResource_st *CUgraphicsResource; }
# 169
extern "C" { typedef 
# 167
struct CUuuid_st { 
# 168
char bytes[16]; 
# 169
} CUuuid; }
# 184
extern "C" { typedef 
# 174
enum CUctx_flags_enum { 
# 175
CU_CTX_SCHED_AUTO, 
# 176
CU_CTX_SCHED_SPIN, 
# 177
CU_CTX_SCHED_YIELD, 
# 178
CU_CTX_SCHED_BLOCKING_SYNC = 4, 
# 179
CU_CTX_BLOCKING_SYNC = 4, 
# 180
CU_CTX_SCHED_MASK = 7, 
# 181
CU_CTX_MAP_HOST, 
# 182
CU_CTX_LMEM_RESIZE_TO_MAX = 16, 
# 183
CU_CTX_FLAGS_MASK = 31
# 184
} CUctx_flags; }
# 193
extern "C" { typedef 
# 189
enum CUevent_flags_enum { 
# 190
CU_EVENT_DEFAULT, 
# 191
CU_EVENT_BLOCKING_SYNC, 
# 192
CU_EVENT_DISABLE_TIMING
# 193
} CUevent_flags; }
# 207
extern "C" { typedef 
# 198
enum CUarray_format_enum { 
# 199
CU_AD_FORMAT_UNSIGNED_INT8 = 1, 
# 200
CU_AD_FORMAT_UNSIGNED_INT16, 
# 201
CU_AD_FORMAT_UNSIGNED_INT32, 
# 202
CU_AD_FORMAT_SIGNED_INT8 = 8, 
# 203
CU_AD_FORMAT_SIGNED_INT16, 
# 204
CU_AD_FORMAT_SIGNED_INT32, 
# 205
CU_AD_FORMAT_HALF = 16, 
# 206
CU_AD_FORMAT_FLOAT = 32
# 207
} CUarray_format; }
# 217
extern "C" { typedef 
# 212
enum CUaddress_mode_enum { 
# 213
CU_TR_ADDRESS_MODE_WRAP, 
# 214
CU_TR_ADDRESS_MODE_CLAMP, 
# 215
CU_TR_ADDRESS_MODE_MIRROR, 
# 216
CU_TR_ADDRESS_MODE_BORDER
# 217
} CUaddress_mode; }
# 225
extern "C" { typedef 
# 222
enum CUfilter_mode_enum { 
# 223
CU_TR_FILTER_MODE_POINT, 
# 224
CU_TR_FILTER_MODE_LINEAR
# 225
} CUfilter_mode; }
# 280
extern "C" { typedef 
# 230
enum CUdevice_attribute_enum { 
# 231
CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK = 1, 
# 232
CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X, 
# 233
CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Y, 
# 234
CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Z, 
# 235
CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X, 
# 236
CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Y, 
# 237
CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Z, 
# 238
CU_DEVICE_ATTRIBUTE_MAX_SHARED_MEMORY_PER_BLOCK, 
# 239
CU_DEVICE_ATTRIBUTE_SHARED_MEMORY_PER_BLOCK = 8, 
# 240
CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY, 
# 241
CU_DEVICE_ATTRIBUTE_WARP_SIZE, 
# 242
CU_DEVICE_ATTRIBUTE_MAX_PITCH, 
# 243
CU_DEVICE_ATTRIBUTE_MAX_REGISTERS_PER_BLOCK, 
# 244
CU_DEVICE_ATTRIBUTE_REGISTERS_PER_BLOCK = 12, 
# 245
CU_DEVICE_ATTRIBUTE_CLOCK_RATE, 
# 246
CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT, 
# 247
CU_DEVICE_ATTRIBUTE_GPU_OVERLAP, 
# 248
CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT, 
# 249
CU_DEVICE_ATTRIBUTE_KERNEL_EXEC_TIMEOUT, 
# 250
CU_DEVICE_ATTRIBUTE_INTEGRATED, 
# 251
CU_DEVICE_ATTRIBUTE_CAN_MAP_HOST_MEMORY, 
# 252
CU_DEVICE_ATTRIBUTE_COMPUTE_MODE, 
# 253
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_WIDTH, 
# 254
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_WIDTH, 
# 255
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_HEIGHT, 
# 256
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_WIDTH, 
# 257
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_HEIGHT, 
# 258
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_DEPTH, 
# 259
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_LAYERED_WIDTH, 
# 260
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_LAYERED_HEIGHT, 
# 261
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_LAYERED_LAYERS, 
# 262
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_WIDTH = 27, 
# 263
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_HEIGHT, 
# 264
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_NUMSLICES, 
# 265
CU_DEVICE_ATTRIBUTE_SURFACE_ALIGNMENT, 
# 266
CU_DEVICE_ATTRIBUTE_CONCURRENT_KERNELS, 
# 267
CU_DEVICE_ATTRIBUTE_ECC_ENABLED, 
# 268
CU_DEVICE_ATTRIBUTE_PCI_BUS_ID, 
# 269
CU_DEVICE_ATTRIBUTE_PCI_DEVICE_ID, 
# 270
CU_DEVICE_ATTRIBUTE_TCC_DRIVER, 
# 271
CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE, 
# 272
CU_DEVICE_ATTRIBUTE_GLOBAL_MEMORY_BUS_WIDTH, 
# 273
CU_DEVICE_ATTRIBUTE_L2_CACHE_SIZE, 
# 274
CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_MULTIPROCESSOR, 
# 275
CU_DEVICE_ATTRIBUTE_ASYNC_ENGINE_COUNT, 
# 276
CU_DEVICE_ATTRIBUTE_UNIFIED_ADDRESSING, 
# 277
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_LAYERED_WIDTH, 
# 278
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_LAYERED_LAYERS, 
# 279
CU_DEVICE_ATTRIBUTE_PCI_DOMAIN_ID = 50
# 280
} CUdevice_attribute; }
# 296
extern "C" { typedef 
# 285
struct CUdevprop_st { 
# 286
int maxThreadsPerBlock; 
# 287
int maxThreadsDim[3]; 
# 288
int maxGridSize[3]; 
# 289
int sharedMemPerBlock; 
# 290
int totalConstantMemory; 
# 291
int SIMDWidth; 
# 292
int memPitch; 
# 293
int regsPerBlock; 
# 294
int clockRate; 
# 295
int textureAlign; 
# 296
} CUdevprop; }
# 306
extern "C" { typedef 
# 301
enum CUpointer_attribute_enum { 
# 302
CU_POINTER_ATTRIBUTE_CONTEXT = 1, 
# 303
CU_POINTER_ATTRIBUTE_MEMORY_TYPE, 
# 304
CU_POINTER_ATTRIBUTE_DEVICE_POINTER, 
# 305
CU_POINTER_ATTRIBUTE_HOST_POINTER
# 306
} CUpointer_attribute; }
# 361
extern "C" { typedef 
# 311
enum CUfunction_attribute_enum { 
# 317
CU_FUNC_ATTRIBUTE_MAX_THREADS_PER_BLOCK, 
# 324
CU_FUNC_ATTRIBUTE_SHARED_SIZE_BYTES, 
# 330
CU_FUNC_ATTRIBUTE_CONST_SIZE_BYTES, 
# 335
CU_FUNC_ATTRIBUTE_LOCAL_SIZE_BYTES, 
# 340
CU_FUNC_ATTRIBUTE_NUM_REGS, 
# 349
CU_FUNC_ATTRIBUTE_PTX_VERSION, 
# 358
CU_FUNC_ATTRIBUTE_BINARY_VERSION, 
# 360
CU_FUNC_ATTRIBUTE_MAX
# 361
} CUfunction_attribute; }
# 370
extern "C" { typedef 
# 366
enum CUfunc_cache_enum { 
# 367
CU_FUNC_CACHE_PREFER_NONE, 
# 368
CU_FUNC_CACHE_PREFER_SHARED, 
# 369
CU_FUNC_CACHE_PREFER_L1
# 370
} CUfunc_cache; }
# 380
extern "C" { typedef 
# 375
enum CUmemorytype_enum { 
# 376
CU_MEMORYTYPE_HOST = 1, 
# 377
CU_MEMORYTYPE_DEVICE, 
# 378
CU_MEMORYTYPE_ARRAY, 
# 379
CU_MEMORYTYPE_UNIFIED
# 380
} CUmemorytype; }
# 390
extern "C" { typedef 
# 385
enum CUcomputemode_enum { 
# 386
CU_COMPUTEMODE_DEFAULT, 
# 387
CU_COMPUTEMODE_EXCLUSIVE, 
# 388
CU_COMPUTEMODE_PROHIBITED, 
# 389
CU_COMPUTEMODE_EXCLUSIVE_PROCESS
# 390
} CUcomputemode; }
# 482
extern "C" { typedef 
# 395
enum CUjit_option_enum { 
# 401
CU_JIT_MAX_REGISTERS, 
# 414
CU_JIT_THREADS_PER_BLOCK, 
# 421
CU_JIT_WALL_TIME, 
# 429
CU_JIT_INFO_LOG_BUFFER, 
# 437
CU_JIT_INFO_LOG_BUFFER_SIZE_BYTES, 
# 445
CU_JIT_ERROR_LOG_BUFFER, 
# 453
CU_JIT_ERROR_LOG_BUFFER_SIZE_BYTES, 
# 460
CU_JIT_OPTIMIZATION_LEVEL, 
# 467
CU_JIT_TARGET_FROM_CUCONTEXT, 
# 473
CU_JIT_TARGET, 
# 480
CU_JIT_FALLBACK_STRATEGY
# 482
} CUjit_option; }
# 495
extern "C" { typedef 
# 487
enum CUjit_target_enum { 
# 489
CU_TARGET_COMPUTE_10, 
# 490
CU_TARGET_COMPUTE_11, 
# 491
CU_TARGET_COMPUTE_12, 
# 492
CU_TARGET_COMPUTE_13, 
# 493
CU_TARGET_COMPUTE_20, 
# 494
CU_TARGET_COMPUTE_21
# 495
} CUjit_target; }
# 506
extern "C" { typedef 
# 500
enum CUjit_fallback_enum { 
# 502
CU_PREFER_PTX, 
# 504
CU_PREFER_BINARY
# 506
} CUjit_fallback; }
# 516
extern "C" { typedef 
# 511
enum CUgraphicsRegisterFlags_enum { 
# 512
CU_GRAPHICS_REGISTER_FLAGS_NONE, 
# 513
CU_GRAPHICS_REGISTER_FLAGS_READ_ONLY, 
# 514
CU_GRAPHICS_REGISTER_FLAGS_WRITE_DISCARD, 
# 515
CU_GRAPHICS_REGISTER_FLAGS_SURFACE_LDST = 4
# 516
} CUgraphicsRegisterFlags; }
# 525
extern "C" { typedef 
# 521
enum CUgraphicsMapResourceFlags_enum { 
# 522
CU_GRAPHICS_MAP_RESOURCE_FLAGS_NONE, 
# 523
CU_GRAPHICS_MAP_RESOURCE_FLAGS_READ_ONLY, 
# 524
CU_GRAPHICS_MAP_RESOURCE_FLAGS_WRITE_DISCARD
# 525
} CUgraphicsMapResourceFlags; }
# 537
extern "C" { typedef 
# 530
enum CUarray_cubemap_face_enum { 
# 531
CU_CUBEMAP_FACE_POSITIVE_X, 
# 532
CU_CUBEMAP_FACE_NEGATIVE_X, 
# 533
CU_CUBEMAP_FACE_POSITIVE_Y, 
# 534
CU_CUBEMAP_FACE_NEGATIVE_Y, 
# 535
CU_CUBEMAP_FACE_POSITIVE_Z, 
# 536
CU_CUBEMAP_FACE_NEGATIVE_Z
# 537
} CUarray_cubemap_face; }
# 546
extern "C" { typedef 
# 542
enum CUlimit_enum { 
# 543
CU_LIMIT_STACK_SIZE, 
# 544
CU_LIMIT_PRINTF_FIFO_SIZE, 
# 545
CU_LIMIT_MALLOC_HEAP_SIZE
# 546
} CUlimit; }
# 828
extern "C" { typedef 
# 551
enum cudaError_enum { 
# 557
CUDA_SUCCESS, 
# 563
CUDA_ERROR_INVALID_VALUE, 
# 569
CUDA_ERROR_OUT_OF_MEMORY, 
# 575
CUDA_ERROR_NOT_INITIALIZED, 
# 580
CUDA_ERROR_DEINITIALIZED, 
# 586
CUDA_ERROR_PROFILER_DISABLED, 
# 591
CUDA_ERROR_PROFILER_NOT_INITIALIZED, 
# 596
CUDA_ERROR_PROFILER_ALREADY_STARTED, 
# 601
CUDA_ERROR_PROFILER_ALREADY_STOPPED, 
# 606
CUDA_ERROR_NO_DEVICE = 100, 
# 612
CUDA_ERROR_INVALID_DEVICE, 
# 619
CUDA_ERROR_INVALID_IMAGE = 200, 
# 629
CUDA_ERROR_INVALID_CONTEXT, 
# 638
CUDA_ERROR_CONTEXT_ALREADY_CURRENT, 
# 643
CUDA_ERROR_MAP_FAILED = 205, 
# 648
CUDA_ERROR_UNMAP_FAILED, 
# 654
CUDA_ERROR_ARRAY_IS_MAPPED, 
# 659
CUDA_ERROR_ALREADY_MAPPED, 
# 667
CUDA_ERROR_NO_BINARY_FOR_GPU, 
# 672
CUDA_ERROR_ALREADY_ACQUIRED, 
# 677
CUDA_ERROR_NOT_MAPPED, 
# 683
CUDA_ERROR_NOT_MAPPED_AS_ARRAY, 
# 689
CUDA_ERROR_NOT_MAPPED_AS_POINTER, 
# 695
CUDA_ERROR_ECC_UNCORRECTABLE, 
# 701
CUDA_ERROR_UNSUPPORTED_LIMIT, 
# 708
CUDA_ERROR_CONTEXT_ALREADY_IN_USE, 
# 713
CUDA_ERROR_INVALID_SOURCE = 300, 
# 718
CUDA_ERROR_FILE_NOT_FOUND, 
# 723
CUDA_ERROR_SHARED_OBJECT_SYMBOL_NOT_FOUND, 
# 728
CUDA_ERROR_SHARED_OBJECT_INIT_FAILED, 
# 733
CUDA_ERROR_OPERATING_SYSTEM, 
# 740
CUDA_ERROR_INVALID_HANDLE = 400, 
# 747
CUDA_ERROR_NOT_FOUND = 500, 
# 756
CUDA_ERROR_NOT_READY = 600, 
# 767
CUDA_ERROR_LAUNCH_FAILED = 700, 
# 778
CUDA_ERROR_LAUNCH_OUT_OF_RESOURCES, 
# 789
CUDA_ERROR_LAUNCH_TIMEOUT, 
# 795
CUDA_ERROR_LAUNCH_INCOMPATIBLE_TEXTURING, 
# 802
CUDA_ERROR_PEER_ACCESS_ALREADY_ENABLED, 
# 809
CUDA_ERROR_PEER_ACCESS_NOT_ENABLED, 
# 815
CUDA_ERROR_PRIMARY_CONTEXT_ACTIVE = 708, 
# 822
CUDA_ERROR_CONTEXT_IS_DESTROYED, 
# 827
CUDA_ERROR_UNKNOWN = 999
# 828
} CUresult; }
# 890
extern "C" { typedef 
# 869
struct CUDA_MEMCPY2D_st { 
# 870
size_t srcXInBytes; 
# 871
size_t srcY; 
# 873
CUmemorytype srcMemoryType; 
# 874
const void *srcHost; 
# 875
CUdeviceptr srcDevice; 
# 876
CUarray srcArray; 
# 877
size_t srcPitch; 
# 879
size_t dstXInBytes; 
# 880
size_t dstY; 
# 882
CUmemorytype dstMemoryType; 
# 883
void *dstHost; 
# 884
CUdeviceptr dstDevice; 
# 885
CUarray dstArray; 
# 886
size_t dstPitch; 
# 888
size_t WidthInBytes; 
# 889
size_t Height; 
# 890
} CUDA_MEMCPY2D; }
# 923
extern "C" { typedef 
# 895
struct CUDA_MEMCPY3D_st { 
# 896
size_t srcXInBytes; 
# 897
size_t srcY; 
# 898
size_t srcZ; 
# 899
size_t srcLOD; 
# 900
CUmemorytype srcMemoryType; 
# 901
const void *srcHost; 
# 902
CUdeviceptr srcDevice; 
# 903
CUarray srcArray; 
# 904
void *reserved0; 
# 905
size_t srcPitch; 
# 906
size_t srcHeight; 
# 908
size_t dstXInBytes; 
# 909
size_t dstY; 
# 910
size_t dstZ; 
# 911
size_t dstLOD; 
# 912
CUmemorytype dstMemoryType; 
# 913
void *dstHost; 
# 914
CUdeviceptr dstDevice; 
# 915
CUarray dstArray; 
# 916
void *reserved1; 
# 917
size_t dstPitch; 
# 918
size_t dstHeight; 
# 920
size_t WidthInBytes; 
# 921
size_t Height; 
# 922
size_t Depth; 
# 923
} CUDA_MEMCPY3D; }
# 956
extern "C" { typedef 
# 928
struct CUDA_MEMCPY3D_PEER_st { 
# 929
size_t srcXInBytes; 
# 930
size_t srcY; 
# 931
size_t srcZ; 
# 932
size_t srcLOD; 
# 933
CUmemorytype srcMemoryType; 
# 934
const void *srcHost; 
# 935
CUdeviceptr srcDevice; 
# 936
CUarray srcArray; 
# 937
CUcontext srcContext; 
# 938
size_t srcPitch; 
# 939
size_t srcHeight; 
# 941
size_t dstXInBytes; 
# 942
size_t dstY; 
# 943
size_t dstZ; 
# 944
size_t dstLOD; 
# 945
CUmemorytype dstMemoryType; 
# 946
void *dstHost; 
# 947
CUdeviceptr dstDevice; 
# 948
CUarray dstArray; 
# 949
CUcontext dstContext; 
# 950
size_t dstPitch; 
# 951
size_t dstHeight; 
# 953
size_t WidthInBytes; 
# 954
size_t Height; 
# 955
size_t Depth; 
# 956
} CUDA_MEMCPY3D_PEER; }
# 968
extern "C" { typedef 
# 961
struct CUDA_ARRAY_DESCRIPTOR_st { 
# 963
size_t Width; 
# 964
size_t Height; 
# 966
CUarray_format Format; 
# 967
unsigned NumChannels; 
# 968
} CUDA_ARRAY_DESCRIPTOR; }
# 982
extern "C" { typedef 
# 973
struct CUDA_ARRAY3D_DESCRIPTOR_st { 
# 975
size_t Width; 
# 976
size_t Height; 
# 977
size_t Depth; 
# 979
CUarray_format Format; 
# 980
unsigned NumChannels; 
# 981
unsigned Flags; 
# 982
} CUDA_ARRAY3D_DESCRIPTOR; }
# 1095
extern "C" CUresult cuInit(unsigned ); 
# 1122
extern "C" CUresult cuDriverGetVersion(int * ); 
# 1160
extern "C" CUresult cuDeviceGet(CUdevice * , int ); 
# 1186
extern "C" CUresult cuDeviceGetCount(int * ); 
# 1215
extern "C" CUresult cuDeviceGetName(char * , int , CUdevice ); 
# 1244
extern "C" CUresult cuDeviceComputeCapability(int * , int * , CUdevice ); 
# 1272
extern "C" CUresult cuDeviceTotalMem_v2(size_t * , CUdevice ); 
# 1332
extern "C" CUresult cuDeviceGetProperties(CUdevprop * , CUdevice ); 
# 1444
extern "C" CUresult cuDeviceGetAttribute(int * , CUdevice_attribute , CUdevice ); 
# 1544
extern "C" CUresult cuCtxCreate_v2(CUcontext * , unsigned , CUdevice ); 
# 1583
extern "C" CUresult cuCtxDestroy_v2(CUcontext ); 
# 1633
extern "C" CUresult cuCtxAttach(CUcontext * , unsigned ); 
# 1668
extern "C" CUresult cuCtxDetach(CUcontext ); 
# 1704
extern "C" CUresult cuCtxPushCurrent_v2(CUcontext ); 
# 1737
extern "C" CUresult cuCtxPopCurrent_v2(CUcontext * ); 
# 1763
extern "C" CUresult cuCtxSetCurrent(CUcontext ); 
# 1782
extern "C" CUresult cuCtxGetCurrent(CUcontext * ); 
# 1811
extern "C" CUresult cuCtxGetDevice(CUdevice * ); 
# 1839
extern "C" CUresult cuCtxSynchronize(); 
# 1900
extern "C" CUresult cuCtxSetLimit(CUlimit , size_t ); 
# 1933
extern "C" CUresult cuCtxGetLimit(size_t * , CUlimit ); 
# 1974
extern "C" CUresult cuCtxGetCacheConfig(CUfunc_cache * ); 
# 2022
extern "C" CUresult cuCtxSetCacheConfig(CUfunc_cache ); 
# 2057
extern "C" CUresult cuCtxGetApiVersion(CUcontext , unsigned * ); 
# 2106
extern "C" CUresult cuModuleLoad(CUmodule * , const char * ); 
# 2140
extern "C" CUresult cuModuleLoadData(CUmodule * , const void * ); 
# 2219
extern "C" CUresult cuModuleLoadDataEx(CUmodule * , const void * , unsigned , CUjit_option * , void ** ); 
# 2259
extern "C" CUresult cuModuleLoadFatBinary(CUmodule * , const void * ); 
# 2284
extern "C" CUresult cuModuleUnload(CUmodule ); 
# 2314
extern "C" CUresult cuModuleGetFunction(CUfunction * , CUmodule , const char * ); 
# 2348
extern "C" CUresult cuModuleGetGlobal_v2(CUdeviceptr * , size_t * , CUmodule , const char * ); 
# 2382
extern "C" CUresult cuModuleGetTexRef(CUtexref * , CUmodule , const char * ); 
# 2413
extern "C" CUresult cuModuleGetSurfRef(CUsurfref * , CUmodule , const char * ); 
# 2456
extern "C" CUresult cuMemGetInfo_v2(size_t * , size_t * ); 
# 2489
extern "C" CUresult cuMemAlloc_v2(CUdeviceptr * , size_t ); 
# 2550
extern "C" CUresult cuMemAllocPitch_v2(CUdeviceptr * , size_t * , size_t , size_t , unsigned ); 
# 2579
extern "C" CUresult cuMemFree_v2(CUdeviceptr ); 
# 2612
extern "C" CUresult cuMemGetAddressRange_v2(CUdeviceptr * , size_t * , CUdeviceptr ); 
# 2658
extern "C" CUresult cuMemAllocHost_v2(void ** , size_t ); 
# 2688
extern "C" CUresult cuMemFreeHost(void * ); 
# 2770
extern "C" CUresult cuMemHostAlloc(void ** , size_t , unsigned ); 
# 2808
extern "C" CUresult cuMemHostGetDevicePointer_v2(CUdeviceptr * , void * , unsigned ); 
# 2833
extern "C" CUresult cuMemHostGetFlags(unsigned * , void * ); 
# 2896
extern "C" CUresult cuMemHostRegister(void * , size_t , unsigned ); 
# 2919
extern "C" CUresult cuMemHostUnregister(void * ); 
# 2955
extern "C" CUresult cuMemcpy(CUdeviceptr , CUdeviceptr , size_t ); 
# 2988
extern "C" CUresult cuMemcpyPeer(CUdeviceptr , CUcontext , CUdeviceptr , CUcontext , size_t ); 
# 3026
extern "C" CUresult cuMemcpyHtoD_v2(CUdeviceptr , const void * , size_t ); 
# 3059
extern "C" CUresult cuMemcpyDtoH_v2(void * , CUdeviceptr , size_t ); 
# 3092
extern "C" CUresult cuMemcpyDtoD_v2(CUdeviceptr , CUdeviceptr , size_t ); 
# 3126
extern "C" CUresult cuMemcpyDtoA_v2(CUarray , size_t , CUdeviceptr , size_t ); 
# 3162
extern "C" CUresult cuMemcpyAtoD_v2(CUdeviceptr , CUarray , size_t , size_t ); 
# 3196
extern "C" CUresult cuMemcpyHtoA_v2(CUarray , size_t , const void * , size_t ); 
# 3230
extern "C" CUresult cuMemcpyAtoH_v2(void * , CUarray , size_t , size_t ); 
# 3268
extern "C" CUresult cuMemcpyAtoA_v2(CUarray , size_t , CUarray , size_t , size_t ); 
# 3428
extern "C" CUresult cuMemcpy2D_v2(const CUDA_MEMCPY2D * ); 
# 3586
extern "C" CUresult cuMemcpy2DUnaligned_v2(const CUDA_MEMCPY2D * ); 
# 3753
extern "C" CUresult cuMemcpy3D_v2(const CUDA_MEMCPY3D * ); 
# 3784
extern "C" CUresult cuMemcpy3DPeer(const CUDA_MEMCPY3D_PEER * ); 
# 3824
extern "C" CUresult cuMemcpyAsync(CUdeviceptr , CUdeviceptr , size_t , CUstream ); 
# 3855
extern "C" CUresult cuMemcpyPeerAsync(CUdeviceptr , CUcontext , CUdeviceptr , CUcontext , size_t , CUstream ); 
# 3897
extern "C" CUresult cuMemcpyHtoDAsync_v2(CUdeviceptr , const void * , size_t , CUstream ); 
# 3937
extern "C" CUresult cuMemcpyDtoHAsync_v2(void * , CUdeviceptr , size_t , CUstream ); 
# 3974
extern "C" CUresult cuMemcpyDtoDAsync_v2(CUdeviceptr , CUdeviceptr , size_t , CUstream ); 
# 4016
extern "C" CUresult cuMemcpyHtoAAsync_v2(CUarray , size_t , const void * , size_t , CUstream ); 
# 4058
extern "C" CUresult cuMemcpyAtoHAsync_v2(void * , CUarray , size_t , size_t , CUstream ); 
# 4229
extern "C" CUresult cuMemcpy2DAsync_v2(const CUDA_MEMCPY2D * , CUstream ); 
# 4404
extern "C" CUresult cuMemcpy3DAsync_v2(const CUDA_MEMCPY3D * , CUstream ); 
# 4429
extern "C" CUresult cuMemcpy3DPeerAsync(const CUDA_MEMCPY3D_PEER * , CUstream ); 
# 4464
extern "C" CUresult cuMemsetD8_v2(CUdeviceptr , unsigned char , size_t ); 
# 4497
extern "C" CUresult cuMemsetD16_v2(CUdeviceptr , unsigned short , size_t ); 
# 4530
extern "C" CUresult cuMemsetD32_v2(CUdeviceptr , unsigned , size_t ); 
# 4568
extern "C" CUresult cuMemsetD2D8_v2(CUdeviceptr , size_t , unsigned char , size_t , size_t ); 
# 4606
extern "C" CUresult cuMemsetD2D16_v2(CUdeviceptr , size_t , unsigned short , size_t , size_t ); 
# 4644
extern "C" CUresult cuMemsetD2D32_v2(CUdeviceptr , size_t , unsigned , size_t , size_t ); 
# 4681
extern "C" CUresult cuMemsetD8Async(CUdeviceptr , unsigned char , size_t , CUstream ); 
# 4718
extern "C" CUresult cuMemsetD16Async(CUdeviceptr , unsigned short , size_t , CUstream ); 
# 4754
extern "C" CUresult cuMemsetD32Async(CUdeviceptr , unsigned , size_t , CUstream ); 
# 4796
extern "C" CUresult cuMemsetD2D8Async(CUdeviceptr , size_t , unsigned char , size_t , size_t , CUstream ); 
# 4838
extern "C" CUresult cuMemsetD2D16Async(CUdeviceptr , size_t , unsigned short , size_t , size_t , CUstream ); 
# 4880
extern "C" CUresult cuMemsetD2D32Async(CUdeviceptr , size_t , unsigned , size_t , size_t , CUstream ); 
# 4983
extern "C" CUresult cuArrayCreate_v2(CUarray * , const CUDA_ARRAY_DESCRIPTOR * ); 
# 5016
extern "C" CUresult cuArrayGetDescriptor_v2(CUDA_ARRAY_DESCRIPTOR * , CUarray ); 
# 5047
extern "C" CUresult cuArrayDestroy(CUarray ); 
# 5155
extern "C" CUresult cuArray3DCreate_v2(CUarray * , const CUDA_ARRAY3D_DESCRIPTOR * ); 
# 5191
extern "C" CUresult cuArray3DGetDescriptor_v2(CUDA_ARRAY3D_DESCRIPTOR * , CUarray ); 
# 5398
extern "C" CUresult cuPointerGetAttribute(void * , CUpointer_attribute , CUdeviceptr ); 
# 5435
extern "C" CUresult cuStreamCreate(CUstream * , unsigned ); 
# 5477
extern "C" CUresult cuStreamWaitEvent(CUstream , CUevent , unsigned ); 
# 5501
extern "C" CUresult cuStreamQuery(CUstream ); 
# 5526
extern "C" CUresult cuStreamSynchronize(CUstream ); 
# 5554
extern "C" CUresult cuStreamDestroy_v2(CUstream ); 
# 5603
extern "C" CUresult cuEventCreate(CUevent * , unsigned ); 
# 5641
extern "C" CUresult cuEventRecord(CUevent , CUstream ); 
# 5672
extern "C" CUresult cuEventQuery(CUevent ); 
# 5706
extern "C" CUresult cuEventSynchronize(CUevent ); 
# 5735
extern "C" CUresult cuEventDestroy_v2(CUevent ); 
# 5779
extern "C" CUresult cuEventElapsedTime(float * , CUevent , CUevent ); 
# 5842
extern "C" CUresult cuFuncGetAttribute(int * , CUfunction_attribute , CUfunction ); 
# 5883
extern "C" CUresult cuFuncSetCacheConfig(CUfunction , CUfunc_cache ); 
# 5999
extern "C" CUresult cuLaunchKernel(CUfunction , unsigned , unsigned , unsigned , unsigned , unsigned , unsigned , unsigned , CUstream , void ** , void ** ); 
# 6055
extern "C" CUresult cuFuncSetBlockShape(CUfunction , int , int , int ); 
# 6089
extern "C" CUresult cuFuncSetSharedSize(CUfunction , unsigned ); 
# 6121
extern "C" CUresult cuParamSetSize(CUfunction , unsigned ); 
# 6154
extern "C" CUresult cuParamSeti(CUfunction , int , unsigned ); 
# 6187
extern "C" CUresult cuParamSetf(CUfunction , int , float ); 
# 6222
extern "C" CUresult cuParamSetv(CUfunction , int , void * , unsigned ); 
# 6259
extern "C" CUresult cuLaunch(CUfunction ); 
# 6298
extern "C" CUresult cuLaunchGrid(CUfunction , int , int ); 
# 6342
extern "C" CUresult cuLaunchGridAsync(CUfunction , int , int , CUstream ); 
# 6367
extern "C" CUresult cuParamSetTexRef(CUfunction , int , CUtexref ); 
# 6408
extern "C" CUresult cuTexRefSetArray(CUtexref , CUarray , unsigned ); 
# 6446
extern "C" CUresult cuTexRefSetAddress_v2(size_t * , CUtexref , CUdeviceptr , size_t ); 
# 6487
extern "C" CUresult cuTexRefSetAddress2D_v2(CUtexref , const CUDA_ARRAY_DESCRIPTOR * , CUdeviceptr , size_t ); 
# 6516
extern "C" CUresult cuTexRefSetFormat(CUtexref , CUarray_format , int ); 
# 6556
extern "C" CUresult cuTexRefSetAddressMode(CUtexref , int , CUaddress_mode ); 
# 6589
extern "C" CUresult cuTexRefSetFilterMode(CUtexref , CUfilter_mode ); 
# 6621
extern "C" CUresult cuTexRefSetFlags(CUtexref , unsigned ); 
# 6647
extern "C" CUresult cuTexRefGetAddress_v2(CUdeviceptr * , CUtexref ); 
# 6673
extern "C" CUresult cuTexRefGetArray(CUarray * , CUtexref ); 
# 6699
extern "C" CUresult cuTexRefGetAddressMode(CUaddress_mode * , CUtexref , int ); 
# 6723
extern "C" CUresult cuTexRefGetFilterMode(CUfilter_mode * , CUtexref ); 
# 6749
extern "C" CUresult cuTexRefGetFormat(CUarray_format * , int * , CUtexref ); 
# 6772
extern "C" CUresult cuTexRefGetFlags(unsigned * , CUtexref ); 
# 6806
extern "C" CUresult cuTexRefCreate(CUtexref * ); 
# 6826
extern "C" CUresult cuTexRefDestroy(CUtexref ); 
# 6864
extern "C" CUresult cuSurfRefSetArray(CUsurfref , CUarray , unsigned ); 
# 6885
extern "C" CUresult cuSurfRefGetArray(CUarray * , CUsurfref ); 
# 6923
extern "C" CUresult cuDeviceCanAccessPeer(int * , CUdevice , CUdevice ); 
# 6966
extern "C" CUresult cuCtxEnablePeerAccess(CUcontext , unsigned ); 
# 6991
extern "C" CUresult cuCtxDisablePeerAccess(CUcontext ); 
# 7032
extern "C" CUresult cuGraphicsUnregisterResource(CUgraphicsResource ); 
# 7070
extern "C" CUresult cuGraphicsSubResourceGetMappedArray(CUarray * , CUgraphicsResource , unsigned , unsigned ); 
# 7104
extern "C" CUresult cuGraphicsResourceGetMappedPointer_v2(CUdeviceptr * , size_t * , CUgraphicsResource ); 
# 7145
extern "C" CUresult cuGraphicsResourceSetMapFlags(CUgraphicsResource , unsigned ); 
# 7183
extern "C" CUresult cuGraphicsMapResources(unsigned , CUgraphicsResource * , CUstream ); 
# 7218
extern "C" CUresult cuGraphicsUnmapResources(unsigned , CUgraphicsResource * , CUstream ); 
# 7222
extern "C" CUresult cuGetExportTable(const void ** , const CUuuid * ); 
# 60 "/home/u0332192/local/GPU_SDK/C/common/inc/cutil.h"
enum CUTBoolean { 
# 62
CUTFalse, 
# 63
CUTTrue
# 64
}; 
# 72
extern "C" void cutFree(void * ); 
# 90
extern "C" void cutCheckBankAccess(unsigned , unsigned , unsigned , unsigned , unsigned , unsigned , const char * , const int , const char * , const int ); 
# 103
extern "C" char *cutFindFilePath(const char * , const char * ); 
# 118
extern "C" CUTBoolean cutReadFilef(const char * , float ** , unsigned * , bool  = false); 
# 134
extern "C" CUTBoolean cutReadFiled(const char * , double ** , unsigned * , bool  = false); 
# 150
extern "C" CUTBoolean cutReadFilei(const char * , int ** , unsigned * , bool  = false); 
# 165
extern "C" CUTBoolean cutReadFileui(const char * , unsigned ** , unsigned * , bool  = false); 
# 181
extern "C" CUTBoolean cutReadFileb(const char * , char ** , unsigned * , bool  = false); 
# 197
extern "C" CUTBoolean cutReadFileub(const char * , unsigned char ** , unsigned * , bool  = false); 
# 211
extern "C" CUTBoolean cutWriteFilef(const char * , const float * , unsigned , const float , bool  = false); 
# 225
extern "C" CUTBoolean cutWriteFiled(const char * , const float * , unsigned , const double , bool  = false); 
# 237
extern "C" CUTBoolean cutWriteFilei(const char * , const int * , unsigned , bool  = false); 
# 249
extern "C" CUTBoolean cutWriteFileui(const char * , const unsigned * , unsigned , bool  = false); 
# 261
extern "C" CUTBoolean cutWriteFileb(const char * , const char * , unsigned , bool  = false); 
# 273
extern "C" CUTBoolean cutWriteFileub(const char * , const unsigned char * , unsigned , bool  = false); 
# 289
extern "C" CUTBoolean cutLoadPGMub(const char * , unsigned char ** , unsigned * , unsigned * ); 
# 302
extern "C" CUTBoolean cutLoadPPMub(const char * , unsigned char ** , unsigned * , unsigned * ); 
# 316
extern "C" CUTBoolean cutLoadPPM4ub(const char * , unsigned char ** , unsigned * , unsigned * ); 
# 332
extern "C" CUTBoolean cutLoadPGMi(const char * , unsigned ** , unsigned * , unsigned * ); 
# 348
extern "C" CUTBoolean cutLoadPGMs(const char * , unsigned short ** , unsigned * , unsigned * ); 
# 363
extern "C" CUTBoolean cutLoadPGMf(const char * , float ** , unsigned * , unsigned * ); 
# 375
extern "C" CUTBoolean cutSavePGMub(const char * , unsigned char * , unsigned , unsigned ); 
# 387
extern "C" CUTBoolean cutSavePPMub(const char * , unsigned char * , unsigned , unsigned ); 
# 400
extern "C" CUTBoolean cutSavePPM4ub(const char * , unsigned char * , unsigned , unsigned ); 
# 412
extern "C" CUTBoolean cutSavePGMi(const char * , unsigned * , unsigned , unsigned ); 
# 424
extern "C" CUTBoolean cutSavePGMs(const char * , unsigned short * , unsigned , unsigned ); 
# 436
extern "C" CUTBoolean cutSavePGMf(const char * , float * , unsigned , unsigned ); 
# 457
extern "C" CUTBoolean cutCheckCmdLineFlag(const int , const char ** , const char * ); 
# 471
extern "C" CUTBoolean cutGetCmdLineArgumenti(const int , const char ** , const char * , int * ); 
# 485
extern "C" CUTBoolean cutGetCmdLineArgumentf(const int , const char ** , const char * , float * ); 
# 499
extern "C" CUTBoolean cutGetCmdLineArgumentstr(const int , const char ** , const char * , char ** ); 
# 514
extern "C" CUTBoolean cutGetCmdLineArgumentListstr(const int , const char ** , const char * , char ** , unsigned * ); 
# 528
extern "C" CUTBoolean cutCheckCondition(int , const char * , const int ); 
# 540
extern "C" CUTBoolean cutComparef(const float * , const float * , const unsigned ); 
# 553
extern "C" CUTBoolean cutComparei(const int * , const int * , const unsigned ); 
# 567
extern "C" CUTBoolean cutCompareuit(const unsigned * , const unsigned * , const unsigned , const float , const float ); 
# 580
extern "C" CUTBoolean cutCompareub(const unsigned char * , const unsigned char * , const unsigned ); 
# 595
extern "C" CUTBoolean cutCompareubt(const unsigned char * , const unsigned char * , const unsigned , const float , const float ); 
# 609
extern "C" CUTBoolean cutCompareube(const unsigned char * , const unsigned char * , const unsigned , const float ); 
# 623
extern "C" CUTBoolean cutComparefe(const float * , const float * , const unsigned , const float ); 
# 638
extern "C" CUTBoolean cutComparefet(const float * , const float * , const unsigned , const float , const float ); 
# 653
extern "C" CUTBoolean cutCompareL2fe(const float * , const float * , const unsigned , const float ); 
# 668
extern "C" CUTBoolean cutComparePPM(const char * , const char * , const float , const float , bool  = false); 
# 681
extern "C" CUTBoolean cutCreateTimer(unsigned * ); 
# 690
extern "C" CUTBoolean cutDeleteTimer(unsigned ); 
# 698
extern "C" CUTBoolean cutStartTimer(const unsigned ); 
# 706
extern "C" CUTBoolean cutStopTimer(const unsigned ); 
# 714
extern "C" CUTBoolean cutResetTimer(const unsigned ); 
# 723
extern "C" float cutGetTimerValue(const unsigned ); 
# 734
extern "C" float cutGetAverageTimerValue(const unsigned ); 
# 10 "hashtab.h"
typedef 
# 6
struct hashtab { 
# 7
int num_variable; 
# 8
int num_constraint; 
# 9
char *ht; 
# 10
} hash_tab; 
# 12
hash_tab *init_hsahtab(int , int , char * ); 
# 13
char *get_element(hash_tab * , int , int ); 
# 14
int put_element(hash_tab * , int , char * ); 
# 6 "cu_lib.h"
extern "C" void solver_constraint_wrapper(hash_tab * , char * ); 
# 16 "cu_lib.cu"
__attribute__((unused)) int get_hash_from_char(char c) {int volatile ___ = 1;(void)c;
# 25
exit(___);}
#if 0
# 16
{ 
# 17
if (((c >= ('a')) && (c <= ('b'))) && ((c >= ('A')) && (c <= ('Z')))) { 
# 18
if ((c >= ('A')) && (c <= ('Z'))) { 
# 19
return (((c - ('A')) + ('a')) - ('a')) + 26; 
# 20
} else { 
# 21
return c - ('a'); 
# 22
}  
# 23
}  
# 24
return -1; 
# 25
} 
#endif
# 27 "cu_lib.cu"
__attribute__((unused)) int hashfunc(char *to) {int volatile ___ = 1;(void)to;
# 39
exit(___);}
#if 0
# 27
{ 
# 28
int v1 = get_hash_from_char(*to); 
# 29
if (v1 == (-1)) { return -1; }  
# 30
if (((*(to + 1)) == (' ')) || ((*(to + 1)) == ('\000'))) 
# 31
{ 
# 32
return v1; 
# 33
}  
# 35
int v2 = get_hash_from_char(*(to + 1)); 
# 36
if (v2 == (-1)) { return -1; }  
# 38
return ((1 + v1) * 52) + v2; 
# 39
} 
#endif
# 43 "cu_lib.cu"
__attribute__((unused)) char *get_element2(char *h, int num_var, int key, int index) {int volatile ___ = 1;(void)h;(void)num_var;(void)key;(void)index;
# 47
exit(___);}
#if 0
# 43
{ 
# 44
int row = ((key + (index * num_var)) * 8); 
# 45
char *elem_addr = (h + row); 
# 46
return elem_addr; 
# 47
} 
#endif
# 50 "cu_lib.cu"
char *get_element3(char *h, int num_var, int key, int index) { 
# 51
int row = ((key + (index * num_var)) * 8); 
# 52
char *elem_addr = (h + row); 
# 53
return elem_addr; 
# 54
} 
# 56
__attribute__((unused)) int put_element2(char *h, int num_var, int num_const, int key, char *constraint, int flag) {int volatile ___ = 1;(void)h;(void)num_var;(void)num_const;(void)key;(void)constraint;(void)flag;
# 70
exit(___);}
#if 0
# 56
{ 
# 57
int i; 
# 59
for (i = 0; i < num_const; i++) { 
# 60
int row = ((key + (i * num_var)) * 8); 
# 61
char *temp = (h + row); 
# 62
if ((*temp) == ('\000')) { 
# 64
memcpy(temp, constraint, 8); 
# 66
return 1; 
# 67
}  
# 68
}  
# 69
return -1; 
# 70
} 
#endif
# 73 "cu_lib.cu"
__attribute__((unused)) void memcopy(char *dest, char *sour, int size) {int volatile ___ = 1;(void)dest;(void)sour;(void)size;
# 78
exit(___);}
#if 0
# 73
{ 
# 74
int i; 
# 75
for (i = 0; i < size; i++) { 
# 76
(dest[i]) = (sour[i]); }  
# 78
} 
#endif
# 81 "cu_lib.cu"
extern "C" void init_constraints_kernel(char *constraints, int num_var, int num_const, const int size_constraint, char *new_constraints, char *analysis, int *empty_contraint) ;
#if 0
# 81
{ 
# 82
int idx = (threadIdx.x); 
# 83
int idy = (threadIdx.y); 
# 85
char *a_constraint = get_element2(constraints, num_var, idx, idy); 
# 87
int pos = ((idx + (idy * num_var)) * size_constraint); 
# 88
if (((constraints[pos]) == ('_')) && ((((constraints[pos + 1]) == ('v')) || ((constraints[pos + 1]) == ('c'))) || ((constraints[pos + 1]) == ('l')))) { 
# 89
memcpy(analysis + pos, a_constraint, size_constraint); 
# 90
} else { 
# 91
memcpy(new_constraints + pos, a_constraint, size_constraint); 
# 92
(*empty_contraint) = 0; 
# 93
}  
# 94
__syncthreads(); 
# 95
} 
#endif
# 100 "cu_lib.cu"
extern "C" void solve_constraints_kernel(char *reflection, char *constraint, int num_var, int num_const, char *new_constraints, char *analysis, int *empty_constraint, char *out1, char *out2) ;
#if 0
# 100
{ 
# 101
__attribute__((unused)) static char sh_constraints[(104 * 3) * 8]; 
# 102
register char n_const[8]; 
# 103
register char n_const2[8]; 
# 104
register char value[8]; 
# 106
int idx = (threadIdx.x); 
# 107
int idy = (threadIdx.y); 
# 108
int i; 
# 111
char *sharemem_addr = (sh_constraints); 
# 112
sharemem_addr = ((sharemem_addr + ((idx * 8) * 104)) + (idy * 8)); 
# 113
memcpy(sharemem_addr, get_element2(constraint, num_var, idx, idy), 8); 
# 115
memcpy(out1, sharemem_addr, 8); 
# 116
for (i = 0; i < num_const; i++) { 
# 117
memcopy(value, get_element2(analysis, num_var, idx, i), 8); 
# 119
if ((*(value)) != ('\000')) { 
# 120
memset(n_const, '\000', 8); 
# 121
memset(n_const2, '\000', 8); 
# 122
if ((((*sharemem_addr) == ('_')) && ((*(sharemem_addr + 1)) == ('P'))) && ((((value)[0]) == ('_')) && (((value)[1]) == ('v')))) { 
# 123
int index = hashfunc(sharemem_addr + 2); 
# 124
memcpy(n_const, value, 8); 
# 125
put_element2(analysis, num_var, num_const, index, n_const, 0); 
# 126
int j; 
# 127
for (j = 0; j < num_const; j++) { 
# 128
char *c = get_element2(reflection, num_var, index, j); 
# 129
if ((*c) != ('\000')) { 
# 130
put_element2(new_constraints, num_var, num_const, index, c, 1); 
# 131
(*empty_constraint) = 0; 
# 132
}  
# 133
}  
# 134
} else { if ((((*sharemem_addr) == ('_')) && ((*(sharemem_addr + 1)) == ('C'))) && ((((value)[0]) == ('_')) && (((value)[1]) == ('c')))) { 
# 135
int index = hashfunc((value) + 2); 
# 136
((n_const)[0]) = '_'; 
# 137
((n_const)[1]) = 'P'; 
# 138
memcpy((n_const) + 2, sharemem_addr + 2, 6); 
# 139
put_element2(new_constraints, num_var, num_const, index, n_const, 1); 
# 140
(*empty_constraint) = 0; 
# 141
} else { if ((((*sharemem_addr) == ('_')) && ((*(sharemem_addr + 1)) == ('D'))) && ((((value)[0]) == ('_')) && (((value)[1]) == ('c')))) { 
# 142
int index = hashfunc((value) + 4); 
# 143
((n_const)[0]) = '_'; 
# 144
((n_const)[1]) = 'P'; 
# 145
memcpy((n_const) + 2, sharemem_addr + 2, 6); 
# 146
put_element2(new_constraints, num_var, num_const, index, n_const, 0); 
# 147
(*empty_constraint) = 0; 
# 148
} else { if ((((*sharemem_addr) == ('_')) && ((*(sharemem_addr + 1)) == ('A'))) && ((((value)[0]) == ('_')) && (((value)[1]) == ('l')))) { 
# 149
int index1 = hashfunc((value) + 6); 
# 150
int index2 = hashfunc(sharemem_addr + 4); 
# 151
((n_const)[0]) = '_'; 
# 152
((n_const2)[0]) = '_'; 
# 153
((n_const)[1]) = 'P'; 
# 154
((n_const2)[1]) = 'P'; 
# 155
memcopy((n_const) + 2, sharemem_addr + 2, 2); 
# 156
memcopy((n_const2) + 2, (value) + 2, 2); 
# 157
put_element2(new_constraints, num_var, num_const, index1, n_const, 1); 
# 158
put_element2(new_constraints, num_var, num_const, index2, n_const2, 1); 
# 159
memcopy(out1, n_const, 8); 
# 160
memcopy(out2, n_const2, 8); 
# 161
(*empty_constraint) = 0; 
# 162
} else { if ((((*sharemem_addr) == ('_')) && ((*(sharemem_addr + 1)) == ('A'))) && ((((value)[0]) == ('_')) && (((value)[1]) == ('t')))) { 
# 163
int index = hashfunc(sharemem_addr + 4); 
# 164
((n_const)[0]) = '_'; 
# 165
((n_const)[1]) = 'P'; 
# 166
memcpy((n_const) + 2, (value) + 2, 6); 
# 167
put_element2(new_constraints, num_var, num_const, index, n_const, 1); 
# 168
(*empty_constraint) = 0; 
# 169
} else { 
# 171
}  }  }  }  }  
# 172
}  
# 173
}  
# 175
__syncthreads(); 
# 176
} 
#endif
# 180 "cu_lib.cu"
void print_memory(char *dish, int szx, int szy, int szelt) 
# 181
{ 
# 182
int i, j, k, pos; 
# 183
for (i = 0; i < szx; i++) { 
# 184
for (j = 0; j < szy; j++) { 
# 185
pos = (((j * szx) + i) * szelt); 
# 186
printf("[%d,%d]\t", i, j); 
# 187
for (k = 0; k < szelt; k++) { 
# 188
printf("%c", dish[pos + k]); }  
# 189
printf("\t"); 
# 190
}  
# 191
printf("\n"); 
# 192
}  
# 193
printf("\n"); 
# 194
} 
# 197
void solver_constraint_wrapper(hash_tab *c, char *out_analysis) { 
# 198
int num_var = (c->num_variable); 
# 199
int num_const = (c->num_constraint); 
# 200
int size = ((num_var * num_const) * 8); 
# 201
char *c_array; 
# 202
char *c_new_array; 
# 203
char *analysis; 
# 204
char *reflection; 
# 205
char *temp; 
# 213
unsigned timer = (0); 
# 215
{ cudaError err = cudaMalloc((void **)(&c_array), size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 215, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 216
{ cudaError err = cudaMalloc((void **)(&c_new_array), size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 216, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 217
{ cudaError err = cudaMalloc((void **)(&analysis), size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 217, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 218
{ cudaError err = cudaMalloc((void **)(&reflection), size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 218, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 221
temp = ((char *)malloc(size)); 
# 222
memset(temp, '\000', size); 
# 224
{ cudaError err = cudaMemcpy(c_array, c->ht, size, cudaMemcpyHostToDevice); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 224, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 225
{ cudaError err = cudaMemset(c_new_array, '\000', size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 225, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 226
{ cudaError err = cudaMemset(analysis, '\000', size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 226, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 228
dim3 threads(104, 3); 
# 229
dim3 grid(1); 
# 231
int empty_const = 1; 
# 232
int *d_empty_const; 
# 233
int size_int = (sizeof(int)); 
# 235
{ cudaError err = cudaMalloc((void **)(&d_empty_const), size_int); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 235, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 236
{ cudaError err = cudaMemcpy(d_empty_const, &empty_const, size_int, cudaMemcpyHostToDevice); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 236, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 238
if ((CUTTrue) != (cutCreateTimer(&timer))) { fprintf(stderr, "Cut error in file \'%s\' in line %i.\n", "cu_lib.cu", 238); exit(1); }  ; 
# 239
if ((CUTTrue) != (cutStartTimer(timer))) { fprintf(stderr, "Cut error in file \'%s\' in line %i.\n", "cu_lib.cu", 239); exit(1); }  ; 
# 242
cudaConfigureCall(grid, threads) ? ((void)0) : init_constraints_kernel(c_array, num_var, num_const, 8, c_new_array, analysis, d_empty_const); 
# 244
{ cudaError err = cudaMemcpy(&empty_const, d_empty_const, 4, cudaMemcpyDeviceToHost); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 244, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 245
{ cudaError err = cudaMemcpy(reflection, c_new_array, size, cudaMemcpyDeviceToDevice); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 245, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 249
{ cudaError err = cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 249, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 252
char *out_c_new_array; 
# 253
char *out1, *out2; 
# 255
char *o1, *o2; 
# 257
o1 = ((char *)malloc(9)); 
# 258
o2 = ((char *)malloc(9)); 
# 259
bzero(o1, 9); 
# 260
bzero(o2, 9); 
# 261
cudaMalloc(&out1, 8); 
# 262
cudaMalloc(&out2, 8); 
# 264
while (!(empty_const)) { 
# 265
empty_const = 1; 
# 266
{ cudaError err = cudaMemcpy(d_empty_const, &empty_const, size_int, cudaMemcpyHostToDevice); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 266, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 268
{ cudaError err = cudaMalloc(&out_c_new_array, size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 268, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 269
{ cudaError err = cudaMemset(out_c_new_array, '\000', size); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 269, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 272
cudaConfigureCall(grid, threads) ? ((void)0) : solve_constraints_kernel(reflection, c_new_array, num_var, num_const, out_c_new_array, analysis, d_empty_const, out1, out2); 
# 273
{ cudaError err = cudaMemcpy(&empty_const, d_empty_const, size_int, cudaMemcpyDeviceToHost); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 273, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 276
cudaMemcpy(temp, out_c_new_array, size, cudaMemcpyDeviceToHost); 
# 279
cudaFree(c_new_array); 
# 281
c_new_array = out_c_new_array; 
# 282
out_c_new_array = (__null); 
# 289
cudaMemcpy(temp, c_new_array, size, cudaMemcpyDeviceToHost); 
# 291
}  
# 294
if ((CUTTrue) != (cutStopTimer(timer))) { fprintf(stderr, "Cut error in file \'%s\' in line %i.\n", "cu_lib.cu", 294); exit(1); }  ; 
# 295
printf("Processing time:%f (ms)\n", cutGetTimerValue(timer)); 
# 296
if ((CUTTrue) != (cutDeleteTimer(timer))) { fprintf(stderr, "Cut error in file \'%s\' in line %i.\n", "cu_lib.cu", 296); exit(1); }  ; 
# 298
cudaMemcpy(o1, out1, 8, cudaMemcpyDeviceToHost); 
# 299
cudaMemcpy(o2, out2, 8, cudaMemcpyDeviceToHost); 
# 305
{ cudaError err = cudaMemcpy(out_analysis, analysis, size, cudaMemcpyDeviceToHost); if ((cudaSuccess) != err) { fprintf(stderr, "Cuda error in file \'%s\' in line %i : %s.\n", "cu_lib.cu", 305, cudaGetErrorString(err)); exit(1); }  } ; ; 
# 306
printf("\nSOLUTIONS=========\n"); 
# 307
print_memory(out_analysis, 104, 3, 8); 
# 308
cudaFree(c_array); 
# 309
cudaFree(c_new_array); 
# 310
cudaFree(analysis); 
# 312
cudaFree(out_c_new_array); 
# 314
} 
# 1 "cu_lib.cudafe1.stub.c"
#include "cu_lib.cudafe1.stub.c"
