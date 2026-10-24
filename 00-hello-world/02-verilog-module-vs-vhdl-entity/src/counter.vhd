-- A Verilog module, rewritten in VHDL.
--
-- Verilog:                    VHDL:
--   parameter W = 8             generic (W : positive := 8)
--   always @(posedge clk)       process (clk) ... rising_edge(clk)
--   reg [W-1:0] cnt             signal cnt : unsigned(W-1 downto 0)
--
-- There is no reg/wire split. Every signal is a wire; what makes it a
-- register is being assigned inside a clocked process.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  generic (
    W : positive := 8
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;                       -- synchronous, active high
    en    : in  std_logic;
    count : out std_logic_vector(W - 1 downto 0)
  );
end entity counter;

architecture rtl of counter is
  signal cnt : unsigned(W - 1 downto 0) := (others => '0');
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        cnt <= (others => '0');
      elsif en = '1' then
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  -- The port is std_logic_vector, the arithmetic happens in unsigned.
  count <= std_logic_vector(cnt);

end architecture rtl;
