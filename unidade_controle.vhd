--Circuito Experiência 6 - Unidade de Controle

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade Principal
entity unidade_controle is
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

    db_estado: out std_logic_vector(3 downto 0) --Debugging: estado atual

  );
end entity;

architecture unidade_controle_arch of unidade_controle is

--Tipos
type estado is (A, B, C, D, E, F, G, H, I, J);

--Sinais
signal estado_atual : estado := A;
signal prox_estado : estado;

begin

  process(clock, reset)
  begin
    if reset='1' then
      estado_atual <= A;
    elsif clock'event and clock = '1' then
      estado_atual <= prox_estado;
    end if;
  end process;

  --Lógica de Próximo Estado
  prox_estado <=
    --A: estado inicial
    A when (estado_atual = A and jogar = '0') else
    B when (estado_atual = A and jogar = '1') else

    --B:
    C when (estado_atual = B) else

    --C:
    C when (estado_atual = C and tem_jogada = '0' and reset = '0') else
    D when (estado_atual = C and tem_jogada = '1' and reset = '0') else
    B when (estado_atual = C and reset = '1') else

    --D:
    E when (estado_atual = D and reset = '0') else
    B when (estado_atual = D and reset = '1') else

    --E:
    F when (estado_atual = E and igual = '0' and reset = '0') else
    G when (estado_atual = E and igual = '1' and fimE = '1' and reset = '0') else
    H when (estado_atual = E and igual = '1' and fimE = '0' and reset = '0') else
    B when (estado_atual = E and reset = '1') else

    --F:
    F when (estado_atual = F and jogar = '0' and reset = '0') else
    B when (estado_atual = F and (jogar = '1' or reset = '1')) else


    --G:
    G when (estado_atual = G and jogar = '0' and reset = '0') else
    B when (estado_atual = G and (jogar = '1' or reset = '1')) else

    --H:
    I when (estado_atual = H and enderecoMenorOuIgualLimite = '1' and enderecoIgualLimite = '0' and reset = '0') else
    J when (estado_atual = H and enderecoMenorOuIgualLimite = '1' and enderecoIgualLimite = '1' and reset = '0') else
    B when (estado_atual = H and reset = '1') else

    --I:
    C when (estado_atual = I and reset = '0') else
    B when (estado_atual = I and reset = '1') else

    --J:
    C when (estado_atual = J and reset = '0') else
    B when (estado_atual = J and reset = '1') else

    A;

  --Lógica de Saída

  --Enable Contador de Endereços
  with estado_atual select
    contaE <= '0' when A | B | C | D | E | F | G | H | J,
              '1' when I,
              '0' when others;

  --Zera Contador de Endereços
  with estado_atual select
    zeraE <= '0' when A | C | D | E | F | G | H | I,
             '1' when B | J,
             '0' when others;

  --Enable Contador do Limite
  with estado_atual select
    contaL <= '0' when A | B | C | D | E | F | G | H | I,
              '1' when J,
              '0' when others;

  --Zera Contador do Limite
  with estado_atual select
    zeraL <= '0' when A | C | D | E | F | G | H | I | J,
             '1' when B,
             '0' when others;

  --Enable do Registrador da Jogada
  with estado_atual select
    registraR <= '0' when A | B | C | E | F | G | H | I,
                 '1' when D,
                 '0' when others;

   --Limpa Registrador da Jogada
   with estado_atual select
    limpaR <= '0' when A | C | D | E | F | G | H | I | J,
              '1' when B,
              '0' when others;

   --Jogo Acabou
   with estado_atual select
    pronto <= '0' when A | B | C | D | E | H | I | J,
              '1' when F | G,
              '0' when others;

   --Acertou
   with estado_atual select
    acertou <= '0' when A | B | C | D | E | F | H | I | J,
               '1' when G,
               '0' when others;

   --Errou
   with estado_atual select
    errou <= '0' when A | B | C | D | E | G | H | I | J,
             '1' when F,
             '0' when others;

   --Debugging
   with estado_atual select
    db_estado <= "0000" when A,
                 "0001" when B,
                 "0010" when C,
                 "0011" when D,
                 "0100" when E,
                 "0101" when F,
                 "0110" when G,
                 "0111" when H,
                 "1000" when I,
                 "1001" when J,
                 "0000" when others;

end architecture;
