library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2x1 is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           input2 : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0));
end MUX2x1;

architecture Behavioral of MUX2x1 is

begin

    output <= input when (sel = '0') else input2;

end Behavioral;