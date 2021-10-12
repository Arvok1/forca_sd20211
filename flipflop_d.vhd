library IEEE;
use IEEE.std_logic_1164.all;  

   entity FlipFlopD is
     port
     (
       clk, d: in std_logic;
       q: out std_logic
      );
     end FlipFlopD;
	  
   architecture FFD of FlipFlopD is
     begin
		  process(clk, d)
			begin
			  if rising_edge(clk) then --rising_edge é uma função do próprio vhdl
			  q <= d; -- a saida vaí receber o que tiver em d toda vez que o clock subir pra nível alto
			  end if;
		  end process;
   end FFD;

								
			
				