-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MIPS_Connected_tb is
end;

architecture bench of MIPS_Connected_tb is

  component MIPS_Connected
      Port ( reset : in STD_LOGIC;
             clk : in STD_LOGIC);
  end component;

  signal reset: STD_LOGIC;
  signal clk: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean ;

begin

  uut: MIPS_Connected port map ( reset => reset,
                                 clk   => clk );

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '1';
    wait for 3 ns;
    reset <= '0';
    wait for 2 ns;
    -- Put test bench stimulus code here
    
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;