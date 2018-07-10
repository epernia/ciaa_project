# CIAA PROJECT EXAMPLE C APP

## IMPORTANT

**This environment is under construction!!**

**Always use the [released versions](../../releases) because in these all examples are tested and the API documentation is consistent. The master branch may contain inconsistencies because this environment is currently under development.**

## Supported boards
- Core lpc4337 that includes:
    - CIAA-NXP (LPC4337).
    - EDU-CIAA-NXP (LPC4337).

## Supported toolchains
- gcc-arm-none-eabi

## Available libraries
- It depends on selected core. See README.md on each folder inside core folder.

## Using "app" example project
- Make sure you have an ```arm-none-eabi-*``` toolchain configured in your ```PATH```. If you don't have it, download [GCC ARM Embedded](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm).
- Inside "app" folder:
- Compile with ```make```.
- Clean with ```make clean```. Clean for all targets with ```make clean_all```.
- Download to target via OpenOCD with ```make download```.

### Makefile

```
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
```

## Create a new project
- Copy "app" example project.
- Each project consist in a folder (with a non-spaces name) that includes inside 2 folders, one named ```src``` (here go, .c, .cpp or .s source code files), and another one named ```inc``` (here go, .h or .hpp source header files) and the project's ```Makefle```, where you may configure which libraries you include and compiler options.

## More Examples
- CIAA-NXP or EDU-CIAA-NXP: https://github.com/epernia/ciaa_lpc4337_examples