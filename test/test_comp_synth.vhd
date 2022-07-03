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
  -- entities/async_dpram.vhd:56:19
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
  signal n281_q : std_logic_vector (8 downto 0);
  signal n296_q : std_logic_vector (8 downto 0);
  signal n305_q : std_logic_vector (32 downto 0);
  signal n311_q : std_logic_vector (32 downto 0);
  signal n314_data : std_logic_vector (32 downto 0);
  signal n315_data : std_logic_vector (32 downto 0);
begin
  doa <= n305_q;
  dob <= n311_q;
  -- entities/async_dpram.vhd:31:10
  ram_out_a <= n315_data; -- (signal)
  -- entities/async_dpram.vhd:32:10
  ram_out_b <= n314_data; -- (signal)
  -- entities/async_dpram.vhd:34:10
  addra_r <= n281_q; -- (signal)
  -- entities/async_dpram.vhd:35:10
  addrb_r <= n296_q; -- (signal)
  -- entities/async_dpram.vhd:39:5
  process (clka)
  begin
    if rising_edge (clka) then
      n281_q <= addra;
    end if;
  end process;
  -- entities/async_dpram.vhd:49:5
  process (clkb)
  begin
    if rising_edge (clkb) then
      n296_q <= addrb;
    end if;
  end process;
  -- entities/async_dpram.vhd:60:7
  process (clka)
  begin
    if rising_edge (clka) then
      n305_q <= ram_out_a;
    end if;
  end process;
  -- entities/async_dpram.vhd:66:7
  process (clkb)
  begin
    if rising_edge (clkb) then
      n311_q <= ram_out_b;
    end if;
  end process;
  -- entities/async_dpram.vhd:22:5
  process (addrb_r, addra_r, clkb, clka) is
    type ram_type is array (0 to 511)
      of std_logic_vector (32 downto 0);
    variable ram : ram_type := (others => (others => 'X'));
  begin
    n314_data <= ram(to_integer (unsigned (addrb_r)));
    n315_data <= ram(to_integer (unsigned (addra_r)));
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
  signal n257_o : std_logic_vector (15 downto 0);
  signal n258_o : std_logic_vector (15 downto 0);
  signal n259_o : std_logic_vector (15 downto 0);
  signal n260_o : std_logic_vector (63 downto 0);
  signal n264_o : std_logic_vector (63 downto 0);
  signal n265_q : std_logic_vector (63 downto 0);
  signal n266_o : std_logic_vector (15 downto 0);
begin
  q <= n266_o;
  -- entities/delay_vector.vhd:21:10
  shreg <= n265_q; -- (signal)
  -- entities/delay_vector.vhd:30:30
  n257_o <= shreg (15 downto 0);
  -- entities/delay_vector.vhd:30:30
  n258_o <= shreg (31 downto 16);
  -- entities/delay_vector.vhd:30:30
  n259_o <= shreg (47 downto 32);
  -- entities/abs_square.vhd:84:3
  n260_o <= n259_o & n258_o & n257_o & d;
  -- entities/delay_vector.vhd:27:5
  n264_o <= shreg when clken = '0' else n260_o;
  -- entities/delay_vector.vhd:27:5
  process (clk)
  begin
    if rising_edge (clk) then
      n265_q <= n264_o;
    end if;
  end process;
  -- entities/delay_vector.vhd:37:13
  n266_o <= shreg (63 downto 48);
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
  signal n182_o : std_logic_vector (7 downto 0);
  signal n184_o : std_logic_vector (7 downto 0);
  signal n188_q : std_logic_vector (7 downto 0);
  signal n189_q : std_logic_vector (7 downto 0);
  signal n193_o : std_logic_vector (15 downto 0);
  signal n194_o : std_logic_vector (15 downto 0);
  signal n195_o : std_logic_vector (15 downto 0);
  signal n197_o : std_logic_vector (7 downto 0);
  signal n199_o : std_logic_vector (7 downto 0);
  signal n201_o : std_logic_vector (15 downto 0);
  signal n206_q : std_logic_vector (7 downto 0);
  signal n207_q : std_logic_vector (7 downto 0);
  signal n208_q : std_logic_vector (15 downto 0);
  signal n212_o : std_logic_vector (15 downto 0);
  signal n213_o : std_logic_vector (15 downto 0);
  signal n214_o : std_logic_vector (15 downto 0);
  signal n216_o : std_logic_vector (7 downto 0);
  signal n218_o : std_logic_vector (7 downto 0);
  signal n220_o : std_logic_vector (15 downto 0);
  signal n222_o : std_logic_vector (15 downto 0);
  signal n228_q : std_logic_vector (7 downto 0);
  signal n229_q : std_logic_vector (7 downto 0);
  signal n230_q : std_logic_vector (15 downto 0);
  signal n231_q : std_logic_vector (15 downto 0);
  signal n235_o : std_logic_vector (15 downto 0);
  signal n237_o : std_logic_vector (7 downto 0);
  signal n239_o : std_logic_vector (7 downto 0);
  signal n241_o : std_logic_vector (15 downto 0);
  signal n246_q : std_logic_vector (7 downto 0);
  signal n247_q : std_logic_vector (7 downto 0);
  signal n248_q : std_logic_vector (15 downto 0);
  signal dv_q : std_logic;
  constant n249_o : std_logic := '1';
  signal db_q : std_logic;
  constant n251_o : std_logic := '1';
begin
  dout_i <= n246_q;
  dout_q <= n247_q;
  dout_valid <= db_q;
  dout_pow_sq <= n248_q;
  dout_mark <= dv_q;
  -- entities/abs_square.vhd:29:10
  din_i_r <= n188_q; -- (signal)
  -- entities/abs_square.vhd:30:10
  din_q_r <= n189_q; -- (signal)
  -- entities/abs_square.vhd:32:10
  din_i_rr <= n206_q; -- (signal)
  -- entities/abs_square.vhd:33:10
  din_q_rr <= n207_q; -- (signal)
  -- entities/abs_square.vhd:34:10
  din_i_sq_rr <= n208_q; -- (signal)
  -- entities/abs_square.vhd:36:10
  din_i_rrr <= n228_q; -- (signal)
  -- entities/abs_square.vhd:37:10
  din_q_rrr <= n229_q; -- (signal)
  -- entities/abs_square.vhd:38:10
  din_i_sq_rrr <= n230_q; -- (signal)
  -- entities/abs_square.vhd:39:10
  din_q_sq_rrr <= n231_q; -- (signal)
  -- entities/abs_square.vhd:49:7
  n182_o <= din_i when reset = '0' else "00000000";
  -- entities/abs_square.vhd:49:7
  n184_o <= din_q when reset = '0' else "00000000";
  -- entities/abs_square.vhd:46:5
  process (clk)
  begin
    if rising_edge (clk) then
      n188_q <= n182_o;
    end if;
  end process;
  -- entities/abs_square.vhd:46:5
  process (clk)
  begin
    if rising_edge (clk) then
      n189_q <= n184_o;
    end if;
  end process;
  -- entities/abs_square.vhd:60:38
  n193_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:60:38
  n194_o <= std_logic_vector (resize (signed (din_i_r), 16));  --  sext
  -- entities/abs_square.vhd:60:38
  n195_o <= std_logic_vector (resize (signed (n193_o) * signed (n194_o), 16));
  -- entities/abs_square.vhd:61:7
  n197_o <= din_i_r when reset = '0' else "00000000";
  -- entities/abs_square.vhd:61:7
  n199_o <= din_q_r when reset = '0' else "00000000";
  -- entities/abs_square.vhd:61:7
  n201_o <= n195_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n206_q <= n197_o;
    end if;
  end process;
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n207_q <= n199_o;
    end if;
  end process;
  -- entities/abs_square.vhd:57:5
  process (clk)
  begin
    if rising_edge (clk) then
      n208_q <= n201_o;
    end if;
  end process;
  -- entities/abs_square.vhd:74:40
  n212_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:74:40
  n213_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
  -- entities/abs_square.vhd:74:40
  n214_o <= std_logic_vector (resize (signed (n212_o) * signed (n213_o), 16));
  -- entities/abs_square.vhd:75:7
  n216_o <= din_i_rr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:75:7
  n218_o <= din_q_rr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:75:7
  n220_o <= din_i_sq_rr when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:75:7
  n222_o <= n214_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n228_q <= n216_o;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n229_q <= n218_o;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n230_q <= n220_o;
    end if;
  end process;
  -- entities/abs_square.vhd:70:5
  process (clk)
  begin
    if rising_edge (clk) then
      n231_q <= n222_o;
    end if;
  end process;
  -- entities/abs_square.vhd:88:52
  n235_o <= std_logic_vector (unsigned (din_i_sq_rrr) + unsigned (din_q_sq_rrr));
  -- entities/abs_square.vhd:89:7
  n237_o <= din_i_rrr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:89:7
  n239_o <= din_q_rrr when reset = '0' else "00000000";
  -- entities/abs_square.vhd:89:7
  n241_o <= n235_o when reset = '0' else "0000000000000000";
  -- entities/abs_square.vhd:85:5
  process (clk)
  begin
    if rising_edge (clk) then
      n246_q <= n237_o;
    end if;
  end process;
  -- entities/abs_square.vhd:85:5
  process (clk)
  begin
    if rising_edge (clk) then
      n247_q <= n239_o;
    end if;
  end process;
  -- entities/abs_square.vhd:85:5
  process (clk)
  begin
    if rising_edge (clk) then
      n248_q <= n241_o;
    end if;
  end process;
  -- entities/abs_square.vhd:97:3
  dv : entity work.delay_vector_4_c17fd92682ca5b304ac71074b558dda9e8eb4d66 port map (
    clk => clk,
    clken => n249_o,
    d => din_mark,
    q => dv_q);
  -- entities/abs_square.vhd:110:3
  db : entity work.delay_bit_4 port map (
    clk => clk,
    clken => n251_o,
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
  constant n46_o : std_logic := '0';
  constant n47_o : std_logic_vector (32 downto 0) := "000000000000000000000000000000000";
  signal n53_o : std_logic_vector (8 downto 0);
  signal n58_q : std_logic_vector (8 downto 0);
  signal n59_q : std_logic;
  signal n60_q : std_logic;
  signal n61_o : std_logic_vector (15 downto 0);
  signal n62_o : std_logic_vector (7 downto 0);
  signal n63_o : std_logic_vector (7 downto 0);
  signal n64_o : std_logic;
  signal n69_o : std_logic_vector (16 downto 0);
  signal n71_o : std_logic_vector (16 downto 0);
  signal n72_o : std_logic_vector (16 downto 0);
  signal n80_q : std_logic_vector (7 downto 0);
  signal n81_q : std_logic_vector (7 downto 0);
  signal n82_q : std_logic_vector (15 downto 0);
  signal n83_q : std_logic;
  signal n84_q : std_logic;
  signal n85_q : std_logic_vector (16 downto 0);
  signal n90_o : std_logic_vector (16 downto 0);
  signal n91_o : std_logic;
  signal n94_o : std_logic;
  signal n103_q : std_logic_vector (7 downto 0);
  signal n104_q : std_logic_vector (7 downto 0);
  signal n105_q : std_logic_vector (15 downto 0);
  signal n106_q : std_logic;
  signal n107_q : std_logic;
  signal n108_q : std_logic;
  signal n112_o : std_logic_vector (17 downto 0);
  signal n117_q : std_logic_vector (17 downto 0);
  signal n118_q : std_logic_vector (15 downto 0);
  signal n119_q : std_logic;
  signal n126_q : std_logic_vector (15 downto 0);
  signal n127_q : std_logic_vector (15 downto 0);
  signal n131_o : std_logic;
  signal n133_o : std_logic;
  signal n135_o : std_logic;
  signal n138_o : std_logic;
  signal n139_o : std_logic;
  signal n141_o : std_logic_vector (1 downto 0);
  signal n144_o : std_logic_vector (15 downto 0);
  signal n147_o : std_logic;
  signal n149_o : std_logic;
  signal n150_o : std_logic_vector (15 downto 0);
  signal n152_o : std_logic_vector (15 downto 0);
  signal n154_o : std_logic;
  signal n155_o : std_logic;
  signal n158_o : std_logic;
  signal n167_q : std_logic := '1';
  signal n168_o : std_logic_vector (15 downto 0);
  signal n169_q : std_logic_vector (15 downto 0);
  signal n170_q : std_logic;
  signal n171_o : std_logic_vector (15 downto 0);
  signal n172_q : std_logic_vector (15 downto 0);
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
  wrap_dout_sq_power <= n118_q;
  wrap_dout_frame <= n119_q;
  wrap_reg_rd_data <= n169_q;
  wrap_reg_rd_ack <= n170_q;
  n0_o <= wrap_din_pps & wrap_din_valid & wrap_din_q & wrap_din_i;
  n2_o <= n117_q (7 downto 0);
  n3_o <= n117_q (15 downto 8);
  n4_o <= n117_q (16);
  n5_o <= n117_q (17);
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
  ram_rd_addr <= n58_q; -- (signal)
  -- test_comp.vhd:46:10
  ram_rd_data <= ram_inst_dob; -- (signal)
  -- test_comp.vhd:48:10
  ram_rd_valid <= n59_q; -- (signal)
  -- test_comp.vhd:49:10
  ram_rd_valid_r <= n60_q; -- (signal)
  -- test_comp.vhd:51:10
  ram_out_i <= n62_o; -- (signal)
  -- test_comp.vhd:52:10
  ram_out_q <= n63_o; -- (signal)
  -- test_comp.vhd:53:10
  ram_out_pow <= n61_o; -- (signal)
  -- test_comp.vhd:54:10
  ram_out_pps <= n64_o; -- (signal)
  -- test_comp.vhd:55:10
  abs_pow_delayed <= dv_q; -- (signal)
  -- test_comp.vhd:57:10
  ram_out_i_r <= n80_q; -- (signal)
  -- test_comp.vhd:58:10
  ram_out_q_r <= n81_q; -- (signal)
  -- test_comp.vhd:59:10
  ram_out_pow_r <= n82_q; -- (signal)
  -- test_comp.vhd:60:10
  ram_out_valid_r <= n83_q; -- (signal)
  -- test_comp.vhd:61:10
  ram_out_pps_r <= n84_q; -- (signal)
  -- test_comp.vhd:62:10
  power_difference <= n85_q; -- (signal)
  -- test_comp.vhd:64:10
  ram_out_i_rr <= n103_q; -- (signal)
  -- test_comp.vhd:65:10
  ram_out_q_rr <= n104_q; -- (signal)
  -- test_comp.vhd:66:10
  ram_out_pow_rr <= n105_q; -- (signal)
  -- test_comp.vhd:67:10
  ram_out_valid_rr <= n106_q; -- (signal)
  -- test_comp.vhd:68:10
  ram_out_pps_rr <= n107_q; -- (signal)
  -- test_comp.vhd:69:10
  edge_detected <= n108_q; -- (signal)
  -- test_comp.vhd:71:10
  threshold <= n126_q; -- (signal)
  -- test_comp.vhd:72:10
  threshold_reg <= n172_q; -- (signal)
  -- test_comp.vhd:73:10
  threshold_reg_r <= n127_q; -- (signal)
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
    wea => ram_wr_en,
    web => n46_o,
    addra => ram_wr_addr,
    addrb => ram_rd_addr,
    dia => ram_wr_data,
    dib => n47_o,
    doa => open,
    dob => ram_inst_dob);
  -- test_comp.vhd:154:65
  n53_o <= std_logic_vector (unsigned (ram_wr_addr) - unsigned'("110010000"));
  -- test_comp.vhd:153:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n58_q <= n53_o;
    end if;
  end process;
  -- test_comp.vhd:153:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n59_q <= abs_valid;
    end if;
  end process;
  -- test_comp.vhd:153:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n60_q <= ram_rd_valid;
    end if;
  end process;
  -- test_comp.vhd:161:29
  n61_o <= ram_rd_data (32 downto 17);
  -- test_comp.vhd:162:29
  n62_o <= ram_rd_data (16 downto 9);
  -- test_comp.vhd:163:29
  n63_o <= ram_rd_data (8 downto 1);
  -- test_comp.vhd:164:29
  n64_o <= ram_rd_data (0);
  -- test_comp.vhd:173:38
  n69_o <= '0' & abs_pow_delayed;
  -- test_comp.vhd:173:70
  n71_o <= '0' & ram_out_pow;
  -- test_comp.vhd:173:57
  n72_o <= std_logic_vector (unsigned (n69_o) - unsigned (n71_o));
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n80_q <= ram_out_i;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n81_q <= ram_out_q;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n82_q <= ram_out_pow;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n83_q <= ram_rd_valid_r;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n84_q <= ram_out_pps;
    end if;
  end process;
  -- test_comp.vhd:167:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n85_q <= n72_o;
    end if;
  end process;
  -- test_comp.vhd:186:40
  n90_o <= '0' & threshold;
  -- test_comp.vhd:186:27
  n91_o <= '1' when signed (power_difference) > signed (n90_o) else '0';
  -- test_comp.vhd:186:7
  n94_o <= '0' when n91_o = '0' else '1';
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n103_q <= ram_out_i_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n104_q <= ram_out_q_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n105_q <= ram_out_pow_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n106_q <= ram_out_valid_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n107_q <= ram_out_pps_r;
    end if;
  end process;
  -- test_comp.vhd:179:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n108_q <= n94_o;
    end if;
  end process;
  n112_o <= ram_out_pps_rr & ram_out_valid_rr & ram_out_q_rr & ram_out_i_rr;
  -- test_comp.vhd:193:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n117_q <= n112_o;
    end if;
  end process;
  -- test_comp.vhd:193:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n118_q <= ram_out_pow_rr;
    end if;
  end process;
  -- test_comp.vhd:193:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n119_q <= edge_detected;
    end if;
  end process;
  -- test_comp.vhd:204:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n126_q <= threshold_reg_r;
    end if;
  end process;
  -- test_comp.vhd:204:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n127_q <= threshold_reg;
    end if;
  end process;
  -- test_comp.vhd:214:22
  n131_o <= not wrap_reg_wr_en;
  -- test_comp.vhd:216:13
  n133_o <= '1' when wrap_reg_addr = "00000000" else '0';
  -- test_comp.vhd:218:13
  n135_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- test_comp.vhd:221:15
  n138_o <= not n158_o;
  -- test_comp.vhd:221:15
  n139_o <= n138_o or '0';
  -- test_comp.vhd:221:15
  n140: postponed assert n167_q = '1' severity error; --  assert
  n141_o <= n135_o & n133_o;
  -- test_comp.vhd:215:11
  with n141_o select n144_o <=
    threshold_reg when "10",
    "0000101100001011" when "01",
    "XXXXXXXXXXXXXXXX" when others;
  -- test_comp.vhd:215:11
  with n141_o select n147_o <=
    '0' when "10",
    '0' when "01",
    '1' when others;
  -- test_comp.vhd:226:13
  n149_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- test_comp.vhd:225:11
  with n149_o select n150_o <=
    wrap_reg_wr_data when '1',
    threshold_reg when others;
  -- test_comp.vhd:214:9
  n152_o <= n150_o when n131_o = '0' else threshold_reg;
  -- test_comp.vhd:214:9
  n154_o <= '0' when n131_o = '0' else n147_o;
  -- test_comp.vhd:213:7
  n155_o <= wrap_reg_en and n131_o;
  -- test_comp.vhd:213:7
  n158_o <= '0' when wrap_reg_en = '0' else n154_o;
  -- test_comp.vhd:210:3
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n167_q <= n139_o;
    end if;
  end process;
  -- test_comp.vhd:211:5
  n168_o <= n169_q when n155_o = '0' else n144_o;
  -- test_comp.vhd:211:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n169_q <= n168_o;
    end if;
  end process;
  -- test_comp.vhd:211:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n170_q <= wrap_reg_en;
    end if;
  end process;
  -- test_comp.vhd:211:5
  n171_o <= threshold_reg when wrap_reg_en = '0' else n152_o;
  -- test_comp.vhd:211:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n172_q <= n171_o;
    end if;
  end process;
end rtl;
