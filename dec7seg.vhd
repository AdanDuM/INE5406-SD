library IEEE;
use IEEE.std_logic_1164.all;

-- Alunos: Adan Pereira Gomes e Wesley Mayk Gama Luz

entity dec7seg is
	port (
		E: in std_logic_vector(4 downto 0);
		O: out std_logic_vector(6 downto 0)
	);
end entity;

architecture structural of dec7seg is
begin

	O <=	"1000000" when E = "00000" else -- 0
			"1111001" when E = "00001" else -- 1
			"0100100" when E = "00010" else -- 2
			"0110000" when E = "00011" else -- 3
			"0011001" when E = "00100" else -- 4
			"0010010" when E = "00101" else -- 5
			"0000010" when E = "00110" else -- 6
			"1111000" when E = "00111" else -- 7
			"0000000" when E = "01000" else -- 8
			"0010000" when E = "01001";	  -- 9
			
end architecture;