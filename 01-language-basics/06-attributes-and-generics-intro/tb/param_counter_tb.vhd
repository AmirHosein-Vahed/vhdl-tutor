-- Two instances of the same entity, at different widths and limits.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity param_counter_tb is
end entity param_counter_tb;

architecture sim of param_counter_tb is
  constant CLK_PERIOD : time := 10 ns;

  signal clk  : std_logic := '0';
  signal rst  : std_logic := '1';
  signal en4  : std_logic := '0';
  signal en6  : std_logic := '0';
  signal cnt4 : std_logic_vector(3 downto 0);
  signal cnt6 : std_logic_vector(5 downto 0);
  signal max4 : std_logic;
  signal max6 : std_logic;
begin

  clk <= not clk after CLK_PERIOD / 2;

  dut4 : entity work.param_counter
    generic map (WIDTH => 4, MAX => 9)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en4,
      count  => cnt4,
      at_max => max4
    );

  dut6 : entity work.param_counter
    generic map (WIDTH => 6, MAX => 40)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en6,
      count  => cnt6,
      at_max => max6
    );

  stimulus : process
  begin
    -- One rising edge with reset high clears both counters.
    tick(clk);
    wait for 1 ns;
    check_eq(cnt4, "0000", "4-bit counter reset");
    check_eq(cnt6, "000000", "6-bit counter reset");
    check_eq(max4, '0', "4-bit at_max after reset");
    check_eq(max6, '0', "6-bit at_max after reset");

    rst <= '0';

    -- 4-bit counter: 0 .. 9, then wrap.
    en4 <= '1';
    for i in 1 to 9 loop
      tick(clk);
      wait for 1 ns;
      check_eq(unsigned(cnt4), to_unsigned(i, 4),
               "4-bit count = " & integer'image(i));
    end loop;
    check_eq(max4, '1', "4-bit at terminal count 9");
    check_eq(max6, '0', "6-bit counter is still idle");

    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(cnt4), to_unsigned(0, 4), "4-bit wraps to 0");
    check_eq(max4, '0', "4-bit at_max clears after wrap");

    -- The enable holds the count.
    en4 <= '0';
    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(cnt4), to_unsigned(0, 4), "4-bit holds while disabled");
    en4 <= '1';
    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(cnt4), to_unsigned(1, 4), "4-bit counts again");

    -- 6-bit counter: 0 .. 40, then wrap.
    en6 <= '1';
    for i in 1 to 40 loop
      tick(clk);
      wait for 1 ns;
    end loop;
    check_eq(unsigned(cnt6), to_unsigned(40, 6), "6-bit at terminal count 40");
    check_eq(max6, '1', "6-bit at_max at 40");
    check_eq(max4, '0', "4-bit stays below its own maximum");

    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(cnt6), to_unsigned(0, 6), "6-bit wraps to 0");
    check_eq(max6, '0', "6-bit at_max clears after wrap");

    -- Attributes describe the instantiated widths, no magic numbers.
    check_eq(cnt4'length, 4, "cnt4'length");
    check_eq(cnt4'high, 3, "cnt4'high");
    check_eq(cnt4'low, 0, "cnt4'low");
    check_eq(cnt6'length, 6, "cnt6'length");
    check_eq(cnt6'high, 5, "cnt6'high");
    check(integer'image(9) = "9", "integer'image(9) is ""9""");

    summary("param_counter_tb");
    wait;
  end process stimulus;

end architecture sim;
