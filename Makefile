# Simple Makefile for compiling eBPF programs

# BPF C compiler
CLANG ?= clang
# BPF target architecture
TARGET_ARCH ?= bpf

# Source and output directories
SRC_DIR = bpf
OUT_DIR = build

# Find all .c files in the source directory
SOURCES = $(wildcard $(SRC_DIR)/*.c)
# Generate object file names from source file names
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.o, $(SOURCES))

# Kernel headers - this might need adjustment depending on the system
# For many systems, this path is correct. For others, you might need to install kernel headers.
LINUX_HEADERS ?= /lib/modules/$(shell uname -r)/build

# Compiler flags
CFLAGS = -I$(LINUX_HEADERS) -I. -O2 -target $(TARGET_ARCH) -g -c

.PHONY: all clean

all: $(OUT_DIR) $(OBJECTS)

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.o: $(SRC_DIR)/%.c
	$(CLANG) $(CFLAGS) -o $@ $<

clean:
	rm -rf $(OUT_DIR)
