################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../bvg.cu 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVIDIA CUDA Compiler'
	nvcc -I/home/skchoe/local/cuda/include -O0 -g -c -Xcompiler -fmessage-length=0 -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


