# Legal Notice: (C)2018 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	pong_nios 	pong_nios:*
set 	pong_nios_oci 	pong_nios_nios2_oci:the_pong_nios_nios2_oci
set 	pong_nios_oci_break 	pong_nios_nios2_oci_break:the_pong_nios_nios2_oci_break
set 	pong_nios_ocimem 	pong_nios_nios2_ocimem:the_pong_nios_nios2_ocimem
set 	pong_nios_oci_debug 	pong_nios_nios2_oci_debug:the_pong_nios_nios2_oci_debug
set 	pong_nios_wrapper 	pong_nios_jtag_debug_module_wrapper:the_pong_nios_jtag_debug_module_wrapper
set 	pong_nios_jtag_tck 	pong_nios_jtag_debug_module_tck:the_pong_nios_jtag_debug_module_tck
set 	pong_nios_jtag_sysclk 	pong_nios_jtag_debug_module_sysclk:the_pong_nios_jtag_debug_module_sysclk
set 	pong_nios_oci_path 	 [format "%s|%s" $pong_nios $pong_nios_oci]
set 	pong_nios_oci_break_path 	 [format "%s|%s" $pong_nios_oci_path $pong_nios_oci_break]
set 	pong_nios_ocimem_path 	 [format "%s|%s" $pong_nios_oci_path $pong_nios_ocimem]
set 	pong_nios_oci_debug_path 	 [format "%s|%s" $pong_nios_oci_path $pong_nios_oci_debug]
set 	pong_nios_jtag_tck_path 	 [format "%s|%s|%s" $pong_nios_oci_path $pong_nios_wrapper $pong_nios_jtag_tck]
set 	pong_nios_jtag_sysclk_path 	 [format "%s|%s|%s" $pong_nios_oci_path $pong_nios_wrapper $pong_nios_jtag_sysclk]
set 	pong_nios_jtag_sr 	 [format "%s|*sr" $pong_nios_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$pong_nios_oci_break_path|break_readreg*] -to [get_keepers *$pong_nios_jtag_sr*]
set_false_path -from [get_keepers *$pong_nios_oci_debug_path|*resetlatch]     -to [get_keepers *$pong_nios_jtag_sr[33]]
set_false_path -from [get_keepers *$pong_nios_oci_debug_path|monitor_ready]  -to [get_keepers *$pong_nios_jtag_sr[0]]
set_false_path -from [get_keepers *$pong_nios_oci_debug_path|monitor_error]  -to [get_keepers *$pong_nios_jtag_sr[34]]
set_false_path -from [get_keepers *$pong_nios_ocimem_path|*MonDReg*] -to [get_keepers *$pong_nios_jtag_sr*]
set_false_path -from *$pong_nios_jtag_sr*    -to *$pong_nios_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$pong_nios_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$pong_nios_oci_debug_path|monitor_go
