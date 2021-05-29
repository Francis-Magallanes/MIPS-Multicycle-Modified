library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- VHDL code for ALU Control Unit of the MIPS Processor
entity ALUControl is
port(
  ALUOp             : in std_logic_vector(1 downto 0);
  ALU_Funct         : in std_logic_vector(5 downto 0);
  
  ALU_Control       : out std_logic_vector(3 downto 0);
  muldivsel         : out std_logic; -- it will select whether multiplication of division
  enableout_fcu     : out std_logic; -- if 1 , output thhe results of the FCU. Otherwise, FCU will output high z
  enableout_muldiv  : out std_logic;-- if 1 , output thhe results of the mul div. Otherwise, mul div will output high z
  enablein_hilo     : out std_logic;-- if 1, the inputs of the HI and LO register will be stored. Otherwise, do nothing
  aluout_seclector  : out std_logic_vector(1 downto 0) -- selects the value to be stored in ALUOut.
  
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
                        
                        --for the addition
                        when "100000" =>  
                            ALU_Control_sig   <= "0010";
                            muldivsel         <= '0';
                            enableout_fcu     <= '0';
                            enableout_muldiv  <= '0';
                            enablein_hilo     <= '0';
                            aluout_seclector  <= "00";
      
                        --for the subtraction
                        when "100010" =>  
                            ALU_Control_sig   <= "0110";
                            muldivsel         <= '0';
                            enableout_fcu     <= '0';
                            enableout_muldiv  <= '0';
                            enablein_hilo     <= '0';
                            aluout_seclector  <= "00";
                            
                         --for the set on less than 
                        when "101010" => 
                            ALU_Control_sig <= "0111";
                            muldivsel         <= '0';
                            enableout_fcu     <= '0';
                            enableout_muldiv  <= '0';
                            enablein_hilo     <= '0';
                            aluout_seclector  <= "00";
                        
                        --for unsigned multiplication
                        when "011001" =>
                            --(HI,LO <= A * B), (ALUOut <= 0x0)
                             ALU_Control_sig   <= "0010"; --the alu will do addition for the ALU
                             muldivsel         <= '0'; -- set to zero for multiplication 
                             enableout_fcu     <= '0';
                             enableout_muldiv  <= '1'; --output the results
                             enablein_hilo     <= '1'; --store the results to HI and LO
                             aluout_seclector  <= "11"; -- (ALUOut <= 0x0)
                           
                       
                       --for unsigned division
                       when "011011" =>
                            --(HI,LO <= A / B), (ALUOut <= 0x0)
                            ALU_Control_sig   <= "0010"; --the alu will do addition for the ALU
                            muldivsel         <= '1'; -- set to one for division 
                            enableout_fcu     <= '0';
                            enableout_muldiv  <= '1'; --output the results
                            enablein_hilo     <= '1'; --store the results to HI and LO
                            aluout_seclector  <= "11"; -- (ALUOut <= 0x0)
                       
                        --for the factorial operation
                        when "011100" =>
                         --(HI,LO <= A!), (ALUOut <= 0x0)
                          ALU_Control_sig   <= "0010"; --the alu will do addition for the ALU
                          muldivsel         <= '0';
                          enableout_fcu     <= '1';--output the results
                          enableout_muldiv  <= '0'; 
                          enablein_hilo     <= '1'; --store the results to HI and LO
                          aluout_seclector  <= "11"; -- (ALUOut <= 0x0)
                                                 
                        --for the mfhi
                        when "010000" =>
                              ALU_Control_sig   <= "0010"; --the alu will do addition for the ALU
                              muldivsel         <= '0'; 
                              enableout_fcu     <= '0';
                              enableout_muldiv  <= '0';
                              enablein_hilo     <= '0';
                              aluout_seclector  <= "01"; -- ho to aluout
                              
                         --for the mflo
                         when "010010" =>
                              ALU_Control_sig   <= "0010"; --the alu will do addition for the ALU
                              muldivsel         <= '0'; 
                              enableout_fcu     <= '0';
                              enableout_muldiv  <= '0';
                              enablein_hilo     <= '0';
                              aluout_seclector  <= "10"; -- lo to aluout
                              
                        -- it will do add by default
                        when others => 
                            ALU_Control_sig <= "0010";
                            muldivsel         <= '0';
                            enableout_fcu     <= '0';
                            enableout_muldiv  <= '0';
                            enablein_hilo     <= '0';
                            aluout_seclector  <= "00";
                            
                     
                     
                     end case;
                     
                --for the beq instruction
                when "01" => 
                    ALU_Control_sig <= "0110"; -- this will do subtraction instruction for the ALU
                    muldivsel         <= '0';
                    enableout_fcu     <= '0';
                    enableout_muldiv  <= '0';
                    enablein_hilo     <= '0';
                    aluout_seclector  <= "00";
                
                --for the bne instruction
                when "11" =>
                     ALU_Control_sig <= "1111";-- this a specialized ALU control for bne instruction
                     muldivsel         <= '0';
                     enableout_fcu     <= '0';
                     enableout_muldiv  <= '0';
                     enablein_hilo     <= '0';
                     aluout_seclector  <= "00";
                
                when others => 
                    ALU_Control_sig <= "0010"; -- it will do add by default
                    muldivsel         <= '0';
                    enableout_fcu     <= '0';
                    enableout_muldiv  <= '0';
                    enablein_hilo     <= '0';
                    aluout_seclector  <= "00";
            
            end case;    
        
    end process;
    
    ALU_Control <= ALU_Control_sig;
end Behavioral;