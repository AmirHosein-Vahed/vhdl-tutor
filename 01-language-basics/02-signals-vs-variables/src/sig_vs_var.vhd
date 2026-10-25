-- Two assignments that look identical, executed by two different rules.
--
-- Signals: `s1 <= d; s2 <= s1;` schedules both updates for the end of the
-- delta cycle, so s2 receives the *old* s1.
--
-- Variables: `v1 := d; v2 := v1;` runs immediately, so v2 receives the *new*
-- v1 on the same line that produced it.

library ieee;
use ieee.std_logic_1164.all;

entity sig_vs_var is
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    d     : in  std_logic;
    q_sig : out std_logic;
    q_var : out std_logic
  );
end entity sig_vs_var;

architecture rtl of sig_vs_var is
  signal s1, s2 : std_logic;
begin

  -- Signal version: a two-stage shift register. q_sig is one cycle behind q_var.
  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        s1 <= '0';
        s2 <= '0';
      else
        s1 <= d;
        s2 <= s1;      -- old s1, because the update is scheduled
      end if;
    end if;
  end process;

  -- Variable version: the variable assignments happen in source order, before
  -- q_var is scheduled. This is not a two-stage register.
  process (clk)
    variable v1, v2 : std_logic;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        v1 := '0';
        v2 := '0';
      else
        v1 := d;
        v2 := v1;      -- new v1, assigned one line above
      end if;
      q_var <= v2;
    end if;
  end process;

  q_sig <= s2;

end architecture rtl;
