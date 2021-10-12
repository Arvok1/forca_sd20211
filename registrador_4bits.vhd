library IEEE;
use IEEE.std_logic_1164.all;  

	entity registrador_4bits is 
		port
		(
			clk: in std_logic := '0';
			d: in std_logic_vector(3 downto 0) := "0000"; 
			q: out std_logic_vector(3 downto 0)
		);
		end registrador_4bits;
		
		architecture registrar of registrador_4bits is
		signal d_temp, q_temp: std_logic_vector(3 downto 0);
		begin
			ffd_1: work.FlipFlopD port map (clk, d(0), q(0));
			ffd_2: work.FlipFlopD port map (clk, d(1), q(1));
			ffd_3: work.FlipFlopD port map (clk, d(2), q(2));
			ffd_4: work.FlipFlopD port map (clk, d(3), q(3));
	end registrar;
				