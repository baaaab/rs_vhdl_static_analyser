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
  signal n295_o : std_logic;
  signal n296_o : std_logic;
  signal n297_o : std_logic;
  signal n298_o : std_logic_vector (3 downto 0);
  signal n302_o : std_logic_vector (3 downto 0);
  signal n303_q : std_logic_vector (3 downto 0);
  signal n304_o : std_logic;
begin
  q <= n304_o;
  -- entities/delay_bit.vhd:20:10
  shreg <= n303_q; -- (signal)
  -- entities/delay_bit.vhd:28:30
  n295_o <= shreg (0);
  -- entities/delay_bit.vhd:28:30
  n296_o <= shreg (1);
  -- entities/delay_bit.vhd:28:30
  n297_o <= shreg (2);
  -- entities/async_dpram.vhd:56:5
  n298_o <= n297_o & n296_o & n295_o & d;
  -- entities/delay_bit.vhd:24:5
  n302_o <= shreg when clken = '0' else n298_o;
  -- entities/delay_bit.vhd:24:5
  process (clk)
  begin
    if rising_edge (clk) then
      n303_q <= n302_o;
    end if;
  end process;
  -- entities/delay_bit.vhd:35:13
  n304_o <= shreg (3);
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
  signal n281_o : std_logic;
  signal n282_o : std_logic;
  signal n283_o : std_logic;
  signal n284_o : std_logic_vector (3 downto 0);
  signal n288_o : std_logic_vector (3 downto 0);
  signal n289_q : std_logic_vector (3 downto 0);
  signal n290_o : std_logic;
begin
  q <= n290_o;
  -- entities/delay_vector.vhd:21:10
  shreg <= n289_q; -- (signal)
  -- entities/delay_vector.vhd:28:30
  n281_o <= shreg (0);
  -- entities/delay_vector.vhd:28:30
  n282_o <= shreg (1);
  -- entities/delay_vector.vhd:28:30
  n283_o <= shreg (2);
  -- entities/async_dpram.vhd:45:5
  n284_o <= n283_o & n282_o & n281_o & d;
  -- entities/delay_vector.vhd:25:5
  n288_o <= shreg when clken = '0' else n284_o;
  -- entities/delay_vector.vhd:25:5
  process (clk)
  begin
    if rising_edge (clk) then
      n289_q <= n288_o;
    end if;
  end process;
  -- entities/delay_vector.vhd:35:13
  n290_o <= shreg (3);
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
  signal n236_o : std_logic;
  signal n255_o : std_logic;
  signal n264_q : std_logic_vector (32 downto 0);
  signal n270_q : std_logic_vector (32 downto 0);
  signal n273_data : std_logic_vector (32 downto 0);
  signal n274_data : std_logic_vector (32 downto 0);
begin
  doa <= n264_q;
  dob <= n270_q;
  -- entities/async_dpram.vhd:40:10
  ram_out_a <= n274_data; -- (signal)
  -- entities/async_dpram.vhd:41:10
  ram_out_b <= n273_data; -- (signal)
  -- entities/async_dpram.vhd:12:8
  n236_o <= wea and ena;
  -- entities/async_dpram.vhd:12:8
  n255_o <= web and enb;
  -- entities/async_dpram.vhd:68:7
  process (clka)
  begin
    if rising_edge (clka) then
      n264_q <= ram_out_a;
    end if;
  end process;
  -- entities/async_dpram.vhd:74:7
  process (clkb)
  begin
    if rising_edge (clkb) then
      n270_q <= ram_out_b;
    end if;
  end process;
  -- entities/async_dpram.vhd:31:5
  process (clkb, clka, clkb, clka) is
    type ram_type is array (0 to 511)
      of std_logic_vector (32 downto 0);
    variable ram : ram_type := (others => (others => 'X'));
  begin
    if rising_edge (clkb) and (enb = '1') then
      n273_data <= ram(to_integer (unsigned (addrb)));
    end if;
    if rising_edge (clka) and (ena = '1') then
      n274_data <= ram(to_integer (unsigned (addra)));
    end if;
    if rising_edge (clkb) and (n255_o = '1') then
      ram (to_integer (unsigned (addrb))) := dib;
    end if;
    if rising_edge (clka) and (n236_o = '1') then
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
  signal n208_o : std_logic_vector (15 downto 0);
  signal n209_o : std_logic_vector (15 downto 0);
  signal n210_o : std_logic_vector (15 downto 0);
  signal n211_o : std_logic_vector (63 downto 0);
  signal n215_o : std_logic_vector (63 downto 0);
  signal n216_q : std_logic_vector (63 downto 0);
  signal n217_o : std_logic_vector (15 downto 0);
begin
  q <= n217_o;
  -- entities/delay_vector.vhd:21:10
  shreg <= n216_q; -- (signal)
  -- entities/delay_vector.vhd:28:30
  n208_o <= shreg (15 downto 0);
  -- entities/delay_vector.vhd:28:30
  n209_o <= shreg (31 downto 16);
  -- entities/delay_vector.vhd:28:30
  n210_o <= shreg (47 downto 32);
  -- entities/abs_square.vhd:66:3
  n211_o <= n210_o & n209_o & n208_o & d;
  -- entities/delay_vector.vhd:25:5
  n215_o <= shreg when clken = '0' else n211_o;
  -- entities/delay_vector.vhd:25:5
  process (clk)
  begin
    if rising_edge (clk) then
      n216_q <= n215_o;
    end if;
  end process;
  -- entities/delay_vector.vhd:35:13
  n217_o <= shreg (63 downto 48);
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
  signal n159_q : std_logic_vector (7 downto 0);
  signal n160_q : std_logic_vector (7 downto 0);
  signal n164_o : std_logic_vector (15 downto 0);
  signal n165_o : std_logic_vector (15 downto 0);
  signal n166_o : std_logic_vector (15 downto 0);
  signal n171_q : std_logic_vector (7 downto 0);
  signal n172_q : std_logic_vector (7 downto 0);
  signal n173_q : std_logic_vector (15 downto 0);
  signal n177_o : std_logic_vector (15 downto 0);
  signal n178_o : std_logic_vector (15 downto 0);
  signal n179_o : std_logic_vector (15 downto 0);
  signal n185_q : std_logic_vector (7 downto 0);
  signal n186_q : std_logic_vector (7 downto 0);
  signal n187_q : std_logic_vector (15 downto 0);
  signal n188_q : std_logic_vector (15 downto 0);
  signal n192_o : std_logic_vector (15 downto 0);
  signal n197_q : std_logic_vector (7 downto 0);
  signal n198_q : std_logic_vector (7 downto 0);
  signal n199_q : std_logic_vector (15 downto 0);
  signal dv_q : std_logic;
  constant n200_o : std_logic := '1';
  signal db_q : std_logic;
  constant n202_o : std_logic := '1';
begin
  dout_i <= n197_q;
  dout_q <= n198_q;
  dout_valid <= db_q;
  dout_pow_sq <= n199_q;
  dout_mark <= dv_q;
  -- entities/abs_square.vhd:29:10
  din_i_r <= n159_q; -- (signal)
  -- entities/abs_square.vhd:30:10
  din_q_r <= n160_q; -- (signal)
  -- entities/abs_square.vhd:32:10
  din_i_rr <= n171_q; -- (signal)
  -- entities/abs_square.vhd:33:10
  din_q_rr <= n172_q; -- (signal)
  -- entities/abs_square.vhd:34:10
  din_i_sq_rr <= n173_q; -- (signal)
  -- entities/abs_square.vhd:36:10
  din_i_rrr <= n185_q; -- (signal)
  -- entities/abs_square.vhd:37:10
  din_q_rrr <= n186_q; -- (signal)
  -- entities/abs_square.vhd:38:10
  din_i_sq_rrr <= n187_q; -- (signal)
  -- entities/abs_square.vhd:39:10
  din_q_sq_rrr <= n188_q; -- (signal)
  -- entities/abs_square.vhd:43:5
  process (clk)
  begin
    if rising_edge (clk) then
      n159_q <= din_i;
    end if;
  end process;
  -- entities/abs_square.vhd:43:5
  process (clk)
  begin
    if rising_edge (clk) then
      n160_q <= din_q;
    end if;
  end process;
  -- entities/abs_square.vhd:53:38
  n164_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:53:38
  n165_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:53:38
  n166_o <= std_logic_vector (resize (signed (n164_o) * signed (n165_o), 16));
  -- entities/abs_square.vhd:50:5
  process (clk)
  begin
    if rising_edge (clk) then
      n171_q <= din_i_r;
    end if;
  end process;
  -- entities/abs_square.vhd:50:5
  process (clk)
  begin
    if rising_edge (clk) then
      n172_q <= din_q_r;
    end if;
  end process;
  -- entities/abs_square.vhd:50:5
  process (clk)
  begin
    if rising_edge (clk) then
      n173_q <= n166_o;
    end if;
  end process;
  -- entities/abs_square.vhd:62:40
  n177_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:62:40
  n178_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:62:40
  n179_o <= std_logic_vector (resize (signed (n177_o) * signed (n178_o), 16));
  -- entities/abs_square.vhd:58:5
  process (clk)
  begin
    if rising_edge (clk) then
      n185_q <= din_i_rr;
    end if;
  end process;
  -- entities/abs_square.vhd:58:5
  process (clk)
  begin
    if rising_edge (clk) then
      n186_q <= din_q_rr;
    end if;
  end process;
  -- entities/abs_square.vhd:58:5
  process (clk)
  begin
    if rising_edge (clk) then
      n187_q <= din_i_sq_rr;
    end if;
  end process;
  -- entities/abs_square.vhd:58:5
  process (clk)
  begin
    if rising_edge (clk) then
      n188_q <= n179_o;
    end if;
  end process;
  -- entities/abs_square.vhd:70:52
  n192_o <= std_logic_vector (unsigned (din_i_sq_rrr) + unsigned (din_q_sq_rrr));
  -- entities/abs_square.vhd:67:5
  process (clk)
  begin
    if rising_edge (clk) then
      n197_q <= din_i_rrr;
    end if;
  end process;
  -- entities/abs_square.vhd:67:5
  process (clk)
  begin
    if rising_edge (clk) then
      n198_q <= din_q_rrr;
    end if;
  end process;
  -- entities/abs_square.vhd:67:5
  process (clk)
  begin
    if rising_edge (clk) then
      n199_q <= n192_o;
    end if;
  end process;
  -- entities/abs_square.vhd:74:3
  dv : entity work.delay_vector_4_c17fd92682ca5b304ac71074b558dda9e8eb4d66 port map (
    clk => clk,
    clken => n200_o,
    d => din_mark,
    q => dv_q);
  -- entities/abs_square.vhd:87:3
  db : entity work.delay_bit_4 port map (
    clk => clk,
    clken => n202_o,
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
  signal n127_o : std_logic_vector (1 downto 0);
  signal n130_o : std_logic_vector (15 downto 0);
  signal n132_o : std_logic;
  signal n133_o : std_logic_vector (15 downto 0);
  signal n135_o : std_logic_vector (15 downto 0);
  signal n136_o : std_logic;
  signal n142_o : std_logic_vector (15 downto 0);
  signal n143_q : std_logic_vector (15 downto 0);
  signal n144_q : std_logic;
  signal n145_o : std_logic_vector (15 downto 0);
  signal n146_q : std_logic_vector (15 downto 0);
  signal n147_o : std_logic_vector (17 downto 0);
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
  wrap_reg_rd_data <= n143_q;
  wrap_reg_rd_ack <= n144_q;
  n0_o <= wrap_din_pps & wrap_din_valid & wrap_din_q & wrap_din_i;
  n2_o <= n147_o (7 downto 0);
  n3_o <= n147_o (15 downto 8);
  n4_o <= n147_o (16);
  n5_o <= n147_o (17);
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
  threshold_reg <= n146_q; -- (signal)
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
      n61_q <= ram_wr_en;
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
  n127_o <= n126_o & n124_o;
  -- test_comp.vhd:211:11
  with n127_o select n130_o <=
    threshold_reg when "10",
    "0000101100001011" when "01",
    "XXXXXXXXXXXXXXXX" when others;
  -- test_comp.vhd:221:13
  n132_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- test_comp.vhd:220:11
  with n132_o select n133_o <=
    wrap_reg_wr_data when '1',
    threshold_reg when others;
  -- test_comp.vhd:210:9
  n135_o <= n133_o when n122_o = '0' else threshold_reg;
  -- test_comp.vhd:209:7
  n136_o <= wrap_reg_en and n122_o;
  -- test_comp.vhd:207:5
  n142_o <= n143_q when n136_o = '0' else n130_o;
  -- test_comp.vhd:207:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n143_q <= n142_o;
    end if;
  end process;
  -- test_comp.vhd:207:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n144_q <= wrap_reg_en;
    end if;
  end process;
  -- test_comp.vhd:207:5
  n145_o <= threshold_reg when wrap_reg_en = '0' else n135_o;
  -- test_comp.vhd:207:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n146_q <= n145_o;
    end if;
  end process;
  -- test_comp.vhd:207:5
  n147_o <= ram_out_pps_rr & ram_out_valid_rr & ram_out_q_rr & ram_out_i_rr;
end rtl;
