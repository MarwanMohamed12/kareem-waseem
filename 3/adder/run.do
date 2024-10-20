vlib work
vlog adder.v Adder_tb.sv pack.sv +cover -covercells
vsim -voptargs=+acc work.Adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit 
run -all

quit -sim

vcover report adder_tb.ucdb -details -all -output coverage_report.txt
