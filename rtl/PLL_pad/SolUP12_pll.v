module SolUP12_pll(PACKAGEPIN,
                   PLLOUTCORE,
                   PLLOUTGLOBAL,
                   RESET,
                   LOCK);

inout PACKAGEPIN;
input RESET;    /* To initialize the simulation properly, the RESET signal (Active Low) must be asserted at the beginning of the simulation */ 
output PLLOUTCORE;
output PLLOUTGLOBAL;
output LOCK;

SB_PLL40_PAD SolUP12_pll_inst(.PACKAGEPIN(PACKAGEPIN),
                              .PLLOUTCORE(PLLOUTCORE),
                              .PLLOUTGLOBAL(PLLOUTGLOBAL),
                              .EXTFEEDBACK(),
                              .DYNAMICDELAY(),
                              .RESETB(RESET),
                              .BYPASS(1'b0),
                              .LATCHINPUTVALUE(),
                              .LOCK(LOCK),
                              .SDI(),
                              .SDO(),
                              .SCLK());

//\\ Fin=12, Fout=16;
defparam SolUP12_pll_inst.DIVR = 4'b0000;
defparam SolUP12_pll_inst.DIVF = 7'b1010100;
defparam SolUP12_pll_inst.DIVQ = 3'b110;
defparam SolUP12_pll_inst.FILTER_RANGE = 3'b001;
defparam SolUP12_pll_inst.FEEDBACK_PATH = "SIMPLE";
defparam SolUP12_pll_inst.DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED";
defparam SolUP12_pll_inst.FDA_FEEDBACK = 4'b0000;
defparam SolUP12_pll_inst.DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED";
defparam SolUP12_pll_inst.FDA_RELATIVE = 4'b0000;
defparam SolUP12_pll_inst.SHIFTREG_DIV_MODE = 2'b00;
defparam SolUP12_pll_inst.PLLOUT_SELECT = "GENCLK";
defparam SolUP12_pll_inst.ENABLE_ICEGATE = 1'b0;

endmodule
