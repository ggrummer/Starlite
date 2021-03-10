----------------------------------------------------------------------
-- Create Date: 04/12/2020 08:58:46 PM
-- Module Name: star8_clocks - rtl
--
-- Description: use an external 8 MHz clock to make an internal 
--		8 MHz clock, an 800 kHz clock, 100 kHz clock enable and a reset
-- 
-- Revision:0.0
-- 
----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity star8_clocks is
   Port ( 
      soft_reset	: in STD_LOGIC;  -- command based reset
		pll_16		: in STD_LOGIC;  -- 16.00 MHz clock input
      clkfast   	: out STD_LOGIC; -- 8.00 MHz clock output
      clk8      	: out STD_LOGIC; -- 800 KHz clock output 
      ce1       	: out STD_LOGIC; -- 100 KHz pulse
      reset8    	: out STD_LOGIC  -- internal logic reset
   );
end star8_clocks;


architecture rtl of star8_clocks is

	
	constant RSTCNT	: std_logic_vector (3 DOWNTO 0) := x"d"; -- count to 13
	constant CNT8     : integer range 0 to 7 := 4;  -- used to count to 5
	
   signal clk8M      : std_logic;
	signal clk8int    : std_logic;
   signal clkcnt     : std_logic_vector (4 DOWNTO 0) := "00000";
	signal ce1cnt     : std_logic_vector (2 DOWNTO 0) := "000";
   signal resetint   : std_logic := '1';
   signal resetcnt   : std_logic_vector (3 DOWNTO 0) := x"0";
   signal reset8cnt  : std_logic_vector (3 DOWNTO 0) := x"0";
    
    
begin

	
   clkfast <= clk8M;
	clk8    <= clk8int;
   
	
	-- make an 8 MHz clock
	clk8M_proc : process (pll_16)
	begin
		if rising_edge(pll_16) then
			clk8M <= not clk8M;
		end if;
	end process;
	
	
	-- start up reset for 8 MHz logic
    reset_proc : process (clk8M)
    begin
        if rising_edge(clk8M) then
            if (resetcnt = RSTCNT) then
                resetint <= '0';
            else
                resetcnt <= resetcnt + '1';
                resetint <= '1';
            end if;
        end if;
    end process;
   
   
   -- make an 800 kHz clock
   clk8_proc : process (resetint, clk8int)
   begin
      if rising_edge(clk8int) then
			if (resetint = '1') then
				clkcnt  <= "00000";
				clk8int <= '0';
			else
				clkcnt <= clkcnt + 1;
				if clkcnt = CONV_STD_LOGIC_VECTOR(CNT8, 4) then
					clk8int <= not clk8int;
					clkcnt  <= "00000";
				end if;
			end if;
      end if;
   end process;
	
	
	-- make a 100 kHz clock enable pulse
	clock_enable_proc : process (resetint, clk8int)
	begin
		if rising_edge(clk8int) then
			if (resetint = '1') then
				ce1cnt <= "000";
				ce1    <= '0';
			else
				ce1cnt <= ce1cnt + '1';
				if ce1cnt = "111" then
						 ce1 <= '1';
					else
						 ce1 <= '0';
					end if;
			end if;
		end if;
    end process;
            

   -- make a reset to go with the 800 kHz clock
   reset8_proc : process (clk8int)
   begin
      if rising_edge(clk8int) then
			if (resetint = '1') then
				reset8cnt <= "0000";
				reset8    <= '1';
			else
				if soft_reset = '1' then
					reset8cnt <= "0000";
					reset8    <= '1';
				elsif (reset8cnt = RSTCNT) then
					reset8    <= '0'; -- stay here until the next reset
				else
					reset8    <= '1';
					reset8cnt <= reset8cnt + '1';
				end if;
			end if;
		end if;
    end process;


end rtl;
