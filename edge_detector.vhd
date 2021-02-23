--Circuito Experiência 6 - Detector de Bordas de Subida

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade Principal
entity edge_detector is
  port (
    clock  : in  std_logic;

    reset  : in  std_logic; --Reseta circuito
    sinal  : in  std_logic; --Sinal a ser analisado
    pulso  : out std_logic --Sinaliza quando o sinal muda
  );
end edge_detector;

architecture rtl of edge_detector is
  signal reg0   : std_logic;
  signal reg1   : std_logic;

begin

  detector : process(clock,reset)
  begin
    if(reset='1') then
        reg0 <= '0';
        reg1 <= '0';
    elsif(rising_edge(clock)) then
        reg0 <= sinal;
        reg1 <= reg0;
    end if;
  end process;

  pulso <= not reg1 and reg0;

end rtl;
