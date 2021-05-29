library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity Memory is
    Port ( 
           --Input
           clk : in STD_LOGIC;
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

--assembly language program stored in this ram

--  GCD PART OF THE PROGRAM
--beq $s0,$s1, finish(loc: 0d32), (mem loc start: 0)
--  Binary Equivalent: 000100(op), 10000(rs), 10001(rt), 0000000000000111 (immediate)
--  Hexadecimal Equivalent: 0x12110007

--slt $t0,$s0, $s1              , (mem loc start: 4)
--  Binary Equivalent: 000000(op), 10000(rd), 10001(rt), 01000(rs), 00000(shamt), 101010(funct)
--  Hexadecimal Equivalent: 0x0211402A

--beq $t0,$zero,ab              , (mem loc start: 8)
--  Binary Equivalent: 000100(op), 01000(rs), 00000(rd), 0000000000000001(immediate)
--  Hexadecimal Equivalent: 0x11000001

--j ba(loc: 0d24)               , (mem loc start: 12)
--  Binary Equivalent: 000010(op), 00000000000000000000000110 (address)
--  Hexadecimal Equivalent: 0x08000006

--sub $s0,$s0,$s1               , (mem loc start: 16)
--  Binary Equivalent: 000000(op), 10000(rs), 10001(rt), 10000(rd), 00000(shamt), 100010(funct)
--  Hexadecimal Equivalent: 0x02118022

--j GCD (loc: 0d0)              , (mem loc start: 20)
--  Binary Equivalent: 000010(op), 00000000000000000000000000(address)
--  Hexadecimal Equivalent: 0x08000000

--sub $s1,$s1,$s0               , (mem loc start: 24)
--  Binary Equivalent: 000000(op), 10001(rs), 10000(rt), 10001(rd), 00000(shamt), 100010(funct) 
--  Hexadecimal Equivalent: 0x02308822

--j GCD (loc: 0d0)              , (mem loc start: 28)
--  Binary Equivalent: 000010(op), 00000000000000000000000000(address)
--  Hexadecimal Equivalent: 0x08000000

-- TESTING OTHER INSTRUCTION
-- This will test the add, addi, lw, sw

--add $s2,$s1,$s0               , (mem loc start: 32)
--  Binary Equivalent: 000000 (op), 10000 (rs), 10001(rt), 10010 (rd), 00000 (shamt), 100000 (funct)
--  Hexadecimal Equivalent: 0000-0010-0001-0001-1001-0000-0010-0000 => 0x02119020
--  Expected Output: $S2 (18) = 4 (assuming the GCD results will have 2 at register $S0 and $S1)

--addi $s3,$s1, 0xFF            , (mem loc start: 36)
--  Binary Equivalent: 001000 (op), 10000 (rs), 10011(rd), 0000 0000 1111 1111 (immediate)
--  Hexadecimal Equivalent: 0010-0010-0001-0011-0000-0000-1111-1111 => 0x221300FF
--  Expected Output : $s3 (19) = 0d257 or 0x101 (assuming that $s1 will have the value of 2 at end of gcd part)

--lw $s4,$t1, 0x01               , (mem loc start: 40)
--  Binary Equivalent: 100011 (op), 01001 (rs), 10100(rd), 0000 0000 0000 0001 (offset)
--  Hexadecimal Equivalent:  1000-1101-0011-0100--0000-0000-0000-0001 => 0x8D340001
--  Expected Output: $s4 = 0xFA0000000 (based on the contents of ram)

---sw $s4,$t1, 0x00              , (mem loc start: 44)
--  Binary Equivalent: 101011 (op), 01001 (rd), 10100(rs), 0000 0000 0000 0000 (offset)
--  Hexadecimal Equivalent: 1010-1101-0011-0100-0000-0000-0000-0000 => 0xAD340000
--  Expected Output: mem(511) = 0xFA (based on the contents of ram)

-- multu $t2,$t3                 , (mem loc start: 48)
-- Binary Equivalent: 000000 (op),  01010 (rs), 01011 (rt), 00000 00000, 011001 (funct)
-- Hexadecimal Equivalent: 0000-0001-0100-1011-0000-0000-0001-1001 => 0x014B0019
-- Expected Output: HI: 0x00000000, LO : 0x00000019

--divu $t2,$t3                   , (mem loc start: 52)
-- Binary Equivalent: 000000 (op),  01010 (rs), 01011 (rt), 00000 00000, 011011 (funct)
-- Hexadecimal Equivalent: 0000-0001-0100-1011-0000-0000-0001-1011 => 0x014B001B
-- Expected Output: HI: 0x00000000, LO : 0x00000001

--fac $t2                       , (mem loc start: 56)
-- Binary Equivalent: 000000 (op),  01010 (rs), 0000-0000-0000-000, 011100 (funct)
-- Hexadecimal Equivalent:  0000-0001-0100-0000-0000-0000-0001-1100 => 0x0140001C
-- Expected Output: HI: 0x00000000, LO : 0x00000078

--mfhi $t4                      , (mem loc start: 60)
-- Binary Equivalent: 000000(op), 0000000000 (rs), 01100 (rd), 00000, 010000
-- Hexadecimal Equivalent: 0000-0000-0000-0000-0110-0000-0001-0000 => 0x00006010
-- Expected Output $t4 = 0x00000000

--mflo $t5                      , (mem loc start: 64)
-- Binary Equivalent: 000000(op), 0000000000 (rs), 01101 (rd), 00000, 010010
-- Hexadecimal Equivalent: 0000-0000-0000-0000-0110-1000-0001-0010 => 0x00006812
-- Expected Output $t5 = 0x00000078

--j 0x44                        , (mem loc start: 68)
--  Binary Equivalent: 000010 (op), 00 0000 0000 0000 0000 0001 0001 (address)
--  Hexadecimal Equivalent: 0000-1000-0000-0000-0000-0000-0001-0001 => 0x08000011
--  Expected Output: PC counter will be at 0d68 forever


signal sig_storage : storage := (
    0 => x"12",-- beq $a0, $a1, 0x20 (0x8)
    1 => x"11",
    2 => x"00",
    3 => x"07",
    
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
    
    20 => x"08", --j to 0x0
    21 => x"00",
    22 => x"00",
    23 => x"00",
    
    24 => x"02", --sub $a1, $a1,$a0
    25 => x"30",
    26 => x"88",
    27 => x"22",
    
    28 => x"08", --j to 0x0
    29 => x"00",
    30 => x"00",
    31 => x"00",
    
    32 => x"02",-- add $s2,$s1,$s0
    33 => x"11",
    34 => x"90",
    35 => x"20",
    
    36 => x"22", -- addi $s3,$s1, 0xFF
    37 => x"13",
    38 => x"00",
    39 => x"FF",
    
    40 => x"8D", -- lw $s4, $t1, 0x01
    41 => x"34",
    42 => x"00",
    43 => x"01",
    
    44 => x"AD", -- sw $s4, $t1, 0x00
    45 => x"34",
    46 => x"00",
    47 => x"00",
    
    48 => x"01", --multu $t2,$t3
    49 => x"4B",
    50 => x"00",
    51 => x"19",
    
    52 => x"01", -- divu $t2,$3
    53 => x"4B",
    54 => x"00",
    55 => x"1B",
    
    56 => x"01", --fac $t2
    57 => x"40",
    58 => x"00",
    59 => x"1C",
    
    60 => x"00", --mfhi $t4
    61 => x"00",
    62 => x"60",
    63 => x"10",
    
    64 => x"00", -- mflo $t5
    65 => x"00",
    66 => x"68",
    67 => x"12",
    
    68 => x"08", -- j 0x44
    69 => x"00",
    70 => x"00",
    71 => x"11",
    
    512 =>x"FA", --this value will be loaded to $s4
    others => ( others=> '0')
);

begin
    
    process(clk,memwrite,memread,address,datain)
    begin
        
         if (rising_edge(clk) and memwrite = '1') then
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
