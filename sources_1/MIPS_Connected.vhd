library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MIPS_Connected is
    Port ( 
           reset : in STD_LOGIC;
           clk   : in STD_LOGIC
           
         );
end MIPS_Connected;

architecture Behavioral of MIPS_Connected is

--for the control unit
component ControlUnit is
port (
    
      --Inputs
     instruction : in STD_LOGIC_VECTOR (5 downto 0);
     clk         : in STD_LOGIC;
     reset       : in STD_LOGIC;
    
     --Output
     PCWriteCond : out STD_LOGIC;
     PC_Write    : out STD_LOGIC;
     IorD        : out STD_LOGIC;
     MemRead     : out STD_LOGIC;
     MemWrite    : out STD_LOGIC;
     MemtoReg    : out STD_LOGIC;
     IRWrite     : out STD_LOGIC;
     RegDst      : out STD_LOGIC;
     RegWrite    : out STD_LOGIC;
     ALUSrcA     : out STD_LOGIC;
     ALUSrcB     : out STD_LOGIC_VECTOR (1 downto 0);
     ALUOp       : out STD_LOGIC_VECTOR (1 downto 0);
     PCSource    : out STD_LOGIC_VECTOR (1 downto 0)
 );
 
end component;

--for the ALU control
component ALUControl is
port(
  --input
  ALUOp      : in std_logic_vector(1 downto 0);
  ALU_Funct  : in std_logic_vector(5 downto 0);
  
  --output
  ALU_Control: out std_logic_vector(3 downto 0)
);

end component;

--for the ALU
component ALU is
    port(
     
     --input
     op1         : in std_logic_vector(31 downto 0);
     op2         : in std_logic_vector(31 downto 0);
     alu_control : in std_logic_vector(3 downto 0); -- function select
     
     --output
     alu_result  : out std_logic_vector(31 downto 0); -- ALU Output Result
     zero        : out std_logic -- Zero Flag
     );
end component;

--for the data memory
component Memory is
    Port ( 
            --Input
           clk      : in STD_LOGIC;
           address  : in STD_LOGIC_VECTOR (31 downto 0); 
           datain   : in STD_LOGIC_VECTOR (31 downto 0);
           memwrite : in STD_LOGIC;
           memread  : in STD_LOGIC;
           
           --Output
           dataout  : out STD_LOGIC_VECTOR (31 downto 0)
         );
end component;

--for the program counter register
component PC is
    Port ( 
           --input
           CLK : in STD_LOGIC;
           enable : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR (31 downto 0);
           
           --output
           Output : out STD_LOGIC_VECTOR (31 downto 0)
          );
end component;

component InstructionRegister is
    Port ( 
            --input
           clk      : in STD_LOGIC;
           input    : in STD_LOGIC_VECTOR (31 downto 0);
           IRWrite  : in STD_LOGIC;
           
           --output
           output   : out STD_LOGIC_VECTOR (31 downto 0)
         );
end component;

--for the registers
component Registers is
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
end component;

--for shift left 2
component ShiftLeft2 is
  port( 
        input  : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0) 
      );
end component;

--for the sign extend
component SignExtend is
  port( 
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0)
  );
       
end component;  


--for the mux2x1
component MUX2x1 is
    Port ( 
           --input
           input  : in STD_LOGIC_VECTOR (31 downto 0);
           input2 : in STD_LOGIC_VECTOR (31 downto 0);
           sel    : in STD_LOGIC;
           
           --output
           output : out STD_LOGIC_VECTOR (31 downto 0)
         );
end component;

component MUX3x1 is
    Port ( 
           --inputs
           input  : in STD_LOGIC_VECTOR (31 downto 0);
           input2 : in STD_LOGIC_VECTOR (31 downto 0);
           input3 : in STD_LOGIC_VECTOR (31 downto 0);
           sel    : in STD_LOGIC_VECTOR (1 downto 0);
           
           --output
           output : out STD_LOGIC_VECTOR (31 downto 0)
       );
end component;

component MUX4x1 is
    Port ( 
            --input
           input  : in STD_LOGIC_VECTOR (31 downto 0);
           input2 : in STD_LOGIC_VECTOR (31 downto 0);
           input3 : in STD_LOGIC_VECTOR (31 downto 0);
           input4 : in STD_LOGIC_VECTOR (31 downto 0);
           sel    : in STD_LOGIC_VECTOR (1 downto 0);
           
           --output
           output : out STD_LOGIC_VECTOR (31 downto 0)
           
           );
end component;

component MUX2x1_5bit is

    Port ( 
           --input
           input  : in STD_LOGIC_VECTOR (4 downto 0);
           input2 : in STD_LOGIC_VECTOR (4 downto 0);
           sel    : in STD_LOGIC;
           
           --output
           output : out STD_LOGIC_VECTOR (4 downto 0)
          );
end component;

component RegAB is
    Port (
        --input
        clk     : in STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(31 downto 0);
        
        --output
        data_out: out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

  --signals from the control unit
  signal pcwritecond_controlunit : STD_LOGIC;
  signal pcwrite_controlunit      : STD_LOGIC;
  signal iord_controlunit        : STD_LOGIC;
  signal memread_controlunit     : STD_LOGIC;
  signal memwrite_controlunit    : STD_LOGIC;
  signal memtoreg_controlunit    : STD_LOGIC;
  signal irwrite_controlunit     : STD_LOGIC;
  signal regdst_controlunit      : STD_LOGIC;
  signal regwrite_controlunit    : STD_LOGIC;
  signal alusrca_controlunit     : STD_LOGIC;
  signal alusrcb_controlunit     : STD_LOGIC_VECTOR (1 downto 0);
  signal aluop_controlunit       : STD_LOGIC_VECTOR (1 downto 0);
  signal pcsource_controlunit    : STD_LOGIC_VECTOR (1 downto 0);
  
  --signals for the PC
  signal input_pc  : STD_LOGIC_VECTOR (31 downto 0);
  signal output_pc : STD_LOGIC_VECTOR (31 downto 0);
  signal enable_pc : STD_LOGIC;
  
  --signals for the memory         
  signal address_memory  :  STD_LOGIC_VECTOR (31 downto 0); 
  signal datain_memory   :  STD_LOGIC_VECTOR (31 downto 0);
  
  --signals for the instruction register
  signal input_ir  : STD_LOGIC_VECTOR (31 downto 0);
  signal output_ir : STD_LOGIC_VECTOR (31 downto 0);
  
  --for the memory address register
  signal output_mar: STD_LOGIC_VECTOR (31 downto 0);
  
  --signals from ALUOut
  signal output_aluout : STD_LOGIC_VECTOR (31 downto 0);
  
  --signals from the sign extend
  signal output_signextend : STD_LOGIC_VECTOR (31 downto 0);
  
  --signals for the registers
  signal addwrite_registers  : STD_LOGIC_VECTOR (4 downto 0); --for the write reg
  signal datwrite_registers  : STD_LOGIC_VECTOR (31 downto 0);
  signal reg1_registers      : STD_LOGIC_VECTOR (31 downto 0);
  signal reg2_registers      : STD_LOGIC_VECTOR (31 downto 0);
          
  --signals from the shift left 2
  signal output_shiftleftalu : STD_LOGIC_VECTOR (31 downto 0);
  signal output_shiftleftjmp : STD_LOGIC_VECTOR (31 downto 0);
    
  --signals from A and B register
  signal output_areg  : STD_LOGIC_VECTOR (31 downto 0);
  signal output_breg  : STD_LOGIC_VECTOR (31 downto 0);
  
  --signals for the alu
  signal  op1_alu        : std_logic_vector(31 downto 0);
  signal  op2_alu        : std_logic_vector(31 downto 0);
  signal  alucontrol_alu : std_logic_vector(3 downto 0); -- function select
  signal  aluresult_alu  : std_logic_vector(31 downto 0); -- ALU Output Result
  signal  zero_alu       : std_logic; -- Zero Flag
  

begin
        
        enable_pc <= pcwrite_controlunit or (pcwritecond_controlunit and zero_alu);
        
        PC_comp: PC port map( 
           
           CLK    => clk,
           enable => enable_pc,
           Input  => input_pc,
           Output => output_pc
           
          );

        MemeoryAddressSelector: MUX2x1 port map( 
           input  => output_pc,
           input2 => output_aluout,
           sel    => iord_controlunit,
           output => address_memory
         );

        RAM: Memory port map( 
           clk      => clk,
           address  => address_memory,
           datain   => output_breg, --data for the writing
           memwrite => memwrite_controlunit,
           memread  => memread_controlunit,
           dataout  => input_ir -- results of the reading
         );
    
        IR: InstructionRegister port map ( 
           clk      =>  clk,
           input    =>  input_ir,
           IRWrite  => irwrite_controlunit,
           output   => output_ir
         );

     MemoryDataRegister : RegAB port map ( 
        clk      => clk,
        data_in  => input_ir,
        data_out => output_mar
        );
         
      WriteDataSelector_Registers : MUX2x1 port map ( 
           input  => output_aluout,
           input2 => output_mar,
           sel    => memtoreg_controlunit,           
           output => datwrite_registers
         );
      
      WriteAddressSelector_Registers : MUX2x1_5bit port map( 
           input  => output_ir(20 downto 16),
           input2 => output_ir(15 downto 11),
           sel    => regdst_controlunit,
           output => addwrite_registers
          );

      RegisterFile :  Registers port map(
           clk        => clk, 
           add1       => output_ir(25 downto 21),
           add2       => output_ir(20 downto 16),
           add_write  => addwrite_registers,
           dat_write  => datwrite_registers,
           RW         => regwrite_controlunit,
           Reg1       => reg1_registers,
           Reg2       => reg2_registers
           );
           
       Areg : RegAB port map(
            clk      => clk,
            data_in  => reg1_registers,
            data_out => output_areg
        );
       
       Breg : RegAB port map(
            clk      => clk,
            data_in  => reg2_registers,
            data_out => output_breg
        );
        
       SE : SignExtend port map( 
           input  => output_ir(15 downto 0),
           output => output_signextend
        );
       
       SL_ALU :  ShiftLeft2 port map( 
        input  => output_signextend,
        output => output_shiftleftalu
        );
      
      FirstInputALUSelector : MUX2x1 port map ( 
           input  => output_pc,
           input2 => output_areg,
           sel    => alusrca_controlunit,          
           output => op1_alu
      );
       
      SecondInputALUSelector :  MUX4x1 port map( 
           input  => output_breg,
           input2 => x"00000004",
           input3 => output_signextend,
           input4 => output_shiftleftalu,
           sel    => alusrcb_controlunit,
           output => op2_alu
       );
       
      alu_comp : ALU port map(
         op1         => op1_alu,
         op2         => op2_alu,
         alu_control => alucontrol_alu,
         alu_result  => aluresult_alu,
         zero        => zero_alu
      );
     
     alucontrol_comp :  ALUControl port map(
          ALUOp      => aluop_controlunit,
          ALU_Funct  => output_ir (5 downto 0),
          ALU_Control=> alucontrol_alu
     );
     
     aluout_comp : RegAB port map(
            clk      => clk,
            data_in  => aluresult_alu,
            data_out => output_aluout
     );
     
     -- for the pc source
     -- this will be the input to the multiplexor
     output_shiftleftjmp <= output_pc(31 downto 28) & std_logic_vector(shift_left( unsigned("00" & output_ir(25 downto 0)) , 2));
     
--     SL_JMP :  ShiftLeft2 port map( 
--        input  => output_ir(25 downto 0),
--        output => output_shiftleftjmp
--     );
     
     PCUpdateSelector : MUX3x1 port map ( 
           input  => aluresult_alu,
           input2 => output_aluout,
           input3 => output_shiftleftjmp,
           sel    => pcsource_controlunit,
           output => input_pc
       );
     
     controller : ControlUnit port map (
         instruction => output_ir (31 downto 26),
         clk         => clk,
         reset       => reset,
         PCWriteCond => pcwritecond_controlunit,
         PC_Write    => pcwrite_controlunit,
         IorD        => iord_controlunit,
         MemRead     => memread_controlunit,
         MemWrite    => memwrite_controlunit,
         MemtoReg    => memtoreg_controlunit,
         IRWrite     => irwrite_controlunit,
         RegDst      => regdst_controlunit,
         RegWrite    => regwrite_controlunit,
         ALUSrcA     => alusrca_controlunit,
         ALUSrcB     => alusrcb_controlunit,
         ALUOp       => aluop_controlunit,
         PCSource    => pcsource_controlunit
    );
  
end Behavioral;
