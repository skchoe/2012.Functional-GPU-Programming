# 1 "cu_lib.cu"
# 942 "/home/u0332192/local/cuda/include/driver_types.h"
struct CUstream_st;
# 199 "/usr/include/math.h" 3
enum _ZUt_ {
FP_NAN,

FP_INFINITE,

FP_ZERO,

FP_SUBNORMAL,

FP_NORMAL};
# 292 "/usr/include/math.h" 3
enum _LIB_VERSION_TYPE {
_IEEE_ = (-1),
_SVID_,
_XOPEN_,
_POSIX_,
_ISOC_};
# 75 "/home/u0332192/local/cuda/include/cuda_surface_types.h"
struct _Z7surfaceIvLi1EE; struct _Z7surfaceIvLi2EE;
# 75 "/home/u0332192/local/cuda/include/cuda_texture_types.h"
struct _Z7textureIcLi1EL19cudaTextureReadMode0EE; struct _Z7textureIaLi1EL19cudaTextureReadMode0EE; struct _Z7textureIhLi1EL19cudaTextureReadMode0EE; struct _Z7textureI5char1Li1EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar1Li1EL19cudaTextureReadMode0EE; struct _Z7textureI5char2Li1EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar2Li1EL19cudaTextureReadMode0EE; struct _Z7textureI5char4Li1EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar4Li1EL19cudaTextureReadMode0EE; struct _Z7textureIsLi1EL19cudaTextureReadMode0EE; struct _Z7textureItLi1EL19cudaTextureReadMode0EE; struct _Z7textureI6short1Li1EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort1Li1EL19cudaTextureReadMode0EE; struct _Z7textureI6short2Li1EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort2Li1EL19cudaTextureReadMode0EE; struct _Z7textureI6short4Li1EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort4Li1EL19cudaTextureReadMode0EE; struct _Z7textureIiLi1EL19cudaTextureReadMode0EE; struct _Z7textureIjLi1EL19cudaTextureReadMode0EE; struct _Z7textureI4int1Li1EL19cudaTextureReadMode0EE; struct _Z7textureI5uint1Li1EL19cudaTextureReadMode0EE; struct _Z7textureI4int2Li1EL19cudaTextureReadMode0EE; struct _Z7textureI5uint2Li1EL19cudaTextureReadMode0EE; struct _Z7textureI4int4Li1EL19cudaTextureReadMode0EE; struct _Z7textureI5uint4Li1EL19cudaTextureReadMode0EE; struct _Z7textureIfLi1EL19cudaTextureReadMode0EE; struct _Z7textureI6float1Li1EL19cudaTextureReadMode0EE; struct _Z7textureI6float2Li1EL19cudaTextureReadMode0EE; struct _Z7textureI6float4Li1EL19cudaTextureReadMode0EE; struct _Z7textureIcLi1EL19cudaTextureReadMode1EE; struct _Z7textureIaLi1EL19cudaTextureReadMode1EE; struct _Z7textureIhLi1EL19cudaTextureReadMode1EE; struct _Z7textureI5char1Li1EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar1Li1EL19cudaTextureReadMode1EE; struct _Z7textureI5char2Li1EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar2Li1EL19cudaTextureReadMode1EE; struct _Z7textureI5char4Li1EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar4Li1EL19cudaTextureReadMode1EE; struct _Z7textureIsLi1EL19cudaTextureReadMode1EE; struct _Z7textureItLi1EL19cudaTextureReadMode1EE; struct _Z7textureI6short1Li1EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort1Li1EL19cudaTextureReadMode1EE; struct _Z7textureI6short2Li1EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort2Li1EL19cudaTextureReadMode1EE; struct _Z7textureI6short4Li1EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort4Li1EL19cudaTextureReadMode1EE; struct _Z7textureIcLi2EL19cudaTextureReadMode0EE; struct _Z7textureIaLi2EL19cudaTextureReadMode0EE; struct _Z7textureIhLi2EL19cudaTextureReadMode0EE; struct _Z7textureI5char1Li2EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar1Li2EL19cudaTextureReadMode0EE; struct _Z7textureI5char2Li2EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar2Li2EL19cudaTextureReadMode0EE; struct _Z7textureI5char4Li2EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar4Li2EL19cudaTextureReadMode0EE; struct _Z7textureIsLi2EL19cudaTextureReadMode0EE; struct _Z7textureItLi2EL19cudaTextureReadMode0EE; struct _Z7textureI6short1Li2EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort1Li2EL19cudaTextureReadMode0EE; struct _Z7textureI6short2Li2EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort2Li2EL19cudaTextureReadMode0EE; struct _Z7textureI6short4Li2EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort4Li2EL19cudaTextureReadMode0EE; struct _Z7textureIiLi2EL19cudaTextureReadMode0EE; struct _Z7textureIjLi2EL19cudaTextureReadMode0EE; struct _Z7textureI4int1Li2EL19cudaTextureReadMode0EE; struct _Z7textureI5uint1Li2EL19cudaTextureReadMode0EE; struct _Z7textureI4int2Li2EL19cudaTextureReadMode0EE; struct _Z7textureI5uint2Li2EL19cudaTextureReadMode0EE; struct _Z7textureI4int4Li2EL19cudaTextureReadMode0EE; struct _Z7textureI5uint4Li2EL19cudaTextureReadMode0EE; struct _Z7textureIfLi2EL19cudaTextureReadMode0EE; struct _Z7textureI6float1Li2EL19cudaTextureReadMode0EE; struct _Z7textureI6float2Li2EL19cudaTextureReadMode0EE; struct _Z7textureI6float4Li2EL19cudaTextureReadMode0EE; struct _Z7textureIcLi2EL19cudaTextureReadMode1EE; struct _Z7textureIaLi2EL19cudaTextureReadMode1EE; struct _Z7textureIhLi2EL19cudaTextureReadMode1EE; struct _Z7textureI5char1Li2EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar1Li2EL19cudaTextureReadMode1EE; struct _Z7textureI5char2Li2EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar2Li2EL19cudaTextureReadMode1EE; struct _Z7textureI5char4Li2EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar4Li2EL19cudaTextureReadMode1EE; struct _Z7textureIsLi2EL19cudaTextureReadMode1EE; struct _Z7textureItLi2EL19cudaTextureReadMode1EE; struct _Z7textureI6short1Li2EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort1Li2EL19cudaTextureReadMode1EE; struct _Z7textureI6short2Li2EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort2Li2EL19cudaTextureReadMode1EE; struct _Z7textureI6short4Li2EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort4Li2EL19cudaTextureReadMode1EE; struct _Z7textureIcLi241EL19cudaTextureReadMode0EE; struct _Z7textureIaLi241EL19cudaTextureReadMode0EE; struct _Z7textureIhLi241EL19cudaTextureReadMode0EE; struct _Z7textureI5char1Li241EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar1Li241EL19cudaTextureReadMode0EE; struct _Z7textureI5char2Li241EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar2Li241EL19cudaTextureReadMode0EE; struct _Z7textureI5char4Li241EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar4Li241EL19cudaTextureReadMode0EE; struct _Z7textureIsLi241EL19cudaTextureReadMode0EE; struct _Z7textureItLi241EL19cudaTextureReadMode0EE; struct _Z7textureI6short1Li241EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort1Li241EL19cudaTextureReadMode0EE; struct _Z7textureI6short2Li241EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort2Li241EL19cudaTextureReadMode0EE; struct _Z7textureI6short4Li241EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort4Li241EL19cudaTextureReadMode0EE; struct _Z7textureIiLi241EL19cudaTextureReadMode0EE; struct _Z7textureIjLi241EL19cudaTextureReadMode0EE; struct _Z7textureI4int1Li241EL19cudaTextureReadMode0EE; struct _Z7textureI5uint1Li241EL19cudaTextureReadMode0EE; struct _Z7textureI4int2Li241EL19cudaTextureReadMode0EE; struct _Z7textureI5uint2Li241EL19cudaTextureReadMode0EE; struct _Z7textureI4int4Li241EL19cudaTextureReadMode0EE; struct _Z7textureI5uint4Li241EL19cudaTextureReadMode0EE; struct _Z7textureIfLi241EL19cudaTextureReadMode0EE; struct _Z7textureI6float1Li241EL19cudaTextureReadMode0EE; struct _Z7textureI6float2Li241EL19cudaTextureReadMode0EE; struct _Z7textureI6float4Li241EL19cudaTextureReadMode0EE; struct _Z7textureIcLi241EL19cudaTextureReadMode1EE; struct _Z7textureIaLi241EL19cudaTextureReadMode1EE; struct _Z7textureIhLi241EL19cudaTextureReadMode1EE; struct _Z7textureI5char1Li241EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar1Li241EL19cudaTextureReadMode1EE; struct _Z7textureI5char2Li241EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar2Li241EL19cudaTextureReadMode1EE; struct _Z7textureI5char4Li241EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar4Li241EL19cudaTextureReadMode1EE; struct _Z7textureIsLi241EL19cudaTextureReadMode1EE; struct _Z7textureItLi241EL19cudaTextureReadMode1EE; struct _Z7textureI6short1Li241EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort1Li241EL19cudaTextureReadMode1EE; struct _Z7textureI6short2Li241EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort2Li241EL19cudaTextureReadMode1EE; struct _Z7textureI6short4Li241EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort4Li241EL19cudaTextureReadMode1EE; struct _Z7textureIcLi242EL19cudaTextureReadMode0EE; struct _Z7textureIaLi242EL19cudaTextureReadMode0EE; struct _Z7textureIhLi242EL19cudaTextureReadMode0EE; struct _Z7textureI5char1Li242EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar1Li242EL19cudaTextureReadMode0EE; struct _Z7textureI5char2Li242EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar2Li242EL19cudaTextureReadMode0EE; struct _Z7textureI5char4Li242EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar4Li242EL19cudaTextureReadMode0EE; struct _Z7textureIsLi242EL19cudaTextureReadMode0EE; struct _Z7textureItLi242EL19cudaTextureReadMode0EE; struct _Z7textureI6short1Li242EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort1Li242EL19cudaTextureReadMode0EE; struct _Z7textureI6short2Li242EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort2Li242EL19cudaTextureReadMode0EE; struct _Z7textureI6short4Li242EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort4Li242EL19cudaTextureReadMode0EE; struct _Z7textureIiLi242EL19cudaTextureReadMode0EE; struct _Z7textureIjLi242EL19cudaTextureReadMode0EE; struct _Z7textureI4int1Li242EL19cudaTextureReadMode0EE; struct _Z7textureI5uint1Li242EL19cudaTextureReadMode0EE; struct _Z7textureI4int2Li242EL19cudaTextureReadMode0EE; struct _Z7textureI5uint2Li242EL19cudaTextureReadMode0EE; struct _Z7textureI4int4Li242EL19cudaTextureReadMode0EE; struct _Z7textureI5uint4Li242EL19cudaTextureReadMode0EE; struct _Z7textureIfLi242EL19cudaTextureReadMode0EE; struct _Z7textureI6float1Li242EL19cudaTextureReadMode0EE; struct _Z7textureI6float2Li242EL19cudaTextureReadMode0EE; struct _Z7textureI6float4Li242EL19cudaTextureReadMode0EE; struct _Z7textureIcLi242EL19cudaTextureReadMode1EE; struct _Z7textureIaLi242EL19cudaTextureReadMode1EE; struct _Z7textureIhLi242EL19cudaTextureReadMode1EE; struct _Z7textureI5char1Li242EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar1Li242EL19cudaTextureReadMode1EE; struct _Z7textureI5char2Li242EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar2Li242EL19cudaTextureReadMode1EE; struct _Z7textureI5char4Li242EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar4Li242EL19cudaTextureReadMode1EE; struct _Z7textureIsLi242EL19cudaTextureReadMode1EE; struct _Z7textureItLi242EL19cudaTextureReadMode1EE; struct _Z7textureI6short1Li242EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort1Li242EL19cudaTextureReadMode1EE; struct _Z7textureI6short2Li242EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort2Li242EL19cudaTextureReadMode1EE; struct _Z7textureI6short4Li242EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort4Li242EL19cudaTextureReadMode1EE; struct _Z7textureIcLi3EL19cudaTextureReadMode0EE; struct _Z7textureIaLi3EL19cudaTextureReadMode0EE; struct _Z7textureIhLi3EL19cudaTextureReadMode0EE; struct _Z7textureI5char1Li3EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar1Li3EL19cudaTextureReadMode0EE; struct _Z7textureI5char2Li3EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar2Li3EL19cudaTextureReadMode0EE; struct _Z7textureI5char4Li3EL19cudaTextureReadMode0EE; struct _Z7textureI6uchar4Li3EL19cudaTextureReadMode0EE; struct _Z7textureIsLi3EL19cudaTextureReadMode0EE; struct _Z7textureItLi3EL19cudaTextureReadMode0EE; struct _Z7textureI6short1Li3EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort1Li3EL19cudaTextureReadMode0EE; struct _Z7textureI6short2Li3EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort2Li3EL19cudaTextureReadMode0EE; struct _Z7textureI6short4Li3EL19cudaTextureReadMode0EE; struct _Z7textureI7ushort4Li3EL19cudaTextureReadMode0EE; struct _Z7textureIiLi3EL19cudaTextureReadMode0EE; struct _Z7textureIjLi3EL19cudaTextureReadMode0EE; struct _Z7textureI4int1Li3EL19cudaTextureReadMode0EE; struct _Z7textureI5uint1Li3EL19cudaTextureReadMode0EE; struct _Z7textureI4int2Li3EL19cudaTextureReadMode0EE; struct _Z7textureI5uint2Li3EL19cudaTextureReadMode0EE; struct _Z7textureI4int4Li3EL19cudaTextureReadMode0EE; struct _Z7textureI5uint4Li3EL19cudaTextureReadMode0EE; struct _Z7textureIfLi3EL19cudaTextureReadMode0EE; struct _Z7textureI6float1Li3EL19cudaTextureReadMode0EE; struct _Z7textureI6float2Li3EL19cudaTextureReadMode0EE; struct _Z7textureI6float4Li3EL19cudaTextureReadMode0EE; struct _Z7textureIcLi3EL19cudaTextureReadMode1EE; struct _Z7textureIaLi3EL19cudaTextureReadMode1EE; struct _Z7textureIhLi3EL19cudaTextureReadMode1EE; struct _Z7textureI5char1Li3EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar1Li3EL19cudaTextureReadMode1EE; struct _Z7textureI5char2Li3EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar2Li3EL19cudaTextureReadMode1EE; struct _Z7textureI5char4Li3EL19cudaTextureReadMode1EE; struct _Z7textureI6uchar4Li3EL19cudaTextureReadMode1EE; struct _Z7textureIsLi3EL19cudaTextureReadMode1EE; struct _Z7textureItLi3EL19cudaTextureReadMode1EE; struct _Z7textureI6short1Li3EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort1Li3EL19cudaTextureReadMode1EE; struct _Z7textureI6short2Li3EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort2Li3EL19cudaTextureReadMode1EE; struct _Z7textureI6short4Li3EL19cudaTextureReadMode1EE; struct _Z7textureI7ushort4Li3EL19cudaTextureReadMode1EE;
# 206 "/usr/include/libio.h" 3
enum __codecvt_result {

__codecvt_ok,
__codecvt_partial,
__codecvt_error,
__codecvt_noconv};
# 271 "/usr/include/libio.h" 3
struct _IO_FILE;
# 174 "/home/u0332192/local/cuda/include/cuda.h"
enum CUctx_flags_enum {
CU_CTX_SCHED_AUTO,
CU_CTX_SCHED_SPIN,
CU_CTX_SCHED_YIELD,
CU_CTX_SCHED_BLOCKING_SYNC = 4,
CU_CTX_BLOCKING_SYNC = 4,
CU_CTX_SCHED_MASK = 7,
CU_CTX_MAP_HOST,
CU_CTX_LMEM_RESIZE_TO_MAX = 16,
CU_CTX_FLAGS_MASK = 31};
# 189 "/home/u0332192/local/cuda/include/cuda.h"
enum CUevent_flags_enum {
CU_EVENT_DEFAULT,
CU_EVENT_BLOCKING_SYNC,
CU_EVENT_DISABLE_TIMING};
# 198 "/home/u0332192/local/cuda/include/cuda.h"
enum CUarray_format_enum {
CU_AD_FORMAT_UNSIGNED_INT8 = 1,
CU_AD_FORMAT_UNSIGNED_INT16,
CU_AD_FORMAT_UNSIGNED_INT32,
CU_AD_FORMAT_SIGNED_INT8 = 8,
CU_AD_FORMAT_SIGNED_INT16,
CU_AD_FORMAT_SIGNED_INT32,
CU_AD_FORMAT_HALF = 16,
CU_AD_FORMAT_FLOAT = 32};
# 212 "/home/u0332192/local/cuda/include/cuda.h"
enum CUaddress_mode_enum {
CU_TR_ADDRESS_MODE_WRAP,
CU_TR_ADDRESS_MODE_CLAMP,
CU_TR_ADDRESS_MODE_MIRROR,
CU_TR_ADDRESS_MODE_BORDER};
# 222 "/home/u0332192/local/cuda/include/cuda.h"
enum CUfilter_mode_enum {
CU_TR_FILTER_MODE_POINT,
CU_TR_FILTER_MODE_LINEAR};
# 230 "/home/u0332192/local/cuda/include/cuda.h"
enum CUdevice_attribute_enum {
CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK = 1,
CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X,
CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Y,
CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Z,
CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X,
CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Y,
CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Z,
CU_DEVICE_ATTRIBUTE_MAX_SHARED_MEMORY_PER_BLOCK,
CU_DEVICE_ATTRIBUTE_SHARED_MEMORY_PER_BLOCK = 8,
CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY,
CU_DEVICE_ATTRIBUTE_WARP_SIZE,
CU_DEVICE_ATTRIBUTE_MAX_PITCH,
CU_DEVICE_ATTRIBUTE_MAX_REGISTERS_PER_BLOCK,
CU_DEVICE_ATTRIBUTE_REGISTERS_PER_BLOCK = 12,
CU_DEVICE_ATTRIBUTE_CLOCK_RATE,
CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT,
CU_DEVICE_ATTRIBUTE_GPU_OVERLAP,
CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT,
CU_DEVICE_ATTRIBUTE_KERNEL_EXEC_TIMEOUT,
CU_DEVICE_ATTRIBUTE_INTEGRATED,
CU_DEVICE_ATTRIBUTE_CAN_MAP_HOST_MEMORY,
CU_DEVICE_ATTRIBUTE_COMPUTE_MODE,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_WIDTH,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_WIDTH,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_HEIGHT,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_WIDTH,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_HEIGHT,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_DEPTH,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_LAYERED_WIDTH,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_LAYERED_HEIGHT,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_LAYERED_LAYERS,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_WIDTH = 27,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_HEIGHT,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_NUMSLICES,
CU_DEVICE_ATTRIBUTE_SURFACE_ALIGNMENT,
CU_DEVICE_ATTRIBUTE_CONCURRENT_KERNELS,
CU_DEVICE_ATTRIBUTE_ECC_ENABLED,
CU_DEVICE_ATTRIBUTE_PCI_BUS_ID,
CU_DEVICE_ATTRIBUTE_PCI_DEVICE_ID,
CU_DEVICE_ATTRIBUTE_TCC_DRIVER,
CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE,
CU_DEVICE_ATTRIBUTE_GLOBAL_MEMORY_BUS_WIDTH,
CU_DEVICE_ATTRIBUTE_L2_CACHE_SIZE,
CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_MULTIPROCESSOR,
CU_DEVICE_ATTRIBUTE_ASYNC_ENGINE_COUNT,
CU_DEVICE_ATTRIBUTE_UNIFIED_ADDRESSING,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_LAYERED_WIDTH,
CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_LAYERED_LAYERS,
CU_DEVICE_ATTRIBUTE_PCI_DOMAIN_ID = 50};
# 301 "/home/u0332192/local/cuda/include/cuda.h"
enum CUpointer_attribute_enum {
CU_POINTER_ATTRIBUTE_CONTEXT = 1,
CU_POINTER_ATTRIBUTE_MEMORY_TYPE,
CU_POINTER_ATTRIBUTE_DEVICE_POINTER,
CU_POINTER_ATTRIBUTE_HOST_POINTER};
# 311 "/home/u0332192/local/cuda/include/cuda.h"
enum CUfunction_attribute_enum {
# 317 "/home/u0332192/local/cuda/include/cuda.h"
CU_FUNC_ATTRIBUTE_MAX_THREADS_PER_BLOCK,
# 324 "/home/u0332192/local/cuda/include/cuda.h"
CU_FUNC_ATTRIBUTE_SHARED_SIZE_BYTES,
# 330 "/home/u0332192/local/cuda/include/cuda.h"
CU_FUNC_ATTRIBUTE_CONST_SIZE_BYTES,




CU_FUNC_ATTRIBUTE_LOCAL_SIZE_BYTES,




CU_FUNC_ATTRIBUTE_NUM_REGS,
# 349 "/home/u0332192/local/cuda/include/cuda.h"
CU_FUNC_ATTRIBUTE_PTX_VERSION,
# 358 "/home/u0332192/local/cuda/include/cuda.h"
CU_FUNC_ATTRIBUTE_BINARY_VERSION,

CU_FUNC_ATTRIBUTE_MAX};
# 366 "/home/u0332192/local/cuda/include/cuda.h"
enum CUfunc_cache_enum {
CU_FUNC_CACHE_PREFER_NONE,
CU_FUNC_CACHE_PREFER_SHARED,
CU_FUNC_CACHE_PREFER_L1};
# 375 "/home/u0332192/local/cuda/include/cuda.h"
enum CUmemorytype_enum {
CU_MEMORYTYPE_HOST = 1,
CU_MEMORYTYPE_DEVICE,
CU_MEMORYTYPE_ARRAY,
CU_MEMORYTYPE_UNIFIED};
# 385 "/home/u0332192/local/cuda/include/cuda.h"
enum CUcomputemode_enum {
CU_COMPUTEMODE_DEFAULT,
CU_COMPUTEMODE_EXCLUSIVE,
CU_COMPUTEMODE_PROHIBITED,
CU_COMPUTEMODE_EXCLUSIVE_PROCESS};
# 395 "/home/u0332192/local/cuda/include/cuda.h"
enum CUjit_option_enum {
# 401 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_MAX_REGISTERS,
# 414 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_THREADS_PER_BLOCK,
# 421 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_WALL_TIME,
# 429 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_INFO_LOG_BUFFER,
# 437 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_INFO_LOG_BUFFER_SIZE_BYTES,
# 445 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_ERROR_LOG_BUFFER,
# 453 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_ERROR_LOG_BUFFER_SIZE_BYTES,
# 460 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_OPTIMIZATION_LEVEL,
# 467 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_TARGET_FROM_CUCONTEXT,
# 473 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_TARGET,
# 480 "/home/u0332192/local/cuda/include/cuda.h"
CU_JIT_FALLBACK_STRATEGY};
# 487 "/home/u0332192/local/cuda/include/cuda.h"
enum CUjit_target_enum {

CU_TARGET_COMPUTE_10,
CU_TARGET_COMPUTE_11,
CU_TARGET_COMPUTE_12,
CU_TARGET_COMPUTE_13,
CU_TARGET_COMPUTE_20,
CU_TARGET_COMPUTE_21};
# 500 "/home/u0332192/local/cuda/include/cuda.h"
enum CUjit_fallback_enum {

CU_PREFER_PTX,

CU_PREFER_BINARY};
# 511 "/home/u0332192/local/cuda/include/cuda.h"
enum CUgraphicsRegisterFlags_enum {
CU_GRAPHICS_REGISTER_FLAGS_NONE,
CU_GRAPHICS_REGISTER_FLAGS_READ_ONLY,
CU_GRAPHICS_REGISTER_FLAGS_WRITE_DISCARD,
CU_GRAPHICS_REGISTER_FLAGS_SURFACE_LDST = 4};
# 521 "/home/u0332192/local/cuda/include/cuda.h"
enum CUgraphicsMapResourceFlags_enum {
CU_GRAPHICS_MAP_RESOURCE_FLAGS_NONE,
CU_GRAPHICS_MAP_RESOURCE_FLAGS_READ_ONLY,
CU_GRAPHICS_MAP_RESOURCE_FLAGS_WRITE_DISCARD};
# 530 "/home/u0332192/local/cuda/include/cuda.h"
enum CUarray_cubemap_face_enum {
CU_CUBEMAP_FACE_POSITIVE_X,
CU_CUBEMAP_FACE_NEGATIVE_X,
CU_CUBEMAP_FACE_POSITIVE_Y,
CU_CUBEMAP_FACE_NEGATIVE_Y,
CU_CUBEMAP_FACE_POSITIVE_Z,
CU_CUBEMAP_FACE_NEGATIVE_Z};
# 542 "/home/u0332192/local/cuda/include/cuda.h"
enum CUlimit_enum {
CU_LIMIT_STACK_SIZE,
CU_LIMIT_PRINTF_FIFO_SIZE,
CU_LIMIT_MALLOC_HEAP_SIZE};
# 551 "/home/u0332192/local/cuda/include/cuda.h"
enum cudaError_enum {
# 557 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_SUCCESS,
# 563 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_INVALID_VALUE,
# 569 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_OUT_OF_MEMORY,
# 575 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_NOT_INITIALIZED,




CUDA_ERROR_DEINITIALIZED,
# 586 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_PROFILER_DISABLED,




CUDA_ERROR_PROFILER_NOT_INITIALIZED,




CUDA_ERROR_PROFILER_ALREADY_STARTED,




CUDA_ERROR_PROFILER_ALREADY_STOPPED,




CUDA_ERROR_NO_DEVICE = 100,
# 612 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_INVALID_DEVICE,
# 619 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_INVALID_IMAGE = 200,
# 629 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_INVALID_CONTEXT,
# 638 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_CONTEXT_ALREADY_CURRENT,




CUDA_ERROR_MAP_FAILED = 205,




CUDA_ERROR_UNMAP_FAILED,
# 654 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_ARRAY_IS_MAPPED,




CUDA_ERROR_ALREADY_MAPPED,
# 667 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_NO_BINARY_FOR_GPU,




CUDA_ERROR_ALREADY_ACQUIRED,




CUDA_ERROR_NOT_MAPPED,
# 683 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_NOT_MAPPED_AS_ARRAY,
# 689 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_NOT_MAPPED_AS_POINTER,
# 695 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_ECC_UNCORRECTABLE,
# 701 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_UNSUPPORTED_LIMIT,
# 708 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_CONTEXT_ALREADY_IN_USE,




CUDA_ERROR_INVALID_SOURCE = 300,




CUDA_ERROR_FILE_NOT_FOUND,




CUDA_ERROR_SHARED_OBJECT_SYMBOL_NOT_FOUND,




CUDA_ERROR_SHARED_OBJECT_INIT_FAILED,




CUDA_ERROR_OPERATING_SYSTEM,
# 740 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_INVALID_HANDLE = 400,
# 747 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_NOT_FOUND = 500,
# 756 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_NOT_READY = 600,
# 767 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_LAUNCH_FAILED = 700,
# 778 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_LAUNCH_OUT_OF_RESOURCES,
# 789 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_LAUNCH_TIMEOUT,
# 795 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_LAUNCH_INCOMPATIBLE_TEXTURING,
# 802 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_PEER_ACCESS_ALREADY_ENABLED,
# 809 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_PEER_ACCESS_NOT_ENABLED,
# 815 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_PRIMARY_CONTEXT_ACTIVE = 708,
# 822 "/home/u0332192/local/cuda/include/cuda.h"
CUDA_ERROR_CONTEXT_IS_DESTROYED,




CUDA_ERROR_UNKNOWN = 999};
# 60 "/home/u0332192/local/GPU_SDK/C/common/inc/cutil.h"
enum CUTBoolean {

CUTFalse,
CUTTrue};
# 6 "hashtab.h"
struct hashtab;
# 124 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt9__is_voidIvEUt_E { _ZNSt9__is_voidIvE7__valueE = 1};
# 144 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIbEUt_E { _ZNSt12__is_integerIbE7__valueE = 1};
# 151 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIcEUt_E { _ZNSt12__is_integerIcE7__valueE = 1};
# 158 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIaEUt_E { _ZNSt12__is_integerIaE7__valueE = 1};
# 165 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIhEUt_E { _ZNSt12__is_integerIhE7__valueE = 1};
# 173 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIwEUt_E { _ZNSt12__is_integerIwE7__valueE = 1};
# 197 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIsEUt_E { _ZNSt12__is_integerIsE7__valueE = 1};
# 204 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerItEUt_E { _ZNSt12__is_integerItE7__valueE = 1};
# 211 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIiEUt_E { _ZNSt12__is_integerIiE7__valueE = 1};
# 218 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIjEUt_E { _ZNSt12__is_integerIjE7__valueE = 1};
# 225 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIlEUt_E { _ZNSt12__is_integerIlE7__valueE = 1};
# 232 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerImEUt_E { _ZNSt12__is_integerImE7__valueE = 1};
# 239 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIxEUt_E { _ZNSt12__is_integerIxE7__valueE = 1};
# 246 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt12__is_integerIyEUt_E { _ZNSt12__is_integerIyE7__valueE = 1};
# 264 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt13__is_floatingIfEUt_E { _ZNSt13__is_floatingIfE7__valueE = 1};
# 271 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt13__is_floatingIdEUt_E { _ZNSt13__is_floatingIdE7__valueE = 1};
# 278 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt13__is_floatingIeEUt_E { _ZNSt13__is_floatingIeE7__valueE = 1};
# 354 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt9__is_charIcEUt_E { _ZNSt9__is_charIcE7__valueE = 1};
# 362 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt9__is_charIwEUt_E { _ZNSt9__is_charIwE7__valueE = 1};
# 377 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt9__is_byteIcEUt_E { _ZNSt9__is_byteIcE7__valueE = 1};
# 384 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt9__is_byteIaEUt_E { _ZNSt9__is_byteIaE7__valueE = 1};
# 391 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/bits/cpp_type_traits.h" 3
enum _ZNSt9__is_byteIhEUt_E { _ZNSt9__is_byteIhE7__valueE = 1};
# 211 "/usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/stddef.h" 3
typedef unsigned long size_t;
#include "crt/host_runtime.h"
# 145 "/usr/include/bits/types.h" 3
typedef long __clock_t;
# 60 "/usr/include/time.h" 3
typedef __clock_t clock_t;
# 75 "/home/u0332192/local/cuda/include/cuda_surface_types.h"
struct _Z7surfaceIvLi1EE { struct surfaceReference __b_16surfaceReference;}; struct _Z7surfaceIvLi2EE { struct surfaceReference __b_16surfaceReference;};
# 75 "/home/u0332192/local/cuda/include/cuda_texture_types.h"
struct _Z7textureIcLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIiLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIjLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int1Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint1Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int2Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint2Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int4Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint4Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIfLi1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float1Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float2Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float4Li1EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li1EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIiLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIjLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int1Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint1Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int2Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint2Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int4Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint4Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIfLi2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float1Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float2Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float4Li2EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li2EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIiLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIjLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int1Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint1Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int2Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint2Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int4Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint4Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIfLi241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float1Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float2Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float4Li241EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li241EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIiLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIjLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int1Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint1Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int2Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint2Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int4Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint4Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIfLi242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float1Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float2Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float4Li242EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li242EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIiLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIjLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int1Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint1Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int2Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint2Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI4int4Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5uint4Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIfLi3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float1Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float2Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6float4Li3EL19cudaTextureReadMode0EE { struct textureReference __b_16textureReference;}; struct _Z7textureIcLi3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIaLi3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIhLi3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char1Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar1Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char2Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar2Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI5char4Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6uchar4Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureIsLi3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureItLi3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short1Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort1Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short2Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort2Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI6short4Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;}; struct _Z7textureI7ushort4Li3EL19cudaTextureReadMode1EE { struct textureReference __b_16textureReference;};
# 49 "/usr/include/stdio.h" 3
typedef struct _IO_FILE FILE;
# 6 "hashtab.h"
struct hashtab {
int num_variable;
int num_constraint;
char *ht;};
typedef struct hashtab hash_tab;
void *memcpy(void*, const void*, size_t); void *memset(void*, int, size_t);
# 638 "/home/u0332192/local/cuda/include/cuda_runtime_api.h"
extern const char *cudaGetErrorString(cudaError_t);
# 1369 "/home/u0332192/local/cuda/include/cuda_runtime_api.h"
extern cudaError_t cudaConfigureCall(dim3, dim3, size_t, cudaStream_t);
# 1586 "/home/u0332192/local/cuda/include/cuda_runtime_api.h"
extern cudaError_t cudaMalloc(void **, size_t);
# 1717 "/home/u0332192/local/cuda/include/cuda_runtime_api.h"
extern cudaError_t cudaFree(void *);
# 2337 "/home/u0332192/local/cuda/include/cuda_runtime_api.h"
extern cudaError_t cudaMemcpy(void *, const void *, size_t, enum cudaMemcpyKind);
# 3118 "/home/u0332192/local/cuda/include/cuda_runtime_api.h"
extern cudaError_t cudaMemset(void *, int, size_t);
# 75 "/home/u0332192/local/cuda/include/common_functions.h"
extern void *memcpy(void *__restrict__, const void *__restrict__, size_t);
# 73 "/home/u0332192/local/cuda/include/common_functions.h"
extern void *memset(void *, int, size_t);
# 459 "/usr/include/string.h" 3
extern void bzero(void *, size_t);
# 183 "/usr/include/time.h" 3
extern clock_t clock(void);
# 292 "/home/u0332192/local/cuda/include/math_functions.h"
extern double acos(double);
# 289 "/home/u0332192/local/cuda/include/math_functions.h"
extern double asin(double);
# 286 "/home/u0332192/local/cuda/include/math_functions.h"
extern double atan(double);
# 283 "/home/u0332192/local/cuda/include/math_functions.h"
extern double atan2(double, double);
# 125 "/home/u0332192/local/cuda/include/math_functions.h"
extern double cos(double);
# 122 "/home/u0332192/local/cuda/include/math_functions.h"
extern double sin(double);
# 133 "/home/u0332192/local/cuda/include/math_functions.h"
extern double tan(double);
# 181 "/home/u0332192/local/cuda/include/math_functions.h"
extern double cosh(double);


extern double sinh(double);


extern double tanh(double);
# 128 "/home/u0332192/local/cuda/include/math_functions.h"
extern void sincos(double, double *, double *);
# 190 "/home/u0332192/local/cuda/include/math_functions.h"
extern double acosh(double);




extern double asinh(double);




extern double atanh(double);
# 178 "/home/u0332192/local/cuda/include/math_functions.h"
extern double exp(double);
# 230 "/home/u0332192/local/cuda/include/math_functions.h"
extern double frexp(double, int *);
# 205 "/home/u0332192/local/cuda/include/math_functions.h"
extern double ldexp(double, int);
# 167 "/home/u0332192/local/cuda/include/math_functions.h"
extern double log(double);
# 164 "/home/u0332192/local/cuda/include/math_functions.h"
extern double log10(double);
# 328 "/home/u0332192/local/cuda/include/math_functions.h"
extern double modf(double, double *);
# 149 "/home/u0332192/local/cuda/include/math_functions.h"
extern double exp10(double);




extern double expm1(double);
# 170 "/home/u0332192/local/cuda/include/math_functions.h"
extern double log1p(double);
# 210 "/home/u0332192/local/cuda/include/math_functions.h"
extern double logb(double);
# 144 "/home/u0332192/local/cuda/include/math_functions.h"
extern double exp2(double);
# 159 "/home/u0332192/local/cuda/include/math_functions.h"
extern double log2(double);
# 325 "/home/u0332192/local/cuda/include/math_functions.h"
extern double pow(double, double);
# 136 "/home/u0332192/local/cuda/include/math_functions.h"
extern double sqrt(double);
# 296 "/home/u0332192/local/cuda/include/math_functions.h"
extern double hypot(double, double);
# 305 "/home/u0332192/local/cuda/include/math_functions.h"
extern double cbrt(double);
# 270 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double ceil(double);
# 91 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double fabs(double);
# 175 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double floor(double);
# 331 "/home/u0332192/local/cuda/include/math_functions.h"
extern double fmod(double, double);
# 389 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __isinf(double);
# 411 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __finite(double);
# 374 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double copysign(double, double);
# 384 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double nan(const char *);
# 394 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __isnan(double);
# 344 "/home/u0332192/local/cuda/include/math_functions.h"
extern double erf(double);
# 354 "/home/u0332192/local/cuda/include/math_functions.h"
extern double erfc(double);
# 364 "/home/u0332192/local/cuda/include/math_functions.h"
extern double lgamma(double);




extern double tgamma(double);
# 250 "/home/u0332192/local/cuda/include/math_functions.h"
extern double rint(double);
# 379 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double nextafter(double, double);
# 334 "/home/u0332192/local/cuda/include/math_functions.h"
extern double remainder(double, double);
# 220 "/home/u0332192/local/cuda/include/math_functions.h"
extern double scalbn(double, int);
# 215 "/home/u0332192/local/cuda/include/math_functions.h"
extern int ilogb(double);
# 225 "/home/u0332192/local/cuda/include/math_functions.h"
extern double scalbln(double, long);
# 265 "/home/u0332192/local/cuda/include/math_functions.h"
extern double nearbyint(double);
# 235 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double round(double);
# 273 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) double trunc(double);
# 339 "/home/u0332192/local/cuda/include/math_functions.h"
extern double remquo(double, double, int *);
# 255 "/home/u0332192/local/cuda/include/math_functions.h"
extern long lrint(double);




extern long long llrint(double);
# 240 "/home/u0332192/local/cuda/include/math_functions.h"
extern long lround(double);




extern long long llround(double);
# 278 "/home/u0332192/local/cuda/include/math_functions.h"
extern double fdim(double, double);
# 119 "/home/u0332192/local/cuda/include/math_functions.h"
extern double fmax(double, double);
# 106 "/home/u0332192/local/cuda/include/math_functions.h"
extern double fmin(double, double);
# 418 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __signbit(double);
# 426 "/home/u0332192/local/cuda/include/math_functions.h"
extern double fma(double, double, double);
# 516 "/home/u0332192/local/cuda/include/math_functions.h"
extern float acosf(float);


extern float asinf(float);


extern float atanf(float);


extern float atan2f(float, float);


extern float cosf(float);


extern float sinf(float);


extern float tanf(float);


extern float coshf(float);


extern float sinhf(float);


extern float tanhf(float);
# 130 "/home/u0332192/local/cuda/include/math_functions.h"
extern void sincosf(float, float *, float *);
# 192 "/home/u0332192/local/cuda/include/math_functions.h"
extern float acoshf(float);




extern float asinhf(float);




extern float atanhf(float);
# 546 "/home/u0332192/local/cuda/include/math_functions.h"
extern float expf(float);
# 232 "/home/u0332192/local/cuda/include/math_functions.h"
extern float frexpf(float, int *);
# 207 "/home/u0332192/local/cuda/include/math_functions.h"
extern float ldexpf(float, int);
# 549 "/home/u0332192/local/cuda/include/math_functions.h"
extern float logf(float);


extern float log10f(float);


extern float modff(float, float *);
# 151 "/home/u0332192/local/cuda/include/math_functions.h"
extern float exp10f(float);




extern float expm1f(float);
# 172 "/home/u0332192/local/cuda/include/math_functions.h"
extern float log1pf(float);
# 212 "/home/u0332192/local/cuda/include/math_functions.h"
extern float logbf(float);
# 146 "/home/u0332192/local/cuda/include/math_functions.h"
extern float exp2f(float);
# 161 "/home/u0332192/local/cuda/include/math_functions.h"
extern float log2f(float);
# 558 "/home/u0332192/local/cuda/include/math_functions.h"
extern float powf(float, float);


extern float sqrtf(float);
# 302 "/home/u0332192/local/cuda/include/math_functions.h"
extern float hypotf(float, float);




extern float cbrtf(float);
# 564 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float ceilf(float);
# 93 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float fabsf(float);
# 567 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float floorf(float);


extern float fmodf(float, float);
# 391 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __isinff(float);
# 414 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __finitef(float);
# 376 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float copysignf(float, float);
# 386 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float nanf(const char *);
# 397 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __isnanf(float);
# 346 "/home/u0332192/local/cuda/include/math_functions.h"
extern float erff(float);
# 356 "/home/u0332192/local/cuda/include/math_functions.h"
extern float erfcf(float);
# 366 "/home/u0332192/local/cuda/include/math_functions.h"
extern float lgammaf(float);




extern float tgammaf(float);
# 252 "/home/u0332192/local/cuda/include/math_functions.h"
extern float rintf(float);
# 381 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float nextafterf(float, float);
# 336 "/home/u0332192/local/cuda/include/math_functions.h"
extern float remainderf(float, float);
# 222 "/home/u0332192/local/cuda/include/math_functions.h"
extern float scalbnf(float, int);
# 217 "/home/u0332192/local/cuda/include/math_functions.h"
extern int ilogbf(float);
# 227 "/home/u0332192/local/cuda/include/math_functions.h"
extern float scalblnf(float, long);
# 267 "/home/u0332192/local/cuda/include/math_functions.h"
extern float nearbyintf(float);
# 237 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float roundf(float);
# 275 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) float truncf(float);
# 341 "/home/u0332192/local/cuda/include/math_functions.h"
extern float remquof(float, float, int *);
# 257 "/home/u0332192/local/cuda/include/math_functions.h"
extern long lrintf(float);




extern long long llrintf(float);
# 242 "/home/u0332192/local/cuda/include/math_functions.h"
extern long lroundf(float);




extern long long llroundf(float);
# 280 "/home/u0332192/local/cuda/include/math_functions.h"
extern float fdimf(float, float);
# 117 "/home/u0332192/local/cuda/include/math_functions.h"
extern float fmaxf(float, float);
# 104 "/home/u0332192/local/cuda/include/math_functions.h"
extern float fminf(float, float);
# 423 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __signbitf(float);




extern float fmaf(float, float, float);
# 438 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __isinfl(long double);
# 450 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __finitel(long double);
# 440 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __isnanl(long double);
# 436 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int __signbitl(long double);
# 471 "/usr/include/stdlib.h" 3
extern __attribute__((__malloc__)) void *malloc(size_t);
# 544 "/usr/include/stdlib.h" 3
extern __attribute__((__noreturn__)) void exit(int);
# 85 "/home/u0332192/local/cuda/include/math_functions.h"
extern __attribute__((__const__)) int abs(int);

extern __attribute__((__const__)) long labs(long);

extern __attribute__((__const__)) long long llabs(long long);
# 96 "/home/u0332192/local/cuda/include/math_functions.h"
extern int min(int, int);

extern unsigned umin(unsigned, unsigned);

extern long long llmin(long long, long long);

extern unsigned long long ullmin(unsigned long long, unsigned long long);
# 109 "/home/u0332192/local/cuda/include/math_functions.h"
extern int max(int, int);

extern unsigned umax(unsigned, unsigned);

extern long long llmax(long long, long long);

extern unsigned long long ullmax(unsigned long long, unsigned long long);
# 139 "/home/u0332192/local/cuda/include/math_functions.h"
extern double rsqrt(double);

extern float rsqrtf(float);
# 310 "/home/u0332192/local/cuda/include/math_functions.h"
extern double rcbrt(double);

extern float rcbrtf(float);


extern double sinpi(double);

extern float sinpif(float);


extern double cospi(double);

extern float cospif(float);
# 349 "/home/u0332192/local/cuda/include/math_functions.h"
extern double erfinv(double);

extern float erfinvf(float);
# 359 "/home/u0332192/local/cuda/include/math_functions.h"
extern double erfcinv(double);

extern float erfcinvf(float);
# 353 "/usr/include/stdio.h" 3
extern int fprintf(FILE *__restrict__, const char *__restrict__, ...);





extern int printf(const char *__restrict__, ...);
# 681 "/home/u0332192/local/GPU_SDK/C/common/inc/cutil.h"
extern enum CUTBoolean cutCreateTimer(unsigned *);
# 690 "/home/u0332192/local/GPU_SDK/C/common/inc/cutil.h"
extern enum CUTBoolean cutDeleteTimer(unsigned);
# 698 "/home/u0332192/local/GPU_SDK/C/common/inc/cutil.h"
extern enum CUTBoolean cutStartTimer(const unsigned);
# 706 "/home/u0332192/local/GPU_SDK/C/common/inc/cutil.h"
extern enum CUTBoolean cutStopTimer(const unsigned);
# 723 "/home/u0332192/local/GPU_SDK/C/common/inc/cutil.h"
extern float cutGetTimerValue(const unsigned);
# 50 "cu_lib.cu"
extern char *_Z12get_element3Pciii(char *, int, int, int);
# 180 "cu_lib.cu"
extern void _Z12print_memoryPciii(char *, int, int, int);
# 197 "cu_lib.cu"
extern void solver_constraint_wrapper(hash_tab *, char *);
# 252 "/home/u0332192/local/cuda/include/cuda_runtime.h"
extern  __attribute__((__weak__)) /* COMDAT group: _Z10cudaMallocIcE9cudaErrorPPT_m */ __inline__ cudaError_t _Z10cudaMallocIcE9cudaErrorPPT_m(char **, size_t);
extern int __cudaSetupArgSimple();
extern int __cudaLaunch();
extern int __cudaRegisterBinary();
extern int __cudaRegisterEntry();
static void __sti___14_cu_lib_cpp1_ii_4113a743(void) __attribute__((__constructor__));
# 167 "/usr/include/stdio.h" 3
extern struct _IO_FILE *stderr;
extern  __attribute__((__weak__)) /* COMDAT group: _ZTSSt9exception */ const char _ZTSSt9exception[13] __attribute__((visibility("default")));
extern  __attribute__((__weak__)) /* COMDAT group: _ZTSSt9bad_alloc */ const char _ZTSSt9bad_alloc[13] __attribute__((visibility("default")));
 __attribute__((__weak__)) /* COMDAT group: _ZTSSt9exception */ const char _ZTSSt9exception[13] __attribute__((visibility("default"))) = "St9exception";
 __attribute__((__weak__)) /* COMDAT group: _ZTSSt9bad_alloc */ const char _ZTSSt9bad_alloc[13] __attribute__((visibility("default"))) = "St9bad_alloc";
# 50 "cu_lib.cu"
char *_Z12get_element3Pciii( char *h,  int num_var,  int key,  int index) {
 int __cuda_local_var_37764_6_non_const_row;
 char *__cuda_local_var_37765_8_non_const_elem_addr;
# 51 "cu_lib.cu"
__cuda_local_var_37764_6_non_const_row = ((key + (index * num_var)) * 8);
__cuda_local_var_37765_8_non_const_elem_addr = (h + __cuda_local_var_37764_6_non_const_row);
return __cuda_local_var_37765_8_non_const_elem_addr;
}
# 180 "cu_lib.cu"
void _Z12print_memoryPciii( char *dish,  int szx,  int szy,  int szelt)
{
 int __cuda_local_var_37895_7_non_const_i;
# 182 "cu_lib.cu"
 int __cuda_local_var_37895_9_non_const_j;
# 182 "cu_lib.cu"
 int __cuda_local_var_37895_11_non_const_k;
# 182 "cu_lib.cu"
 int __cuda_local_var_37895_13_non_const_pos;
for (__cuda_local_var_37895_7_non_const_i = 0; (__cuda_local_var_37895_7_non_const_i < szx); __cuda_local_var_37895_7_non_const_i++) {
for (__cuda_local_var_37895_9_non_const_j = 0; (__cuda_local_var_37895_9_non_const_j < szy); __cuda_local_var_37895_9_non_const_j++) {
__cuda_local_var_37895_13_non_const_pos = (((__cuda_local_var_37895_9_non_const_j * szx) + __cuda_local_var_37895_7_non_const_i) * szelt);
printf(((const char *)"[%d,%d]\t"), __cuda_local_var_37895_7_non_const_i, __cuda_local_var_37895_9_non_const_j);
for (__cuda_local_var_37895_11_non_const_k = 0; (__cuda_local_var_37895_11_non_const_k < szelt); __cuda_local_var_37895_11_non_const_k++) {
printf(((const char *)"%c"), ((int)(dish[(__cuda_local_var_37895_13_non_const_pos + __cuda_local_var_37895_11_non_const_k)]))); }
printf(((const char *)"\t"));
}
printf(((const char *)"\n"));
}
printf(((const char *)"\n")); 
}


void solver_constraint_wrapper( hash_tab *c,  char *out_analysis) {
 int __cuda_local_var_37911_6_non_const_num_var;
 int __cuda_local_var_37912_6_non_const_num_const;
 int __cuda_local_var_37913_6_non_const_size;
 char *__cuda_local_var_37914_8_non_const_c_array;
 char *__cuda_local_var_37915_8_non_const_c_new_array;
 char *__cuda_local_var_37916_8_non_const_analysis;
 char *__cuda_local_var_37917_8_non_const_reflection;
 char *__cuda_local_var_37918_8_non_const_temp;
# 213 "cu_lib.cu"
 unsigned __cuda_local_var_37926_15_non_const_timer;
# 228 "cu_lib.cu"
 dim3 __cuda_local_var_37941_7_non_const_threads;
 dim3 __cuda_local_var_37942_7_non_const_grid;

 int __cuda_local_var_37944_6_non_const_empty_const;
 int *__cuda_local_var_37945_7_non_const_d_empty_const;
 int __cuda_local_var_37946_6_non_const_size_int;
# 252 "cu_lib.cu"
 char *__cuda_local_var_37965_8_non_const_out_c_new_array;
 char *__cuda_local_var_37966_8_non_const_out1;
# 253 "cu_lib.cu"
 char *__cuda_local_var_37966_14_non_const_out2;

 char *__cuda_local_var_37968_8_non_const_o1;
# 255 "cu_lib.cu"
 char *__cuda_local_var_37968_12_non_const_o2;
# 198 "cu_lib.cu"
__cuda_local_var_37911_6_non_const_num_var = (c->num_variable);
__cuda_local_var_37912_6_non_const_num_const = (c->num_constraint);
__cuda_local_var_37913_6_non_const_size = ((__cuda_local_var_37911_6_non_const_num_var * __cuda_local_var_37912_6_non_const_num_const) * 8);
# 213 "cu_lib.cu"
__cuda_local_var_37926_15_non_const_timer = 0U;

{  enum cudaError __cuda_local_var_37928_14_non_const_err;
# 215 "cu_lib.cu"
__cuda_local_var_37928_14_non_const_err = (cudaMalloc(((void **)(&__cuda_local_var_37914_8_non_const_c_array)), ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37928_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 215, (cudaGetErrorString(__cuda_local_var_37928_14_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37929_14_non_const_err;
# 216 "cu_lib.cu"
__cuda_local_var_37929_14_non_const_err = (cudaMalloc(((void **)(&__cuda_local_var_37915_8_non_const_c_new_array)), ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37929_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 216, (cudaGetErrorString(__cuda_local_var_37929_14_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37930_14_non_const_err;
# 217 "cu_lib.cu"
__cuda_local_var_37930_14_non_const_err = (cudaMalloc(((void **)(&__cuda_local_var_37916_8_non_const_analysis)), ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37930_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 217, (cudaGetErrorString(__cuda_local_var_37930_14_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37931_14_non_const_err;
# 218 "cu_lib.cu"
__cuda_local_var_37931_14_non_const_err = (cudaMalloc(((void **)(&__cuda_local_var_37917_8_non_const_reflection)), ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37931_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 218, (cudaGetErrorString(__cuda_local_var_37931_14_non_const_err))); exit(1); } } ; ;


__cuda_local_var_37918_8_non_const_temp = ((char *)(malloc(((size_t)__cuda_local_var_37913_6_non_const_size))));
memset(((void *)__cuda_local_var_37918_8_non_const_temp), 0, ((size_t)__cuda_local_var_37913_6_non_const_size));

{  enum cudaError __cuda_local_var_37937_14_non_const_err;
# 224 "cu_lib.cu"
__cuda_local_var_37937_14_non_const_err = (cudaMemcpy(((void *)__cuda_local_var_37914_8_non_const_c_array), ((const void *)(c->ht)), ((size_t)__cuda_local_var_37913_6_non_const_size), cudaMemcpyHostToDevice)); if (0 != ((int)__cuda_local_var_37937_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 224, (cudaGetErrorString(__cuda_local_var_37937_14_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37938_14_non_const_err;
# 225 "cu_lib.cu"
__cuda_local_var_37938_14_non_const_err = (cudaMemset(((void *)__cuda_local_var_37915_8_non_const_c_new_array), 0, ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37938_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 225, (cudaGetErrorString(__cuda_local_var_37938_14_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37939_14_non_const_err;
# 226 "cu_lib.cu"
__cuda_local_var_37939_14_non_const_err = (cudaMemset(((void *)__cuda_local_var_37916_8_non_const_analysis), 0, ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37939_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 226, (cudaGetErrorString(__cuda_local_var_37939_14_non_const_err))); exit(1); } } ; ;

{ (__cuda_local_var_37941_7_non_const_threads.x) = 104U; (__cuda_local_var_37941_7_non_const_threads.y) = 3U; (__cuda_local_var_37941_7_non_const_threads.z) = 1U; }
{ (__cuda_local_var_37942_7_non_const_grid.x) = 1U; (__cuda_local_var_37942_7_non_const_grid.y) = 1U; (__cuda_local_var_37942_7_non_const_grid.z) = 1U; }

__cuda_local_var_37944_6_non_const_empty_const = 1;

__cuda_local_var_37946_6_non_const_size_int = 4;

{  enum cudaError __cuda_local_var_37948_14_non_const_err;
# 235 "cu_lib.cu"
__cuda_local_var_37948_14_non_const_err = (cudaMalloc(((void **)(&__cuda_local_var_37945_7_non_const_d_empty_const)), ((size_t)__cuda_local_var_37946_6_non_const_size_int))); if (0 != ((int)__cuda_local_var_37948_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 235, (cudaGetErrorString(__cuda_local_var_37948_14_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37949_14_non_const_err;
# 236 "cu_lib.cu"
__cuda_local_var_37949_14_non_const_err = (cudaMemcpy(((void *)__cuda_local_var_37945_7_non_const_d_empty_const), ((const void *)(&__cuda_local_var_37944_6_non_const_empty_const)), ((size_t)__cuda_local_var_37946_6_non_const_size_int), cudaMemcpyHostToDevice)); if (0 != ((int)__cuda_local_var_37949_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 236, (cudaGetErrorString(__cuda_local_var_37949_14_non_const_err))); exit(1); } } ; ;

if (1 != ((int)(cutCreateTimer((&__cuda_local_var_37926_15_non_const_timer))))) { fprintf(stderr, ((const char *)"Cut error in file \'%s\' in line %i.\n"), ((const char *)("cu_lib.cu")), 238); exit(1); } ;
if (1 != ((int)(cutStartTimer(__cuda_local_var_37926_15_non_const_timer)))) { fprintf(stderr, ((const char *)"Cut error in file \'%s\' in line %i.\n"), ((const char *)("cu_lib.cu")), 239); exit(1); } ;


(cudaConfigureCall(__cuda_local_var_37942_7_non_const_grid, __cuda_local_var_37941_7_non_const_threads, 0UL, ((cudaStream_t)0LL))) ? ((void)0) : (__device_stub__Z23init_constraints_kernelPciiiS_S_Pi(__cuda_local_var_37914_8_non_const_c_array, __cuda_local_var_37911_6_non_const_num_var, __cuda_local_var_37912_6_non_const_num_const, 8, __cuda_local_var_37915_8_non_const_c_new_array, __cuda_local_var_37916_8_non_const_analysis, __cuda_local_var_37945_7_non_const_d_empty_const));

{  enum cudaError __cuda_local_var_37957_14_non_const_err;
# 244 "cu_lib.cu"
__cuda_local_var_37957_14_non_const_err = (cudaMemcpy(((void *)(&__cuda_local_var_37944_6_non_const_empty_const)), ((const void *)__cuda_local_var_37945_7_non_const_d_empty_const), 4UL, cudaMemcpyDeviceToHost)); if (0 != ((int)__cuda_local_var_37957_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 244, (cudaGetErrorString(__cuda_local_var_37957_14_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37958_14_non_const_err;
# 245 "cu_lib.cu"
__cuda_local_var_37958_14_non_const_err = (cudaMemcpy(((void *)__cuda_local_var_37917_8_non_const_reflection), ((const void *)__cuda_local_var_37915_8_non_const_c_new_array), ((size_t)__cuda_local_var_37913_6_non_const_size), cudaMemcpyDeviceToDevice)); if (0 != ((int)__cuda_local_var_37958_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 245, (cudaGetErrorString(__cuda_local_var_37958_14_non_const_err))); exit(1); } } ; ;



{  enum cudaError __cuda_local_var_37962_14_non_const_err;
# 249 "cu_lib.cu"
__cuda_local_var_37962_14_non_const_err = (cudaMemcpy(((void *)__cuda_local_var_37918_8_non_const_temp), ((const void *)__cuda_local_var_37915_8_non_const_c_new_array), ((size_t)__cuda_local_var_37913_6_non_const_size), cudaMemcpyDeviceToHost)); if (0 != ((int)__cuda_local_var_37962_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 249, (cudaGetErrorString(__cuda_local_var_37962_14_non_const_err))); exit(1); } } ; ;
# 257 "cu_lib.cu"
__cuda_local_var_37968_8_non_const_o1 = ((char *)(malloc(9UL)));
__cuda_local_var_37968_12_non_const_o2 = ((char *)(malloc(9UL)));
bzero(((void *)__cuda_local_var_37968_8_non_const_o1), 9UL);
bzero(((void *)__cuda_local_var_37968_12_non_const_o2), 9UL);
_Z10cudaMallocIcE9cudaErrorPPT_m((&__cuda_local_var_37966_8_non_const_out1), 8UL);
_Z10cudaMallocIcE9cudaErrorPPT_m((&__cuda_local_var_37966_14_non_const_out2), 8UL);

while (!(__cuda_local_var_37944_6_non_const_empty_const)) {
__cuda_local_var_37944_6_non_const_empty_const = 1;
{  enum cudaError __cuda_local_var_37979_15_non_const_err;
# 266 "cu_lib.cu"
__cuda_local_var_37979_15_non_const_err = (cudaMemcpy(((void *)__cuda_local_var_37945_7_non_const_d_empty_const), ((const void *)(&__cuda_local_var_37944_6_non_const_empty_const)), ((size_t)__cuda_local_var_37946_6_non_const_size_int), cudaMemcpyHostToDevice)); if (0 != ((int)__cuda_local_var_37979_15_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 266, (cudaGetErrorString(__cuda_local_var_37979_15_non_const_err))); exit(1); } } ; ;

{  enum cudaError __cuda_local_var_37981_15_non_const_err;
# 268 "cu_lib.cu"
__cuda_local_var_37981_15_non_const_err = (_Z10cudaMallocIcE9cudaErrorPPT_m((&__cuda_local_var_37965_8_non_const_out_c_new_array), ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37981_15_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 268, (cudaGetErrorString(__cuda_local_var_37981_15_non_const_err))); exit(1); } } ; ;
{  enum cudaError __cuda_local_var_37982_15_non_const_err;
# 269 "cu_lib.cu"
__cuda_local_var_37982_15_non_const_err = (cudaMemset(((void *)__cuda_local_var_37965_8_non_const_out_c_new_array), 0, ((size_t)__cuda_local_var_37913_6_non_const_size))); if (0 != ((int)__cuda_local_var_37982_15_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 269, (cudaGetErrorString(__cuda_local_var_37982_15_non_const_err))); exit(1); } } ; ;


(cudaConfigureCall(__cuda_local_var_37942_7_non_const_grid, __cuda_local_var_37941_7_non_const_threads, 0UL, ((cudaStream_t)0LL))) ? ((void)0) : (__device_stub__Z24solve_constraints_kernelPcS_iiS_S_PiS_S_(__cuda_local_var_37917_8_non_const_reflection, __cuda_local_var_37915_8_non_const_c_new_array, __cuda_local_var_37911_6_non_const_num_var, __cuda_local_var_37912_6_non_const_num_const, __cuda_local_var_37965_8_non_const_out_c_new_array, __cuda_local_var_37916_8_non_const_analysis, __cuda_local_var_37945_7_non_const_d_empty_const, __cuda_local_var_37966_8_non_const_out1, __cuda_local_var_37966_14_non_const_out2));
{  enum cudaError __cuda_local_var_37986_15_non_const_err;
# 273 "cu_lib.cu"
__cuda_local_var_37986_15_non_const_err = (cudaMemcpy(((void *)(&__cuda_local_var_37944_6_non_const_empty_const)), ((const void *)__cuda_local_var_37945_7_non_const_d_empty_const), ((size_t)__cuda_local_var_37946_6_non_const_size_int), cudaMemcpyDeviceToHost)); if (0 != ((int)__cuda_local_var_37986_15_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 273, (cudaGetErrorString(__cuda_local_var_37986_15_non_const_err))); exit(1); } } ; ;


cudaMemcpy(((void *)__cuda_local_var_37918_8_non_const_temp), ((const void *)__cuda_local_var_37965_8_non_const_out_c_new_array), ((size_t)__cuda_local_var_37913_6_non_const_size), cudaMemcpyDeviceToHost);


cudaFree(((void *)__cuda_local_var_37915_8_non_const_c_new_array));

__cuda_local_var_37915_8_non_const_c_new_array = __cuda_local_var_37965_8_non_const_out_c_new_array;
__cuda_local_var_37965_8_non_const_out_c_new_array = ((char *)0LL);
# 289 "cu_lib.cu"
cudaMemcpy(((void *)__cuda_local_var_37918_8_non_const_temp), ((const void *)__cuda_local_var_37915_8_non_const_c_new_array), ((size_t)__cuda_local_var_37913_6_non_const_size), cudaMemcpyDeviceToHost);

}


if (1 != ((int)(cutStopTimer(__cuda_local_var_37926_15_non_const_timer)))) { fprintf(stderr, ((const char *)"Cut error in file \'%s\' in line %i.\n"), ((const char *)("cu_lib.cu")), 294); exit(1); } ;
printf(((const char *)"Processing time:%f (ms)\n"), ((double)(cutGetTimerValue(__cuda_local_var_37926_15_non_const_timer))));
if (1 != ((int)(cutDeleteTimer(__cuda_local_var_37926_15_non_const_timer)))) { fprintf(stderr, ((const char *)"Cut error in file \'%s\' in line %i.\n"), ((const char *)("cu_lib.cu")), 296); exit(1); } ;

cudaMemcpy(((void *)__cuda_local_var_37968_8_non_const_o1), ((const void *)__cuda_local_var_37966_8_non_const_out1), 8UL, cudaMemcpyDeviceToHost);
cudaMemcpy(((void *)__cuda_local_var_37968_12_non_const_o2), ((const void *)__cuda_local_var_37966_14_non_const_out2), 8UL, cudaMemcpyDeviceToHost);
# 305 "cu_lib.cu"
{  enum cudaError __cuda_local_var_38018_14_non_const_err;
# 305 "cu_lib.cu"
__cuda_local_var_38018_14_non_const_err = (cudaMemcpy(((void *)out_analysis), ((const void *)__cuda_local_var_37916_8_non_const_analysis), ((size_t)__cuda_local_var_37913_6_non_const_size), cudaMemcpyDeviceToHost)); if (0 != ((int)__cuda_local_var_38018_14_non_const_err)) { fprintf(stderr, ((const char *)"Cuda error in file \'%s\' in line %i : %s.\n"), ((const char *)("cu_lib.cu")), 305, (cudaGetErrorString(__cuda_local_var_38018_14_non_const_err))); exit(1); } } ; ;
printf(((const char *)"\nSOLUTIONS=========\n"));
_Z12print_memoryPciii(out_analysis, 104, 3, 8);
cudaFree(((void *)__cuda_local_var_37914_8_non_const_c_array));
cudaFree(((void *)__cuda_local_var_37915_8_non_const_c_new_array));
cudaFree(((void *)__cuda_local_var_37916_8_non_const_analysis));

cudaFree(((void *)__cuda_local_var_37965_8_non_const_out_c_new_array)); 

}
# 252 "/home/u0332192/local/cuda/include/cuda_runtime.h"
 __attribute__((__weak__)) /* COMDAT group: _Z10cudaMallocIcE9cudaErrorPPT_m */ __inline__ cudaError_t _Z10cudaMallocIcE9cudaErrorPPT_m(
char **devPtr, 
size_t size)

{
return cudaMalloc(((void **)((void *)devPtr)), size);
}
static void __sti___14_cu_lib_cpp1_ii_4113a743(void) {   }

#include "cu_lib.cudafe1.stub.c"
