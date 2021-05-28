-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity FCU_tb is
end;

architecture bench of FCU_tb is

  component FCU
      Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
             hi : out STD_LOGIC_VECTOR (31 downto 0);
             lo : out STD_LOGIC_VECTOR (31 downto 0);
             enable_out : in STD_LOGIC);
  end component;

  signal input: STD_LOGIC_VECTOR (31 downto 0);
  signal hi: STD_LOGIC_VECTOR (31 downto 0);
  signal lo: STD_LOGIC_VECTOR (31 downto 0);
  signal enable_out: STD_LOGIC;

begin

  uut: FCU port map ( input  => input,
                      hi     => hi,
                      lo     => lo,
                      enable_out => enable_out );

  stimulus: process
  begin
    enable_out <= '0';
    wait for 10 ns;
    input <= x"00000005"; -- 5!
    enable_out <= '1';
    wait for 10 ns;
    enable_out <= '0';

    wait;
  end process;


end;