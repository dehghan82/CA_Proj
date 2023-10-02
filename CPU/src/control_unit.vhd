library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity Controller is
port (
	  opcode: in std_logic_vector(3 downto 0);
	  reset: in std_logic;
	  alu_op: out std_logic_vector(3 downto 0);
	  reg_dst,mem_to_reg,jump,branch,mem_read,mem_write,alu_src1,alu_src2,reg_write,sign_or_zero,clear_reg,clear_mem,add_type2,BA_write,type1
	  
	  
	  
	  : out std_logic
 );
end Controller;

architecture Behavioral of Controller is
	begin
	process(reset,opcode)
	begin
	 if(reset = '1') then
	   reg_dst <= '0';
	   mem_to_reg <= '0';
	   alu_op <= "0000";
	   jump <= '0';
	   branch <= '0';
	   mem_read <= '0';
	   mem_write <= '0';
	   alu_src1 <= '0';
	   alu_src2 <= '0';
	   clear_reg <= '0';
	   clear_mem <= '0';
	   ba_write <= '0';
	   add_type2 <= '0';
	   reg_write <= '0'; 
	   type1 <= '0';
	   --sign_or_zero <= '1';
	 else 
	 case opcode is
		  when "0000" => -- add d0, d1
		    reg_dst <= '1';
		    mem_to_reg <= '0';
		    alu_op <= "0000";
		    jump <= '0';
		    branch <= '0';
		    mem_read <= '0';
		    mem_write <= '0';
		    alu_src1 <= '0'; 
			alu_src2 <= '0';
		    reg_write <= '1';
			add_type2 <= '0';
			clear_reg <= '0';
			clear_mem <= '0';
			BA_write <= '0';
			type1 <= '0';
		    --sign_or_zero <= '0'; 
			
			
		  when "0001" => -- add d0, 25	-> memory(BA + 2*25)
		    reg_dst <= '1';
		    mem_to_reg <= '1';
		    alu_op <= "0001";
		    jump <= '0';
		    branch <= '0';
		    mem_read <= '1';
		    mem_write <= '0';
		    alu_src1 <= '0';
			alu_src2 <= '1';
		    reg_write <= '1';
			clear_reg <= '0';
			clear_mem <= '0'; 
			add_type2 <= '1';
			BA_write <= '0'; 
			type1 <= '0';
		    --sign_or_zero <= '0'; 
			
		  when "0010" =>-- sub d0, d1
		   reg_dst <= '1';
		   mem_to_reg <= '0';
		   alu_op <= "0010";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';
		   alu_src2 <= '0';
		   clear_mem <= '0';
		   clear_reg <= '0';  
		   add_type2 <= '1';
		   reg_write <= '1';
		   BA_write <= '0';
		   type1 <= '0';
		   --sign_or_zero <= '0';
		   
		  when "0011" =>-- addi d0, 50
		   reg_dst <= '1';
		   mem_to_reg <= '0';
		   alu_op <= "0011";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';
		   alu_src2 <= '1';
		   clear_reg <= '0';
		   clear_mem <= '0';
		   reg_write <= '1';  
		   add_type2 <= '0';
		   BA_write <= '0';
		   type1 <= '1';
		   --sign_or_zero <= '0';
		   
		  when "0101" => -- and d0, d1
		   reg_dst <= '1';
		   mem_to_reg <= '0';
		   alu_op <= "0101";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';	
		   alu_src2 <= '0';
		   clear_reg <= '0';
		   clear_mem <= '0';
		   reg_write <= '1';
		   add_type2 <= '0'; 
		   BA_write <= '0';	
		   type1 <= '0';
		   --sign_or_zero <= '0';	
		   
		  when "0110" => -- sll d0, 10
		   reg_dst <= '0';
		   mem_to_reg <= '0';
		   alu_op <= "0110";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';
		   alu_src2 <= '1';
		   clear_reg <= '0';
		   clear_mem <= '0';
		   add_type2 <= '0';
		   reg_write <= '1'; 
		   BA_write <= '0';
		   --sign_or_zero <= '0';
		   
		   when "0111" =>-- lw d0, 7
		   reg_dst <= '0';
		   mem_to_reg <= '1';
		   alu_op <= "0111";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '1';
		   mem_write <= '0';
		   alu_src1 <= '1';
		   alu_src2 <= '1';
		   clear_reg <= '0';
		   clear_mem <= '0';
		   add_type2 <= '0';
		   reg_write <= '1'; 
		   BA_write <= '0';
		   type1 <= '0';
		   --sign_or_zero <= '1';
		   
		   when "1001" => -- sw d0, 10
		   reg_dst <= '0';
		   mem_to_reg <= '1';
		   alu_op <= "1001";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '1';
		   alu_src1 <= '1';	
		   alu_src2 <= '1';
		   clear_reg <= '0';
		   clear_mem <= '0';
		   add_type2 <= '0';
		   reg_write <= '0'; 
		   BA_write <= '0';
		   type1 <= '0';
		   --sign_or_zero <= '1';
		   
		   when "1011" => -- clr d0
		   reg_dst <= '1';
		   mem_to_reg <= '0';
		   alu_op <= "1011";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '1';
		   alu_src1 <= '0';
		   alu_src2 <= '0';
		   clear_reg <= '1';
		   clear_mem <= '0';
		   add_type2 <= '0';
		   reg_write <= '1';
		   BA_write <= '0';
		   type1 <= '0';
		   --sign_or_zero <= '1';													
		   
		   when "0100" => --clear mem
		    reg_dst <= '1';
		   mem_to_reg <= '0';
		   alu_op <= "0100";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '1';
		   alu_src1 <= '1';
		   alu_src2 <= '1';
		   clear_reg <= '0';
		   clear_mem <= '1';
		   add_type2 <= '0';
		   reg_write <= '0';
		   BA_write <= '0';
		   type1 <= '0';
		   
		 when "1100" => -- mov BA, 50
		   reg_dst <= '0';
		   mem_to_reg <= '0';
		   alu_op <= "1100";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';
		   alu_src2 <= '0';
		   clear_mem <= '0';
		   clear_reg <= '0';
		   add_type2 <= '0';
		   reg_write <= '0';
		   BA_write <= '1';	
		   type1 <= '0';
		   --sign_or_zero <= '1';	 
		   
		  when "1101" => -- cmp d0, d1
		   reg_dst <= '0';
		   mem_to_reg <= '0';
		   alu_op <= "1101";
		   jump <= '0';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';
		   alu_src2 <= '0';
		   clear_reg <= '0';
		   clear_mem <= '0';
		   add_type2 <= '0';
		   BA_write <= '0';
		   
		   reg_write <= '0';
		   --sign_or_zero <= '1';	 
		   
		  when "1110" => -- bne 25
		   reg_dst <= '0';
		   mem_to_reg <= '0';
		   alu_op <= "1110";
		   jump <= '0';
		   branch <= '1';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';
		   alu_src2 <= '0';
		   clear_mem <= '0';
		   clear_reg <= '0';
		   add_type2 <= '0';
		   reg_write <= '0';
		   BA_write <= '0';
		   type1 <= '0';
		   --sign_or_zero <= '1';	
		   
		  when "1111" =>-- jmp 2500
		   reg_dst <= '1';
		   mem_to_reg <= '0';
		   alu_op <= "1111";
		   jump <= '1';
		   branch <= '0';
		   mem_read <= '0';
		   mem_write <= '0';
		   alu_src1 <= '0';
		   alu_src2 <= '0';
		   clear_reg <= '0';
		   clear_mem <= '0';
		   add_type2 <= '0';
		   reg_write <= '0';
		   BA_write <= '0';
		   type1 <= '0';
		   --sign_or_zero <= '1';
		 
		 when others =>   
		    reg_dst <= '1';
		    mem_to_reg <= '0';
		    alu_op <= "0000";
		    jump <= '0';
		    branch <= '0';
		    mem_read <= '0';
		    mem_write <= '0';
		    alu_src1 <= '0'; 
			alu_src2 <= '0';
			clear_reg <= '0';
			clear_mem <= '0';
		    reg_write <= '1';
			BA_write <= '0';
			type1 <= '0';
		    --sign_or_zero <= '1';
	 end case;
 end if;
end process;

end Behavioral;
