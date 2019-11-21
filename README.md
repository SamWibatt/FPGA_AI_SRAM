# FPGA_AI_SRAM
Preliminary part of AI acceleration with FPGAs, interfacing external memory for greater capacity.

# Objective

The initial goal is to try accelerating some data structures such as red/black trees and running some old AI techniques like A* to get a feel for how well programmable logic can tighten them up.

Ultimately, I want to implement modern methods such as RNNs, but since I'm still working on tiny cheap eval boards it's unlikely I can do much - but I will look into it, and I will learn some useful things in this endeavor that will transfer (transfer learning LOL) I imagine I'm also going to have to pick up DSP for best results there.

OK so now got this project cloned onto makevm4, let's try a push from it. Not on the VPN, so I expect it to work.

Copied over some initial stuff like osresearch's makefile for their serial project, need hack up to do what I want AND DO WHATEVER I NEED TO DO TO SATISFY THE TERMS OF THEIR LICENSE!!!!!!!!!!!!

# Notes

I will be keeping my usual stream of consciousness [notes in the repo wiki, qv](https://github.com/SamWibatt/FPGA_AI_SRAM/wiki).

Makefile, Makefile.icestorm, and upduino_v2.pcf are copied and modified from osresearch's code at https://github.com/osresearch/up5k licensed under GPL3
