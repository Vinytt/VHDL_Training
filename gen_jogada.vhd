--Circuito Experiência 6 - Gerenciador da Jogada

---Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade Principal
entity gen_jogada is
  port(
    clock : in std_logic;

    registraR : in std_logic; --Enable do registrador
    limpaR : in std_logic; --Limpa registrador

    botoes : in std_logic_vector(3 downto 0); --Input da jogada
    jogada : out std_logic_vector(3 downto 0); --Jogada registrada

    tem_jogada : out std_logic --Indica que uma nova jogada foi feita
  );
end entity;

architecture gen_jogada_arch of gen_jogada is

--Componentes Necessários

--Registrador de 4 bits
component registrador_4bits is
  port (
    clock:  in  std_logic;

    clear:  in  std_logic; --Limpa Registrador (coloca o valor em "0000")
    enable: in  std_logic; --Enable para Registrar um novo valor

    D:       in std_logic_vector(3 downto 0); --Valor que pode ser registrado
    Q:      out std_logic_vector(3 downto 0) --Valor atualmente registrado
  );
end component;

--Detector de Bordas de Subida
component edge_detector is
  port (
    clock  : in  std_logic;

    reset  : in  std_logic; --Reseta circuito
    sinal  : in  std_logic; --Sinal a ser analisado
    pulso  : out std_logic --Sinaliza quando o sinal muda
  );
end component;

--Sinais
signal or_sinais_jogada : std_logic;

begin

  --Registrador de 4 bits: Alocamento de Sinais
  reg_jogada: registrador_4bits port map(
    clock => clock,
    clear => limpaR,
    enable => registraR,
    D => botoes,
    Q => jogada
  );

  --Detector de Bordas de Subida: Alocamento de Sinais
  detect_jogada: edge_detector port map(
    clock => clock,
    reset => limpaR,
    sinal => or_sinais_jogada,
    pulso => tem_jogada
  );

  or_sinais_jogada <= botoes(0) or botoes(1) or botoes(2) or botoes(3);

end architecture;
