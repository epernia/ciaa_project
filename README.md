# CIAA PROJECT

CIAA project Boards ASM, C or C++ project 

## IMPORTANT

**This environment is under construction!!**

**Always use the [released versions](../../releases) because in these all examples are tested and the API documentation is consistent. The master branch may contain inconsistencies because this environment is currently under development.**

## Supported boards
- Core lpc4337 tha includes:
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

## Create a new project
- Copy "app" example project.
- Each project consist in a folder (with a non-spaces name) that includes inside 2 folders, one named ```src``` (here go, .c, .cpp or .s source code files), and another one named ```inc``` (here go, .h or .hpp source header files) and the project's ```Makefle```, where you may configure which libraries you include and compiler options.

## Examples
- CIAA-NXP or EDU-CIAA-NXP: https://github.com/epernia/ciaa_lpc4337_examples