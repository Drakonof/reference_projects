set_property PACKAGE_PIN T2 [get_ports pcie_tx_p[3]]                                       
set_property PACKAGE_PIN T1 [get_ports pcie_tx_n[3]]
set_property PACKAGE_PIN V6 [get_ports pcie_rx_p[3]]
set_property PACKAGE_PIN V5 [get_ports pcie_rx_n[3]]

set_property PACKAGE_PIN R4 [get_ports pcie_tx_p[2]]
set_property PACKAGE_PIN R3 [get_ports pcie_tx_n[2]]
set_property PACKAGE_PIN U4 [get_ports pcie_rx_p[2]]
set_property PACKAGE_PIN U3 [get_ports pcie_rx_n[2]]

set_property PACKAGE_PIN P2 [get_ports pcie_tx_p[1]]
set_property PACKAGE_PIN P1 [get_ports pcie_tx_n[1]]
set_property PACKAGE_PIN T6 [get_ports pcie_rx_p[1]]
set_property PACKAGE_PIN T5 [get_ports pcie_rx_n[1]]

set_property PACKAGE_PIN N4 [get_ports pcie_tx_p[0]]
set_property PACKAGE_PIN N3 [get_ports pcie_tx_n[0]]
set_property PACKAGE_PIN P6 [get_ports pcie_rx_p[0]]
set_property PACKAGE_PIN P5 [get_ports pcie_rx_n[0]]

set_property PACKAGE_PIN N8 [get_ports pcie_sys_clk_100M_p]
create_clock -period 10.000 -name pcie_sys_clk_100M_p [get_ports pcie_sys_clk_100M_p]

set_property PACKAGE_PIN N7 [get_ports pcie_sys_clk_100M_n]

set_property PACKAGE_PIN Y21 [get_ports pcie_link_up_led]
set_property IOSTANDARD LVCMOS25 [get_ports pcie_link_up_led]
set_false_path -from [get_clocks pcie_sys_clk_100M_p] -to [get_ports pcie_link_up_led]

set_property PACKAGE_PIN W21 [get_ports pcie_heart_beat_led]
set_property IOSTANDARD LVCMOS25 [get_ports pcie_heart_beat_led]
set_false_path -from [get_clocks pcie_sys_clk_100M_p] -to [get_ports pcie_heart_beat_led]

set_property PACKAGE_PIN AK23 [get_ports pcie_sys_rst_n]
set_property IOSTANDARD LVCMOS25 [get_ports pcie_sys_rst_n]
set_false_path -fall_from [get_ports pcie_sys_rst_n]
