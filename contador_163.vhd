--Circuito Experiência 6 - Contador de 4 bits

--Bibliotecas Necessárias
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--Entidade Principal
entity contador_163 is
   port (
        clock : in  std_logic;

        clr   : in  std_logic; --Limpa Contador
        ld    : in  std_logic; --Carrega Dado em "D" para o contador
        ent   : in  std_logic; --Enable do contador
        enp   : in  std_logic; --Enable do contador também por algum motivo

        D     :  in std_logic_vector (3 downto 0); --Dado que pode ser carregado ao contador
        Q     : out std_logic_vector (3 downto 0); --Saída do Contador
        rco   : out std_logic --Avisa que chegou ao final da contagem
   );
end contador_163;

architecture comportamental of contador_163 is
  signal IQ: integer range 0 to 15;
begin

  process (clock, ent, enp, IQ)
  begin

    if clock'event and clock='1' then
      if clr='0' then   IQ <= 0;
      elsif ld='0' then IQ <= to_integer(unsigned(D));
      elsif ent='1' and enp='1' then
        if IQ=15 then   IQ <= 0;
        else            IQ <= IQ + 1;
        end if;
      else              IQ <= IQ;
      end if;
    end if;

    if IQ=15 and ent='1' then rco <= '1';
    else                      rco <= '0';
    end if;

    Q <= std_logic_vector(to_unsigned(IQ, Q'length));

  end process;
end comportamental;
