vlib work
vlog *v  +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave *
coverage save priroty_encoder_tb.ucdb -onexit 
run -all
quit -sim

vcover report priroty_encoder_tb.ucdb -details -all -output coverage_report.txt
