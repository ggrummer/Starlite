-----------------------------------------------------------------------
-- Create Date: 01/30/2020 08:46:52 AM
-- Module Name: cmod_s6_top_tb - Behavioral
-- By: Grant Grummer
-- 
-- Description: simple simulation for cmod_s6_top module.
-- 
-- Revision: 0.0
-- 
-----------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity cmod_s6_top_tb is
end cmod_s6_top_tb;


architecture Behavioral of cmod_s6_top_tb is

   COMPONENT cmod_s6_top
      PORT (
      user_clock  : in STD_LOGIC;
      user_reset  : in STD_LOGIC;
      DISP_SEL    : in STD_LOGIC;
      DISP_SEL_N  : in STD_LOGIC;
      UART_DOUT   : in STD_LOGIC;
      PWR_ON      : out std_logic;
      BUF_DIS     : out std_logic;
      GPIO_LED1   : out std_logic;
      GPIO_LED2   : out std_logic;
      GPIO_LED3   : out std_logic;
      GPIO_LED4   : out std_logic;
      PMOD1_P1    : out STD_LOGIC;
      PMOD1_P2    : out STD_LOGIC
      );
   END COMPONENT;
   
   
   signal clk8tb      : std_logic;
   signal rst         : std_logic;
	signal sel_pb      : std_logic;
   
   signal user_clock  : std_logic;
   signal user_reset  : std_logic;
   signal DISP_SEL    : std_logic;
   signal DISP_SEL_N  : std_logic;
   signal UART_DOUT   : std_logic;
   signal PWR_ON      : STD_LOGIC;
   signal BUF_DIS     : STD_LOGIC;
   signal GPIO_LED1   : STD_LOGIC;
   signal GPIO_LED2   : STD_LOGIC;
   signal GPIO_LED3   : STD_LOGIC;
   signal GPIO_LED4   : STD_LOGIC;
   signal PMOD1_P1    : STD_LOGIC;
   signal PMOD1_P2    : STD_LOGIC;
   

begin

   cmod_s6_top_0 : cmod_s6_top
      PORT MAP (
         user_clock	=> user_clock,
         user_reset	=> user_reset,
         DISP_SEL		=> DISP_SEL,
         DISP_SEL_N 	=> DISP_SEL_N,
         UART_DOUT  	=> UART_DOUT,
         PWR_ON  		=> PWR_ON,
         BUF_DIS    	=> BUF_DIS,
         GPIO_LED1	=> GPIO_LED1,
         GPIO_LED2   => GPIO_LED2,
         GPIO_LED3   => GPIO_LED3,
         GPIO_LED4	=> GPIO_LED4,
         PMOD1_P1   	=> PMOD1_P1,
         PMOD1_P2    => PMOD1_P2
      );
   
   
   user_clock	<= clk8tb;
   user_reset  <= rst;
	DISP_SEL  	<= sel_pb;
	DISP_SEL_N	<= '1';
	UART_DOUT	<= '0';
	
  
   rst     <= '1', '0' after 375 ns;
  
  
   -- 8 MHz clock
   clk8_proc : process
   begin
       loop
         clk8tb <= '0';
         wait for 62.5 ns;
         clk8tb <= '1';
         wait for 62.5 ns;
       end loop;
       wait;
   end process;
   
   
   
   cmod_s6_top_test_proc : process
   begin
      sel_pb <= '0';
		wait for 200 ms;
		wait until rising_edge(clk8tb);
		wait for 50 ns;
		sel_pb <= '1'; -- select next pattern
		wait for 5120 ns;
		sel_pb <= '0';
		wait for 200 ms;
		wait until rising_edge(clk8tb);
		wait for 50 ns;
		sel_pb <= '1'; -- select next pattern
		wait for 5120 ns;
		sel_pb <= '0';
		wait for 300 ms;
		wait until rising_edge(clk8tb);
		wait for 50 ns;
		sel_pb <= '1'; -- select last pattern
		wait for 5120 ns;
		sel_pb <= '0';
		wait for 100 ms;
      -- end test
      assert false
         report "cmod_s6_top Module Simulation Done " & cr
         severity failure;
      wait;
   end process;


end Behavioral;
