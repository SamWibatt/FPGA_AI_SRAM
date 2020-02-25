//automatically generated .inc file for FPGA_sram
//Created by sram_config.py 6000000

//system frequency 6_000_000Hz
//1 system clock tick = 166.66666666666666 nanoseconds
`define SR_SYSFREQ         (6_000_000)

// downcount clock values to load for one read/write given mode
`define SR_READ2_TICKS     (3)
`define SR_READ1_TICKS     (2)
`define SR_WRITE1_TICKS    (4)

// downcounter values for actions in read2:
// first cycle have address in place and ~WE disabled (raised), enable (lower) ~OE
// wait - tACE - tDOE = max 45 - max 22 = 23 ns
// then enable (lower) ~OE (WILL CHANGE FOR SUBSEQUENT BYTE VERSION)
`define SR_READ2_OEON      (2)
// wait tDOE = max 22ns
// then latch data, mark ready for mentor to harvest the byte
`define SR_READ2_LATCH     (1)
// wait for rest of tRC which may be 0 more
// and if there are no subsequent bytes, disable (raise) ~OE
`define SR_READ2_DONE      (0)

// downcounter values for actions in read1 (subsequent bytes after a read2 above):
// assumed that ~OE is still low and ~WE high
// on first cycle, change address
`define SR_READ1_NEWADDR   (2)
// then wait tAA = max 45ns, latch data, send ack
// if this is the last byte, disable (raise) ~OE
`define SR_READ1_LATCHACK  (1)
// then wait tHZOE = max 18ns (note 29, I/Os are in output, do not apply signal)
`define SR_READ1_DONE      (0)

// downcounter values for actions in write1:
//******************************* PROOFREAD THIS
// first cycle have address in place, ~OE disabled (high)
`define SR_WRITE1_NEWADDR  (4)
// then wait tHZOE = max 18 ns (note 29, I/Os are in output, do not apply signal)
// and present data on output pins, enable (drop) ~WE
`define SR_WRITE1_WEON     (3)
// wait for rest of write length, tPWE = 35 ns?
// then raise (disable) ~WE
`define SR_WRITE1_WEOFF    (2)
// wait the rest of tWC = 45 ns, let's just say wait until timer is 0
`define SR_WRITE1_DONE     (0)
// count bits must accommodate max of readcycle2 ticks=(3) readcycle1 ticks=(2) and writecycle1 ticks=(4) so 4
`define SRNS_COUNT_BITS    (3)
