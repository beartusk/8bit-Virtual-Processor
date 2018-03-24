library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.numeric_std.all;

entity cpu is
	port	(clock		: in  std_logic;
		 reset		: in  std_logic;
		 writ		: out std_logic;
		 from_memory	: in  std_logic_vector (7 downto 0);
		 address	: out std_logic_vector (7 downto 0);
		 to_memory	: out std_logic_vector (7 downto 0));
end entity;

architecture cpu_arch of cpu is

	component control_unit is
		port	(clock		: in  std_logic;
			 reset		: in  std_logic;
			 IR		: in  std_logic_vector (7 downto 0);
			 CCR_Result	: in  std_logic_vector (3 downto 0);
			 writ		: out std_logic;
			 IR_Load	: out std_logic;
			 MAR_Load	: out std_logic;
			 PC_Load	: out std_logic;
	 		 PC_INC		: out std_logic;
			 A_Load		: out std_logic;
			 B_Load		: out std_logic;
			 CCR_Load	: out std_logic;
			 Bus2_SEL	: out std_logic_vector (1 downto 0);
			 Bus1_SEL	: out std_logic_vector (1 downto 0);
			 ALU_Sel	: out std_logic_vector (2 downto 0));
	end component;

	component data_path is
		port	(clock		: in  std_logic;
		 	reset		: in  std_logic;
		 	IR_Load		: in  std_logic;
		 	MAR_Load	: in  std_logic;
		 	PC_Load		: in  std_logic;
 		 	PC_INC		: in  std_logic;
		 	A_Load		: in  std_logic;
		 	B_Load		: in  std_logic;
		 	CCR_Load	: in  std_logic;
		 	Bus2_SEL	: in  std_logic_vector (1 downto 0);
		 	Bus1_SEL	: in  std_logic_vector (1 downto 0);
		 	ALU_Sel		: in  std_logic_vector (2 downto 0);
		 	IR		: out std_logic_vector (7 downto 0);
		 	CCR_Result	: out std_logic_vector (3 downto 0);
		 	address		: out std_logic_vector (7 downto 0);
		 	from_memory	: in  std_logic_vector (7 downto 0);
		 	to_memory	: out std_logic_vector (7 downto 0));   
	end component;
	
	signal IL_sig	: std_logic;
	signal ML_sig	: std_logic;
	signal PCL_sig	: std_logic;
	signal PCI_sig	: std_logic;
	signal AL_sig	: std_logic;
	signal BL_sig	: std_logic;
	signal CL_sig	: std_logic;
	signal B2	: std_logic_vector (1 downto 0);
	signal B1	: std_logic_vector (1 downto 0);
	signal I_sig	: std_logic_vector (7 downto 0);
	signal CR_sig	: std_logic_vector (3 downto 0);
	signal ALU_sig	: std_logic_vector (2 downto 0);

begin

	CU : control_unit	port map (clock => clock,
					  reset => reset,
					  IR => I_sig,
					  CCR_Result => CR_sig,
					  writ => writ,
					  IR_Load => IL_sig,
					  MAR_Load => ML_sig,
					  PC_Load => PCL_sig,
					  A_Load => AL_sig,
					  B_Load => BL_sig,
					  CCR_Load => CL_sig,
					  PC_INC => PCI_sig,
					  Bus2_SEL => B2,
					  Bus1_SEL => B1,
					  ALU_Sel => ALU_sig);

	DP : data_path		port map (clock => clock,
					  reset => reset,
					  IR => I_sig,
					  CCR_Result => CR_sig,
					  IR_Load => IL_sig,
					  MAR_Load => ML_sig,
					  PC_Load => PCL_sig,
					  A_Load => AL_sig,
					  B_Load => BL_sig,
					  CCR_Load => CL_sig,
					  PC_INC => PCI_sig,
					  Bus2_SEL => B2,
					  Bus1_SEL => B1,
					  ALU_Sel => ALU_sig,
					  address => address,
					  from_memory => from_memory,
					  to_memory => to_memory);
end architecture;
