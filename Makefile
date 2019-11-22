all: top.bin
# not happy with this following, but changing a .v doesn't change the .icmd, so if you've already done a make test changing the .v doesn't motivate another one.
# FIND OUT HOW TO MAKE THE .V FILES A DEPENDENCY!
# also the way the osresearch code top & tb work they include the other v files, so I don't know if changing say sram.v makes any difference
# https://stackoverflow.com/questions/3267145/makefile-execute-another-target about how to do other targets as dependencies and multithread and stuff.
test: clean
test: top_test.fst
include Makefile.icestorm
