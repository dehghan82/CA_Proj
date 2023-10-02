library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;  
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
														   
														   
entity inst_fetch is
	port(
		
		clk		: in std_logic;					
		rst		: in std_logic;					
		branch		: in std_logic;	
		jump :in std_logic;
		branch_input	: in std_logic_vector(15 downto 0);	
		inst 	: out std_logic_vector(15 downto 0);	 --instruction to run right now
		next_inst_addr	: out std_logic_vector(15 downto 0)	--address of next instruction
		
	);
end inst_fetch;

architecture inst_fetch_beh of inst_fetch is	




	component pc_reg is 
		
		port(
			clk		: in	std_logic;						
		    rst		: in	std_logic;			
		    input_addr		: in	std_logic_vector(15 downto 0);	
		    output_addr	: out	std_logic_vector(15 downto 0)	
		);
	end component pc_reg;

	component IF_ID_reg is   
		port(
			
	clock   : in std_logic ; 	 		
	reset : in std_logic;
	--IF_ID_enable :in std_logic;
	input_nxt_line : in std_logic_vector(15 downto 0) ; 
	input_Instruction : in std_logic_vector(15 downto 0) ; 
	output_nxt_line : out std_logic_vector(15 downto 0) ; 
	output_instruction : out std_logic_vector(15 downto 0)  
	);
		
	end component IF_ID_reg;

	component instruction_memory is
		port(
		clk : in std_logic;
		reset : in std_logic;
    		addr : in std_logic_vector(15 downto 0);
    		address_data : out std_logic_vector(15 downto 0)
		);
	end component instruction_memory;


	signal pc_val	: std_logic_vector (15 downto 0);	--	 old pc
	signal pc_pluse2	: std_logic_vector (15 downto 0);	-- Carry out
	signal mux1_output	: std_logic_vector (15 downto 0);	-- MUX_PC  
	signal now_inst		: std_logic_vector (15 downto 0);	
	signal jump_res :std_logic_vector(15 downto 0);	 
	signal shift_jump :std_logic_vector(12 downto 0);
	
begin
	pc_plus2_jump: process(clk)
	begin
		
		pc_pluse2 <= pc_val + "0000000000000010";
		shift_jump <= now_inst(11 downto 0) & '0';
		jump_res <= std_logic_vector(pc_pluse2(15 downto 13) & shift_jump(12 downto 0));
	end process pc_plus2_jump;
	mux1:
	process(branch,jump,pc_pluse2,branch_input,jump_res)
		begin
			if( branch = '0' and jump='0' ) then
				mux1_output <= pc_pluse2(15 downto 0); 
			elsif (branch= '1' and jump='0')  then
				mux1_output <= branch_input; 
				
			elsif (branch ='0' and jump='1')  then
				mux1_output <= jump_res;
				
			end if;
		end process mux1; 

	PC : 
		pc_reg port map(
			clk		=> clk,					
		    rst		=>rst,			
		    input_addr	=>	mux1_output,	
		    output_addr	=> pc_val
		);
	
	INST_MEM:
		instruction_memory port map(
			clk		=>	clk,
			addr 	=>	pc_val,
			address_data	=> 	now_inst,
			reset =>rst
		);
		
	IF_ID_REGister:
		IF_ID_reg port map(
			clock		=> clk,
			reset		=> rst,
			input_nxt_line	=> pc_pluse2(15 downto 0),
			input_instruction	=> now_inst,
			output_nxt_line	=> inst,
			output_instruction	=> next_inst_addr
		);	

end inst_fetch_beh;