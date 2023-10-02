library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL ; 	

entity IF_ID_reg is
	port (
	clock   : in std_logic ; 	 		
	reset : in std_logic;
	--IF_ID_enable :in std_logic;
	input_nxt_line : in std_logic_vector(15 downto 0) ; 
	input_Instruction : in std_logic_vector(15 downto 0) ; 
	output_nxt_line : out std_logic_vector(15 downto 0) ; 
	output_instruction : out std_logic_vector(15 downto 0)  
	);
end IF_ID_reg;	 

architecture register_if_id of IF_ID_reg is
begin
	process( clock , reset )
		
	begin  							 
		if( reset = '1' ) then 
			output_nxt_line <= ( others => '0' ) ; 
			output_instruction <= ( others => '0' ) ; 	 
		else
			if( rising_edge( clock ) ) then	
				output_instruction <= input_instruction ; 
				output_nxt_line	<= input_nxt_line;
					
			end if ; 
			
		end if ; 
		
	end process;	
end register_if_id;