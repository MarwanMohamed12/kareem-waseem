vlib work
vlog dff.v tb.sv +cover -covercells
vsim -voptargs=+acc work.tb_1 -cover
add wave *
coverage save dff_t1.ucdb -onexit -du work.dff
run -all
quit -sim

vlog dff.v tb_2.sv  +cover -covercells
vsim -voptargs=+acc work.tb_2 -cover
add wave *
coverage save dff_t2.ucdb -onexit -du work.dff
run -all
quit -sim

vcover merge dff_merged.ucdb dff_t1.ucdb dff_t2.ucdb -du dff

vcover report dff_merged.ucdb -details -all -output coverage_report.txt
