onerror {quit -f}
vlib work
vlog -work work EightBitAdd.vo
vlog -work work EightBitAdd.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.EightBitAdd_vlg_vec_tst
vcd file -direction EightBitAdd.msim.vcd
vcd add -internal EightBitAdd_vlg_vec_tst/*
vcd add -internal EightBitAdd_vlg_vec_tst/i1/*
add wave /*
run -all
