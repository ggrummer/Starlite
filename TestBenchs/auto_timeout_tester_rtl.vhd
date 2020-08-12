--
-- VHDL Test Bench lites_lib.auto_timeout_tester.auto_timeout_tester
--
-- Created:
--          by - Grant.Grummer.UNKNOWN (AED-GRUMMER3)
--          at - 16:34:36 04/ 2/2014
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2011.1 (Build 18)
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;


ENTITY auto_timeout_tester IS
   PORT (
      clk8         : OUT    STD_LOGIC;
      reset8       : OUT    STD_LOGIC;
      cmd_inst     : OUT    STD_LOGIC_VECTOR(3 downto 0);
      cmd_data     : OUT    STD_LOGIC_VECTOR(27 downto 0);
      blackout     : IN     STD_LOGIC;
      reload       : IN     STD_LOGIC;
      timeout_done : IN     STD_LOGIC
   );
END auto_timeout_tester;


--LIBRARY lites_lib;

ARCHITECTURE rtl OF auto_timeout_tester IS
   
   signal clktb     : std_logic;
   signal rst       : std_logic;
   
   
BEGIN
   
   
   clk8   <= clktb;
   reset8 <= rst;
  
   rst    <= '1', '0' after 72 ns;
  
  
   clk_proc : process
   begin
     loop
       clktb <= '1';
       wait for 8 ns;
       clktb <= '0';
       wait for 8 ns;
     end loop;
     wait;
   end process;
   
   
   data_proc : process
   begin
      cmd_inst <= (others => '1');
      cmd_data <= (others => '0');
      wait for 24 us;
      
      -- on for 2, off for 5 tc, repeat
      cmd_inst <= x"D";
      cmd_data <= x"0205000"; 
      wait for 32 ns;
      
      cmd_inst <= (others => '1');
      cmd_data <= (others => '0');
      --wait for 210 us; -- using tc1 for simulation
      wait for 28 ms; -- using tc2 for simulation
      
      -- always on command
      cmd_inst <= x"D";
      cmd_data <= x"0000000"; 
      wait for 32 ns;
      
      cmd_inst <= (others => '1');
      cmd_data <= (others => '0');
      --wait for 40 us; -- using tc1 for simulation
      wait for 10 ms; -- using tc2 for simulation
      
      -- at 38 ms
      -- on for 3 tc then off and stay off
      cmd_inst <= x"D";
      cmd_data <= x"0300000"; 
      wait for 32 ns;
      
      cmd_inst <= (others => '1');
      cmd_data <= (others => '0');
      --wait for 50 us; -- using tc1 for simulation
      wait for 13 ms; -- using tc2 for simulation
      
      -- at 51 ms
      -- delay for 2, on for 2, off for 5 tc, repeat on & off
      cmd_inst <= x"D";
      cmd_data <= x"0204002"; 
      wait for 32 ns;
      
      cmd_inst <= (others => '1');
      cmd_data <= (others => '0');
      --wait for 110 us; -- using tc1 for simulation
      wait for 15 ms; -- using tc2 for simulation
      
      -- at 66 ms
      -- delay for 1, on for 1, off for 1 tc, repeat on & off
      cmd_inst <= x"D";
      cmd_data <= x"0101001"; 
      wait for 32 ns;
      
      cmd_inst <= (others => '1');
      cmd_data <= (others => '0');
      --wait for 110 us; -- using tc1 for simulation
      wait for 10 ms; -- using tc2 for simulation
      
      -- at 76 ms
      -- delay for 1, on for 1, off for 1 tc, repeat on & off
      cmd_inst <= x"2";
      cmd_data <= x"0000000"; 
      wait for 32 ns;
      
      cmd_inst <= (others => '1');
      cmd_data <= (others => '0');
      --wait for 110 us; -- using tc1 for simulation
      wait for 4 ms; -- using tc2 for simulation
      
      wait for 1 us;
        assert false
          report "Auto Timeout Simulation Done " & cr
          severity failure;
        wait;
     end process;
   
   
END rtl;
