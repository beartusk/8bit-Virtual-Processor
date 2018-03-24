library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.numeric_std.all;

entity alu is
	port	(B		: in  std_logic_vector (7 downto 0);
		 A		: in  std_logic_vector (7 downto 0);
		 ALU_Sel	: in  std_logic_vector (2 downto 0);
		 NZVC		: out std_logic_vector (3 downto 0);
		 Result		: out std_logic_vector (7 downto 0));
end entity;

architecture alu_arch of alu is

	

begin

	Operations : process (A)
		
		variable Sum_uns	:	unsigned(8 downto 0);
		
		begin
		
	------------Sum Calculation----------------------------------
		if(ALU_Sel = "000") then
			Sum_uns := unsigned('0' & A) + unsigned('0' & B);
			Result  <= std_logic_vector(Sum_uns(7 downto 0));
			
			NZVC(3) <= Sum_uns(7);
			
			if(Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;
			
			if((A(7)='0' and B(7)='0' and Sum_uns(7)='1') or 
				(A(7)='1' and B(7)='1' and Sum_uns(7)='0')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;
			
			NZVC(0) <= Sum_uns(8);
		elsif(ALU_Sel = "001") then 
			Result <= x"00";
			NZVC <= x"0";
		elsif(ALU_Sel = "010") then 
			Result <= x"00";
			NZVC <= x"0";
		elsif(ALU_Sel = "011") then 
			Result <= x"00";
			NZVC <= x"0";
		elsif(ALU_Sel = "100") then 
			Result <= x"00";
			NZVC <= x"0";
		elsif(ALU_Sel = "101") then 
			Result <= x"00";
			NZVC <= x"0";
		elsif(ALU_Sel = "110") then 
			Result <= x"00";
			NZVC <= x"0";
		elsif(ALU_Sel = "111") then 
			Result <= x"00";
			NZVC <= x"0";
		end if;
		
	end process;

end architecture;
