library IEEE;
use IEEE.std_logic_1164.all;  

	
	entity status is 
		port
		(
			clk, reset, mode, end_g: in std_logic; -- pode reiniciar o estado atual ou escolher entre debug, config e jogar
			actual_status: out std_logic_vector(1 downto 0) := "10";
			reset_game: out std_logic
		);
		end status;
		
		architecture define_status of status is
		signal d_temp: std_logic_vector(1 downto 0) := "10";
		signal q_temp: std_logic_vector(1 downto 0) := "10"; 
		signal reset_game_temp,status_temp: std_logic;
			begin
				ffd_1: work.FlipFlopD port map (clk, d_temp(0), q_temp(0));
				ffd_2: work.FlipFlopD port map (clk, d_temp(1), q_temp(1));
				process(clk, mode, end_g, reset, d_temp, q_temp, reset_game_temp) -- mode, end_g, d_temp)
					begin
					if rising_edge(clk) then
	
						if q_temp = "00" and mode ='0' then -- config -> config
							d_temp <= "00";
							reset_game_temp <= '0';
						
						elsif q_temp = "00" and mode='1' then -- config -> playing
							d_temp <= "10";
							reset_game_temp <= '0';
						
						elsif q_temp = "10" and mode='0' then -- playing -> config
							d_temp <= "00";
							reset_game_temp <= '0';
						
						elsif q_temp = "10" and mode='1' and reset='1' then -- playing -> playing reset
							d_temp <= "10";
							reset_game_temp <= '0';
							
						elsif q_temp = "10" and mode='1' and end_g='1' then -- playing -> end
							d_temp <= "11";
							reset_game_temp <= '0';
						
						elsif q_temp="10" and mode='1' and end_g='0' and reset='0' then --  playing -> playing
							d_temp <= "10";
							reset_game_temp <= '0';
							
						elsif q_temp <= "11" and mode = '0' then -- win -> config
							d_temp <= "00";
							reset_game_temp <= '1';
						
						elsif q_temp <= "11" and mode = '1' then -- win -> win
							d_temp <= "11";
							reset_game_temp <= '0';
							
						elsif q_temp <= "11" and mode = '1' and reset='1' then -- win -> playing reset
							d_temp <= "00";
							reset_game_temp <= '1';
							end if;
						
					
						end if;
					actual_status <= q_temp;
					reset_game <= reset_game_temp;
				end process;
			end define_status;