################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/driver.c \
../src/hashfunc.c \
../src/hashtab.c 

CU_SRCS += \
../src/cu_lib.cu 

OBJS += \
./src/cu_lib.o \
./src/driver.o \
./src/hashfunc.o \
./src/hashtab.o 

C_DEPS += \
./src/driver.d \
./src/hashfunc.d \
./src/hashtab.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVIDIA CUDA Compiler'
	nvcc -I/home/skchoe/local/cuda/include -I/home/skchoe/local/GPU_SDK/C/common/inc -O0 -g -c -Xcompiler -fmessage-length=0 -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


