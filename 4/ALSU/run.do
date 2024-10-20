vlib work
vlog ALSU.v ALSU_tb.sv pack_alsu.sv +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit 
run -all
coverage exclude -src ALSU.v -line 121 -code b
coverage exclude -src ALSU.v -line 121 -code s
coverage exclude -du ALSU -togglenode {cin_reg[1]}
quit -sim

vcover report ALSU_tb.ucdb -details -all -output coverage_report.txt
