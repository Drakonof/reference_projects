
################################################################
# This is a generated script based on design: xc7z045_1ge_v1_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source xc7z045_1ge_v1_bd_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z045ffg900-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name xc7z045_1ge_v1_bd

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./bd

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_msg_id "BD_TCL-110" "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_msg_id "BD_TCL-008" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_msg_id "BD_TCL-009" "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-111" "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-010" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-112" "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_msg_id "BD_TCL-113" "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-011" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_msg_id "BD_TCL-012" "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:axi_ethernet:7.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconcat:2.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ddr [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr ]
  set fixed_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io ]
  set sfp [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sfp_rtl:1.0 sfp ]

  # Create ports
  set mgt_clk_125_n [ create_bd_port -dir I -type clk mgt_clk_125_n ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $mgt_clk_125_n
  set mgt_clk_125_p [ create_bd_port -dir I -type clk mgt_clk_125_p ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $mgt_clk_125_p
  set ref_clk_200_n [ create_bd_port -dir I -type clk ref_clk_200_n ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
 ] $ref_clk_200_n
  set ref_clk_200_p [ create_bd_port -dir I -type clk ref_clk_200_p ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
 ] $ref_clk_200_p
  set sft_tx_disable [ create_bd_port -dir O -from 0 -to 0 sft_tx_disable ]

  # Create instance: const_1h0, and set properties
  set const_1h0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1h0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $const_1h0

  # Create instance: const_1h1, and set properties
  set const_1h1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1h1 ]

  # Create instance: dma, and set properties
  set dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_sg_include_stscntrl_strm {1} \
 ] $dma

  # Create instance: dma_axi_interconnect, and set properties
  set dma_axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 dma_axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {3} \
 ] $dma_axi_interconnect

  # Create instance: dma_axis_data_fifo_rx, and set properties
  set dma_axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 dma_axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {1024} \
 ] $dma_axis_data_fifo_rx

  # Create instance: dma_axis_data_fifo_tx, and set properties
  set dma_axis_data_fifo_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 dma_axis_data_fifo_tx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {1024} \
 ] $dma_axis_data_fifo_tx

  # Create instance: ethernet, and set properties
  set ethernet [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 ethernet ]
  set_property -dict [ list \
   CONFIG.PHYADDR {3} \
   CONFIG.PHY_TYPE {1000BaseX} \
   CONFIG.RXCSUM {Full} \
   CONFIG.RXMEM {16k} \
   CONFIG.SupportLevel {1} \
   CONFIG.TXCSUM {Full} \
   CONFIG.TXMEM {16k} \
 ] $ethernet

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /ethernet/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /ethernet/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /ethernet/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /ethernet/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /ethernet/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /ethernet/gtref_clk_buf_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /ethernet/gtref_clk_out]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /ethernet/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /ethernet/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] [get_bd_pins /ethernet/pma_reset_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
 ] [get_bd_pins /ethernet/ref_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /ethernet/rxuserclk2_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /ethernet/rxuserclk_out]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /ethernet/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /ethernet/s_axi_lite_resetn]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /ethernet/userclk2_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /ethernet/userclk_out]

  # Create instance: ethernet_clk_wiz, and set properties
  set ethernet_clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 ethernet_clk_wiz ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {50.0} \
   CONFIG.CLKOUT1_JITTER {98.146} \
   CONFIG.CLKOUT1_PHASE_ERROR {89.971} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.PRIM_IN_FREQ {200.000} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $ethernet_clk_wiz

  # Create instance: ps, and set properties
  set ps [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {50000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {6} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {54} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1800.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#UART 1#UART 1#I2C 0#I2C 0#unassigned#unassigned} \
   CONFIG.PCW_MIO_TREE_SIGNALS {unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#tx#rx#scl#sda#unassigned#unassigned} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {9} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {HSTL 1.8V} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {8 Bits} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M8 HX-15E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {30.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
 ] $ps

  # Create instance: ps_axi_interconnect, and set properties
  set ps_axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_axi_interconnect ]

  # Create instance: ps_proc_sys_reset, and set properties
  set ps_proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ps_proc_sys_reset ]

  # Create instance: xlconcat, and set properties
  set xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins ps/M_AXI_GP0] [get_bd_intf_pins ps_axi_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_CNTRL [get_bd_intf_pins dma/M_AXIS_CNTRL] [get_bd_intf_pins ethernet/s_axis_txc]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins dma/M_AXI_MM2S] [get_bd_intf_pins dma_axi_interconnect/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins dma/M_AXI_S2MM] [get_bd_intf_pins dma_axi_interconnect/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins dma/M_AXI_SG] [get_bd_intf_pins dma_axi_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxs [get_bd_intf_pins dma/S_AXIS_STS] [get_bd_intf_pins ethernet/m_axis_rxs]
  connect_bd_intf_net -intf_net axi_ethernet_0_sfp [get_bd_intf_ports sfp] [get_bd_intf_pins ethernet/sfp]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins dma_axi_interconnect/M00_AXI] [get_bd_intf_pins ps/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins dma/S_AXI_LITE] [get_bd_intf_pins ps_axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins ethernet/s_axi] [get_bd_intf_pins ps_axi_interconnect/M01_AXI]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins dma_axis_data_fifo_tx/M_AXIS] [get_bd_intf_pins ethernet/s_axis_txd]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins dma/S_AXIS_S2MM] [get_bd_intf_pins dma_axis_data_fifo_rx/M_AXIS]
  connect_bd_intf_net -intf_net dma_M_AXIS_MM2S [get_bd_intf_pins dma/M_AXIS_MM2S] [get_bd_intf_pins dma_axis_data_fifo_tx/S_AXIS]
  connect_bd_intf_net -intf_net ethernet_m_axis_rxd [get_bd_intf_pins dma_axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins ethernet/m_axis_rxd]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports ddr] [get_bd_intf_pins ps/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports fixed_io] [get_bd_intf_pins ps/FIXED_IO]

  # Create port connections
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins dma/axi_resetn] [get_bd_pins dma_axi_interconnect/M00_ARESETN] [get_bd_pins dma_axi_interconnect/S00_ARESETN] [get_bd_pins dma_axi_interconnect/S01_ARESETN] [get_bd_pins dma_axi_interconnect/S02_ARESETN] [get_bd_pins dma_axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins dma_axis_data_fifo_tx/s_axis_aresetn] [get_bd_pins ethernet/s_axi_lite_resetn] [get_bd_pins ps_axi_interconnect/M00_ARESETN] [get_bd_pins ps_axi_interconnect/M01_ARESETN] [get_bd_pins ps_axi_interconnect/S00_ARESETN] [get_bd_pins ps_proc_sys_reset/peripheral_aresetn]
  connect_bd_net -net axi_dma_0_mm2s_cntrl_reset_out_n [get_bd_pins dma/mm2s_cntrl_reset_out_n] [get_bd_pins ethernet/axi_txc_arstn]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins dma/mm2s_introut] [get_bd_pins xlconcat/In0]
  connect_bd_net -net axi_dma_0_mm2s_prmry_reset_out_n [get_bd_pins dma/mm2s_prmry_reset_out_n] [get_bd_pins ethernet/axi_txd_arstn]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins dma/s2mm_introut] [get_bd_pins xlconcat/In1]
  connect_bd_net -net axi_dma_0_s2mm_prmry_reset_out_n [get_bd_pins dma/s2mm_prmry_reset_out_n] [get_bd_pins ethernet/axi_rxd_arstn]
  connect_bd_net -net axi_dma_0_s2mm_sts_reset_out_n [get_bd_pins dma/s2mm_sts_reset_out_n] [get_bd_pins ethernet/axi_rxs_arstn]
  connect_bd_net -net axi_ethernet_0_interrupt [get_bd_pins ethernet/interrupt] [get_bd_pins xlconcat/In2]
  connect_bd_net -net clk_in1_n_1 [get_bd_ports ref_clk_200_n] [get_bd_pins ethernet_clk_wiz/clk_in1_n]
  connect_bd_net -net clk_in1_p_1 [get_bd_ports ref_clk_200_p] [get_bd_pins ethernet_clk_wiz/clk_in1_p]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins ethernet/ref_clk] [get_bd_pins ethernet_clk_wiz/clk_out1]
  connect_bd_net -net const_1h0_dout [get_bd_ports sft_tx_disable] [get_bd_pins const_1h0/dout]
  connect_bd_net -net mgt_clk_clk_n_1 [get_bd_ports mgt_clk_125_n] [get_bd_pins ethernet/mgt_clk_clk_n]
  connect_bd_net -net mgt_clk_clk_p_1 [get_bd_ports mgt_clk_125_p] [get_bd_pins ethernet/mgt_clk_clk_p]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins dma_axi_interconnect/ARESETN] [get_bd_pins ps_axi_interconnect/ARESETN] [get_bd_pins ps_proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins dma/m_axi_mm2s_aclk] [get_bd_pins dma/m_axi_s2mm_aclk] [get_bd_pins dma/m_axi_sg_aclk] [get_bd_pins dma/s_axi_lite_aclk] [get_bd_pins dma_axi_interconnect/ACLK] [get_bd_pins dma_axi_interconnect/M00_ACLK] [get_bd_pins dma_axi_interconnect/S00_ACLK] [get_bd_pins dma_axi_interconnect/S01_ACLK] [get_bd_pins dma_axi_interconnect/S02_ACLK] [get_bd_pins dma_axis_data_fifo_rx/s_axis_aclk] [get_bd_pins dma_axis_data_fifo_tx/s_axis_aclk] [get_bd_pins ethernet/axis_clk] [get_bd_pins ethernet/s_axi_lite_clk] [get_bd_pins ps/FCLK_CLK0] [get_bd_pins ps/M_AXI_GP0_ACLK] [get_bd_pins ps/S_AXI_HP0_ACLK] [get_bd_pins ps_axi_interconnect/ACLK] [get_bd_pins ps_axi_interconnect/M00_ACLK] [get_bd_pins ps_axi_interconnect/M01_ACLK] [get_bd_pins ps_axi_interconnect/S00_ACLK] [get_bd_pins ps_proc_sys_reset/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins ps/FCLK_RESET0_N] [get_bd_pins ps_proc_sys_reset/ext_reset_in]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins ps/IRQ_F2P] [get_bd_pins xlconcat/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins const_1h1/dout] [get_bd_pins ethernet/signal_detect]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/Data_SG] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/Data_MM2S] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/Data_S2MM] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces ps/Data] [get_bd_addr_segs dma/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41000000 [get_bd_addr_spaces ps/Data] [get_bd_addr_segs ethernet/s_axi/Reg0] SEG_axi_ethernet_0_Reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


