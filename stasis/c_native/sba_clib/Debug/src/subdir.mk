################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/stm_common.c \
../src/stm_driver.c \
../src/stm_kernel.c 

OBJS += \
./src/stm_common.o \
./src/stm_driver.o \
./src/stm_kernel.o 

C_DEPS += \
./src/stm_common.d \
./src/stm_driver.d \
./src/stm_kernel.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -I/home/skchoe/project-gpu/inc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


