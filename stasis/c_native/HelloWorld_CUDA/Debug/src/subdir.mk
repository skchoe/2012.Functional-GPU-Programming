################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/HelloWorld_CUDA.cu \
../src/HelloWorld_kernel.cu 

OBJS += \
./src/HelloWorld_CUDA.o \
./src/HelloWorld_kernel.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVIDIA CUDA Compiler'
	nvcc -I/home/skchoe/local/cuda/include -O0 -g -c -Xcompiler -fmessage-length=0 -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/HelloWorld_kernel.o: ../src/HelloWorld_kernel.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVIDIA CUDA Compiler'
	nvcc -I/home/skchoe/local/cuda/include -I/home/skchoe/local/GPU_SDK/C/common/inc -O0 -g -c -Xcompiler -fmessage-length=0 -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


