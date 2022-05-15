library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity prbs_generator is
  port (
    reset : in std_logic;
    clk : in std_logic;

    din_ready : in std_logic;

    dout_prbs : out std_logic_vector;
    dout_valid : out std_logic
  );
end prbs_generator;

architecture rtl_bob of prbs_generator is

  signal prbs : std_logic_vector(22 downto 0);

begin

  process (clk)
    variable v_prbs : std_logic_vector(prbs'range);
  begin
    if rising_edge(clk) then
      v_prbs := prbs;
      for i in 0 to dout_prbs'length-1 loop
        v_prbs := v_prbs(v_prbs'high-1 downto 0) & (v_prbs(22) xor v_prbs(17));
      end loop;
      if din_ready = '1' then
        prbs <= v_prbs;
      end if;

      if reset = '1' then
        prbs <= (others => '1');
      end if;
    end if;
  end process;

  dout_prbs <= prbs(dout_prbs'range);
  dout_valid <= din_ready;

end;