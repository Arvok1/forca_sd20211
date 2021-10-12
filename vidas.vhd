library IEEE;
use IEEE.std_logic_1164.all;  
	
	entity vidas is
		port
		(
		clk: in std_logic;
		numeros_acertados: in std_logic_vector(3 downto 0);
		vidas: out std_logic_vector(3 downto 0) := "1111";
		lose: out std_logic
		);
		end vidas;
		
		architecture calcular_vidas of vidas is
		signal numeros_acertados_antigo: std_logic_vector(3 downto 0) := "0000";
		signal vida_antigo, vida_novo: std_logic_vector(3 downto 0) := "1111";
		signal equality, lose_temp : std_logic := '0';
			begin 
				registrador_1: work.registrador_4bits port map(clk, numeros_acertados, numeros_acertados_antigo);
				acertados_comparador: work.equal_4bits port map(numeros_acertados, numeros_acertados_antigo, equality);
				registrador_vidas: work.registrador_4bits port map(clk, vida_novo, vida_antigo);
				process (numeros_acertados)
				begin 
					if equality = '0' then 
						vida_novo <= vida_antigo;
						elsif equality = '1' then
							if vida_antigo = "1111" then
								vida_novo <= "0111";
								elsif vida_antigo = "0111" then
								vida_novo <= "0011";
								elsif vida_antigo = "0011" then
								vida_novo <= "0001";
								elsif vida_antigo = "0001" then
								vida_novo <= "0000";
								elsif vida_antigo = "0000" then
								lose_temp <= '0';
			
							
						
						end if;
					end if;
				vidas <= vida_antigo;
				lose <= lose_temp;
				end process;
			end calcular_vidas;
				