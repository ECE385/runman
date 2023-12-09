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
    input logic reset_rtl_0, Play_btn, Next_btn, Prev_btn,

    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB,

    output logic SD_DQ3,
    output logic SD_CLK,
    input logic SD_DQ0,
    output logic SD_CMD,

    output logic JA1_P, JA1_N, JA2_P, JA2_N,
    output logic JAB_0, JAB_1, JAB_2, JAB_3, JAB_4, JAB_5,

    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,

    input logic vp_in, vn_in
);

    logic clk_50;
    logic clk_125MHz;
    logic clk_25MHz;
    logic test;
    assign test = 1'b1;
    logic reset_locked;
    logic clock_50m_locked;
    logic clock_128fs_locked;

    assign reset_locked = reset_rtl_0 || ~clock_50m_locked || ~clock_128fs_locked;


    clk_wiz_0 clk_wiz_50m(
        .reset(reset_rtl_0),
        .clk_in1(Clk),
        .clk_out1(clk_50),
        .clk_out2(clk_125MHz),
        .clk_out3(clk_25MHz),
        .locked(clock_50m_locked)
    );

    clk_wiz_1 clk_wiz_128fs (
        .reset(reset_rtl_0),
        .clk_in1(Clk),
        .clk_out1(clk_128fs),
        .locked(clock_128fs_locked)
    );

    logic [9:0] drawX, drawY, song_progress;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;

    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_rtl_0),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );

    logic [55:0] dividor_res;
    logic [31:0] s_axis_divisor;

    assign s_axis_divisor = song_size;//44100 * 60 * 3; // song length in samples Binh Minh add here which will update all instances

    div_gen_0 divider(
        .s_axis_divisor_tdata(s_axis_divisor), // 44100 samples a second * 60 second * 3 minutes
        .s_axis_dividend_tdata(total_bits), // sample #
        .aclk(Clk),
        .s_axis_dividend_tvalid(1'b1),
        .s_axis_divisor_tvalid(1'b1),
        .m_axis_dout_tdata(dividor_res) // multipy by 505 = song_progress
    );

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(clock_50m_locked),
        //Reset is active LOW
        .rst(reset_rtl_0),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),

        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),

        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),
        .TMDS_CLK_N(hdmi_tmds_clk_n),
        .TMDS_DATA_P(hdmi_tmds_data_p),
        .TMDS_DATA_N(hdmi_tmds_data_n)
    );

//    always_comb begin
//        if (vsync == 0) begin
//            if (525 >= song_progress)  begin
//                song_progress = 0;
//            end
//            else begin
//                song_progress = song_progress + 1;
//            end
//        end
//    end

    always_ff @(posedge vsync) begin
//        if (505 <= song_progress)  begin
//            song_progress <= 0;
//        end
//        else begin
//            song_progress <= song_progress + 1;
//        end
        integer i;
        for (i=0; i<10; i=i+1)
            song_progress[i] <= dividor_res[i+16];
    end


    //Color Mapper Module
    color_mapper color_instance(
        .DrawX(drawX),
        .DrawY(drawY),
        .song_progress(song_progress),
        .Red(red),
        .Green(green),
        .Blue(blue)
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

        if (reset_rtl_0) begin
            clk_div <= 0;
            clk_32fs <= 0;
        end
        else if(clk_div) begin
            clk_32fs <= ~clk_32fs;
        end
    end

    assign I2S_bck = ~clk_32fs;

///// Buttons
    logic playing;
    logic play_btn_ms, play_btn_sync, play_btn_prev; // _ms = metastable

    localparam MAX_TRACK_ID = 7;

    logic [2:0] track_num;
    logic next_btn_ms, next_btn_sync, next_btn_prev;
    logic prev_btn_ms, prev_btn_sync, prev_btn_prev;

    logic new_song;

    always_ff @(posedge clk_32fs) begin
        new_song <= 0;

        if(reset_locked) begin
            playing <= 0;
            track_num <= 0;
            new_song <= 1;
        end else begin
            play_btn_ms <= Play_btn;
            play_btn_sync <= play_btn_ms;
            play_btn_prev <= play_btn_sync;

            next_btn_ms <= Next_btn;
            next_btn_sync <= next_btn_ms;
            next_btn_prev <= next_btn_sync;

            prev_btn_ms <= Prev_btn;
            prev_btn_sync <= prev_btn_ms;
            prev_btn_prev <= prev_btn_sync;

            if(sample_number >= song_size) begin
                playing <= 0;
            end

            if(play_btn_prev != play_btn_sync && play_btn_sync == 1) playing <= ~playing;

            if(next_btn_prev != next_btn_sync && next_btn_sync == 1) begin
                track_num <= track_num + 1;
                if (track_num >= MAX_TRACK_ID) track_num <= 0;
                playing <= 1;
                new_song <= 1;
            end

            if(prev_btn_prev != prev_btn_sync && prev_btn_sync == 1) begin
                track_num <= track_num - 1;
                if (track_num == 0) track_num <= MAX_TRACK_ID;
                playing <= 1;
                new_song <= 1;
            end
        end
    end

////// 
logic drdy_out;
logic [15:0] do_out;
logic [4:0] channel_out;
logic eoc_out, busy_out;

xadc_wiz_0 vol_adc (
    .di_in(0),              // input wire [15 : 0] di_in
    .daddr_in(3),        // input wire [6 : 0] daddr_in
    .den_in(eoc_out),            // input wire den_in
    .dwe_in(0),            // input wire dwe_in
    .drdy_out(drdy_out),        // output wire drdy_out
    .do_out(do_out),            // output wire [15 : 0] do_out
    .dclk_in(clk_50),          // input wire dclk_in
    .reset_in(0),        // input wire reset_in
    .vp_in(vp_in),              // input wire vp_in
    .vn_in(vn_in),              // input wire vn_in
    .channel_out(channel_out),  // output wire [4 : 0] channel_out
    .eoc_out(eoc_out),          // output wire eoc_out
    .alarm_out(alarm_out),      // output wire alarm_out
    .eos_out(eos_out),          // output wire eos_out
    .busy_out(busy_out)        // output wire busy_out
);

///// I22 State machine
    logic [31:0] data;
    logic [4:0] bit_counter;
    logic [39:0] total_bits;

    logic [11:0] volume_level;

    logic [31:0] song_size; // In # of samples
    logic song_load_status; // 0 for load new song (need to update size), 1 for size has been read

    logic [31:0] sample_number;

    logic [4:0] data_idx;
    assign data_idx = {~bit_counter[4], 4'd15 - bit_counter[3:0]};

    always_ff @ (posedge clk_32fs) begin
        fifo_rd_en <= 0;

        // data_mult[1] <= (fifo_dout[31:16] * 12'hfff);
        // data_mult[0] <= (fifo_dout[15:0] * volume_level);

        if(new_song) song_load_status <= 0;

        if(reset_locked) begin
            bit_counter <= 0;
            total_bits <= 0;
            volume_level <= 0;

            song_size <= 32'hffff_ffff;
            song_load_status <= 0;

            sample_number <= 0;

            I2S_data <= 0;
            I2S_lrck <= 0;
        end else begin
            bit_counter <= bit_counter + 1;

            I2S_data <= data[data_idx];
            I2S_lrck <= bit_counter[4];

            if(bit_counter[3:0] == 4'd15) I2S_lrck <= ~bit_counter[4];

            // If finished writing word (32 bits), grab next word (2x 16-bit half words, L+R channel)
            if(bit_counter >= 5'h1f) begin
                bit_counter <= 5'd0;


                // Load 0 if fifo out of data
                data <= 0;
                if(~fifo_empty && playing) begin
                    sample_number <= sample_number + 1;

                    // if (s_axis_divisor >= total_bits) begin
                    //     total_bits <= total_bits + 505;
                    // end
                    total_bits <= total_bits + 500;

                    // Tell FIFO move to next sample
                    fifo_rd_en <= 1;

                    // Load in volume scalled sound data
                    volume_level <= do_out[15:4];
                    data[31:16] <= signed'(fifo_dout[31:16]) >>> volume_level[11 -: 4];
                    data[15:0] <= signed'(fifo_dout[15:0]) >>> volume_level[11 -: 4];

                    // If song size not loaded, next word should be the song size
                    if(~song_load_status) begin
                        song_size[31:16] <= fifo_dout[15:0] >> 2;
                        song_size[15:0] <= {fifo_dout[1:0], fifo_dout[31:16]};
                        song_load_status <= 1;

                        total_bits <= 0;
                        sample_number <= 0;
                    end
                end
            end
        end
    end

/////////

    logic [30:0] ram_address;
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

        .start_addr(31'h3_0000 * 31'd256 * track_num),

        .fifo_rd_en, //input logic
        .fifo_rd_clk(clk_32fs), //input logic
        .fifo_dout, //output logic [31 : 0]
        .fifo_empty // output logic
    );

    HexDriver hex_seg_disA(
        .clk(clk_50),
        .reset(reset_locked),
        .in({{1'b0, track_num}, { 2'b0, song_progress[9:8] }, song_progress[7:4], song_progress[3:0]}),
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
        .probe4(sdcard_init_i.ram_addr_r),
        .probe5(sdcard_init_i.sd_busy),
        .probe6(sdcard_init_i.wr_en),
        .probe7({fifo_empty, sdcard_init_i.prog_full, sdcard_init_i.full, clk_32fs, clk_128fs, I2S_lrck}), //
        .probe8(fifo_rd_en),
        .probe9(fifo_dout),
        .probe10(reset_locked),
        .probe11(sdcard_init_i.TEST_counter),
        .probe12({prev_btn_sync, prev_btn_prev, next_btn_sync, next_btn_prev, play_btn_sync, play_btn_prev}),
        .probe13(track_num),
        .probe14(sdcard_init_i.start_addr),
        .probe15(song_progress),
        .probe16(dividor_res[55:16]),
        .probe17(dividor_res[15:0]),
        .probe18(song_size),
        .probe19({song_load_status, new_song})
    );

endmodule
