library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
    Port ( 
           --Inputs
           instruction : in STD_LOGIC_VECTOR (5 downto 0);
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;
    
           --Output
           --Comments are based on online reference 
           
           -- when 1 : The PC is written if the Zero output from the ALU is also active.
           PCWriteCond : out STD_LOGIC;
           
            -- when 1: The PC is written; the source is controlled by PCSource.
           PC_Write : out STD_LOGIC;
           
           -- when 0: The PC is used to supply the address to the memory unit.
           --when 1: ALUOut is used to supply the address to the memory unit. 
           IorD : out STD_LOGIC;
           
           -- when 1: Content of memory at the location specified by the Address input is put on Memory data output. 
           MemRead : out STD_LOGIC;
           
           -- when 1: Memory contents at the location specified by the Address input is replaced by value on Write data input
           MemWrite : out STD_LOGIC;
           
           -- when 0: The value fed to the register file Write data input comes from ALUOut.
           -- when 1: The value fed to the register file Write data input comes from the MDR.
           MemtoReg : out STD_LOGIC;
           
           -- The output of the memory is written into the IR.
           IRWrite : out STD_LOGIC;
           
           -- when 0: The register file destination number for the Write register comes from the rt field.
           --when 1: The register file destination number for the Write register comes from the rd field.
           RegDst : out STD_LOGIC;
           
           -- when 1: The general-purpose register selected by the Write register number is written with the value of the Write data input. 
           RegWrite : out STD_LOGIC;
           
           --when 0: The first ALU operand is the PC.
           --when 1: The first ALU operand comes from the A register
           ALUSrcA : out STD_LOGIC;
           
           -- when 00: The second input to the ALU comes from the B register.
           -- when 01: The second input to the ALU is the constant 4.
           -- when 10: The second input to the ALU is the sign-extended, lower 16 bits of the IR.
           -- when 11: The second input to the ALU is the sign-extended, lower 16 bits of the IR shifted left 2 bits.
           ALUSrcB : out STD_LOGIC_VECTOR (1 downto 0);
           
           -- when 00: The ALU performs an add operation.
           -- when 01: The ALU performs a subtract operation.
           -- when 10: The funct field of the instruction determines the ALU operation. 
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           
           -- when 00: Output of the ALU (PC + 4) is sent to the PC for writing.
           -- when 10: The contents of ALUOut (the branch target address) are sent to the PC for writing.
           -- when 11: The jump target address (IR[25:0] shifted left 2 bits and concatenated with PC + 4[31:28]) is sent to the PC for writing.
           PCSource : out STD_LOGIC_VECTOR (1 downto 0));
end ControlUnit;

architecture Behavioral of ControlUnit is

type State is (
    
    InstructionFetch,
    InstructionDecode,
    ExecuteSW1,
    ExecuteSW2,
    ExecuteLW1,
    ExecuteLW2,
    ExecuteLW3,
    ExecuteRTYPE1,
    ExecuteRTYPE2,
    ExecuteBEQ1,
    ExecuteJMP1,
    ExecuteITYPE1,
    ExecuteITYPE2,
    ExecuteMFLO1,
    ExecuteMFHO1,
    ExecuteADDI1,
    ExecuteADDI2

 );


signal controlunit_state : State := InstructionFetch;

begin

    process(clk, instruction)
    begin
        
        if reset = '1' then
            controlunit_state <= InstructionFetch;
        
        elsif falling_edge(clk) then
            --check the clocking
               
             case controlunit_state is
                
                 when InstructionFetch =>
                    PCWriteCond <= '0';
                    PC_Write <= '1';
                    IorD <= '0';
                    MemRead <= '1';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '1';
                    RegDst <= '0';
                    RegWrite <= '0';
                    ALUSrcA <= '0';
                    ALUSrcB <= "01";
                    ALUOp <= "00"; --addition
                    PCSource <= "00";
                    controlunit_state <= InstructionDecode; --update
                    
                 when InstructionDecode =>
                     PCWriteCond <= '0';
                     PC_Write <= '0';
                     IorD <= '0';
                     MemRead <= '0';
                     MemWrite <= '0';
                     MemtoReg <= '0';
                     IRWrite <= '0';
                     RegDst <= '0';
                     RegWrite <= '0';
                     ALUSrcA <= '0';
                     ALUSrcB <= "11";
                     ALUOp <= "00"; --addition
                     PCSource <= "00";
                     
                     --update the state depending of the instruction
                     if instruction = "000000" then 
                        --R-type instruction (add,sub,slt)
                         controlunit_state <= ExecuteRTYPE1; --update
                     
                     elsif instruction = "001000" then
                        --addi instruction
                        controlunit_state <= ExecuteADDI1;
                     
                     elsif instruction = "000010" then
                        --Jump instruction
                        controlunit_state <= ExecuteJMP1;
                     
                     elsif instruction = "000100" then
                        --Branch on equal instruction
                        controlunit_state <= ExecuteBEQ1;
                     
                     elsif instruction = "100011" then
                        -- Load word instruction
                        controlunit_state <= ExecuteLW1;
                     
                     elsif instruction  = "101011" then
                        --store word instruction
                        controlunit_state <= ExecuteSW1;
                     else
                        controlunit_state <= InstructionFetch; --if the instruction is unrecognized, it will go to the instruction decode
                     end if;
                 
                 -- execution of the store word
                 when ExecuteSW1 =>
                     PCWriteCond <= '0';
                     PC_Write <= '0';
                     IorD <= '0';
                     MemRead <= '0';
                     MemWrite <= '0';
                     MemtoReg <= '0';
                     IRWrite <= '0';
                     RegDst <= '0';
                     RegWrite <= '0';
                     ALUSrcA <= '1';
                     ALUSrcB <= "10";
                     ALUOp <= "00"; --addition
                     PCSource <= "00";
                     controlunit_state <= ExecuteSW2;
                  
                  when ExecuteSW2 =>
                     PCWriteCond <= '0';
                     PC_Write <= '0';
                     IorD <= '1';
                     MemRead <= '0';
                     MemWrite <= '1';
                     MemtoReg <= '0';
                     IRWrite <= '0';
                     RegDst <= '0';
                     RegWrite <= '0';
                     ALUSrcA <= '0';
                     ALUSrcB <= "01"; -- this should be one (PC + 4) to avoid conflict during the fetch cycle of the next instruction
                     ALUOp <= "00"; --addition
                     PCSource <= "00";
                     controlunit_state <= InstructionFetch; --proceed to the next instruction
                 
                 --execution of the load word instruction
                 when ExecuteLW1 =>
                    PCWriteCond <= '0';
                    PC_Write <= '0';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '0';
                    ALUSrcA <= '1';
                    ALUSrcB <= "10";
                    ALUOp <= "00"; --addition
                    PCSource <= "00";
                    controlunit_state <= ExecuteLW2;
                  
                 when ExecuteLW2 =>
                    PCWriteCond <= '0';
                    PC_Write <= '0';
                    IorD <= '1';
                    MemRead <= '1';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '0';
                    ALUSrcA <= '0';
                    ALUSrcB <= "00";
                    ALUOp <= "00"; --addition
                    PCSource <= "00";
                    controlunit_state <= ExecuteLW3; 
                 
                 when ExecuteLW3 =>
                    PCWriteCond <= '0';
                    PC_Write <= '0';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '1';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '1';
                    ALUSrcA <= '0';
                    ALUSrcB <= "00";
                    ALUOp <= "00"; --addition
                    PCSource <= "00";
                    controlunit_state <= InstructionFetch; -- proceed to the next instruction
                
                -- for the rtype instruction execution(add, sub,slt)
                 when ExecuteRTYPE1 =>
                    PCWriteCond <= '0';
                    PC_Write <= '0';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '0';
                    ALUSrcA <= '1';
                    ALUSrcB <= "00";
                    ALUOp <= "10";
                    PCSource <= "00";
                    controlunit_state <= ExecuteRTYPE2;
                 
                 when ExecuteRTYPE2 =>
                    PCWriteCond <= '0';
                    PC_Write <= '0';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '1';
                    RegWrite <= '1';
                    ALUSrcA <= '0';
                    ALUSrcB <= "00";
                    ALUOp <= "10";
                    PCSource <= "00";
                    controlunit_state <= InstructionFetch;
                 
                 -- for the jump instruction
                 when ExecuteJMP1 =>
                    PCWriteCond <= '0';
                    PC_Write <= '1';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '0';
                    ALUSrcA <= '0';
                    ALUSrcB <= "00";
                    ALUOp <= "00"; --addition
                    PCSource <= "10";
                    controlunit_state <= InstructionFetch;
                 
                 -- for the beq instruction
                 when ExecuteBEQ1 =>
                    PCWriteCond <= '1';
                    PC_Write <= '0';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '0';
                    ALUSrcA <= '1';
                    ALUSrcB <= "00";
                    ALUOp <= "01";
                    PCSource <= "01";
                    controlunit_state <= InstructionFetch;
                 
                 --for the add immediate instruction
                 when ExecuteADDI1 =>
                    PCWriteCond <= '0';
                    PC_Write <= '0';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '0';
                    ALUSrcA <= '1';
                    ALUSrcB <= "10";
                    ALUOp <= "00";
                    PCSource <= "00";
                    controlunit_state <= ExecuteADDI2;
                
                when ExecuteADDI2 =>
                    PCWriteCond <= '0';
                    PC_Write <= '0';
                    IorD <= '0';
                    MemRead <= '0';
                    MemWrite <= '0';
                    MemtoReg <= '0';
                    IRWrite <= '0';
                    RegDst <= '0';
                    RegWrite <= '1';
                    ALUSrcA <= '0';
                    ALUSrcB <= "00";
                    ALUOp <= "00"; --addition
                    PCSource <= "00";
                    controlunit_state <= InstructionFetch;
                 
                 when others =>
                    controlunit_state <= InstructionFetch;
                    
             end case;
             
        end if;
    
    end process;

end Behavioral;
