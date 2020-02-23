//automatically generated .inc file for FPGA_sram
//Created by sram_config.py 6000000

//system frequency 6_000_000Hz
//1 system clock tick = 166.66666666666666 nanoseconds

//short delays for sram module, in clock ticks
`define SR_SYSFREQ         (6_000_000)
`define SR_TICKS_TACE_TDOE (1)
`define SR_TICKS_TDOE      (1)
`define SR_TICKS_TAA       (1)
`define SR_TICKS_THZOE     (1)
`define SR_TICKS_TSA_THZOE (1)
`define SR_TICKS_TPWE      (1)
`define SR_TICKS_THD       (1)
`define SR_TICKS_THA_THD   (1)
// downcount clock values to load for one read/write given mode
`define SR_READ2_TICKS     (2)
`define SR_READ1_TICKS     (2)
`define SR_WRITE1_TICKS    (4)
// count bits must accommodate max of readcycle2 ticks=(2) readcycle1 ticks=(2) and writecycle1 ticks=(4) so 4
`define SRNS_COUNT_BITS    (3)
