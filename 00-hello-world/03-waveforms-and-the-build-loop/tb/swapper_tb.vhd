-- Checks the swap, and the fact that the swap happens in ONE delta cycle:
-- on the waveform, a and b change at the same timestamp.

library ieee;
use ieee.std_logic_1164.all;
use work.tb_utils.all;

entity swapper_tb is
end entity swapper_tb;

architecture sim of swapper_tb is
  signal clk : std_logic := '0';
  signal a   : std_logic_vector(7 downto 0);
  signal b   : std_logic_vector(7 downto 0);
begin

  clk <= not clk after 5 ns;

  dut : entity work.swapper
    port map (
      clk => clk,
      a   => a,
      b   => b
    );

  monitor : process
  begin
    wait for 1 ns;
    check_eq(a, x"12", "initial value of a");
    check_eq(b, x"34", "initial value of b");

    wait until rising_edge(clk);
    wait for 1 ns;
    check_eq(a, x"34", "a after the first edge");
    check_eq(b, x"12", "b after the first edge");

    wait until rising_edge(clk);
    wait for 1 ns;
    check_eq(a, x"12", "a after the second edge");
    check_eq(b, x"34", "b after the second edge");

    summary("swapper_tb");
    wait;
  end process monitor;

end architecture sim;
