ifeq ($(USE_SAPI),y)

SAPI_PATH=$(MODULES_PATH)/sapi
DEFINES+=USE_SAPI
INCLUDES += -I$(SAPI_PATH)/sapi_v0.5.1/inc
SRC+=$(wildcard $(SAPI_PATH)/sapi_v0.5.1/src/*.c)

endif
