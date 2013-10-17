onerror {quit -f}
vlib work
vlog -work work EightBitNot.vo
vlog -work work EightBitNot.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.EightBitNot_vlg_vec_tst
vcd file -direction EightBitNot.msim.vcd
vcd add -internal EightBitNot_vlg_vec_tst/*
vcd add -internal EightBitNot_vlg_vec_tst/i1/*
add wave /*
run -all
