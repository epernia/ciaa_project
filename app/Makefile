# -------- Project Name ------------------------------------------------------
PROJECT_NAME=app

# -------- Compile options ---------------------------------------------------
# y = Verbose compilation output (slower)
VERBOSE=n
# Optimization options: g, 0, 1, 2, 3, s, fast
OPT=g
# y = use Hardware FPU
USE_FPU=y

# -------- Modules to include ----------------------------------------------
# y = use newlib nano, n = use full newlib
USE_NANO=y
# y = use semihosting
SEMIHOST=n
# y = use LPCOpen library
USE_LPCOPEN=y
# y = use sAPI library
USE_SAPI=y
# y = use el-chan FAT FS library (SSP disk)
USE_FATFS_SSP=n
# y = use el-chan FAT FS library (pendrive disk)
USE_FATFS_USB=n
# y = use FreeRTOS library
USE_FREERTOS=n
# FreeRTOS heap type (1 to 5)
FREERTOS_HEAP_TYPE=5

# -------- Core makefile -----------------------------------------------------
# You must define your core folder here (relative to this program folder)
CORE_PATH = ../cores/lpc4337

include $(CORE_PATH)/core.mk
