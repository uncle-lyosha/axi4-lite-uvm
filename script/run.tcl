# TCL script
set test_name [lindex $argv 0]
set seed      [lindex $argv 1]
set is_cli    [lindex $argv 2]

set cov_dir   "sim/cov"
set cov_name  "${test_name}_seed_${seed}"

eval vsim -voptargs="+acc" -sv_seed $seed \
     +UVM_TESTNAME=$test_name \
     -coverage \
     work.axi_tb_top

if {$is_cli == 0} {
    echo " GUI Mode "
    add wave -position 1 -group "Global" sim:/axi_tb_top/axi4_lite_inst/aclk
    add wave -position 1 -group "Global" sim:/axi_tb_top/axi4_lite_inst/aresetn

    add wave -position 2 -group "Write Address" sim:/axi_tb_top/axi4_lite_inst/awaddr
    add wave -position 2 -group "Write Address" sim:/axi_tb_top/axi4_lite_inst/awready
    add wave -position 2 -group "Write Address" sim:/axi_tb_top/axi4_lite_inst/awvalid

    add wave -position 3 -group "Write Data" sim:/axi_tb_top/axi4_lite_inst/wdata
    add wave -position 3 -group "Write Data" sim:/axi_tb_top/axi4_lite_inst/wstrb
    add wave -position 3 -group "Write Data" sim:/axi_tb_top/axi4_lite_inst/wready
    add wave -position 3 -group "Write Data" sim:/axi_tb_top/axi4_lite_inst/wvalid

    add wave -position 4 -group "Write Response" sim:/axi_tb_top/axi4_lite_inst/bresp
    add wave -position 4 -group "Write Response" sim:/axi_tb_top/axi4_lite_inst/bvalid
    add wave -position 4 -group "Write Response" sim:/axi_tb_top/axi4_lite_inst/bready

    add wave -position 5 -group "Read Address" sim:/axi_tb_top/axi4_lite_inst/araddr
    add wave -position 5 -group "Read Address" sim:/axi_tb_top/axi4_lite_inst/arvalid
    add wave -position 5 -group "Read Address" sim:/axi_tb_top/axi4_lite_inst/arready

    add wave -position 6 -group "Read Data" sim:/axi_tb_top/axi4_lite_inst/rdata
    add wave -position 6 -group "Read Data" sim:/axi_tb_top/axi4_lite_inst/rresp
    add wave -position 6 -group "Read Data" sim:/axi_tb_top/axi4_lite_inst/rvalid
    add wave -position 6 -group "Read Data" sim:/axi_tb_top/axi4_lite_inst/rready

    add wave -position 7 -group "Reg Signals" sim:/axi_tb_top/axi4_lite_inst/awaddr_r
    add wave -position 7 -group "Reg Signals" sim:/axi_tb_top/axi4_lite_inst/wdata_r
    add wave -position 7 -group "Reg Signals" sim:/axi_tb_top/axi4_lite_inst/wstrb_r
    add wave -position 7 -group "Reg Signals" sim:/axi_tb_top/axi4_lite_inst/bresp_r
    add wave -position 7 -group "Reg Signals" sim:/axi_tb_top/axi4_lite_inst/araddr_r
    add wave -position 7 -group "Reg Signals" sim:/axi_tb_top/axi4_lite_inst/rdata_r
    add wave -position 7 -group "Reg Signals" sim:/axi_tb_top/axi4_lite_inst/rresp_r

    add wave -position 8 -group "State" sim:/axi_tb_top/axi4_lite_inst/next_w
    add wave -position 8 -group "State" sim:/axi_tb_top/axi4_lite_inst/next_r
    add wave -position 8 -group "State" sim:/axi_tb_top/axi4_lite_inst/state_w
    add wave -position 8 -group "State" sim:/axi_tb_top/axi4_lite_inst/state_r
    add wave -position 8 -group "State" sim:/axi_tb_top/axi4_lite_inst/state_bresp

    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/hsh_aw
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/hsh_w
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/hsh_ar
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/hsh_r
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/awready_r
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/wready_r
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/bvalid_r
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/arready_r
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/rvalid_r
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/one_ready_wr
    add wave -position 9 -group "Handshake & valid/ready" sim:/axi_tb_top/axi4_lite_inst/one_ready_rd

    add wave -position 10 -group "Register" sim:/axi_tb_top/axi4_lite_inst/control_reg
    add wave -position 10 -group "Register" sim:/axi_tb_top/axi4_lite_inst/status_reg
    add wave -position 10 -group "Register" sim:/axi_tb_top/axi4_lite_inst/data_in_reg
    add wave -position 10 -group "Register" sim:/axi_tb_top/axi4_lite_inst/data_out_reg

    run -all 

    wave zoomfull
} else {
    echo " CLI Mode "
    run -all

    # coverage attribute -name TESTNAME -value $test_name
    # coverage save "$cov_dir/$cov_name.ucdb"
    quit -f
}
