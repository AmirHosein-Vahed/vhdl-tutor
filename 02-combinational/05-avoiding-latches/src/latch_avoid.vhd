-- Demonstration of latch avoidance via default signal assignments.

library ieee;
use ieee.std_logic_1164.all;

entity latch_avoid is
  port (
    sel : in  std_logic;
    d   : in  std_logic_vector(7 downto 0);
    y   : out std_logic_vector(7 downto 0)
  );
end entity latch_avoid;

architecture rtl of latch_avoid is
begin

  -- Providing a default assignment at the start of the process prevents latch inference.
  process (all)
  begin
    y <= (others => '0');

    if sel = '1' then
      y <= d;
    end if;
  end process;

end architecture rtl;
