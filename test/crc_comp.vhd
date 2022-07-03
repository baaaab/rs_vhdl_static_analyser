library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity crc_comp is
  port
  (
    reset           : in std_logic;
    clk             : in std_logic;

    din_data        : in std_logic_vector(7 downto 0);
    din_valid       : in std_logic;
    din_frame       : in std_logic;

    dout_data       : out  std_logic_vector(7 downto 0);
    dout_valid      : out  std_logic;
    dout_frame      : out  std_logic;
    dout_last       : out  std_logic;
    dout_pass       : out  std_logic;

    phase_increment : out std_logic;

    reg_clk         : in  std_logic;
    reg_addr        : in  std_logic_vector(7 downto 0);
    reg_wr_data     : in  std_logic_vector(15 downto 0);
    reg_wr_en       : in  std_logic;
    reg_en          : in  std_logic;
    reg_rd_data     : out std_logic_vector(15 downto 0);
    reg_rd_ack      : out std_logic
  );
end crc_comp;

architecture rtl_bob of crc_comp is

  constant FRAME_LENGTH : natural := 36;

  type t_state is (in_frame, between_frame);

  signal sreset            : std_logic;

  signal accumulator : std_logic_vector(7 downto 0);
  signal byte_counter : unsigned(5 downto 0);

  signal din_data_r        : std_logic_vector(7 downto 0);
  signal din_valid_r       : std_logic;
  signal din_frame_r       : std_logic;
  signal din_last_r        : std_logic;
  signal din_pass_r        : std_logic;

  signal pass_counter      : unsigned(31 downto 0);
  signal fail_counter      : unsigned(31 downto 0);

  signal consecutive_fail_counter : unsigned(7 downto 0);

begin

  process (clk) begin
    if rising_edge(clk) then

      din_data_r  <= din_data;
      din_valid_r <= din_valid;
      din_frame_r <= din_frame;
      din_last_r  <= '0';
      din_pass_r  <= '0';

      if din_valid = '1' then
        if din_frame = '1' then
          accumulator  <= din_data;
          byte_counter <= (others => '0');
        else
          if byte_counter = FRAME_LENGTH-1 then
            din_last_r <= '1';
            if accumulator = din_data then
              din_pass_r <= '1';
            end if;
          else
            -- CBA doing CRC, use add
            accumulator  <= std_logic_vector(unsigned(accumulator) + unsigned(din_data));
            byte_counter <= byte_counter + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk) begin
    if rising_edge(clk) then
      dout_data  <= din_data_r;
      dout_valid <= din_valid_r;
      dout_frame <= din_frame_r;
      dout_last  <= din_last_r;
      dout_pass  <= din_pass_r;
    end if;
  end process;

  process (clk) begin
    if rising_edge(clk) then
      phase_increment <= '0';
      if din_valid_r = '1' then
        if din_last_r = '1' then
          if din_pass_r = '1' then
            pass_counter             <= pass_counter + 1;
            consecutive_fail_counter <= (others => '0');
          else
            fail_counter             <= fail_counter + 1;
            consecutive_fail_counter <= consecutive_fail_counter + 1;
          end if;
        end if;
      end if;
      if consecutive_fail_counter = (consecutive_fail_counter'range => '1') then
        phase_increment <= '1';
        consecutive_fail_counter <= (others => '0');
      end if;
      if sreset = '1' then
        pass_counter             <= (others => '0');
        fail_counter             <= (others => '0');
        consecutive_fail_counter <= (others => '0');
      end if;
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
              reg_rd_data <= std_logic_vector(pass_counter(31 downto 16));
            when x"02" =>
              reg_rd_data <= std_logic_vector(pass_counter(15 downto 0));
            when x"03" =>
              reg_rd_data <= std_logic_vector(fail_counter(31 downto 16));
            when x"04" =>
              reg_rd_data <= std_logic_vector(fail_counter(15 downto 0));
            when others =>
              assert false report "Invalid reg address" severity error;
              reg_rd_data <= (others => '-');
          end case;
        else
          case reg_addr is
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;

end;