do compile_p1.do
vsim -voptargs=+acc work.three_k_plus_one

add wave -radix unsigned sim:/three_k_plus_one/*
add wave -radix unsigned sim:/three_k_plus_one/number_r
add wave -radix unsigned sim:/three_k_plus_one/term_r
add wave -radix unsigned sim:/three_k_plus_one/length_r
add wave sim:/three_k_plus_one/done_r

force -freeze sim:/three_k_plus_one/clk 0 0, 1 5 -repeat 10

force -freeze sim:/three_k_plus_one/reset 1
run 30 ns
force -freeze sim:/three_k_plus_one/reset 0

run 2000 ns
