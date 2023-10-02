library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Memory is
	port( 
		clk : in std_logic;
		reset : in std_logic;	
		RegWrite_in: in std_logic;
		MemtoReg_in: in std_logic;
		zeroflag : in std_logic;	
		New_PC_Address : in std_logic_vector (15 downto 0);
		Addres : in std_logic_vector (15 downto 0);	
		WriteData : in std_logic_vector (15 downto 0);	
		WriteReg : in std_logic_vector (3 downto 0);
		Branch : in std_logic;
		MemRead : in std_logic;  
		MemWrite : in std_logic;
		clear_reg : in std_logic;
		clear_mem : in std_logic;
		add_type2 : in std_logic;

		RegWrite_Out: out std_logic;
		MemtoReg_Out: out std_logic;
		Read_Data : out std_logic_vector (15 downto 0);	
		Address_out : out std_logic_vector (15 downto 0);	
		WriteReg_out : out std_logic_vector (3 downto 0);	
		New_PC_Address_out : out std_logic_vector (15 downto 0);	
		PCSrc : out std_logic		
	);
end Memory;

architecture Behavioral of Memory is
	component DataMemory is
		port(clk : in std_logic;
	   		 reset : in std_logic;
	   		 address : in std_logic_vector(15 downto 0);
	         mem_write : in std_logic;
			 clear_mem : in std_logic;
			 mem_read : in std_logic;
			 write_data : in std_logic_vector(15 downto 0);	 
			 
	         read_data : out std_logic_vector(15 downto 0)
		);
	end component DataMemory;

	component MEM_WB_reg is
		 port(
			clk	: in std_logic;
			reset : in std_logic;
			RegWrite: in std_logic;
			MemtoReg: in std_logic;
			ReadData : in std_logic_vector (15 downto 0);
			Address	: in std_logic_vector (15 downto 0);
			--WriteRegister : in std_logic_vector (3 downto 0);	
			
			RegWrite_out: out std_logic;
			MemtoReg_out: out std_logic;
			ReadData_out : out std_logic_vector (15 downto 0);
			Address_out : out std_logic_vector (15 downto 0)
			--WriteRegister_out : out std_logic_vector (3 downto 0)
		);
	end component MEM_WB_reg;
	 
	signal ReadData : STD_LOGIC_VECTOR (15 downto 0);
	signal type2_inst : std_logic_vector(15 downto 0); 
	signal lw_inst : std_logic_vector(15 downto 0);
	signal clearReg_inst : std_logic_vector(15 downto 0);
	signal output_lastmux : std_logic_vector(15 downto 0);
	
 
	begin
			process(clk, reset, zeroflag, Branch, New_PC_Address)
			begin
				if( RESET = '1') then
					PCSrc <= '0';
					New_PC_Address_out <= (others => '0'); 
				else
					PCSrc <= zeroflag and Branch;
					New_PC_Address_out <= New_PC_Address;
				end if;
			end process;
	
		Data_Memory:
			DataMemory port map(				 
			    clk			=> clk,
				reset		=> reset,
				address		=> Addres,
				write_data	=> WriteData,
				mem_read	=> MemRead,
				mem_write	=> MemWrite,
				read_data	=> ReadData,
				clear_mem => clear_mem
			);
		process (clk )
		begin 
			type2_inst <=  std_logic_vector( ReadData+ writedata);
			lw_inst <= ReadData;
			clearReg_inst <= "0000000000000000";
			if(clear_reg = '1' and add_type2= '0') then
				output_lastmux <= clearReg_inst;
				
			elsif (clear_reg = '0' and add_type2 ='1')then 
				output_lastmux <= type2_inst;	
			elsif (clear_reg='0' and add_type2='0') then 
				output_lastmux <= lw_inst;
			end if;
		
			read_data <= output_lastmux;	
			
			
			
		end process; 
		

		
		MEM_WB_REGISTER:												   
		
			MEM_WB_reg port map(
				clk			=> clk,
				reset		=> reset,
				RegWrite => RegWrite_in,
				MemtoReg => MemtoReg_in,
				ReadData	=> output_lastmux,
				Address		=> Addres,
				---WriteRegister => WriteReg,
				RegWrite_out => RegWrite_Out,
				MemtoReg_out => MemtoReg_Out,
				ReadData_out => Read_Data,
				Address_out	 => Address_out	
				--WriteRegister_out => WriteReg_out 
			);
			
			
end Behavioral;