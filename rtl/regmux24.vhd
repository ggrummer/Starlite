----------------------------------------------------------------------
-- Create Date: 04/13/2020
-- Module Name: regmux24 - rtl
-- By: Grant Grummer
-- 
-- Description: 24-bit registered 2 to 1 muxes with load on one input
-- 
-- Revision: 0.0
-- 
----------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.std_logic_arith.all;


entity regmux24 is
   Port ( 
      clkfast     : in  STD_LOGIC;
      reset8      : in  STD_LOGIC;
      sel 			: in  STD_LOGIC;
		load			: in  STD_LOGIC;
		datain0     : in  STD_LOGIC_VECTOR (23 downto 0);
		datain1     : in  STD_LOGIC_VECTOR (23 downto 0);
		dataout     : out STD_LOGIC_VECTOR (23 downto 0)
   );
end regmux24;


architecture rtl of regmux24 is
	
   
begin
   
	
	-- 24-bit registered mux with a load
   data_proc : process (reset8, clkfast)
   begin
		if rising_edge(clkfast) then
			if (reset8 = '1') then
				dataout <= (others => '0');
			elsif (sel = '0') then
				dataout <= datain0;
			elsif (sel = '1' and load = '1') then
				dataout <= datain1;
			end if;
		end if;
	end process;
	 
   
end rtl;
   