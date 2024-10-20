vlib work
vlog priority_enc.v priority_enc_tb.sv  +cover -covercells
vsim -voptargs=+acc work.priority_enc_tb -cover
add wave *
coverage save priroty_encoder_tb.ucdb -onexit -du work.priority_enc
run -all


//vcover report priroty_encoder_tb.ucdb -details -all -output coverage_report.txt
