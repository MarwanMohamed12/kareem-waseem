vlib work
vlog *v +cover
vsim -voptargs=+acc work.top -cover
add wave *
coverage save ALU_tb.ucdb -onexit 
run -all
coverage exclude -src {E:/study/kareem wassem/ASSIGMENTS/4/ALU/ALU.sv} -line 11

quit -sim

vcover report ALU_tb.ucdb -details -all -output coverage_report.txt
