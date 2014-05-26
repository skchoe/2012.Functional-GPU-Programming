#ifndef _SIMPLEGL_KERNEL_H_
#define _SIMPLEGL_KERNEL_H_
extern "C"
__global__ void kernel(float4* pos, int width, int height, int time)
{
	unsigned int x = blockDim.x * blockIdx.x + threadIdx.x;
	unsigned int y = blockDim.y * blockIdx.y + threadIdx.y;
	unsigned int i = y * width + x;
	float u = 2.0 * x / width - 1.0;
	float v = 2.0 * y / width - 1.0;
	float freq = 5.0;
	float w = sinf(u * freq + time) + cosf(v * freq + time) * 0.5;

	pos[i] = make_float4(u, v, w, 1.0f);
}
#endif

