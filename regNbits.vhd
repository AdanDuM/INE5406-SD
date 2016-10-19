library IEEE;
use IEEE.std_logic_1164.all;

-- Alunos: Adan Pereira Gomes e Wesley Mayk Gama Luz

entity regNbits is
	generic (N: positive := 5);
	port (
		clock, reset, enable: in std_logic;
		data: in std_logic_vector((N - 1) downto 0);
		Q: out std_logic_vector((N - 1) downto 0)
	);
end entity;

architecture circuito of regNbits is
begin

	REG : process (clock, reset)
	begin
		if reset = '0' then
			Q <= (others => '0');
		elsif rising_edge(clock) then
			if enable = '1' then
				Q <= data;
			end if;
		end if;
	end process;
	
end architecture;
