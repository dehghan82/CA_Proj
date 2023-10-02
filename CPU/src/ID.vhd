library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity inst_decode is
	port(
			clk,rst			:	in	std_logic;	
			
			zero_in : in std_logic;
			now_inst		:	in	std_logic_vector (15 downto 0);
			nxt_inst_in		:	in	std_logic_vector (15 downto 0);
				  
			reg_write		:	in	std_logic;						 
			write_data		:	in	std_logic_vector (15 downto 0);
			write_reg 		:	in	std_logic_vector (3 downto 0);
			
			nxt_inst_out		:	out	std_logic_vector (15 downto 0);
			
			addr_offset_o			: out	std_logic_vector (15 downto 0);
			rs_o,rd_o	: out	std_logic_vector (3 downto 0);
			register1_val_o,register2_val_o	 : out	std_logic_vector (15 downto 0);
						
			reg_write_out : out std_logic;
			mem_to_reg_out : out std_logic;
			branch_out :out std_logic;
			jump_out :out std_logic;--new
			branching_out :out std_logic_vector(15 downto 0); 			
			mem_read_out :out std_logic;
			mem_write_out: out std_logic;
			reg_dst_out : out std_logic;
			alu_op_out : out std_logic_vector(3 downto 0);
			alu_src1_out: out std_logic	;
			alu_src2_out : out std_logic;
			clear_mem_out :out std_logic;
			clear_reg_out : out std_logic;
			ba_write_out: out std_logic;
			add_type2_out : out std_logic;
			mov_ba_data_out : out std_logic_vector(15 downto 0) ;
		    iformat_data_out : out std_logic_vector(15 downto 0);
			type1_out : out std_logic
	);
end inst_decode;

architecture inst_dec_beh of inst_decode is	

 
	component register_file is 
	port(
		clk      : in  std_logic;
        reset    : in  std_logic;
		enable_write : in std_logic;
        write_register   : in  std_logic_vector(3 downto 0);
        write_data  : in  std_logic_vector(15 downto 0);
        read_register1 : in  std_logic_vector(3 downto 0);
        read_register2 : in  std_logic_vector(3 downto 0);
        read_data1: out std_logic_vector(15 downto 0);
        read_data2: out std_logic_vector(15 downto 0)    
	);
	end component register_file;


	component Controller is
	port( 
		
	  opcode: in std_logic_vector(3 downto 0);
	  reset: in std_logic;
	  alu_op: out std_logic_vector(3 downto 0);
	  reg_dst,mem_to_reg,jump,branch,mem_read,mem_write,alu_src1,alu_src2,reg_write,sign_or_zero,clear_reg,clear_mem,add_type2,BA_write,type1 : out std_logic
	  
	);
	end component Controller;


	component ID_EX_reg is 
	port(
		
		clk,rst	: in	std_logic;				
						
		input_nxt_line	: in	std_logic_vector (15 downto 0);	--pc+2 or new_pc
		addr_offset_in			: in	std_logic_vector (15 downto 0);-- offset of instruction
		rs_input,rd_input	: in	std_logic_vector (3 downto 0);
		register1_val_in,register2_val_in	 : in	std_logic_vector (15 downto 0);
		
		reg_write : in std_logic;
		mem_to_reg : in std_logic;
		branch :in std_logic;
		mem_read :in std_logic;
		mem_write: in std_logic;
		reg_dst : in std_logic;
		alu_op : in std_logic_vector(3 downto 0);
		alu_src1: in std_logic;
		alu_src2 : in std_logic;
		clear_reg : in std_logic;
		clear_mem : in std_logic;
		add_type2 : in std_logic;
		ba_write : in std_logic;
		mov_ba_data : in std_logic_vector(15 downto 0);
		iformat_data : in std_logic_vector(15 downto 0);
		type1 : in std_logic;

		output_nxt_line			: out	std_logic_vector (15 downto 0);
		addr_offset_out			: out	std_logic_vector (15 downto 0);-- offset of instruction
		rs_output,rd_output			: out	std_logic_vector (3 downto 0);
		register1_val_out,register2_val_out	 			: out	std_logic_vector (15 downto 0);
		
		reg_write_out : out std_logic;
		mem_to_reg_out : out std_logic;
		branch_out :out std_logic;
		
		mem_read_out :out std_logic;
		mem_write_out: out std_logic;
		reg_dst_out : out std_logic;
		alu_op_out : out std_logic_vector(3 downto 0);
		alu_src1_out: out std_logic;	
		alu_src2_out :out std_logic;
		clear_mem_out : out std_logic;
		clear_reg_out : out std_logic;
		ba_write_out : out std_logic;
		add_type2_out : out std_logic;
		mov_ba_data_out : out std_logic_vector(15 downto 0) ;
		iformat_data_out : out std_logic_vector(15 downto 0);
		type1_out : out std_logic

	);
end component ID_EX_reg;

	signal offset_bus	: std_logic_vector (15 downto 0);
	signal rs_bus		: std_logic_vector (15 downto 0);
	signal rd_bus		: std_logic_vector (15 downto 0);

	signal regwrite :std_logic;
	signal memtoreg :std_logic;
	signal branch :	 std_logic;
	signal memread : std_logic;
	signal memwrite : std_logic;
	signal regdst : std_logic;
	signal aluop :std_logic_vector(3 downto 0 );
	signal alusrc1 : std_logic;
	signal alusrc2 : std_logic;
	signal clearmem : std_logic;
	signal clearreg : std_logic;
	signal addtype2 : std_logic	;
   	signal BAwrite : std_logic;
	signal mohasebe: std_logic_vector(15 downto 0);	 
	signal mohasebe3 : std_logic_vector(15 downto 0);
	signal mohasebe2 : std_logic_vector(15 downto 0);
	signal type1 : std_logic; 
	signal branch_final : std_logic;
	--siganl final_branch : std_logic;
begin

	

		execution :   process(clk)
			begin 
				mohasebe <= "0000" & now_inst(11 downto 0);
				mohasebe2 <= "00000000" & now_inst(7 downto 0);
				mohasebe3 <= mohasebe(14 downto 0) & '0'; 
				mohasebe3 <=std_logic_vector ((mohasebe3) + (nxt_inst_in));
				branching_out<= mohasebe3;
				
			
			end process execution;
	REGS: 
	register_file port map(
			clk 		=> clk,
			reset		=> rst,
			enable_write		=> reg_write,
			read_register2 	=> now_inst(7 downto 4),--rs
			read_register1 	=> now_inst(11 downto 8),--rd
			write_register 	=> now_inst(11 downto 8),
			write_data	=> write_data,
			read_data1 	=> rd_bus,
            read_data2 	=> rs_bus
		);
     
		
		
	CTRL : 
		Controller port map(
			--Entrada 	
			opcode		=> now_inst(15 downto 12),--OP_A,
			--Salidas				
			 reset =>rst,
			 
	  --reset: in std_logic;

			
			reg_write	=> regwrite,
			mem_to_reg	=> memtoreg,
			branch		=> branch,
			mem_read		=> memread,
			mem_write	=> memwrite,
			reg_dst		=> regdst,
			alu_src1		=> alusrc1,
			alu_src2 => alusrc2,
			clear_reg => clearreg,
			clear_mem => clearmem,
			ba_write => bawrite,
			add_type2 => addtype2,
		  	alu_op  => aluop,
			type1 => type1
		);
	


--
--	offset_bus	<=  '00000000' & now_inst(7 downto 0)
--				when now_inst(7) = '0'
--					else  '11111111' & now_inst(15 downto 0);
		execution2 :   process(branch)
			begin 
				branch_final <= branch and (not(zero_in));
				
			
			end process execution2; 
       

	ID_EX_REGS:
		ID_EX_reg port map(
	  
		clk	=>clk,				
		rst =>rst,			
		input_nxt_line	=> nxt_inst_in,
		addr_offset_in	=> offset_bus,
		rd_input => now_inst(11 downto 8),
		rs_input => now_inst(7 downto 4),
		register1_val_in => rs_bus,
		register2_val_in => rd_bus,
		reg_write => regwrite,
		mem_to_reg => memtoreg,
		branch => branch,
		mem_read => memread,															
		mem_write =>memwrite,
		reg_dst =>regdst,
		alu_op => aluop	,
		alu_src1 => alusrc1,
		alu_src2 => alusrc2,
		clear_mem => clearmem,
		clear_reg => clearreg,
		add_type2 => addtype2,
		ba_write => bawrite,
		mov_ba_data => mohasebe,
		iformat_data => mohasebe2,
		type1 => type1,
		

		output_nxt_line	=> nxt_inst_out,
		addr_offset_out	=>addr_offset_o,
		rs_output	=> rs_o,
		rd_output =>rd_o,
		register1_val_out => register1_val_o,
		register2_val_out => register2_val_o,
		reg_write_out => reg_write_out,
		mem_to_reg_out => mem_to_reg_out,
		branch_out =>branch_final,
		mem_read_out =>mem_read_out,
		mem_write_out => mem_write_out,
		reg_dst_out => reg_dst_out,
		alu_op_out => alu_op_out,
		alu_src1_out => alu_src1_out,
		alu_src2_out => alu_src2_out,
		clear_mem_out => clear_mem_out,
		clear_reg_out => clear_reg_out,
		ba_write_out => ba_write_out,
		add_type2_out => add_type2_out,
		mov_ba_data_out => mov_ba_data_out,
		iformat_data_out => iformat_data_out,
		 type1_out => type1_out



		);	

end inst_dec_beh;