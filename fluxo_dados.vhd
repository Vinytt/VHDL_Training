--Circuito Experiência 6 - Fluxo de Dados

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade Principal
entity fluxo_dados is
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
end entity;

architecture fluxo_dados_arch of fluxo_dados is

--Componentes Necessários

--Contador de 4 bits
component contador_163 is
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
end component;

--Comparador de 4 bits
component comparador_85 is
  port (
    --Primeira palavra binária
    i_A3   : in  std_logic; --bit mais significativo
    i_A2   : in  std_logic;
    i_A1   : in  std_logic;
    i_A0   : in  std_logic;

    --Segunda palavra binária
    i_B3   : in  std_logic; --bit mais significativo
    i_B2   : in  std_logic;
    i_B1   : in  std_logic;
    i_B0   : in  std_logic;

    --Informacoes de comparacoes nos bits menos signficativos (no caso de cascateamento)
    i_AGTB : in  std_logic; --A maior que B
    i_ALTB : in  std_logic; --A menor que B
    i_AEQB : in  std_logic; --A igual a B

    --Saidas: resultados da comparacao destes bits
    o_AGTB : out std_logic; --A maior que B
    o_ALTB : out std_logic; --A menor que B
    o_AEQB : out std_logic  --A igual a B
  );
end component comparador_85;

--Memória RAM 16x4
component ram_16x4 is
   port (
       clk          :  in std_logic;

       endereco     :  in std_logic_vector(3 downto 0); -- Endereço a ser acessado na memória
       dado_entrada :  in std_logic_vector(3 downto 0); --Dado que pode ser escrito na memória

       we           :  in std_logic; --Enable da escrita na memória (ATIVO EM BAIXO)
       ce           :  in std_logic; --Enable da escrita na memória (ATIVO EM BAIXO)

       dado_saida   : out std_logic_vector(3 downto 0) --Dado no endereço acessado
    );
end component ram_16x4;

--Gerenciador da Jogada
component gen_jogada is
  port(
    clock : in std_logic;

    registraR : in std_logic; --Enable do registrador
    limpaR : in std_logic; --Limpa registrador

    botoes : in std_logic_vector(3 downto 0); --Input da jogada
    jogada : out std_logic_vector(3 downto 0); --Jogada registrada

    tem_jogada : out std_logic --Indica que uma nova jogada foi feita
  );
end component;

--Sinais
signal not_ZeraE : std_logic;
signal saida_end : std_logic_vector(3 downto 0);

signal not_ZeraL : std_logic;
signal saida_lim : std_logic_vector(3 downto 0);

signal endMenor : std_logic;
signal endMaior : std_logic;
signal endIgual : std_logic;

signal jogada : std_logic_vector(3 downto 0);

signal saida_mem : std_logic_vector(3 downto 0);

signal jogMenor : std_logic;
signal jogMaior : std_logic;

begin

  --Contador de Endereços: Alocamento de Sinais
  cont_end : contador_163 port map(
    clock => clock,
    clr => not_ZeraE,
    ld => '1',
    ent => '1',
    enp => contaE,
    D => "0000",
    Q => saida_end,
    rco => fimE
  );

  not_ZeraE <= not zeraE;
  db_end <= saida_end;

  --Contador do Limite: Alocamento de Sinais
  cont_lim : contador_163 port map(
    clock => clock,
    clr => not_ZeraL,
    ld => '1',
    ent => '1',
    enp => contaL,
    D => "0000",
    Q => saida_lim,
    rco => fimL
  );

  not_ZeraL <= not ZeraL;
  db_limite <= saida_lim;

  --Comparador Limite-Endereço: Alocamento de Sinais
  comp_lim_end : comparador_85 port map(
    i_A3 => saida_lim(3),
    i_A2 => saida_lim(2),
    i_A1 => saida_lim(1),
    i_A0 => saida_lim(0),
    i_B3 => saida_end(3),
    i_B2 => saida_end(2),
    i_B1 => saida_end(1),
    i_B0 => saida_end(0),
    i_AGTB => '0',
    i_ALTB => '0',
    i_AEQB => '1',
    o_AGTB => endMenor,
    o_ALTB => endMaior,
    o_AEQB => endIgual
  );

  enderecoMenorOuIgualLimite <= endMenor or endIgual;
  enderecoIgualLimite <= endIgual;

  --Gerenciador da Jogada: Alocamento de Sinais
  gen_jog : gen_jogada port map(
    clock => clock,
    registraR => registraR,
    limpaR => limpaR,
    botoes => botoes,
    jogada => jogada,
    tem_jogada => tem_jogada
  );

  --Memória RAM : Alocamente de Sinais
  mem : ram_16x4 port map(
    clk => clock,
    endereco => saida_end,
    dado_entrada => jogada,
    we => escreve,
    ce => '0',
    dado_saida => saida_mem
  );

  db_memoria <= saida_mem;

  --Comparador Botoes-Dado-Memoria: Alocamento de Sinais
  comp_bot_mem : comparador_85 port map(
    i_A3 => saida_mem(3),
    i_A2 => saida_mem(2),
    i_A1 => saida_mem(1),
    i_A0 => saida_mem(0),
    i_B3 => jogada(3),
    i_B2 => jogada(2),
    i_B1 => jogada(1),
    i_B0 => jogada(0),
    i_AGTB => '0',
    i_ALTB => '0',
    i_AEQB => '1',
    o_AGTB => jogMenor,
    o_ALTB => jogMaior,
    o_AEQB => chavesIgualMemoria
  );

end architecture;
