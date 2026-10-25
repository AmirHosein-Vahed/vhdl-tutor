-- Carry, wrap, truncation and saturation, checked against to_unsigned.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity arith_demo_tb is
end entity arith_demo_tb;

architecture sim of arith_demo_tb is
  -- Initial values keep the first delta free of 'U' metavalue warnings.
  signal a, b : std_logic_vector(7 downto 0) := (others => '0');
  signal sum  : std_logic_vector(8 downto 0);
  signal diff : std_logic_vector(8 downto 0);
  signal prod : std_logic_vector(15 downto 0);
  signal gt   : std_logic;
  signal sat  : std_logic_vector(7 downto 0);
begin

  dut : entity work.arith_demo
    port map (
      a    => a,
      b    => b,
      sum  => sum,
      diff => diff,
      prod => prod,
      gt   => gt,
      sat  => sat
    );

  stimulus : process
  begin
    -- 10 + 20: no carry, no saturation, no underflow.
    a <= std_logic_vector(to_unsigned(10, 8));
    b <= std_logic_vector(to_unsigned(20, 8));
    wait for 1 ns;
    check_eq(sum, std_logic_vector(to_unsigned(30, 9)), "10 + 20");
    check_eq(diff, std_logic_vector(to_unsigned(502, 9)),
             "10 - 20 wraps modulo 512 in 9-bit unsigned");
    check_eq(prod, std_logic_vector(to_unsigned(200, 16)), "10 * 20");
    check_eq(gt, '0', "10 > 20");
    check_eq(sat, std_logic_vector(to_unsigned(30, 8)), "10 + 20 saturates to 30");

    -- 200 + 100: the 9th bit of sum is the carry, sat clamps at 255.
    a <= std_logic_vector(to_unsigned(200, 8));
    b <= std_logic_vector(to_unsigned(100, 8));
    wait for 1 ns;
    check_eq(sum, std_logic_vector(to_unsigned(300, 9)), "200 + 100 keeps the carry");
    check_eq(diff, std_logic_vector(to_unsigned(100, 9)), "200 - 100");
    check_eq(prod, std_logic_vector(to_unsigned(20000, 16)), "200 * 100");
    check_eq(gt, '1', "200 > 100");
    check_eq(sat, x"FF", "200 + 100 saturates to 255");

    -- 255 + 255: maximum carry, maximum product, saturation again.
    a <= x"FF";
    b <= x"FF";
    wait for 1 ns;
    check_eq(sum, std_logic_vector(to_unsigned(510, 9)), "255 + 255");
    check_eq(diff, std_logic_vector(to_unsigned(0, 9)), "255 - 255");
    check_eq(prod, std_logic_vector(to_unsigned(65025, 16)), "255 * 255");
    check_eq(gt, '0', "255 > 255");
    check_eq(sat, x"FF", "255 + 255 saturates to 255");

    -- Conversions are explicit and width-checked.
    check_eq(unsigned(a), to_unsigned(255, 8), "unsigned(255)");
    check_eq(to_integer(unsigned(a)), 255, "to_integer");
    check_eq(resize(unsigned(a), 16), to_unsigned(255, 16), "resize zero-extends");
    check_eq(resize(signed(a), 16), to_signed(-1, 16),
             "resize sign-extends signed(0xFF) to -1");

    summary("arith_demo_tb");
    wait;
  end process stimulus;

end architecture sim;
