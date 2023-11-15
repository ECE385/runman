`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2023 01:33:53 PM
// Design Name: 
// Module Name: runman_top
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


module runman_top(
    input logic Clk,
    input logic reset_rtl_0,
    
//    output logic [7:0] hex_segA,
//    output logic [3:0] hex_gridA,
//    output logic [7:0] hex_segB,
//    output logic [3:0] hex_gridB,
    
    output logic SD_DQ3,
    output logic SD_CLK,
    output logic SD_DQ0,
    output logic SD_CMD
);

    logic clk_50;
    logic locked;
    logic test;
    assign test = 1'b1;
    
    clk_wiz_0 clk_wiz(
        .reset(reset_rtl_0),
        .clk_in1(Clk),
        .clk_out1(clk_50)
    );
    
    logic [24:0] ram_address;
    logic [15:0] ram_data;
    
    sdcard_init sdcard_init_i(
        .clk50(clk_50),
        .reset(reset_rtl_0),          //starts as soon reset is deasserted
        .ram_we(ram_we),         //RAM interface pins
        .ram_address(ram_address),
        .ram_data(ram_data),
    	.ram_op_begun(test),   //acknowledge from RAM to move to next word
//        .ram_op_begun(~almost_full),   //acknowledge from RAM to move to next word
        .ram_init_error(ram_init_error), //error initializing
        .ram_init_done(ram_init_done),  //done with reading all MAX_RAM_ADDRESS words
        .cs_bo(SD_DQ3), //SD card pins (also make sure to disable USB CS if using DE10-Lite)
        .sclk_o(SD_CLK),
        .mosi_o(SD_CMD),
        .miso_i(SD_DQ0)
    );
    
//    HexDriver hex_seg_disA(
//        .clk(Clk),
//        .reset(reset_rtl_0),
//        .in({ram_address[15:12], ram_address[11:8], ram_address[7:4], ram_address[3:0]}),
//        .hex_seg(hex_segA),
//        .hex_grid(hex_gridA)  
//    );
//    HexDriver hex_seg_disB(
//        .clk(Clk),
//        .reset(reset_rtl_0),
//        .in({{ram_init_error, ram_init_done, ram_we, test}, 4'b0011, 4'b0111, 4'b1111}),
//        .hex_seg(hex_segB),
//        .hex_grid(hex_gridB)  
//    );
    
endmodule
