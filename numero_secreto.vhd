library IEEE;
use IEEE.std_logic_1164.all;

entity numero_secreto is 
				port 
				(
				clk: in std_logic; 
				numero_secreto: out std_logic_vector(15 downto 0) := "0001001100110111"
				);
				end numero_secreto;
			
		
		architecture behave of numero_secreto is
					signal numero1_temp, novonumero1_temp: std_logic_vector(3 downto 0) := "0001";
					signal numero2_temp, novonumero2_temp: std_logic_vector(3 downto 0) := "0011";
					signal numero3_temp, novonumero3_temp: std_logic_vector(3 downto 0) := "0011";
					signal numero4_temp, novonumero4_temp: std_logic_vector(3 downto 0) := "0111" ;
				begin 
					registrador_1: work.registrador_4bits port map(clk, novonumero1_temp, numero1_temp);
					registrador_2: work.registrador_4bits port map(clk, novonumero2_temp, numero2_temp);
					registrador_3: work.registrador_4bits port map(clk, novonumero3_temp, numero3_temp);
					registrador_4: work.registrador_4bits port map(clk, novonumero4_temp, numero4_temp);
					
				process(clk)
				begin
					
				 if rising_edge(clk) then 
				numero_secreto(15 downto 12) <= numero1_temp;
				numero_secreto(11 downto 8) <= numero2_temp;
				numero_secreto(7 downto 4) <= numero3_temp;
				numero_secreto(3 downto 0) <= numero4_temp;
				end if;
				end process;
				end behave;