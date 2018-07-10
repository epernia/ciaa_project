# -------- Project Name ------------------------------------------------------
PROJECT_NAME=app

# -------- Compile options ---------------------------------------------------
VERBOSE=n
OPT=g
USE_FPU=y

# -------- Modules to include ----------------------------------------------
# y = use newlib nano, n = use full newlib
USE_NANO=y
SEMIHOST=n
USE_LPCOPEN=y
USE_SAPI=y
USE_FATFS_SSP=n
USE_FATFS_USB=n
USE_FREERTOS=n
FREERTOS_HEAP_TYPE=5

# -------- Core makefile -----------------------------------------------------
# You must define your core folder here (relative to this program folder)
CORE_PATH = ../cores/lpc4337

include $(CORE_PATH)/core.mk
