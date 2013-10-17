onerror {quit -f}
vlib work
vlog -work work EightBitRot.vo
vlog -work work EightBitRot.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.EightBitRot_vlg_vec_tst
vcd file -direction EightBitRot.msim.vcd
vcd add -internal EightBitRot_vlg_vec_tst/*
vcd add -internal EightBitRot_vlg_vec_tst/i1/*
add wave /*
run -all
