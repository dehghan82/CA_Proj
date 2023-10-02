library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_signed.all;	 
use IEEE.NUMERIC_STD.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity DataMemory is
   port (clk : in std_logic;
   		 reset : in std_logic;
   		 address : in std_logic_vector(15 downto 0);
         mem_write : in std_logic;		  
		 mem_read : in std_logic;  
		 clear_mem : in std_logic;
		 
		 write_data : in std_logic_vector(15 downto 0);
		 
         read_data : out std_logic_vector(15 downto 0)	
		 );
end DataMemory;

architecture behav of DataMemory is
	type mem_array is array (3071 downto 0) of std_logic_vector(15 downto 0);	 -- 4KB = 32000b ??
	signal memory : mem_array := (others => (others => '0')); -- Initialize with base address
	
	--signal program_counter : std_logic_vector(15 downto 0) := (others => '0');
	--signal base_address : std_logic_vector(15 downto 0) := (others => '0');
	
	begin 
		
	process (clk, reset, address, mem_write, mem_read, write_data, memory)
		begin 
		if reset = '1' then
			for i in 0 to 3071 loop
				memory(i) <= (others => '1');  -- 1 or 0?
			end loop;
		
      	elsif (mem_write = '1' and clear_mem ='0') then
         	memory(to_integer(unsigned(address(11 downto 0)))) <= write_data;
      	elsif (mem_read = '1' and clear_mem='0' )then
      		read_data <= memory(to_integer(unsigned(address)));
			  
		elsif (mem_write = '1' and clear_mem ='1')then
			memory(to_integer(unsigned(address(11 downto 0)))) <= "0000000000000000"; --clear_mem instruction
			
	  	end if;	
		
		  --read_data
	  --base_address <= (others => (others => '0'));
	end process;
end behav;