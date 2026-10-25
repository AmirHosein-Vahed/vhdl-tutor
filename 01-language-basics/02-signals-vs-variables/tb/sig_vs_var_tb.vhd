-- Checks that the signal path lags one cycle behind the variable path.

library ieee;
use ieee.std_logic_1164.all;
use work.tb_utils.all;

entity sig_vs_var_tb is
end entity sig_vs_var_tb;

architecture sim of sig_vs_var_tb is
  constant CLK_PERIOD : time := 10 ns;

  signal clk   : std_logic := '0';
  signal rst   : std_logic := '1';
  signal d     : std_logic := '0';
  signal q_sig : std_logic;
  signal q_var : std_logic;
begin

  clk <= not clk after CLK_PERIOD / 2;

  dut : entity work.sig_vs_var
    port map (
      clk   => clk,
      rst   => rst,
      d     => d,
      q_sig => q_sig,
      q_var => q_var
    );

  stimulus : process
  begin
    -- One rising edge with reset high clears both paths.
    tick(clk);
    wait for 1 ns;
    check_eq(q_sig, '0', "q_sig after reset");
    check_eq(q_var, '0', "q_var after reset");

    rst <= '0';

    d <= '1';
    tick(clk);
    wait for 1 ns;
    check_eq(q_var, '1', "variable path sees the value sampled at this edge");
    check_eq(q_sig, '0', "signal path still holds the previous value");

    d <= '0';
    tick(clk);
    wait for 1 ns;
    check_eq(q_var, '0', "variable path follows d immediately");
    check_eq(q_sig, '1', "signal path now shows the previous d");

    d <= '1';
    tick(clk);
    wait for 1 ns;
    check_eq(q_var, '1', "variable path: third sample");
    check_eq(q_sig, '0', "signal path: still one behind");

    d <= '0';
    tick(clk);
    wait for 1 ns;
    check_eq(q_var, '0', "variable path: fourth sample");
    check_eq(q_sig, '1', "signal path: one behind");

    summary("sig_vs_var_tb");
    wait;
  end process stimulus;

end architecture sim;
