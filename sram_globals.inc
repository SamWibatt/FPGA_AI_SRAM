//Global defines and such for the SRAM module

//Cycle tag definitions: Not sure how to handle this; would put it in sram.v as a parameter but
//can't find a way for a design that includes the module to *query* the module's parameter values,
//only *change* them at instantiation time.
//so for now I will use some defines in here and have the top modules AND the sram module include it.

`define SR_CYC_NONE     (0)             //undefined - throws error, caller must specify
`define SR_CYC_SRD      (1)             //single read
`define SR_CYC_SWRT     (2)             //single write
`define SR_CYC_BRD      (3)             //block read
`define SR_CYC_BWRT     (4)             //block write 
