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
  signal n336_o : std_logic;
  signal n337_o : std_logic;
  signal n338_o : std_logic;
  signal n339_o : std_logic_vector (3 downto 0);
  signal n343_o : std_logic_vector (3 downto 0);
  signal n344_q : std_logic_vector (3 downto 0);
  signal n345_o : std_logic;
begin
  q <= n345_o;
  -- entities/delay_bit.vhd:20:10
  shreg <= n344_q; -- (signal)
  -- entities/delay_bit.vhd:30:30
  n336_o <= shreg (0);
  -- entities/delay_bit.vhd:30:30
  n337_o <= shreg (1);
  -- entities/delay_bit.vhd:30:30
  n338_o <= shreg (2);
  -- entities/async_dpram.vhd:56:5
  n339_o <= n338_o & n337_o & n336_o & d;
  -- entities/delay_bit.vhd:26:5
  n343_o <= shreg when clken = '0' else n339_o;
  -- entities/delay_bit.vhd:26:5
  process (clk)
  begin
    if rising_edge (clk) then
      n344_q <= n343_o;
    end if;
  end process;
  -- entities/delay_bit.vhd:37:13
  n345_o <= shreg (3);
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
  signal n322_o : std_logic;
  signal n323_o : std_logic;
  signal n324_o : std_logic;
  signal n325_o : std_logic_vector (3 downto 0);
  signal n329_o : std_logic_vector (3 downto 0);
  signal n330_q : std_logic_vector (3 downto 0);
  signal n331_o : std_logic;
begin
  q <= n331_o;
  -- entities/delay_vector.vhd:21:10
  shreg <= n330_q; -- (signal)
  -- entities/delay_vector.vhd:30:30
  n322_o <= shreg (0);
  -- entities/delay_vector.vhd:30:30
  n323_o <= shreg (1);
  -- entities/delay_vector.vhd:30:30
  n324_o <= shreg (2);
  -- entities/async_dpram.vhd:45:5
  n325_o <= n324_o & n323_o & n322_o & d;
  -- entities/delay_vector.vhd:27:5
  n329_o <= shreg when clken = '0' else n325_o;
  -- entities/delay_vector.vhd:27:5
  process (clk)
  begin
    if rising_edge (clk) then
      n330_q <= n329_o;
    end if;
  end process;
  -- entities/delay_vector.vhd:37:13
  n331_o <= shreg (3);
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_dpram_9_33_bf8b4530d8d246dd74ac53a13471bba17941dff7 is
  port (
    clka : in std_logic;
    clkb : in std_logic;
    ena : in std_logic;
    enb : in std_logic;
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
  signal n277_o : std_logic;
  signal n296_o : std_logic;
  signal n305_q : std_logic_vector (32 downto 0);
  signal n311_q : std_logic_vector (32 downto 0);
  signal n314_data : std_logic_vector (32 downto 0);
  signal n315_data : std_logic_vector (32 downto 0);
begin
  doa <= n305_q;
  dob <= n311_q;
  -- entities/async_dpram.vhd:40:10
  ram_out_a <= n315_data; -- (signal)
  -- entities/async_dpram.vhd:41:10
  ram_out_b <= n314_data; -- (signal)
  -- entities/async_dpram.vhd:12:8
  n277_o <= wea and ena;
  -- entities/async_dpram.vhd:12:8
  n296_o <= web and enb;
  -- entities/async_dpram.vhd:68:7
  process (clka)
  begin
    if rising_edge (clka) then
      n305_q <= ram_out_a;
    end if;
  end process;
  -- entities/async_dpram.vhd:74:7
  process (clkb)
  begin
    if rising_edge (clkb) then
      n311_q <= ram_out_b;
    end if;
  end process;
  -- entities/async_dpram.vhd:31:5
  process (clkb, clka, clkb, clka) is
    type ram_type is array (0 to 511)
      of std_logic_vector (32 downto 0);
    variable ram : ram_type := (others => (others => 'X'));
  begin
    if rising_edge (clkb) and (enb = '1') then
      n314_data <= ram(to_integer (unsigned (addrb)));
    end if;
    if rising_edge (clka) and (ena = '1') then
      n315_data <= ram(to_integer (unsigned (addra)));
    end if;
    if rising_edge (clkb) and (n296_o = '1') then
      ram (to_integer (unsigned (addrb))) := dib;
    end if;
    if rising_edge (clka) and (n277_o = '1') then
      ram (to_integer (unsigned (addra))) := dia;
    end if;
  end process;
  -- entities/async_dpram.vhd:56:5
  -- entities/async_dpram.vhd:45:5
  -- entities/async_dpram.vhd:60:15
  -- entities/async_dpram.vhd:49:15
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
  signal n249_o : std_logic_vector (15 downto 0);
  signal n250_o : std_logic_vector (15 downto 0);
  signal n251_o : std_logic_vector (15 downto 0);
  signal n252_o : std_logic_vector (63 downto 0);
  signal n256_o : std_logic_vector (63 downto 0);
  signal n257_q : std_logic_vector (63 downto 0);
  signal n258_o : std_logic_vector (15 downto 0);
begin
  q <= n258_o;
  -- entities/delay_vector.vhd:21:10
  shreg <= n257_q; -- (signal)
  -- entities/delay_vector.vhd:30:30
  n249_o <= shreg (15 downto 0);
  -- entities/delay_vector.vhd:30:30
  n250_o <= shreg (31 downto 16);
  -- entities/delay_vector.vhd:30:30
  n251_o <= shreg (47 downto 32);
  -- entities/abs_square.vhd:85:3
  n252_o <= n251_o & n250_o & n249_o & d;
  -- entities/delay_vector.vhd:27:5
  n256_o <= shreg when clken = '0' else n252_o;
  -- entities/delay_vector.vhd:27:5
  process (clk)
  begin
    if rising_edge (clk) then
      n257_q <= n256_o;
    end if;
  end process;
  -- entities/delay_vector.vhd:37:13
  n258_o <= shreg (63 downto 48);
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
  signal n174_o : std_logic_vector (7 downto 0);
  signal n176_o : std_logic_vector (7 downto 0);
  signal n180_q : std_logic_vector (7 downto 0);
  signal n181_q : std_logic_vector (7 downto 0);
  signal n185_o : std_logic_vector (15 downto 0);
  signal n186_o : std_logic_vector (15 downto 0);
  signal n187_o : std_logic_vector (15 downto 0);
  signal n189_o : std_logic_vector (7 downto 0);
  signal n191_o : std_logic_vector (7 downto 0);
  signal n193_o : std_logic_vector (15 downto 0);
  signal n198_q : std_logic_vector (7 downto 0);
  signal n199_q : std_logic_vector (7 downto 0);
  signal n200_q : std_logic_vector (15 downto 0);
  signal n204_o : std_logic_vector (15 downto 0);
  signal n205_o : std_logic_vector (15 downto 0);
  signal n206_o : std_logic_vector (15 downto 0);
  signal n220_q : std_logic_vector (7 downto 0);
  signal n221_q : std_logic_vector (7 downto 0);
  signal n222_q : std_logic_vector (15 downto 0);
  signal n223_q : std_logic_vector (15 downto 0);
  signal n227_o : std_logic_vector (15 downto 0);
  signal n229_o : std_logic_vector (7 downto 0);
  signal n231_o : std_logic_vector (7 downto 0);
  signal n233_o : std_logic_vector (15 downto 0);
  signal n238_q : std_logic_vector (7 downto 0);
  signal n239_q : std_logic_vector (7 downto 0);
  signal n240_q : std_logic_vector (15 downto 0);
  signal dv_q : std_logic;
  constant n241_o : std_logic := '1';
  signal db_q : std_logic;
  constant n243_o : std_logic := '1';
begin
  dout_i <= n238_q;
  dout_q <= n239_q;
  dout_valid <= db_q;
  dout_pow_sq <= n240_q;
  dout_mark <= dv_q;
  -- entities/abs_square.vhd:29:10
  din_i_r <= n180_q; -- (signal)
  -- entities/abs_square.vhd:30:10
  din_q_r <= n181_q; -- (signal)
  -- entities/abs_square.vhd:32:10
  din_i_rr <= n198_q; -- (signal)
  -- entities/abs_square.vhd:33:10
  din_q_rr <= n199_q; -- (signal)
  -- entities/abs_square.vhd:34:10
  din_i_sq_rr <= n200_q; -- (signal)
  -- entities/abs_square.vhd:36:10
  din_i_rrr <= n220_q; -- (signal)
  -- entities/abs_square.vhd:37:10
  din_q_rrr <= n221_q; -- (signal)
  -- entities/abs_square.vhd:38:10
  din_i_sq_rrr <= n222_q; -- (signal)
  -- entities/abs_square.vhd:39:10
  din_q_sq_rrr <= n223_q; -- (signal)
  -- entities/abs_square.vhd:49:7
  n174_o <= din_i when reset = '0' else "00000000";
  -- entities/abs_square.vhd:49:7
  n176_o <= din_q when reset = '0' else "00000000";
  -- entities/abs_square.vhd:46:5
  process (clk)
  begin
    if rising_edge (clk) then
      n180_q <= n174_o;
    end if;
  end process;
  -- entities/abs_square.vhd:46:5
  process (clk)
  begin
    if rising_edge (clk) then
      n181_q <= n176_o;
    end if;
  end process;
  -- entities/abs_square.vhd:60:38
  n185_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:60:38
  n186_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:60:38
  n187_o <= std_logic_vector (resize (signed (n185_o) * signed (n186_o), 16));
  -- entities/abs_square.vhd:61:7
  n189_o <= din_i_r when reset = '0' else "00000000";
  -- entities/abs_square.vhd:61:7
  n191_o <= din_q_r when reset = '0' else "00000000";
  -- entities/abs_square.vhd:61:7
  n193_o <= n187_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n198_q <= n189_o;
    end if;
  end process;
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n199_q <= n191_o;
    end if;
  end process;
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n200_q <= n193_o;
    end if;
  end process;
  -- entities/abs_square.vhd:74:40
  n204_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:74:40
  n205_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:74:40
  n206_o <= std_logic_vector (resize (signed (n204_o) * signed (n205_o), 16));
  -- entities/abs_square.vhd:70:5
  process (clk, reset)
  begin
    if reset = '1' then
      n220_q <= "00000000";
    elsif rising_edge (clk) then
      n220_q <= din_i_rr;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk, reset)
  begin
    if reset = '1' then
      n221_q <= "00000000";
    elsif rising_edge (clk) then
      n221_q <= din_q_rr;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk, reset)
  begin
    if reset = '1' then
      n222_q <= "0000000000000000";
    elsif rising_edge (clk) then
      n222_q <= din_i_sq_rr;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk, reset)
  begin
    if reset = '1' then
      n223_q <= "0000000000000000";
    elsif rising_edge (clk) then
      n223_q <= n206_o;
    end if;
  end process;
  -- entities/abs_square.vhd:89:52
  n227_o <= std_logic_vector (unsigned (din_i_sq_rrr) + unsigned (din_q_sq_rrr));
  -- entities/abs_square.vhd:90:7
  n229_o <= din_i_rrr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:90:7
  n231_o <= din_q_rrr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:90:7
  n233_o <= n227_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:86:5
  process (clk)
  begin
    if rising_edge (clk) then
      n238_q <= n229_o;
    end if;
  end process;
  -- entities/abs_square.vhd:86:5
  process (clk)
  begin
    if rising_edge (clk) then
      n239_q <= n231_o;
    end if;
  end process;
  -- entities/abs_square.vhd:86:5
  process (clk)
  begin
    if rising_edge (clk) then
      n240_q <= n233_o;
    end if;
  end process;
  -- entities/abs_square.vhd:98:3
  dv : entity work.delay_vector_4_c17fd92682ca5b304ac71074b558dda9e8eb4d66 port map (
    clk => clk,
    clken => n241_o,
    d => din_mark,
    q => dv_q);
  -- entities/abs_square.vhd:111:3
  db : entity work.delay_bit_4 port map (
    clk => clk,
    clken => n243_o,
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
  constant n46_o : std_logic := '1';
  constant n47_o : std_logic := '1';
  constant n48_o : std_logic := '0';
  constant n49_o : std_logic_vector (32 downto 0) := "000000000000000000000000000000000";
  signal n55_o : std_logic_vector (8 downto 0);
  signal n60_q : std_logic_vector (8 downto 0);
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
  signal n117_q : std_logic_vector (15 downto 0);
  signal n118_q : std_logic_vector (15 downto 0);
  signal n122_o : std_logic;
  signal n124_o : std_logic;
  signal n126_o : std_logic;
  signal n129_o : std_logic;
  signal n130_o : std_logic;
  signal n132_o : std_logic_vector (1 downto 0);
  signal n135_o : std_logic_vector (15 downto 0);
  signal n138_o : std_logic;
  signal n140_o : std_logic;
  signal n141_o : std_logic_vector (15 downto 0);
  signal n143_o : std_logic_vector (15 downto 0);
  signal n145_o : std_logic;
  signal n146_o : std_logic;
  signal n149_o : std_logic;
  signal n158_q : std_logic := '1';
  signal n159_o : std_logic_vector (15 downto 0);
  signal n160_q : std_logic_vector (15 downto 0);
  signal n161_q : std_logic;
  signal n162_o : std_logic_vector (15 downto 0);
  signal n163_q : std_logic_vector (15 downto 0);
  signal n164_o : std_logic_vector (17 downto 0);
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
  wrap_dout_sq_power <= ram_out_pow_rr;
  wrap_dout_frame <= edge_detected;
  wrap_reg_rd_data <= n160_q;
  wrap_reg_rd_ack <= n161_q;
  n0_o <= wrap_din_pps & wrap_din_valid & wrap_din_q & wrap_din_i;
  n2_o <= n164_o (7 downto 0);
  n3_o <= n164_o (15 downto 8);
  n4_o <= n164_o (16);
  n5_o <= n164_o (17);
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
  ram_rd_addr <= n60_q; -- (signal)
  -- test_comp.vhd:46:10
  ram_rd_data <= ram_inst_dob; -- (signal)
  -- test_comp.vhd:48:10
  ram_rd_valid <= n61_q; -- (signal)
  -- test_comp.vhd:49:10
  ram_rd_valid_r <= n62_q; -- (signal)
  -- test_comp.vhd:51:10
  ram_out_i <= n64_o; -- (signal)
  -- test_comp.vhd:52:10
  ram_out_q <= n65_o; -- (signal)
  -- test_comp.vhd:53:10
  ram_out_pow <= n63_o; -- (signal)
  -- test_comp.vhd:54:10
  ram_out_pps <= n66_o; -- (signal)
  -- test_comp.vhd:55:10
  abs_pow_delayed <= dv_q; -- (signal)
  -- test_comp.vhd:57:10
  ram_out_i_r <= n82_q; -- (signal)
  -- test_comp.vhd:58:10
  ram_out_q_r <= n83_q; -- (signal)
  -- test_comp.vhd:59:10
  ram_out_pow_r <= n84_q; -- (signal)
  -- test_comp.vhd:60:10
  ram_out_valid_r <= n85_q; -- (signal)
  -- test_comp.vhd:61:10
  ram_out_pps_r <= n86_q; -- (signal)
  -- test_comp.vhd:62:10
  power_difference <= n87_q; -- (signal)
  -- test_comp.vhd:64:10
  ram_out_i_rr <= n105_q; -- (signal)
  -- test_comp.vhd:65:10
  ram_out_q_rr <= n106_q; -- (signal)
  -- test_comp.vhd:66:10
  ram_out_pow_rr <= n107_q; -- (signal)
  -- test_comp.vhd:67:10
  ram_out_valid_rr <= n108_q; -- (signal)
  -- test_comp.vhd:68:10
  ram_out_pps_rr <= n109_q; -- (signal)
  -- test_comp.vhd:69:10
  edge_detected <= n110_q; -- (signal)
  -- test_comp.vhd:71:10
  threshold <= n117_q; -- (signal)
  -- test_comp.vhd:72:10
  threshold_reg <= n163_q; -- (signal)
  -- test_comp.vhd:73:10
  threshold_reg_r <= n118_q; -- (signal)
  -- test_comp.vhd:79:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n15_q <= n0_o;
    end if;
  end process;
  -- test_comp.vhd:84:3
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
  -- test_comp.vhd:90:27
  n16_o <= din_r (7 downto 0);
  -- test_comp.vhd:91:27
  n17_o <= din_r (15 downto 8);
  -- test_comp.vhd:92:27
  n18_o <= din_r (16);
  -- test_comp.vhd:93:27
  n19_o <= din_r (17);
  n25_o <= abs_sq_dout_mark;
  -- test_comp.vhd:102:3
  dv : entity work.delay_vector_4_b2aa97e8911ab0960636412a10bb582b30f69335 port map (
    clk => wrap_clk,
    clken => n26_o,
    d => abs_pow,
    q => dv_q);
  -- test_comp.vhd:117:30
  n31_o <= abs_pow & abs_i;
  -- test_comp.vhd:117:38
  n32_o <= n31_o & abs_q;
  -- test_comp.vhd:117:46
  n33_o <= n32_o & abs_pps;
  -- test_comp.vhd:120:63
  n35_o <= std_logic_vector (unsigned (ram_wr_addr) + unsigned'("000000001"));
  -- test_comp.vhd:119:7
  n36_o <= ram_wr_addr when abs_valid = '0' else n35_o;
  -- test_comp.vhd:123:7
  n38_o <= n36_o when wrap_reset = '0' else "000000000";
  -- test_comp.vhd:116:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n43_q <= n38_o;
    end if;
  end process;
  -- test_comp.vhd:116:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n44_q <= n33_o;
    end if;
  end process;
  -- test_comp.vhd:116:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n45_q <= abs_valid;
    end if;
  end process;
  -- test_comp.vhd:129:3
  ram_inst : entity work.async_dpram_9_33_bf8b4530d8d246dd74ac53a13471bba17941dff7 port map (
    clka => wrap_clk,
    clkb => wrap_clk,
    ena => n46_o,
    enb => n47_o,
    wea => ram_wr_en,
    web => n48_o,
    addra => ram_wr_addr,
    addrb => ram_rd_addr,
    dia => ram_wr_data,
    dib => n49_o,
    doa => open,
    dob => ram_inst_dob);
  -- test_comp.vhd:154:65
  n55_o <= std_logic_vector (unsigned (ram_wr_addr) - unsigned'("110010000"));
  -- test_comp.vhd:153:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n60_q <= n55_o;
    end if;
  end process;
  -- test_comp.vhd:153:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n61_q <= abs_valid;
    end if;
  end process;
  -- test_comp.vhd:153:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n62_q <= ram_rd_valid;
    end if;
  end process;
  -- test_comp.vhd:161:29
  n63_o <= ram_rd_data (32 downto 17);
  -- test_comp.vhd:162:29
  n64_o <= ram_rd_data (16 downto 9);
  -- test_comp.vhd:163:29
  n65_o <= ram_rd_data (8 downto 1);
  -- test_comp.vhd:164:29
  n66_o <= ram_rd_data (0);
  -- test_comp.vhd:173:38
  n71_o <= '0' & abs_pow_delayed;
  -- test_comp.vhd:173:70
  n73_o <= '0' & ram_out_pow;
  -- test_comp.vhd:173:57
  n74_o <= std_logic_vector (unsigned (n71_o) - unsigned (n73_o));
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n82_q <= ram_out_i;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n83_q <= ram_out_q;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n84_q <= ram_out_pow;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n85_q <= ram_rd_valid_r;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n86_q <= ram_out_pps;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n87_q <= n74_o;
    end if;
  end process;
  -- test_comp.vhd:186:40
  n92_o <= '0' & threshold;
  -- test_comp.vhd:186:27
  n93_o <= '1' when signed (power_difference) > signed (n92_o) else '0';
  -- test_comp.vhd:186:7
  n96_o <= '0' when n93_o = '0' else '1';
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n105_q <= ram_out_i_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n106_q <= ram_out_q_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n107_q <= ram_out_pow_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n108_q <= ram_out_valid_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n109_q <= ram_out_pps_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n110_q <= n96_o;
    end if;
  end process;
  -- test_comp.vhd:200:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n117_q <= threshold_reg_r;
    end if;
  end process;
  -- test_comp.vhd:200:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n118_q <= threshold_reg;
    end if;
  end process;
  -- test_comp.vhd:210:22
  n122_o <= not wrap_reg_wr_en;
  -- test_comp.vhd:212:13
  n124_o <= '1' when wrap_reg_addr = "00000000" else '0';
  -- test_comp.vhd:214:13
  n126_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- test_comp.vhd:217:15
  n129_o <= not n149_o;
  -- test_comp.vhd:217:15
  n130_o <= n129_o or '0';
  -- test_comp.vhd:217:15
  n131: postponed assert n158_q = '1' severity error; --  assert
  n132_o <= n126_o & n124_o;
  -- test_comp.vhd:211:11
  with n132_o select n135_o <=
    threshold_reg when "10",
    "0000101100001011" when "01",
    "XXXXXXXXXXXXXXXX" when others;
  -- test_comp.vhd:211:11
  with n132_o select n138_o <=
    '0' when "10",
    '0' when "01",
    '1' when others;
  -- test_comp.vhd:222:13
  n140_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- test_comp.vhd:221:11
  with n140_o select n141_o <=
    wrap_reg_wr_data when '1',
    threshold_reg when others;
  -- test_comp.vhd:210:9
  n143_o <= n141_o when n122_o = '0' else threshold_reg;
  -- test_comp.vhd:210:9
  n145_o <= '0' when n122_o = '0' else n138_o;
  -- test_comp.vhd:209:7
  n146_o <= wrap_reg_en and n122_o;
  -- test_comp.vhd:209:7
  n149_o <= '0' when wrap_reg_en = '0' else n145_o;
  -- test_comp.vhd:206:3
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n158_q <= n130_o;
    end if;
  end process;
  -- test_comp.vhd:207:5
  n159_o <= n160_q when n146_o = '0' else n135_o;
  -- test_comp.vhd:207:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n160_q <= n159_o;
    end if;
  end process;
  -- test_comp.vhd:207:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n161_q <= wrap_reg_en;
    end if;
  end process;
  -- test_comp.vhd:207:5
  n162_o <= threshold_reg when wrap_reg_en = '0' else n143_o;
  -- test_comp.vhd:207:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n163_q <= n162_o;
    end if;
  end process;
  -- test_comp.vhd:207:5
  n164_o <= ram_out_pps_rr & ram_out_valid_rr & ram_out_q_rr & ram_out_i_rr;
end rtl;
