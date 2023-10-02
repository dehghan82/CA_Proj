library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;	 
use IEEE.NUMERIC_STD.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM_WB_reg is
 	port(
		clk	: in std_logic;	 --1
		reset : in std_logic; --2
		RegWrite: in std_logic;	--3
		MemtoReg: in std_logic;	 --4
		ReadData : in std_logic_vector (15 downto 0);--data read from mem stage	5
		Address	: in std_logic_vector (15 downto 0);  --address entered into memory or result of alu
		--WriteRegister : in std_logic_vector (3 downto 0);	
		
		RegWrite_out: out std_logic;
		MemtoReg_out: out std_logic;
		ReadData_out : out std_logic_vector (15 downto 0);
		Address_out : out std_logic_vector (15 downto 0)
		--WriteRegister_out : out std_logic_vector (3 downto 0)
	);
end MEM_WB_reg;

architecture Behavioral of MEM_WB_reg is        
begin
		process(CLK, RESET, RegWrite, MemtoReg, ReadData, Address)
		begin
			if RESET = '1' then	
				RegWrite_out <= '0';
				MemtoReg_out <= '0';
				ReadData_out <= (others => '0');
				Address_out	<= (others => '0'); 
				
			elsif rising_edge(CLK) then
				RegWrite_out <= RegWrite;
				MemtoReg_out <= MemtoReg;
				ReadData_out <= ReadData;
				Address_out	<= Address;
				
			end if;
		end process; 
end Behavioral;