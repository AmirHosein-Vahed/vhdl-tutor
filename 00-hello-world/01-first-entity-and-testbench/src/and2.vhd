-- The smallest complete design: a two-input AND gate.
--
-- The entity is the interface, the architecture is the behaviour.
-- There is no `module`, no `assign`, and no implicit clock.

library ieee;
use ieee.std_logic_1164.all;

entity and2 is
  port (
    a : in  std_logic;
    b : in  std_logic;
    y : out std_logic
  );
end entity and2;

architecture rtl of and2 is
begin

  y <= a and b;

end architecture rtl;
