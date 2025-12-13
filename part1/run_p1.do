vsim -voptargs=+acc work.three_k_plus_one

delete wave *
add wave sim:/three_k_plus_one/reset
add wave sim:/three_k_plus_one/clk
add wave -radix unsigned sim:/three_k_plus_one/number_out
add wave -radix unsigned sim:/three_k_plus_one/term_out
add wave sim:/three_k_plus_one/done_out
add wave -radix unsigned sim:/three_k_plus_one/length_r

force -freeze sim:/three_k_plus_one/clk 0 0, 1 5 -repeat 10

force -freeze sim:/three_k_plus_one/reset 1
run 30 ns
force -freeze sim:/three_k_plus_one/reset 0

run 400 ns

wave zoom range 0 ns 400 ns
