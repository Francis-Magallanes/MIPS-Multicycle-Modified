library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- VHDL code for ALU Control Unit of the MIPS Processor
entity ALUControl is
port(
  ALU_Control: out std_logic_vector(3 downto 0);
  ALUOp : in std_logic_vector(1 downto 0);
  ALU_Funct : in std_logic_vector(5 downto 0)
);
end ALUControl;

architecture Behavioral of ALUControl is

signal ALU_Control_sig : std_logic_vector(3 downto 0);

begin
    process(ALUOp,ALU_Funct)
    begin
        case ALUOp is
                
            --for the r-type instructions
            when "10" => 
             
                 --depending on the alu func, it will send signal to the ALU
                 case ALU_Funct is
                    
                    when "100000" =>  ALU_Control_sig <= "0010"; --for the addition
                    when "100010" =>  ALU_Control_sig <= "0110"; --for the subtraction
                    when "101010" => ALU_Control_sig <= "0111"; --for the set on less than 
                    when others => ALU_Control_sig <= "0010"; -- it will do add by default
                 end case;
                 
            --for the beq instruction
            when "01" => 
                ALU_Control_sig <= "0110"; -- this will do subtraction instruction for the ALU
            
            --for the bne instruction
            when "11" =>
                 ALU_Control_sig <= "1111";-- this a specialized ALU control for bne instruction
            
            when others => ALU_Control_sig <= "0010"; -- it will do add by default
        
        end case;
    end process;
    
    ALU_Control <= ALU_Control_sig;
end Behavioral;