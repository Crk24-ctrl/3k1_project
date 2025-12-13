do compile_p2.do

vsim -voptargs=+acc work.three_k_plus_one

delete wave *

add wave sim:/three_k_plus_one/reset
add wave sim:/three_k_plus_one/clk

add wave -radix unsigned sim:/three_k_plus_one/number_out
add wave -radix unsigned sim:/three_k_plus_one/term_out
add wave sim:/three_k_plus_one/done_out

add wave sim:/three_k_plus_one/U_CU/state

add wave sim:/three_k_plus_one/reset_number
add wave sim:/three_k_plus_one/inc_number
add wave sim:/three_k_plus_one/load_term
add wave sim:/three_k_plus_one/shift_term
add wave sim:/three_k_plus_one/multadd_term
add wave sim:/three_k_plus_one/reset_length
add wave sim:/three_k_plus_one/inc_length
add wave sim:/three_k_plus_one/load_done

add wave sim:/three_k_plus_one/term_is_one
add wave sim:/three_k_plus_one/term_is_even
add wave sim:/three_k_plus_one/length_ge_9

force -freeze sim:/three_k_plus_one/clk 0 0, 1 5 -repeat 10

force -freeze sim:/three_k_plus_one/reset 1
run 30 ns
force -freeze sim:/three_k_plus_one/reset 0

run 800 ns

wave zoom range 0 ns 300 ns
