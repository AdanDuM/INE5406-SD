library IEEE;
use IEEE.std_logic_1164.all;

-- Alunos: Adan Pereira Gomes e Wesley Mayk Gama Luz

entity dec7seg is
	port (
		bcd_in: in std_logic_vector(3 downto 0);
		dec_out: out std_logic_vector(6 downto 0)
	);
end entity;

architecture structural of dec7seg is
begin

	dec_out <=	"1000000" when bcd_in = "0000" else -- 0
					"1111001" when bcd_in = "0001" else -- 1
					"0100100" when bcd_in = "0010" else -- 2
					"0110000" when bcd_in = "0011" else -- 3
					"0011001" when bcd_in = "0100" else -- 4
					"0010010" when bcd_in = "0101" else -- 5
					"0000010" when bcd_in = "0110" else -- 6
					"1111000" when bcd_in = "0111" else -- 7
					"0000000" when bcd_in = "1000" else -- 8
					"0010000" when bcd_in = "1001" else -- 9
					"0000110";									-- E - Error
			
end architecture;
