-----------------------------------------------------------------------
-- Create Date: 03/20/2019 10:56:12 PM
-- Module Name: star_top_simple_tb - behavioral
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


entity star_top_simple_tb is
end star_top_simple_tb;

architecture Behavioral of star_top_simple_tb is

   COMPONENT star_top
      PORT (
			disp_sel_n  : in  STD_LOGIC;
			buf_en		: out STD_LOGIC;
			tx_data     : out STD_LOGIC_VECTOR (0 to NUM_OF_POINTS-1)
      );
   END COMPONENT;
   
	
	signal disp_sel_n : std_logic;
   signal buf_en     : std_logic;
   signal tx_data    : STD_LOGIC_VECTOR (0 to NUM_OF_POINTS-1);
   

begin

   star_top_0 : star_top
      PORT MAP (
			disp_sel_n  => disp_sel_n,
			buf_en		=> buf_en,
         tx_data     => tx_data
      );
	
	
   starlites_test_proc : process 
   begin
      disp_sel_n  <= '1';
      wait for 90 ms; -- wait for init to complete
      
      wait for 100 ms;
      assert false
         report "Star LED Lites Simple Simulation Done " & cr
         severity failure;
      wait;
   end process;


end Behavioral;
