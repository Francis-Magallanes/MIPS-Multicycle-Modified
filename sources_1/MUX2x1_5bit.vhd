library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2x1_5bit is
    Port ( input : in STD_LOGIC_VECTOR (4 downto 0);
           input2 : in STD_LOGIC_VECTOR (4 downto 0);
           sel : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (4 downto 0));
end MUX2x1_5bit;

architecture Behavioral of MUX2x1_5bit is

begin

    output <= input when (sel = '0') else input2;

end Behavioral;