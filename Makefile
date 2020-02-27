submodules = sram.v blinky.v
alldeps = top.v $(submodules)
testdeps = top_test.v $(submodules)
# the STEP variable ends up as a define that gets inspected in .v files
# used to distinguish build and simulation, for things like avoiding enormous
# counters in gtkview.
# haven't figured out how to communicate this to yosys yet!!!
all: STEP = BUILD_STEP
all: top.bin
test: STEP = SIM_STEP
test: top_test.fst
include Makefile.icestorm
