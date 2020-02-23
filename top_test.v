//seeing if this is how to do a testbench for a module

`default_nettype none



//`include "sram.v"

// FOR STARTERS JUST USING CLIFFORD WOLF'S BLINKY
module top_test #(parameter ADDR_WIDTH=20, parameter DATA_WIDTH=8,
    parameter DTAG_WIDTH=2, parameter ATAG_WIDTH=2, parameter CTAG_WIDTH=2)
    ();     //no ports on a test bench the way I cook 'em up
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

    //ram module easy stuff: syscon, addr, data out (mentor -> student), data in (student->mentor)
    reg o_reset = 0;
    reg o_write = 0;
    reg[ADDR_WIDTH-1:0] o_m_addr = 0;
    reg[DATA_WIDTH-1:0] o_m_data = 0;       //data going out to module from here
    wire[DATA_WIDTH-1:0] i_m_data;       //data coming in from module to here

    //then wishboney stuff
    //commented wishbone names are from sram's POV so O is output from it to this module, m.m. for I input from this
    reg o_strobe = 0;               //.STB_I,   //strobe
    wire i_ack;                     //.ACK_O,   //acknowledge

    //THEN wishboney stuff I will support in a bit
    reg o_cyc = 0;                  //.CYC_I,   //cycle flag
    wire i_err;                     //.ERR_O,   //error
    wire i_retry;                   //.RTY_O,   //retry

    //Wishbone signals of lower priority that still need placeholders.
    //Jamming them all at 0 should be harmless, yes?
    reg o_sel = 0;                  //.SEL_I,   //select... for 8 bit data, shouldn't need it, but get used to it.
    reg[ATAG_WIDTH-1:0] o_atag = 0; //.TGA_I,   //address tag, get used to
    reg[DTAG_WIDTH-1:0] o_dtag = 0; //.TGD_I,   //data tag for incoming data, get used to
    reg[CTAG_WIDTH-1:0] o_ctag = 0; //.TGC_I,   //cycle tag, get used to
    reg o_lock = 0;                 //.LOCK_I,  //lock flag, ignore signals from any other mentor. Worry re yet?

    //and wishbone signal I won't use unless I redo this as pipelined
    //.STALL_I,                  //stall is only for pipelined

    //chip pins driven by the sram module. In testbench they're faked here, in real implementation
    //they go in the pcf
    wire[ADDR_WIDTH-1:0] o_addr;
    wire[DATA_WIDTH-1:0] io_data;
    wire o_n_oe;
    wire o_n_we;

    //Here is our actual sram instance!
    sram_1Mx8 #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH),
        .DTAG_WIDTH(DTAG_WIDTH), .ATAG_WIDTH(ATAG_WIDTH), .CTAG_WIDTH(CTAG_WIDTH)
        ) rammy (
        //syscon stuff
        .CLK_I(clk),       //was i_clk,
        .RST_I(o_reset),       //was i_reset,
        //inputs from MENTOR
        .WE_I(o_write),        //was i_write,
        .ADR_I(o_m_addr),       //was i_addr,
        .TGA_I(o_atag),       //address tag, get used to
        .DAT_I(o_m_data),       //was i_data, //data from mentor, for writes
        .TGD_I(o_dtag),       //data tag for incoming data, get used to
        .LOCK_I(o_lock),                      //lock flag, ignore signals from any other mentor. Worry re yet?
        .SEL_I(o_sel),                       //select... for 8 bit data, shouldn't need it, but get used to it.
        .CYC_I(o_cyc),                       //cycle flag
        .TGC_I(o_ctag),       //cycle tag, get used to
        .STB_I(o_strobe),                       //strobe
        //output to MENTOR
        .DAT_O(i_m_data),      //was o_data, //data to mentor, for reads
        .ACK_O(i_ack),                      //acknowledge
        //.STALL_I,                  //stall is only for pipelined
        .ERR_O(i_err),                      //error
        .RTY_O(i_retry),                      //retry
        //non-Wishbone stuff such as pins out to actual RAM chip
        .o_addr(o_addr),     //connects straight to pins
        .io_c_data(io_data),   //straight to pins
        .o_n_oe(o_n_oe),                     //~OE (active low output enable), to pins, purely controlled by this module
        .o_n_we(o_n_we)                      //~WE (active low write enable), to pins
        );

        /* auld
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
        */


    //bit for creating gtkwave output
    /* dunno if we need this with the makefile version - Maybe, it's hanging - aha, bc I hadn't made clean and had a non-finishing version */
    initial begin
        //uncomment the next two for gtkwave?
        $dumpfile("top_test.vcd");
        $dumpvars(0, top_test);
    end

    initial begin
        $display("and away we go!!!1");
        //OK SO AT THE START DO THE FAKE SYSCON THING AND PULSE RESET FOR A FEW CYCLES.
        o_reset = 1;                // raise reset, hold for a while to verify that it behaves
        // remember that a "clock tick" is really 10 ticks in here so do changes on #10 boundaries
        // or elsewhere if you want to see what "async" signals do
        #40 o_reset = 0;
        #30 o_m_data = 8'hC9;   //random data value!
        o_m_addr = 1777;        //random address!
        o_write = 1;            //do a write!
        o_strobe = 1;           //raise strobe!
        #10 o_strobe = 0;       //and then lower it.
        #1000 $finish;
    end

endmodule
