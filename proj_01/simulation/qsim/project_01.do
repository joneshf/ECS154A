onerror {quit -f}
vlib work
vlog -work work project_01.vo
vlog -work work project_01.vt
vsim -novopt -c -t 1ps -L arriaii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.project_01_vlg_vec_tst
vcd file -direction project_01.msim.vcd
vcd add -internal project_01_vlg_vec_tst/*
vcd add -internal project_01_vlg_vec_tst/i1/*
add wave /*
run -all
