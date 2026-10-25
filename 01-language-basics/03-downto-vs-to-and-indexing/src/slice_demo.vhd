-- Slicing, reversing, and the two array directions.
--
-- A range is part of the subtype: `(7 downto 0)` and `(0 to 3)` both hold
-- eight or four bits, but they disagree about which index is leftmost.

library ieee;
use ieee.std_logic_1164.all;

entity slice_demo is
  port (
    din         : in  std_logic_vector(7 downto 0);
    high_nibble : out std_logic_vector(3 downto 0);
    low_nibble  : out std_logic_vector(3 downto 0);
    reversed    : out std_logic_vector(7 downto 0);
    msb_is      : out std_logic;
    lsb_is      : out std_logic;
    descending  : out std_logic_vector(3 downto 0);
    ascending   : out std_logic_vector(0 to 3)
  );
end entity slice_demo;

architecture rtl of slice_demo is

  -- Works for any direction, because it uses the argument's own attributes.
  -- For v'range = 7 downto 0: r(7) := v(0) ... r(0) := v(7).
  function reverse(v : std_logic_vector) return std_logic_vector is
    variable r : std_logic_vector(v'range);
  begin
    for i in v'range loop
      r(i) := v(v'high + v'low - i);
    end loop;
    return r;
  end function reverse;

begin

  high_nibble <= din(7 downto 4);
  low_nibble  <= din(3 downto 0);
  reversed    <= reverse(din);

  -- Attributes instead of hard-coded indices.
  msb_is <= din(din'high);
  lsb_is <= din(din'low);

  -- The same string literal, assigned to two different directions.
  -- descending(3) is the leftmost bit; ascending(0) is the leftmost bit.
  descending <= "1010";
  ascending  <= "1010";

end architecture rtl;
