----------------------------------------------------------------------------------
-- Create Date: 03/19/2019 10:56:12 PM
-- Module Name: star_top - rtl
-- 
-- Description: top level for starlite project only
-- 
-- Revision: 0.0 
-- Revision: 0.1 added brightness select push button
-- 
----------------------------------------------------------------------------------


use work.lites_pkg.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity star_top is
   Port ( 
      disp_sel_n  : in  STD_LOGIC;
		brite_sel_n : in  STD_LOGIC;
		osc12		   : in  STD_LOGIC;
		buf_en		: out STD_LOGIC;
      tx_data     : out STD_LOGIC_VECTOR (0 to NUM_OF_POINTS-1));
end star_top;


architecture rtl of star_top is


   -- Component declarations
   COMPONENT SolUP12_pll
		PORT (
			REFERENCECLK	: in STD_LOGIC;
			PLLOUTCORE		: out STD_LOGIC; -- 16 MHz clock output drives FPGA routing
			PLLOUTGLOBAL	: out STD_LOGIC; -- 16 MHz clock output drives global clock network
			RESET				: in STD_LOGIC;  -- Active low reset
			LOCK				: out STD_LOGIC  -- When High, indicates that the PLL output is phase aligned
		);
	END COMPONENT;
	
	
	COMPONENT star8_clocks
      PORT (
			soft_reset	: in STD_LOGIC;
			pll_16		: in STD_LOGIC;
			lock  		: in STD_LOGIC;
			clkfast   	: out STD_LOGIC;
			clk8      	: out STD_LOGIC;
			ce1       	: out STD_LOGIC;
			reset8    	: out STD_LOGIC
		);
   END COMPONENT;
   
   
   COMPONENT star_neo_main
      PORT (
			clk8        	: in STD_LOGIC;
         clkfast     	: in STD_LOGIC;
         reset8      	: in STD_LOGIC;
         ce1         	: in STD_LOGIC;
         frame_start 	: in STD_LOGIC;
         frame_data  	: in STD_LOGIC_VECTOR (25 downto 0);
			brite_sel_n		: in STD_LOGIC;
			point_offset	: in STD_LOGIC;
			point_block		: in STD_LOGIC_VECTOR (11 downto 0);
			buf_en			: out STD_LOGIC;
         neo_busy    	: out STD_LOGIC;
         tx_data     	: out STD_LOGIC_VECTOR (0 to NUM_OF_POINTS-1)
		);
   END COMPONENT;
   
   
   COMPONENT tasks2do
      PORT (
			clk8        : in STD_LOGIC;
			reset8      : in STD_LOGIC;
			ce1         : in STD_LOGIC;
			frame_start : out STD_LOGIC;
			frame_busy  : in STD_LOGIC;
			frame_data  : out STD_LOGIC_VECTOR (25 downto 0);
			prog_req    : in STD_LOGIC;
			prog_ack    : out STD_LOGIC;
			prog_addr   : in STD_LOGIC_VECTOR (9 downto 0);
			prog_word   : in STD_LOGIC_VECTOR (31 downto 0);
			prog_wr     : in STD_LOGIC;
			prog_busy   : in STD_LOGIC;
			neo_busy    : in STD_LOGIC;
			neo_size    : out STD_LOGIC_VECTOR (7 downto 0);
			sw          : in STD_LOGIC_VECTOR (3 downto 0);
			disp_sel_n  : in STD_LOGIC;
			led         : out STD_LOGIC_VECTOR (3 downto 0);
			point_offset : out STD_LOGIC;
			point_block	: out STD_LOGIC_VECTOR (11 downto 0)
      );
   END COMPONENT;
   
   
   signal clk8        : std_logic;
   signal clkfast     : std_logic;
   signal ce1         : std_logic;
   signal reset8      : std_logic;
   signal frame_start : std_logic;
   signal frame_busy  : std_logic;
   signal frame_data  : STD_LOGIC_VECTOR (25 downto 0);
   signal prog_req    : STD_LOGIC;
   signal prog_ack    : STD_LOGIC;
   signal prog_addr   : STD_LOGIC_VECTOR (9 downto 0);
   signal prog_word   : STD_LOGIC_VECTOR (31 downto 0);
   signal prog_wr     : STD_LOGIC;
   signal prog_busy   : STD_LOGIC;
   signal soft_reset  : STD_LOGIC;
   signal led         : STD_LOGIC_VECTOR (3 downto 0);
   signal sw          : STD_LOGIC_VECTOR (3 downto 0);
   signal neo_busy    : STD_LOGIC;
   signal neo_size    : STD_LOGIC_VECTOR (7 downto 0);
   signal point_offset : STD_LOGIC;
	signal point_block : STD_LOGIC_VECTOR (11 downto 0);
	signal pll_16		 : STD_LOGIC;
	signal lock			 : STD_LOGIC;


begin

   
	pll_0 : SolUP12_pll
		PORT MAP (
			REFERENCECLK	=> osc12,
			PLLOUTCORE		=> pll_16,
			PLLOUTGLOBAL	=> OPEN,
			RESET				=> '1',  -- Active low reset
			LOCK				=> lock
		);
	
	
	clks_0 : star8_clocks
      PORT MAP (
         soft_reset => soft_reset,
			pll_16	  => pll_16,
			lock	  	  => lock,
         clkfast    => clkfast,
         clk8       => clk8,
         ce1        => ce1,
         reset8     => reset8
      );
   
   
   star_main_0 : star_neo_main
      PORT MAP (
         clk8        	=> clk8,
         clkfast     	=> clkfast,
         reset8      	=> reset8,
         ce1         	=> ce1,
         frame_start 	=> frame_start,
         frame_data  	=> frame_data,
			brite_sel_n		=> brite_sel_n,
			point_offset	=> point_offset,
			point_block		=> point_block,
			buf_en			=> buf_en,
         neo_busy    	=> neo_busy,
         tx_data     	=> tx_data
      );
   
   
   tasks2do_0 : tasks2do
      PORT MAP (
         clk8        => clk8,
         ce1         => ce1,
         reset8      => reset8,
         frame_start => frame_start,
         frame_busy  => frame_busy,
         frame_data  => frame_data,
         prog_req    => prog_req,
         prog_ack    => OPEN, -- not used in this version
         prog_addr   => prog_addr,
         prog_word   => prog_word,
         prog_wr     => prog_wr,
         prog_busy   => prog_busy,
         neo_busy    => neo_busy,
         neo_size    => neo_size,
         sw          => sw,
         disp_sel_n  => disp_sel_n,
         led         => led,
			point_offset => point_offset,
			point_block	=> point_block
      );
   
	
	-- signals not used in this version of the lites projects
	soft_reset	<= '0';
	frame_busy	<= neo_busy; -- double check this 
	prog_addr	<= (others => '0');
	prog_word	<= (others => '0');
	prog_req		<= '0';
	prog_wr		<= '0';
	prog_busy	<= '0';
	sw				<= (others => '0');
	
   
end rtl;
