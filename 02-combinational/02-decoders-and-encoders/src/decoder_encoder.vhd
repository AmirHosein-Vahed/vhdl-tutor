-- Binary decoder and priority encoder implementation.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_encoder is
  port (
    bin_in  : in  std_logic_vector(2 downto 0);
    dec_out : out std_logic_vector(7 downto 0);
    enc_in  : in  std_logic_vector(7 downto 0);
    enc_out : out std_logic_vector(2 downto 0);
    valid   : out std_logic
  );
end entity decoder_encoder;

architecture rtl of decoder_encoder is
begin

  -- 3-to-8 Binary Decoder using with/select
  with bin_in select
    dec_out <= "00000001" when "000",
               "00000010" when "001",
               "00000100" when "010",
               "00001000" when "011",
               "00010000" when "100",
               "00100000" when "101",
               "01000000" when "110",
               "10000000" when others;

  -- 8-to-3 Priority Encoder (highest index 7 has highest priority)
  process (all)
  begin
    enc_out <= "000";
    valid   <= '0';

    for i in 7 downto 0 loop
      if enc_in(i) = '1' then
        enc_out <= std_logic_vector(to_unsigned(i, 3));
        valid   <= '1';
        exit;
      end if;
    end loop;
  end process;

end architecture rtl;
