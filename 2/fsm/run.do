vlib work
vlog FSM_010.v fsm_tb.sv pack.sv +cover -covercells
vsim -voptargs=+acc work.fsm_tb -cover
add wave *
coverage save fsm_tb.ucdb -onexit -du work.FSM_010
run -all

coverage exclude -du FSM_010 -togglenode {users_count[3]}
coverage exclude -du FSM_010 -togglenode {users_count[4]}
coverage exclude -du FSM_010 -togglenode {users_count[5]}
coverage exclude -du FSM_010 -togglenode {users_count[6]}
coverage exclude -du FSM_010 -togglenode {users_count[7]}
coverage exclude -du FSM_010 -togglenode {users_count[8]}
coverage exclude -du FSM_010 -togglenode {users_count[9]}

quit -sim


vcover report fsm_tb.ucdb -details -all -output coverage_report.txt
