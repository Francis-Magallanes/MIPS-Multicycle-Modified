library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity HoLoRegisters is
    Port ( 
        --input
        clk         : in STD_LOGIC;
        ho_data_in  : in STD_LOGIC_VECTOR(31 downto 0);
        lo_data_in  : in STD_LOGIC_VECTOR(31 downto 0);


        --output
        ho_data_out : out STD_LOGIC_VECTOR(31 downto 0);
        lo_data_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
end HoLoRegisters;

architecture Behavioral of HoLoRegisters is

signal ho_data_reg : STD_LOGIC_VECTOR(31 downto 0);
signal lo_data_reg : STD_LOGIC_VECTOR(31 downto 0);

begin

    process(clk,ho_data_in,lo_data_in)
    begin
        if rising_edge(clk) then
            ho_data_reg <= ho_data_in;
            lo_data_reg <= lo_data_in;
        end if;
    end process;

    ho_data_out <= ho_data_reg;
    lo_data_out <= lo_data_reg;

end Behavioral;