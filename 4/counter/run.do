vlib work
vlog *v +cover -covercells +define+SIM
vsim -voptargs=+acc work.top -cover
add wave *
coverage save counter_tb.ucdb -onexit 
run -all
quit -sim

vcover report counter_tb.ucdb -details -all -output coverage_report.txt
