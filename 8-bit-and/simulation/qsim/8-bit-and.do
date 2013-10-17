onerror {quit -f}
vlib work
vlog -work work 8-bit-and.vo
vlog -work work 8-bit-and.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.8-bit-and_vlg_vec_tst
vcd file -direction 8-bit-and.msim.vcd
vcd add -internal 8-bit-and_vlg_vec_tst/*
vcd add -internal 8-bit-and_vlg_vec_tst/i1/*
add wave /*
run -all
