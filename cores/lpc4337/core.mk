COMMON_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
#COMMON_PATH=$(CORE_PATH)
$(info COMMON_PATH=$(COMMON_PATH))

MODULES_PATH=$(COMMON_PATH)/libs
MODULES=. $(sort $(dir $(wildcard $(MODULES_PATH)/*/)))
MODULES_MK=$(foreach m, $(MODULES), $(wildcard $(m)/module.mk))

SRC=$(wildcard *.c)
SRC+=$(foreach m, $(MODULES), $(wildcard $(m)/src/*.c))

CXXSRC=$(wildcard *.cpp)
CXXSRC+=$(foreach m, $(MODULES), $(wildcard $(m)/src/*.cpp))

ASRC=$(wildcard *.s)
ASRC+=$(foreach m, $(MODULES), $(wildcard $(m)/src/*.s))

OUT=out
OBJECTS=$(CXXSRC:%.cpp=$(OUT)/%.o) $(ASRC:%.s=$(OUT)/%.o) $(SRC:%.c=$(OUT)/%.o)
DEPS=$(OBJECTS:%.o=%.d)

OOCD_SCRIPT=$(COMMON_PATH)/openocd/lpc4337_openocd.cfg

TARGET=$(OUT)/$(PROJECT_NAME).elf
TARGET_BIN=$(basename $(TARGET)).bin
TARGET_LST=$(basename $(TARGET)).lst
TARGET_MAP=$(basename $(TARGET)).map
TARGET_NM=$(basename $(TARGET)).names.csv

INCLUDE_FLAGS=$(foreach m, $(MODULES), -I$(m)/inc) -Iinc $(INCLUDES)
DEFINES_FLAGS=$(foreach m, $(DEFINES), -D$(m))
OPT_FLAGS=-ggdb3 -O$(OPT) -ffunction-sections -fdata-sections

COMMON_FLAGS=$(ARCH_FLAGS) $(DEFINES_FLAGS) $(INCLUDE_FLAGS) $(OPT_FLAGS)

CFLAGS=$(COMMON_FLAGS) -std=c99
CXXFLAGS=$(COMMON_FLAGS) -fno-rtti -fno-exceptions -std=c++11

LDFLAGS=$(ARCH_FLAGS)
LDFLAGS+=$(foreach m, $(MODULES), -L$(m)/lib)
LDFLAGS+=-Tlink.ld
LDFLAGS+=-nostartfiles -Wl,-gc-sections -Wl,-Map=$(TARGET_MAP) -Wl,--cref

ifeq ($(USE_NANO),y)
$(info with newlib nano)
LDFLAGS+=--specs=nano.specs
endif

ifeq ($(SEMIHOST),y)
$(info with semihosting)
LDFLAGS+=--specs=rdimon.specs
endif

ifeq ($(USE_NOSYS),y)
$(info with nosys library)
LDFLAGS+=--specs=nosys.specs
endif

CROSS=arm-none-eabi-
CC=$(CROSS)gcc
CXX=$(CROSS)g++
ifeq ($(CXXSRC),)
LD=$(CROSS)gcc
else
LD=$(CROSS)g++
endif
SIZE=$(CROSS)size
LIST=$(CROSS)objdump -xdS
OBJCOPY=$(CROSS)objcopy
NM=$(CROSS)nm
GDB=$(CROSS)gdb
OOCD=openocd

ifeq ($(VERBOSE),y)
Q=
else
Q=@
endif

#WITH_SED=$(shell which sed)
#WITH_MEMORY_USAGE=$(shell $(LD) -Wl,--help|grep memory-usage)

ifneq ($(WITH_MEMORY_USAGE),)
$(info with memory usage)
LDFLAGS+=-Wl,--print-memory-usage
endif

OBJECTS_FILTERED=$(OBJECTS)
OBJ_DIR=$(dir $@)
OBJ_=$@
#OBJECTS_FILTERED=$(foreach obj, $(OBJECTS), $(subst $(COMMON_PATH)/,,$(obj)))
#OBJ_DIR=$(subst $(COMMON_PATH)/,,$(dir $@))
#OBJ_=$(subst $(COMMON_PATH)/,,$@)

all: $(TARGET) $(TARGET_BIN) $(TARGET_LST) $(TARGET_NM) size

-include $(MODULES_MK)

-include $(DEPS)

info:
	@echo MODULES:    $(MODULES)
	@echo MODULES_MK: $(MODULES_MK)
	@echo SRC:        $(SRC)
	@echo CFLAGS:     $(CFLAGS)

$(OUT)/%.o: %.c
	@echo CC $(notdir $<)
	@mkdir -p $(OBJ_DIR)
	$(Q)$(CC) -MMD $(CFLAGS) -c -o $(OBJ_) $<

$(OUT)/%.o: %.cpp
	@echo CXX $(notdir $<)
	@mkdir -p $(OBJ_DIR)
	$(Q)$(CXX) -MMD $(CXXFLAGS) -c -o $(OBJ_) $<

$(OUT)/%.o: %.s
	@echo AS $(notdir $<)
	@mkdir -p $(OBJ_DIR)
	$(Q)$(CC) -MMD $(CFLAGS) -c -o $(OBJ_) $<

$(TARGET): $(OBJECTS)
	@echo LD $@...
	$(Q)$(LD) $(LDFLAGS) -o $(OBJ_) $(OBJECTS_FILTERED)

$(TARGET_BIN): $(TARGET)
	$(Q)$(OBJCOPY) -v -O binary $< $(OBJ_)

$(TARGET_LST): $(TARGET)
	@echo LIST
	$(Q)$(LIST) $< > $(OBJ_)

#ifneq ($(WITH_SED),)
## If you doesn't have sed
#$(info with SED)
#$(TARGET_NM): $(TARGET)
#	@echo NAME
#	$(Q)$(NM) -nAsSCp $< > $(OBJ_)
#else
## If you have sed
#$(info without SED)
$(TARGET_NM): $(TARGET)
	@echo NAME
#	$(Q)$(NM) -nAsSCp $< \
#		| sed -r 's/(.+?\:[^ ]+) ([a-zA-Z\?] [a-zA-Z_].*)/\1 00000000 \2/' \
#		| sed -r 's/(.+?)\:([a-fA-F0-9]+) ([a-fA-F0-9]+) ([a-zA-Z\?]) (.*)/\1\t0x\2\t0x\3\t\4\t\5/' \
#		> $@
#endif

size: $(TARGET)
	$(Q)$(SIZE) $<

download: $(TARGET_BIN)
	@echo DOWNLOAD
	$(Q)$(OOCD) -f $(OOCD_SCRIPT) \
		-c "init" \
		-c "halt 0" \
		-c "flash write_image erase unlock $< 0x1A000000 bin" \
		-c "reset run" \
		-c "shutdown" 2>&1

erase:
	@echo ERASE
	$(Q)$(OOCD) -f $(OOCD_SCRIPT) \
		-c "init" \
		-c "halt 0" \
		-c "flash erase_sector 0 0 last" \
		-c "shutdown" 2>&1

debug:
	@echo DEBUG
	$(Q)$(OOCD) -f $(OOCD_SCRIPT) 2>&1

clean:
	@echo CLEAN
	$(Q)rm -fR $(OBJECTS) $(TARGET) $(TARGET_BIN) $(TARGET_LST) $(DEPS) $(OUT)

.PHONY: all size download erase debug clean
