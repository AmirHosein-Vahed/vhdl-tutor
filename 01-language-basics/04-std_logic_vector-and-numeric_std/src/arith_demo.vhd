-- Arithmetic on std_logic_vector, done properly.
--
-- std_logic_vector is a bag of bits. Conversions to unsigned are explicit, and
-- widening is your job: 8 + 8 needs 9 bits, 8 * 8 needs 16.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arith_demo is
  port (
    a, b : in  std_logic_vector(7 downto 0);
    sum  : out std_logic_vector(8 downto 0);
    diff : out std_logic_vector(8 downto 0);
    prod : out std_logic_vector(15 downto 0);
    gt   : out std_logic;
    sat  : out std_logic_vector(7 downto 0)
  );
end entity arith_demo;

architecture rtl of arith_demo is
begin

  -- The concatenation widens the operands before adding, so the carry survives.
  sum <= std_logic_vector(('0' & unsigned(a)) + ('0' & unsigned(b)));

  -- Unsigned subtraction is modulo 2**9. It is correct when a >= b and wraps
  -- when it is not; the testbench checks both cases.
  diff <= std_logic_vector(('0' & unsigned(a)) - ('0' & unsigned(b)));

  -- 8 x 8 = 16 bits. Assigning this product to 8 bits would silently truncate.
  prod <= std_logic_vector(unsigned(a) * unsigned(b));

  gt <= '1' when unsigned(a) > unsigned(b) else '0';

  -- Saturating add: clamp to 255 instead of wrapping around.
  process (all)
    variable wide : unsigned(8 downto 0);
  begin
    wide := ('0' & unsigned(a)) + ('0' & unsigned(b));
    if wide > 255 then
      sat <= x"FF";
    else
      sat <= std_logic_vector(wide(7 downto 0));
    end if;
  end process;

end architecture rtl;
