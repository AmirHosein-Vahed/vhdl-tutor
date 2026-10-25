-- Every select value, through all three descriptions of the same mux.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity mux_styles_tb is
end entity mux_styles_tb;

architecture sim of mux_styles_tb is
  type byte_array_t is array (0 to 3) of std_logic_vector(7 downto 0);

  constant INPUTS : byte_array_t := (x"11", x"22", x"33", x"44");

  signal a, b, c, d : std_logic_vector(7 downto 0);
  signal sel        : std_logic_vector(1 downto 0) := "00";
  signal y_when     : std_logic_vector(7 downto 0);
  signal y_with     : std_logic_vector(7 downto 0);
  signal y_case     : std_logic_vector(7 downto 0);
begin

  a <= INPUTS(0);
  b <= INPUTS(1);
  c <= INPUTS(2);
  d <= INPUTS(3);

  dut : entity work.mux_styles
    port map (
      a      => a,
      b      => b,
      c      => c,
      d      => d,
      sel    => sel,
      y_when => y_when,
      y_with => y_with,
      y_case => y_case
    );

  stimulus : process
  begin
    for i in 0 to 3 loop
      sel <= std_logic_vector(to_unsigned(i, 2));
      wait for 1 ns;

      check_eq(y_when, INPUTS(i),
               "when/else, sel=" & integer'image(i));
      check_eq(y_with, INPUTS(i),
               "with/select, sel=" & integer'image(i));
      check_eq(y_case, INPUTS(i),
               "process/case, sel=" & integer'image(i));

      -- The three descriptions must never disagree.
      check(y_when = y_with and y_with = y_case,
            "all three styles agree, sel=" & integer'image(i));
    end loop;

    -- A selected assignment is not priority logic: this checks that the
    -- exhaustive choices above really cover the 2-bit select.
    sel <= "11";
    wait for 1 ns;
    check_eq(y_when, INPUTS(3), "default branch of when/else");
    check_eq(y_with, INPUTS(3), "when others of with/select");
    check_eq(y_case, INPUTS(3), "when others of case");

    summary("mux_styles_tb");
    wait;
  end process stimulus;

end architecture sim;
