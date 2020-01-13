// this will be a module to access a 1Mx8 SRAM / flash module such as I own for soldering practice. They will be useful for
// testing data structure acceleration, too, I reckon.

`default_nettype none

//right so let's do this iteratively.
//parameterize the address and data widths bc let's get used to that. 1Mx8 is 20 bits addr, 8 bits data
//then have a flag for read or write, where 1 = write
//one for reset a la wishbone
//later have handshakey stuff. For the moment, start with one byte. Later do multi byte read/write.
//THIS NEEDS TO TALK TO THE CHIP DIRECTLY, YES?
//so address will come from mentor, and this will register it and pass it along - I don't think
//we want the address to go straight from caller to pins. Likewise data... so how do we handle that?
//pin connections have to be in the top module's ports, yes? Well, I guess so. Figure out how to verify.
module sram_1Mx8 #(parameter ADDR_WIDTH=20, parameter DATA_WIDTH=8) (
    input wire i_clk,
    input wire i_reset,
    input wire i_write,
    input wire[ADDR_WIDTH-1:0] i_addr,
    inout wire[DATA_WIDTH-1:0] io_m_data,           //connects just to mentor
    output wire[ADDR_WIDTH-1:0] o_addr,             //connects straight to pins
    inout wire[DATA_WIDTH-1:0] io_data,              //straight to pins
    output wire o_n_oe,                             //~OE (active low output enable), to pins, purely controlled by this module
    output wire o_n_we                             //~WE (active low write enable), to pins
    );

    //MINIMAL DUMMY IMPLEMENTATION TO SEE IF I CAN GET THIS TO COMPILE
    reg [ADDR_WIDTH-1:0] addr_reg = 0;

    always @(posedge i_clk) begin
        //dummy code
        addr_reg <= i_addr;
    end
    assign o_addr = addr_reg;
endmodule
