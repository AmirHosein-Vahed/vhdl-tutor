-- Advanced 4:1 multiplexer demonstrating when/else, with/select, and case process styles with enable control.

library ieee;
use ieee.std_logic_1164.all;

entity mux_advanced is
  port (
    a, b, c, d : in  std_logic_vector(7 downto 0);
    sel        : in  std_logic_vector(1 downto 0);
    en         : in  std_logic;
    y_when     : out std_logic_vector(7 downto 0);
    y_with     : out std_logic_vector(7 downto 0);
    y_case     : out std_logic_vector(7 downto 0)
  );
end entity mux_advanced;

architecture rtl of mux_advanced is
begin

  -- 1. Conditional assignment (when/else) with enable
  y_when <= (others => '0') when en = '0' else
            a when sel = "00" else
            b when sel = "01" else
            c when sel = "10" else
            d;

  -- 2. Selected assignment (with/select) using concatenated en & sel
  with (en & sel) select
    y_with <= a when "100",
              b when "101",
              c when "110",
              d when "111",
              (others => '0') when others;

  -- 3. Process with case statement
  process (all)
    variable sel_full : std_logic_vector(2 downto 0);
  begin
    sel_full := en & sel;
    case sel_full is
      when "100"  => y_case <= a;
      when "101"  => y_case <= b;
      when "110"  => y_case <= c;
      when "111"  => y_case <= d;
      when others => y_case <= (others => '0');
    end case;
  end process;

end architecture rtl;
