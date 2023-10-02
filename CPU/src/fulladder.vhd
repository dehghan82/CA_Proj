library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity FullAdder is 
    port(
	        A	: in std_logic;
	        B	: in std_logic;
	        CarryIN	: in	std_logic;
			
	        CarryOUT: out	std_logic;
	        result	: out	std_logic
        );
end FullAdder;

architecture Behavioral of FullAdder is					  


	signal X,Y,Z : std_logic;
	
	--begin 
--	process(A,B,CarryIN)  
	begin
		X <= A xor B;  
		result <= X xor CarryIN;
		Y <= A and B;
		Z <= X and CarryIN;
		CarryOUT <= Y or Z;
	
	
		--if Sum(15) = '1' then
--			Negative = '1';
--		elsif Sum = "0000000000000000" then
--			Zero = '1';		   
--		end if;
--	
--		
--		case Sum(16) is
--    		when '1' =>
--			if A(16) = '0' and B(16) = '0' then
--				Overflow = '1';
--    		when '0' =>
--        	if A(16) = '1' and B(16) = '1' then
--				Overflow = '1';
--		end case;
--	end process;
end Behavioral;