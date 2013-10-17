onerror {quit -f}
vlib work
vlog -work work FourBitcarryLookaheadAdder.vo
vlog -work work FourBitcarryLookaheadAdder.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.FourBitcarryLookaheadAdder_vlg_vec_tst
vcd file -direction FourBitcarryLookaheadAdder.msim.vcd
vcd add -internal FourBitcarryLookaheadAdder_vlg_vec_tst/*
vcd add -internal FourBitcarryLookaheadAdder_vlg_vec_tst/i1/*
add wave /*
run -all
