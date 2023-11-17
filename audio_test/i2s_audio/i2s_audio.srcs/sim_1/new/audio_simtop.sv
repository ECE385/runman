`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 04:11:22 PM
// Design Name: 
// Module Name: audio_simtop
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


module audio_simtop();
    logic Clk;
    logic Reset;

    logic I2S_bck, I2S_lrck, I2S_data;
    logic clk32, clk128;

    logic JA1_P, JAB_0, JAB_3, JAB_4, JAB_5, JAB_6, JAB_7;

    i2S_audio_toplevel DUT(
        .Clk(Clk), .Reset(Reset),
        .JA1_P(JA1_P), .JA1_N(I2S_bck), .JA2_P(I2S_data), .JA2_N(I2S_lrck),
        .JAB_0(JAB_0), .JAB_1(clk128), .JAB_2(clk32), .JAB_3(JAB_3), .JAB_4(JAB_4), .JAB_5(JAB_5), .JAB_6(JAB_6), .JAB_7(JAB_7)
    );

    initial begin
        Clk = 0;
        Reset = 0;
    end

    always begin
        #5 Clk <= ~Clk;
    end
endmodule
