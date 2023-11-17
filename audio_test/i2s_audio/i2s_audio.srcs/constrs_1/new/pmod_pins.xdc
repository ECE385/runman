create_clock -period 10 [get_ports {Clk}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS25} [get_ports {Clk}]

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