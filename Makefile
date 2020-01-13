submodules = sram.v blinky.v
alldeps = top.v $(submodules)
testdeps = top_test.v $(submodules)
all: top.bin
test: top_test.fst
include Makefile.icestorm
