----------------------------------------------------------------------------------
-- Create Date: 03/13/2019 08:46:52 AM
-- Module Name: star_neo_main_tb - Behavioral
-- By: Grant Grummer
-- 
-- Description: simulation for star_neo_main module
-- 
-- Revision: 0.0
-- 
----------------------------------------------------------------------------------


use work.lites_pkg.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity star_neo_main_tb is
end star_neo_main_tb;


architecture Behavioral of star_neo_main_tb is

   COMPONENT star_neo_main
      PORT (
         clk8        	: in STD_LOGIC;
         clkfast     	: in STD_LOGIC;
         reset8      	: in STD_LOGIC;
         ce1         	: in STD_LOGIC;
         frame_start 	: in STD_LOGIC;
         frame_data  	: in STD_LOGIC_VECTOR (25 downto 0);
			point_offset	: in STD_LOGIC;
			point_block 	: in STD_LOGIC_VECTOR (11 downto 0);
			buf_en			: out STD_LOGIC;
         neo_busy    	: out STD_LOGIC;
         tx_data     	: out STD_LOGIC_VECTOR (0 to NUM_OF_POINTS-1)
		);
   END COMPONENT;
   
   
   signal clk8tb      : std_logic;
   signal clkfasttb   : std_logic;
   signal rst         : std_logic;
   signal ce1cnt      : STD_LOGIC_VECTOR (2 downto 0);
   
   signal clk8        : std_logic;
   signal clkfast     : std_logic;
   signal reset8      : std_logic;
   signal ce1         : std_logic;
   signal frame_start : std_logic;
   signal frame_data  : std_logic_VECTOR (25 downto 0);
   signal point_offset : std_logic;
	signal point_block : std_logic_VECTOR (11 downto 0);
	signal buf_en		 : std_logic;
   signal neo_busy    : std_logic;
   signal tx_data     : std_logic_VECTOR (0 to NUM_OF_POINTS-1);
   

begin

   star_neo_main_0 : star_neo_main
      PORT MAP (
         clk8        	=> clk8,
         clkfast     	=> clkfast,
         reset8      	=> reset8,
         ce1         	=> ce1,
         frame_start 	=> frame_start,
         frame_data  	=> frame_data,
			point_offset	=> point_offset,
			point_block		=> point_block,
			buf_en			=> buf_en,
         neo_busy    	=> neo_busy,
         tx_data     	=> tx_data
      );
   
   
   clk8    <= clk8tb;
   clkfast <= clkfasttb;
   reset8  <= rst;
  
   rst     <= '1', '0' after 3610 ns;
  
  
   -- 831 KHz clock
   clk8_proc : process
   begin
       loop
         clk8tb <= '0';
         wait for 600 ns;
         clk8tb <= '1';
         wait for 600 ns;
       end loop;
       wait;
   end process;
  
  
   -- 8.31 MHz clock
   clkfast_proc : process
   begin
       loop
         clkfasttb <= '0';
         wait for 60 ns;
         clkfasttb <= '1';
         wait for 60 ns;
       end loop;
       wait;
   end process;
   
   
   -- make a 104 kHz clock enable pulse
	clock_enable_proc : process (rst, clk8tb)
	begin
		if rst = '1' then
			ce1    <= '0';
			ce1cnt <= "000";
		elsif rising_edge(clk8tb) then
			ce1cnt <= ce1cnt + '1';
			if ce1cnt = "111" then
                ce1 <= '1';
            else
                ce1 <= '0';
            end if;
		end if;
    end process;
  
 
   neo_lites_test_proc : process
   begin
      frame_start  <= '0';
      frame_data   <= "00" & x"000000";
      point_offset <= '0';
		point_block	 <= x"000";
      wait for 6 us;
      wait until rising_edge(clk8tb);
      wait for 2 ns;
			wait for 10 us;
			
			-- send set lites command to lite 0
			frame_start <= '1';
			frame_data  <= "00" & x"0C0F0F";
			wait for 5 us;
			frame_start <= '0';
			frame_data  <= "00" & x"000000";
			wait for 25 us;
			assert (neo_busy = '1')
				report "neo_busy didn't assert " & cr
				severity error;
			wait for 600 us;
			assert (neo_busy = '0')
				report "neo_busy didn't deassert " & cr
				severity error;
				
			-- send set lites command to lite 3
			frame_start <= '1';
			frame_data  <= "00" & x"3C02AF";
			wait for 5 us;
			frame_start <= '0';
			frame_data  <= "00" & x"000000";
			wait for 25 us;
			assert (neo_busy = '1')
				report "neo_busy didn't assert " & cr
				severity error;
			wait for 600 us;
			assert (neo_busy = '0')
				report "neo_busy didn't deassert " & cr
				severity error;
			wait for 100 us;
			point_offset <= '1'; 
			wait for 10 us;
			
			-- send set lites command to lite 0
			frame_start <= '1';
			frame_data  <= "00" & x"0C0F0F";
			wait for 5 us;
			frame_start <= '0';
			frame_data  <= "00" & x"000000";
			wait for 25 us;
			assert (neo_busy = '1')
				report "neo_busy didn't assert " & cr
				severity error;
			wait for 600 us;
			assert (neo_busy = '0')
				report "neo_busy didn't deassert " & cr
				severity error;
				
			-- send set lites command to lite 3
			frame_start <= '1';
			frame_data  <= "00" & x"3C02AF";
			wait for 5 us;
			frame_start <= '0';
			frame_data  <= "00" & x"000000";
			wait for 25 us;
			assert (neo_busy = '1')
				report "neo_busy didn't assert " & cr
				severity error;
			wait for 600 us;
			assert (neo_busy = '0')
				report "neo_busy didn't deassert " & cr
				severity error;
			
				
			-- block lites 7, 5 & 2 from changing and send set lites
			-- command to lite 3
			point_offset <= '0'; 
			point_block  <= x"0A4"; 
			wait for 10 us;
			frame_start <= '1';
			frame_data  <= "00" & x"3C0FF0";
			wait for 5 us;
			frame_start <= '0';
			frame_data  <= "00" & x"000000";
			wait for 25 us;
			assert (neo_busy = '1')
				report "neo_busy didn't assert " & cr
				severity error;
			wait for 600 us;
			assert (neo_busy = '0')
				report "neo_busy didn't deassert " & cr
				severity error;
			wait for 100 us;
		-- end test
      assert false
         report "Star Neo Lites Simulation Done " & cr
         severity failure;
      wait;
   end process;


end Behavioral;
