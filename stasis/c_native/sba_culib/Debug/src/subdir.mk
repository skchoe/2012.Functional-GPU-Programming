################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/gstm_common.cpp 

CU_SRCS += \
../src/gstm_driver.cu \
../src/gstm_kernel.cu 

CU_DEPS += \
./src/gstm_driver.d \
./src/gstm_kernel.d 

OBJS += \
./src/gstm_common.o \
./src/gstm_driver.o \
./src/gstm_kernel.o 

CPP_DEPS += \
./src/gstm_common.d 


# Each subdirectory must supply rules for building sources it contributes
src/gstm_common.o: ../src/gstm_common.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	nvcc -I/home/skchoe/project-gpu/inc -G -g -O0 -gencode arch=compute_12,code=sm_12 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	nvcc --compile -G -I/home/skchoe/project-gpu/inc -O0 -g -gencode arch=compute_12,code=compute_12 -gencode arch=compute_12,code=sm_12 -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/gstm_driver.o: ../src/gstm_driver.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	nvcc -I/home/skchoe/project-gpu/inc -G -g -O0 -gencode arch=compute_12,code=sm_12 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	nvcc --compile -G -I/home/skchoe/project-gpu/inc -O0 -g -gencode arch=compute_12,code=compute_12 -gencode arch=compute_12,code=sm_12 -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/gstm_kernel.o: ../src/gstm_kernel.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	nvcc -I/home/skchoe/project-gpu/inc -G -g -O0 -gencode arch=compute_12,code=sm_12 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	nvcc --compile -G -I/home/skchoe/project-gpu/inc -O0 -g -gencode arch=compute_12,code=compute_12 -gencode arch=compute_12,code=sm_12 -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


