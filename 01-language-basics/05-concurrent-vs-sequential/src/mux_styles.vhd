-- One 4:1 multiplexer, three descriptions, identical hardware.
--
-- y_when uses conditional signal assignments (a priority chain),
-- y_with uses a selected signal assignment (a parallel case),
-- y_case uses sequential syntax inside a process.

library ieee;
use ieee.std_logic_1164.all;

entity mux_styles is
  port (
    a, b, c, d : in  std_logic_vector(7 downto 0);
    sel        : in  std_logic_vector(1 downto 0);
    y_when     : out std_logic_vector(7 downto 0);
    y_with     : out std_logic_vector(7 downto 0);
    y_case     : out std_logic_vector(7 downto 0)
  );
end entity mux_styles;

architecture rtl of mux_styles is
begin

  -- 1. Conditional assignment. Order matters: the first true branch wins.
  y_when <= a when sel = "00" else
            b when sel = "01" else
            c when sel = "10" else
            d;

  -- 2. Selected assignment. Exactly one branch matches and the choices must
  --    cover every possible value of sel.
  with sel select
    y_with <= a when "00",
              b when "01",
              c when "10",
              d when others;

  -- 3. A process with case. `process (all)` is VHDL-2008 and replaces the
  --    hand-written sensitivity list.
  process (all)
  begin
    case sel is
      when "00"   => y_case <= a;
      when "01"   => y_case <= b;
      when "10"   => y_case <= c;
      when others => y_case <= d;
    end case;
  end process;

end architecture rtl;
