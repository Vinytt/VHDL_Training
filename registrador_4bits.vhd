--Circuito Experiência 6 - Registrador de 4 bits

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade Principal
entity registrador_4bits is
  port (
    clock:  in  std_logic;

    clear:  in  std_logic; --Limpa Registrador (coloca o valor em "0000")
    enable: in  std_logic; --Enable para Registrar um novo valor

    D:       in std_logic_vector(3 downto 0); --Valor que pode ser registrado
    Q:      out std_logic_vector(3 downto 0) --Valor atualmente registrado
  );
end entity;

architecture arch of registrador_4bits is
  signal IQ: std_logic_vector(3 downto 0);
begin
    process(clock, clear, IQ)
    begin
      if (clear = '1') then IQ <= (others => '0');
      elsif (clock'event and clock='1') then
        if (enable='1') then IQ <= D; end if;
      end if;
    end process;

    Q <= IQ;
end architecture;
