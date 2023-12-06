//Zuofu Cheng (2020) for ECE 385, wrapper for VHDL XESS SDCard driver
//
//State machine to load (RAW) SD Card blocks into memory
//memory is assumed to by 32Mx16 (for now)
//loads up to MAX_RAM_ADDRESS parameter from SD card
//
//Note that your SD Card must be written with RAW binary data (e.g. no filesystem)
//On *nix you can use the dd (direct disk) command to write a binary file directly
//to the SD block device; on Windows, you can try using: http://www.chrysocome.net/dd
//Note that dd is a *dangerous program*, you can easily overwrite your boot 
//disk and brick your computer. Triple check your output device is the SD Card (and not your boot drive!)
//
//By default tested using old 1GB SD micro SD cards, should work with SDHC, but you will
//need to change both the parameter in this module, and the default generic in the VHDL 
//code (SDCard.VHD)


module sdcard_init (
	input  logic clk50,
	input  logic reset,          //starts as soon reset is deasserted
	output logic ram_we,         //RAM interface pins
	output logic [30:0] ram_address,
	output logic [15:0] ram_data,
	input  logic ram_op_begun,   //acknowledge from RAM to move to next word
	output logic ram_init_error, //error initializing
	output logic ram_init_done,  //done with reading all MAX_RAM_ADDRESS words
	output logic cs_bo, //SD card pins (also make sure to disable USB CS if using DE10-Lite)
	output logic sclk_o,
	output logic mosi_o,
	input  logic miso_i,

	input logic [30:0] start_addr,

	input logic fifo_rd_en,
	input logic fifo_rd_clk,
	output logic [31 : 0] fifo_dout,
	output logic fifo_empty
);

parameter 			MAX_RAM_ADDRESS = 31'h1E84_8000;
parameter			SDHC 				 = 1'b1;

logic 				sd_read_block;
logic				sd_busy;
logic				sd_data_rdy;
logic				sd_data_next;
logic				sd_continue;
logic	[15:0]		sd_error;
logic [7:0] 		sd_output_data;
logic [31:0] 		sd_block_addr;

//registers written in 2-always method
enum logic [8:0]	{RESET, READBLOCK, READL_0, READL_1, READH_0, READH_1, WRITE, ERROR, DONE, FLUSHBLK_0, FLUSHBLK_1} state_r, state_x;
logic [30:0]		ram_addr_r, ram_addr_x;  //word address for memory initialization
logic [15:0]		data_r, data_x;

//assign primary outputs to correct registers
assign ram_address = ram_addr_r;
assign ram_data = data_r; 

SdCardCtrl m_sdcard ( .clk_i(clk50),
							 .reset_i(reset),
							 .rd_i(sd_read_block),
							 .wr_i(1'b0), //never write
							 .continue_i(sd_continue), //FSM keeps track of address
							 .addr_i(sd_block_addr),
							 .data_i(), //never write
							 .data_o(sd_output_data),
							 .busy_o(sd_busy),
							 .hndShk_o(sd_data_rdy),
							 .hndShk_i(sd_data_next),		
							 .error_o(sd_error),
							 .cs_bo(cs_bo),
							 .sclk_o(sclk_o),
							 .mosi_o(mosi_o),
							 .miso_i(miso_i));

logic wr_en;
logic full, empty, prog_full;
logic wr_rst_busy, rd_rst_busy;

fifo_generator_0 audio_buf (
	.rst(reset || reset_counter),                  // input wire rst
	.wr_clk(clk50),            // input wire wr_clk
	.rd_clk(fifo_rd_clk),            // input wire rd_clk
	.din(data_r),                  // input wire [15 : 0] din
	.wr_en(wr_en & !reset),              // input wire wr_en
	.rd_en(fifo_rd_en & !reset),              // input wire rd_en
	.dout(fifo_dout),                // output wire [15 : 0] dout
	.full(full),                // output wire full
	.empty(empty),              // output wire empty
	.prog_full(prog_full),      // output wire prog_full
	.prog_empty(fifo_empty),      // output wire prog_empty
	.wr_rst_busy(wr_rst_busy),  // output wire wr_rst_busy
	.rd_rst_busy(rd_rst_busy)  // output wire rd_rst_busy
);

logic [15:0] TEST_counter;

logic [9:0] reset_counter;
logic [30:0] start_addr_ms, start_addr_sync, start_addr_prev;

always_ff @ (posedge clk50) 
begin
	if(reset_counter != 0) reset_counter <= reset_counter - 1;
	start_addr_ms <= start_addr;
	start_addr_sync <= start_addr_ms;
	start_addr_prev <= start_addr_sync;

	if (reset) begin
		state_r <= RESET;
		ram_addr_r <= start_addr_sync;
		data_r <= 16'h0001;
		reset_counter <= 10'd1000;
	end
	else if (start_addr_sync != start_addr_prev) begin
		state_r <= READBLOCK;

		if(state_r == READH_0 || state_r == READL_0) state_r <= FLUSHBLK_0;
		if(state_r == READH_1 || state_r == READL_1) state_r <= FLUSHBLK_1;

		ram_addr_r <= start_addr_sync;
		data_r <= 16'h0001;
		reset_counter <= 10'd1000;
	end
	else if (reset_counter == 0) begin
		if(state_x == RESET) begin
			TEST_counter <= 0;
		end else if((state_x == READH_1 || state_x == READL_1) && state_r != state_x) begin
			TEST_counter <= TEST_counter + 1;
		end

		state_r <= state_x;
		data_r <= data_x;
		ram_addr_r <= ram_addr_x;
	end
end

always_comb begin
	wr_en = 0;

	if(state_r == READL_1 && sd_data_rdy == 1'b0) wr_en = 1;
end

always_comb 
begin
	//default combinational assignments
	sd_read_block = 1'b0;
	sd_continue = 1'b0;
	sd_data_next = 1'b0;
	ram_we = 1'b0;
	if (SDHC)//if SDHC mode, then this is block address (note that you need to change VHDL generic)
		sd_block_addr = ram_addr_r >> 8;
	else
		sd_block_addr = ram_addr_r << 1; //in SD mode, this is the *byte* address, change for SDHC 
	state_x = state_r;
	data_x = data_r;
	ram_addr_x = ram_addr_r;
	ram_init_error = 1'b0;
	ram_init_done = 1'b0;

	unique case (state_r)
		RESET: begin //reset state, wait for SD initialization - if failed for any reason, go into ERROR state
			if ((sd_busy == 1'b0) && (sd_error == 16'h0000))
				state_x = READBLOCK;//properly initialized
			else if ((sd_busy == 1'b0) && (sd_error != 16'h0000))
				state_x = ERROR;
		end
		READBLOCK: begin //send enable to start block read
			if (ram_addr_r >= MAX_RAM_ADDRESS) //done with the whole range
				state_x = DONE;
			else if(~prog_full) begin
				sd_read_block = 1'b1; //start block read
				if (sd_block_addr != 32'h00000000)
					sd_continue = 0;//1'b1;
				if (sd_busy == 1'b1)
					state_x = READH_0;
			end
		end
		READH_0: begin //read first byte (higher byte)
			if (sd_busy == 1'b0) //busy going low signals end of block, read next block
				state_x = READBLOCK;
			else if (sd_data_rdy == 1'b1) begin//still have more data in this block, read more bytes
				data_x[7:0] = sd_output_data;
				state_x = READH_1;
			end
		end
		READH_1: begin //ack first byte
			sd_data_next = 1'b1;
			if (sd_data_rdy == 1'b0)//moved on to next byte
				state_x = READL_0;
		end
		READL_0: begin //read second byte (lower byte)
			if (sd_data_rdy == 1'b1) begin
				data_x[15:8] = sd_output_data;
				state_x = READL_1;
			end
		end
		READL_1: begin //ack second byte
			sd_data_next = 1'b1;
			if (sd_data_rdy == 1'b0) begin //move on to next byte/write word
				// state_x = WRITE;
				ram_addr_x = ram_addr_r + 1;
				state_x = READH_0; // Skip write
			end
		end
		WRITE: begin //write 16-bit word, WE=1 and increment ram address for next word
			ram_we = 1'b1;
			if (ram_op_begun == 1'b1) begin//RAM as responded
				ram_addr_x = ram_addr_r + 1;
				state_x = READH_0;
			end
		end
		ERROR: begin
			ram_init_error = 1'b1;
		end
		DONE: begin
			ram_init_done = 1'b1;
		end
		FLUSHBLK_0: begin //read first byte (higher byte)
			if (sd_busy == 1'b0) //busy going low signals end of block, read next block
				state_x = READBLOCK;
			else if (sd_data_rdy == 1'b1) begin//still have more data in this block, read more bytes
				state_x = FLUSHBLK_1;
			end
		end
		FLUSHBLK_1: begin //ack first byte
			sd_data_next = 1'b1;
			if (sd_data_rdy == 1'b0)//moved on to next byte
				state_x = FLUSHBLK_0;
		end
	endcase 
end //end comb
	
endmodule
