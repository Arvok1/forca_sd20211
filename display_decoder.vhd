library ieee;
use ieee.std_logic_1164.all;


entity display_decoder is 
port(
	CLK, CORRECT :   in std_logic := '1';
	--universal, para funcionar em todos os displays da FPGA
    VALUE_TO_SHOW : in std_logic_vector (3 DOWNTO 0) := (others => '1'); -- entrada que diz qual valor precisa sair direto pro display
    
    DECODED_FOR_DISPLAY : out std_logic_vector (6 downto 0) -- saída já pronta pro display
);
end display_decoder;

ARCHITECTURE decoder of display_decoder is -- o led da FPGA ativa em valor baixo(display anodo comum)
signal DISPLAY_TEMP: std_logic_vector(0 to 6);
begin	
		
		with VALUE_TO_SHOW select 
		 DISPLAY_TEMP <=  "1000000" when "0000",  --0
						 
						 "1111001" when  "0001",  --1
						 
						 "0100100" when "0010", --2
						 
						 "0110000" when "0011",  --3 
						  
						 "0011001" when "0100",  --4 
						 
						 "0010010" when "0101",  --5
						 
						 "0000010" when "0110", --6
						 
						 "1111000" when "0111",  --7
						 
						 "0000000" when "1000", --8
						 
						 "0001100" when  "1001",  --9
						 
						 "0111111" when "1010",  -- - para esconder números 
						 
						 "0000010" when "1011",  -- G
						 
						 "0010100" when "1100",-- P
						 
						 "1111111" when "1111",
						 
					  
						 "0011000" when others; -- representa um E, mostrando que há algo de errado.
						 
						 process(clk, CORRECT, DISPLAY_TEMP)
						 begin 
						 if rising_edge(clk) then
							if CORRECT = '1' then -- se a entrada "correct" for 1, mostra o valor da entrada, caso seja 0, "desliga o display"
								DECODED_FOR_DISPLAY <= DISPLAY_TEMP;
							elsif CORRECT = '0' then 
								DECODED_FOR_DISPLAY <= "1111111";
							end if;
						end if;
						end process;
						
end decoder;



