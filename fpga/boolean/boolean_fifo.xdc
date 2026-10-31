# Real Digital Boolean official pin map, confirmed by user.
# https://www.realdigital.org/downloads/8d5c167add28c014173edcf51db78bb9.txt
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name board_clk [get_ports clk]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports reset_button]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
# Asynchronous pushbutton only asserts the reset synchronizers; release is local.
set_false_path -from [get_ports reset_button]
# Human-readable status LEDs have no external synchronous capture interface.
set_false_path -to [get_ports {led[*]}]
