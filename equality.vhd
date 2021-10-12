library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity equal_1bit is
    Port ( A,B : in std_logic;
           Equality: out std_logic);
end equal_1bit;

architecture behav of equal_1bit is
  begin
   Equality <= A xnor B; -- diz se A e B são iguais usando um xnor
end behav;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity equal_4bits is
	Port( A, B: in std_logic_vector(3 downto 0);
				Equality: out std_logic);
		end equal_4bits;
	
	architecture behav of equal_4bits is
	signal equality_temp: std_logic_vector(3 downto 0);
	signal equality_result: std_logic;
	begin 
		e1: work.equal_1bit port map(A(0), B(0), equality_temp(0)); -- compara bit a bit
		e2: work.equal_1bit port map(A(1), B(1), equality_temp(1));
		e3: work.equal_1bit port map(A(2), B(2), equality_temp(2));
		e4: work.equal_1bit port map(A(3), B(3), equality_temp(3));
		process(equality_temp)
		begin
		if equality_temp="1111" then -- caso todos os bits sejam iguais, dá 1 como resposta, caso não, 0
			equality_result <= '1';
			else 
			equality_result <= '0';
			end if;
			end process;
		Equality <= equality_result;
	end behav;