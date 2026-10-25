-- Slices, attributes, and the direction trap.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity slice_demo_tb is
end entity slice_demo_tb;

architecture sim of slice_demo_tb is
  signal din         : std_logic_vector(7 downto 0) := x"96";
  signal high_nibble : std_logic_vector(3 downto 0);
  signal low_nibble  : std_logic_vector(3 downto 0);
  signal reversed    : std_logic_vector(7 downto 0);
  signal msb_is      : std_logic;
  signal lsb_is      : std_logic;
  signal descending  : std_logic_vector(3 downto 0);
  signal ascending   : std_logic_vector(0 to 3);
begin

  dut : entity work.slice_demo
    port map (
      din         => din,
      high_nibble => high_nibble,
      low_nibble  => low_nibble,
      reversed    => reversed,
      msb_is      => msb_is,
      lsb_is      => lsb_is,
      descending  => descending,
      ascending   => ascending
    );

  stimulus : process
  begin
    wait for 1 ns;

    -- 0x96 = 1001_0110, so the nibbles and the reversal are easy to verify.
    check_eq(high_nibble, "1001", "din(7 downto 4)");
    check_eq(low_nibble, "0110", "din(3 downto 0)");
    check_eq(reversed, x"69", "reverse(0x96) = 0x69");
    check_eq(msb_is, '1', "din(din'high)");
    check_eq(lsb_is, '0', "din(din'low)");

    -- Both literals compare equal as strings, but the indices differ.
    check_eq(descending, "1010", "descending literal");
    check_eq(ascending, "1010", "ascending literal");
    check_eq(descending(3), '1', "descending: index 3 is the leftmost bit");
    check_eq(descending(0), '0', "descending: index 0 is the rightmost bit");
    check_eq(ascending(0), '1', "ascending: index 0 is the leftmost bit");
    check_eq(ascending(3), '0', "ascending: index 3 is the rightmost bit");
    check_eq(descending(1), '1', "descending: index 1");
    check_eq(ascending(1), '0', "ascending: index 1 is a different bit");

    -- Attributes describe the range without hard-coded numbers.
    check_eq(din'length, 8, "din'length");
    check_eq(din'high, 7, "din'high");
    check_eq(din'low, 0, "din'low");
    check_eq(din'left, 7, "din'left");
    check_eq(din'right, 0, "din'right");

    -- A change on the input propagates through the function in one delta.
    din <= x"0F";
    wait for 1 ns;
    check_eq(reversed, x"F0", "reverse(0x0F) = 0xF0");
    check_eq(high_nibble, "0000", "new high nibble");
    check_eq(low_nibble, "1111", "new low nibble");

    summary("slice_demo_tb");
    wait;
  end process stimulus;

end architecture sim;
