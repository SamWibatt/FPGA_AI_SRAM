//top.v - "main" or "controller" for sram project
`default_nettype none


module top #(parameter ADDR_WIDTH=20, parameter DATA_WIDTH=8) (
    output wire led_g,              //alive-blinky, use rgb green ... from controller
    output wire led_b,                  //blue led bc rgb driver needs it
    output wire led_r,                   //red led

    //chip connections - these will be controlled by sram module
    output wire[ADDR_WIDTH-1:0] o_addr,             //connects straight to pins
    inout wire[DATA_WIDTH-1:0] io_data,              //straight to pins
    output wire o_n_oe,                             //~OE (active low output enable), to pins
    output wire o_n_we,                             //~WE (active low write enable), to pins
    );

    wire clk;
    wire reset = 0;

    //let's do a 6MHz clock for now, speed up later if I feel like it; for now it's all about getting stuff to work and not nec. be fast
    //The SB_HFOSC primitive contains the following parameter and their default values:
    //Parameter CLKHF_DIV = 2’b00 : 00 = div1, 01 = div2, 10 = div4, 11 = div8 ; Default = “00”
    //div8 = 6MHz
    SB_HFOSC #(.CLKHF_DIV("0b11")) u_hfosc (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(clk)
	);

    //looks like the pwm parameters like registers - not quite sure how they work, but let's
    //just create some registers and treat them as active-high ... Well, we'll see what we get.
    //these work basically like an "on" bit, just write a 1 to turn LED on. PWM comes from you
    //switching it on and off and stuff.
    reg led_r_pwm_reg = 0;
    reg led_g_pwm_reg = 0;
    reg led_b_pwm_reg = 0;

    SB_RGBA_DRV rgb (
      .RGBLEDEN (1'b1),         // enable LED
      .RGB0PWM  (led_g_pwm_reg),    //these appear to be single-bit parameters. ordering determined by experimentation and may be wrong
      .RGB1PWM  (led_b_pwm_reg),    //driven from registers within counter arrays in every example I've seen
      .RGB2PWM  (led_r_pwm_reg),    //so I will do similar
      .CURREN   (1'b1),         // supply current; 0 shuts off the driver (verify)
      .RGB0     (led_g),    //Actual Hardware connection - output wires. looks like it goes 0=green
      .RGB1     (led_b),        //1 = blue
      .RGB2     (led_r)         //2 = red - but verify
    );
    defparam rgb.CURRENT_MODE = "0b1";          //half current mode
    defparam rgb.RGB0_CURRENT = "0b000001";     //4mA for Full Mode; 2mA for Half Mode
    defparam rgb.RGB1_CURRENT = "0b000001";     //see SiliconBlue ICE Technology doc
    defparam rgb.RGB2_CURRENT = "0b000001";

    // non-fpga-specific ==========================================================================

    // sram ---------------------------------------------------------------------------------------
    reg o_reset = 0;
    reg o_write = 0;
    reg[ADDR_WIDTH-1:0] o_m_addr = 0;
    reg[DATA_WIDTH-1:0] io_m_data = 0;

    sram_1Mx8 #(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH)) rammy (
        .i_clk(clk),
        .i_reset(o_reset),
        .i_write(o_write),
        .i_addr(o_m_addr),
        .io_m_data(io_m_data),           //connects just to mentor
        .o_addr(o_addr),             //connects straight to pins
        .io_data(io_data),              //straight to pins
        .o_n_oe(o_n_oe),
        .o_n_we(o_n_we)
        );


    // blinky -------------------------------------------------------------------------------------
    wire led_outwire;

    //let us have it blink on the blue and red upduino LED, giving us a dim purple blinky.
    blinky #(.CBITS(23)) blinkus(.i_clk(clk),.o_led(led_outwire));

    //dim by having the current set low as possible AND dividing down by 2^LED_PWM_DIVIDER_BITS
    parameter LED_PWM_DIVIDER_BITS = 4;
    reg [LED_PWM_DIVIDER_BITS-1:0] led_dimmer = 0;
    always @(posedge clk) begin
        led_dimmer <= led_dimmer + 1;
        //this should drive the blinkingness, pwm factor is only 1 when led_dimmer is all 1s
        led_r_pwm_reg <= led_outwire & &led_dimmer;
        led_b_pwm_reg <= led_outwire & &led_dimmer;
    end

endmodule
