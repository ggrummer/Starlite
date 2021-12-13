localparam FAMILY = "iCE40UP";
localparam MEM_ID = "instr_dpram_sect2";
localparam MEM_SIZE = "32,256";
localparam WADDR_DEPTH = 256;
localparam WDATA_WIDTH = 32;
localparam RADDR_DEPTH = 256;
localparam RDATA_WIDTH = 32;
localparam WADDR_WIDTH = 8;
localparam REGMODE = "noreg";
localparam RADDR_WIDTH = 8;
localparam OUTPUT_CLK_EN = 0;
localparam RESETMODE = "sync";
localparam BYTE_ENABLE = 0;
localparam BYTE_WIDTH = 1;
localparam BYTE_SIZE = 8;
localparam ECC_ENABLE = 0;
localparam INIT_MODE = "mem_file";
localparam INIT_FILE = "C:/Projects/Starlite/SolRadi/instr_dpram_sect2/misc/pointblocktest_instr_dpram_sect2_copy.mem";
localparam INIT_FILE_FORMAT = "hex";
localparam INIT_VALUE_00 = "0xA0004064A0004063A0004063A0004063A0004063A0004063A0000000500070000x0FFD0F000FFB0FF00FF700F00FEF805F0FDF002F0FBF000F0F7F000020000000";
localparam INIT_VALUE_01 = "0x000000000000000000000000000000000000000020008FF114004063A00040630x00000000000000000000000000000000000000000000100000000BBB0FFE0F0F";
localparam INIT_VALUE_02 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_03 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_04 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_05 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_06 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_07 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_08 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_09 = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_0A = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_0B = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_0C = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_0D = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_0E = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_0F = "0x00000000000000000000000000000000000000000000000000000000000000000x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_10 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_11 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_12 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_13 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_14 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_15 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_16 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_17 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_18 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_19 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_1A = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_1B = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_1C = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_1D = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_1E = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_1F = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_20 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_21 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_22 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_23 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_24 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_25 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_26 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_27 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_28 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_29 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_2A = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_2B = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_2C = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_2D = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_2E = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_2F = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_30 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_31 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_32 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_33 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_34 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_35 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_36 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_37 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_38 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_39 = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_3A = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_3B = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_3C = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_3D = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_3E = "0x0000000000000000000000000000000000000000000000000000000000000000";
localparam INIT_VALUE_3F = "0x0000000000000000000000000000000000000000000000000000000000000000";
`define iCE40UP
`define ice40tp
`define iCE40UP5K
