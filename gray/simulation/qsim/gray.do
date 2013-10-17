onerror {quit -f}
vlib work
vlog -work work gray.vo
vlog -work work gray.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.gray_vlg_vec_tst
vcd file -direction gray.msim.vcd
vcd add -internal gray_vlg_vec_tst/*
vcd add -internal gray_vlg_vec_tst/i1/*
add wave /*
run -all
