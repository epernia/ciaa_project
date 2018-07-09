ifeq ($(USE_FREERTOS),y)

FREERTOS_PATH=$(MODULES_PATH)/freertos
SRC+=$(FREERTOS_PATH)/MemMang/heap_$(FREERTOS_HEAP_TYPE).c

INCLUDES += -I$(FREERTOS_PATH)/include
INCLUDES += -I$(FREERTOS_PATH)/include/private

DEFINES+=USE_FREERTOS
DEFINES+=TICK_OVER_RTOS

SRC+=$(wildcard $(FREERTOS_PATH)/source/*.c)
SRC+=$(wildcard $(FREERTOS_PATH)/source/portable/*.c)

ifeq ($(USE_FPU),y)
INCLUDES += -I$(FREERTOS_PATH)/source/portable/ARM_CM4F
SRC+=$(FREERTOS_PATH)/source/portable/ARM_CM4F/port.c
else
INCLUDES += -I$(FREERTOS_PATH)/source/portable/ARM_CM3
SRC+=$(FREERTOS_PATH)/source/portable/ARM_CM3/port.c
endif

endif
