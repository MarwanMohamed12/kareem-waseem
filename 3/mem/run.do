vlib work
vlog my_mem.sv my_mem_tb.sv pack.sv +cover -covercells
vsim -voptargs=+acc work.my_mem_tb -cover
add wave *
coverage save memory_tb.ucdb -onexit -du work.my_mem
run -all
quit -sim

vcover report memory_tb.ucdb -details -all -output coverage_report.txt
