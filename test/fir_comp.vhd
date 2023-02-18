library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_comp is
  port
  (
    reset           : in std_logic;
    clk             : in std_logic;

    din_data        : in std_logic_vector(15 downto 0);
    din_valid       : in std_logic;
    din_frame       : in std_logic;

    dout_data       : out  std_logic_vector(15 downto 0);
    dout_valid      : out  std_logic;
    dout_frame      : out  std_logic;

    reg_clk         : in  std_logic;
    reg_addr        : in  std_logic_vector(7 downto 0);
    reg_wr_data     : in  std_logic_vector(15 downto 0);
    reg_wr_en       : in  std_logic;
    reg_en          : in  std_logic;
    reg_rd_data     : out std_logic_vector(15 downto 0);
    reg_rd_ack      : out std_logic
  );
end fir_comp;

architecture rtl_bob of fir_comp is

  constant DATA_BITS : natural := din_data'length;
  constant NUM_TAPS  : natural := 16;

  type data_delay_t is array (0 to NUM_TAPS-1) of std_logic_vector(DATA_BITS-1 downto 0);
  type coeff_t is array (0 to NUM_TAPS-1) of std_logic_vector(DATA_BITS-1 downto 0);
  type carry_t is array (0 to NUM_TAPS) of std_logic_vector(47 downto 0);

  signal delayed_data : data_delay_t;
  signal carry_chain  : carry_t;
  signal coeffs       : coeff_t;

  signal new_coeff    : std_logic_vector(15 downto 0);
  signal coeff_we     : std_logic := '0';

  signal new_coeff_reg    : std_logic_vector(15 downto 0);
  signal coeff_we_reg     : std_logic := '0';

begin

  carry_chain(0)  <= (others => '0');

  process (clk) begin
    if rising_edge(clk) then
      if din_valid = '1' then
        delayed_data(0) <= din_data;
        for i in 0 to NUM_TAPS-2 loop
          delayed_data(i+1) <= delayed_data(i);
        end loop;
      end if;
    end if;
  end process;

  process (clk) begin
    if rising_edge(clk) then
      if coeff_we = '1' then
        coeffs(0) <= new_coeff;
        for i in 0 to NUM_TAPS-2 loop
          coeffs(i+1) <= coeffs(i);
        end loop;
      end if;
    end if;
  end process;

  gen_stages : for i in 0 to NUM_TAPS-1 generate
    fir : entity work.fir_stage
    port map
    (
      clk           => clk,

      din_data      => delayed_data(i),
      din_coeff     => coeffs(i),
      din_carry     => carry_chain(i),
      din_valid     => din_valid,

      dout_carry    => carry_chain(i+1)
    );
  end generate;

  dout_data  <= carry_chain(NUM_TAPS)(din_data'length + new_coeff'length + 4-1 downto new_coeff'length + 4);
  dout_valid <= din_valid;
  dout_frame <= din_frame; -- cba doing this properly

  process (clk) begin
    if rising_edge(clk) then
       new_coeff <= new_coeff_reg;
       coeff_we  <= coeff_we_reg;
    end if;
  end process;

  process (reg_clk) begin
    if rising_edge(reg_clk) then
      reg_rd_ack <= reg_en;
      coeff_we_reg <= '0';
      if reg_en = '1' then
        if reg_wr_en = '0' then
          case reg_addr is
            when x"00" =>
              reg_rd_data <= x"0f1b";
            when x"01" =>
              reg_rd_data <= std_logic_vector(new_coeff_reg);
            when others =>
              assert false report "Invalid reg address" severity error;
              reg_rd_data <= (others => '-');
          end case;
        else
          case reg_addr is
            when x"01" =>
              new_coeff_reg <= reg_wr_data;
              coeff_we_reg <= '1';
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;

end;