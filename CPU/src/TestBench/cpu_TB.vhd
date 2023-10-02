library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity cpu_tb is
end cpu_tb;

architecture TB_ARCHITECTURE of cpu_tb is
	-- Component declaration of the tested unit
	component cpu
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC );
	end component;
	constant clk_time: time :=100ns;
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...
	signal stop : boolean :=false;
begin  

	-- Unit Under Test port map
	UUT : cpu
		port map (
			clk => clk,
			reset => reset
		);

	CLK_PROCESS : process 
    begin 
        while not stop loop 
            clk <= not clk; 
            wait for clk_time;    
        end loop; 
        wait; 
    end process CLK_PROCESS;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_cpu of cpu_tb is
	for TB_ARCHITECTURE
		for UUT : cpu
			use entity work.cpu(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_cpu;

