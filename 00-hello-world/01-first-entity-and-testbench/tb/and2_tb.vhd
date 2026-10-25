-- A self-checking testbench for and2.
--
-- A testbench is an entity with no ports. It instantiates the design under
-- test (DUT), drives its inputs, and checks its outputs with `assert`-like
-- helpers from work.tb_utils.

library ieee;
use ieee.std_logic_1164.all;
use work.tb_utils.all;

entity and2_tb is
end entity and2_tb;

architecture sim of and2_tb is
  signal a : std_logic := '0';
  signal b : std_logic := '0';
  signal y : std_logic;
begin

  -- Direct instantiation: no component declaration needed in VHDL-2008.
  dut : entity work.and2
    port map (
      a => a,
      b => b,
      y => y
    );

  stimulus : process
  begin
    a <= '0'; b <= '0'; wait for 1 ns;
    check_eq(y, '0', "0 and 0");

    a <= '0'; b <= '1'; wait for 1 ns;
    check_eq(y, '0', "0 and 1");

    a <= '1'; b <= '0'; wait for 1 ns;
    check_eq(y, '0', "1 and 0");

    a <= '1'; b <= '1'; wait for 1 ns;
    check_eq(y, '1', "1 and 1");

    wait for 1 ns;

    -- Prints PASS/FAIL and ends the simulation with a meaningful exit code.
    summary("and2_tb");
    wait;
  end process stimulus;

end architecture sim;
