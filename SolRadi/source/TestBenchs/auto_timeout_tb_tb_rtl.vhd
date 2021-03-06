--
-- VHDL Test Bench lites_lib.auto_timeout_tb.auto_timeout_tester
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


ENTITY auto_timeout_tb IS
END auto_timeout_tb;


--LIBRARY lites_lib;
--USE lites_lib.ALL;


ARCHITECTURE rtl OF auto_timeout_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL clk8         : STD_LOGIC;
   SIGNAL reset8       : STD_LOGIC;
   SIGNAL cmd_inst     : STD_LOGIC_VECTOR(3 downto 0);
   SIGNAL cmd_data     : STD_LOGIC_VECTOR(27 downto 0);
   SIGNAL blackout     : STD_LOGIC;
   SIGNAL reload       : STD_LOGIC;
   SIGNAL timeout_done : STD_LOGIC;


   -- Component declarations
   COMPONENT auto_timeout
      PORT (
         clk8         : IN     STD_LOGIC;
         reset8       : IN     STD_LOGIC;
         cmd_inst     : IN     STD_LOGIC_VECTOR(3 downto 0);
         cmd_data     : IN     STD_LOGIC_VECTOR(27 downto 0);
         blackout     : OUT    STD_LOGIC;
         reload       : OUT    STD_LOGIC;
         timeout_done : OUT    STD_LOGIC
      );
   END COMPONENT;

   COMPONENT auto_timeout_tester
      PORT (
         clk8         : OUT    STD_LOGIC;
         reset8       : OUT    STD_LOGIC;
         cmd_inst     : OUT    STD_LOGIC_VECTOR(3 downto 0);
         cmd_data     : OUT    STD_LOGIC_VECTOR(27 downto 0);
         blackout     : IN     STD_LOGIC;
         reload       : IN     STD_LOGIC;
         timeout_done : IN     STD_LOGIC
      );
   END COMPONENT;

BEGIN

         TIMEOUT_0 : auto_timeout
            PORT MAP (
               clk8         => clk8,
               reset8       => reset8,
               cmd_inst     => cmd_inst,
               cmd_data     => cmd_data,
               blackout     => blackout,
               reload       => reload,
               timeout_done => timeout_done
            );

         TEST_1 : auto_timeout_tester
            PORT MAP (
               clk8         => clk8,
               reset8       => reset8,
               cmd_inst     => cmd_inst,
               cmd_data     => cmd_data,
               blackout     => blackout,
               reload       => reload,
               timeout_done => timeout_done
            );


END rtl;