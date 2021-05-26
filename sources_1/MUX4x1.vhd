library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4x1 is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           input2 : in STD_LOGIC_VECTOR (31 downto 0);
	       input3 : in STD_LOGIC_VECTOR (31 downto 0);
	       input4 : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end MUX4x1;

architecture Behavioral of MUX4x1 is

begin

    output <= input when (sel = "00") else 
              input2 when (sel = "01") else
              input3 when (sel = "10") else
	          input4;

end Behavioral;