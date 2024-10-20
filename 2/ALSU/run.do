vlib work
vlog ALSU.v ALSU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit -du work.ALSU
run -all
quit -sim

vcover report ALSU_tb.ucdb -details -all -output coverage_report.txt
