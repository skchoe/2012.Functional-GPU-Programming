################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/main.cu 

OBJS += \
./src/main.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVIDIA CUDA Compiler'
	nvcc -I/home/u0332192/local/cuda/include -I/home/u0332192/local/GPU_SDK/C/common/inc -O0 -g -c -Xcompiler -fmessage-length=0 -arch sm_11 -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


