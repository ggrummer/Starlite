create_clock -period 125.00 -name {star_top|clkfast} -waveform [list 0.00 62.50] [get_nets clkfast]
create_clock -period 1250.00 -name {star_top|clk8} -waveform [list 0.00 625.00] [get_nets clk8]
