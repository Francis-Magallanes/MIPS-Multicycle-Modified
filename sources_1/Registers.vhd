library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Registers is
    Port ( 
           --input
           clk        : in STD_LOGIC;
           add1       : in STD_LOGIC_VECTOR (4 downto 0); -- address of the first register
           add2       : in STD_LOGIC_VECTOR (4 downto 0); -- address of the second register
           add_write  : in STD_LOGIC_VECTOR (4 downto 0); --for the write reg
           dat_write  : in STD_LOGIC_VECTOR (31 downto 0);
           RW         : in STD_LOGIC;
           
           --output
           Reg1 : out STD_LOGIC_VECTOR (31 downto 0);
           Reg2 : out STD_LOGIC_VECTOR (31 downto 0)
           );
end Registers;

architecture Behavioral of Registers is

    type registers_type is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal Reg: registers_type := (
        
        0 => x"00000000",
        9 => x"000001FF", -- contains the location of the load word which is 511 , (see the ram)
        16 => x"00000028", -- a part
        17 => x"0000011E", -- b part
        
        others => (others => '0')
        );

begin

    process(clk,RW, add_write,dat_write)
    begin
         if  RW = '1'and rising_edge(clk) then
                Reg(to_integer(unsigned(add_write))) <= dat_write;
         end if;         
    end process;
     
     Reg1 <= Reg(to_integer(unsigned(add1)));
     Reg2 <= Reg(to_integer(unsigned(add2)));
     
end Behavioral;
