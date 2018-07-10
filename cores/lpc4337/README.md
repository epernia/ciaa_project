# CIAA CORE LIBRARIES FOR NXP LPC4337 (CIAA-NXP AND EDU-CIAA-NXP)

by Eric Pernia and Martin Ribelotta.

## Available libraries:
- LPCOpen v3.01
- sAPI v0.5.1.
- FreeRTOS Kernel V10.0.1

## Supported boards
- CIAA-NXP (LPC4337).
- EDU-CIAA-NXP (LPC4337).

## Supported toolchains
- gcc-arm-none-eabi

## Add a new library

The ```libs``` folder allow you to include 2 types of libraries:

- Simplie library. Consist in a folder (with a non-spaces name) that includes inside 2 folders, one named ```src``` (here go .c, .cpp or .s source code files), and another one named ```inc``` (here go .h or .hpp header files). This kind of library compiles automaticaly by the Makefile.
- Advanced library. Consist in a library whit a complex folder and files strcuture, i.e. LibUSB. This case reuire make your own makefile. You can inspire from available libs makefiles to do that.
