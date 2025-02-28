CC := clang -std=gnu99
CFLAGS := -Wall -Wextra -ggdb -O0
LDFLAGS := -lraylib
ifneq ($(OS),Windows_NT)
LDFLAGS += -lm
endif

SRC := $(wildcard src/*.c)
# I honestly thought I was going to need something other than just main.c, that's why there's a src dir

.PHONY: default clean test

default: rl-viewer

test: rl-viewer
	${CURDIR}/rl-viewer -m assets/utah.obj -f shaders/sheen_frag.glsl

rl-viewer: $(SRC)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f rl-viewer rl-viewer.exe

compile_commands.json: $(SRC)
	$(CC) -MJ temp $(CFLAGS) -c $^ $(INC)
	python -c 'with open("temp", "r") as f:\
    print("[\n{}\n]".format(f.read()[:-2]))' > compile_commands.json
	rm temp *.o
