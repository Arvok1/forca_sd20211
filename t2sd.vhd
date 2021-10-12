library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
-- V_sw(0) = modo de jogo, 0 mostra os números, 1 vc joga
-- v_sw(1) = durante o jogo, você pode resetar
-- para reiniciar o jogo quando tiver ganho, clique duas vezes em v_sw(0)

entity t2sd is
port (
	G_CLOCK_50: in std_logic; -- entrada de clock fornecida pela FPGA, permite usar clock
	V_SW: in std_logic_vector(17 downto 0); -- os 18 botões "liga-desliga" disponíveis
	KEY: in std_logic_vector(3 downto 0); -- os 4 botões "ligou desligou" disponíveis
	LEDR: out std_logic_vector(17 downto 0) := "000000000000000000"; -- os 18 leds disponíveis
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: out std_logic_vector(6 downto 0) -- os 8 displays 7seg
	
);
end t2sd;

architecture main of t2sd is
	
	signal user_guess : std_logic_vector (3 downto 0) := (others => '1'); -- sinal para receber a entrada do usuário
	signal win, lose, reset_game, reset_by_status: std_logic := '0'; -- condições de win/lose e reset(resetam o jogo no geral)
	signal actual_status: std_logic_vector(1 downto 0) := "00"; -- status atual do jogo, começa em 10, jogando
	signal decoded_number_temp, numeros_acertados_temp, vidas_def, vidas_temp: std_logic_vector(3 downto 0); -- número de entrada decoded, numeros acertados e vidas
	signal numero_secreto_temp: std_logic_vector(15 downto 0) := "0001001100110111"; -- número a ser descoberto, no caso 1337
	signal correct_disp0, correct_disp1, correct_disp2, correct_disp3, correct_disp4, correct_disp5, correct_disp6, correct_disp7: std_logic := '0'; -- mostra o que o display tem salvo se 1 ou não se 0
	signal display0_value, display1_value, display2_value, display3_value, display4_value, display5_value, display6_value, display7_value: std_logic_vector(3 downto 0); --valores para mostrar nos displays
	signal coded_number: std_logic_vector(17 downto 8);
	--a placa FPGA apresenta alta impedância nos displays dos números corretos, as vezes eles aparecem, as vezes não
	begin 
	status: work.status port map(G_CLOCK_50, reset_game, V_SW(0), win OR lose,actual_status, reset_by_status); -- máquina de estado dos status do jogo, tem entrada de reset e de "modo", que permite mudar pra "config" ou jogando
	
	numero_secreto: work.numero_secreto port map (G_CLOCK_50, numero_secreto_temp); -- permitiria a mudança do número secreto
	
	numero_entrada: work.decoder_botoes port map (G_CLOCK_50, coded_number, decoded_number_temp); -- decoder da entrada (de 9 a 0) para binário
	
	numeros_acertados: work.numeros_acertados port map (G_CLOCK_50, actual_status, reset_game, decoded_number_temp, numero_secreto_temp, numeros_acertados_temp, win); --clock, estado atual que vem de status, a entrada fornecida pelo usuário, o numero secreto(permitiria a mudança do mesmo, a saída de quantos números foram acertados e a condição de win, calculada no módulo
	
	vidas: work.vidas port map(G_CLOCK_50, numeros_acertados_temp, LEDR(3 DOWNTO 0), lose); --clock, os números acertados, que devem sair do módulo de números acertados, a saída de vidas disponíveis que vai direto pro led e a condição de lose, que é calculada direto no módulo
	
	
	--decoders dos displays
	DISPLAY_0: work.display_decoder port map(G_CLOCK_50, correct_disp0,  display0_value, HEX0);
	DISPLAY_1: work.display_decoder port map(G_CLOCK_50, correct_disp1, display1_value, HEX1);
	DISPLAY_2: work.display_decoder port map(G_CLOCK_50, correct_disp2, display2_value, HEX2);
	DISPLAY_3: work.display_decoder port map(G_CLOCK_50, correct_disp3, display3_value, HEX3);
	DISPLAY_4: work.display_decoder port map(G_CLOCK_50, correct_disp4, display4_value, HEX4);
	DISPLAY_5: work.display_decoder port map(G_CLOCK_50, correct_disp5, display5_value, HEX5);
	DISPLAY_6: work.display_decoder port map(G_CLOCK_50, correct_disp6, display6_value, HEX6);
	DISPLAY_7: work.display_decoder port map(G_CLOCK_50, correct_disp7, display7_value, HEX7);
	
	reset_game <= V_SW(1) or reset_by_status; -- condições assíncronas que resetariam o jogo
		
	process (G_CLOCK_50, win, lose, decoded_number_temp, numeros_acertados_temp, reset_game) begin
		if rising_edge(G_CLOCK_50) then 
			if actual_status = "11" then

			
				if win = '1' AND lose = '0' then
					display7_value <= "1100"; -- se ganhar, mostra G e liga o display 7
					correct_disp7 <= '1';
				elsif win='0' AND lose = '1' then
					display6_value <= "1011";
					correct_disp6 <= '1'; --  se perder, mostra P e liga o display 7
				elsif win='0' AND lose='0' then --não é pra entrar nesse caso, mas caso aconteça, desliga todos os displays menos o 0, pra mostrar erro
					correct_disp0 <= '0';
					correct_disp1 <= '0';
					correct_disp2 <= '0';
					correct_disp3 <= '0'; 
					correct_disp4 <= '0';
					correct_disp5 <= '0';
					correct_disp6 <= '0';
					correct_disp7 <= '0';
					end if;
					
			elsif actual_status = "00" then -- status de "config" ou debug, configura os valores a serem mostrados nos displays caso a pessoa acerte-os
					correct_disp0 <= '1'; -- o jogo inicia nesse modo, é preciso apertar V_SW(0) para mudar para modo jogo
					correct_disp1 <= '1';
					correct_disp2 <= '1';
					correct_disp3 <= '1'; 
					correct_disp4 <= '1';
					correct_disp5 <= '1';
					correct_disp6 <= '1';
					correct_disp7 <= '1';
				display0_value <= numero_secreto_temp(3 downto 0);
				display1_value <= numero_secreto_temp(7 downto 4);
				display2_value <= numero_secreto_temp(11 downto 8);
				display3_value <= numero_secreto_temp(15 downto 12);
				display4_value <= "1010";
				display5_value <= "1010";
				display6_value <= "1010";
				display7_value <= "1010";
				
			elsif actual_status = "10" then --  jogando
				coded_number <= V_SW(17 downto 8);
				correct_disp3 <= numeros_acertados_temp(3); -- só mostra o número se numeros_acertados tiver com '1' na casa equivalente, numeros_acertados vem do módulo números acertados
				correct_disp2 <= numeros_acertados_temp(2);
				correct_disp1 <= numeros_acertados_temp(1);
				correct_disp0 <= numeros_acertados_temp(0);
			
			end if;
			if reset_game = '1' then
				display0_value <= "1010"; -- feito para solucionar um problema de alto impedância que tava ocorrendo no display com o último número
				display1_value <= "1010";
				display2_value <= "1010";
				display3_value <= "1010";
			end if;
		end if;
					--display0_value_def <= display0_value; 
					--display1_value_def <= display1_value;
					--display2_value_def <= display2_value;
					--display3_value_def <= display3_value;
					--display4_value_def <= display4_value;
					--display5_value_def <= display5_value;
					--display6_value_def <= display6_value;
					--display7_value_def <= display7_value;
					--correct_disp0_def <= correct_disp0;
					--correct_disp1_def <= correct_disp1;
					--correct_disp2_def <= correct_disp2;
					--correct_disp3_def <= correct_disp3;
					--correct_disp4_def <= correct_disp4;
					--correct_disp5_def <= correct_disp5;
					--correct_disp6_def <= correct_disp6;
					--correct_disp7_def <= correct_disp7;
					
		end process;
		
	end main;
				
			
				-- não consegui pensar em uma maneira de implementar a mudança de número 
				
					