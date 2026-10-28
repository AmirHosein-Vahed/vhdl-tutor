-- Testbench for adder and subtractor.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity adder_subtractor_tb is
end entity adder_subtractor_tb;

architecture sim of adder_subtractor_tb is
  signal a, b     : std_logic_vector(7 downto 0) := (others => '0');
  signal sub      : std_logic := '0';
  signal sum      : std_logic_vector(7 downto 0);
  signal cout     : std_logic;
  signal overflow : std_logic;
begin

  dut : entity work.adder_subtractor
    port map (
      a        => a,
      b        => b,
      sub      => sub,
      sum      => sum,
      cout     => cout,
      overflow => overflow
    );

  stimulus : process
  begin
    -- Test safe Addition (no overflow)
    a <= std_logic_vector(to_unsigned(10, 8));
    b <= std_logic_vector(to_unsigned(20, 8));
    sub <= '0';
    wait for 1 ns;
    check_eq(sum, std_logic_vector(to_unsigned(30, 8)), "10 + 20 = 30");
    check_eq(cout, '0', "no cout");
    check_eq(overflow, '0', "no overflow");

    -- Test Addition with signed overflow (100 + 50 = 150 > 127)
    a <= std_logic_vector(to_unsigned(100, 8));
    b <= std_logic_vector(to_unsigned(50, 8));
    wait for 1 ns;
    check_eq(overflow, '1', "signed overflow detected for 100 + 50");

    -- Test Addition with carry out (unsigned)
    a <= std_logic_vector(to_unsigned(200, 8));
    b <= std_logic_vector(to_unsigned(100, 8));
    wait for 1 ns;
    check_eq(sum, std_logic_vector(to_unsigned(44, 8)), "200 + 100 mod 256");
    check_eq(cout, '1', "cout set");

    -- Test Subtraction
    a <= std_logic_vector(to_unsigned(100, 8));
    b <= std_logic_vector(to_unsigned(30, 8));
    sub <= '1';
    wait for 1 ns;
    check_eq(sum, std_logic_vector(to_unsigned(70, 8)), "100 - 30 = 70");

    summary("adder_subtractor_tb");
    wait;
  end process stimulus;

end architecture sim;
