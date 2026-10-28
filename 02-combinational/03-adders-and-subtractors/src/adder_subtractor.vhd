-- Adder and subtractor with carry-out and signed overflow detection.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_subtractor is
  port (
    a, b     : in  std_logic_vector(7 downto 0);
    sub      : in  std_logic; -- '0' for add, '1' for subtract
    sum      : out std_logic_vector(7 downto 0);
    cout     : out std_logic;
    overflow : out std_logic
  );
end entity adder_subtractor;

architecture rtl of adder_subtractor is
  signal res_uns : unsigned(8 downto 0);
  signal res_s   : signed(7 downto 0);
begin

  -- Unsigned addition / subtraction with carry-out
  process (all)
  begin
    if sub = '1' then
      res_uns <= unsigned('0' & a) + unsigned('0' & not b) + 1;
    else
      res_uns <= unsigned('0' & a) + unsigned('0' & b);
    end if;
  end process;

  sum  <= std_logic_vector(res_uns(7 downto 0));
  cout <= res_uns(8);

  -- Signed overflow detection
  process (all)
    variable a_val, b_val : signed(7 downto 0);
  begin
    a_val := signed(a);
    if sub = '1' then
      b_val := -signed(b);
      res_s <= signed(a) - signed(b);
    else
      b_val := signed(b);
      res_s <= signed(a) + signed(b);
    end if;

    if (a_val(7) = b_val(7)) and (res_s(7) /= a_val(7)) then
      overflow <= '1';
    else
      overflow <= '0';
    end if;
  end process;

end architecture rtl;
