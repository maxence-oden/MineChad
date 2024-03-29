BIN = minechad.elf

LIB_FOLDER = Vowoxels
SRC_DIR = src

INCLUDES = -IVowoxels/lib/include -IVowoxels/src/include -Iinclude

CC = gcc-9
CFLAGS = -Wall -Wextra -O0 -g $(INCLUDES) $(shell pkg-config --cflags glfw3 gl sdl2)
LDFLAGS = $(shell pkg-config --libs gl glew glfw3 sdl2 SDL2_image) -pthread -lm -L. -lvowoxels

BUILD = build

INTERNALCFLAGS  :=       \
	-std=gnu17           \

SRCDIRS := $(shell find ./$(LIB_FOLDER) -type d)
SRCDIRS += $(shell find ./$(SRC_DIR) -type d)
# SRCDIRS += $(shell find ./src -type d)

CFILES := $(shell find ./$(LIB_FOLDER) -type f -name '*.c')
CFILES += $(shell find ./$(SRC_DIR) -type f -name '*.c')

OBJ    := $(CFILES:%.c=$(BUILD)/%.o)

$(shell mkdir -p $(addprefix $(BUILD)/,$(SRCDIRS)))

all: NODEBUG

warning: $(BIN)

.PHONY: all clean NODEBUG clean_deps

NODEBUG: $(BIN)
	@./$<

$(BIN): $(OBJ)
	@make -C Vowoxels
	@mv Vowoxels/vowoxels.a libvowoxels.a
	@$(CC) $(OBJ) $(LDFLAGS) -o $@

$(BUILD)/%.o: %.c
	@$(CC) -o $@ $(CFLAGS) $(INTERNALCFLAGS) -c $<

$(BUILD)/%.o: %.s
	@nasm $(ASMPARAM) -o $@ $<

clean:
	@make clean -C Vowoxels
	@rm -rf $(BUILD) $(BIN)
