onerror {quit -f}
vlib work
vlog -work work 4-bit-carry-lookahead-adder.vo
vlog -work work 4-bit-carry-lookahead-adder.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.4-bit-carry-lookahead-adder_vlg_vec_tst
vcd file -direction 4-bit-carry-lookahead-adder.msim.vcd
vcd add -internal 4-bit-carry-lookahead-adder_vlg_vec_tst/*
vcd add -internal 4-bit-carry-lookahead-adder_vlg_vec_tst/i1/*
add wave /*
run -all
