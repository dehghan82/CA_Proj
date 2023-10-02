library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;  
		enable_write :in std_logic;
        write_register   : in  std_logic_vector(3 downto 0);
        write_data  : in  std_logic_vector(15 downto 0);
        read_register1 : in  std_logic_vector(3 downto 0);
        read_register2 : in  std_logic_vector(3 downto 0);
        read_data1: out std_logic_vector(15 downto 0);
        read_data2: out std_logic_vector(15 downto 0)
    );
end entity register_file;

architecture reg_file_arc of register_file is	
--defining array of registersr
type type_array_register is array (0 to 13) of std_logic_vector(15 downto 0);  

signal registers : type_array_register := (others => (others => '0')); 
--
begin					  
	
	
    process (clk, reset)
    begin
        if reset = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then	 
			
            if  enable_write ='1' then
                registers(to_integer(unsigned(write_register))) <= std_logic_vector(unsigned(write_data));
            end if;
        end if;
    end process;

    read_data1 <= std_logic_vector(unsigned(registers(to_integer (unsigned(read_register1)))));
    read_data2 <= std_logic_vector(unsigned(registers(to_integer (unsigned(read_register2))))); 
	
end architecture reg_file_arc;