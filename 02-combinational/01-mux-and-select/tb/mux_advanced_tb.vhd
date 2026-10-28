-- Testbench for advanced multiplexer with enable control across all three styles.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity mux_advanced_tb is
end entity mux_advanced_tb;

architecture sim of mux_advanced_tb is
  signal a, b, c, d : std_logic_vector(7 downto 0) := x"00";
  signal sel        : std_logic_vector(1 downto 0) := "00";
  signal en         : std_logic := '1';
  signal y_when     : std_logic_vector(7 downto 0);
  signal y_with     : std_logic_vector(7 downto 0);
  signal y_case     : std_logic_vector(7 downto 0);
begin

  dut : entity work.mux_advanced
    port map (
      a      => a,
      b      => b,
      c      => c,
      d      => d,
      sel    => sel,
      en     => en,
      y_when => y_when,
      y_with => y_with,
      y_case => y_case
    );

  stimulus : process
  begin
    a <= x"11";
    b <= x"22";
    c <= x"33";
    d <= x"44";
    wait for 1 ns;

    -- Test enabled selections
    for i in 0 to 3 loop
      sel <= std_logic_vector(to_unsigned(i, 2));
      en  <= '1';
      wait for 1 ns;

      case i is
        when 0 =>
          check_eq(y_when, x"11", "when/else sel 0");
          check_eq(y_with, x"11", "with/select sel 0");
          check_eq(y_case, x"11", "process/case sel 0");
        when 1 =>
          check_eq(y_when, x"22", "when/else sel 1");
          check_eq(y_with, x"22", "with/select sel 1");
          check_eq(y_case, x"22", "process/case sel 1");
        when 2 =>
          check_eq(y_when, x"33", "when/else sel 2");
          check_eq(y_with, x"33", "with/select sel 2");
          check_eq(y_case, x"33", "process/case sel 2");
        when others =>
          check_eq(y_when, x"44", "when/else sel 3");
          check_eq(y_with, x"44", "with/select sel 3");
          check_eq(y_case, x"44", "process/case sel 3");
      end case;
    end loop;

    -- Test disabled state (en = '0')
    en <= '0';
    sel <= "10";
    wait for 1 ns;
    check_eq(y_when, x"00", "when/else disabled");
    check_eq(y_with, x"00", "with/select disabled");
    check_eq(y_case, x"00", "process/case disabled");

    summary("mux_advanced_tb");
    wait;
  end process stimulus;

end architecture sim;
