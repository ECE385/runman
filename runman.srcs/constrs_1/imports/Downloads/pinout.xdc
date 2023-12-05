create_clock -period 10.000 -name clk_100 -waveform {0.000 5.000} [get_ports Clk]

set_property IOSTANDARD LVCMOS33 [get_ports Clk]
set_property IOSTANDARD LVCMOS25 [get_ports reset_rtl_0]
set_property PACKAGE_PIN N15 [get_ports Clk]
set_property PACKAGE_PIN J2 [get_ports reset_rtl_0]
# set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_rxd]
# set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_txd]
# set_property PACKAGE_PIN B16 [get_ports uart_rtl_0_rxd]
# set_property PACKAGE_PIN A16 [get_ports uart_rtl_0_txd]


set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[0]}]
set_property PACKAGE_PIN G6 [get_ports {hex_gridA[0]}]
set_property PACKAGE_PIN H6 [get_ports {hex_gridA[1]}]
set_property PACKAGE_PIN C3 [get_ports {hex_gridA[2]}]
set_property PACKAGE_PIN B3 [get_ports {hex_gridA[3]}]
set_property PACKAGE_PIN E6 [get_ports {hex_segA[0]}]
set_property PACKAGE_PIN B4 [get_ports {hex_segA[1]}]
set_property PACKAGE_PIN D5 [get_ports {hex_segA[2]}]
set_property PACKAGE_PIN C5 [get_ports {hex_segA[3]}]
set_property PACKAGE_PIN D7 [get_ports {hex_segA[4]}]
set_property PACKAGE_PIN D6 [get_ports {hex_segA[5]}]
set_property PACKAGE_PIN C4 [get_ports {hex_segA[6]}]
set_property PACKAGE_PIN B5 [get_ports {hex_segA[7]}]
set_property PACKAGE_PIN F3 [get_ports {hex_segB[0]}]
set_property PACKAGE_PIN G5 [get_ports {hex_segB[1]}]
set_property PACKAGE_PIN J3 [get_ports {hex_segB[2]}]
set_property PACKAGE_PIN H4 [get_ports {hex_segB[3]}]
set_property PACKAGE_PIN F4 [get_ports {hex_segB[4]}]
set_property PACKAGE_PIN H3 [get_ports {hex_segB[5]}]
set_property PACKAGE_PIN E5 [get_ports {hex_segB[6]}]
set_property PACKAGE_PIN J4 [get_ports {hex_segB[7]}]
set_property PACKAGE_PIN E4 [get_ports {hex_gridB[0]}]
set_property PACKAGE_PIN E3 [get_ports {hex_gridB[1]}]
set_property PACKAGE_PIN F5 [get_ports {hex_gridB[2]}]
set_property PACKAGE_PIN H5 [get_ports {hex_gridB[3]}]



#HDMI Signals
 set_property -dict { PACKAGE_PIN V17   IOSTANDARD TMDS_33 } [get_ports {hdmi_tmds_clk_n}]
 set_property -dict { PACKAGE_PIN U16   IOSTANDARD TMDS_33 } [get_ports {hdmi_tmds_clk_p}]

 set_property -dict { PACKAGE_PIN U18   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_data_n[0]}]
 set_property -dict { PACKAGE_PIN R17   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_data_n[1]}]
 set_property -dict { PACKAGE_PIN T14   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_data_n[2]}]

 set_property -dict { PACKAGE_PIN U17   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_data_p[0]}]
 set_property -dict { PACKAGE_PIN R16   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_data_p[1]}]
 set_property -dict { PACKAGE_PIN R14   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_data_p[2]}]




#SD card!!!
set_property IOSTANDARD LVCMOS33 [get_ports SD_DQ0]
set_property IOSTANDARD LVCMOS33 [get_ports SD_DQ1]
set_property IOSTANDARD LVCMOS33 [get_ports SD_DQ2]
set_property IOSTANDARD LVCMOS33 [get_ports SD_DQ3]
set_property IOSTANDARD LVCMOS33 [get_ports SD_CMD]
set_property IOSTANDARD LVCMOS33 [get_ports SD_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports SD_CD]
set_property PACKAGE_PIN M16 [get_ports SD_DQ0]
set_property PACKAGE_PIN M17 [get_ports SD_DQ1]
set_property PACKAGE_PIN M18 [get_ports SD_DQ2]
set_property PACKAGE_PIN N18 [get_ports SD_DQ3]
set_property PACKAGE_PIN P17 [get_ports SD_CMD]
set_property PACKAGE_PIN P18 [get_ports SD_CLK]
set_property PACKAGE_PIN R18 [get_ports SD_CD]

#AUDIO OUTPUT!!!
# set_property IOSTANDARD LVCMOS33 [get_ports SPKL]
# set_property IOSTANDARD LVCMOS33 [get_ports SPKR]
# set_property PACKAGE_PIN B13 [get_ports SPKL]
# set_property PACKAGE_PIN B14 [get_ports SPKR]

# PMODx_1, PMODx_2, PMODx_3, PMODx_4
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {JA1_P}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports {JA1_N}]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {JA2_P}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {JA2_N}]

# JAB 2,3 on bank15 with pmod, rest are on bank 16
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS33} [get_ports {JAB_0}]
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {JAB_1}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {JAB_2}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {JAB_3}]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {JAB_4}]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports {JAB_5}]

set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS25} [get_ports {Reset}]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS25} [get_ports {Play_btn}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS25} [get_ports {Next_btn}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS25} [get_ports {Prev_btn}]