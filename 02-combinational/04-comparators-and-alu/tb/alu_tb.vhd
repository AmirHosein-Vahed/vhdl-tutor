-- Testbench for ALU and comparators.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity alu_tb is
end entity alu_tb;

architecture sim of alu_tb is
  signal a, b    : std_logic_vector(7 downto 0) := (others => '0');
  signal op      : std_logic_vector(2 downto 0) := "000";
  signal result  : std_logic_vector(7 downto 0);
  signal zero    : std_logic;
begin

  dut : entity work.alu
    port map (
      a      => a,
      b      => b,
      op     => op,
      result => result,
      zero   => zero
    );

  stimulus : process
  begin
    a <= std_logic_vector(to_unsigned(10, 8));
    b <= std_logic_vector(to_unsigned(5, 8));

    -- ADD
    op <= "000";
    wait for 1 ns;
    check_eq(result, std_logic_vector(to_unsigned(15, 8)), "ALU ADD");
    check_eq(zero, '0', "ALU zero=0");

    -- SUB
    op <= "001";
    wait for 1 ns;
    check_eq(result, std_logic_vector(to_unsigned(5, 8)), "ALU SUB");

    -- SUB to zero
    b <= std_logic_vector(to_unsigned(10, 8));
    wait for 1 ns;
    check_eq(result, x"00", "ALU SUB zero result");
    check_eq(zero, '1', "ALU zero=1");

    -- AND
    a <= x"F0";
    b <= x"0F";
    op <= "010";
    wait for 1 ns;
    check_eq(result, x"00", "ALU AND");

    summary("alu_tb");
    wait;
  end process stimulus;

end architecture sim;
