-- Testbench for decoder and priority encoder.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_utils.all;

entity decoder_encoder_tb is
end entity decoder_encoder_tb;

architecture sim of decoder_encoder_tb is
  signal bin_in  : std_logic_vector(2 downto 0) := "000";
  signal dec_out : std_logic_vector(7 downto 0);
  signal enc_in  : std_logic_vector(7 downto 0) := (others => '0');
  signal enc_out : std_logic_vector(2 downto 0);
  signal valid   : std_logic;
begin

  dut : entity work.decoder_encoder
    port map (
      bin_in  => bin_in,
      dec_out => dec_out,
      enc_in  => enc_in,
      enc_out => enc_out,
      valid   => valid
    );

  stimulus : process
  begin
    -- Test decoder
    for i in 0 to 7 loop
      bin_in <= std_logic_vector(to_unsigned(i, 3));
      wait for 1 ns;
      check_eq(dec_out, std_logic_vector(shift_left(to_unsigned(1, 8), i)),
               "decoder output for " & integer'image(i));
    end loop;

    -- Test priority encoder
    enc_in <= "00000000";
    wait for 1 ns;
    check_eq(valid, '0', "encoder all zeros valid=0");

    enc_in <= "00010000"; -- bit 4
    wait for 1 ns;
    check_eq(valid, '1', "encoder bit 4 valid=1");
    check_eq(enc_out, "100", "encoder bit 4 index");

    enc_in <= "10100000"; -- bits 7 and 5 set, priority to 7
    wait for 1 ns;
    check_eq(valid, '1', "encoder priority valid=1");
    check_eq(enc_out, "111", "encoder priority index 7");

    summary("decoder_encoder_tb");
    wait;
  end process stimulus;

end architecture sim;
