library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_back is
  port (
		clk : in std_logic;	 
		reset : in std_logic;  
		RegWrite_in : in std_logic;
		MemToReg_in : in std_logic;
		ReadData : in std_logic_vector(15 downto 0);
		Address : in std_logic_vector(15 downto 0);
		
		write_data : out std_logic_vector(15 downto 0);  -- Data to write
	    reg_write_out : out std_logic  -- Write enable signal for the register file
  );
end write_back;

architecture behavioral of write_back is
begin
	process (clk, reset)
	begin	 
		if reset = '1' then
			reg_write_out <= '0';
			
			write_data <= (others => '0');
		else
			if rising_edge(clk) then
				reg_write_out <= RegWrite_in;
				--write_register_out <= write_register;
				
	      		if MemToReg_in = '1' then
					write_data <= ReadData;
				else
					write_data <= Address; 
				end if;	
			end if;
		end if;
	end process;
end behavioral;