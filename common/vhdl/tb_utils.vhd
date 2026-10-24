-- tb_utils: the smallest useful testbench helper package.
--
-- Usage:
--
--   use work.tb_utils.all;
--   ...
--   check_eq(y, '1', "1 and 1");
--   summary("and2_tb");       -- prints PASS/FAIL and ends the simulation
--
-- Individual failures are reported at severity warning so the run continues
-- and you see every failure. The summary is reported at severity failure,
-- which stops the simulation with a non-zero exit code for CI.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tb_utils is

  -- Count one check. Pass when condition is true.
  procedure check(condition : boolean; message : string);

  -- Compare an actual value with the expected one.
  procedure check_eq(actual, expected : std_logic; message : string);
  procedure check_eq(actual, expected : std_logic_vector; message : string);
  procedure check_eq(actual, expected : unsigned; message : string);
  procedure check_eq(actual, expected : signed; message : string);
  procedure check_eq(actual, expected : integer; message : string);
  procedure check_eq(actual, expected : boolean; message : string);

  -- Wait for n rising edges of clk. Call from a process.
  procedure tick(signal clk : in std_logic; n : positive := 1);

  -- Print "name: PASS (n checks)" or "name: FAIL (m of n)" and finish.
  procedure summary(name : string);

end package tb_utils;


package body tb_utils is

  type results_t is protected
    procedure passed;
    procedure failed(message : string);
    procedure finish(name : string);
  end protected results_t;

  type results_t is protected body
    variable checks   : natural := 0;
    variable failures : natural := 0;

    procedure passed is
    begin
      checks := checks + 1;
    end procedure passed;

    procedure failed(message : string) is
    begin
      checks   := checks + 1;
      failures := failures + 1;
      report "FAIL: " & message severity warning;
    end procedure failed;

    procedure finish(name : string) is
    begin
      if failures = 0 then
        report name & ": PASS (" & integer'image(checks) & " checks)"
          severity note;
        std.env.finish;
      else
        report name & ": FAIL (" & integer'image(failures) & " of "
               & integer'image(checks) & " checks failed)"
          severity failure;
      end if;
    end procedure finish;
  end protected body results_t;

  shared variable results : results_t;

  procedure check(condition : boolean; message : string) is
  begin
    if condition then
      results.passed;
    else
      results.failed(message);
    end if;
  end procedure check;

  procedure check_eq(actual, expected : std_logic; message : string) is
  begin
    if actual = expected then
      results.passed;
    else
      results.failed(message & " (expected " & std_logic'image(expected)
                     & ", got " & std_logic'image(actual) & ")");
    end if;
  end procedure check_eq;

  procedure check_eq(actual, expected : std_logic_vector; message : string) is
  begin
    if actual = expected then
      results.passed;
    else
      results.failed(message & " (expected " & to_hstring(expected)
                     & ", got " & to_hstring(actual) & ")");
    end if;
  end procedure check_eq;

  procedure check_eq(actual, expected : unsigned; message : string) is
  begin
    if actual = expected then
      results.passed;
    else
      results.failed(message & " (expected " & to_hstring(expected)
                     & ", got " & to_hstring(actual) & ")");
    end if;
  end procedure check_eq;

  procedure check_eq(actual, expected : signed; message : string) is
  begin
    if actual = expected then
      results.passed;
    else
      results.failed(message & " (expected " & to_hstring(expected)
                     & ", got " & to_hstring(actual) & ")");
    end if;
  end procedure check_eq;

  procedure check_eq(actual, expected : integer; message : string) is
  begin
    if actual = expected then
      results.passed;
    else
      results.failed(message & " (expected " & integer'image(expected)
                     & ", got " & integer'image(actual) & ")");
    end if;
  end procedure check_eq;

  procedure check_eq(actual, expected : boolean; message : string) is
  begin
    if actual = expected then
      results.passed;
    else
      results.failed(message & " (expected " & boolean'image(expected)
                     & ", got " & boolean'image(actual) & ")");
    end if;
  end procedure check_eq;

  procedure tick(signal clk : in std_logic; n : positive := 1) is
  begin
    for i in 1 to n loop
      wait until rising_edge(clk);
    end loop;
  end procedure tick;

  procedure summary(name : string) is
  begin
    results.finish(name);
  end procedure summary;

end package body tb_utils;
