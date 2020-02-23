//automatically generated .inc file for FPGA_sram
//Created by sram_config.py 100000000

//system frequency 100_000_000Hz
//1 system clock tick = 10.0 nanoseconds

//short delays for sram module, in clock ticks
`define SR_SYSFREQ         (100_000_000)
`define SR_TICKS_TACE_TDOE (3)
`define SR_TICKS_TDOE      (3)
`define SR_TICKS_TAA       (5)
`define SR_TICKS_THZOE     (2)
`define SR_TICKS_TSA_THZOE (1)
`define SR_TICKS_TPWE      (4)
`define SR_TICKS_THD       (1)
`define SR_TICKS_THA_THD   (4)
// downcount clock values to load for one read/write given mode
`define SR_READ2_TICKS     (6)
`define SR_READ1_TICKS     (7)
`define SR_WRITE1_TICKS    (10)
// count bits must accommodate max of readcycle2 ticks=(6) readcycle1 ticks=(7) and writecycle1 ticks=(10) so 10
`define SRNS_COUNT_BITS    (4)
