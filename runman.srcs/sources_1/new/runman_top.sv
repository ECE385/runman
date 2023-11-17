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
    
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB,
    
    output logic SD_DQ3,
    output logic SD_CLK,
    input logic SD_DQ0,
    output logic SD_CMD,

    output logic JA1_P, JA1_N, JA2_P, JA2_N,
    output logic JAB_0, JAB_1, JAB_2, JAB_3, JAB_4, JAB_5
);

    logic clk_50;
    logic test;
    assign test = 1'b1;
    logic reset_locked;
    logic clock_locked;
    
    assign reset_locked = reset_rtl_0 || ~clock_locked;
    
    clk_wiz_0 clk_wiz(
        .reset(reset_rtl_0),
        .clk_in1(Clk),
        .clk_out1(clk_50),
        .clk_out2(clk_128fs),
        .locked(clock_locked)
    );

    logic I2S_bck, I2S_lrck, I2S_data;

    assign JA1_P = 1'bz;
    assign JA1_N = I2S_bck;
    assign JA2_P = I2S_data;
    assign JA2_N = I2S_lrck;

    assign JAB_0 = reset_rtl_0;
    assign JAB_1 = clk_128fs;
    assign JAB_2 = clk_32fs;
    assign JAB_3 = 1'bz;
    assign JAB_4 = 1'bz;
    assign JAB_5 = 1'bz;

    logic fifo_rd_en; //input logic 
    logic [31 : 0] fifo_dout; //output logic [31 : 0] 
    logic fifo_empty; // output logic 

//// Clock generation, fs = 44.1khz
    logic clk_128fs;
    logic clk_32fs;
    logic clk_div;

    always_ff @ (posedge clk_128fs) begin
        clk_div <= ~clk_div;

        if (reset_locked) begin
            clk_div <= 0;
            clk_32fs <= 0;
        end
        else if(clk_div) begin
            clk_32fs <= ~clk_32fs;
        end
    end

    assign I2S_bck = ~clk_32fs;

///// I22 State machine
    logic [31:0] data;
    logic [4:0] bit_counter;

    logic [4:0] data_idx;
    assign data_idx = {~bit_counter[4], 4'd15 - bit_counter[3:0]};

    always_ff @ (posedge clk_32fs) begin
        fifo_rd_en <= 0;

        if(reset_locked) begin
            bit_counter <= 0;

            I2S_data <= 0;
            I2S_lrck <= 0;
        end else begin
            bit_counter <= bit_counter + 1;

            I2S_data <= data[data_idx];
            I2S_lrck <= bit_counter[4];

            if(bit_counter[3:0] == 4'd15) I2S_lrck <= ~bit_counter[4];

            if(bit_counter >= 5'h1f) begin
                bit_counter <= 5'd0;
                
                data <= 0;
                if(~fifo_empty) begin
                    fifo_rd_en <= 1;
                    data <= fifo_dout;
                end
            end
        end
    end

/////////
    
    logic [24:0] ram_address;
    logic [15:0] ram_data;
    
    sdcard_init sdcard_init_i(
        .clk50(clk_50),
        .reset(reset_locked),          //starts as soon reset is deasserted
        .ram_we(ram_we),         //RAM interface pins
        .ram_address(ram_address),
        .ram_data(ram_data),
    	.ram_op_begun(~test),   //acknowledge from RAM to move to next word
//        .ram_op_begun(~almost_full),   //acknowledge from RAM to move to next word
        .ram_init_error(ram_init_error), //error initializing
        .ram_init_done(ram_init_done),  //done with reading all MAX_RAM_ADDRESS words
        .cs_bo(SD_DQ3), //SD card pins (also make sure to disable USB CS if using DE10-Lite)
        .sclk_o(SD_CLK),
        .mosi_o(SD_CMD),
        .miso_i(SD_DQ0),

        .fifo_rd_en, //input logic 
        .fifo_rd_clk(clk_32fs), //input logic 
        .fifo_dout, //output logic [31 : 0] 
        .fifo_empty // output logic 
    );
    
    HexDriver hex_seg_disA(
        .clk(clk_50),
        .reset(reset_locked),
        .in({ram_address[15:12], ram_address[11:8], ram_address[7:4], ram_address[3:0]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)  
    );
    
    HexDriver hex_seg_disB(
        .clk(clk_50),
        .reset(reset_locked),
        .in({ram_data[15:12], ram_data[11:8], ram_data[7:4], ram_data[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)  
    );
    
    ila_0 ila (
        .clk(Clk),

        .probe0(clk_50),
        .probe1(data),
        .probe2({I2S_data, bit_counter, data_idx}), //
        .probe3(sdcard_init_i.state_r),
        .probe4(sdcard_init_i.state_x),
        .probe5(sdcard_init_i.sd_busy),
        .probe6(sdcard_init_i.wr_en),
        .probe7({fifo_empty, sdcard_init_i.prog_full, sdcard_init_i.full, clk_32fs, clk_128fs, I2S_lrck}), //
        .probe8(fifo_rd_en),
        .probe9(fifo_dout)
    );
    
endmodule
