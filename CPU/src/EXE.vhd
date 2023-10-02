library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;


entity EXE is
	port( 
		
     		clk			: in std_logic;					
			rst			: in std_logic;					
			reg_write : in std_logic;
			mem_to_reg : in std_logic;
			branch :in std_logic;
			mem_read :in std_logic;
			mem_write: in std_logic;		
		reg_dst : in std_logic;
		alu_op : in std_logic_vector(3 downto 0);
		alu_src1: in std_logic;	
		alu_src2 : in std_logic;
		clear_mem : in std_logic;
		clear_reg : in std_logic;
		add_type2 : in std_logic;
		type1 : in std_logic;
		inst_nxt_in		: in std_logic_vector (15 downto 0);	
		rs	 		: in std_logic_vector (15 downto 0);	
	    rd 			: in std_logic_vector (15 downto 0);	
		offset			: in std_logic_vector (15 downto 0);
		rs_addr			: in std_logic_vector (3 downto 0);
		rd_addr		: in std_logic_vector (3 downto 0);				 				
		mov_ba_data : in std_logic_vector(15 downto 0);
		iformat_data : in std_logic_vector(15 downto 0);
		ba_write : in std_logic;
		
		
		
		--Salidas
		reg_write_o : out std_logic;
		mem_to_reg_o : out std_logic;
		branch_o :out std_logic;
		mem_read_o :out std_logic;
		mem_write_o: out std_logic;
		inst_nxt_out		: out std_logic_vector (15 downto 0);	
		reg_dst_o : out std_logic;
		alu_op_o : out std_logic_vector(3 downto 0);
		alu_src_o: out std_logic;	     					
		alu_result		: out std_logic_vector(15 downto 0);	
		carry_out	   :out std_logic;
		overflow_out :out std_logic;
		zero_out :out std_logic;
		negative_out : out std_logic;
		write_data_in_mem		:	out std_logic_vector (15 downto 0);	
		write_register_addr	:	out std_logic_vector (3 downto 0)	
	);
end EXE;

architecture exe_beh of EXE is	

	
	component ALU_VHDL is 
		port(
			input1 : in std_logic_vector(15 downto 0); 
			input2 : in std_logic_vector(15 downto 0);
			 opcode : in std_logic_vector(3 downto 0); -- function select
			 alu_result: out std_logic_vector(15 downto 0); -- ALU Output Result
			 zero: out std_logic; -- Zero Flag
			 overflow: out std_logic ;-- Overflow Flag 
			 carry_out : out std_logic;
			 N: out std_logic
 );
	end component ALU_VHDL;

	
component status_reg is
  port (
  clk : in std_logic;
  rst : in std_logic;
    result : in std_logic_vector(15 downto 0); 
	zero : in std_logic;
	negative : in std_logic;
	carry : in std_logic;
	overflow : in std_logic;
	

	zero_o : out std_logic;
	negative_o : out std_logic;
	carry_o : out std_logic;
	overflow_o: out std_logic;
    status_reg : out std_logic_vector(15 downto 0)
  );
end component status_reg;
--	
	component EX_MEM_reg is  
	    port(
		
		clk		:	in STD_LOGIC;					
		rst		:	in STD_LOGIC;					
		reg_write : in std_logic;
		mem_to_reg : in std_logic;
		branch :in std_logic;
		mem_read :in std_logic;
		mem_write: in std_logic;
		inst_nxt_in	:	in std_logic_vector (15 downto 0);	
		--carry		:	in std_logic;
       	--overflow	:	in std_logic;
       	--zero		:	in std_logic;
       	--negative	:in 	std_logic;				
		alu_result	:	in std_logic_vector (15 downto 0);	
		write_data_in_mem		:	in std_logic_vector (15 downto 0);	
		write_register_addr	:	in std_logic_vector (3 downto 0);		
		clear_mem : in std_logic;
		clear_reg : in std_logic;
		add_type2 : in std_logic;
		
        reg_write_out : out std_logic;
		mem_to_reg_out : out std_logic;
		branch_out :out std_logic;
		mem_read_out :out std_logic;
		mem_write_out: out std_logic;
		--reg_dst_out : out std_logic;
		inst_nxt_out :	out std_logic_vector (15 downto 0);	
		--carry_o		:	out std_logic;
       	--overflow_o	:	out std_logic;
       	--zero_o		:	out std_logic;
       	--negative_o	:out 	std_logic;
		alu_result_o	:	out std_logic_vector(15 downto 0);	
		write_data_in_mem_o			:	out std_logic_vector (15 downto 0);
		write_register_addr_o	:	out std_logic_vector (3 downto 0)	
	        
        );
	end component EX_MEM_reg;
	

	
	signal ALU_IN_AUX	: std_logic_vector(3 downto 0);
	signal PC_ADDR_AUX	: STD_LOGIC_VECTOR (15 downto 0); 
	signal RT_RD_ADDR_AUX	: STD_LOGIC_VECTOR (3 downto 0);
	signal OFFSET_SHIFT2	: STD_LOGIC_VECTOR (3 downto 0);
	signal ALU_REG_IN	: STD_LOGIC_VECTOR (15 downto 0); 
	signal ALU_RES_AUX	: STD_LOGIC_VECTOR (15 downto 0); 
	--signal ALU_FLAGS_AUX	: ALU_FLAGS; 
	signal zero_aux :std_logic;
	signal overflow_aux : std_logic;
	signal carry_aux : std_logic;
	signal N_aux :std_logic; 
	signal mux11_output: std_logic_vector(15 downto 0);
	signal mux12_output : std_logic_vector(15 downto 0); 
	signal mux13_output :std_logic_vector(15 downto 0);
	signal BA :std_logic_vector(15 downto 0);
	--status register to exe mem reg signals	
	signal zero_aux2 :std_logic;
	signal overflow_aux2 : std_logic;
	signal carry_aux2 : std_logic;
	signal N_aux2 :std_logic; 
	signal status_reg_aux: std_logic_vector(15downto 0);
begin
	--OFFSET_SHIFT2 <= OFFSET(29 downto 0) & "00";	
	
BA_MOV:process(ba_write)
begin 
	if ba_write='1' then 
		BA <= mov_ba_data;
	end if;
	end process BA_MOV;
	
	
	
MUX11:																												
   process(	iformat_data,type1)
   begin
	   if type1 ='1' then
		 mux11_output <=  iformat_data ;
	   elsif type1 ='0' then
		   
		 mux11_output <= iformat_data(14 downto 0) & '0';													  
		 
		 
		 
	   end if;
	   
	   end process MUX11;
	   
		   
		   

	
	MUX12:
		process(alu_src2,rs,mux11_output) is
    		begin
    	 		if( alu_src2 = '0') then
    	 			mux12_output <= rs; 
	    	 	else
    		 		mux12_output <= mux11_output;
    		 	end if;
    	 	end process MUX12;
	 
	MUX13:
		process(alu_src1,rd,ba)
		begin
			if( alu_src1 = '0') then
				mux13_output <= rd; 
			else
				mux13_output <= ba;
			end if;
		end process MUX13;
	 
	ALU_MIPS: 	 

		ALU_VHDL 
		port map(
			input1	=> mux13_output,
			input2	=> mux12_output,
			opcode	=> alu_op,
			alu_result	=> ALU_RES_AUX,
			zero => zero_aux,		
			carry_out => carry_aux,
			overflow => overflow_aux,
			N => N_aux
		);
	
		
	Status_register:
	status_reg port map (
	
	clk => clk,
	rst => rst,
    result => alu_res_aux,
	zero => zero_aux,
	negative => N_aux,
	carry => carry_aux,
	overflow => overflow_aux ,
	

	zero_o => zero_out,
	negative_o => N_aux2,
	carry_o =>carry_aux2,
	overflow_o =>overflow_aux2,
    status_reg  => status_reg_aux
	

	
	);
		
	
		
	EX_MEM_REGS:
	 
	EX_MEM_REG port map(
			
			clk		=> clk,
			rst		=> rst,
			reg_write =>reg_write,
			mem_to_reg =>mem_to_reg,
			branch =>branch,
			mem_read =>mem_read,
			mem_write =>mem_write,
			inst_nxt_in	=> inst_nxt_in,
			--carry		=>carry_aux,
	       	--overflow	=> overflow_aux,
	       	--zero	=>	zero_aux,
	       	--negative =>	N_aux,
			alu_result	=> ALU_RES_AUX,	
			write_data_in_mem	=>	rd ,
			write_register_addr	=>	RT_RD_ADDR_AUX,
			clear_reg =>clear_reg,
			clear_mem => clear_mem,
			add_type2 => add_type2,
			
			reg_write_out => reg_write_o,
			mem_to_reg_out => mem_to_reg_o,
			branch_out =>branch_o  ,
			mem_read_out =>mem_read_o,
			mem_write_out =>mem_write_o,
			inst_nxt_out 	=> inst_nxt_out,
			--carry_o		=> carry_out,
       	--overflow_o	=> overflow_out,
       	--zero_o		=> zero_out,
       	--negative_o	=> negative_out,
			alu_result_o	=> alu_result,
				
			write_data_in_mem_o		=> write_data_in_mem,
		write_register_addr_o	  => write_register_addr
		);

end exe_beh;
