
################################################################
# This is a generated script based on design: xc7z045_xdma_bd
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
# source xc7z045_xdma_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# heart_beat

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
set design_name xc7z045_xdma_bd

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
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:processing_system7:5.5\
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
heart_beat\
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
  set DDR_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR_0 ]
  set FIXED_IO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO_0 ]

  # Create ports
  set pcie_heart_beat_led [ create_bd_port -dir O pcie_heart_beat_led ]
  set pcie_link_up_led [ create_bd_port -dir O pcie_link_up_led ]
  set pcie_rx_n [ create_bd_port -dir I -from 3 -to 0 pcie_rx_n ]
  set pcie_rx_p [ create_bd_port -dir I -from 3 -to 0 pcie_rx_p ]
  set pcie_sys_clk_100M_n [ create_bd_port -dir I -from 0 -to 0 -type clk pcie_sys_clk_100M_n ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $pcie_sys_clk_100M_n
  set pcie_sys_clk_100M_p [ create_bd_port -dir I -from 0 -to 0 -type clk pcie_sys_clk_100M_p ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $pcie_sys_clk_100M_p
  set pcie_sys_rst_n [ create_bd_port -dir I -type rst pcie_sys_rst_n ]
  set pcie_tx_n [ create_bd_port -dir O -from 3 -to 0 pcie_tx_n ]
  set pcie_tx_p [ create_bd_port -dir O -from 3 -to 0 pcie_tx_p ]

  # Create instance: block_mem_gen, and set properties
  set block_mem_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 block_mem_gen ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $block_mem_gen

  # Create instance: pcie, and set properties
  set pcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 pcie ]
  set_property -dict [ list \
   CONFIG.PF0_DEVICE_ID_mqdma {9024} \
   CONFIG.PF2_DEVICE_ID_mqdma {9024} \
   CONFIG.PF3_DEVICE_ID_mqdma {9024} \
   CONFIG.axi_data_width {128_bit} \
   CONFIG.axilite_master_en {false} \
   CONFIG.axilite_master_scale {Megabytes} \
   CONFIG.axilite_master_size {1} \
   CONFIG.axist_bypass_en {false} \
   CONFIG.axist_bypass_scale {Megabytes} \
   CONFIG.axist_bypass_size {1} \
   CONFIG.axisten_freq {125} \
   CONFIG.pf0_device_id {7024} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_0} \
   CONFIG.pf0_msix_cap_table_bir {BAR_0} \
   CONFIG.pl_link_cap_max_link_speed {5.0_GT/s} \
   CONFIG.pl_link_cap_max_link_width {X4} \
   CONFIG.plltype {QPLL1} \
 ] $pcie

  # Create instance: pcie_axi_bram_ctrl, and set properties
  set pcie_axi_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 pcie_axi_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $pcie_axi_bram_ctrl

  # Create instance: pcie_axi_interconnect, and set properties
  set pcie_axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 pcie_axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $pcie_axi_interconnect

  # Create instance: pcie_const_19h0, and set properties
  set pcie_const_19h0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pcie_const_19h0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {19} \
 ] $pcie_const_19h0

  # Create instance: pcie_const_1h0, and set properties
  set pcie_const_1h0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pcie_const_1h0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $pcie_const_1h0

  # Create instance: pcie_const_32h0, and set properties
  set pcie_const_32h0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pcie_const_32h0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $pcie_const_32h0

  # Create instance: pcie_const_4h0, and set properties
  set pcie_const_4h0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pcie_const_4h0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $pcie_const_4h0

  # Create instance: pcie_heart_beat, and set properties
  set block_name heart_beat
  set block_cell_name pcie_heart_beat
  if { [catch {set pcie_heart_beat [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pcie_heart_beat eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pcie_proc_sys_reset, and set properties
  set pcie_proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pcie_proc_sys_reset ]

  # Create instance: pcie_util_ds_buf, and set properties
  set pcie_util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 pcie_util_ds_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $pcie_util_ds_buf

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
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {54} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1800.000} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#UART 1#UART 1#unassigned#unassigned#unassigned#unassigned} \
   CONFIG.PCW_MIO_TREE_SIGNALS {unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#tx#rx#unassigned#unassigned#unassigned#unassigned} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {9} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
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
   CONFIG.PCW_USE_S_AXI_HP0 {0} \
 ] $ps

  # Create instance: ps_axi_bram_ctrl, and set properties
  set ps_axi_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 ps_axi_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $ps_axi_bram_ctrl

  # Create instance: ps_axi_interconnect, and set properties
  set ps_axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $ps_axi_interconnect

  # Create instance: ps_proc_sys_reset, and set properties
  set ps_proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ps_proc_sys_reset ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins block_mem_gen/BRAM_PORTB] [get_bd_intf_pins pcie_axi_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins block_mem_gen/BRAM_PORTA] [get_bd_intf_pins ps_axi_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_interconnect_4_M00_AXI [get_bd_intf_pins pcie_axi_bram_ctrl/S_AXI] [get_bd_intf_pins pcie_axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_5_M00_AXI [get_bd_intf_pins ps_axi_bram_ctrl/S_AXI] [get_bd_intf_pins ps_axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR_0] [get_bd_intf_pins ps/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO_0] [get_bd_intf_pins ps/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins ps/M_AXI_GP0] [get_bd_intf_pins ps_axi_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net xdma_M_AXI [get_bd_intf_pins pcie/M_AXI] [get_bd_intf_pins pcie_axi_interconnect/S00_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins pcie_axi_interconnect/ARESETN] [get_bd_pins pcie_proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins pcie_axi_bram_ctrl/s_axi_aresetn] [get_bd_pins pcie_axi_interconnect/M00_ARESETN] [get_bd_pins pcie_axi_interconnect/S00_ARESETN] [get_bd_pins pcie_proc_sys_reset/peripheral_aresetn]
  connect_bd_net -net S00_ARESETN_2 [get_bd_pins ps_axi_bram_ctrl/s_axi_aresetn] [get_bd_pins ps_axi_interconnect/M00_ARESETN] [get_bd_pins ps_axi_interconnect/S00_ARESETN] [get_bd_pins ps_proc_sys_reset/peripheral_aresetn]
  connect_bd_net -net heart_beat_0_beat_o [get_bd_ports pcie_heart_beat_led] [get_bd_pins pcie_heart_beat/heart_beat_o]
  connect_bd_net -net pcie_rxn_1 [get_bd_ports pcie_rx_n] [get_bd_pins pcie/pci_exp_rxn]
  connect_bd_net -net pcie_rxp_1 [get_bd_ports pcie_rx_p] [get_bd_pins pcie/pci_exp_rxp]
  connect_bd_net -net pcie_sys_rst_n_1 [get_bd_ports pcie_sys_rst_n] [get_bd_pins pcie/sys_rst_n]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins ps_axi_interconnect/ARESETN] [get_bd_pins ps_proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins pcie/axi_aclk] [get_bd_pins pcie_axi_bram_ctrl/s_axi_aclk] [get_bd_pins pcie_axi_interconnect/ACLK] [get_bd_pins pcie_axi_interconnect/M00_ACLK] [get_bd_pins pcie_axi_interconnect/S00_ACLK] [get_bd_pins pcie_heart_beat/clk_i] [get_bd_pins pcie_proc_sys_reset/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins ps/FCLK_CLK0] [get_bd_pins ps/M_AXI_GP0_ACLK] [get_bd_pins ps_axi_bram_ctrl/s_axi_aclk] [get_bd_pins ps_axi_interconnect/ACLK] [get_bd_pins ps_axi_interconnect/M00_ACLK] [get_bd_pins ps_axi_interconnect/S00_ACLK] [get_bd_pins ps_proc_sys_reset/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins ps/FCLK_RESET0_N] [get_bd_pins ps_proc_sys_reset/ext_reset_in]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins pcie/sys_clk] [get_bd_pins pcie_util_ds_buf/IBUF_OUT]
  connect_bd_net -net xdma_0_pci_exp_txn [get_bd_ports pcie_tx_n] [get_bd_pins pcie/pci_exp_txn]
  connect_bd_net -net xdma_0_pci_exp_txp [get_bd_ports pcie_tx_p] [get_bd_pins pcie/pci_exp_txp]
  connect_bd_net -net xdma_0_user_lnk_up [get_bd_ports pcie_link_up_led] [get_bd_pins pcie/user_lnk_up]
  connect_bd_net -net xdma_axi_aresetn [get_bd_pins pcie/axi_aresetn] [get_bd_pins pcie_heart_beat/srst_n_i] [get_bd_pins pcie_proc_sys_reset/ext_reset_in]
  connect_bd_net -net xdma_clk_100Mhz_n_1 [get_bd_ports pcie_sys_clk_100M_n] [get_bd_pins pcie_util_ds_buf/IBUF_DS_N]
  connect_bd_net -net xdma_clk_100Mhz_p_1 [get_bd_ports pcie_sys_clk_100M_p] [get_bd_pins pcie_util_ds_buf/IBUF_DS_P]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins pcie/cfg_mgmt_read] [get_bd_pins pcie/cfg_mgmt_type1_cfg_reg_access] [get_bd_pins pcie/cfg_mgmt_write] [get_bd_pins pcie/usr_irq_req] [get_bd_pins pcie_const_1h0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins pcie/cfg_mgmt_write_data] [get_bd_pins pcie_const_32h0/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins pcie/cfg_mgmt_byte_enable] [get_bd_pins pcie_const_4h0/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins pcie/cfg_mgmt_addr] [get_bd_pins pcie_const_19h0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x40000000 [get_bd_addr_spaces pcie/M_AXI] [get_bd_addr_segs pcie_axi_bram_ctrl/S_AXI/Mem0] SEG_pcie_axi_bram_ctrl_Mem0
  create_bd_addr_seg -range 0x00001000 -offset 0x40000000 [get_bd_addr_spaces ps/Data] [get_bd_addr_segs ps_axi_bram_ctrl/S_AXI/Mem0] SEG_ps_axi_bram_ctrl_Mem0


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


