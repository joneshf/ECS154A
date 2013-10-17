onerror {quit -f}
vlib work
vlog -work work EightBitXor.vo
vlog -work work EightBitXor.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.EightBitXor_vlg_vec_tst
vcd file -direction EightBitXor.msim.vcd
vcd add -internal EightBitXor_vlg_vec_tst/*
vcd add -internal EightBitXor_vlg_vec_tst/i1/*
add wave /*
run -all
