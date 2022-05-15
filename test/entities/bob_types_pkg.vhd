library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

package bob_types is

  constant DATA_BITS : natural := 8;

  type iq_8_t is record
    i        : std_logic_vector(DATA_BITS-1 downto 0);
    q        : std_logic_vector(DATA_BITS-1 downto 0);
    valid    : std_logic;
    pps      : std_logic;
  end record;

end bob_types;

package body bob_types is

end package body;