library ieee;
use ieee.std_logic_1164.all;


entity decoder_botoes is
port(
    
    clk :   in std_logic;
    
    botoes   :   in std_logic_vector (9 downto 0);
	 
    
    numero_decodificado  :   out std_logic_vector (3 downto 0)

);
end decoder_botoes;


	architecture decodificar of decoder_botoes is
begin

    process (botoes) begin
        
        case botoes is
        
            when "0000000001" =>
                numero_decodificado <= "0000";
        
        
            when "0000000010" =>
                numero_decodificado <= "0001";
        
        
            when "0000000100" =>
                numero_decodificado <= "0010";
        
        
            when "0000001000" =>
                numero_decodificado <= "0011";
        
        
            when "0000010000" =>
                numero_decodificado <= "0100";
        
        
            when "0000100000" =>
                numero_decodificado <= "0101";
        
        
            when "0001000000" =>
                numero_decodificado <= "0110";
        
        
            when "0010000000" =>
                numero_decodificado <= "0111";
        
        
            when "0100000000" =>
                numero_decodificado <= "1000";
        
        
            when "1000000000" =>
                numero_decodificado <= "1001";
        
        
            when others =>
                numero_decodificado <= "1111"; -- vai mostrar o E do erro nos displays
            
        end case;
    end process;
    
end decodificar;
