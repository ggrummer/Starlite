---------------------------------------------------------------------
-- Create Date: 04/13/2020
-- Module Name: framer_main - rtl
-- By: Grant Grummer
-- 
-- Description: top level of framer. 
-- 
-- Revision: 0.0
-- Revision: 0.1 added double sided lites support
-- Revision: 0.2 for 24-bit module data input
-- Revision: 0.3 added individual point blocking
-- 
---------------------------------------------------------------------


use work.lites_pkg.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity framer_main is
   Port ( 
      clkfast      : in  STD_LOGIC;
      reset8       : in  STD_LOGIC;
		ce1          : in  STD_LOGIC;
      point_offset : in  STD_LOGIC;
		point_block	 : in  STD_LOGIC_VECTOR (11 downto 0);
      dp_addr      : out STD_LOGIC_VECTOR (7 downto 0);
      dp_rd_en     : out STD_LOGIC;
		dp_data      : in  STD_LOGIC_VECTOR (23 downto 0);
      fm_go        : in  STD_LOGIC;
      fm_busy      : out STD_LOGIC;
		tx_data      : out STD_LOGIC_VECTOR (0 to NUM_OF_POINTS-1)
   );
end framer_main;


architecture rtl of framer_main is
	
	COMPONENT sub_framer
      PORT (
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
   END COMPONENT;
	
	COMPONENT regmux24
		PORT (
			clkfast     : in  STD_LOGIC;
			reset8      : in  STD_LOGIC;
			sel 			: in  STD_LOGIC;
			load			: in  STD_LOGIC;
			datain0     : in  STD_LOGIC_VECTOR (23 downto 0);
			datain1     : in  STD_LOGIC_VECTOR (23 downto 0);
			dataout     : out STD_LOGIC_VECTOR (23 downto 0)
		);
	END COMPONENT;
	
   
   subtype slv24  	is std_logic_vector(23 DOWNTO 0);
	
	type points24  	is array (0 to NUM_OF_POINTS - 1) of slv24;
	type ctrlsm_type  is (INIT,START,VAL1,VAL0,INC,INTER,SENT,DONE);
   
   signal fm_data		: points24;
	signal ctrlsm     : ctrlsm_type;
   
   signal go1        : STD_LOGIC;
   signal go2        : STD_LOGIC;
   signal addr       : STD_LOGIC_VECTOR (7 downto 0);
	
	signal fm_valid   : STD_LOGIC;
	signal fm_val_vec : STD_LOGIC_VECTOR (0 to NUM_OF_POINTS - 1);
   signal interframe : STD_LOGIC;
	signal pixel_sent : STD_LOGIC_VECTOR (0 to NUM_OF_POINTS - 1);
	signal frame_sent : STD_LOGIC_VECTOR (0 to NUM_OF_POINTS - 1);
	signal pixtmpsent : STD_LOGIC_VECTOR (0 to NUM_OF_POINTS - 1);
	signal frmtmpsent : STD_LOGIC_VECTOR (0 to NUM_OF_POINTS - 1);
	signal pixanysent : STD_LOGIC;
	signal frmanysent : STD_LOGIC;
	signal load			: STD_LOGIC;
	
	signal whichside	: STD_LOGIC;
	signal sideaddr	: STD_LOGIC_VECTOR (7 downto 0);
   
   
begin
	
	
	-- access the same commands a second time when lights are 
	-- double sided.
	sideaddr <= TOTAL_MINUS1 when DUBSIDED = '0' else 
		('0' & TOTAL_MINUS1 (7 downto 1));
	
	
	-- sync neo_go input to 8.31 MHz clock
   go_proc : process (reset8, clkfast)
   begin
      if rising_edge(clkfast) then
			if (reset8 = '1') then
				go1       <= '0';
				go2       <= '0';
			else
				go1       <= fm_go;
				go2       <= go1;
			end if;
		end if;
   end process;
   
   
   -- combine feedback signals from sub_framers
	
	-- pixanysent <= '0' when pixel_sent = 0 else '1';
	-- frmanysent <= '0' when frame_sent = 0 else '1';
	
	gen3: for i in pixel_sent'range generate
		gen3a: if (i = 0) generate
			pixtmpsent(0) <= pixel_sent(0);
		end generate gen3a;
		gen3b: if (i /= 0) generate
			pixtmpsent(i) <= pixtmpsent(i-1) or pixel_sent(i);
		end generate gen3b;
	end generate;
	pixanysent <= pixtmpsent(pixel_sent'high);
	
	gen4: for i in frame_sent'range generate
		gen4a: if (i = 0) generate
			frmtmpsent(0) <= frame_sent(0);
		end generate gen4a;
		gen4b: if (i /= 0) generate
			frmtmpsent(i) <= frmtmpsent(i-1) or frame_sent(i);
		end generate gen4b;
	end generate;
	frmanysent <= frmtmpsent(frame_sent'high);
	
	
	-- high level control of framer
   ctrl_proc : process (reset8, clkfast)
   begin
      if rising_edge(clkfast) then
			if (reset8 = '1') then
				addr       <= x"00";
				whichside  <= '0';				
				dp_rd_en   <= '0';
				fm_busy    <= '0';
				fm_valid   <= '0';
				interframe <= '0';
				ctrlsm     <= INIT;
			else
				case ctrlsm is
				when INIT =>
					addr       <= x"00";
					whichside  <= '0';				
					dp_rd_en   <= '0';
					fm_busy    <= '0';
					fm_valid   <= '0';
					interframe <= '0';
					if (go2 = '1') then
						ctrlsm <= START;
					end if;
				when START =>
					dp_rd_en  <= '1';
					fm_busy   <= '1';
					ctrlsm    <= VAL1;
				when VAL1 =>
					fm_valid <= '1';
					ctrlsm <= VAL0;
				when VAL0 =>
					--if (pixel_sent(0) = '1') then
					if (pixanysent = '1') then
						ctrlsm <= INC;
					end if;
				when INC =>
					if (addr = sideaddr and whichside = '0' and 
					DUBSIDED = '1') then
						addr      <= x"00";
						whichside <= not whichside;
						ctrlsm    <= START; -- loop to get next data word
					elsif (addr < sideaddr) then
						addr   <= addr + '1';
						ctrlsm <= START; -- loop to get next data word
					else
						ctrlsm <= INTER; -- no more data words
					end if;
				when INTER =>
					fm_valid   <= '0'; -- new change
					interframe <= '1';
					ctrlsm     <= SENT;
				when SENT =>
					interframe <= '0';
					--if (frame_sent(0) = '1') then
					if (frmanysent = '1') then
						ctrlsm <= DONE;
					end if;
				when DONE => 
					fm_busy <= '0'; 
					ctrlsm  <= INIT;
				when others => 
					ctrlsm <= INIT;
				end case;
			end if;
		end if;
   end process;
   
   dp_addr <= addr;
	
	
	-- creating frame valid signals for each of the star points
	-- point blocking is only available for the first 12 points
	gen0: for i in 0 to NUM_OF_POINTS - 1 generate
		genlo: if (i <= 11) generate
			fm_val_vec(i) <= fm_valid and not point_block(i);
		end generate genlo;
		genhi: if (i > 11) generate
			fm_val_vec(i) <= fm_valid; -- no blocking available
		end generate genhi;
	end generate gen0;
	
	
	-- create a sub_framer for each of the star points
	gen1: for i in 0 to NUM_OF_POINTS - 1 generate
		sub_framer_x: sub_framer port map (
			clkfast,
         reset8,
         ce1,
			fm_val_vec(i),
			interframe,
			fm_data(i),
			pixel_sent(i),
			frame_sent(i),
         tx_data(i)
			);
	end generate gen1;
	
	
	-- register fm_data(0)
   data_proc : process (reset8, clkfast)
   begin
		if rising_edge(clkfast) then
			if (reset8 = '1') then
				fm_data(0) <= (others => '0');
			else
				fm_data(0) <= dp_data;
			end if;
		end if;
	end process;
	
	   
   load <= '1' when (ctrlsm = VAL0 and pixel_sent(0) = '1') else '0';
	
	-- move data from one star point to another
	gen2: for i in 1 to NUM_OF_POINTS - 1 generate
		regmux24x : regmux24 port map (
			clkfast,
			reset8,
			point_offset,
			load,
			dp_data,
			fm_data(i-1),
			fm_data(i)
		);
	end generate gen2;
	
	
end rtl;
   