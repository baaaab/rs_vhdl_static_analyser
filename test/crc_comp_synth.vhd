library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity crc_comp is
  port (
    reset: in std_logic;
    clk: in std_logic;
    din_data: in std_logic_vector (7 downto 0);
    din_valid: in std_logic;
    din_frame: in std_logic;
    dout_data: out std_logic_vector (7 downto 0);
    dout_valid: out std_logic;
    dout_frame: out std_logic;
    dout_last: out std_logic;
    dout_pass: out std_logic;
    phase_increment: out std_logic;
    reg_clk: in std_logic;
    reg_addr: in std_logic_vector (7 downto 0);
    reg_wr_data: in std_logic_vector (15 downto 0);
    reg_wr_en: in std_logic;
    reg_en: in std_logic;
    reg_rd_data: out std_logic_vector (15 downto 0);
    reg_rd_ack: out std_logic
  );
end crc_comp;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of crc_comp is
  signal wrap_reset: std_logic;
  signal wrap_clk: std_logic;
  subtype typwrap_din_data is std_logic_vector (7 downto 0);
  signal wrap_din_data: typwrap_din_data;
  signal wrap_din_valid: std_logic;
  signal wrap_din_frame: std_logic;
  signal wrap_reg_clk: std_logic;
  subtype typwrap_reg_addr is std_logic_vector (7 downto 0);
  signal wrap_reg_addr: typwrap_reg_addr;
  subtype typwrap_reg_wr_data is std_logic_vector (15 downto 0);
  signal wrap_reg_wr_data: typwrap_reg_wr_data;
  signal wrap_reg_wr_en: std_logic;
  signal wrap_reg_en: std_logic;
  subtype typwrap_dout_data is std_logic_vector (7 downto 0);
  signal wrap_dout_data: typwrap_dout_data;
  signal wrap_dout_valid: std_logic;
  signal wrap_dout_frame: std_logic;
  signal wrap_dout_last: std_logic;
  signal wrap_dout_pass: std_logic;
  signal wrap_phase_increment: std_logic;
  subtype typwrap_reg_rd_data is std_logic_vector (15 downto 0);
  signal wrap_reg_rd_data: typwrap_reg_rd_data;
  signal wrap_reg_rd_ack: std_logic;
  signal sreset : std_logic;
  signal accumulator : std_logic_vector (7 downto 0);
  signal byte_counter : std_logic_vector (5 downto 0);
  signal din_data_r : std_logic_vector (7 downto 0);
  signal din_valid_r : std_logic;
  signal din_frame_r : std_logic;
  signal din_last_r : std_logic;
  signal din_pass_r : std_logic;
  signal pass_counter : std_logic_vector (31 downto 0);
  signal fail_counter : std_logic_vector (31 downto 0);
  signal consecutive_fail_counter : std_logic_vector (7 downto 0);
  signal n12_o : std_logic;
  signal n13_o : std_logic;
  signal n16_o : std_logic;
  signal n17_o : std_logic_vector (7 downto 0);
  signal n19_o : std_logic_vector (5 downto 0);
  signal n20_o : std_logic_vector (7 downto 0);
  signal n21_o : std_logic_vector (5 downto 0);
  signal n24_o : std_logic;
  signal n26_o : std_logic;
  signal n27_o : std_logic_vector (7 downto 0);
  signal n29_o : std_logic_vector (5 downto 0);
  signal n31_o : std_logic;
  signal n33_o : std_logic;
  signal n37_o : std_logic;
  signal n40_o : std_logic;
  signal n50_o : std_logic_vector (7 downto 0);
  signal n51_q : std_logic_vector (7 downto 0);
  signal n52_o : std_logic_vector (5 downto 0);
  signal n53_q : std_logic_vector (5 downto 0);
  signal n54_q : std_logic_vector (7 downto 0);
  signal n55_q : std_logic;
  signal n56_q : std_logic;
  signal n57_q : std_logic;
  signal n58_q : std_logic;
  signal n68_q : std_logic_vector (7 downto 0);
  signal n69_q : std_logic;
  signal n70_q : std_logic;
  signal n71_q : std_logic;
  signal n72_q : std_logic;
  signal n77_o : std_logic_vector (31 downto 0);
  signal n79_o : std_logic_vector (31 downto 0);
  signal n81_o : std_logic_vector (7 downto 0);
  signal n82_o : std_logic_vector (31 downto 0);
  signal n83_o : std_logic_vector (31 downto 0);
  signal n85_o : std_logic_vector (7 downto 0);
  signal n86_o : std_logic;
  signal n87_o : std_logic_vector (31 downto 0);
  signal n88_o : std_logic_vector (7 downto 0);
  signal n89_o : std_logic;
  signal n90_o : std_logic;
  signal n91_o : std_logic;
  signal n93_o : std_logic;
  signal n96_o : std_logic;
  signal n99_o : std_logic_vector (7 downto 0);
  signal n101_o : std_logic_vector (31 downto 0);
  signal n103_o : std_logic_vector (31 downto 0);
  signal n105_o : std_logic_vector (7 downto 0);
  signal n111_q : std_logic;
  signal n112_q : std_logic_vector (31 downto 0);
  signal n113_q : std_logic_vector (31 downto 0);
  signal n114_q : std_logic_vector (7 downto 0);
  signal n118_o : std_logic;
  signal n120_o : std_logic;
  signal n121_o : std_logic_vector (15 downto 0);
  signal n123_o : std_logic;
  signal n124_o : std_logic_vector (15 downto 0);
  signal n126_o : std_logic;
  signal n127_o : std_logic_vector (15 downto 0);
  signal n129_o : std_logic;
  signal n130_o : std_logic_vector (15 downto 0);
  signal n132_o : std_logic;
  signal n135_o : std_logic;
  signal n136_o : std_logic;
  signal n138_o : std_logic_vector (4 downto 0);
  signal n141_o : std_logic_vector (15 downto 0);
  signal n144_o : std_logic;
  signal n147_o : std_logic;
  signal n148_o : std_logic;
  signal n150_o : std_logic;
  signal n158_q : std_logic := '1';
  signal n159_o : std_logic_vector (15 downto 0);
  signal n160_q : std_logic_vector (15 downto 0);
  signal n161_q : std_logic;
begin
  wrap_reset <= reset;
  wrap_clk <= clk;
  wrap_din_data <= din_data;
  wrap_din_valid <= din_valid;
  wrap_din_frame <= din_frame;
  wrap_reg_clk <= reg_clk;
  wrap_reg_addr <= reg_addr;
  wrap_reg_wr_data <= reg_wr_data;
  wrap_reg_wr_en <= reg_wr_en;
  wrap_reg_en <= reg_en;
  dout_data <= wrap_dout_data;
  dout_valid <= wrap_dout_valid;
  dout_frame <= wrap_dout_frame;
  dout_last <= wrap_dout_last;
  dout_pass <= wrap_dout_pass;
  phase_increment <= wrap_phase_increment;
  reg_rd_data <= wrap_reg_rd_data;
  reg_rd_ack <= wrap_reg_rd_ack;
  wrap_dout_data <= n68_q;
  wrap_dout_valid <= n69_q;
  wrap_dout_frame <= n70_q;
  wrap_dout_last <= n71_q;
  wrap_dout_pass <= n72_q;
  wrap_phase_increment <= n111_q;
  wrap_reg_rd_data <= n160_q;
  wrap_reg_rd_ack <= n161_q;
  -- crc_comp.vhd:41:10
  sreset <= 'X'; -- (signal)
  -- crc_comp.vhd:43:10
  accumulator <= n51_q; -- (signal)
  -- crc_comp.vhd:44:10
  byte_counter <= n53_q; -- (signal)
  -- crc_comp.vhd:46:10
  din_data_r <= n54_q; -- (signal)
  -- crc_comp.vhd:47:10
  din_valid_r <= n55_q; -- (signal)
  -- crc_comp.vhd:48:10
  din_frame_r <= n56_q; -- (signal)
  -- crc_comp.vhd:49:10
  din_last_r <= n57_q; -- (signal)
  -- crc_comp.vhd:50:10
  din_pass_r <= n58_q; -- (signal)
  -- crc_comp.vhd:52:10
  pass_counter <= n112_q; -- (signal)
  -- crc_comp.vhd:53:10
  fail_counter <= n113_q; -- (signal)
  -- crc_comp.vhd:55:10
  consecutive_fail_counter <= n114_q; -- (signal)
  -- crc_comp.vhd:73:27
  n12_o <= '1' when byte_counter = "100011" else '0';
  -- crc_comp.vhd:75:28
  n13_o <= '1' when accumulator = wrap_din_data else '0';
  -- crc_comp.vhd:75:13
  n16_o <= '0' when n13_o = '0' else '1';
  -- crc_comp.vhd:80:68
  n17_o <= std_logic_vector (unsigned (accumulator) + unsigned (wrap_din_data));
  -- crc_comp.vhd:81:42
  n19_o <= std_logic_vector (unsigned (byte_counter) + unsigned'("000001"));
  -- crc_comp.vhd:73:11
  n20_o <= n17_o when n12_o = '0' else accumulator;
  -- crc_comp.vhd:73:11
  n21_o <= n19_o when n12_o = '0' else byte_counter;
  -- crc_comp.vhd:73:11
  n24_o <= '0' when n12_o = '0' else '1';
  -- crc_comp.vhd:73:11
  n26_o <= '0' when n12_o = '0' else n16_o;
  -- crc_comp.vhd:69:9
  n27_o <= n20_o when wrap_din_frame = '0' else wrap_din_data;
  -- crc_comp.vhd:69:9
  n29_o <= n21_o when wrap_din_frame = '0' else "000000";
  -- crc_comp.vhd:69:9
  n31_o <= n24_o when wrap_din_frame = '0' else '0';
  -- crc_comp.vhd:69:9
  n33_o <= n26_o when wrap_din_frame = '0' else '0';
  -- crc_comp.vhd:68:7
  n37_o <= '0' when wrap_din_valid = '0' else n31_o;
  -- crc_comp.vhd:68:7
  n40_o <= '0' when wrap_din_valid = '0' else n33_o;
  -- crc_comp.vhd:60:5
  n50_o <= accumulator when wrap_din_valid = '0' else n27_o;
  -- crc_comp.vhd:60:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n51_q <= n50_o;
    end if;
  end process;
  -- crc_comp.vhd:60:5
  n52_o <= byte_counter when wrap_din_valid = '0' else n29_o;
  -- crc_comp.vhd:60:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n53_q <= n52_o;
    end if;
  end process;
  -- crc_comp.vhd:60:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n54_q <= wrap_din_data;
    end if;
  end process;
  -- crc_comp.vhd:60:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n55_q <= wrap_din_valid;
    end if;
  end process;
  -- crc_comp.vhd:60:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n56_q <= wrap_din_frame;
    end if;
  end process;
  -- crc_comp.vhd:60:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n57_q <= n37_o;
    end if;
  end process;
  -- crc_comp.vhd:60:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n58_q <= n40_o;
    end if;
  end process;
  -- crc_comp.vhd:89:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n68_q <= din_data_r;
    end if;
  end process;
  -- crc_comp.vhd:89:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n69_q <= din_valid_r;
    end if;
  end process;
  -- crc_comp.vhd:89:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n70_q <= din_frame_r;
    end if;
  end process;
  -- crc_comp.vhd:89:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n71_q <= din_last_r;
    end if;
  end process;
  -- crc_comp.vhd:89:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n72_q <= din_pass_r;
    end if;
  end process;
  -- crc_comp.vhd:104:54
  n77_o <= std_logic_vector (unsigned (pass_counter) + unsigned'("00000000000000000000000000000001"));
  -- crc_comp.vhd:107:54
  n79_o <= std_logic_vector (unsigned (fail_counter) + unsigned'("00000000000000000000000000000001"));
  -- crc_comp.vhd:108:66
  n81_o <= std_logic_vector (unsigned (consecutive_fail_counter) + unsigned'("00000001"));
  -- crc_comp.vhd:101:7
  n82_o <= pass_counter when n89_o = '0' else n77_o;
  -- crc_comp.vhd:103:11
  n83_o <= n79_o when din_pass_r = '0' else fail_counter;
  -- crc_comp.vhd:103:11
  n85_o <= n81_o when din_pass_r = '0' else "00000000";
  -- crc_comp.vhd:102:9
  n86_o <= din_last_r and din_pass_r;
  -- crc_comp.vhd:101:7
  n87_o <= fail_counter when n90_o = '0' else n83_o;
  -- crc_comp.vhd:101:7
  n88_o <= consecutive_fail_counter when n91_o = '0' else n85_o;
  -- crc_comp.vhd:101:7
  n89_o <= din_valid_r and n86_o;
  -- crc_comp.vhd:101:7
  n90_o <= din_valid_r and din_last_r;
  -- crc_comp.vhd:101:7
  n91_o <= din_valid_r and din_last_r;
  -- crc_comp.vhd:112:35
  n93_o <= '1' when consecutive_fail_counter = "11111111" else '0';
  -- crc_comp.vhd:112:7
  n96_o <= '0' when n93_o = '0' else '1';
  -- crc_comp.vhd:112:7
  n99_o <= n88_o when n93_o = '0' else "00000000";
  -- crc_comp.vhd:116:7
  n101_o <= n82_o when sreset = '0' else "00000000000000000000000000000000";
  -- crc_comp.vhd:116:7
  n103_o <= n87_o when sreset = '0' else "00000000000000000000000000000000";
  -- crc_comp.vhd:116:7
  n105_o <= n99_o when sreset = '0' else "00000000";
  -- crc_comp.vhd:99:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n111_q <= n96_o;
    end if;
  end process;
  -- crc_comp.vhd:99:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n112_q <= n101_o;
    end if;
  end process;
  -- crc_comp.vhd:99:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n113_q <= n103_o;
    end if;
  end process;
  -- crc_comp.vhd:99:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n114_q <= n105_o;
    end if;
  end process;
  -- crc_comp.vhd:128:22
  n118_o <= not wrap_reg_wr_en;
  -- crc_comp.vhd:130:13
  n120_o <= '1' when wrap_reg_addr = "00000000" else '0';
  -- crc_comp.vhd:133:59
  n121_o <= pass_counter (31 downto 16);
  -- crc_comp.vhd:132:13
  n123_o <= '1' when wrap_reg_addr = "00000001" else '0';
  -- crc_comp.vhd:135:59
  n124_o <= pass_counter (15 downto 0);
  -- crc_comp.vhd:134:13
  n126_o <= '1' when wrap_reg_addr = "00000010" else '0';
  -- crc_comp.vhd:137:59
  n127_o <= fail_counter (31 downto 16);
  -- crc_comp.vhd:136:13
  n129_o <= '1' when wrap_reg_addr = "00000011" else '0';
  -- crc_comp.vhd:139:59
  n130_o <= fail_counter (15 downto 0);
  -- crc_comp.vhd:138:13
  n132_o <= '1' when wrap_reg_addr = "00000100" else '0';
  -- crc_comp.vhd:141:15
  n135_o <= not n150_o;
  -- crc_comp.vhd:141:15
  n136_o <= n135_o or '0';
  -- crc_comp.vhd:141:15
  n137: postponed assert n158_q = '1' severity error; --  assert
  n138_o <= n132_o & n129_o & n126_o & n123_o & n120_o;
  -- crc_comp.vhd:129:11
  with n138_o select n141_o <=
    n130_o when "10000",
    n127_o when "01000",
    n124_o when "00100",
    n121_o when "00010",
    "0000101100001011" when "00001",
    "XXXXXXXXXXXXXXXX" when others;
  -- crc_comp.vhd:129:11
  with n138_o select n144_o <=
    '0' when "10000",
    '0' when "01000",
    '0' when "00100",
    '0' when "00010",
    '0' when "00001",
    '1' when others;
  -- crc_comp.vhd:128:9
  n147_o <= '0' when n118_o = '0' else n144_o;
  -- crc_comp.vhd:127:7
  n148_o <= wrap_reg_en and n118_o;
  -- crc_comp.vhd:127:7
  n150_o <= '0' when wrap_reg_en = '0' else n147_o;
  -- crc_comp.vhd:124:3
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n158_q <= n136_o;
    end if;
  end process;
  -- crc_comp.vhd:125:5
  n159_o <= n160_q when n148_o = '0' else n141_o;
  -- crc_comp.vhd:125:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n160_q <= n159_o;
    end if;
  end process;
  -- crc_comp.vhd:125:5
  process (wrap_reg_clk)
  begin
    if rising_edge (wrap_reg_clk) then
      n161_q <= wrap_reg_en;
    end if;
  end process;
end rtl;
