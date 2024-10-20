vlib work
vlog *v +cover
vsim -voptargs=+acc work.Assertion_ex2 -cover
add wave *
coverage save Assertion_ex2_tb.ucdb -onexit -du work.Assertion_ex2
run -all
Quit -sim