# RL-Viewer

A simple model viewer using Raylib that supports custom shaders via GLSL.  Doesn't work without raylib :(

## Build Instructions

```
gcc -std=gnu99 -o rl-viewer src/main.c -lraylib -lm
```

Or do the following if you have `clang`:

```
make
```
