----------------------------------------------------------------------
-- Create Date: 04/06/2013 10:12:49 PM
-- Module Name: starpoint - rtl
-- By: Grant Grummer
-- 
-- Description: changes an address offset of each command by 1 if 
--    enabled. Individual points can be blocked.
-- 
-- Revision 0.1 - File Created
-- Revision 0.2 - Added ability block individual points from changing
-- 
----------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
-- USE ieee.std_logic_unsigned.all;


entity starpoint is
    Port ( clk8        		: in STD_LOGIC;
           reset8      		: in STD_LOGIC;
           cmd_inst    		: in STD_LOGIC_VECTOR (3 downto 0);
           cmd_data    		: in STD_LOGIC_VECTOR (27 downto 0);
           point_offset		: out STD_LOGIC;
			  point_block		: out STD_LOGIC_VECTOR (11 downto 0);
           starpoint_done  : out STD_LOGIC);
end starpoint;


architecture rtl of starpoint is

   
   type spsm_type is (INIT,START,DONE);
   
   signal spsm    	: spsm_type;
	signal sp_offset  : STD_LOGIC;
	signal sp_block   : STD_LOGIC_VECTOR (11 downto 0);


begin
   
   
   starpoint_proc : process (reset8, clk8)
   begin
      if rising_edge(clk8) then
			if (reset8 = '1') then
				starpoint_done	<= '0'; 
				point_offset	<= '0';
				sp_offset   	<= '0';
				point_block		<= x"000";
				sp_block	   	<= x"000";
				spsm    			<= INIT;
			else
				case spsm is
				when INIT =>
					starpoint_done <= '0';
					sp_offset	 	<= cmd_data(12);
					sp_block		 	<= cmd_data(11 downto 0);
					if (cmd_inst = x"A") then
						spsm <= START;
					end if;
				when START =>
					point_offset <= sp_offset;
					point_block  <= sp_block;
					spsm <= DONE;
				when DONE => 
					starpoint_done <= '1';
					spsm <= INIT;
				when others => 
					spsm <= INIT;
				end case;
			end if;
		end if;
   end process;
   
   
end rtl;