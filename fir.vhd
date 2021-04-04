library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir is
   port(
   i_rst: in std_logic;
   i_clk: in std_logic;
   i_en: in std_logic;
   i_data: in std_logic_vector(15 downto 0);
   o_data: out std_logic_vector(31 downto 0));
end entity;

architecture behave of fir is

   signal r_out: signed(31 downto 0);
   type mults is array(0 to 32) of signed(31 downto 0);
   signal r_mults: mults;
   type taps is array(0 to 32) of signed(15 downto 0);
   signal r_circ_buffer: taps;
   constant coeffs: taps := (
      "0000000000000000",
      "1111111100101001",
      "1111111010001110",
      "1111111011000101",
      "0000000000000000",
      "0000000111000001",
      "0000001011110011",
      "0000001001111011",
      "0000000000000000",
      "1111110001110000",
      "1111100111011100",
      "1111101010011001",
      "0000000000000000",
      "0000100101111101",
      "0001010001110101",
      "0001110100110110",
      "0010000010001101",
      "0001110100110110",
      "0001010001110101",
      "0000100101111101",
      "0000000000000000",
      "1111101010011001",
      "1111100111011100",
      "1111110001110000",
      "0000000000000000",
      "0000001001111011",
      "0000001011110011",
      "0000000111000001",
      "0000000000000000",
      "1111111011000101",
      "1111111010001110",
      "1111111100101001",
      "0000000000000000");

begin

   -- FIFO buffer to store the filter inputs
   process(i_rst, i_clk)
   begin
      if (i_rst = '0') then
         for i in 0 to 32 loop
            r_circ_buffer(i) <= (others => '0');
         end loop;
      elsif (rising_edge(i_clk)) then
         if (i_en = '1') then 
            r_circ_buffer(0) <= signed(i_data);
            for i in 1 to 32 loop
               r_circ_buffer(i) <= r_circ_buffer(i-1);
            end loop;
         end if;
      end if;
   end process;

   -- Mult and add
   process(i_clk)
   begin
      if (rising_edge(i_clk)) then
         for i in 0 to 32 loop
            r_mults(i) <= r_circ_buffer(i) * coeffs(i);
         end loop;
         r_out <= 
         r_mults(0) + r_mults(1) + r_mults(2) + r_mults(3) + 
         r_mults(4) + r_mults(5) + r_mults(6) + r_mults(7) + 
         r_mults(8) + r_mults(9) + r_mults(10) + r_mults(11) + 
         r_mults(12) + r_mults(13) + r_mults(14) + r_mults(15) + 
         r_mults(16) + r_mults(17) + r_mults(18) + r_mults(19) + 
         r_mults(20) + r_mults(21) + r_mults(22) + r_mults(23) + 
         r_mults(24) + r_mults(25) + r_mults(26) + r_mults(27) + 
         r_mults(28) + r_mults(29) + r_mults(30) + r_mults(31) +
         r_mults(32); 
      end if;
   end process;

   o_data <= std_logic_vector(r_out);

end architecture;