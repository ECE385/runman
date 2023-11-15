create_clock -period 10.000 -name clk_100 -waveform {0.000 5.000} [get_ports Clk]

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
set_property IOSTANDARD LVCMOS33 [get_ports SPKL]
set_property IOSTANDARD LVCMOS33 [get_ports SPKR]
set_property PACKAGE_PIN B13 [get_ports SPKL]
set_property PACKAGE_PIN B14 [get_ports SPKR]