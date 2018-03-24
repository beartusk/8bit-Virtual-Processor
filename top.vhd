library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.numeric_std.all;

entity top is
	port(Clock	:	in  std_logic;
		  Reset	:	in  std_logic;
		  SW		:	in  std_logic_vector(9 downto 0);
		  KEY		:	in	 std_logic_vector(3 downto 0);
		  HEX0	:	out std_logic_vector(6 downto 0);
		  HEX1	:	out std_logic_vector(6 downto 0);
		  HEX2	:	out std_logic_vector(6 downto 0);
		  HEX3	:	out std_logic_vector(6 downto 0);
		  HEX4	:	out std_logic_vector(6 downto 0);
		  HEX5	:	out std_logic_vector(6 downto 0);	
		  LEDR	:	out std_logic_vector(9 downto 0);	
		  GPIO_0	:	out std_logic_vector(15 downto 0));
end entity;

architecture top_arch of top is
	
	signal HEX_VALUES	:	std_logic_vector(23 downto 0);
	signal Comp_Clock	:	std_logic;
	
	component computer is
		port   (clock          : in   std_logic;
              reset          : in   std_logic;
              port_in_00     : in   std_logic_vector (7 downto 0);
              port_in_01     : in   std_logic_vector (7 downto 0);
              port_in_02     : in   std_logic_vector (7 downto 0);
              port_in_03     : in   std_logic_vector (7 downto 0);
              port_in_04     : in   std_logic_vector (7 downto 0);
              port_in_05     : in   std_logic_vector (7 downto 0);
              port_in_06     : in   std_logic_vector (7 downto 0);               
              port_in_07     : in   std_logic_vector (7 downto 0);
              port_in_08     : in   std_logic_vector (7 downto 0);
              port_in_09     : in   std_logic_vector (7 downto 0);
              port_in_10     : in   std_logic_vector (7 downto 0);
              port_in_11     : in   std_logic_vector (7 downto 0);
              port_in_12     : in   std_logic_vector (7 downto 0);
              port_in_13     : in   std_logic_vector (7 downto 0);
              port_in_14     : in   std_logic_vector (7 downto 0);
              port_in_15     : in   std_logic_vector (7 downto 0);                                                                   
              port_out_00    : out  std_logic_vector (7 downto 0);
              port_out_01    : out  std_logic_vector (7 downto 0);
              port_out_02    : out  std_logic_vector (7 downto 0);
              port_out_03    : out  std_logic_vector (7 downto 0);
              port_out_04    : out  std_logic_vector (7 downto 0);
              port_out_05    : out  std_logic_vector (7 downto 0);
              port_out_06    : out  std_logic_vector (7 downto 0);
              port_out_07    : out  std_logic_vector (7 downto 0);
              port_out_08    : out  std_logic_vector (7 downto 0);
              port_out_09    : out  std_logic_vector (7 downto 0);
              port_out_10    : out  std_logic_vector (7 downto 0);
              port_out_11    : out  std_logic_vector (7 downto 0);
              port_out_12    : out  std_logic_vector (7 downto 0);
              port_out_13    : out  std_logic_vector (7 downto 0);
              port_out_14    : out  std_logic_vector (7 downto 0);
              port_out_15    : out  std_logic_vector (7 downto 0));
	end component;
	
	component char_decoder is
		port (BIN_IN : in std_logic_vector (3 downto 0);
				HEX_OUT : out std_logic_vector (6 downto 0));
	end component;
	
	component clock_div_prec is
		port (Clock_in : in std_logic;
				Reset : in std_logic;
				Sel : in std_logic_vector (1 downto 0);
				Clock_out : out std_logic);
	end component; 


begin

	COMP	:	computer port map (clock => Comp_Clock, 
										 reset => Reset, 
										 port_in_00  => SW(7 downto 0), 
										 port_in_01 => "0000" & KEY (3 downto 0),
										 port_in_02 => x"00",
										 port_in_03 => x"00",
										 port_in_04 => x"00",
										 port_in_05 => x"00",
										 port_in_06 => x"00",
										 port_in_07 => x"00",
										 port_in_08 => x"00",
										 port_in_09 => x"00",
										 port_in_10 => x"00",
										 port_in_11 => x"00",
										 port_in_12 => x"00",
										 port_in_13 => x"00",
										 port_in_14 => x"00",
										 port_in_15 => x"00",
										 port_out_00 => LEDR (7 downto 0),
										 port_out_01 => HEX_VALUES (7 downto 0),
										 port_out_02 => HEX_VALUES (15 downto 8),
										 port_out_03 => HEX_VALUES (23 downto 16),
										 port_out_04 => GPIO_0 (7 downto 0),
										 port_out_05 => GPIO_0 (15 downto 8));
										 
	CH0	:	char_decoder port map (BIN_IN => HEX_VALUES (3 downto 0), HEX_OUT => HEX0);
	CH1	:	char_decoder port map (BIN_IN => HEX_VALUES (7 downto 4), HEX_OUT => HEX1);
	CH2	:	char_decoder port map (BIN_IN => HEX_VALUES (11 downto 8), HEX_OUT => HEX2);
	CH3	:	char_decoder port map (BIN_IN => HEX_VALUES (15 downto 12), HEX_OUT => HEX3);
	CH4	:	char_decoder port map (BIN_IN => HEX_VALUES (19 downto 16), HEX_OUT => HEX4);
	CH5	:	char_decoder port map (BIN_IN => HEX_VALUES (23 downto 20), HEX_OUT => HEX5);
	
	clock_set	:	clock_div_prec port map (Clock_in => Clock, Reset => Reset, Sel => SW(9 downto 8), Clock_out => Comp_Clock);
										 
end architecture;
