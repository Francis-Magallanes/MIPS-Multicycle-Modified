
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity FCU is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           hi : out STD_LOGIC_VECTOR (31 downto 0) :=  (others => 'Z');
           lo : out STD_LOGIC_VECTOR (31 downto 0) :=  (others => 'Z');
           enable_out : in STD_LOGIC);
end FCU;

architecture Behavioral of FCU is

signal product_acc : std_logic_vector(63 downto 0);

begin

   process(input,enable_out)
   variable temp_pa : unsigned (63 downto 0) := x"0000_0000_0000_0001";
   variable pa: std_logic_vector(63 downto 0);
   begin
        
        -- max 20 since this is maximum value that the two 32-bit represen can represent
        for i in 1 to 20 loop 
          
            if (i <= to_integer(unsigned(input)))  then
                 temp_pa := resize(temp_pa * to_unsigned(i, product_acc'length),64);
            end if;
            
        end loop;
        
        pa := std_logic_vector(temp_pa);
        
        if(enable_out = '1') then
           hi <= pa(63 downto 32) ;
           lo <= pa(31 downto 0) ;
        else
            hi <= (others => 'Z') ;
            lo <= (others => 'Z') ;
        end if;
        
   end process;
      
end Behavioral;
