library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity async_dpram is
  generic
  (
    ADDR_BITS  : natural := 9;
    DATA_BITS  : natural := 16;
    OUTPUT_REG : boolean := true
  );
  port
  (
    clka  : in  std_logic;
    clkb  : in  std_logic;
    wea   : in  std_logic;
    web   : in  std_logic;
    addra : in  std_logic_vector(ADDR_BITS-1 downto 0);
    addrb : in  std_logic_vector(ADDR_BITS-1 downto 0);
    dia   : in  std_logic_vector(DATA_BITS-1 downto 0);
    dib   : in  std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
    doa   : out std_logic_vector(DATA_BITS-1 downto 0);
    dob   : out std_logic_vector(DATA_BITS-1 downto 0)
  );
end async_dpram;

architecture rtl of async_dpram is
  type ram_type is array (2**ADDR_BITS-1 downto 0) of std_logic_vector(DATA_BITS-1 downto 0);
  shared variable RAM : ram_type;

  signal ram_out_a : std_logic_vector(DATA_BITS-1 downto 0);
  signal ram_out_b : std_logic_vector(DATA_BITS-1 downto 0);

  signal addra_r : std_logic_vector(ADDR_BITS-1 downto 0);
  signal addrb_r : std_logic_vector(ADDR_BITS-1 downto 0);
begin

  process (CLKA) begin
    if rising_edge(CLKA) then
      addra_r <= addra;
      if WEA = '1' then
        RAM(conv_integer(ADDRA)) := DIA;
      end if;
    end if;
  end process;
  ram_out_a <= RAM(conv_integer(addra_r));

  process (CLKB) begin
    if rising_edge(CLKB) then
      addrb_r <= addrb;
      if WEB = '1' then
        RAM(conv_integer(ADDRB)) := DIB;
      end if;
    end if;
  end process;
  ram_out_b <= RAM(conv_integer(addrb_r));

  gen_output_reg : if OUTPUT_REG generate
    process (CLKA) begin
      if rising_edge(CLKA) then
        doa <= ram_out_a;
      end if;
    end process;

    process (CLKB) begin
      if rising_edge(CLKB) then
        dob <= ram_out_b;
      end if;
    end process;
  end generate;

  no_output_reg : if OUTPUT_REG = false generate
    doa <= ram_out_a;
    dob <= ram_out_b;
  end generate;

end;
