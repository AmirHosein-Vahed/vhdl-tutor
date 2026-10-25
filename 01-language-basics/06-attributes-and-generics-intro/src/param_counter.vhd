-- A counter whose width and terminal count are generics.
--
-- Verilog:  parameter WIDTH = 8, parameter MAX = 0
--           #(.WIDTH(16), .MAX(1000))
-- VHDL:     generic (WIDTH : positive := 8; MAX : natural := 0)
--           generic map (WIDTH => 16, MAX => 1000)
--
-- Attributes and `others` keep the body independent of the actual width.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity param_counter is
  generic (
    WIDTH : positive := 8;
    MAX   : natural  := 0        -- terminal count; 0 means 2**WIDTH - 1
  );
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    en     : in  std_logic;
    count  : out std_logic_vector(WIDTH - 1 downto 0);
    at_max : out std_logic
  );
end entity param_counter;

architecture rtl of param_counter is

  -- At elaboration time, turn the generic MAX into a WIDTH-bit value.
  function terminal_count return unsigned is
  begin
    if MAX = 0 then
      return (WIDTH - 1 downto 0 => '1');
    else
      return to_unsigned(MAX, WIDTH);
    end if;
  end function terminal_count;

  constant TOP_COUNT : unsigned(WIDTH - 1 downto 0) := terminal_count;
  signal cnt         : unsigned(WIDTH - 1 downto 0) := (others => '0');

begin

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        cnt <= (others => '0');
      elsif en = '1' then
        if cnt = TOP_COUNT then
          cnt <= (others => '0');
        else
          cnt <= cnt + 1;
        end if;
      end if;
    end if;
  end process;

  count  <= std_logic_vector(cnt);
  at_max <= '1' when cnt = TOP_COUNT else '0';

end architecture rtl;
