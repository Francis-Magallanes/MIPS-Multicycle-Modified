library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- VHDL code for ALU of the MIPS Processor
entity ALU is
port(
 op1 : in std_logic_vector(31 downto 0);
 op2 : in std_logic_vector(31 downto 0);
 alu_control : in std_logic_vector(3 downto 0); -- function select
 alu_result: out std_logic_vector(31 downto 0); -- ALU Output Result
 zero: out std_logic -- Zero Flag
 );
end ALU;

architecture Behavioral of ALU is
 signal result: std_logic_vector(31 downto 0);
begin
    
    --this alu will do only the following:
    -- subtraction
    -- set on less than
    -- compare 
    process(op1,op2,alu_control)
    begin
         case alu_control is
           
           --for the addition
           when "0010" =>
                result <= std_logic_vector( signed(op1) + signed(op2) );
                
           --for the subtraction and beq instruction
           when "0110" =>
                result <= std_logic_vector( signed(op1) - signed(op2) );
           
           --for the slt 
           when "0111" =>
                if( unsigned(op1) < unsigned(op2) ) then
                    result <= x"00000001"; -- it will set to one if op1 is less than op2
                else
                    result <= x"00000000";
                end if;
           
           --for the bne instruction
           when "1111" =>
                if( unsigned(op1) /= unsigned(op2) ) then
                    result <= x"00000000"; -- it will set to one if op1 is not equal op2 to set the zero output to one for the bne instruction
                else
                    result <= x"00000001";
                end if;
            
            when others =>
                result <= (others => '0');
         end case;
    end process;
    
    alu_result <= result; -- results
    zero <= '1' when result = x"00000000" else '0';--setting of the flag
  
end Behavioral;