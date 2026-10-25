-- Every literal form that means 255, plus the one type that is not a number.
--
-- Verilog habit:                  VHDL:
--   logic [7:0] x = 8'hFF;          signal x : std_logic_vector(7 downto 0) := x"FF";
--   localparam int N = 1_000_000;   constant N : integer := 1_000_000;
--
-- There is no `logic` here. std_logic is a resolved 9-value type, and
-- std_logic_vector is an array of it until you explicitly say otherwise.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity literals is
  port (
    hex_255     : out std_logic_vector(7 downto 0);
    bin_255     : out std_logic_vector(7 downto 0);
    based_255   : out std_logic_vector(7 downto 0);
    dec_255     : out std_logic_vector(7 downto 0);
    underscored : out natural
  );
end entity literals;

architecture rtl of literals is
  constant C_HEX   : std_logic_vector(7 downto 0) := x"FF";
  constant C_BIN   : std_logic_vector(7 downto 0) := "11111111";
  constant C_BASED : integer := 16#FF#;
  constant C_DEC   : unsigned(7 downto 0) := to_unsigned(255, 8);
  constant C_UNDER : natural := 1_000_000;
begin

  hex_255   <= C_HEX;
  bin_255   <= C_BIN;
  based_255 <= std_logic_vector(to_unsigned(C_BASED, 8));
  dec_255   <= std_logic_vector(C_DEC);

  -- Underscores are ignored by the lexer; they are for humans.
  underscored <= C_UNDER;

end architecture rtl;
