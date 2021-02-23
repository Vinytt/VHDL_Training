--Circuito Experiência 6 - Memória RAM 16x4

--Bibliotecas Necessárias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Entidade Principal
entity ram_16x4 is
   port (
       clk          :  in std_logic;

       endereco     :  in std_logic_vector(3 downto 0); -- Endereço a ser acessado na memória
       dado_entrada :  in std_logic_vector(3 downto 0); --Dado que pode ser escrito na memória

       we           :  in std_logic; --Enable da escrita na memória (ATIVO EM BAIXO)
       ce           :  in std_logic; --Enable da escrita na memória (ATIVO EM BAIXO)

       dado_saida   : out std_logic_vector(3 downto 0) --Dado no endereço acessado
    );
end entity ram_16x4;

architecture ram_mif of ram_16x4 is
  type   arranjo_memoria is array(0 to 15) of std_logic_vector(3 downto 0);
  signal memoria : arranjo_memoria;

  -- Configuracao do Arquivo MIF
  attribute ram_init_file: string;
  attribute ram_init_file of memoria: signal is "ram_conteudo_jogadas.mif";

begin

  process(clk)
  begin
    if (clk = '1' and clk'event) then
          if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"

              -- Detecta ativacao de we (ativo baixo)
              if (we = '0')
                  then memoria(to_integer(unsigned(endereco))) <= dado_entrada;
              end if;

          end if;
      end if;
  end process;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));

end architecture ram_mif;

-- Dados iniciais (para simulacao com Modelsim)
architecture ram_modelsim of ram_16x4 is
  type   arranjo_memoria is array(0 to 15) of std_logic_vector(3 downto 0);
  signal memoria : arranjo_memoria := (
                                        "0001",
                                        "0010",
                                        "0100",
                                        "1000",
                                        "0100",
                                        "0010",
                                        "0001",
                                        "0001",
                                        "0010",
                                        "0010",
                                        "0100",
                                        "0100",
                                        "1000",
                                        "1000",
                                        "0001",
                                        "0100" );

begin

  process(clk)
  begin
    if (clk = '1' and clk'event) then
          if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"

              -- Detecta ativacao de we (ativo baixo)
              if (we = '0')
                  then memoria(to_integer(unsigned(endereco))) <= dado_entrada;
              end if;

          end if;
      end if;
  end process;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));

end architecture ram_modelsim;
