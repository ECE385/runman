// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Wed Dec  6 00:11:10 2023
// Host        : DESKTOP-99QIRRF running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Binh-Minh/Documents/School/ece385/runman/runman.gen/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2022.2" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[31:0],probe2[10:0],probe3[8:0],probe4[30:0],probe5[0:0],probe6[0:0],probe7[5:0],probe8[0:0],probe9[31:0],probe10[0:0],probe11[15:0],probe12[5:0],probe13[2:0],probe14[30:0]" */;
  input clk;
  input [0:0]probe0;
  input [31:0]probe1;
  input [10:0]probe2;
  input [8:0]probe3;
  input [30:0]probe4;
  input [0:0]probe5;
  input [0:0]probe6;
  input [5:0]probe7;
  input [0:0]probe8;
  input [31:0]probe9;
  input [0:0]probe10;
  input [15:0]probe11;
  input [5:0]probe12;
  input [2:0]probe13;
  input [30:0]probe14;
endmodule
