-- Testbench for the translated counter: reset, count, hold, continue.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity counter_tb is
end entity counter_tb;

architecture sim of counter_tb is
  constant CLK_PERIOD : time := 10 ns;

  signal clk   : std_logic := '0';
  signal rst   : std_logic := '1';
  signal en    : std_logic := '0';
  signal count : std_logic_vector(3 downto 0);
begin

  clk <= not clk after CLK_PERIOD / 2;

  -- generic map is how you pass a Verilog `parameter`.
  dut : entity work.counter
    generic map (W => 4)
    port map (
      clk   => clk,
      rst   => rst,
      en    => en,
      count => count
    );

  stimulus : process
  begin
    -- Synchronous reset: it takes effect on the next rising edge.
    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(count), to_unsigned(0, 4), "reset value");

    rst <= '0';
    en  <= '1';

    for i in 1 to 3 loop
      tick(clk);
      wait for 1 ns;
      check_eq(unsigned(count), to_unsigned(i, 4),
               "count after " & integer'image(i) & " cycle(s)");
    end loop;

    en <= '0';
    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(count), to_unsigned(3, 4), "holds while disabled");

    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(count), to_unsigned(3, 4), "still held");

    en <= '1';
    tick(clk);
    wait for 1 ns;
    check_eq(unsigned(count), to_unsigned(4, 4), "counts again after enable");

    summary("counter_tb");
    wait;
  end process stimulus;

end architecture sim;
