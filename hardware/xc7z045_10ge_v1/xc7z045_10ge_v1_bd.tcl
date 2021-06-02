
################################################################
# This is a generated script based on design: xc7z045_10ge_v1_bd
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
# source xc7z045_10ge_v1_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# ethernet_flow_cntrl, heart_beat, link_status

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z045ffg900-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name xc7z045_10ge_v1_bd

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
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:ten_gig_eth_mac:15.1\
xilinx.com:ip:ten_gig_eth_pcs_pma:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
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

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
ethernet_flow_cntrl\
heart_beat\
link_status\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
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
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set eth_link_led [ create_bd_port -dir O eth_link_led ]
  set eth_ref_156MHz_clk_n [ create_bd_port -dir I -type clk eth_ref_156MHz_clk_n ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
 ] $eth_ref_156MHz_clk_n
  set eth_ref_156MHz_clk_p [ create_bd_port -dir I -type clk eth_ref_156MHz_clk_p ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
 ] $eth_ref_156MHz_clk_p
  set eth_reset_done_led [ create_bd_port -dir O eth_reset_done_led ]
  set eth_rx_n [ create_bd_port -dir I eth_rx_n ]
  set eth_rx_p [ create_bd_port -dir I eth_rx_p ]
  set eth_tx_disable [ create_bd_port -dir O eth_tx_disable ]
  set eth_tx_n [ create_bd_port -dir O eth_tx_n ]
  set eth_tx_p [ create_bd_port -dir O eth_tx_p ]
  set heth_eart_beat_led [ create_bd_port -dir O heth_eart_beat_led ]

  # Create instance: PS_axi_interconnect, and set properties
  set PS_axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 PS_axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $PS_axi_interconnect

  # Create instance: dma, and set properties
  set dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma ]
  set_property -dict [ list \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_burst_size {256} \
   CONFIG.c_s2mm_burst_size {256} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
 ] $dma

  # Create instance: dma_smartconnect, and set properties
  set dma_smartconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 dma_smartconnect ]
  set_property -dict [ list \
   CONFIG.NUM_SI {2} \
 ] $dma_smartconnect

  # Create instance: eth_flow_cntrl, and set properties
  set block_name ethernet_flow_cntrl
  set block_cell_name eth_flow_cntrl
  if { [catch {set eth_flow_cntrl [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_flow_cntrl eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: eth_heart_beat, and set properties
  set block_name heart_beat
  set block_cell_name eth_heart_beat
  if { [catch {set eth_heart_beat [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_heart_beat eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: eth_link_status, and set properties
  set block_name link_status
  set block_cell_name eth_link_status
  if { [catch {set eth_link_status [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_link_status eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: eth_mac, and set properties
  set eth_mac [ create_bd_cell -type ip -vlnv xilinx.com:ip:ten_gig_eth_mac:15.1 eth_mac ]
  set_property -dict [ list \
   CONFIG.Statistics_Gathering {true} \
 ] $eth_mac

  # Create instance: eth_pcs_pma, and set properties
  set eth_pcs_pma [ create_bd_cell -type ip -vlnv xilinx.com:ip:ten_gig_eth_pcs_pma:6.0 eth_pcs_pma ]
  set_property -dict [ list \
   CONFIG.SupportLevel {1} \
 ] $eth_pcs_pma

  # Create instance: eth_proc_sys_reset, and set properties
  set eth_proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 eth_proc_sys_reset ]

  # Create instance: eth_rx_axis_data_fifo, and set properties
  set eth_rx_axis_data_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 eth_rx_axis_data_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {32768} \
   CONFIG.FIFO_MODE {2} \
 ] $eth_rx_axis_data_fifo

  # Create instance: eth_tx_axis_data_fifo, and set properties
  set eth_tx_axis_data_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 eth_tx_axis_data_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {32768} \
   CONFIG.FIFO_MODE {2} \
   CONFIG.TDATA_NUM_BYTES {8} \
 ] $eth_tx_axis_data_fifo

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_OF_PROBES {9} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_0

  # Create instance: ila_1, and set properties
  set ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_1 ]
  set_property -dict [ list \
   CONFIG.C_NUM_OF_PROBES {9} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_1

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
   CONFIG.PCW_MIO_48_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {HSTL 1.8V} \
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

  # Create instance: ps_proc_sys_reset, and set properties
  set ps_proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ps_proc_sys_reset ]

  # Create instance: vio, and set properties
  set vio [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {6} \
   CONFIG.C_NUM_PROBE_OUT {0} \
   CONFIG.C_PROBE_IN4_WIDTH {1} \
   CONFIG.C_PROBE_IN5_WIDTH {8} \
 ] $vio

  # Create instance: xlconcat, and set properties
  set xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat

  # Create instance: xlconstant_1h0, and set properties
  set xlconstant_1h0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1h0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1h0

  # Create instance: xlconstant_1h1, and set properties
  set xlconstant_1h1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1h1 ]

  # Create instance: xlconstant_3h5, and set properties
  set xlconstant_3h5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3h5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {5} \
   CONFIG.CONST_WIDTH {3} \
 ] $xlconstant_3h5

  # Create instance: xlconstant_5h0, and set properties
  set xlconstant_5h0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5h0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {5} \
 ] $xlconstant_5h0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins dma/M_AXIS_MM2S] [get_bd_intf_pins eth_tx_axis_data_fifo/S_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins dma/M_AXI_MM2S] [get_bd_intf_pins dma_smartconnect/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins dma/M_AXI_S2MM] [get_bd_intf_pins dma_smartconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins PS_axi_interconnect/M00_AXI] [get_bd_intf_pins dma/S_AXI_LITE]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins dma/S_AXIS_S2MM] [get_bd_intf_pins eth_rx_axis_data_fifo/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins eth_mac/s_axis_tx] [get_bd_intf_pins eth_tx_axis_data_fifo/M_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_data_fifo_1_M_AXIS] [get_bd_intf_pins eth_tx_axis_data_fifo/M_AXIS] [get_bd_intf_pins ila_0/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net ethernet_flow_cntrl_0_s_axi [get_bd_intf_pins eth_flow_cntrl/s_axi] [get_bd_intf_pins eth_mac/s_axi]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins PS_axi_interconnect/S00_AXI] [get_bd_intf_pins ps/M_AXI_GP0]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins dma_smartconnect/M00_AXI] [get_bd_intf_pins ps/S_AXI_HP0]
  connect_bd_intf_net -intf_net ten_gig_eth_mac_0_m_axis_rx [get_bd_intf_pins eth_mac/m_axis_rx] [get_bd_intf_pins eth_rx_axis_data_fifo/S_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets ten_gig_eth_mac_0_m_axis_rx] [get_bd_intf_pins eth_rx_axis_data_fifo/S_AXIS] [get_bd_intf_pins ila_1/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net ten_gig_eth_mac_0_mdio_xgmac [get_bd_intf_pins eth_mac/mdio_xgmac] [get_bd_intf_pins eth_pcs_pma/mdio_interface]
  connect_bd_intf_net -intf_net ten_gig_eth_mac_0_xgmii_xgmac [get_bd_intf_pins eth_mac/xgmii_xgmac] [get_bd_intf_pins eth_pcs_pma/xgmii_interface]
  connect_bd_intf_net -intf_net ten_gig_eth_pcs_pma_0_core_gt_drp_interface [get_bd_intf_pins eth_pcs_pma/core_gt_drp_interface] [get_bd_intf_pins eth_pcs_pma/user_gt_drp_interface]

  # Create port connections
  connect_bd_net -net Net1 [get_bd_pins eth_mac/reset] [get_bd_pins eth_pcs_pma/reset] [get_bd_pins eth_proc_sys_reset/peripheral_reset]
  connect_bd_net -net Net2 [get_bd_pins eth_flow_cntrl/s_axi_reset_n] [get_bd_pins eth_mac/rx_axis_aresetn] [get_bd_pins eth_mac/s_axi_aresetn] [get_bd_pins eth_mac/tx_axis_aresetn] [get_bd_pins eth_proc_sys_reset/peripheral_aresetn] [get_bd_pins eth_rx_axis_data_fifo/s_axis_aresetn] [get_bd_pins eth_tx_axis_data_fifo/s_axis_aresetn]
  connect_bd_net -net Net3 [get_bd_pins eth_flow_cntrl/enable_custom_preamble] [get_bd_pins eth_flow_cntrl/enable_vlan] [get_bd_pins eth_flow_cntrl/pcs_loopback] [get_bd_pins eth_pcs_pma/sim_speedup_control] [get_bd_pins eth_pcs_pma/tx_fault] [get_bd_pins xlconstant_1h0/dout]
  connect_bd_net -net Net4 [get_bd_pins eth_mac/rx_dcm_locked] [get_bd_pins eth_mac/tx_dcm_locked] [get_bd_pins eth_pcs_pma/signal_detect] [get_bd_pins xlconstant_1h1/dout]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins dma/mm2s_introut] [get_bd_pins xlconcat/In0]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins dma/s2mm_introut] [get_bd_pins xlconcat/In1]
  connect_bd_net -net eth_ref_156MHz_clk_n_1 [get_bd_ports eth_ref_156MHz_clk_p] [get_bd_pins eth_pcs_pma/refclk_p]
  connect_bd_net -net eth_ref_156MHz_clk_p_1 [get_bd_ports eth_ref_156MHz_clk_n] [get_bd_pins eth_pcs_pma/refclk_n]
  connect_bd_net -net eth_rx_n_1 [get_bd_ports eth_rx_n] [get_bd_pins eth_pcs_pma/rxn]
  connect_bd_net -net eth_rx_p_1 [get_bd_ports eth_rx_p] [get_bd_pins eth_pcs_pma/rxp]
  connect_bd_net -net heart_beat_0_heart_beat_o [get_bd_ports heth_eart_beat_led] [get_bd_pins eth_heart_beat/heart_beat_o]
  connect_bd_net -net link_status_0_link_o [get_bd_ports eth_link_led] [get_bd_pins eth_link_status/link_o]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins PS_axi_interconnect/ARESETN] [get_bd_pins ps_proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins PS_axi_interconnect/M00_ARESETN] [get_bd_pins PS_axi_interconnect/S00_ARESETN] [get_bd_pins dma/axi_resetn] [get_bd_pins ps_proc_sys_reset/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins dma_smartconnect/aresetn] [get_bd_pins eth_proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins PS_axi_interconnect/ACLK] [get_bd_pins PS_axi_interconnect/M00_ACLK] [get_bd_pins PS_axi_interconnect/S00_ACLK] [get_bd_pins dma/s_axi_lite_aclk] [get_bd_pins eth_flow_cntrl/s_axi_aclk] [get_bd_pins eth_mac/s_axi_aclk] [get_bd_pins eth_pcs_pma/dclk] [get_bd_pins ps/FCLK_CLK0] [get_bd_pins ps/M_AXI_GP0_ACLK] [get_bd_pins ps_proc_sys_reset/slowest_sync_clk] [get_bd_pins vio/clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins eth_proc_sys_reset/ext_reset_in] [get_bd_pins ps/FCLK_RESET0_N] [get_bd_pins ps_proc_sys_reset/ext_reset_in]
  connect_bd_net -net ten_gig_eth_mac_0_rx_statistics_valid [get_bd_pins eth_mac/rx_statistics_valid] [get_bd_pins vio/probe_in2]
  connect_bd_net -net ten_gig_eth_mac_0_rx_statistics_vector [get_bd_pins eth_mac/rx_statistics_vector] [get_bd_pins vio/probe_in3]
  connect_bd_net -net ten_gig_eth_mac_0_tx_statistics_valid [get_bd_pins eth_mac/tx_statistics_valid] [get_bd_pins vio/probe_in0]
  connect_bd_net -net ten_gig_eth_mac_0_tx_statistics_vector [get_bd_pins eth_mac/tx_statistics_vector] [get_bd_pins vio/probe_in1]
  connect_bd_net -net ten_gig_eth_mac_0_xgmacint [get_bd_pins eth_mac/xgmacint] [get_bd_pins xlconcat/In2]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_core_status [get_bd_pins eth_link_status/status_i] [get_bd_pins eth_pcs_pma/core_status] [get_bd_pins vio/probe_in5]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_coreclk_out [get_bd_pins dma/m_axi_mm2s_aclk] [get_bd_pins dma/m_axi_s2mm_aclk] [get_bd_pins dma_smartconnect/aclk] [get_bd_pins eth_heart_beat/clk_i] [get_bd_pins eth_mac/rx_clk0] [get_bd_pins eth_mac/tx_clk0] [get_bd_pins eth_pcs_pma/coreclk_out] [get_bd_pins eth_proc_sys_reset/slowest_sync_clk] [get_bd_pins eth_rx_axis_data_fifo/s_axis_aclk] [get_bd_pins eth_tx_axis_data_fifo/s_axis_aclk] [get_bd_pins ila_0/clk] [get_bd_pins ila_1/clk] [get_bd_pins ps/S_AXI_HP0_ACLK]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_drp_req [get_bd_pins eth_pcs_pma/drp_gnt] [get_bd_pins eth_pcs_pma/drp_req]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_resetdone_out [get_bd_ports eth_reset_done_led] [get_bd_pins eth_heart_beat/srst_n_i] [get_bd_pins eth_pcs_pma/resetdone_out] [get_bd_pins vio/probe_in4]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_tx_disable [get_bd_ports eth_tx_disable] [get_bd_pins eth_pcs_pma/tx_disable]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_txn [get_bd_ports eth_tx_n] [get_bd_pins eth_pcs_pma/txn]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_txp [get_bd_ports eth_tx_p] [get_bd_pins eth_pcs_pma/txp]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins ps/IRQ_F2P] [get_bd_pins xlconcat/dout]
  connect_bd_net -net xlconstant_3h5_dout [get_bd_pins eth_pcs_pma/pma_pmd_type] [get_bd_pins xlconstant_3h5/dout]
  connect_bd_net -net xlconstant_5h0_dout [get_bd_pins eth_pcs_pma/prtad] [get_bd_pins xlconstant_5h0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/Data_MM2S] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces dma/Data_S2MM] [get_bd_addr_segs ps/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces eth_flow_cntrl/s_axi] [get_bd_addr_segs eth_mac/s_axi/Reg] SEG_ten_gig_eth_mac_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces ps/Data] [get_bd_addr_segs dma/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

