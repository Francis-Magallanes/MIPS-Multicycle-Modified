library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity MultiAndDiv is
  Port ( 
    input: in unsigned(31 downto 0);
    input2: in unsigned(31 downto 0);
    sel: in STD_LOGIC;
    EnOut: in STD_LOGIC;
    output: out STD_LOGIC_VECTOR(63 downto 0)  
  );
end MultiAndDiv;

architecture Behavioral of MultiAndDiv is

signal Transfer: STD_LOGIC_VECTOR(63 downto 0);

begin
    
    process(input,input2,sel)
    
    variable temp: unsigned (31 downto 0);
    variable result: unsigned(63 downto 0);
    variable temp2: unsigned (31 downto 0);
    variable counter: integer;
   
    begin
    temp := input;
    counter:= 0;
    
    if (sel = '0') then result := input * input2;
    else 
        L1: for i in 0 to input'high loop
        
            exit L1 when (input2 > temp);
            temp := temp - input2;
            counter:= counter + 1;
            
        end loop;
    end if;
    
    result := to_unsigned(counter,64);
    Transfer <= STD_LOGIC_VECTOR(result);
    
    end process;
    
    output <= Transfer when (EnOut = '1') else (others => 'Z');

end Behavioral;
