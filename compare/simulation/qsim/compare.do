onerror {quit -f}
vlib work
vlog -work work compare.vo
vlog -work work compare.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.compare_vlg_vec_tst
vcd file -direction compare.msim.vcd
vcd add -internal compare_vlg_vec_tst/*
vcd add -internal compare_vlg_vec_tst/i1/*
add wave /*
run -all
