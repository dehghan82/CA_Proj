library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity EX_MEM_reg is 
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
		
		inst_nxt_out :	out std_logic_vector (15 downto 0);	
		--carry_o		:	out std_logic;
       	--overflow_o	:	out std_logic;
       	--zero_o		:	out std_logic;
       	--negative_o	:out 	std_logic;
		alu_result_o	:	out std_logic_vector(15 downto 0);	
		write_data_in_mem_o			:	out std_logic_vector (15 downto 0);	
		write_register_addr_o	:	out std_logic_vector (3 downto 0)
	        
        );
end EX_MEM_reg;

architecture EX_MEM_reg_beh of EX_MEM_reg is        
begin 

	SYNC_EX_MEM:
	  process(clk, rst)
	  begin
		if rst = '1' then
	        reg_write_out <= '0';
			mem_to_reg_out <='0';
			branch_out <= '0';
			mem_read_out <= '0';
			mem_write_out <= '0';
			
			inst_nxt_out	<= "0000000000000000";
			--carry_o		<= '0';
	       	--overflow_o	<= '0';
	       	--zero_o		<= '0';
	       	--negative_o	<= '0';
			alu_result_o <= "0000000000000000";
			write_data_in_mem_o	 <= "0000000000000000";	
			write_register_addr_o <= "0000";
		elsif rising_edge(clk) then
	    	reg_write_out <= reg_write;
			mem_to_reg_out <= mem_to_reg;
			branch_out <= branch;
			mem_read_out <= mem_read;
			mem_write_out <= mem_write;
			--reg_dst_out : out std_logic;
			inst_nxt_out <= inst_nxt_in;
			--carry_o	<=	carry;
	       	--overflow_o	<= overflow;
	       	--zero_o	<=	zero;
	       	--negative_o	<= negative;
			alu_result_o	<= alu_result;
			write_data_in_mem_o		<= write_data_in_mem ;
			write_register_addr_o	<= write_register_addr;	
		        
		end if;
	  end process; 

end EX_MEM_reg_beh;