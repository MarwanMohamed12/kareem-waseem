vlib work
vlog adder.v tb.sv  +cover -covercells
vsim -voptargs=+acc work.tb -cover
add wave *
coverage save adder_tb.ucdb -onexit -du work.adder
run -all


//vcover report adder_tb.ucdb -details -all -output coverage_report.txt
