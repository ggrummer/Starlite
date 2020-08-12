----------------------------------------------------------------------
-- Create Date: 04/11/2020 
-- Module Name: instr_ram - rtl
-- By: Grant Grummer
-- 
-- Description: a 1024 x 32 bank of dual port RAMs, using 
--			 eight 256 x 16 iCE40 ENRs
-- 
-- Revision: 0.0
-- 
----------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

-- For Synplify Pro synthesis only
--library sb_ice40_components_syn;
--use sb_ice40_components_syn.components.all;

-- For LSE synthesis 
library ice;
use ice.vcomponent_vital.all;
library work;
--use work.components.all;


entity instr_ram is
   Port (
		reset8	: IN  STD_LOGIC;
		rclk  	: IN  STD_LOGIC;
		ren   	: IN  STD_LOGIC;
		raddr 	: IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		rdata 	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		wclk  	: IN  STD_LOGIC;
		wen   	: IN  STD_LOGIC;
		waddr 	: IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		wdata 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end instr_ram;


architecture rtl of instr_ram is

	
	-- this shouldn't be needed, but...
	component SB_RAM256x16
		port (
			rdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			raddr : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			rclk  : IN  STD_LOGIC;
			rclke : IN  STD_LOGIC;
			re    : IN  STD_LOGIC;
			wdata : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			waddr : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			wclk  : IN  STD_LOGIC;
			wclke : IN  STD_LOGIC;
			we    : IN  STD_LOGIC;
			mask  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;
	
	
	-- access all bits durning writes
	constant mask_int	: std_logic_vector (15 downto 0) := x"0000";
	
	signal rsel_1		: std_logic;
	signal rsel_2		: std_logic;
	signal rsel_3		: std_logic;
	signal rsel_4		: std_logic;
	
	signal rdata1v		: std_logic_vector(31 downto 0);
	signal rdata2v		: std_logic_vector(31 downto 0);
	signal rdata3v		: std_logic_vector(31 downto 0);
	signal rdata4v		: std_logic_vector(31 downto 0);
	
	signal wsel_1		: std_logic;
	signal wsel_2		: std_logic;
	signal wsel_3		: std_logic;
	signal wsel_4		: std_logic;
	
	
begin
	
	
	hi_1_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata1v(31 downto 16),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_1,
		re    => rsel_1,
		wdata => wdata(31 downto 16),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_1,
		we    => wsel_1,
		mask  => mask_int
	);
	
	hi_2_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata2v(31 downto 16),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_2,
		re    => rsel_2,
		wdata => wdata(31 downto 16),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_2,
		we    => wsel_2,
		mask  => mask_int
	);
	
	hi_3_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata3v(31 downto 16),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_3,
		re    => rsel_3,
		wdata => wdata(31 downto 16),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_3,
		we    => wsel_3,
		mask  => mask_int
	);
	
	hi_4_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata4v(31 downto 16),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_4,
		re    => rsel_4,
		wdata => wdata(31 downto 16),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_4,
		we    => wsel_4,
		mask  => mask_int
	);
	
	
	lo_1_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata1v(15 downto 0),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_1,
		re    => rsel_1,
		wdata => wdata(15 downto 0),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_1,
		we    => wsel_1,
		mask  => mask_int
	);
	
	lo_2_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata2v(15 downto 0),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_2,
		re    => rsel_2,
		wdata => wdata(15 downto 0),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_2,
		we    => wsel_2,
		mask  => mask_int
	);
	
	lo_3_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata3v(15 downto 0),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_3,
		re    => rsel_3,
		wdata => wdata(15 downto 0),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_3,
		we    => wsel_3,
		mask  => mask_int
	);
	
	lo_4_ram256x16_inst : SB_RAM256x16
	port map (
		rdata => rdata4v(15 downto 0),
		raddr => raddr(7 downto 0),
		rclk  => rclk,
		rclke => rsel_4,
		re    => rsel_4,
		wdata => wdata(15 downto 0),
		waddr => waddr(7 downto 0),
		wclk  => wclk,
		wclke => wsel_4,
		we    => wsel_4,
		mask  => mask_int
	);
	
	
	-- decode upper 2 write address bits for write selects
	wsel_1 <= (not waddr(9)) and (not waddr(8)) and wen;
	wsel_2 <= (not waddr(9)) and waddr(8) and wen;
	wsel_3 <= waddr(9) and (not waddr(8)) and wen;
	wsel_4 <= waddr(9) and waddr(8) and wen;
	
	
	-- decode upper 2 read address bits for rdata out select
	rsel_1 <= (not raddr(9)) and (not raddr(8)) and ren;
	rsel_2 <= (not raddr(9)) and raddr(8) and ren;
	rsel_3 <= raddr(9) and (not raddr(8)) and ren;
	rsel_4 <= raddr(9) and raddr(8) and ren;
	
	
	-- read data output mux
	rdata <= rdata1v when rsel_1 = '1' else
				rdata2v when rsel_2 = '1' else
				rdata3v when rsel_3 = '1' else
				rdata4v;
	
	
end rtl;