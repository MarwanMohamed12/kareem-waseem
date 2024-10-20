vlib work
vlog DSP.v tb.sv  +cover -covercells
vsim -voptargs=+acc work.tb -cover
add wave *
coverage save DSP_tb.ucdb -onexit -du work.DSP
run -all


//vcover report DSP_tb.ucdb -details -all -output coverage_report.txt
