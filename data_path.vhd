library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity data_path is
	port	(clock		: in  std_logic;
		 reset		: in  std_logic;
		 IR_Load	: in  std_logic;
		 MAR_Load	: in  std_logic;
		 PC_Load	: in  std_logic;
 		 PC_INC		: in  std_logic;
		 A_Load		: in  std_logic;
		 B_Load		: in  std_logic;
		 CCR_Load	: in  std_logic;
		 Bus2_SEL	: in  std_logic_vector (1 downto 0);
		 Bus1_SEL	: in  std_logic_vector (1 downto 0);
		 ALU_Sel	: in  std_logic_vector (2 downto 0);
		 IR		: out std_logic_vector (7 downto 0);
		 CCR_Result	: out std_logic_vector (3 downto 0);
		 address	: out std_logic_vector (7 downto 0);
		 from_memory	: in  std_logic_vector (7 downto 0);
		 to_memory	: out std_logic_vector (7 downto 0));   
end entity;

architecture data_path_arch of data_path is

	component alu is
		port	(B		: in  std_logic_vector (7 downto 0);
			 A		: in  std_logic_vector (7 downto 0);
			 ALU_Sel	: in  std_logic_vector (2 downto 0);
			 NZVC		: out std_logic_vector (3 downto 0);
			 Result		: out std_logic_vector (7 downto 0));
	end component;

	signal Bus1		: std_logic_vector (7 downto 0);
	signal Bus2		: std_logic_vector (7 downto 0);
	signal PC_out		: std_logic_vector (7 downto 0);
	signal PC_uns		: unsigned (7 downto 0);
	signal A_out		: std_logic_vector (7 downto 0);
	signal B_out		: std_logic_vector (7 downto 0);
	signal MAR_out		: std_logic_vector (7 downto 0);
	signal B_ALU		: std_logic_vector (7 downto 0);
	signal NZVC_sig		: std_logic_vector (3 downto 0);
	signal Result_sig	: std_logic_vector (7 downto 0);

begin

	ALU_MAP : alu 	port map(B_out, Bus1, ALU_Sel, NZVC_sig, Result_sig); 

--------------------------Bus Lines------------------------------------------------

	MUX_BUS1 : process (Bus1_SEL, PC_out, A_out, B_out)
	begin
		case (Bus1_Sel) is
			when "00"	=> Bus1 <= PC_out;
			when "01"	=> Bus1 <= A_out;
			when "10"	=> Bus1 <= B_out;
			when others	=> Bus1 <= x"00";
		end case;
	end process;

	MUX_BUS2 : process (Bus2_SEL, Result_sig, Bus1, from_memory)
	begin
		case (Bus2_Sel) is
			when "00"	=> Bus2 <= Result_sig;
			when "01"	=> Bus2 <= Bus1;
			when "10"	=> Bus2 <= from_memory;
			when others	=> Bus2 <= x"00";
		end case;
	end process;

	address		<= MAR_out;
	to_memory	<= Bus1;

----------------------------Registers------------------------------------------------

	Instruction_Register : process (Clock, Reset)
	begin
		if(Reset = '0') then
			IR <= x"00";
		elsif(rising_edge(clock)) then
			if(IR_Load = '1') then
				IR <= Bus2;
			end if;
		end if;
	end process;

	Memory_Address_Register : process (Clock, Reset)
	begin
		if(Reset = '0') then
			MAR_out <= x"00";
		elsif(rising_edge(clock)) then
			if(MAR_Load = '1') then
				MAR_out <= Bus2;
			end if;
		end if;
	end process;

	A_Register : process (Clock, Reset)
	begin
		if(Reset = '0') then
			A_out <= x"00";
		elsif(rising_edge(clock)) then
			if(A_Load = '1') then
				A_out <= Bus2;
			end if;
		end if;
	end process;

	B_Register : process (Clock, Reset)
	begin
		if(Reset = '0') then
			B_out <= x"00";
		elsif(rising_edge(clock)) then
			if(B_Load = '1') then
				B_out <= Bus2;
			end if;
		end if;
	end process;

	Condition_Code_Register : process (Clock, Reset)
	begin
		if(Reset = '0') then
			CCR_Result <= x"0";
		elsif(rising_edge(clock)) then
			if(CCR_Load = '1') then
				CCR_Result <= NZVC_sig;
			end if;
		end if;
	end process;

------------------------------Program Counter-----------------------------

	Program_Counter : process (Clock, Reset)
	begin
		if(Reset = '0') then
			PC_uns <= x"00";
		elsif(rising_edge(clock)) then
			if(PC_Load = '1') then
				PC_uns <= unsigned(Bus2);
			elsif(PC_INC = '1') then
				PC_uns <= PC_uns + 1;
			end if;
		end if;
	end process;

	PC_out <= std_logic_vector(PC_uns);

end architecture;
