library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.bob_types.all;
entity test_comp is
  port (
    reset: in std_logic;
    clk: in std_logic;
    din: in iq_8_t;
    dout: out iq_8_t;
    dout_sq_power: out std_logic_vector (15 downto 0);
    dout_frame: out std_logic;
    reg_clk: in std_logic;
    reg_addr: in std_logic_vector (7 downto 0);
    reg_wr_data: in std_logic_vector (15 downto 0);
    reg_wr_en: in std_logic;
    reg_en: in std_logic;
    reg_rd_data: out std_logic_vector (15 downto 0);
    reg_rd_ack: out std_logic
  );
end test_comp;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_bit_4 is
  port (
    clk : in std_logic;
    clken : in std_logic;
    d : in std_logic;
    q : out std_logic);
end entity delay_bit_4;

architecture rtl of delay_bit_4 is
  signal shreg : std_logic_vector (3 downto 0);
  signal n338_o : std_logic;
  signal n339_o : std_logic;
  signal n340_o : std_logic;
  signal n341_o : std_logic_vector (3 downto 0);
  signal n345_o : std_logic_vector (3 downto 0);
  signal n346_q : std_logic_vector (3 downto 0);
  signal n347_o : std_logic;
begin
  q <= n347_o;
  -- entities/delay_bit.vhd:20:10
  shreg <= n346_q; -- (signal)
  -- entities/delay_bit.vhd:30:30
  n338_o <= shreg (0);
  -- entities/delay_bit.vhd:30:30
  n339_o <= shreg (1);
  -- entities/delay_bit.vhd:30:30
  n340_o <= shreg (2);
  n341_o <= n340_o & n339_o & n338_o & d;
  -- entities/delay_bit.vhd:26:5
  n345_o <= shreg when clken = '0' else n341_o;
  -- entities/delay_bit.vhd:26:5
  process (clk)
  begin
    if rising_edge (clk) then
      n346_q <= n345_o;
    end if;
  end process;
  -- entities/delay_bit.vhd:37:13
  n347_o <= shreg (3);
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_vector_4_c17fd92682ca5b304ac71074b558dda9e8eb4d66 is
  port (
    clk : in std_logic;
    clken : in std_logic;
    d : in std_logic;
    q : out std_logic);
end entity delay_vector_4_c17fd92682ca5b304ac71074b558dda9e8eb4d66;

architecture rtl of delay_vector_4_c17fd92682ca5b304ac71074b558dda9e8eb4d66 is
  signal shreg : std_logic_vector (3 downto 0);
  signal n324_o : std_logic;
  signal n325_o : std_logic;
  signal n326_o : std_logic;
  signal n327_o : std_logic_vector (3 downto 0);
  signal n331_o : std_logic_vector (3 downto 0);
  signal n332_q : std_logic_vector (3 downto 0);
  signal n333_o : std_logic;
begin
  q <= n333_o;
  -- entities/delay_vector.vhd:21:10
  shreg <= n332_q; -- (signal)
  -- entities/delay_vector.vhd:30:30
  n324_o <= shreg (0);
  -- entities/delay_vector.vhd:30:30
  n325_o <= shreg (1);
  -- entities/delay_vector.vhd:30:30
  n326_o <= shreg (2);
  -- entities/async_dpram.vhd:56:19
  n327_o <= n326_o & n325_o & n324_o & d;
  -- entities/delay_vector.vhd:27:5
  n331_o <= shreg when clken = '0' else n327_o;
  -- entities/delay_vector.vhd:27:5
  process (clk)
  begin
    if rising_edge (clk) then
      n332_q <= n331_o;
    end if;
  end process;
  -- entities/delay_vector.vhd:37:13
  n333_o <= shreg (3);
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_dpram_9_33_bf8b4530d8d246dd74ac53a13471bba17941dff7 is
  port (
    clka : in std_logic;
    clkb : in std_logic;
    wea : in std_logic;
    web : in std_logic;
    addra : in std_logic_vector (8 downto 0);
    addrb : in std_logic_vector (8 downto 0);
    dia : in std_logic_vector (32 downto 0);
    dib : in std_logic_vector (32 downto 0);
    doa : out std_logic_vector (32 downto 0);
    dob : out std_logic_vector (32 downto 0));
end entity async_dpram_9_33_bf8b4530d8d246dd74ac53a13471bba17941dff7;

architecture rtl of async_dpram_9_33_bf8b4530d8d246dd74ac53a13471bba17941dff7 is
  signal ram_out_a : std_logic_vector (32 downto 0);
  signal ram_out_b : std_logic_vector (32 downto 0);
  signal addra_r : std_logic_vector (8 downto 0);
  signal addrb_r : std_logic_vector (8 downto 0);
  signal n283_q : std_logic_vector (8 downto 0);
  signal n298_q : std_logic_vector (8 downto 0);
  signal n307_q : std_logic_vector (32 downto 0);
  signal n313_q : std_logic_vector (32 downto 0);
  signal n316_data : std_logic_vector (32 downto 0);
  signal n317_data : std_logic_vector (32 downto 0);
begin
  doa <= n307_q;
  dob <= n313_q;
  -- entities/async_dpram.vhd:31:10
  ram_out_a <= n317_data; -- (signal)
  -- entities/async_dpram.vhd:32:10
  ram_out_b <= n316_data; -- (signal)
  -- entities/async_dpram.vhd:34:10
  addra_r <= n283_q; -- (signal)
  -- entities/async_dpram.vhd:35:10
  addrb_r <= n298_q; -- (signal)
  -- entities/async_dpram.vhd:39:5
  process (clka)
  begin
    if rising_edge (clka) then
      n283_q <= addra;
    end if;
  end process;
  -- entities/async_dpram.vhd:49:5
  process (clkb)
  begin
    if rising_edge (clkb) then
      n298_q <= addrb;
    end if;
  end process;
  -- entities/async_dpram.vhd:60:7
  process (clka)
  begin
    if rising_edge (clka) then
      n307_q <= ram_out_a;
    end if;
  end process;
  -- entities/async_dpram.vhd:66:7
  process (clkb)
  begin
    if rising_edge (clkb) then
      n313_q <= ram_out_b;
    end if;
  end process;
  -- entities/async_dpram.vhd:22:5
  process (addrb_r, addra_r, clkb, clka) is
    type ram_type is array (0 to 511)
      of std_logic_vector (32 downto 0);
    variable ram : ram_type := (others => (others => 'X'));
  begin
    n316_data <= ram(to_integer (unsigned (addrb_r)));
    n317_data <= ram(to_integer (unsigned (addra_r)));
    if rising_edge (clkb) and (web = '1') then
      ram (to_integer (unsigned (addrb))) := dib;
    end if;
    if rising_edge (clka) and (wea = '1') then
      ram (to_integer (unsigned (addra))) := dia;
    end if;
  end process;
  -- entities/async_dpram.vhd:56:20
  -- entities/async_dpram.vhd:46:20
  -- entities/async_dpram.vhd:52:13
  -- entities/async_dpram.vhd:42:13
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_vector_4_b2aa97e8911ab0960636412a10bb582b30f69335 is
  port (
    clk : in std_logic;
    clken : in std_logic;
    d : in std_logic_vector (15 downto 0);
    q : out std_logic_vector (15 downto 0));
end entity delay_vector_4_b2aa97e8911ab0960636412a10bb582b30f69335;

architecture rtl of delay_vector_4_b2aa97e8911ab0960636412a10bb582b30f69335 is
  signal shreg : std_logic_vector (63 downto 0);
  signal n259_o : std_logic_vector (15 downto 0);
  signal n260_o : std_logic_vector (15 downto 0);
  signal n261_o : std_logic_vector (15 downto 0);
  signal n262_o : std_logic_vector (63 downto 0);
  signal n266_o : std_logic_vector (63 downto 0);
  signal n267_q : std_logic_vector (63 downto 0);
  signal n268_o : std_logic_vector (15 downto 0);
begin
  q <= n268_o;
  -- entities/delay_vector.vhd:21:10
  shreg <= n267_q; -- (signal)
  -- entities/delay_vector.vhd:30:30
  n259_o <= shreg (15 downto 0);
  -- entities/delay_vector.vhd:30:30
  n260_o <= shreg (31 downto 16);
  -- entities/delay_vector.vhd:30:30
  n261_o <= shreg (47 downto 32);
  -- entities/abs_square.vhd:84:3
  n262_o <= n261_o & n260_o & n259_o & d;
  -- entities/delay_vector.vhd:27:5
  n266_o <= shreg when clken = '0' else n262_o;
  -- entities/delay_vector.vhd:27:5
  process (clk)
  begin
    if rising_edge (clk) then
      n267_q <= n266_o;
    end if;
  end process;
  -- entities/delay_vector.vhd:37:13
  n268_o <= shreg (63 downto 48);
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity abs_square_c17fd92682ca5b304ac71074b558dda9e8eb4d66 is
  port (
    reset : in std_logic;
    clk : in std_logic;
    din_i : in std_logic_vector (7 downto 0);
    din_q : in std_logic_vector (7 downto 0);
    din_valid : in std_logic;
    din_mark : in std_logic;
    dout_i : out std_logic_vector (7 downto 0);
    dout_q : out std_logic_vector (7 downto 0);
    dout_valid : out std_logic;
    dout_pow_sq : out std_logic_vector (15 downto 0);
    dout_mark : out std_logic);
end entity abs_square_c17fd92682ca5b304ac71074b558dda9e8eb4d66;

architecture rtl of abs_square_c17fd92682ca5b304ac71074b558dda9e8eb4d66 is
  signal din_i_r : std_logic_vector (7 downto 0);
  signal din_q_r : std_logic_vector (7 downto 0);
  signal din_i_rr : std_logic_vector (7 downto 0);
  signal din_q_rr : std_logic_vector (7 downto 0);
  signal din_i_sq_rr : std_logic_vector (15 downto 0);
  signal din_i_rrr : std_logic_vector (7 downto 0);
  signal din_q_rrr : std_logic_vector (7 downto 0);
  signal din_i_sq_rrr : std_logic_vector (15 downto 0);
  signal din_q_sq_rrr : std_logic_vector (15 downto 0);
  -- attribute use_dsp of din_q_sq_rrr is "yes";
  signal n184_o : std_logic_vector (7 downto 0);
  signal n186_o : std_logic_vector (7 downto 0);
  signal n190_q : std_logic_vector (7 downto 0);
  signal n191_q : std_logic_vector (7 downto 0);
  signal n195_o : std_logic_vector (15 downto 0);
  signal n196_o : std_logic_vector (15 downto 0);
  signal n197_o : std_logic_vector (15 downto 0);
  signal n199_o : std_logic_vector (7 downto 0);
  signal n201_o : std_logic_vector (7 downto 0);
  signal n203_o : std_logic_vector (15 downto 0);
  signal n208_q : std_logic_vector (7 downto 0);
  signal n209_q : std_logic_vector (7 downto 0);
  signal n210_q : std_logic_vector (15 downto 0);
  signal n214_o : std_logic_vector (15 downto 0);
  signal n215_o : std_logic_vector (15 downto 0);
  signal n216_o : std_logic_vector (15 downto 0);
  signal n218_o : std_logic_vector (7 downto 0);
  signal n220_o : std_logic_vector (7 downto 0);
  signal n222_o : std_logic_vector (15 downto 0);
  signal n224_o : std_logic_vector (15 downto 0);
  signal n230_q : std_logic_vector (7 downto 0);
  signal n231_q : std_logic_vector (7 downto 0);
  signal n232_q : std_logic_vector (15 downto 0);
  signal n233_q : std_logic_vector (15 downto 0);
  signal n237_o : std_logic_vector (15 downto 0);
  signal n239_o : std_logic_vector (7 downto 0);
  signal n241_o : std_logic_vector (7 downto 0);
  signal n243_o : std_logic_vector (15 downto 0);
  signal n248_q : std_logic_vector (7 downto 0);
  signal n249_q : std_logic_vector (7 downto 0);
  signal n250_q : std_logic_vector (15 downto 0);
  signal dv_q : std_logic;
  constant n251_o : std_logic := '1';
  signal db_q : std_logic;
  constant n253_o : std_logic := '1';
begin
  dout_i <= n248_q;
  dout_q <= n249_q;
  dout_valid <= db_q;
  dout_pow_sq <= n250_q;
  dout_mark <= dv_q;
  -- entities/abs_square.vhd:29:10
  din_i_r <= n190_q; -- (signal)
  -- entities/abs_square.vhd:30:10
  din_q_r <= n191_q; -- (signal)
  -- entities/abs_square.vhd:32:10
  din_i_rr <= n208_q; -- (signal)
  -- entities/abs_square.vhd:33:10
  din_q_rr <= n209_q; -- (signal)
  -- entities/abs_square.vhd:34:10
  din_i_sq_rr <= n210_q; -- (signal)
  -- entities/abs_square.vhd:36:10
  din_i_rrr <= n230_q; -- (signal)
  -- entities/abs_square.vhd:37:10
  din_q_rrr <= n231_q; -- (signal)
  -- entities/abs_square.vhd:38:10
  din_i_sq_rrr <= n232_q; -- (signal)
  -- entities/abs_square.vhd:39:10
  din_q_sq_rrr <= n233_q; -- (signal)
  -- entities/abs_square.vhd:49:7
  n184_o <= din_i when reset = '0' else "00000000";
  -- entities/abs_square.vhd:49:7
  n186_o <= din_q when reset = '0' else "00000000";
  -- entities/abs_square.vhd:46:5
  process (clk)
  begin
    if rising_edge (clk) then
      n190_q <= n184_o;
    end if;
  end process;
  -- entities/abs_square.vhd:46:5
  process (clk)
  begin
    if rising_edge (clk) then
      n191_q <= n186_o;
    end if;
  end process;
  -- entities/abs_square.vhd:60:38
  n195_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:60:38
  n196_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:60:38
  n197_o <= std_logic_vector (resize (signed (n195_o) * signed (n196_o), 16));
  -- entities/abs_square.vhd:61:7
  n199_o <= din_i_r when reset = '0' else "00000000";
  -- entities/abs_square.vhd:61:7
  n201_o <= din_q_r when reset = '0' else "00000000";
  -- entities/abs_square.vhd:61:7
  n203_o <= n197_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n208_q <= n199_o;
    end if;
  end process;
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n209_q <= n201_o;
    end if;
  end process;
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n210_q <= n203_o;
    end if;
  end process;
  -- entities/abs_square.vhd:74:40
  n214_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:74:40
  n215_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:74:40
  n216_o <= std_logic_vector (resize (signed (n214_o) * signed (n215_o), 16));
  -- entities/abs_square.vhd:75:7
  n218_o <= din_i_rr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:75:7
  n220_o <= din_q_rr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:75:7
  n222_o <= din_i_sq_rr when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:75:7
  n224_o <= n216_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n230_q <= n218_o;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n231_q <= n220_o;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n232_q <= n222_o;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n233_q <= n224_o;
    end if;
  end process;
  -- entities/abs_square.vhd:88:52
  n237_o <= std_logic_vector (unsigned (din_i_sq_rrr) + unsigned (din_q_sq_rrr));
  -- entities/abs_square.vhd:89:7
  n239_o <= din_i_rrr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:89:7
  n241_o <= din_q_rrr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:89:7
  n243_o <= n237_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:85:5
  process (clk)
  begin
    if rising_edge (clk) then
      n248_q <= n239_o;
    end if;
  end process;
  -- entities/abs_square.vhd:85:5
  process (clk)
  begin
    if rising_edge (clk) then
      n249_q <= n241_o;
    end if;
  end process;
  -- entities/abs_square.vhd:85:5
  process (clk)
  begin
    if rising_edge (clk) then
      n250_q <= n243_o;
    end if;
  end process;
  -- entities/abs_square.vhd:97:3
  dv : entity work.delay_vector_4_c17fd92682ca5b304ac71074b558dda9e8eb4d66 port map (
    clk => clk,
    clken => n251_o,
    d => din_mark,
    q => dv_q);
  -- entities/abs_square.vhd:110:3
  db : entity work.delay_bit_4 port map (
    clk => clk,
    clken => n253_o,
    d => din_valid,
    q => db_q);
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of test_comp is
  signal wrap_reset: std_logic;
  signal wrap_clk: std_logic;
  subtype typwrap_din_i is std_logic_vector (7 downto 0);
  signal wrap_din_i: typwrap_din_i;
  subtype typwrap_din_q is std_logic_vector (7 downto 0);
  signal wrap_din_q: typwrap_din_q;
  signal wrap_din_valid: std_logic;
  signal wrap_din_pps: std_logic;
  signal wrap_reg_clk: std_logic;
  subtype typwrap_reg_addr is std_logic_vector (7 downto 0);
  signal wrap_reg_addr: typwrap_reg_addr;
  subtype typwrap_reg_wr_data is std_logic_vector (15 downto 0);
  signal wrap_reg_wr_data: typwrap_reg_wr_data;
  signal wrap_reg_wr_en: std_logic;
  signal wrap_reg_en: std_logic;
  subtype typwrap_dout_i is std_logic_vector (7 downto 0);
  signal wrap_dout_i: typwrap_dout_i;
  subtype typwrap_dout_q is std_logic_vector (7 downto 0);
  signal wrap_dout_q: typwrap_dout_q;
  signal wrap_dout_valid: std_logic;
  signal wrap_dout_pps: std_logic;
  subtype typwrap_dout_sq_power is std_logic_vector (15 downto 0);
  signal wrap_dout_sq_power: typwrap_dout_sq_power;
  signal wrap_dout_frame: std_logic;
  subtype typwrap_reg_rd_data is std_logic_vector (15 downto 0);
  signal wrap_reg_rd_data: typwrap_reg_rd_data;
  signal wrap_reg_rd_ack: std_logic;
  signal n0_o : std_logic_vector (17 downto 0);
  signal n2_o : std_logic_vector (7 downto 0);
  signal n3_o : std_logic_vector (7 downto 0);
  signal n4_o : std_logic;
  signal n5_o : std_logic;
  signal din_r : std_logic_vector (17 downto 0);
  signal abs_i : std_logic_vector (7 downto 0);
  signal abs_q : std_logic_vector (7 downto 0);
  signal abs_pow : std_logic_vector (15 downto 0);
  signal abs_valid : std_logic;
  signal abs_pps : std_logic;
  signal ram_wr_addr : std_logic_vector (8 downto 0);
  signal ram_wr_data : std_logic_vector (32 downto 0);
  signal ram_wr_en : std_logic;
  signal ram_rd_addr : std_logic_vector (8 downto 0);
  signal ram_rd_data : std_logic_vector (32 downto 0);
  signal ram_rd_valid : std_logic;
  signal ram_rd_valid_r : std_logic;
  signal ram_rd_valid_rr : std_logic;
  signal ram_out_i : std_logic_vector (7 downto 0);
  signal ram_out_q : std_logic_vector (7 downto 0);
  signal ram_out_pow : std_logic_vector (15 downto 0);
  signal ram_out_pps : std_logic;
  signal abs_pow_delayed : std_logic_vector (15 downto 0);
  signal ram_out_i_r : std_logic_vector (7 downto 0);
  signal ram_out_q_r : std_logic_vector (7 downto 0);
  signal ram_out_pow_r : std_logic_vector (15 downto 0);
  signal ram_out_valid_r : std_logic;
  signal ram_out_pps_r : std_logic;
  signal power_difference : std_logic_vector (16 downto 0);
  signal ram_out_i_rr : std_logic_vector (7 downto 0);
  signal ram_out_q_rr : std_logic_vector (7 downto 0);
  signal ram_out_pow_rr : std_logic_vector (15 downto 0);
  signal ram_out_valid_rr : std_logic;
  signal ram_out_pps_rr : std_logic;
  signal edge_detected : std_logic;
  signal threshold : std_logic_vector (15 downto 0);
  signal threshold_reg : std_logic_vector (15 downto 0);
  signal threshold_reg_r : std_logic_vector (15 downto 0);
  signal n15_q : std_logic_vector (17 downto 0);
  signal abs_sq_dout_i : std_logic_vector (7 downto 0);
  signal abs_sq_dout_q : std_logic_vector (7 downto 0);
  signal abs_sq_dout_valid : std_logic;
  signal abs_sq_dout_pow_sq : std_logic_vector (15 downto 0);
  signal abs_sq_dout_mark : std_logic;
  signal n16_o : std_logic_vector (7 downto 0);
  signal n17_o : std_logic_vector (7 downto 0);
  signal n18_o : std_logic;
  signal n19_o : std_logic;
  signal n25_o : std_logic;
  signal dv_q : std_logic_vector (15 downto 0);
  constant n26_o : std_logic := '1';
  signal n31_o : std_logic_vector (23 downto 0);
  signal n32_o : std_logic_vector (31 downto 0);
  signal n33_o : std_logic_vector (32 downto 0);
  signal n35_o : std_logic_vector (8 downto 0);
  signal n36_o : std_logic_vector (8 downto 0);
  signal n38_o : std_logic_vector (8 downto 0);
  signal n43_q : std_logic_vector (8 downto 0);
  signal n44_q : std_logic_vector (32 downto 0);
  signal n45_q : std_logic;
  signal ram_inst_doa : std_logic_vector (32 downto 0);
  signal ram_inst_dob : std_logic_vector (32 downto 0);
  constant n46_o : std_logic := '0';
  constant n47_o : std_logic_vector (32 downto 0) := "000000000000000000000000000000000";
  signal n53_o : std_logic_vector (8 downto 0);
  signal n59_q : std_logic_vector (8 downto 0);
  signal n60_q : std_logic;
  signal n61_q : std_logic;
  signal n62_q : std_logic;
  signal n63_o : std_logic_vector (15 downto 0);
  signal n64_o : std_logic_vector (7 downto 0);
  signal n65_o : std_logic_vector (7 downto 0);
  signal n66_o : std_logic;
  signal n71_o : std_logic_vector (16 downto 0);
  signal n73_o : std_logic_vector (16 downto 0);
  signal n74_o : std_logic_vector (16 downto 0);
  signal n82_q : std_logic_vector (7 downto 0);
  signal n83_q : std_logic_vector (7 downto 0);
  signal n84_q : std_logic_vector (15 downto 0);
  signal n85_q : std_logic;
  signal n86_q : std_logic;
  signal n87_q : std_logic_vector (16 downto 0);
  signal n92_o : std_logic_vector (16 downto 0);
  signal n93_o : std_logic;
  signal n96_o : std_logic;
  signal n105_q : std_logic_vector (7 downto 0);
  signal n106_q : std_logic_vector (7 downto 0);
  signal n107_q : std_logic_vector (15 downto 0);
  signal n108_q : std_logic;
  signal n109_q : std_logic;
  signal n110_q : std_logic;
  signal n114_o : std_logic_vector (17 downto 0);
  signal n119_q : std_logic_vector (17 downto 0);
  signal n120_q : std_logic_vector (15 downto 0);
  signal n121_q : std_logic;
  signal n128_q : std_logic_vector (15 downto 0);
  signal n129_q : std_logic_vector (15 downto 0);
  signal n133_o : std_logic;
  signal n135_o : std_logic;
  signal n137_o : std_logic;
  signal n140_o : std_logic;
  signal n141_o : std_logic;
  signal n143_o : std_logic_vector (1 downto 0);
  signal n146_o : std_logic_vector (15 downto 0);
  signal n149_o : std_logic;
  signal n151_o : std_logic;
  signal n152_o : std_logic_vector (15 downto 0);
  signal n154_o : std_logic_vector (15 downto 0);
  signal n156_o : std_logic;
  signal n157_o : std_logic;
  signal n160_o : std_logic;
  signal n169_q : std_logic := '1';
  signal n170_o : std_logic_vector (15 downto 0);
  signal n171_q : std_logic_vector (15 downto 0);
  signal n172_q : std_logic;
  signal n173_o : std_logic_vector (15 downto 0);
  signal n174_q : std_logic_vector (15 downto 0);
begin
  wrap_reset <= reset;
  wrap_clk <= clk;
  wrap_din_i <= din.i;
  wrap_din_q <= din.q;
  wrap_din_valid <= din.valid;
  wrap_din_pps <= din.pps;
  wrap_reg_clk <= reg_clk;
  wrap_reg_addr <= reg_addr;
  wrap_reg_wr_data <= reg_wr_data;
  wrap_reg_wr_en <= reg_wr_en;
  wrap_reg_en <= reg_en;
  dout.i <= wrap_dout_i;
  dout.q <= wrap_dout_q;
  dout.valid <= wrap_dout_valid;
  dout.pps <= wrap_dout_pps;
  dout_sq_power <= wrap_dout_sq_power;
  dout_frame <= wrap_dout_frame;
  reg_rd_data <= wrap_reg_rd_data;
  reg_rd_ack <= wrap_reg_rd_ack;
  wrap_dout_i <= n2_o;
  wrap_dout_q <= n3_o;
  wrap_dout_valid <= n4_o;
  wrap_dout_pps <= n5_o;
  wrap_dout_sq_power <= n120_q;
  wrap_dout_frame <= n121_q;
  wrap_reg_rd_data <= n171_q;
  wrap_reg_rd_ack <= n172_q;
  n0_o <= wrap_din_pps & wrap_din_valid & wrap_din_q & wrap_din_i;
  n2_o <= n119_q (7 downto 0);
  n3_o <= n119_q (15 downto 8);
  n4_o <= n119_q (16);
  n5_o <= n119_q (17);
  -- test_comp.vhd:33:10
  din_r <= n15_q; -- (signal)
  -- test_comp.vhd:35:10
  abs_i <= abs_sq_dout_i; -- (signal)
  -- test_comp.vhd:36:10
  abs_q <= abs_sq_dout_q; -- (signal)
  -- test_comp.vhd:37:10
  abs_pow <= abs_sq_dout_pow_sq; -- (signal)
  -- test_comp.vhd:38:10
  abs_valid <= abs_sq_dout_valid; -- (signal)
  -- test_comp.vhd:39:10
  abs_pps <= n25_o; -- (signal)
  -- test_comp.vhd:41:10
  ram_wr_addr <= n43_q; -- (signal)
  -- test_comp.vhd:42:10
  ram_wr_data <= n44_q; -- (signal)
  -- test_comp.vhd:43:10
  ram_wr_en <= n45_q; -- (signal)
  -- test_comp.vhd:45:10
  ram_rd_addr <= n59_q; -- (signal)
  -- test_comp.vhd:46:10
  ram_rd_data <= ram_inst_dob; -- (signal)
  -- test_comp.vhd:48:10
  ram_rd_valid <= n60_q; -- (signal)
  -- test_comp.vhd:49:10
  ram_rd_valid_r <= n61_q; -- (signal)
  -- test_comp.vhd:50:10
  ram_rd_valid_rr <= n62_q; -- (signal)
  -- test_comp.vhd:52:10
  ram_out_i <= n64_o; -- (signal)
  -- test_comp.vhd:53:10
  ram_out_q <= n65_o; -- (signal)
  -- test_comp.vhd:54:10
  ram_out_pow <= n63_o; -- (signal)
  -- test_comp.vhd:55:10
  ram_out_pps <= n66_o; -- (signal)
  -- test_comp.vhd:56:10
  abs_pow_delayed <= dv_q; -- (signal)
  -- test_comp.vhd:58:10
  ram_out_i_r <= n82_q; -- (signal)
  -- test_comp.vhd:59:10
  ram_out_q_r <= n83_q; -- (signal)
  -- test_comp.vhd:60:10
  ram_out_pow_r <= n84_q; -- (signal)
  -- test_comp.vhd:61:10
  ram_out_valid_r <= n85_q; -- (signal)
  -- test_comp.vhd:62:10
  ram_out_pps_r <= n86_q; -- (signal)
  -- test_comp.vhd:63:10
  power_difference <= n87_q; -- (signal)
  -- test_comp.vhd:65:10
  ram_out_i_rr <= n105_q; -- (signal)
  -- test_comp.vhd:66:10
  ram_out_q_rr <= n106_q; -- (signal)
  -- test_comp.vhd:67:10
  ram_out_pow_rr <= n107_q; -- (signal)
  -- test_comp.vhd:68:10
  ram_out_valid_rr <= n108_q; -- (signal)
  -- test_comp.vhd:69:10
  ram_out_pps_rr <= n109_q; -- (signal)
  -- test_comp.vhd:70:10
  edge_detected <= n110_q; -- (signal)
  -- test_comp.vhd:72:10
  threshold <= n128_q; -- (signal)
  -- test_comp.vhd:73:10
  threshold_reg <= n174_q; -- (signal)
  -- test_comp.vhd:74:10
  threshold_reg_r <= n129_q; -- (signal)
  -- test_comp.vhd:80:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n15_q <= n0_o;
    end if;
  end process;
  -- test_comp.vhd:85:3
  abs_sq : entity work.abs_square_c17fd92682ca5b304ac71074b558dda9e8eb4d66 port map (
    reset => wrap_reset,
    clk => wrap_clk,
    din_i => n16_o,
    din_q => n17_o,
    din_valid => n18_o,
    din_mark => n19_o,
    dout_i => abs_sq_dout_i,
    dout_q => abs_sq_dout_q,
    dout_valid => abs_sq_dout_valid,
    dout_pow_sq => abs_sq_dout_pow_sq,
    dout_mark => abs_sq_dout_mark);
  -- test_comp.vhd:91:27
  n16_o <= din_r (7 downto 0);
  -- test_comp.vhd:92:27
  n17_o <= din_r (15 downto 8);
  -- test_comp.vhd:93:27
  n18_o <= din_r (16);
  -- test_comp.vhd:94:27
  n19_o <= din_r (17);
  n25_o <= abs_sq_dout_mark;
  -- test_comp.vhd:103:3
  dv : entity work.delay_vector_4_b2aa97e8911ab0960636412a10bb582b30f69335 port map (
    clk => wrap_clk,
    clken => n26_o,
    d => abs_pow,
    q => dv_q);
  -- test_comp.vhd:118:30
  n31_o <= abs_pow & abs_i;
  -- test_comp.vhd:118:38
  n32_o <= n31_o & abs_q;
  -- test_comp.vhd:118:46
  n33_o <= n32_o & abs_pps;
  -- test_comp.vhd:121:63
  n35_o <= std_logic_vector (unsigned (ram_wr_addr) + unsigned'("000000001"));
  -- test_comp.vhd:120:7
  n36_o <= ram_wr_addr when abs_valid = '0' else n35_o;
  -- test_comp.vhd:124:7
  n38_o <= n36_o when wrap_reset = '0' else "000000000";
  -- test_comp.vhd:117:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n43_q <= n38_o;
    end if;
  end process;
  -- test_comp.vhd:117:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n44_q <= n33_o;
    end if;
  end process;
  -- test_comp.vhd:117:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n45_q <= abs_valid;
    end if;
  end process;
  -- test_comp.vhd:130:3
  ram_inst : entity work.async_dpram_9_33_bf8b4530d8d246dd74ac53a13471bba17941dff7 port map (
    clka => wrap_clk,
    clkb => wrap_clk,
    wea => ram_wr_en,
    web => n46_o,
    addra => ram_wr_addr,
    addrb => ram_rd_addr,
    dia => ram_wr_data,
    dib => n47_o,
    doa => open,
    dob => ram_inst_dob);
  -- test_comp.vhd:155:65
  n53_o <= std_logic_vector (unsigned (ram_wr_addr) - unsigned'("110010000"));
  -- test_comp.vhd:154:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n59_q <= n53_o;
    end if;
  end process;
  -- test_comp.vhd:154:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n60_q <= abs_valid;
    end if;
  end process;
  -- test_comp.vhd:154:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n61_q <= ram_rd_valid;
    end if;
  end process;
  -- test_comp.vhd:154:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n62_q <= ram_rd_valid_r;
    end if;
  end process;
  -- test_comp.vhd:163:29
  n63_o <= ram_rd_data (32 downto 17);
  -- test_comp.vhd:164:29
  n64_o <= ram_rd_data (16 downto 9);
  -- test_comp.vhd:165:29
  n65_o <= ram_rd_data (8 downto 1);
  -- test_comp.vhd:166:29
  n66_o <= ram_rd_data (0);
  -- test_comp.vhd:175:38
  n71_o <= '0' & abs_pow_delayed;
  -- test_comp.vhd:175:70
  n73_o <= '0' & ram_out_pow;
  -- test_comp.vhd:175:57
  n74_o <= std_logic_vector (unsigned (n71_o) - unsigned (n73_o));
  -- test_comp.vhd:169:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n82_q <= ram_out_i;
    end if;
  end process;
  -- test_comp.vhd:169:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n83_q <= ram_out_q;
    end if;
  end process;
  -- test_comp.vhd:169:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n84_q <= ram_out_pow;
    end if;
  end process;
  -- test_comp.vhd:169:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n85_q <= ram_rd_valid_rr;
    end if;
  end process;
  -- test_comp.vhd:169:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n86_q <= ram_out_pps;
    end if;
  end process;
  -- test_comp.vhd:169:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n87_q <= n74_o;
    end if;
  end process;
  -- test_comp.vhd:188:40
  n92_o <= '0' & threshold;
  -- test_comp.vhd:188:27
  n93_o <= '1' when signed (power_difference) > signed (n92_o) else '0';
  -- test_comp.vhd:188:7
  n96_o <= '0' when n93_o = '0' else '1';
  -- test_comp.vhd:181:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n105_q <= ram_out_i_r;
    end if;
  end process;
  -- test_comp.vhd:181:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n106_q <= ram_out_q_r;
    end if;
  end process;
  -- test_comp.vhd:181:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n107_q <= ram_out_pow_r;
    end if;
  end process;
  -- test_comp.vhd:181:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n108_q <= ram_out_valid_r;
    end if;
  end process;
  -- test_comp.vhd:181:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n109_q <= ram_out_pps_r;
    end if;
  end process;
  -- test_comp.vhd:181:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n110_q <= n96_o;
    end if;
  end process;
  n114_o <= ram_out_pps_rr & ram_out_valid_rr & ram_out_q_rr & ram_out_i_rr;
  -- test_comp.vhd:195:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n119_q <= n114_o;
    end if;
  end process;
  -- test_comp.vhd:195:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n120_q <= ram_out_pow_rr;
    end if;
  end process;
  -- test_comp.vhd:195:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n121_q <= edge_detected;
    end if;
  end process;
  -- test_comp.vhd:206:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n128_q <= threshold_reg_r;
    end if;
  end process;
  -- test_comp.vhd:206:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n129_q <= threshold_reg;
    end if;
  end process;
  -- test_comp.vhd:216:22
  n133_o <= not wrap_reg_wr_en;
  -- test_comp.vhd:218:13
  n135_o <= '1' when wrap_reg_addr = "00000000" else '0';
  -- test_comp.vhd:220:13
  n137_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- test_comp.vhd:223:15
  n140_o <= not n160_o;
  -- test_comp.vhd:223:15
  n141_o <= n140_o or '0';
  -- test_comp.vhd:223:15
  n142: postponed assert n169_q = '1' severity error; --  assert
  n143_o <= n137_o & n135_o;
  -- test_comp.vhd:217:11
  with n143_o select n146_o <=
    threshold_reg when "10",
    "0000101100001011" when "01",
    "XXXXXXXXXXXXXXXX" when others;
  -- test_comp.vhd:217:11
  with n143_o select n149_o <=
    '0' when "10",
    '0' when "01",
    '1' when others;
  -- test_comp.vhd:228:13
  n151_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- test_comp.vhd:227:11
  with n151_o select n152_o <=
    wrap_reg_wr_data when '1',
    threshold_reg when others;
  -- test_comp.vhd:216:9
  n154_o <= n152_o when n133_o = '0' else threshold_reg;
  -- test_comp.vhd:216:9
  n156_o <= '0' when n133_o = '0' else n149_o;
  -- test_comp.vhd:215:7
  n157_o <= wrap_reg_en and n133_o;
  -- test_comp.vhd:215:7
  n160_o <= '0' when wrap_reg_en = '0' else n156_o;
  -- test_comp.vhd:212:3
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n169_q <= n141_o;
    end if;
  end process;
  -- test_comp.vhd:213:5
  n170_o <= n171_q when n157_o = '0' else n146_o;
  -- test_comp.vhd:213:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n171_q <= n170_o;
    end if;
  end process;
  -- test_comp.vhd:213:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n172_q <= wrap_reg_en;
    end if;
  end process;
  -- test_comp.vhd:213:5
  n173_o <= threshold_reg when wrap_reg_en = '0' else n154_o;
  -- test_comp.vhd:213:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n174_q <= n173_o;
    end if;
  end process;
end rtl;
