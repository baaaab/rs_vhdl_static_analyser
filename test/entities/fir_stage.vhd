library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_stage is
  port
  (
    clk : in std_logic;

    din_data  : in std_logic_vector;
    din_coeff : in std_logic_vector;
    din_carry : in std_logic_vector;
    din_valid : in std_logic;

    dout_carry : out std_logic_vector
  );
end entity fir_stage;

architecture rtl of fir_stage is

  signal din_data_r  : signed(din_data'range);

  signal mult        : signed(din_data'length + din_coeff'length - 1 downto 0);

begin

  process (clk) begin
    if rising_edge(clk) then
      if din_valid = '1' then
        din_data_r <= signed(din_data);
      end if;
    end if;
  end process;

  process (clk) begin
    if rising_edge(clk) then
      if din_valid = '1' then
        mult <= din_data_r * signed(din_coeff);
      end if;
    end if;
  end process;

  process (clk) begin
    if rising_edge(clk) then
      if din_valid = '1' then
        dout_carry <= std_logic_vector(signed(din_carry) + resize(mult, dout_carry'length));
      end if;
    end if;
  end process;

end rtl;