library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity ALU_VHDL is
port(
input1 : in std_logic_vector(15 downto 0); 
input2 : in std_logic_vector(15 downto 0);
opcode : in std_logic_vector(3 downto 0); -- function select
 alu_result: out std_logic_vector(15 downto 0); -- ALU Output Result
 zero: out std_logic; -- Zero Flag
 overflow: out std_logic ;-- Overflow Flag
 carry_out : out std_logic;
 N: out std_logic);--carry out	  
 
end ALU_VHDL;

architecture Behavioral of ALU_VHDL is
component Adder
  port(		
			A	: in std_logic_vector(15 downto 0);
	        B	: in std_logic_vector(15 downto 0);
			Carry_in : in std_logic;
			
	        CarryOUT: out	std_logic;
	        Sum	: out	std_logic_vector(15 downto 0);
			Overflow : out std_logic;
			Negative : out std_logic;
			Zero : out std_logic);
 
 end component;
signal result: std_logic_vector(15 downto 0);
signal carry_in1: std_logic;
signal carry_out2: std_logic;
signal overflow_3: std_logic;
signal zero_6: std_logic;
signal N_5: std_logic;


 signal  res : std_logic_vector(15 downto 0);
begin
	
	
adder1:	Adder port map(
 		
 			A	=> input1,
	        B	=> input2,
			Carry_in => carry_in1,
			
	        CarryOUT => carry_out2,
	        Sum	=> result,
			Overflow => overflow_3,
			Negative => N_5,
			Zero => zero_6 );	
process(input1,input2,opcode)
 variable temp: std_logic_vector(15 downto 0);
begin
 --sign1 <= input1(15);
 --sign2 <= input2(15);

 
 

 
 case opcode is
 when "0000" =>	 --add 
 
   
   	alu_result <= result;
	zero <= zero_6;
	overflow <= overflow_3;
	carry_out <= carry_out2;
	n <= n_5;
 
 
 

 
 
 
 when "0010" =>
  -- sub operation


		res <= std_logic_vector((input1(15 downto 0)) - (input2(15 downto 0)));
        if(res(15)= '1')  then
			carry_out <= '1';
		else
			carry_out <= '0';
		end if;
		if (input1(15) ='0' and input2(15)='1' and res(15)='1') or (input1(15) ='1' and input2(15)='0' and res(15)='0') then 
			overflow <= '1';
		else 
			overflow <= '0';
		end if;
		if(res =  "0000000000000000")then 
			zero <= '1';
		else
			zero <= '0';
		end if;
		N <= res(15);
		result <= res;
		

        

                -- Assign result
   --Result <= temp(15 downto 0); 
  when "0011" =>
  -- addi operation
  	alu_result <= result;
	zero <= zero_6;
	overflow <= overflow_3;
	carry_out <= carry_out2;
	n <= n_5;
 

    Result <= temp(15 downto 0);
 when "0101" => 
  -- and operation
  result <= input1 and input2;	
  alu_result <= result;
  carry_out <= '0';
  when "0110" =>
  -- shift left logical operation
     result <= std_logic_vector(shift_left(unsigned(input1), to_integer(unsigned(input2))));

	 alu_result <= result;
 
 
 
 
  carry_out <= result(14) and not result(15);	
 when "1101" =>
  -- compare operation
  res <= std_logic_vector((input1(15 downto 0)) - (input2(15 downto 0)));
  -- Check for zero
  if res = "0000000000000000" then
    zero <= '1';
    overflow <= '0';
  -- Check for negative
  elsif temp(15) = '1' then
    zero <= '0';
    overflow <= '0';
    alu_result <= (others => '0');
    -- Set the negative flag
    N <= '1';
  -- Otherwise, set both flags to zero
  else
    zero <= '0';
    overflow <= '0';
    alu_result <= (others => '0');
    N <= '0';
  end if;
  
  
  
  when others =>
                -- Invalid operation, set result and overflow to zero
                alu_result <= input1+input2;
                Overflow <= '0';
				n <= '0';
				zero <= '0';
				carry_out <= '0';
 end case;
end process;




end Behavioral;





