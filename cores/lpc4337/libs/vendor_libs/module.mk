ifeq ($(USE_LPCOPEN),y)

LPCOPEN_PATH=$(MODULES_PATH)/vendor_libs
DEFINES+=__USE_LPCOPEN

SRC+=$(wildcard $(LPCOPEN_PATH)/lpc_board_ciaa_edu_4337/src/*.c) 
INCLUDES+=-I$(LPCOPEN_PATH)/lpc_board_ciaa_edu_4337/inc

SRC+=$(wildcard $(LPCOPEN_PATH)/lpc_chip_43xx/src/*.c) 
INCLUDES+=-I$(LPCOPEN_PATH)/lpc_chip_43xx/inc
INCLUDES+=-I$(LPCOPEN_PATH)/lpc_chip_43xx/inc/usbd_rom
INCLUDES+=-I$(LPCOPEN_PATH)/lpc_chip_43xx/inc/config_43xx

endif

DEFINES+=CORE_M4 __USE_NEWLIB
ARCH_FLAGS=-mcpu=cortex-m4 -mthumb

ifeq ($(USE_FPU),y)
ARCH_FLAGS+=-mfloat-abi=hard -mfpu=fpv4-sp-d16
endif

LDSCRIPT=lpc4337.ld

SRC+=$(wildcard $(LPCOPEN_PATH)/lpc_startup/src/*.c) 
INCLUDES+=-I$(LPCOPEN_PATH)/lpc_startup/inc

