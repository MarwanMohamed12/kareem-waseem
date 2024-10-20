vlib work
vlog *v +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

add wave -position insertpoint sim:/top/if_t/*
add wave -position insertpoint sim:/top/sr_t/*
coverage save Top_tb.ucdb -onexit 
run -all

coverage exclude -dirpath /top/DUT/AS/bypass2_cover /top/DUT/AS/OR2_cover /top/DUT/AS/XOR2_cover /top/DUT/AS/halfADD_cover
coverage exclude -src ALSU.sv -line 114 -code b
coverage exclude -clear -src ALSU.sv -code b -line 114
coverage exclude -src ALSU.sv -line 64 -code b
coverage exclude -src ALSU.sv -line 75 -code b
coverage exclude -src ALSU.sv -line 85 -code b
coverage exclude -src ALSU.sv -line 96 -code b
coverage exclude -src ALSU.sv -line 114 -code b
coverage exclude -src ALSU.sv -line 97 -code s
coverage exclude -src ALSU.sv -line 114 -code s


quit -sim
vcover report Top_tb.ucdb -details -all -output coverage_report.txt