library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
    Port ( CLK : in STD_LOGIC;
           enable : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR (31 downto 0);
           Output : out STD_LOGIC_VECTOR (31 downto 0)
         );
end PC;

architecture Behavioral of PC is

signal output_sig : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin

    process(CLK)
    begin
    
        if rising_edge(CLK) then
            if enable = '1' then
                output_sig <= input;
            end if;
        end if;
    
    end process;
    
    output <= output_sig;
end Behavioral;