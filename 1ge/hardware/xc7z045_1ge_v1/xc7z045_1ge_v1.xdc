set_property LOC AC8 [get_ports mgt_clk_125_p]
set_property LOC AC7 [get_ports mgt_clk_125_n]

create_clock -name mgt_clk_125_p -period 8.0 [get_ports mgt_clk_125_p]

set_property LOC W4 [get_ports sfp_txp]
set_property LOC W3 [get_ports sfp_txn]
set_property LOC Y6 [get_ports sfp_rxp]
set_property LOC Y5 [get_ports sfp_rxn]

set_property LOC H9 [get_ports ref_clk_200_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports ref_clk_200_p]
set_property LOC G9 [get_ports ref_clk_200_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports ref_clk_200_n]

create_clock -name ref_clk_200_p -period 5.0 [get_ports ref_clk_200_p]

set_property LOC AA18 [get_ports sft_tx_disable]
set_property IOSTANDARD LVCMOS33 [get_ports sft_tx_disable]
set_false_path -from [get_clocks mgt_clk_125_p] -to [get_ports sft_tx_disable]
set_false_path -from [get_clocks ref_clk_200_p] -to [get_ports sft_tx_disable]
