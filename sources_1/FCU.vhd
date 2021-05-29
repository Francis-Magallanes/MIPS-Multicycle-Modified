
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity FCU is
    Port ( input      : in STD_LOGIC_VECTOR (31 downto 0);
           enable_out : in STD_LOGIC;
           output     : out std_logic_vector(63 downto 0)
           );
end FCU;

architecture Behavioral of FCU is

signal product_acc : std_logic_vector(63 downto 0) := (others => '0');

begin


   process(input)
   variable temp_pa : unsigned (63 downto 0);
   begin
       temp_pa := x"0000_0000_0000_0001";
       for i in 1 to 20 loop
          
              if (i <= to_integer(unsigned(input)))  then
                  temp_pa := resize(temp_pa * to_unsigned(i, product_acc'length),64);
              end if;
                
       end loop;
      
       product_acc <= std_logic_vector(temp_pa);
   end process;
   
   output <= product_acc when enable_out= '1' else (others => 'Z');
   
end Behavioral;
