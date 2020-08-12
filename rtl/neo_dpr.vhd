----------------------------------------------------------------------------------
-- Create Date: 04/11/2020 
-- Module Name: neo_dpr - rtl
-- By: Grant Grummer
-- 
-- Description: 256 x 24 dual port RAM using two 256 x 16 RAMs 
-- 
-- Revision: 0.0
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity neo_dpr is
   Port (
		rclk  : IN  STD_LOGIC;
		ren   : IN  STD_LOGIC;
		raddr : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		rdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		wclk  : IN  STD_LOGIC;
		wen   : IN  STD_LOGIC;
		waddr : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		wdata : IN  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
end neo_dpr;


architecture rtl of neo_dpr is

	
	component dp_ram256x16
		port (
			wen 	: in std_logic;
			waddr : in std_logic_vector (7 downto 0);
			wclk 	: in std_logic;
			wdata : in std_logic_vector (15 downto 0);
			ren	: in std_logic;
			raddr : in std_logic_vector (7 downto 0);
			rclk 	: in std_logic;
			rdata : out std_logic_vector (15 downto 0)
		);
	end component;
	
	
	signal rdata_up     : std_logic_vector (15 downto 0);
	signal rdata_lo     : std_logic_vector (15 downto 0);
	signal wdata_up     : std_logic_vector (15 downto 0);
	signal wdata_lo     : std_logic_vector (15 downto 0);
	
	
begin
	
	
	rdata 	<= rdata_up(7 downto 0) & rdata_lo;
	
	wdata_up <= x"00" & wdata(23 downto 16);
	wdata_lo <= wdata(15 downto 0);
	
	
	up_neo_ram256x16_inst : dp_ram256x16
	port map (
		rdata => rdata_up,
		raddr => raddr,
		rclk  => rclk,
		ren   => ren,
		waddr => waddr,
		wclk  => wclk,
		wdata => wdata_up,
		wen   => wen
	);
	
	lo_neo_ram256x16_inst : dp_ram256x16
	port map (
		rdata => rdata_lo,
		raddr => raddr,
		rclk  => rclk,
		ren   => ren,
		waddr => waddr,
		wclk  => wclk,
		wdata => wdata_lo,
		wen   => wen
	);
	
	
end rtl;