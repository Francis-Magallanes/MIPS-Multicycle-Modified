library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity Memory is
    Port ( 
           --Input
           address : in STD_LOGIC_VECTOR (31 downto 0); -- address to which data will be read or write
           datain : in STD_LOGIC_VECTOR (31 downto 0); -- data coming in for the write operation
           memwrite : in STD_LOGIC;
           memread : in STD_LOGIC;
           
           --Output
           dataout : out STD_LOGIC_VECTOR (31 downto 0)
           );
end Memory;

architecture Behavioral of Memory is

type storage is array (1024 downto 0) of std_logic_vector(7 downto 0);

signal sig_storage : storage := (
    0 => x"12",-- beq $a0, $a1, 0x20 (0x8)
    1 => x"11",
    2 => x"00",
    3 => x"08",
    4 => x"02", -- slt $a0, $a1,0x0,0x7
    5 => x"11",
    6 => x"40",
    7 => x"2A",
    8 => x"11",-- beq $t0, $zero
    9 => x"00",
    10 => x"00",
    11 => x"01",
    12 => x"08",-- j ba
    13 => x"00",
    14 => x"00",
    15 => x"06",
    16 => x"02", --sub $a0, $a0,$a1
    17 => x"11",
    18 => x"80",
    19 => x"22",
    20 => x"08", --j to zero
    21 => x"00",
    22 => x"00",
    23 => x"00",
    24 => x"02", --sub $a1, $a1,$a0
    25 => x"30",
    26 => x"88",
    27 => x"22",
    28 => x"08", --j to zero
    29 => x"00",
    30 => x"00",
    31 => x"00",
    others => ( others=> '0')
);

begin
    
    process(memwrite,memread,address,datain)
    begin
        
         if (memwrite = '1') then
                sig_storage(to_integer(unsigned(address))) <= datain(31 downto 24);
                sig_storage(to_integer(unsigned(address)) + 1) <= datain(23 downto 16);
                sig_storage(to_integer(unsigned(address)) + 2) <= datain(15 downto 8);
                sig_storage(to_integer(unsigned(address)) + 3) <= datain(7 downto 0);       
        end if;
               
    end process;
    
    dataout <= sig_storage( to_integer( unsigned(address))) &
               sig_storage( to_integer( unsigned(address)) + 1) &
               sig_storage( to_integer( unsigned(address)) + 2) &
               sig_storage( to_integer( unsigned(address)) + 3)  
               when memread = '1' else (others => '0');
               
end Behavioral;
