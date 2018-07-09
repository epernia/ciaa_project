PROJECT_PATH = $(CURDIR)
#$(info PROJECT_PATH="$(PROJECT_PATH)")
PROJECT_NAME = $(notdir $(CURDIR))

MODULES_PATH=$(CIAA_PORJECT_PATH)/libs
MODULES=$(sort $(dir $(wildcard $(MODULES_PATH)/*/)))

SRC=$(wildcard $(PROJECT_PATH)/src/*.c)
SRC+=$(foreach m, $(MODULES), $(wildcard $(m)/src/*.c))


CXXSRC=$(wildcard $(PROJECT_PATH)/src/*.cpp)
CXXSRC+=$(foreach m, $(MODULES), $(wildcard $(m)/src/*.cpp))

ASRC=$(wildcard $(PROJECT_PATH)/src/*.s)
ASRC+=$(foreach m, $(MODULES), $(wildcard $(m)/src/*.s))

OUT=out

OBJECTS=$(CXXSRC:%.cpp=$(OUT)/%.o) $(ASRC:%.s=$(OUT)/%.o) $(SRC:%.c=$(OUT)/%.o)
DEPS=$(OBJECTS:%.o=%.d)

OOCD_SCRIPT=$(CIAA_PORJECT_PATH)/scripts/lpc4337_openocd.cfg

TARGET=$(OUT)/$(PROJECT_NAME).elf
TARGET_BIN=$(basename $(TARGET)).bin
TARGET_LST=$(basename $(TARGET)).lst
TARGET_MAP=$(basename $(TARGET)).map
TARGET_NM=$(basename $(TARGET)).names.csv

INCLUDE_FLAGS=$(foreach m, $(MODULES), -I$(m)/inc) -I$(PROJECT_PATH)/inc $(INCLUDES)
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
LDFLAGS+=--specs=nano.specs
endif

ifeq ($(SEMIHOST),y)
LDFLAGS+=--specs=rdimon.specs
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

all: $(TARGET) $(TARGET_BIN) $(TARGET_LST) $(TARGET_NM) size

-include $(foreach m, $(MODULES), $(wildcard $(m)/module.mk))

-include $(DEPS)

$(OUT)/%.o: %.c
	@echo CC $(notdir $<)
	@mkdir -p $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$(dir $@)))
	$(Q)$(CC) -MMD $(CFLAGS) -c -o $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$@)) $<   

$(OUT)/%.o: %.cpp
	@echo CXX $(notdir $<)
	@mkdir -p $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$(dir $@)))
	$(Q)$(CXX) -MMD $(CXXFLAGS) -c -o $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$@)) $<  

$(OUT)/%.o: %.s
	@echo AS $(notdir $<)
	@mkdir -p $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$(dir $@)))
	$(Q)$(CC) -MMD $(CFLAGS) -c -o $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$@)) $<  
   
OBJECTS_FILTERED=$(foreach obj, $(OBJECTS), $(subst $(PROJECT_PATH)/,,$(subst 	$(CIAA_PORJECT_PATH)/,,$(obj))))

$(TARGET): $(OBJECTS)
	@echo LD $@...
	$(Q)$(LD) $(LDFLAGS) -o $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$@)) $(OBJECTS_FILTERED)

$(TARGET_BIN): $(TARGET)
	$(Q)$(OBJCOPY) -v -O binary $< $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$@))

$(TARGET_LST): $(TARGET)
	@echo LIST
	$(Q)$(LIST) $< > $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$@))

# If you have sed
#$(TARGET_NM): $(TARGET)
#	@echo NAME
#	$(Q)$(NM) -nAsSCp $< \
#		| sed -r 's/(.+?\:[^ ]+) ([a-zA-Z\?] [a-zA-Z_].*)/\1 00000000 \2/' \
#		| sed -r 's/(.+?)\:([a-fA-F0-9]+) ([a-fA-F0-9]+) ([a-zA-Z\?]) (.*)/\1\t0x\2\t0x\3\t\4\t\5/' \
#		> $@

# If you doesn't have sed
$(TARGET_NM): $(TARGET)
	@echo NAME
	$(Q)$(NM) -nAsSCp $< > $(subst $(PROJECT_PATH)/,,$(subst $(CIAA_PORJECT_PATH)/,,$@))

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
