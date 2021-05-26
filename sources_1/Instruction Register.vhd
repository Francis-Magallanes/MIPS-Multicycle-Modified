library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionRegister is
    Port ( 
            --input
           clk      : in STD_LOGIC;
           input    : in STD_LOGIC_VECTOR (31 downto 0);
           IRWrite  : in STD_LOGIC;
           
           --output
           output   : out STD_LOGIC_VECTOR (31 downto 0)
         );
end InstructionRegister;

architecture Behavioral of InstructionRegister is

signal data_reg : STD_LOGIC_VECTOR (31 downto 0);

begin

   process(clk,input,IRWrite)
   begin
        
        if rising_edge(clk) then
            
            if IRwrite = '1' then
                data_reg <= input;
            end if;
            
        end if;
   end process;
    
   output <= data_reg;
   
end Behavioral;
