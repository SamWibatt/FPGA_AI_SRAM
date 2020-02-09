//seeing if this is how to do a testbench for a module

`default_nettype none



//`include "sram.v"

// FOR STARTERS JUST USING CLIFFORD WOLF'S BLINKY
module top_test #(parameter ADDR_WIDTH=20, parameter DATA_WIDTH=8) ();
    //and then the clock, simulation style
    reg clk = 1;
    //make easier-to-count gtkwave values by having a system tick be 10 clk ticks
    always #5 clk = (clk === 1'b0);

    wire led_b_outwire;
    reg led_reg = 0;

    //then the sram module proper, currently a blinkois
    //let us have it blink on the blue upduino LED.
    // test using smaller counter so we don't have to run a jillion cycles in gtkwave
    // ....well, this module should always be compiled with TEST defined but... wev
    `ifdef TEST
    parameter cbits = 4;
    `else
    parameter cbits = 25;
    `endif
    blinky #(.CBITS(cbits)) blinkus(.i_clk(clk),.o_led(led_b_outwire));

    always @(posedge clk) begin
        //this should drive the blinkingness
        led_reg <= led_b_outwire;
    end

    //ram module
    reg o_reset = 0;
    reg o_write = 0;
    reg[ADDR_WIDTH-1:0] o_m_addr = 0;
    reg[DATA_WIDTH-1:0] o_m_data = 0;       //data going out to module from here
    wire[DATA_WIDTH-1:0] i_m_data;       //data coming in from module to here

    //fake pins
    wire[ADDR_WIDTH-1:0] o_addr;
    wire[DATA_WIDTH-1:0] io_data;
    wire o_n_oe;
    wire o_n_we;

    sram_1Mx8 #(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH)) rammy (
        .i_clk(clk),
        .i_reset(o_reset),
        .i_write(o_write),
        .i_addr(o_m_addr),
        .i_data(o_m_data),           //bc data out from here is input from module's pov
        .o_data(i_m_data),           //mutatis mutandis
        .o_addr(o_addr),             //connects straight to pins
        .io_c_data(io_data),         //straight to pins; c is for chip
        .o_n_oe(o_n_oe),
        .o_n_we(o_n_we)
        );

    //bit for creating gtkwave output
    /* dunno if we need this with the makefile version - Maybe, it's hanging - aha, bc I hadn't made clean and had a non-finishing version */
    initial begin
        //uncomment the next two for gtkwave?
        $dumpfile("top_test.vcd");
        $dumpvars(0, top_test);
    end

    initial begin
        $display("and away we go!!!1");
        #1000 $finish;           //longer sim, mask clock is now 16 bits. 5 sec run on vm, 30M vcd.
    end

endmodule
