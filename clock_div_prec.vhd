library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_div_prec is
	port (Clock_in : in std_logic;
			Reset : in std_logic;
			Sel : in std_logic_vector (1 downto 0);
			Clock_out : out std_logic);
end entity; 

architecture clock_div_prec_arch of clock_div_prec is

signal count_int : integer range 0 to 50000000;
signal clock_toggle : std_logic;

begin
		
		
	process (Clock_in, Reset) 
		begin
			if (Reset = '0') then 
				count_int <= 0;
			elsif rising_edge(Clock_in) then
				case (Sel) is	
				when "00" =>	
					if(count_int <= 25000000) then
						count_int <= count_int + 1;
					else
						clock_toggle <= not clock_toggle;
						count_int <= 0;
					end if;
				when "01" =>	
					if(count_int <= 2500000) then
						count_int <= count_int + 1;
					else
						clock_toggle <= not clock_toggle;
						count_int <= 0;
					end if;
				when "10" =>
					if(count_int <= 250000) then
						count_int <= count_int + 1;
					else
						clock_toggle <= not clock_toggle;
						count_int <= 0;
					end if;	
				when others =>	
					if(count_int <= 25000) then
						count_int <= count_int + 1;
					else
						clock_toggle <= not clock_toggle;
						count_int <= 0;
					end if;
				end case;
			else
			end if;
	end process;

	Clock_out <= clock_toggle;

end architecture;