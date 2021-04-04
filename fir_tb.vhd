library ieee;
use ieee.std_logic_1164.all;

entity fir_tb is 
end entity;

architecture test of fir_tb is
   
   signal rst: std_logic;
   signal clk: std_logic;
   signal en: std_logic := '1';
   signal fir_in: std_logic_vector(15 downto 0);
   signal fir_out: std_logic_vector(31 downto 0);
	
   constant t: time := 20 ns;
	
begin

   -- Design under test instanciation
   dut: entity work.fir port map(
   i_rst => rst, 
   i_clk => clk, 
   i_en => en,
   i_data => fir_in,
   o_data => fir_out);

   -- Clock signal
   process
   begin
      clk <= '0';
      wait for t/2;
      clk <= '1';
      wait for t/2;
   end process;

   -- rst signal
   process
   begin
      rst <= '0';
      wait for t;
      rst <= '1';
      wait;
   end process;

   -- fir input impulse 
   process
   begin
      fir_in <= x"0000";
      wait for 10*t;
      fir_in <= x"0010";
      wait for 10*t;
      fir_in <= x"0000";
      wait;
   end process;

   -- fir input step function
   --process
   --begin
   --   fir_in <= x"0000";
   --   wait for 10*t;
   --   fir_in <= x"0010";
   --   wait;
   --end process;
	
end architecture;