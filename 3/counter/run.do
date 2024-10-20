vlib work
vlog counter.v counter_tb.sv all_item.sv +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
add wave *
coverage save counter_tb.ucdb -onexit 
run -all
quit -sim

vcover report counter_tb.ucdb -details -all -output coverage_report.txt
