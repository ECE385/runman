`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 03:43:16 PM
// Design Name: 
// Module Name: runman_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module runman_tb(

    );

    logic Clk, Reset;
    logic Play_btn, Next_btn, Prev_btn;
    runman_top DUT(
        .Clk,
        .reset_rtl_0(Reset), 
        .Play_btn, .Next_btn, .Prev_btn
    );

    logic clk_50;
    assign clk_50 = DUT.clk_50;
    logic reset_locked;
    assign reset_locked = DUT.reset_locked;

    logic drdy_out;
    logic [15:0] do_out;
    logic [4:0] channel_out;
    logic eoc_out, busy_out;

    assign drdy_out = DUT.drdy_out;
    assign do_out = DUT.do_out;
    assign channel_out = DUT.channel_out;
    assign eoc_out = DUT.eoc_out;
    assign busy_out = DUT.busy_out;

    always begin
        #5 Clk <= ~Clk;
    end

    initial begin
        Clk <= 0;
        Reset <= 0;
        Play_btn = 0;
        Next_btn = 0;
        Prev_btn = 0;
        #10
        Reset <= 1;
        #20
        Reset <= 0;
        #30_000
        force DUT.vol_adc.den_in = 1;
        #1000
        release DUT.vol_adc.den_in;
    end
endmodule
