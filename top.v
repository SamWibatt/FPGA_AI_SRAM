//top.v - "main" or "controller" for sram project
`default_nettype none

//`include "sram.v"

module top(
    output wire led_g,              //alive-blinky, use rgb green ... from controller
    output wire led_b,                  //blue led bc rgb driver needs it
    output wire led_r,                   //red led
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

    // alive-blinky wires:
    //wire led_g_outwire;
    wire led_b_outwire; // = greenblinkct[GREENBLINKBITS-1];
    //wire led_r_outwire;

    //then the sram module proper, currently a blinkois
    //let us have it blink on the blue upduino LED.
    sram_1Mx8 ram(.i_clk(clk),.o_led(led_b_outwire));

    always @(posedge clk) begin
        //this should drive the blinkingness
        led_b_pwm_reg <= led_b_outwire;
    end

endmodule
