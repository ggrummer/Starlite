----------------------------------------------------------------------
-- Create Date: 07/17/2020
-- Module Name: star8_clocks - rtl
--
-- Description: use the internal 16 MHz clock from the PLL to make 
--		an internal 8 MHz clock, 800 kHz clock, 100 kHz clock enable,
--		and a reset
-- 
-- Revision:0.0
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
--library work;
--use work.components.all;


entity star8_clocks is
   Port ( 
      soft_reset	: in STD_LOGIC;  -- command based reset
		pll_16		: in STD_LOGIC;  -- 16 MHz input from PLL
		lock			: in STD_LOGIC;  -- PLL lock signal
      clkfast   	: out STD_LOGIC; -- 8 MHz clock output
      clk8      	: out STD_LOGIC; -- 800 KHz clock output 
      ce1       	: out STD_LOGIC; -- 100 KHz pulse
      reset8    	: out STD_LOGIC  -- internal logic reset
   );
end star8_clocks;


architecture rtl of star8_clocks is
	
	
	component SB_GB
		port(
			USER_SIGNAL_TO_GLOBAL_BUFFER : in std_logic;
			GLOBAL_BUFFER_OUTPUT : out std_logic
		);
	end component;
	
	
	constant RSTCNT	: std_logic_vector (3 DOWNTO 0) := x"d"; -- count to 13
	constant CNT8     : integer range 0 to 7 := 4;  -- used to count to 5
	
   signal clk8M		: std_logic := '0';
	signal clkfastint	: std_logic := '0';
	signal clk8int   	: std_logic;
   signal clkcnt    	: std_logic_vector (4 DOWNTO 0) := "00000";
	signal ce1cnt    	: std_logic_vector (2 DOWNTO 0) := "000";
   signal resetint  	: std_logic := '1';
	signal reset8int  : std_logic := '1';
   signal resetcnt  	: std_logic_vector (3 DOWNTO 0) := x"0";
   signal reset8cnt 	: std_logic_vector (3 DOWNTO 0) := x"0";
    
    
begin
	
	
	clkfast_gbuf_inst: SB_GB
	port map 
		(
			USER_SIGNAL_TO_GLOBAL_BUFFER => clk8M,
			GLOBAL_BUFFER_OUTPUT => clkfastint
		);
	
	
	clk8_gbuf_inst: SB_GB
	port map 
		(
			USER_SIGNAL_TO_GLOBAL_BUFFER => clk8int,
			GLOBAL_BUFFER_OUTPUT => clk8
		);
	
	
	reset_gbuf_inst: SB_GB
	port map 
		(
			USER_SIGNAL_TO_GLOBAL_BUFFER => reset8int,
			GLOBAL_BUFFER_OUTPUT => reset8
		);
	
	
	clkfast <= clkfastint;
   
	
	-- make an 8 MHz clock
	clk8M_proc : process (pll_16)
	begin
		if (lock = '0') then
			clk8M <= '0';
		elsif rising_edge(pll_16) then
			clk8M <= not clk8M;
		end if;
	end process;
	
	
	-- start up reset for 8 MHz logic
   reset_proc : process (clkfastint)
   begin
      if (lock = '0') then
			resetint <= '1';
			resetcnt <= (others => '0');
		elsif rising_edge(clkfastint) then
         if (resetcnt = RSTCNT) then
            resetint <= '0';
         else
            resetcnt <= resetcnt + '1';
            resetint <= '1';
         end if;
      end if;
   end process;
   
   
   -- make an 800 kHz clock
   clk8_proc : process (resetint, clkfastint)
   begin
      if rising_edge(clkfastint) then
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
				reset8int <= '1';
			else
				if soft_reset = '1' then
					reset8cnt <= "0000";
					reset8int <= '1';
				elsif (reset8cnt = RSTCNT) then
					reset8int <= '0'; -- stay here until the next reset
				else
					reset8int <= '1';
					reset8cnt <= reset8cnt + '1';
				end if;
			end if;
		end if;
    end process;


end rtl;
