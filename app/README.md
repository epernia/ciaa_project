# CIAA PROJECT EXAMPLE C APP

## Using "app" example project
- Make sure you have an ```arm-none-eabi-*``` toolchain configured in your ```PATH```. If you don't have it, download [GCC ARM Embedded](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm).
- Inside "app" folder:
    - Compile with ```make```.
    - Clean with ```make clean```.
    - Download to target via OpenOCD with ```make download```.

### Makefile

```makefile
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
```

## Create a new project
- Copy "app" example project.
- Each project consist in a folder (with a non-spaces name) that includes inside 2 folders, one named ```src``` (here go, .c, .cpp or .s source code files), and another one named ```inc``` (here go, .h or .hpp source header files) and the project's ```Makefle```, where you may configure which libraries you include and compiler options.

## More Examples
- [NXP LPC4337 (CIAA-NXP or EDU-CIAA-NXP)](../../../../ciaa_lpc4337_examples).