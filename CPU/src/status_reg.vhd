

library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity status_reg is
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
end entity status_reg;

architecture rtl of status_reg is
  signal z_flag : std_logic;
  signal n_flag : std_logic;
  signal c_flag : std_logic;
  signal o_flag : std_logic; 
begin
  process(result,zero,negative,carry,overflow)
  begin	  
	  z_flag <= zero;
	  n_flag <= negative;
	  c_flag <= carry;
	  o_flag <= overflow;
	  
	  zero_o <= zero;
	  negative_o <= negative;
	  carry_o <= carry;
	  overflow_o <= overflow;
 
      -- Combine the flags with the remaining bits of the status register
      status_reg <= (z_flag & n_flag & c_flag & o_flag & "000000000000"); -- others => '0'
    
	  
  end process;
end architecture rtl;				



      --if rising_edge(clk) then
--      -- Set the Z flag
--      if result = "00000000000000000" then
--        z_flag <= '1';
--      else
--        z_flag <= '0';
--      end if;
--
--      -- Set the N flag
--      if result(15) = '1' then
--        n_flag <= '1';
--      else
--        n_flag <= '0';
--      end if;
--
--      -- Set the C flag
--      if (result(16) = '1') then
--        c_flag <= '1';
--      else
--        c_flag <= '0';
--      end if;
--
--      -- Set the O flag
--      if result(15) /= result(14) then
--        o_flag <= '1';
--      else
--        o_flag <= '0';
--      end if;  