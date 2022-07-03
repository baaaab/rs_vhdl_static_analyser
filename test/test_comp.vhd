library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.bob_types.all;

entity test_comp is
  port
  (
    reset         : in std_logic;
    clk           : in std_logic;

    din           : in iq_8_t;

    dout          : out iq_8_t;
    dout_sq_power : out std_logic_vector(15 downto 0);
    dout_frame    : out std_logic;

    reg_clk       : in  std_logic;
    reg_addr      : in  std_logic_vector(7 downto 0);
    reg_wr_data   : in  std_logic_vector(15 downto 0);
    reg_wr_en     : in  std_logic;
    reg_en        : in  std_logic;
    reg_rd_data   : out std_logic_vector(15 downto 0);
    reg_rd_ack    : out std_logic
  );
end test_comp;

architecture rtl_bob of test_comp is

  signal din_r            : iq_8_t;

  signal abs_i            : std_logic_vector(7 downto 0);
  signal abs_q            : std_logic_vector(7 downto 0);
  signal abs_pow          : std_logic_vector(15 downto 0);
  signal abs_valid        : std_logic;
  signal abs_pps          : std_logic;

  signal ram_wr_addr      : std_logic_vector(8 downto 0);
  signal ram_wr_data      : std_logic_vector(abs_i'length + abs_q'length + abs_pow'length + 1 - 1 downto 0);
  signal ram_wr_en        : std_logic;

  signal ram_rd_addr      : std_logic_vector(ram_wr_addr'range);
  signal ram_rd_data      : std_logic_vector(ram_wr_data'range);

  signal ram_rd_valid     : std_logic;
  signal ram_rd_valid_r   : std_logic;
  signal ram_rd_valid_rr  : std_logic;

  signal ram_out_i        : std_logic_vector(7 downto 0);
  signal ram_out_q        : std_logic_vector(7 downto 0);
  signal ram_out_pow      : std_logic_vector(15 downto 0);
  signal ram_out_pps      : std_logic;
  signal abs_pow_delayed  : std_logic_vector(15 downto 0);

  signal ram_out_i_r      : std_logic_vector(7 downto 0);
  signal ram_out_q_r      : std_logic_vector(7 downto 0);
  signal ram_out_pow_r    : std_logic_vector(15 downto 0);
  signal ram_out_valid_r  : std_logic;
  signal ram_out_pps_r    : std_logic;
  signal power_difference : signed(16 downto 0);

  signal ram_out_i_rr      : std_logic_vector(7 downto 0);
  signal ram_out_q_rr      : std_logic_vector(7 downto 0);
  signal ram_out_pow_rr    : std_logic_vector(15 downto 0);
  signal ram_out_valid_rr  : std_logic;
  signal ram_out_pps_rr    : std_logic;
  signal edge_detected     : std_logic;

  signal threshold        : std_logic_vector(15 downto 0);
  signal threshold_reg    : std_logic_vector(threshold'range);
  signal threshold_reg_r  : std_logic_vector(threshold'range);


begin

  process (clk) begin
    if rising_edge(clk) then
      din_r     <= din;
    end if;
  end process;

  abs_sq : entity work.abs_square
  port map
  (
    reset        => reset,
    clk          => clk,

    din_i        => din_r.i,
    din_q        => din_r.q,
    din_valid    => din_r.valid,
    din_mark(0)  => din_r.pps,

    dout_i       => abs_i,
    dout_q       => abs_q,
    dout_valid   => abs_valid,
    dout_pow_sq  => abs_pow,
    dout_mark(0) => abs_pps
  );

  dv : entity work.delay_vector
  generic map
  (
    DELAY => 4
  )
  port map
  (
    clk => clk,
    clken => '1',
    d => abs_pow,
    q => abs_pow_delayed
  );

  process (clk) begin
    if rising_edge(clk) then
      ram_wr_data <= abs_pow & abs_i & abs_q & abs_pps;
      ram_wr_en   <= abs_valid;
      if abs_valid = '1' then
        ram_wr_addr <= std_logic_vector(unsigned(ram_wr_addr) + 1);
      end if;

      if reset = '1' then
        ram_wr_addr <= (others => '0');
      end if;
    end if;
  end process;

  ram_inst : entity work.async_dpram
  generic map
  (
    ADDR_BITS  => ram_wr_addr'length,
    DATA_BITS  => ram_wr_data'length,
    OUTPUT_REG => true
  )
  port map
  (
    clka  => clk,
    clkb  => clk,

    wea   => ram_wr_en,
    addra => ram_wr_addr,
    dia   => ram_wr_data,
    doa   => open,

    web   => '0',
    addrb => ram_rd_addr,
    dib   => "000000000000000000000000000000000",
    dob   => ram_rd_data
  );

  process (clk) begin
    if rising_edge(clk) then
      ram_rd_addr     <= std_logic_vector(unsigned(ram_wr_addr) - to_unsigned(400, ram_rd_addr'length));

      ram_rd_valid    <= abs_valid;
      ram_rd_valid_r  <= ram_rd_valid;
      ram_rd_valid_rr <= ram_rd_valid_r;
    end if;
  end process;

  ram_out_pow <= ram_rd_data(32 downto 17);
  ram_out_i   <= ram_rd_data(16 downto 9);
  ram_out_q   <= ram_rd_data(8 downto 1);
  ram_out_pps <= ram_rd_data(0);

  process (clk) begin
    if rising_edge(clk) then
      ram_out_i_r      <= ram_out_i;
      ram_out_q_r      <= ram_out_q;
      ram_out_pow_r    <= ram_out_pow;
      ram_out_valid_r  <= ram_rd_valid_rr;
      ram_out_pps_r    <= ram_out_pps;
      power_difference <= signed('0' & abs_pow_delayed) - signed('0' & ram_out_pow);
    end if;
  end process;


  process (clk) begin
    if rising_edge(clk) then
      ram_out_i_rr      <= ram_out_i_r;
      ram_out_q_rr      <= ram_out_q_r;
      ram_out_pow_rr    <= ram_out_pow_r;
      ram_out_valid_rr  <= ram_out_valid_r;
      ram_out_pps_rr    <= ram_out_pps_r;
      edge_detected     <= '0';
      if power_difference > signed('0' & threshold) then
        edge_detected   <= '1';
      end if;
    end if;
  end process;

  process (clk) begin
    if rising_edge(clk) then
      dout.i        <= ram_out_i_rr;
      dout.q        <= ram_out_q_rr;
      dout_sq_power <= ram_out_pow_rr;
      dout.valid    <= ram_out_valid_rr;
      dout.pps      <= ram_out_pps_rr;
      dout_frame    <= edge_detected;
    end if;
  end process;

  process (clk) begin
    if rising_edge(clk) then
      threshold_reg_r <= threshold_reg;
      threshold       <= threshold_reg_r;
    end if;
  end process;

  process (reg_clk) begin
    if rising_edge(reg_clk) then
      reg_rd_ack <= reg_en;
      if reg_en = '1' then
        if reg_wr_en = '0' then
          case reg_addr is
            when x"00" =>
              reg_rd_data <= x"0b0b";
            when x"01" =>
              reg_rd_data <= threshold_reg;
            when others =>
              assert false report "Invalid reg address" severity error;
              reg_rd_data <= (others => '-');
          end case;
        else
          case reg_addr is
            when x"01" =>
              threshold_reg <= reg_wr_data;
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;

end;