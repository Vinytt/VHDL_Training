-- Circuito Experiência 6 - Sistema Digital

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade Principal
entity circuito_exp6 is
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
end entity;

architecture circuito_exp6_arch of circuito_exp6 is

--Componentes Necessários

--Fluxo de Dados
component fluxo_dados is
  port(
    clock : in std_logic;

    contaL :    in std_logic; --Enable do contador do Limite
    zeraL :     in std_logic; --Zera contador do Limite
    fimL :     out std_logic; --Limite final alcançado
    db_limite: out std_logic_vector(3 downto 0); --Debugging: Valor atual do Limmite

    contaE :  in std_logic; --Enable do contador de Endereços
    zeraE :   in std_logic; --Enable do contador de Endereços
    fimE :   out std_logic; --Endereço Final alcaçado
    db_end : out std_logic_vector(3 downto 0); --Debugging: Valor atual do Endreço

    botoes :      in std_logic_vector(3 downto 0); --Jogada
    registraR :   in std_logic; --Enable do registrador da jogada
    limpaR :      in std_logic; --Clear do registrador da jogada
    tem_jogada : out std_logic; --Uma nova jogada foi feita
    db_jogada :  out std_logic_vector(3 downto 0); --Debugging: Valor da Jogada

    escreve :     in std_logic; --Enable de escrita na memória ram
    db_memoria : out std_logic_vector(3 downto 0); --Debugging: Valor sendo acessado na Memória

    enderecoMenorOuIgualLimite : out std_logic; --Saída do comparador Limite-Endereço (me parece meio inútil)
    enderecoIgualLimite :        out std_logic; --Saída do comparador Limite-Endereço

    chavesIgualMemoria : out std_logic --Saída do comparador Botoes-Dado_Memoria
  );
end component;

--Unidade de Controle
component unidade_controle is
  port(
    clock : in std_logic;

    reset :                      in std_logic; --Reset o Circuito
    jogar :                      in std_logic; --Inicia o Circuito
    tem_jogada :                 in std_logic; --Uma nova Jogada foi feita
    igual :                      in std_logic; --Jogada é igual ao dado armazenado na memória
    fimE :                       in std_logic; --Atingiu Endereço final
    enderecoMenorOuIgualLimite : in std_logic; --End <= Lim
    enderecoIgualLimite :        in std_logic; --End == Lim

    contaE : out std_logic; --Enable do Contador de Endereços
    zeraE :  out std_logic; --Zera Contador de Endereços

    contaL : out std_logic; --Enable do Contador do Limite
    zeraL :  out std_logic; --Zera Contador do Limite

    registraR : out std_logic; --Enable do Registrador da Jogada
    limpaR :    out std_logic; --Limpa Registrador da Jogada

    pronto :  out std_logic; --Jogo Acabou
    errou :   out std_logic; --Erro / Perdeu
    acertou : out std_logic; --Acerto / Ganhou

    db_estado :  out std_logic_vector(3 downto 0) --Debugging: estado atual

  );
end component;

--Display de 7 Segmentos
component hexa7seg is
    port (
        hexa : in  std_logic_vector(3 downto 0); --Entrada: número representado em 4 bits
        sseg : out std_logic_vector(6 downto 0) --Saída: ativar segmentos no display (ativos em baixo)
    );
end component;

--Sinais
signal fimL : std_logic;
signal fimE : std_logic;
signal tem_jogada : std_logic;
signal endMenorIgual : std_logic;
signal endIgual : std_logic;
signal jogIgual : std_logic;
signal limite : std_logic_vector(3 downto 0);
signal endereco : std_logic_vector(3 downto 0);
signal jogada : std_logic_vector(3 downto 0);
signal memoria : std_logic_vector(3 downto 0);

signal contaE : std_logic;
signal zeraE : std_logic;
signal contaL : std_logic;
signal zeraL : std_logic;
signal registraR : std_logic;
signal limpaR : std_logic;
signal estado : std_logic_vector(3 downto 0);

  begin

    --Fluxo de Dados: Alocamento de Sinais
    fd : fluxo_dados port map(
      clock => clock,
      contaL => contaL,
      zeraL => zeraL,
      fimL => fimL,
      db_limite => limite,
      contaE => contaE,
      zeraE => zeraE,
      fimE => fimE,
      db_end => endereco,
      botoes => botoes,
      registraR => registraR,
      limpaR => limpaR,
      tem_jogada => tem_jogada,
      db_jogada => jogada,
      escreve => '1',
      db_memoria => memoria,
      enderecoMenorOuIgualLimite => endMenorIgual,
      enderecoIgualLimite => endIgual,
      chavesIgualMemoria => jogIgual
    );

    leds <= jogada;

    --Unidade de Controle: Alocamento de Sinais
    uc : unidade_controle port map(
      clock => clock,
      reset => reset,
      jogar => iniciar,
      tem_jogada => tem_jogada,
      igual => jogIgual,
      fimE => fimE,
      enderecoMenorOuIgualLimite => endMenorIgual,
      enderecoIgualLimite => endIgual,
      contaE => contaE,
      zeraE => zeraE,
      contaL => contaL,
      zeraL => zeraL,
      registraR => registraR,
      limpaR => limpaR,
      pronto => pronto,
      errou => errou,
      acertou => acertou,
      db_estado => estado
    );

    --Display Memória: Alocamento de Sinais
    mem_dis : hexa7seg port map(
      hexa => memoria,
      sseg => db_memoria
    );

    --Display Estado: Alocamento de Sinais
    est_dis : hexa7seg port map(
      hexa => estado,
      sseg => db_estado
    );

    --Display Endereço: Alocamento de Sinais
    end_dis : hexa7seg port map(
      hexa => endereco,
      sseg => db_end
    );

    --Display Limite: Alocamento de sinais
    lim_dis : hexa7seg port map(
      hexa => limite,
      sseg => db_limite
    );

end architecture;
