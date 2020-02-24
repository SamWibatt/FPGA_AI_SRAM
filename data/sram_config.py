#!/usr/bin/env python3
# configuration for FPGA_AI_SRAM project
# given a clock speed in Hz, emits timing values for accessing a Cypress
# Semiconductor Corp. CY62157EV30LL-45ZXIT 1Mx8 SRAM
# based on:
# configuration for FPGA_HD44780
# since I'm doing something with the calculated defines that yosys doesn't like, let's just
# calculate them externally and #include them.
#
# usage: sram_config.py (sysclock Hz) > (includefile).v
# e.g. for up5K at 48MHz do
# sram_config.py 48000000 > sram_inc.v
#
# can make multiple include files and switch between them depending on simulation or production
# THOUGH YOU KNOW WHAT, NONE OF THIS REALLY MATTERS WHEN YOUR CLOCK IS 48MHZ BECAUSE THEN ONE TICK
# IS 20.8333 NANOS (48MHZ) for a 45 ns chip
# but then, you never know when I might want to use this with a 50GHz fpga in 2037 as an old hobbyist
#
import math
import sys

# tiny utility fiddlement - given a number of nanoseconds, x, figur out how many clock ticks that is in the
# given freq (Hz)
#`define TICKS_PER_NS(x) ($ceil(($itor(  x)/$itor(1_000_000_000)) / ($itor(1)/$itor(`G_SYSFREQ))))
# returns at least 1 for any number > 0, erring on the side of slowness but assuming any delay
# we care about enough to calculate must be at least 1 tick.
def ticks_per_ns(x,freq):
    return math.ceil((float(x)/1000000000.0) / (1.0/freq))

# given an int like 1000, turns into verilog underscored style for readability like 1_000
def make_verilog_number_str(x):
    num = int(x)
    if num < 1000:
        return str(num)
    else:
        # ok here figure out how to stick a _ in all the right spots.
        # ha, can just do this, per https://stackoverflow.com/questions/1823058/how-to-print-number-with-commas-as-thousands-separators/10742904
        # >>> f'{value:_}'
        # '48_000_000'
        # better, '{:_}'.format(value) bc the previous kind needs python 3.7 and people might be a bit behind
        return '{:_}'.format(num)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("usage: sram_config.py (sysclock Hz) > (includefile).v")
        print("e.g. for up5K at 48MHz do")
        print("sram_config.py 48000000 > sram_def.inc")
        print("Then `include sram_def.inc in your design")
        print(
        '''
        Can use a define to switch between different configs in your .v -
        `ifndef SIM_STEP
        `include sram_build_config.inc
        `else
        `include sram_sim_config.inc
        `endif
        ''')
        sys.exit(1)

    # ok, calc some stuff
    g_sysfreq = float(sys.argv[1])              # the heart of it all, system frequency.

    # delays for the sram state machine, which will do timing with its own little (unless you're running at petaHz) downcounter
    # Here's the sketch of the state machine from my "what the module does" page on wiki:
    # https://github.com/SamWibatt/FPGA_AI_SRAM/wiki/00---What-The-Module-Does
    #
    # * so given that the chip enables are always set, read cycle 2:
    #     * at idle both ~OE and ~WE high
    #     * mark cycle start, or whatever
    #     * mark busy
    #     * set address (would also set CE lines here too)
    #     * (would be a wait then set BLE/BHE, though those are also glued)
    #     * wait - tACE - tDOE = max 45 - max 22 = 23 ns?
    ticks_tace_tdoe = ticks_per_ns(23,g_sysfreq)
    #     * drop ~OE
    #     * wait tDOE = max 22ns
    ticks_tdoe = ticks_per_ns(22,g_sysfreq)
    #     * latch data
    #     * mark ready for mentor to harvest the byte?
    #     * wait for rest of tRC ... I think can do 0 but let's say not < 1
    ticks_endrd2 = ticks_per_ns(max(1,45 - (ticks_tace_tdoe + ticks_tdoe)),g_sysfreq)
    #
    #
    #
    # * then can do subsequent bytes, as many as needed, rdcyc 1
    #     * mark busy
    #     * change address
    #     * wait tAA = max 45ns
    ticks_taa = ticks_per_ns(45,g_sysfreq)
    #     * latch data
    #     * mark ready for mentor to harvest
    # * to wrap up,
    #     * raise ~OE
    #     * wait tHZOE = max 18ns (note 29, I/Os are in output, do not apply signal)
    ticks_thzoe = ticks_per_ns(18,g_sysfreq)
    #     * mark cycle end
    #
    #
    #
    # * write: Looks like I'm using write cycle 1 from the docs...?
    #     * address
    #     * raise ~OE - or is it already?
    #     * wait tHZOE = max 18 ns (note 29, I/Os are in output, do not apply signal)
    # already got thzoe
    #     * wait tSA - tHZOE = min 0 ns, no max ....??? let's do 1 tick
    ticks_tsa_thzoe = ticks_per_ns(1,g_sysfreq)
    #         * Write cycle 1 timings are subject to the notes 26 27 and 28:
    #           "26. The internal write time of the memory is defined by the overlap of WE, CE =
    #           V IL , BHE, BLE or both = V IL , and CE 2 = V IH . All signals must be active to initiate
    #           a write and any of these signals can terminate a write by going inactive. The data
    #           input setup and hold timing must be referenced to the edge of the signal that
    #           terminates the write. (In my case that'd be ~WE, bc all the others are hardwired)
    #           27. Data I/O is high impedance if OE = V IH .
    #           28. If CE 1 goes HIGH and CE 2 goes LOW simultaneously with WE = V IH , the output
    #           remains in a high impedance state.
    #           29. During this period (raise ~OE), the I/Os are in output state. Do not apply input signals.
    #     * drop ~WE
    #     * wait...??? no time given
    #     * present data on output pins
    #     * wait for rest of write length, tPWE = 35 ns?
    ticks_tpwe = ticks_per_ns(35,g_sysfreq)
    #     * raise ~WE
    #     * wait tHD = min 0...? not less than 1 tick, say
    ticks_thd = ticks_per_ns(1,g_sysfreq)
    #     * wait the rest of tWC = 45 ns, so
    #         * really tHA - tHD = min 0... so I guess rest of 45ns
    #         * not less than 1 tick
    ticks_tha_thd = ticks_per_ns(max(1,45 - (ticks_tsa_thzoe + ticks_tpwe + ticks_thd)),g_sysfreq)
    #

    # then the # of bits for the state machine's downcounter.
    # HD44780 CASE WAS LIKE THIS:
    # the duration it has to downcount is the E cycle length ticks_tcyce plus the
    # address setup time, ticks_tas.
    # so, add up tas, then the ecycle parts: pweh, tah, and the rest of tcyce, which I call e_pad.
    #count_top = int(ticks_tas) + int(ticks_pweh) + int(ticks_tah) + int(ticks_e_pad)

    # the duration sram state machine has to downcount is the greatest of the first read, subsequent read,
    # or write cycles.
    read2_ticks = ticks_tace_tdoe + ticks_tdoe + ticks_endrd2
    read1_ticks = ticks_taa + ticks_thzoe
    write1_ticks = ticks_tsa_thzoe + ticks_tpwe + ticks_thd + ticks_tha_thd
    count_top = max(read2_ticks, read1_ticks, write1_ticks)
    # I believe we need to fudge count_top up by one in bit container like we did with bit length for timer
    # i.e. the number 4 needs 3 bits to hold though its log2 is 2.
    bits_to_hold_sram_max = math.ceil(math.log2(count_top+1))

    # output! We need everything to be integers.
    # prefix with SR as the shortest form of sram.
    print("//automatically generated .inc file for FPGA_sram")
    print("//Created by sram_config.py {}\n".format(int(g_sysfreq)))
    print("//system frequency {}Hz".format(make_verilog_number_str(int(g_sysfreq))))
    print("//1 system clock tick = {} nanoseconds".format((1.0 / g_sysfreq) / (1.0/1000000000.0)))
    print("`define SR_SYSFREQ         ({})".format(make_verilog_number_str(int(math.ceil(g_sysfreq)))))
    print("\n// downcount clock values to load for one read/write given mode")
    print("`define SR_READ2_TICKS     ({})".format(make_verilog_number_str(int(read2_ticks))))
    print("`define SR_READ1_TICKS     ({})".format(make_verilog_number_str(int(read1_ticks))))
    print("`define SR_WRITE1_TICKS    ({})".format(make_verilog_number_str(int(write1_ticks))))
    print("\n// downcounter values for actions in read2:")
    print("// first cycle have address in place and ~WE disabled (raised), enable (lower) ~OE")
    rd2_tick = read2_ticks
    print("`define SR_READ2_OEON      ({})".format(make_verilog_number_str(int(rd2_tick))))
    print("// wait - tACE - tDOE = max 45 - max 22 = 23 ns")
    print("// then disable (raise) ~OE (WILL CHANGE FOR SUBSEQUENT BYTE VERSION)")
    rd2_tick -= ticks_tace_tdoe
    print("`define SR_READ2_OEOFF     ({})".format(make_verilog_number_str(int(rd2_tick))))
    print("// wait tDOE = max 22ns")
    print("// then latch data, mark ready for mentor to harvest the byte")
    rd2_tick -= ticks_tdoe
    print("`define SR_READ2_LATCH     ({})".format(make_verilog_number_str(int(rd2_tick))))
    print("// wait for rest of tRC which may be 0 more")
    rd2_tick = 0
    print("`define SR_READ2_DONE      ({})".format(make_verilog_number_str(int(rd2_tick))))

    # subsequent byte read (read cycle 1 from datasheet)
    print("\n// downcounter values for actions in read1 (subsequent bytes after a read2 above):")
    print("// assumed that ~OE is still low and ~WE high")
    print("// on first cycle, change address")
    rd1_tick = read1_ticks
    print("`define SR_READ1_NEWADDR   ({})".format(make_verilog_number_str(int(rd1_tick))))
    print("// then wait tAA = max 45ns, latch data, send ack")
    print("// if this is the last byte, disable (raise) ~OE")
    rd1_tick -= ticks_taa
    print("`define SR_READ1_LATCHACK  ({})".format(make_verilog_number_str(int(rd1_tick))))
    print("// then wait tHZOE = max 18ns (note 29, I/Os are in output, do not apply signal)")
    rd1_tick -= ticks_thzoe
    print("`define SR_READ1_DONE      ({})".format(make_verilog_number_str(int(rd1_tick))))

    # write: write cycle 1 from datasheet
    #     * address
    #     * raise ~OE - or is it already?
    print("\n// downcounter values for actions in write1:")
    print("//******************************* PROOFREAD THIS")
    print("// first cycle have address in place, ~OE disabled (high)")
    wr1_tick = write1_ticks
    print("`define SR_WRITE1_NEWADDR  ({})".format(make_verilog_number_str(int(wr1_tick))))
    print("// then wait tHZOE = max 18 ns (note 29, I/Os are in output, do not apply signal)")
    print("// and present data on output pins, enable (drop) ~WE")
    wr1_tick -= ticks_tsa_thzoe
    print("`define SR_WRITE1_WEON     ({})".format(make_verilog_number_str(int(wr1_tick))))
    print("// wait for rest of write length, tPWE = 35 ns?")
    print("// then raise (disable) ~WE")
    wr1_tick -= ticks_tpwe
    print("`define SR_WRITE1_WEOFF    ({})".format(make_verilog_number_str(int(wr1_tick))))
    # not sure what this part is for:
    #     * wait tHD = min 0...? not less than 1 tick, say
    #ticks_thd = ticks_per_ns(1,g_sysfreq)
    # end not sure what this part is for
    print("// wait the rest of tWC = 45 ns, let's just say wait until timer is 0")
    #         * really tHA - tHD = min 0... so I guess rest of 45ns
    #         * not less than 1 tick
    #ticks_tha_thd = ticks_per_ns(max(1,45 - (ticks_tsa_thzoe + ticks_tpwe + ticks_thd)),g_sysfreq)
    wr1_tick = 0
    print("`define SR_WRITE1_DONE     ({})".format(make_verilog_number_str(int(wr1_tick))))

    #print("\n// short delays for sram module, in clock ticks")
    #print("`define SR_TICKS_TACE_TDOE ({})".format(make_verilog_number_str(int(ticks_tace_tdoe))))
    #print("`define SR_TICKS_TDOE      ({})".format(make_verilog_number_str(int(ticks_tdoe))))
    #print("`define SR_TICKS_TAA       ({})".format(make_verilog_number_str(int(ticks_taa))))
    #print("`define SR_TICKS_THZOE     ({})".format(make_verilog_number_str(int(ticks_thzoe))))
    #print("`define SR_TICKS_TSA_THZOE ({})".format(make_verilog_number_str(int(ticks_tsa_thzoe))))
    #print("`define SR_TICKS_TPWE      ({})".format(make_verilog_number_str(int(ticks_tpwe))))
    #print("`define SR_TICKS_THD       ({})".format(make_verilog_number_str(int(ticks_thd))))
    #print("`define SR_TICKS_THA_THD   ({})".format(make_verilog_number_str(int(ticks_tha_thd))))

    print("// count bits must accommodate max of readcycle2 ticks=({}) readcycle1 ticks=({}) and writecycle1 ticks=({}) so {}".
        format(read2_ticks, read1_ticks, write1_ticks, count_top))
    print("`define SRNS_COUNT_BITS    ({})".format(make_verilog_number_str(int(bits_to_hold_sram_max))))
