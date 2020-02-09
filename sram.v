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
//    inout wire[DATA_WIDTH-1:0] io_m_data,           //connects just to mentor
    //wishbone doesn't have bidirectional m/s connections, so we need data in and data out
    input wire[DATA_WIDTH-1:0] i_data,              //data from mentor, for writes (and who knows what else)
    output wire[DATA_WIDTH-1:0] o_data,             //data to mentor, for reads (awkwelse)
    output wire[ADDR_WIDTH-1:0] o_addr,             //connects straight to pins
    inout wire[DATA_WIDTH-1:0] io_c_data,              //straight to pins
    output wire o_n_oe,                             //~OE (active low output enable), to pins, purely controlled by this module
    output wire o_n_we                             //~WE (active low write enable), to pins
    );

    /*
    //MINIMAL DUMMY IMPLEMENTATION TO SEE IF I CAN GET THIS TO COMPILE
    reg [ADDR_WIDTH-1:0] addr_reg = 0;

    always @(posedge i_clk) begin
        //dummy code
        addr_reg <= i_addr;
    end
    assign o_addr = addr_reg;
    */



    /* now designing actual state machine
    * much of this comes from my wiki 00-what the module does page
    * idle, keep the pins hi-z
        - from https://electronics.stackexchange.com/questions/22220/how-to-assign-value-to-bidirectional-port-in-verilog
        If you must use any port as inout, Here are few things to remember:

        1. You can't read and write inout port simultaneously, hence kept highZ for reading.
        2. inout port can NEVER be of type reg.
        3. There should be a condition at which it should be written. (data in mem should be written when
           Write = 1 and should be able to read when Write = 0).
        For e.g. I'll write your code in following way.

        module test (value, var);
          inout value;
          output reg var;
          assign value = (condition) ? <some value / expression> : 'bz;
          always @(<event>)
            var = value;
        endmodule

        BTW When var is of type wire, you can read it in following fashion:

        assign var = (different condition than writing) ? value : [something else];

        Hence as you can see there is no restriction how to read it but inout port MUST
        be written the way shown above.

        ------

        module bidirec (oe, clk, inp, outp, bidir);

            // Port Declaration
            input   oe;
            input   clk;
            input   [7:0] inp;
            output  [7:0] outp;
            inout   [7:0] bidir;

            reg     [7:0] a;
            reg     [7:0] b;

            assign bidir = oe ? a : 8'bZ ;
            assign outp  = b;

            // Always Construct
            always @ (posedge clk)
            begin
                b <= bidir;
                a <= inp;
            end
        endmodule


    * then for read and write ops:
    * could do something like I did with the LCD piece where I used a counter for the state machine, hd44780_nybsen.v - had the python script that could calculate the delays, and I could do a thing like that for the RAM timing and test it with a few values like 48MHz which in theory the up5K could do.
        * and have it err on the side of slow s.t. anything that should get a delay does get a cycle
        * can tighten it all up later, first get it to work!
    * Noodle: we'll figure out all the signals
    * so given that the chip enables are always set, read cycle is like:
        * at idle both ~OE and ~WE high
        * mark cycle start, or whatever; student receives cycle start
        * mark busy
        * set address (would also set CE lines here too)
        * (would be a wait then set BLE/BHE, though those are also glued)
        * wait
        * drop ~OE
        * wait tDOE
        * latch data
        * mark ready for mentor to harvest the byte?
        * wait
    * then can do subsequent bytes, as many as needed
        * mark busy
        * change address
        * wait tAA
        * latch data
        * mark ready for mentor to harvest
    * to wrap up,
        * raise ~OE
        * wait tHZOE
        * mark cycle end

    * write:
        * address
        * wait tSA
        * drop ~WE (and present data on output pins?)
        * wait for rest of write length
        * figure out the rest
    */

    //declarations
    //keep the input address in a nice stable register so we're not sensitive to
    //irrelevant changes to the input addr port during operations. Also, for
    //multibyte contiguous transfers we want to be able to increment it within the module ...?
    //or does the mentor keep sending new addrs? Even then we'll want to sync it. So register.
    //yeah, mentor keeps sending new values. That way it can be contiguous or not, and we
    //send back or receive one byte at a time - ? yes, see state machine
    reg [ADDR_WIDTH-1:0] addr_reg = 0;
    reg [DATA_WIDTH-1:0] data_reg = 0;
    //similarly preserve whether current operation is a write;
    //shouldn't get changed during cycle, I'd think. Verify w/wishbone docs and
    //be ready to enforce with formal verification
    reg write_reg = 0;

    //actual state machine - will try it my usual way with synch and <=

    always @(posedge i_clk) begin
        if(i_reset) begin
            //reset! zero out address, make all the i/o pins hi-z
            //hi-z has to happen in assign block bc wires
            addr_reg <= 0;
            data_reg <= 0;
            write_reg <= 0;
        end
    end

    //assigns, I like to group them after the clockyblock bc why not
    // recall that inouts must use this form:
    //output reg var;
    //assign value = (condition) ? <some value / expression> : 'bz;
    //always @(<event>)
    //  var = value;
    // so, looks like you can always read, but write
    // perhaps a bit clearer is the other example
    /*
    module bidirec (oe, clk, inp, outp, bidir);

        // Port Declaration
        input   oe;
        input   clk;
        input   [7:0] inp;
        output  [7:0] outp;
        inout   [7:0] bidir;

        reg     [7:0] a;
        reg     [7:0] b;

        assign bidir = oe ? a : 8'bZ ;
        assign outp  = b;

        // Always Construct
        always @ (posedge clk)
        begin
            b <= bidir;
            a <= inp;
        end
    endmodule
    */
    //inout wire[DATA_WIDTH-1:0] io_c_data,              //straight to pins
    //so if we're in reset, we want hi-z; if writing, want value, so
    //we want value when (NOT reset) AND writing, yes? otherwise hi-z
    //how to do variable-width hi-z? Per https://stackoverflow.com/questions/18328006/how-can-i-set-a-full-variable-constant
    //you do a = {`SIZE{1'b1}};
    assign io_c_data = (!i_reset & write_reg) ? data_reg : {DATA_WIDTH{1'bz}};

endmodule
