onerror {quit -f}
vlib work
vlog -work work EightBitAnd.vo
vlog -work work EightBitAnd.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.EightBitAnd_vlg_vec_tst
vcd file -direction EightBitAnd.msim.vcd
vcd add -internal EightBitAnd_vlg_vec_tst/*
vcd add -internal EightBitAnd_vlg_vec_tst/i1/*
add wave /*
run -all
