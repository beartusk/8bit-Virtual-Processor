library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;

entity control_unit is
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
end entity;

architecture control_unit_arch of control_unit is

type state_type is
		(S_FETCH_0, S_FETCH_1, S_FETCH_2, S_DECODE_3,
		 S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
		 S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
		 S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7,
		 S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,
		 S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,
		 S_STB_DIR_4, S_STB_DIR_5, S_STB_DIR_6, S_STB_DIR_7,
		 S_ADD_AB_4, 
		 S_SUB_AB_4, 
		 S_AND_AB_4, 
		 S_OR_AB_4, 
		 S_INCA_4, 
		 S_INCB_4, 
		 S_DECA_4, 
		 S_DECB_4, 
		 S_BRA_4, S_BRA_5, S_BRA_6, 
		 S_BEQ_4, S_BEQ_5, S_BEQ_6, S_BEQ_7,
		 S_BCS_4, S_BCS_5, S_BCS_6, S_BCS_7,
		 S_BVS_4, S_BVS_5, S_BVS_6, S_BVS_7,
		 S_BMI_4, S_BMI_5, S_BMI_6, S_BMI_7);

signal current_state, next_state : state_type;

constant LDA_IMM	: std_logic_vector (7 downto 0 ) := x"86";
constant LDA_DIR	: std_logic_vector (7 downto 0 ) := x"87";
constant LDB_IMM	: std_logic_vector (7 downto 0 ) := x"88";
constant LDB_DIR	: std_logic_vector (7 downto 0 ) := x"89";
constant STA_DIR	: std_logic_vector (7 downto 0 ) := x"96";
constant STB_DIR	: std_logic_vector (7 downto 0 ) := x"97";
constant ADD_AB		: std_logic_vector (7 downto 0 ) := x"42";
constant SUB_AB		: std_logic_vector (7 downto 0 ) := x"43";
constant AND_AB		: std_logic_vector (7 downto 0 ) := x"44";
constant OR_AB		: std_logic_vector (7 downto 0 ) := x"45";
constant INCA		: std_logic_vector (7 downto 0 ) := x"46";
constant INCB		: std_logic_vector (7 downto 0 ) := x"47";
constant DECA		: std_logic_vector (7 downto 0 ) := x"48";
constant DECB		: std_logic_vector (7 downto 0 ) := x"49";
constant BRA		: std_logic_vector (7 downto 0 ) := x"20";
constant BMI		: std_logic_vector (7 downto 0 ) := x"21";
constant BPL		: std_logic_vector (7 downto 0 ) := x"22";
constant BEQ		: std_logic_vector (7 downto 0 ) := x"23";
constant BNE		: std_logic_vector (7 downto 0 ) := x"24";
constant BCS		: std_logic_vector (7 downto 0 ) := x"27";
constant BVS		: std_logic_vector (7 downto 0 ) := x"25";
constant BCC		: std_logic_vector (7 downto 0 ) := x"28";
constant BVC		: std_logic_vector (7 downto 0 ) := x"26";

begin

STATE_MEMORY : process (Clock, Reset)
	begin
		if (Reset = '0') then
			current_state <= S_FETCH_0;
		elsif (rising_edge (clock)) then
			current_state <= next_state;
		end if;
	end process;

NEXT_STATE_LOGIC : process (current_state, IR, CCR_Result)
	begin
		if(current_state = S_FETCH_0)then
			next_state <= S_FETCH_1;
		elsif(current_state = S_FETCH_1)then
			next_state <= S_FETCH_2;
		elsif(current_state = S_FETCH_2)then
			next_state <= S_DECODE_3;

		elsif(current_state = S_DECODE_3)then
		
			if(IR = LDA_IMM) then
				next_state <= S_LDA_IMM_4;
			elsif(IR = LDA_DIR) then
				next_state <= S_LDA_DIR_4;
			elsif(IR = STA_DIR) then
				next_state <= S_STA_DIR_4;
				
			elsif(IR = LDB_IMM) then
				next_state <= S_LDB_IMM_4;
			elsif(IR = LDB_DIR) then
				next_state <= S_LDB_DIR_4;
			elsif(IR = STB_DIR) then
				next_state <= S_STB_DIR_4;
				
			elsif(IR = ADD_AB) then
				next_state <= S_ADD_AB_4;
			elsif(IR = SUB_AB) then
				next_state <= S_SUB_AB_4;
			elsif(IR = AND_AB) then
				next_state <= S_AND_AB_4;
			elsif(IR = OR_AB) then
				next_state <= S_OR_AB_4;
			elsif(IR = INCA) then
				next_state <= S_INCA_4;
			elsif(IR = INCB) then
				next_state <= S_INCB_4;
			elsif(IR = DECA) then
				next_state <= S_DECA_4;
			elsif(IR = DECB) then
				next_state <= S_DECB_4;
				
			elsif(IR = BRA) then
				next_state <= S_BRA_4;
			elsif(IR = BEQ and CCR_RESULT(2)='1') then
				next_state <= S_BEQ_4;
			elsif(IR = BEQ and CCR_RESULT(2)='0') then
				next_state <= S_BEQ_7;
			elsif(IR = BCS and CCR_RESULT(2)='1') then
				next_state <= S_BCS_4;
			elsif(IR = BCS and CCR_RESULT(2)='0') then
				next_state <= S_BCS_7;
			elsif(IR = BVS and CCR_RESULT(2)='1') then
				next_state <= S_BVS_4;
			elsif(IR = BVS and CCR_RESULT(2)='0') then
				next_state <= S_BVS_7;
			elsif(IR = BMI and CCR_RESULT(2)='1') then
				next_state <= S_BMI_4;
			elsif(IR = BMI and CCR_RESULT(2)='0') then
				next_state <= S_BMI_7;
				
			else
				next_state <= S_FETCH_0;
			end if;

-------------------------------LDA's----------------------------
			
		elsif(current_state = S_LDA_IMM_4)then
			next_state <= S_LDA_IMM_5;
		elsif(current_state = S_LDA_IMM_5)then
			next_state <= S_LDA_IMM_6;
		elsif(current_state = S_LDA_IMM_6)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_LDA_DIR_4)then
			next_state <= S_LDA_DIR_5;
		elsif(current_state = S_LDA_DIR_5)then
			next_state <= S_LDA_DIR_6;
		elsif(current_state = S_LDA_DIR_6)then
			next_state <= S_LDA_DIR_7;
		elsif(current_state = S_LDA_DIR_7)then
			next_state <= S_LDA_DIR_8;
		elsif(current_state = S_LDA_DIR_8)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_STA_DIR_4)then
			next_state <= S_STA_DIR_5;
		elsif(current_state = S_STA_DIR_5)then
			next_state <= S_STA_DIR_6;
		elsif(current_state = S_STA_DIR_6)then
			next_state <= S_STA_DIR_7;
		elsif(current_state = S_STA_DIR_7)then
			next_state <= S_FETCH_0;

-----------------------------LDB's----------------------------------

		elsif(current_state = S_LDB_IMM_4)then
			next_state <= S_LDB_IMM_5;
		elsif(current_state = S_LDB_IMM_5)then
			next_state <= S_LDB_IMM_6;
		elsif(current_state = S_LDB_IMM_6)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_LDB_DIR_4)then
			next_state <= S_LDB_DIR_5;
		elsif(current_state = S_LDB_DIR_5)then
			next_state <= S_LDB_DIR_6;
		elsif(current_state = S_LDB_DIR_6)then
			next_state <= S_LDB_DIR_7;
		elsif(current_state = S_LDB_DIR_7)then
			next_state <= S_LDB_DIR_8;
		elsif(current_state = S_LDB_DIR_8)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_STB_DIR_4)then
			next_state <= S_STB_DIR_5;
		elsif(current_state = S_STB_DIR_5)then
			next_state <= S_STB_DIR_6;
		elsif(current_state = S_STB_DIR_6)then
			next_state <= S_STB_DIR_7;
		elsif(current_state = S_STB_DIR_7)then
			next_state <= S_FETCH_0;
			
-----------------------------Operations----------------------------------
			
		elsif(current_state = S_ADD_AB_4)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_SUB_AB_4)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_AND_AB_4)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_OR_AB_4)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_INCA_4)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_INCB_4)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_DECA_4)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_DECB_4)then
			next_state <= S_FETCH_0;

-----------------------------Branches----------------------------------
			
		elsif(current_state = S_BRA_4)then
			next_state <= S_BRA_5;
		elsif(current_state = S_BRA_5)then
			next_state <= S_BRA_6;
		elsif(current_state = S_BRA_6)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_BEQ_4)then
			next_state <= S_BEQ_5;
		elsif(current_state = S_BEQ_5)then
			next_state <= S_BEQ_6;
		elsif(current_state = S_BEQ_6)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_BEQ_7)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_BCS_4)then
			next_state <= S_BCS_5;
		elsif(current_state = S_BCS_5)then
			next_state <= S_BCS_6;
		elsif(current_state = S_BCS_6)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_BCS_7)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_BVS_4)then
			next_state <= S_BVS_5;
		elsif(current_state = S_BVS_5)then
			next_state <= S_BVS_6;
		elsif(current_state = S_BVS_6)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_BVS_7)then
			next_state <= S_FETCH_0;

		elsif(current_state = S_BMI_4)then
			next_state <= S_BMI_5;
		elsif(current_state = S_BMI_5)then
			next_state <= S_BMI_6;
		elsif(current_state = S_BMI_6)then
			next_state <= S_FETCH_0;
		elsif(current_state = S_BMI_7)then
			next_state <= S_FETCH_0;

		end if;

	end process;

OUTPUT_LOGIC : process (current_state)
	begin
		case(current_state) is
			when S_FETCH_0 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_FETCH_1 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_FETCH_2 =>
				IR_LOAD <= '1';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_DECODE_3 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
-------------------------------LDA's----------------------------
			when S_LDA_IMM_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_LDA_IMM_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_LDA_IMM_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_LDA_DIR_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_LDA_DIR_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_LDA_DIR_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_LDA_DIR_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_LDA_DIR_8 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_STA_DIR_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_STA_DIR_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_STA_DIR_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_STA_DIR_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '1';
-----------------------------LDB's----------------------------------
			when S_LDB_IMM_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_LDB_IMM_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_LDB_IMM_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '1';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_LDB_DIR_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_LDB_DIR_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_LDB_DIR_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_LDB_DIR_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_LDB_DIR_8 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '1';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_STB_DIR_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_STB_DIR_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_STB_DIR_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_STB_DIR_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "10";
				BUS2_SEL <= "00";
				writ <= '1';
-----------------------------Operations----------------------------------
			when S_ADD_AB_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_SUB_AB_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "001";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_AND_AB_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "010";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_OR_AB_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "011";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_INCA_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "100";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_INCB_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '1';
				ALU_SEL <= "101";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_DECA_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '1';
				B_LOAD <= '0';
				ALU_SEL <= "110";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_DECB_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '1';
				ALU_SEL <= "111";
				CCR_LOAD <= '1';
				BUS1_SEL <= "01";
				BUS2_SEL <= "00";
				writ <= '0';
-----------------------------Branches----------------------------------
			when S_BRA_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_BRA_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_BRA_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '1';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
				
			when S_BEQ_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_BEQ_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_BEQ_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '1';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_BEQ_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
				
			when S_BCS_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_BCS_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_BCS_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '1';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_BCS_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
				
			when S_BVS_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_BVS_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_BVS_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '1';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_BVS_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
				
			when S_BMI_4 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '1';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "01";
				writ <= '0';
			when S_BMI_5 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
			when S_BMI_6 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '1';
				PC_INC <= '0';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "10";
				writ <= '0';
			when S_BMI_7 =>
				IR_LOAD <= '0';
				MAR_LOAD <= '0';
				PC_LOAD <= '0';
				PC_INC <= '1';
				A_LOAD <= '0';
				B_LOAD <= '0';
				ALU_SEL <= "000";
				CCR_LOAD <= '0';
				BUS1_SEL <= "00";
				BUS2_SEL <= "00";
				writ <= '0';
		end case;
	end process;


end architecture;
