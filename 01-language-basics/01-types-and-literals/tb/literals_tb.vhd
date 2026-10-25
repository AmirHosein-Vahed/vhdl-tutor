-- The same value spelled five ways, and the nine values of std_logic.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity literals_tb is
end entity literals_tb;

architecture sim of literals_tb is
  signal hex_255     : std_logic_vector(7 downto 0);
  signal bin_255     : std_logic_vector(7 downto 0);
  signal based_255   : std_logic_vector(7 downto 0);
  signal dec_255     : std_logic_vector(7 downto 0);
  signal underscored : natural;
begin

  dut : entity work.literals
    port map (
      hex_255     => hex_255,
      bin_255     => bin_255,
      based_255   => based_255,
      dec_255     => dec_255,
      underscored => underscored
    );

  stimulus : process
  begin
    wait for 1 ns;

    -- Five spellings of 255, all checked against the same byte.
    check_eq(hex_255, x"FF", "hex literal x""FF""");
    check_eq(bin_255, "11111111", "binary string literal ""11111111""");
    check_eq(based_255, x"FF", "integer 16#FF# converted with to_unsigned");
    check_eq(dec_255, x"FF", "to_unsigned(255, 8)");
    check_eq(underscored, 1_000_000, "underscores are ignored");

    check_eq(16#FF#, 255, "based integer literal");
    check_eq(2#1111_1111#, 255, "binary based literal with an underscore");
    check_eq(1_000_000 / 1_000, 1_000, "underscores in arithmetic");

    -- std_logic is not a bit: it carries simulation states as values.
    check(std_logic'image('U') = "'U'", "U = uninitialized");
    check(std_logic'image('Z') = "'Z'", "Z = high impedance");
    check(std_logic'image('-') = "'-'", "- = don't care");
    check_eq('1' and 'H', '1', "strong and weak 1 resolve to 1");
    check(to_bit('L') = '0', "weak L converts to bit 0");

    -- Constrained subtypes carry their bounds into the type system.
    check_eq(natural'low, 0, "natural starts at 0");
    check(integer'high >= 2_147_483_647, "integer is at least 32-bit signed");

    summary("literals_tb");
    wait;
  end process stimulus;

end architecture sim;
