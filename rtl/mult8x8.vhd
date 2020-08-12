------------------------------------------------------------------------
-- Create Date: 04/8/2020 
-- Module Name: mult8x8 - rtl
-- By: Grant Grummer
-- 
-- Description: 8x8 multiplier, with both inputs & outputs registered.
--    Inferencing Lattice iCE40 DSPs. Added "ce", it may not work.
-- 
-- Revision: 0.0
-- 
-----------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY mult8x8 IS
	PORT (
		clk  : IN STD_LOGIC;
		ce	  : IN STD_LOGIC;
		a_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		b_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		prod : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END mult8x8;


ARCHITECTURE arch OF mult8x8 IS


	SIGNAL a_reg 	 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL b_reg 	 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mult_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

	
BEGIN
	
	-- mult_out <= ("00000000" & a_reg * b_reg); -- looks wrong
	mult_out <= (a_reg * b_reg);
	
	mult_reg_proc : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (ce = '1') THEN
				a_reg <= a_in;
				b_reg <= b_in;
				prod  <= mult_out;
			END IF;
		END IF;
	END PROCESS;
	
END arch;