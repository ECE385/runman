// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Dec  8 11:15:56 2023
// Host        : DESKTOP-99QIRRF running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Binh-Minh/Documents/School/ece385/runman/runman.gen/sources_1/ip/div_gen_0/div_gen_0_stub.v
// Design      : div_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "div_gen_v5_1_19,Vivado 2022.2" *)
module div_gen_0(aclk, s_axis_divisor_tvalid, 
  s_axis_divisor_tdata, s_axis_dividend_tvalid, s_axis_dividend_tdata, 
  m_axis_dout_tvalid, m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_divisor_tvalid,s_axis_divisor_tdata[31:0],s_axis_dividend_tvalid,s_axis_dividend_tdata[39:0],m_axis_dout_tvalid,m_axis_dout_tdata[55:0]" */;
  input aclk;
  input s_axis_divisor_tvalid;
  input [31:0]s_axis_divisor_tdata;
  input s_axis_dividend_tvalid;
  input [39:0]s_axis_dividend_tdata;
  output m_axis_dout_tvalid;
  output [55:0]m_axis_dout_tdata;
endmodule
