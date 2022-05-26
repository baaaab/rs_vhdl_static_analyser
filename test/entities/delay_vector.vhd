library ieee;
use ieee.std_logic_1164.all;

entity delay_vector is
  generic
  (
    DELAY : integer := 32
  );
  port
  (
    clk   : in std_logic;
    clken : in std_logic := '1';
    d     : in std_logic_vector;
    q     : out std_logic_vector
  );

end delay_vector;

architecture archi of delay_vector is
  type array_t is array(DELAY - 1 downto 0) of std_logic_vector(d'range);
  signal shreg : array_t;
begin

  process (clk) begin
    if rising_edge(clk) then
      if clken = '1' then
        for i in 0 to DELAY-2 loop
          shreg(i+1) <= shreg(i);
        end loop;
        shreg(0) <= d;
      end if;
    end if;
  end process;

  q <= shreg(DELAY - 1);

end archi;