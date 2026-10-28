-- Testbench for latch avoidance design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity latch_avoid_tb is
end entity latch_avoid_tb;

architecture sim of latch_avoid_tb is
  signal sel : std_logic := '0';
  signal d   : std_logic_vector(7 downto 0) := x"55";
  signal y   : std_logic_vector(7 downto 0);
begin

  dut : entity work.latch_avoid
    port map (
      sel => sel,
      d   => d,
      y   => y
    );

  stimulus : process
  begin
    sel <= '0';
    d   <= "10101010";
    wait for 1 ns;
    check_eq(y, x"00", "sel=0 outputs default 0");

    sel <= '1';
    d   <= x"AA";
    wait for 1 ns;
    check_eq(y, x"AA", "sel=1 outputs d");

    sel <= '0';
    wait for 1 ns;
    check_eq(y, x"00", "sel returns to 0 outputs default 0");

    summary("latch_avoid_tb");
    wait;
  end process stimulus;

end architecture sim;
