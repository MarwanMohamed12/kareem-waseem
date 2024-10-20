vlib work
vlog *v +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

add wave -position insertpoint sim:/top/if_t/*
add wave -position insertpoint sim:/top/sr_t/*
coverage save Top_tb.ucdb -onexit 
run -all

coverage exclude -dirpath /top/DUT/AS/OR2_cover /top/DUT/AS/bypass2_cover /top/DUT/AS/XOR2_cover /top/DUT/AS/halfADD_cover
coverage exclude -src ALSU.sv -line 101 -code s
coverage exclude -du ALSU -togglenode invalid_opcode
coverage exclude -src ALSU.sv -line 68 -code b
coverage exclude -src ALSU.sv -line 79 -code b
coverage exclude -src ALSU.sv -line 89 -code b
coverage exclude -src ALSU.sv -line 100 -code b


quit -sim
vcover report Top_tb.ucdb -details -all -output coverage_report.txt