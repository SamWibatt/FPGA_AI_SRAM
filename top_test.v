//seeing if this is how to do a testbench for a module

`default_nettype none



//`include "sram.v"

// FOR STARTERS JUST USING CLIFFORD WOLF'S BLINKY
module top_test();
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
    parameter cbits = 26;
    `endif
    sram_1Mx8 #(.CBITS(cbits)) ram(.i_clk(clk),.o_led(led_b_outwire));

    always @(posedge clk) begin
        //this should drive the blinkingness
        led_reg <= led_b_outwire;
    end

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
