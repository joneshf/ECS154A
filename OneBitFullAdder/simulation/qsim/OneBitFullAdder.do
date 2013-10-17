onerror {quit -f}
vlib work
vlog -work work OneBitFullAdder.vo
vlog -work work OneBitFullAdder.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.OneBitFullAdder_vlg_vec_tst
vcd file -direction OneBitFullAdder.msim.vcd
vcd add -internal OneBitFullAdder_vlg_vec_tst/*
vcd add -internal OneBitFullAdder_vlg_vec_tst/i1/*
add wave /*
run -all
