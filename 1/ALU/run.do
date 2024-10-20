vlib work
vlog ALU.v tb.sv  +cover -covercells
vsim -voptargs=+acc work.tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit -du work.ALU_4_bit
run -all

coverage exclude -src ALU.v -line 26 -code s


//vcover report dff_merged.ucdb -details -all -output coverage_report.txt
