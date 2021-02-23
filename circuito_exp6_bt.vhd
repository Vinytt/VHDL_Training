--Circuito Experiência 6 - Bancada de Testes

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade Principal
entity bancada_testes is
--Vazio
end entity;

architecture testes of bancada_testes is

--Importar DUT
component circuito_exp6 is
  port(
    clock :   in std_logic; --Clock geral

    reset :   in std_logic; --Resetar Funcionamento
    iniciar : in std_logic; --Iniciar Jogo

    botoes :  in std_logic_vector(3 downto 0); --Botões da Jogada

    leds :    out std_logic_vector(3 downto 0); --LEDs que representam a Jogada

    pronto :  out std_logic; --Fim de jogo
    acertou : out std_logic; --Acertou / Ganhou
    errou :   out std_logic; --Errou / Perdeu

    db_estado :  out std_logic_vector(6 downto 0);
    db_end :     out std_logic_vector(6 downto 0); --Debugging: endereço atual
    db_limite :  out std_logic_vector(6 downto 0); --Debugging: limite atual
    db_memoria : out std_logic_vector(6 downto 0) --Debugging dado acessado
  );
end component;

--Sinais
signal clock_in : std_logic;
signal reset_in : std_logic := '0';
signal iniciar_in : std_logic := '0';
signal botoes_in : std_logic_vector(3 downto 0) := "0000";
signal leds_out : std_logic_vector(3 downto 0);
signal pronto_out : std_logic;
signal acertou_out : std_logic;
signal errou_out : std_logic;

signal db_limite_out : std_logic_vector(6 downto 0);
signal db_end_out : std_logic_vector(6 downto 0);
signal db_memoria_out : std_logic_vector(6 downto 0);
signal db_estado_out : std_logic_vector(6 downto 0);

begin

  --Clock
  clk: process is
  begin
    clock_in <= '0';
    wait for 0.5 ns;
    clock_in <= '1';
    wait for 0.5 ns;
  end process;

  --Circuito Experiência 6: Alocamento de Sinais
  exp6 : circuito_exp6 port map(
    clock => clock_in,
    reset => reset_in,
    iniciar => iniciar_in,
    botoes => botoes_in,
    leds => leds_out,
    pronto => pronto_out,
    acertou => acertou_out,
    errou => errou_out,
    db_limite => db_limite_out,
    db_end => db_end_out,
    db_memoria => db_memoria_out,
    db_estado => db_estado_out
  );

  process
  begin

    --Prieiro Teste: Acertar Tudo

    --Estado Inicial
    reset_in <= '1';
    iniciar_in <= '0';
    botoes_in <= "0000";
    wait for 6.0 ns;
    assert (db_estado_out = "1000000")
    report "Falha no Teste Inicial 1 "
    severity error;

    --Iniciar
    reset_in <= '0';
    iniciar_in <= '1';
    botoes_in <= "0000";
    wait for 1.0 ns;
    assert (db_estado_out = "1111001" and db_end_out = "1000000" and db_limite_out = "1000000")
    report "Falha no Teste Iniciar 1 "
    severity error;

    --Estado C: Aguarda Jogada
    wait for 1.0 ns;
    assert (db_estado_out = "0100100" and db_end_out = "1000000" and db_limite_out = "1000000")
    report "Falha no Teste Aguardar jogada 1 "
    severity error;

    --Rodada 0, Jogada 0
    reset_in <= '0';
    iniciar_in <= '0';
    botoes_in <= "0001";
    wait for 6.0 ns;
    assert (db_limite_out = "1111001")
    report "Falha no Teste 0, 0 - 1 "
    severity error;

    --Rodada 1, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    reset_in <= '0';
    iniciar_in <= '0';
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 1, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    reset_in <= '0';
    iniciar_in <= '0';
    botoes_in <= "0010";
    wait for 6.0 ns;
    assert(db_limite_out = "0100100")
    report "Falha no Teste 1, 1 - 1"
    severity error;

    --Rodada 2, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 2, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 2, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    assert(db_limite_out = "0110000")
    report "Falha no Teste 2, 2 - 1"
    severity error;

    --Rodada 3, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 3, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 3, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 3, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    assert(db_limite_out = "0011001")
    report "Falha no Teste 3, 3 - 1"
    severity error;

    --Rodada 4, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 4, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 4, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 4, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 4, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    assert(db_limite_out = "0010010")
    report "Falha no Teste 4, 4 - 1"
    severity error;

    --Rodada 5, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 5, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 5, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 5, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 5, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 5, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    assert(db_limite_out = "0000010")
    report "Falha no Teste 5, 5 - 1"
    severity error;

    --Rodada 6, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 6, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 6, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 6, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 6, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 6, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 6, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    assert(db_limite_out = "1111000")
    report "Falha no Teste 6, 6 - 1"
    severity error;

    --Rodada 7, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 7, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 7, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 7, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 7, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 7, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 7, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 7, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    assert(db_limite_out = "0000000")
    report "Falha no Teste 7, 7 - 1"
    severity error;

    --Rodada 8, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 8, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 8, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 8, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 8, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 8, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 8, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 8, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 8, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    assert(db_limite_out = "0010000")
    report "Falha no Teste 8, 8 - 1"
    severity error;

    --Rodada 9, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 9, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 9, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 9, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 9, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 9, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 9, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 9, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 9, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 9, Jogada 9
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    assert(db_limite_out = "0001000")
    report "Falha no Teste 9, 9 - 1"
    severity error;

    --Rodada 10, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 10, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 10, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 10, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 10, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 10, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 10, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 10, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 10, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 10, Jogada 9
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 10, Jogada 10
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    assert(db_limite_out = "0000011")
    report "Falha no Teste 10, 10 - 1"
    severity error;

    --Rodada 11, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 11, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 11, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 11, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 11, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 11, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 11, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 11, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 11, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 11, Jogada 9
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 11, Jogada 10
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 11, Jogada 11
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    assert(db_limite_out = "1000110")
    report "Falha no Teste 11, 11 - 1"
    severity error;

    --Rodada 12, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 12, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 12, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 12, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 12, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 12, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 12, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 12, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 12, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 12, Jogada 9
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 12, Jogada 10
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 12, Jogada 11
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 12, Jogada 12
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    assert(db_limite_out = "0100001")
    report "Falha no Teste 12, 12 - 1"
    severity error;

    --Rodada 13, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 13, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 13, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 13, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 13, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 13, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 13, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 13, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 13, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 13, Jogada 9
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 13, Jogada 10
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 13, Jogada 11
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 13, Jogada 12
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 13, Jogada 13
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    assert(db_limite_out = "0000110")
    report "Falha no Teste 13, 13 - 1"
    severity error;

    --Rodada 14, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 14, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 14, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 14, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 14, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 14, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 14, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 14, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 14, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 14, Jogada 9
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 14, Jogada 10
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 14, Jogada 11
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 14, Jogada 12
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 14, Jogada 13
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 14, Jogada 14
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    assert(db_limite_out = "0001110")
    report "Falha no Teste 14, 14 - 1"
    severity error;

    --Rodada 15, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 15, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 15, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 15, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 15, Jogada 4
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 15, Jogada 5
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 15, Jogada 6
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 15, Jogada 7
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 15, Jogada 8
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 15, Jogada 9
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 15, Jogada 10
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 15, Jogada 11
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 15, Jogada 12
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 15, Jogada 13
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "1000";
    wait for 6.0 ns;
    --Rodada 15, Jogada 14
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 15, Jogada 15
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 9.0 ns;
    assert(db_estado_out = "0000010")
    report "Falha no Teste 15, 15 - 1"
    severity error;

    --Segundo Teste: Errar na Rodada 3, Jogada 3

    --Iniciar
    reset_in <= '0';
    iniciar_in <= '1';
    botoes_in <= "0000";
    wait for 1.0 ns;
    assert (db_estado_out = "1111001")
    report "Falha no Teste Iniciar 2 "
    severity error;

    --Estado C: Aguarda Jogada
    wait for 1.0 ns;
    assert (db_estado_out = "0100100"  and db_end_out = "1000000" and db_limite_out = "1000000")
    report "Falha no Teste Aguardar jogada 2 "
    severity error;

    --Rodada 0, Jogada 0
    reset_in <= '0';
    iniciar_in <= '0';
    botoes_in <= "0001";
    wait for 6.0 ns;
    assert (db_limite_out = "1111001")
    report "Falha no Teste 0, 0 - 2 "
    severity error;

    --Rodada 1, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    reset_in <= '0';
    iniciar_in <= '0';
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 1, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    reset_in <= '0';
    iniciar_in <= '0';
    botoes_in <= "0010";
    wait for 6.0 ns;
    assert(db_limite_out = "0100100")
    report "Falha no Teste 1, 1 - 2"
    severity error;

    --Rodada 2, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 2, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 2, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    assert(db_limite_out = "0110000")
    report "Falha no Teste 2, 2 - 2"
    severity error;

    --Rodada 3, Jogada 0
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0001";
    wait for 6.0 ns;
    --Rodada 3, Jogada 1
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 6.0 ns;
    --Rodada 3, Jogada 2
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0100";
    wait for 6.0 ns;
    --Rodada 3, Jogada 3
    botoes_in <= "0000";
    wait for 1.0 ns;
    botoes_in <= "0010";
    wait for 9.0 ns;
    assert(db_estado_out = "0010010")
    report "Falha no Teste Errou"
    severity error;

    reset_in <= '0';
    iniciar_in <= '0';
    botoes_in <= "0000";
    assert(False)
    report "Testes Finalizados"
    severity note;
    wait;

  end process;
end architecture;
