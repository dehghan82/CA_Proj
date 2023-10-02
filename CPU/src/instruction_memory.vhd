library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



use std.textio.all;
use ieee.std_logic_textio.all;  
entity instruction_memory is

  port (
    clk : in std_logic;
    addr : in std_logic_vector(15 downto 0);
    address_data : out std_logic_vector(15 downto 0) ;
	reset : in std_logic
  );
end entity;

architecture behavioral of instruction_memory is
  type memory_array is array (1023 downto 0) of std_logic_vector(15 downto 0);	--??? 2^10 ~ = 1KB
  signal instructions : memory_array := (	others => "0000000000000000");
      type mem_array is array (1023 downto 0) of std_logic_vector(15 downto 0);
    signal inst_mem : memory_array := (others => (others => '0'));	
	signal line_num : integer;
begin			
    -- Insert program instructions here
--	"0000111100000000",	  
--	"0000111100000000",
--    "0000001000000010",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000000100000001",
--	"0000001000000010" 

  

	process (reset)		 
		file text_file : text open read_mode is "input.txt";
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
		instructions <= inst_mem;
	end process;
	
	
	
  process (clk)
  begin
    if rising_edge(clk) then
      address_data <= instructions(to_integer(unsigned( std_logic_vector(addr(9 downto 0)))));
    end if;
  end process;
end behavioral;