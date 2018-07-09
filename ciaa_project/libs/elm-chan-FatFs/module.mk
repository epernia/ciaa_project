ifeq ($(USE_FATFS_SSP),y)
ifeq ($(USE_FATFS_USB),y)
$(error "Error: Only incluede FATFS_SSP or FATFS_USB, not both!")
endif
FATFS_PATH=$(MODULES_PATH)/elm-chan-FatFs/fatfs_ssp
DEFINES+=USE_FATFS_SSP
INCLUDES += -I$(FATFS_PATH)/inc
SRC+=$(wildcard $(FATFS_PATH)/src/*.c)
endif

ifeq ($(USE_FATFS_USB),y)
FATFS_PATH=$(MODULES_PATH)/elm-chan-FatFs/fatfs_usb
DEFINES+=USE_FATFS_USB
INCLUDES += -I$(FATFS_PATH)/inc
SRC+=$(wildcard $(FATFS_PATH)/src/*.c)
endif