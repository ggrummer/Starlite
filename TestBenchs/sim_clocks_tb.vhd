-----------------------------------------------------------------------
-- Create Date: 03/20/2019 10:56:12 PM
-- Module Name: sim_clocks_tb - behavioral
-- By: Grant Grummer
-- 
-- Description: test bench for top level for starlites design 
-- 
-- Revision: 0.0
-- 
-----------------------------------------------------------------------


use work.lites_pkg.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.std_logic_arith.all;
-- USE ieee.std_logic_unsigned.all;


entity sim_clocks_tb is
end sim_clocks_tb;

architecture Behavioral of sim_clocks_tb is

   COMPONENT sim_clocks
      PORT (
			osc48      	: in  STD_LOGIC; -- test 48 MHz clock
			soft_reset	: in  STD_LOGIC; -- command based reset
			clkfast   	: out STD_LOGIC; -- 8 MHz clock output
			clk8      	: out STD_LOGIC; -- 800 KHz clock output 
			ce1       	: out STD_LOGIC; -- 100 KHz pulse
			reset8    	: out STD_LOGIC  -- internal logic reset
      );
   END COMPONENT;
   
   
	signal clk48tb     : std_logic;
	
   signal osc48      : std_logic;
	signal soft_reset : std_logic;
   signal clkfast    : std_logic;
	signal clk8	      : std_logic;
	signal ce1	      : std_logic;
	signal reset8     : std_logic;
   

begin

   sim_clocks_0 : sim_clocks
      PORT MAP (
         osc48			=> osc48,
			soft_reset  => soft_reset,
			clkfast		=> clkfast,
			clk8			=> clk8,
			ce1			=> ce1,
         reset8      => reset8
      );
   
   
   osc48 <= clk48tb;
	soft_reset <= '0';
	
	
	-- 48 MHz clock
   clk48_proc : process
   begin
       loop
         clk48tb <= '0';
         wait for 10.42 ns;
         clk48tb <= '1';
         wait for 10.42 ns;
       end loop;
       wait;
   end process;
	
	
   sim_clocks_test_proc : process 
   begin
		
      wait for 90 ms; -- wait for init to complete
      
      wait for 100 ms;
      assert false
         report "Sim Clocks Simulation Done " & cr
         severity failure;
      wait;
   end process;


end Behavioral;
