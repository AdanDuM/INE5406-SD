library IEEE;
use IEEE.std_logic_1164.all;

entity compara_zero_8bits is
	generic (N: integer := 10);
	port (
		in_0,in_1: in std_logic_vector((N - 1) downto 0);
		out_0: out std_logic
	);
end entity;

architecture circuito of compara_zero_8bits is
begin

	compara_zero_8bits <= (
		(in_0(0) xnor in_1(0)) and
		(in_0(1) xnor in_1(1)) and
		(in_0(2) xnor in_1(2)) and
		(in_0(3) xnor in_1(3)) and
		(in_0(4) xnor in_1(4)) and
		(in_0(5) xnor in_1(5)) and
		(in_0(6) xnor in_1(6)) and
		(in_0(7) xnor in_1(7))
	);
	
end architecture;
