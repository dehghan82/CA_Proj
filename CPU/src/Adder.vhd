library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Adder is 
    port(		
			A	: in std_logic_vector(15 downto 0);
	        B	: in std_logic_vector(15 downto 0);
			Carry_in : in std_logic;
			
	        CarryOUT: out	std_logic;
	        Sum	: out	std_logic_vector(15 downto 0);
			Overflow : out std_logic;
			Negative : out std_logic;
			Zero : out std_logic
        );
end Adder;

architecture Behavioral of Adder is	
	component FullAdder is
		port(					 
			A	: in std_logic;
	        B	: in std_logic;
	        CarryIN	: in	std_logic;
			
	        CarryOUT: out	std_logic;
	        result	: out	std_logic
		);	 
	end component FullAdder;
	
	signal Carry :	std_logic_vector(15 downto 0);
    signal Sum2 : std_logic_vector(15 downto 0); 
begin
	FA:
		FullAdder port map(
			A => A(0),
		    B => B(0),
		    CarryIN	=> Carry_in,
				
		    CarryOUT =>	Carry(0),
		    result	=> Sum2(0)
		);
	
			
	bahav:
		for i in 1 to 15 generate
			next_FA:
				FullAdder port map (
					A	=> A(i),
					B	=> B(i),	
					CarryIN	=> Carry(i-1),
					CarryOUT=> Carry(i),
					result	=> Sum2(i)
				);
		end generate;
	Negative <= '0';
	Zero <= '0';
	CarryOUT <= Carry(15);
	Sum <= Sum2;
	Negative <= '1' when Sum2(15) = '1';
	Zero <= '1' when Sum2 = "0000000000000000";
	process(A ,B)										  
	
	
	
	
	
	begin
	case Sum2(15) is
   		when '1' =>
			if A(15) = '0' and B(15) = '0' then
				Overflow <= '1';	 
			end if;
   		when '0' =>
	       	if A(15) = '1' and B(15) = '1' then
				Overflow <= '1';	 
			end if;
		when others	=>
			 Overflow <= '0';
	end case;
end process;
	
end Behavioral;