library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;



entity ID_EX_reg is 
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
		ba_write : in std_logic;
		add_type2 : in std_logic;
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
		alu_src2_out : out std_logic;
		clear_reg_out : out std_logic;
		clear_mem_out : out std_logic;
		ba_write_out : out std_logic;
		add_type2_out : out std_logic ;
		mov_ba_data_out : out std_logic_vector(15 downto 0) ;
		iformat_data_out : out std_logic_vector(15 downto 0);
		type1_out : out std_logic
		

	);
end ID_EX_reg;

architecture ID_EX_register of ID_EX_reg is
begin
	SYNC_ID_EX:
	  process(clk,rst)
	  begin
		if rst = '1' then
				output_nxt_line		<= (others => '0');
				addr_offset_out <= (others =>'0');
				rs_output		<= (others => '0');
				rd_output		<= (others => '0');
				register1_val_out<= (others => '0');
				register2_val_out	<= (others => '0');
				
				reg_write_out <= '0';
				mem_to_reg_out <= '0';
				branch_out <= '0';
				mem_read_out <= '0';
				mem_write_out<= '0';
				reg_dst_out <= '0';
				alu_op_out <=(others => '0');
				alu_src1_out <= '0';
				alu_src2_out <= '0';
				clear_reg_out <= '0';
				clear_mem_out <= '0';
				ba_write_out <= '0';
				add_type2_out <= '0';
		elsif rising_edge(clk) then
				output_nxt_line		<= input_nxt_line;
				addr_offset_out <= addr_offset_in;
				rs_output		<= rs_input;
				rd_output		<= rd_input;	
				register1_val_out	 		<= register1_val_in;
				register2_val_out 			<= register2_val_in;
				
				reg_write_out <=reg_write ;
				mem_to_reg_out <= mem_to_reg;
				branch_out <= branch;
				mem_read_out <= mem_read;
				mem_write_out<= mem_write;
				reg_dst_out <= reg_dst;
				alu_op_out <= alu_op;
				alu_src1_out <= alu_src1;
				alu_src2_out <= alu_src2;
				clear_mem_out <= clear_mem;
				clear_reg_out <= clear_reg;
				BA_write_out <= BA_write;
				add_type2_out <= add_type2;
				mov_ba_data_out <= mov_ba_data;
				type1_out <=  type1;
		end if;
	  end process;

end ID_EX_register;