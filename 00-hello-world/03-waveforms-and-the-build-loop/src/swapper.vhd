-- Two signals swapped in one clocked process.
--
-- This is the delta-cycle demo. In software both lines would run in order;
-- in VHDL both right-hand sides are evaluated before either assignment takes
-- effect. That is why a swap needs no temporary variable here.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity swapper is
  port (
    clk : in  std_logic;
    a   : out std_logic_vector(7 downto 0);
    b   : out std_logic_vector(7 downto 0)
  );
end entity swapper;

architecture rtl of swapper is
  -- Initial values are an FPGA/simulation convenience, not a substitute
  -- for a reset. Topic 03 explains when they are acceptable.
  signal ra : std_logic_vector(7 downto 0) := x"12";
  signal rb : std_logic_vector(7 downto 0) := x"34";
begin

  process (clk)
  begin
    if rising_edge(clk) then
      ra <= rb;
      -- `ra` still holds its OLD value on this line: the assignment above
      -- has only been scheduled, it has not happened yet.
      report "inside the clocked process, ra is still " & to_hstring(ra)
        severity note;
      rb <= ra;
    end if;
  end process;

  a <= ra;
  b <= rb;

end architecture rtl;
