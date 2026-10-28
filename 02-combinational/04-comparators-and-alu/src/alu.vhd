-- Small combinational ALU and comparator implementation.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
    a, b    : in  std_logic_vector(7 downto 0);
    op      : in  std_logic_vector(2 downto 0);
    result  : out std_logic_vector(7 downto 0);
    zero    : out std_logic
  );
end entity alu;

architecture rtl of alu is
  signal res_int : std_logic_vector(7 downto 0);
begin

  process (all)
  begin
    case op is
      when "000"  => res_int <= std_logic_vector(unsigned(a) + unsigned(b)); -- ADD
      when "001"  => res_int <= std_logic_vector(unsigned(a) - unsigned(b)); -- SUB
      when "010"  => res_int <= a and b;                                      -- AND
      when "011"  => res_int <= a or b;                                       -- OR
      when "100"  => res_int <= a xor b;                                      -- XOR
      when "101"  =>                                                          -- SLT (signed less than)
                     if signed(a) < signed(b) then
                       res_int <= x"01";
                     else
                       res_int <= x"00";
                     end if;
      when others => res_int <= (others => '0');
    end case;
  end process;

  result <= res_int;
  zero   <= '1' when res_int = x"00" else '0';

end architecture rtl;
