/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

-uvmhome /tools/cadence/XCELIUM/24.09.011/tools/methodology/UVM/CDNS-1.1d

-timescale 1ns/1ns

cdns_uvmreg_utils_pkg.sv
yapp_router_regs_rdb.sv
-incdir ../../yapp/sv
../../yapp/sv/yapp_pkg.sv
../../yapp/sv/yapp_if.sv

-incdir ../../channel/sv
../../channel/sv/channel_pkg.sv
../../channel/sv/channel_if.sv

-incdir ../../hbus/sv
../../hbus/sv/hbus_pkg.sv
../../hbus/sv/hbus_if.sv

-incdir ../../clock_and_reset/sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../clock_and_reset/sv/clock_and_reset_if.sv

+incdir+../sv
../sv/router_module_pkg.sv

clkgen.sv
../../router_rtl/yapp_router.sv


/*
// קבצי ה-UVM של Lab 8
-incdir ./sv
./sv/router_mcsequencer.sv
./sv/router_mcseqs_lib.sv
./sv/router_tb.sv
./sv/router_test_lib.sv
*/

hw_top.sv
tb_top.sv 
 
+UVM_VERBOSITY=UVM_LOW
//+UVM_TESTNAME=base_test
//+UVM_TESTNAME=uvm_reset_test
//+UVM_TESTNAME=reg_access_test
+UVM_TESTNAME=reg_function_test
