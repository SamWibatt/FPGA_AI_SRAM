// this will be a module to access a 1Mx8 SRAM / flash module such as I own for soldering practice. They will be useful for
// testing data structure acceleration, too, I reckon.

`default_nettype none

// FOR STARTERS JUST USING CLIFFORD WOLF'S BLINKY
module sram_1Mx8(i_clk, o_led);
    parameter CBITS = 26;
    input wire i_clk;

    //here will go all the address and data lines and stuff

    output wire o_led;

    reg	[CBITS-1:0]	counter = 0;
    always @(posedge i_clk)
    counter <= counter + 1'b1;
    assign o_led = counter[CBITS-1];
endmodule
