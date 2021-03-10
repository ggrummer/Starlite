-----------------------------------------------------------------------
-- Create Date: 03/11/2019 08:46:52 AM
-- Module Name: sub_framer - rtl
-- By: Grant Grummer
-- 
-- Description: bit level protocol for neopixel lites. Supports 
--				WS2812 & WS2812B & SK6812 tri-color lites
-- 
-- Revision: 0.0
-- Revision: 0.1 increased inter frame gap to 80 usec to support SK6812
-- 
-----------------------------------------------------------------------


use work.lites_pkg.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity sub_framer is
   Port ( 
      clkfast     : in STD_LOGIC;
		reset8      : in STD_LOGIC;
		ce1         : in STD_LOGIC;
		fm_valid    : in STD_LOGIC;
		interframe  : in STD_LOGIC;
		fm_data     : in STD_LOGIC_VECTOR (23 downto 0);
		pixel_sent  : out STD_LOGIC;
		frame_sent  : out STD_LOGIC;
		tx_data     : out STD_LOGIC
   );
end sub_framer;


architecture rtl of sub_framer is
   
   constant HI0_X812  : std_logic_vector (3 DOWNTO 0) := "0001"; -- 375 ns 
   constant LO0_X812  : std_logic_vector (3 DOWNTO 0) := "0101"; -- 875 ns
	
   constant LO1_2812B : std_logic_vector (3 DOWNTO 0) := "0010"; -- 500 ns 
	constant LO1_6812  : std_logic_vector (3 DOWNTO 0) := "0011"; -- 625 ns 
	
	constant HI1_2812B : std_logic_vector (3 DOWNTO 0) := "0100"; -- 750 ns
	constant HI1_6812  : std_logic_vector (3 DOWNTO 0) := "0011"; -- 625 ns
   
   signal HI0CNT      : std_logic_vector (3 DOWNTO 0);
   signal LO0CNT      : std_logic_vector (3 DOWNTO 0);
   signal HI1CNT      : std_logic_vector (3 DOWNTO 0);
   signal LO1CNT      : std_logic_vector (3 DOWNTO 0);
   
   type par2sersm_type is (INIT,GO,LOAD,DEC,DONE);
   type bitsm_type     is (INIT,START,DEC_HI,DEC_LO);
   type intersm_type   is (INIT,INC,HI5,LO5,DONE);
   
   signal par2sersm   : par2sersm_type;
   signal bitsm       : bitsm_type;
   signal intersm     : intersm_type;
   
	signal ce1_sync1   : STD_LOGIC;
   signal ce1_sync2   : STD_LOGIC;
   signal dbit        : INTEGER range 0 to 23;
   signal dataword    : STD_LOGIC_VECTOR (23 downto 0);
   signal databit     : STD_LOGIC;
   signal gobit       : STD_LOGIC;
   signal cnthi       : STD_LOGIC_VECTOR (3 DOWNTO 0);
   signal cntlo       : STD_LOGIC_VECTOR (3 DOWNTO 0);
   signal nextbit     : STD_LOGIC;
   signal ten_us      : STD_LOGIC_VECTOR (3 downto 0);
   
   
begin
   
   
   -- set LED starlite prococol
   HI0CNT <= HI0_X812;
   LO0CNT <= LO0_X812;
   HI1CNT <= HI1_6812 when TYPE_OF_LITE = 3 else HI1_2812B;
   LO1CNT <= LO1_6812 when TYPE_OF_LITE = 3 else LO1_2812B;
	
	
	-- sync ce1 control input to 8.31 MHz clock
   go_proc : process (reset8, clkfast)
   begin
      if rising_edge(clkfast) then
			if (reset8 = '1') then
				ce1_sync1 <= '0';
				ce1_sync2 <= '0';
			else
				ce1_sync1 <= ce1;
				ce1_sync2 <= ce1_sync1;
			end if;
		end if;
   end process;
   
   
   -- parellel to serial data converter
   par2ser_proc : process (reset8, clkfast)
   begin
      if rising_edge(clkfast) then
			if reset8 = '1' then
				dataword   <= x"000000";
				databit    <= '0';         
				dbit       <= 23;
				gobit      <= '0';
				pixel_sent <= '0';
				par2sersm  <= INIT;
			else
				case par2sersm is
				when INIT =>
					dbit       <= 23; 
					gobit      <= '0';
					pixel_sent <= '0';
					if (fm_valid = '1') then
						par2sersm <= GO;
					end if;
				when GO =>
					dataword  <= fm_data; 
					gobit     <= '1';
					par2sersm <= LOAD;
				when LOAD =>
					databit    <= dataword(dbit); 
					pixel_sent <= '0';
					if (nextbit = '1') then
						par2sersm <= DEC;
					end if;
				when DEC => 
					if (dbit = 1) then
						dbit       <= dbit - 1;
						pixel_sent <= '1';
						par2sersm  <= GO; -- loop through data bit 1
					elsif (dbit = 0) then
						par2sersm  <= DONE; -- exit loop
					else
						dbit       <= dbit - 1;
						par2sersm  <= GO; -- loop through all other data bits
					end if;
				when DONE => 
					gobit      <= '0';
					par2sersm  <= INIT;
				when others => 
					par2sersm <= INIT;
				end case;
			end if;
		end if;
   end process;
   
   
   -- format a bit into proper waveform
   bit_proc : process (reset8, clkfast)
   begin
      if rising_edge(clkfast) then
			if reset8 = '1' then
				tx_data <= '0';
				nextbit <= '0';
				cnthi   <= "0000";
				cntlo   <= "0000";
				bitsm   <= INIT;
			else
				case bitsm is
				when INIT =>
					if (gobit = '1') then
						bitsm <= START;
					end if;
				when START =>
					tx_data   <= '1';
					nextbit   <= '1';
					bitsm     <= DEC_HI;
					if (databit = '0') then
						cnthi <= hi0cnt;
						cntlo <= lo0cnt;
					else
						cnthi <= hi1cnt;
						cntlo <= lo1cnt;
					end if;
				when DEC_HI =>
					nextbit <= '0';
					if (cnthi /= 0) then -- loop in state until cnthi = 0
						cnthi <= cnthi - '1'; 
					else
						bitsm <= DEC_LO;
					end if;
				when DEC_LO =>
					tx_data <= '0';
					if (cntlo /= 0) then -- loop in state until cntlo = 0
						cntlo <= cntlo - '1'; 
					else
						bitsm <= INIT;
					end if;
				when others => 
					bitsm <= INIT;
				end case;
			end if;
		end if;
   end process;
   
   
   -- create inter frame gap of greater than 80 us
   inter_proc : process (reset8, clkfast)
   begin
      if rising_edge(clkfast) then
			if reset8 = '1' then
				ten_us     <= x"0"; 
				frame_sent <= '0';
				intersm    <= INIT;
			else
				case intersm is
				when INIT =>
					ten_us     <= x"0"; 
					frame_sent <= '0';
					if (interframe = '1') then
						intersm <= HI5;
					end if;
				when HI5 =>
					if (ce1_sync2 = '1') then
						intersm <= LO5;
					end if;
				when LO5 =>
					if (ce1_sync2 = '0') then
						intersm <= INC;
					end if;
				when INC =>
					ten_us <= ten_us + '1'; 
					if (ten_us = x"8") then
						intersm <= DONE;
					else
						intersm <= HI5;
					end if;
				when DONE => 
					frame_sent <= '1'; 
					intersm    <= INIT;
				when others => 
					intersm <= INIT;
				end case;
			end if;
		end if;
   end process;
   
   
end rtl;
   