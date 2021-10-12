	
library IEEE;
use IEEE.std_logic_1164.all;  
	
	entity numeros_acertados is
		port
		(
		clk: in std_logic;
		mode: in std_logic_vector(1 downto 0);
		reset: in std_logic;
		new_entry: in std_logic_vector(3 downto 0);
		numero_secreto: in std_logic_vector(15 downto 0) := "0001001100110111";
		numeros_acertados: out std_logic_vector(3 downto 0);
		win: out std_logic
		);
		end numeros_acertados;
		
						
		architecture behave of numeros_acertados is
		signal equality_temp, equality, d_temp, q_temp: std_logic_vector(3 downto 0) := "0000";
		signal win_temp: std_logic := '0';
		begin
					numero_1_comparador: work.equal_4bits port map(new_entry, numero_secreto(15 downto 12), equality_temp(3));
					numero_2_comparador: work.equal_4bits port map(new_entry, numero_secreto(11 downto 8), equality_temp(2));
					numero_3_comparador: work.equal_4bits port map(new_entry, numero_secreto(7 downto 4), equality_temp(1));
					numero_4_comparador: work.equal_4bits port map(new_entry, numero_secreto(3 downto 0), equality_temp(0));
					ffd_1: work.FlipFlopD port map (clk, d_temp(0), q_temp(0));
					ffd_2: work.FlipFlopD port map (clk, d_temp(1), q_temp(1));
					ffd_3: work.FlipFlopD port map (clk, d_temp(2), q_temp(2));
					ffd_4: work.FlipFlopD port map (clk, d_temp(3), q_temp(3));
					
					process(clk, q_temp, d_temp, mode, reset) 
					begin 
					if rising_edge(clk) then 
						if q_temp(3) = '0' then 
							d_temp(3) <= equality_temp(3);
							else	
							d_temp(3) <= q_temp(3);
							end if;
							
						if q_temp(2) = '0' then
							d_temp(2) <= equality_temp(2);
							else	
							d_temp(2) <= q_temp(2);
							end if;
							
						if q_temp(1) = '0' then 
							d_temp(1) <= equality_temp(1);
							else	
							d_temp(1) <= q_temp(1);
							end if;
							
						if q_temp(0) = '0' then 
							d_temp(0) <= equality_temp(0);
							else	
							d_temp(0) <= q_temp(0);
							end if;	
							
						if d_temp = "1111" then
							win_temp <= '1';
							else 
							win_temp <= '0';
							end if;
						
						if mode = "00" or reset = '1' then
							d_temp <= "0000";
							end if;
						
						if mode="11" and reset='1' then
							d_temp <= "0000";
							end if;
							
						
					end if;	
					numeros_acertados <=q_temp;
					win <= win_temp;
					end process;
				end behave;