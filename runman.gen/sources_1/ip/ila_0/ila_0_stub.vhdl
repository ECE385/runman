-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
-- Date        : Fri Dec  8 12:06:59 2023
-- Host        : DESKTOP-99QIRRF running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/Binh-Minh/Documents/School/ece385/runman/runman.gen/sources_1/ip/ila_0/ila_0_stub.vhdl
-- Design      : ila_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7s50csga324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_0 is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 8 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 30 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe7 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe9 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe11 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe14 : in STD_LOGIC_VECTOR ( 30 downto 0 );
    probe15 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe16 : in STD_LOGIC_VECTOR ( 39 downto 0 );
    probe17 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe18 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe19 : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );

end ila_0;

architecture stub of ila_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[0:0],probe1[31:0],probe2[10:0],probe3[8:0],probe4[30:0],probe5[0:0],probe6[0:0],probe7[5:0],probe8[0:0],probe9[31:0],probe10[0:0],probe11[15:0],probe12[5:0],probe13[2:0],probe14[30:0],probe15[9:0],probe16[39:0],probe17[15:0],probe18[31:0],probe19[1:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2022.2";
begin
end;
