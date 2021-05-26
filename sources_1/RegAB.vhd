library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RegAB is
    Port ( 
        --input
        clk     : in STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(31 downto 0);
        
        --output
        data_out: out STD_LOGIC_VECTOR(31 downto 0)
        );
end RegAB;

architecture Behavioral of RegAB is

signal data_reg : STD_LOGIC_VECTOR(31 downto 0);

begin

    process(clk,data_in)
    begin
        if rising_edge(clk) then
            data_reg <= data_in;
        end if;
    end process;
    
    data_out <= data_reg;
    
end Behavioral;
