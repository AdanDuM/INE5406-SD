library IEEE;
use IEEE.std_logic_1164.all;
use iEEE.numeric_std.all;

-- Alunos: Adan Pereira Gomes e Wesley Mayk Gama Luz

entity timer_2sec is
	port (
		clock, reset: in std_logic;
		time_out	: out std_logic
	);
end entity;

architecture sequencial of timer_2sec is
	type State is (init, count, sm0, sm1, zero);
	signal actualState, nextState: State;
	signal tempo: positive range 0 to 5;
begin

	-- next state logic
	LPE: process(actualState, tempo, sn_m0, sn_m1) is
	begin
		nextState <= actualState;
		case actualState is
			when init =>
				nextState <= count;
			when count =>
				if tempo = 2 then
					nextState <= zero;
				end if;
			when zero =>
				nextState <= actualState;
		end case;
	end process;

	-- state element (memory)
	ME: process (clock, reset)
	begin
		if reset = '0' then
			actualState <= init;
		elsif rising_edge(clock) then
			actualState <= nextState;
		end if;
	end process;
	
	-- output-logic
	OL: process(actualState) is
	begin
		case actualState is
			when init =>
				tempo <= 0;
				time_out <= 0;
			when count =>
				tempo <= tempo + 1 ;
				zero  <= 0;
			when zero =>
				tempo <= tempo;
				zero  <= 1;
			
		end case;
	end process;
	
end architecture; 
