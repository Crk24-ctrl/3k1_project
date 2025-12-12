do compile_p1.do

vsim -voptargs=+acc work.three_k_plus_one

;# --- Waves (keep it clean for printing) ---
delete wave *
add wave sim:/three_k_plus_one/reset
add wave sim:/three_k_plus_one/clk
add wave -radix unsigned sim:/three_k_plus_one/number_out
add wave -radix unsigned sim:/three_k_plus_one/term_out
add wave sim:/three_k_plus_one/done_out
add wave -radix unsigned sim:/three_k_plus_one/length_r

;# --- Clock: 10 ns period ---
force -freeze sim:/three_k_plus_one/clk 0 0, 1 5 -repeat 10

;# --- Async reset pulse ---
force -freeze sim:/three_k_plus_one/reset 1
run 30 ns
force -freeze sim:/three_k_plus_one/reset 0

;# --- Run long enough to reach number=6 and done=1 ---
run 400 ns

;# Optional: zoom to a nice window for printing
;# (Adjust if you want, but this range usually prints well)
wave zoom range 0 ns 400 ns
