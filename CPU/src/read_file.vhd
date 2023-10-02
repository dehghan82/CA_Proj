library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;  


entity read_text_file is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic
    );
end entity read_text_file;

architecture Behavioral of read_text_file is
    type mem_array is array (0 to 1023) of std_logic_vector(15 downto 0);
    signal inst_mem : mem_array := (others => (others => '0'));	
	signal line_num : integer;
begin			
	process (reset)		 
		file text_file : text open read_mode is "text.txt";
        variable line : line;
        variable c     : std_logic_vector(15 downto 0);
		begin 	  
			line_num <= 0;
			if reset = '1' then
				inst_mem <= (others => (others => '0'));
			else 
				while not endfile(text_file) loop
					readline(text_file, line);
					read(line, c); 
					inst_mem(line_num) <= c;
					line_num <= line_num + 1;
				end loop;
			end if;
		file_close(text_file);
	end process;
end architecture Behavioral;