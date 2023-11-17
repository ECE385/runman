`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 12:50:48 PM
// Design Name: 
// Module Name: i2s_audio_toplevel
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


module i2s_audio_toplevel(
    input logic Clk, Reset,
    output logic JA1_P, JA1_N, JA2_P, JA2_N,
    output logic JAB_0, JAB_1, JAB_2, JAB_3, JAB_4, JAB_5
    );

    logic I2S_bck, I2S_lrck, I2S_data;

    assign JA1_P = 1'bz;
    assign JA1_N = I2S_bck;
    assign JA2_P = I2S_data;
    assign JA2_N = I2S_lrck;

    assign JAB_0 = Reset;
    assign JAB_1 = clk_128fs;
    assign JAB_2 = clk_32fs;
    assign JAB_3 = 1'bz;
    assign JAB_4 = 1'bz;
    assign JAB_5 = 1'bz;

//// Clock generation, fs = 44.1khz
    logic clk_128fs, mmcm_locked;
    logic clk_32fs;
    logic clk_div;

    clk_wiz_0 clk_wiz
    (
    // Clock out ports
    .clk_out1(clk_128fs),     // output clk_out1
    // Status and control signals
    .reset(Reset), // input reset
    .locked(mmcm_locked),       // output locked
    // Clock in ports
    .clk_in1(Clk)      // input clk_in1
    );

    always_ff @ (posedge clk_128fs) begin
        clk_div <= ~clk_div;

        if (Reset | ~mmcm_locked) begin
            clk_div <= 0;
            clk_32fs <= 0;
        end
        else if(clk_div) begin
            clk_32fs <= ~clk_32fs;
        end
    end

    assign I2S_bck = clk_32fs;

///// I22 State machine
    logic [15:0] data [101];
    initial $readmemh("sin.mem", data);

    logic [4:0] bit_counter;
    logic [7:0] pos_counter;

    always_ff @ (negedge clk_32fs) begin
        if(Reset) begin
            bit_counter <= 0;
            pos_counter <= 0;

            I2S_data <= data[0][0];
            I2S_lrck <= 0;
        end else begin
            bit_counter <= bit_counter + 1;

            I2S_data <= data[pos_counter][15 - bit_counter[3:0]];
            I2S_lrck <= bit_counter[4];

            if(bit_counter[3:0] == 4'd15) I2S_lrck <= ~bit_counter[4];

            if(bit_counter >= 5'h1f) begin
                bit_counter <= 5'd0;
                pos_counter <= pos_counter + 1;

                if(pos_counter >= 8'd100) pos_counter <= 8'd0;
            end
        end
    end

////// Integrated Logic Analyzer
    // ila_0 ila (
    //     .clk(Clk), // input wire clk

    //     .probe0({JA1_P, I2S_bck, I2S_data, I2S_lrck, bit_counter, pos_counter, 9'd0/*data[pos_counter][8:0]*/}), // input wire [25:0]  probe0  
    //     .probe1({Reset, Clk, clk_128fs, clk_32fs}) // input wire [3:0]  probe1
    // );
    
endmodule
