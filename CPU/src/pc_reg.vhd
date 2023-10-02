library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;


entity pc_reg is 
	    
	port(
		clk		: in	std_logic;						
		rst		: in	std_logic;			
		input_addr		: in	std_logic_vector(15 downto 0);	
		output_addr	: out	std_logic_vector(15 downto 0)	
	);
end pc_reg;

architecture pc_reg_arc of pc_reg is        
begin
	
		process(clk,rst,input_addr)
		begin
			if(rst = '1') then
				output_addr <= (others => '0');
			elsif rising_edge(clk) then
				output_addr <= input_addr;
			end if;
		end process; 
end pc_reg_arc;