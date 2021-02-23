--Circuito Experiência 6 - Comparador de 4 bits

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;

--Entidade: Principal
entity comparador_85 is
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
end entity comparador_85;

architecture dataflow of comparador_85 is

  --Sinais internos: comparacoes destes bits apenas
  signal agtb : std_logic; --alto quando A > B
  signal aeqb : std_logic; --alto quando A = B
  signal altb : std_logic; --alto quando A < B

begin
  agtb <= (i_A3 and not(i_B3)) or --alto se A3 = '1' e B3 = '0' OU...
          (not(i_A3 xor i_B3) and i_A2 and not(i_B2)) or --alto se A3 = B3, A2 = '1' e B2 = '0' OU...
          (not(i_A3 xor i_B3) and not(i_A2 xor i_B2) and i_A1 and not(i_B1)) or --alto se A3 = B3, A2 = B2, A1 = '1' e B1 = '0' OU...
          (not(i_A3 xor i_B3) and not(i_A2 xor i_B2) and not(i_A1 xor i_B1) and i_A0 and not(i_B0)); --alto se A3 = B3, A2 = B2, A1 = B1 e A0 = '1' e B0 = '0'

  aeqb <= not((i_A3 xor i_B3) or (i_A2 xor i_B2) or (i_A1 xor i_B1) or (i_A0 xor i_B0)); --not (xor bit a bit):
                                                                                         --este sinal so sera alto se todos bits forem IGUAIS

  altb <= not(agtb or aeqb); --Se A NAO eh maior nem igual a B, A sera MENOR que B

  -- Saidas:
  --Usam o resultado da comparacao destes bits, mas caso A = B, checa informacoes vindas de bits menos significativos
  o_AGTB <= agtb or (aeqb and (not(i_AEQB) and not(i_ALTB)));
  o_ALTB <= altb or (aeqb and (not(i_AEQB) and not(i_AGTB)));
  o_AEQB <= aeqb and i_AEQB;

end architecture dataflow;
