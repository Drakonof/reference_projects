
set_property PACKAGE_PIN AA18 [get_ports tx_disable]
set_property IOSTANDARD LVCMOS33 [get_ports tx_disable]

# SI5324 output to MGTREFCLK1
set_property PACKAGE_PIN AC8 [get_ports eth_ref_156MHz_clk_p]
set_property PACKAGE_PIN AC7 [get_ports eth_ref_156MHz_clk_n]

set_property PACKAGE_PIN Y5 [get_ports eth_rx_n]
set_property PACKAGE_PIN Y6 [get_ports eth_rx_p]
set_property PACKAGE_PIN W3 [get_ports eth_tx_n]
set_property PACKAGE_PIN W4 [get_ports eth_tx_p]

#R
set_property PACKAGE_PIN W21 [get_ports heart_beat_led]
set_property IOSTANDARD LVCMOS25 [get_ports heart_beat_led]
#0
set_property PACKAGE_PIN A17 [get_ports link_led]
set_property IOSTANDARD LVCMOS15 [get_ports link_led]

#L
set_property PACKAGE_PIN Y21 [get_ports reset_done_led]
set_property IOSTANDARD LVCMOS25 [get_ports reset_done_led]
