----------------------------------------------------------------------------------
-- Create Date: 04/11/2020 
-- Module Name: dp_ram256x16 - rtl
-- By: Grant Grummer
-- 
-- Description: dual port 256 x 16 RAM
-- 
-- Revision: 0.0
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity dp_ram256x16 is
	generic (
		addr_width : natural := 8; --256 x 16
		data_width : natural := 16
	);
	port (
		wen 	: in std_logic;
		waddr : in std_logic_vector (addr_width - 1 downto 0);
		wclk 	: in std_logic;
		wdata : in std_logic_vector (data_width - 1 downto 0);
		ren	: in std_logic;
		raddr : in std_logic_vector (addr_width - 1 downto 0);
		rclk 	: in std_logic;
		rdata : out std_logic_vector (data_width - 1 downto 0)
	);
end dp_ram256x16;
	
library synplify;
	
architecture rtl of dp_ram256x16 is

	type mem_type is array ((2** addr_width) - 1 downto 0) of
	std_logic_vector(data_width - 1 downto 0);
	
	signal mem : mem_type;
	
	attribute syn_ramstyle : string; 
	attribute syn_ramstyle of mem : signal is "block_ram";

	
begin


	write_proc : process (wclk) -- Write memory.
	begin
		if (wclk'event and wclk = '1') then
			if (wen = '1') then
				mem(conv_integer(waddr)) <= wdata;
				-- Using write address bus.
			end if;
		end if;
	end process;
		
		
	read_proc : process (rclk) -- Read memory.
	begin
		if (rclk'event and rclk = '1') then
			if (ren = '1') then
				rdata <= mem(conv_integer(raddr));
				-- Using read address bus.
			end if;
		end if;
	end process;
	
	
end rtl;