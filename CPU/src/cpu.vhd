															library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
	port(
		clk : in std_logic;
		reset : in std_logic
	);
end CPU;

architecture Behavioral of CPU is	
	component inst_fetch is
		port(
			clk		: in std_logic;					
			rst		: in std_logic;	
			branch		: in std_logic;		 
			jump :in std_logic;
			branch_input	: in std_logic_vector(15 downto 0);
			
			inst 	: out std_logic_vector(15 downto 0);	
			next_inst_addr	: out std_logic_vector(15 downto 0)
			);
	end component inst_fetch;	   
	
	component inst_decode is
		port(
			clk,rst			:	in	std_logic;	
			now_inst		:	in	std_logic_vector (15 downto 0);
			nxt_inst_in		:	in	std_logic_vector (15 downto 0);
			reg_write		:	in	std_logic;						 
			write_data		:	in	std_logic_vector (15 downto 0);
			write_reg 		:	in	std_logic_vector (3 downto 0);
			zero_in : in std_logic;
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
	end component inst_decode;
	
	component EXE is
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
	end component EXE;
		 
	component Memory is
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
	end component Memory;
	
	component Write_Back is
		port(
		  	clk : in std_logic;	 
			reset : in std_logic;  
			RegWrite_in : in std_logic;
			MemToReg_in : in std_logic;
			ReadData : in std_logic_vector(15 downto 0);
			Address : in std_logic_vector(15 downto 0);
			
			write_data : out std_logic_vector(15 downto 0); 
		    reg_write_out : out std_logic 
		);	
	end component Write_Back; 
	
	-- signals
		-- IF/ID
		signal NewPCAddr_IfId_CPUport : std_logic_vector (15 downto 0);
		signal Inst_IfId_CPUport : std_logic_vector (15 downto 0);
		
		-- WB/ID
		signal RegWrite_WbId_CPUport	: std_logic;
		signal WriteRegAddr_WbId_CPUport : std_logic_vector (3 downto 0);
		signal WriteData_WbId_CPUport : std_logic_vector (15 downto 0);	 
		
		-- ID/IF
		signal Jump_IdIf_CPUport : std_logic;
		signal Branch_in_IdIf_CPUport : std_logic_vector(15 downto 0);
		
		-- ID/EX
		signal NewPCAddr_IdExe_CPUport : std_logic_vector (15 downto 0);
		signal Offset_IdExe_CPUport : std_logic_vector (15 downto 0);
		signal rsAddr_IdExe_CPUport : std_logic_vector (3 downto 0); 
		signal rs_IdExe_CPUport : std_logic_vector (15 downto 0);
		signal rt_IdExe_CPUport : std_logic_vector (15 downto 0);
		signal rdAddr_IdExe_CPUport : std_logic_vector (3 downto 0);
		signal RegWrite_IdExe_CPUport : std_logic;
		signal MemtoReg_IdExe_CPUport : std_logic;  
		signal Branch_IdExe_CPUport : std_logic;
		signal MemRead_IdExe_CPUport : std_logic;	
		signal MemWrite_IdExe_CPUport	: std_logic;
		signal RegDst_IdExe_CPUport : std_logic;
		signal ALUOp_IdExe_CPUport : std_logic_vector (3 downto 0);
		signal ALUSrc1_IdExe_CPUport : std_logic;
		signal ALUSrc2_IdExe_CPUport : std_logic;
		signal Clear_mem_IdExe_CPUport : std_logic;
		signal Clear_reg_IdExe_CPUport : std_logic;
		signal Add_type2_IdExe_CPUport : std_logic;
		signal Type1_IdExe_CPUport : std_logic;	
		signal Mov_ba_data_IdExe_CPUport : std_logic_vector(15 downto 0);
		signal Iformat_data_IdExe_CPUport : std_logic_vector(15 downto 0);
		signal Ba_write_IdExe_CPUport : std_logic;
		
		-- EX/MEM
		signal RegWrite_ExeMem_CPUport	: std_logic;
		signal MemtoReg_ExeMem_CPUport	: std_logic;
		signal Branch_ExeMem_CPUport :	std_logic;
		signal MemRead_ExeMem_CPUport : std_logic;	
		signal MemWrite_ExeMem_CPUport	: std_logic;
		signal NewPCAddr_ExeMem_CPUport : std_logic_vector (15 downto 0);
		signal ALU_Carry_ExeMem_CPUport : std_logic;
       	signal ALU_Overflow_ExeMem_CPUport :	std_logic;
       	signal ALU_Zero_ExeMem_CPUport :	std_logic;
       	signal ALU_Negative_ExeMem_CPUport :	std_logic;
		signal ALU_Result_ExeMem_CPUport : std_logic_vector (15 downto 0);
		signal rt_ExeMem_CPUport : std_logic_vector (15 downto 0);
		signal rt_rd_Addr_ExeMem_CPUport : std_logic_vector (3 downto 0);
		
		 -- MEM/IF
		signal PCSrc_MemIf_CPUport : std_logic;
		signal NewPCAddr_MemIf_CPUport : std_logic_vector (15 downto 0);
		
		-- MEM/WB
		signal RegWrite_MemWb_CPUport : std_logic;
		signal MemtoReg_MemWb_CPUport : std_logic;
		signal ReadData_MemWb_CPUport : std_logic_vector (15 downto 0);
		signal Address_MemWb_CPUport : std_logic_vector (15 downto 0);
		signal WriteRegisterOut_MemWb_CPUport : std_logic_vector (3 downto 0);
	
			
	-- port map
	begin 
		--process(clk, reset)
--		begin
--			reset <= '1';
--			wait for 100ns;
--			reset <= '0';  
--		end process;
		
		
		
		
		IFetch:
			inst_fetch port map
			( 
				clk	=> clk,		
				rst	=> reset,
				branch => Branch_IdExe_CPUport,		 
				jump =>	Jump_IdIf_CPUport,
				branch_input =>	Branch_in_IdIf_CPUport,
				--pcsrc_sig => PCSrc_MemIf_CPUport,			
				--one_mux_input => NewPCAddr_MemIf_CPUport, 
				
				inst => Inst_IfId_CPUport,
				next_inst_addr => NewPCAddr_IfId_CPUport
			);	
			
		ID:	 
			inst_decode port map
			(	
			clk => clk,															 
			
				rst	=> reset,
				now_inst =>	Inst_IfId_CPUport,
				nxt_inst_in	=> NewPCAddr_IfId_CPUport,
				reg_write => RegWrite_WbId_CPUport,		 
				write_data => WriteData_WbId_CPUport,
				write_reg => WriteRegAddr_WbId_CPUport,
				zero_in =>ALU_Zero_ExeMem_CPUport,
				nxt_inst_out =>	NewPCAddr_IdExe_CPUport,
				addr_offset_o => Offset_IdExe_CPUport,
				rs_o => rsAddr_IdExe_CPUport,
				rd_o => rdAddr_IdExe_CPUport,
				register1_val_o => rt_IdExe_CPUport,
				register2_val_o	=> rs_IdExe_CPUport,
				reg_write_out => RegWrite_IdExe_CPUport,
				mem_to_reg_out => MemtoReg_IdExe_CPUport,
				branch_out => Branch_IdExe_CPUport,
				jump_out => Jump_IdIf_CPUport,
				branching_out => Branch_in_IdIf_CPUport,
				mem_read_out =>	MemRead_IdExe_CPUport,
				mem_write_out => MemWrite_IdExe_CPUport,
				reg_dst_out => RegDst_IdExe_CPUport,
				alu_op_out => ALUOp_IdExe_CPUport, 	
				alu_src1_out => ALUSrc1_IdExe_CPUport,
				alu_src2_out => ALUSrc2_IdExe_CPUport,
				clear_mem_out => Clear_mem_IdExe_CPUport,
				clear_reg_out => Clear_reg_IdExe_CPUport,
				ba_write_out => Ba_write_IdExe_CPUport,
				add_type2_out => Add_type2_IdExe_CPUport,
				mov_ba_data_out => Mov_ba_data_IdExe_CPUport, 
			    iformat_data_out => Iformat_data_IdExe_CPUport,
				type1_out => Type1_IdExe_CPUport
				
				--alu_src_out => ALUSrc_IdExe_CPUport
			); 
			
		EXEC:
			EXE port map
			(  
				clk	=> clk,
				rst	=> reset,		
				reg_write => RegWrite_IdExe_CPUport,
				mem_to_reg => MemtoReg_IdExe_CPUport,
				branch => Branch_IdExe_CPUport,
				mem_read =>	MemRead_IdExe_CPUport,
				mem_write => MemWrite_IdExe_CPUport,
				reg_dst => RegDst_IdExe_CPUport,
				alu_op => ALUOp_IdExe_CPUport,
				--alu_src => ALUSrc_IdExe_CPUport, 	
				alu_src1 =>	ALUSrc1_IdExe_CPUport,
				alu_src2 =>	ALUSrc2_IdExe_CPUport,
				clear_mem => Clear_mem_IdExe_CPUport,
				clear_reg => Clear_reg_IdExe_CPUport,
				add_type2 => Add_type2_IdExe_CPUport,
				type1 => Add_type2_IdExe_CPUport,
				inst_nxt_in	=> NewPCAddr_IdExe_CPUport,
				rs => rs_IdExe_CPUport,
				rd => rt_IdExe_CPUport,
			     --rt => rt_IdExe_CPUport,
				offset => Offset_IdExe_CPUport,
				rs_addr => rsAddr_IdExe_CPUport,
				rd_addr	=> rdAddr_IdExe_CPUport,
				mov_ba_data => Mov_ba_data_IdExe_CPUport,
				iformat_data =>	Iformat_data_IdExe_CPUport,
				ba_write =>	Ba_write_IdExe_CPUport,
						     	      
				reg_write_o => RegWrite_ExeMem_CPUport,
				mem_to_reg_o => MemtoReg_ExeMem_CPUport,
				branch_o =>	Branch_ExeMem_CPUport,
				mem_read_o => MemRead_ExeMem_CPUport,
				mem_write_o => MemWrite_ExeMem_CPUport,
				inst_nxt_out =>	NewPCAddr_ExeMem_CPUport,
				--reg_dst_o =>
				--alu_op_o =>
				--alu_src_o =>   				
				alu_result => ALU_Result_ExeMem_CPUport,
				carry_out => ALU_Carry_ExeMem_CPUport,
				overflow_out =>	ALU_Overflow_ExeMem_CPUport,
				zero_out =>	ALU_Zero_ExeMem_CPUport,
				negative_out =>	ALU_Negative_ExeMem_CPUport,
				write_data_in_mem => rt_ExeMem_CPUport,
				write_register_addr => rt_rd_Addr_ExeMem_CPUport 
				
			
			--reg_dst_o : out std_logic;
--			alu_op_o : out std_logic_vector(3 downto 0);
--			alu_src_o: out std_logic;	     					
			);
		
		MEM:
			Memory port map(
				clk => clk,
				reset => reset,
				RegWrite_in => RegWrite_ExeMem_CPUport,
				MemtoReg_in => MemtoReg_ExeMem_CPUport,
				zeroflag =>	ALU_Zero_ExeMem_CPUport,
				New_PC_Address => NewPCAddr_ExeMem_CPUport,
				Addres => ALU_Result_ExeMem_CPUport,
				WriteData => rt_ExeMem_CPUport,
				WriteReg => rt_rd_Addr_ExeMem_CPUport,
				Branch => Branch_ExeMem_CPUport,
				MemRead => MemRead_ExeMem_CPUport,
				MemWrite => MemWrite_ExeMem_CPUport,
				clear_reg => Clear_reg_IdExe_CPUport,
				clear_mem => Clear_mem_IdExe_CPUport,
				add_type2 => Add_type2_IdExe_CPUport,
				
				RegWrite_Out =>	RegWrite_MemWb_CPUport,
				MemtoReg_Out => MemtoReg_MemWb_CPUport,
				Read_Data => ReadData_MemWb_CPUport,
				Address_out => Address_MemWb_CPUport,
				WriteReg_out =>	WriteRegisterOut_MemWb_CPUport,
				New_PC_Address_out => NewPCAddr_MemIf_CPUport,
				PCSrc => PCSrc_MemIf_CPUport	   
			);
			
		WB:
			WRITE_back port map(
				clk => clk,
				reset => reset,
				RegWrite_in => RegWrite_MemWb_CPUport,
				MemToReg_in => MemtoReg_MemWb_CPUport,
				ReadData =>	ReadData_MemWb_CPUport,
				Address => Address_MemWb_CPUport,
				--write_register => WriteRegisterOut_MemWb_CPUport,
				
				--write_register_out => WriteRegAddr_WbId_CPUport,
				write_data => WriteData_WbId_CPUport,
				reg_write_out => RegWrite_WbId_CPUport 
			);
			

end Behavioral;
