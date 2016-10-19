library IEEE;
use IEEE.std_logic_1164.all;
use iEEE.numeric_std.all;

-- Alunos: Adan Pereira Gomes e Wesley Mayk Gama Luz

entity contador_decrescente is
	generic (
		in_width	: positive := 4;
		out_width: positive := 4
	);
	port (
		clock, reset, enable: in std_logic;
		in_value : in std_logic_vector(in_width-1 downto 0);
		m0, m1	: out std_logic_vector(out_width-1 downto 0)
	);
end entity;

architecture FSM of contador_decrescente is
	type State is (init, count, sm0, sm1, zero);
	signal actualState, nextState: State;
	signal sn_m0, sn_m1: positive range 0 to 9; 
	signal tempo: positive range 0 to 59;
begin

	-- next state logic
	LPE: process(actualState, tempo, sn_m0, sn_m1) is
	begin
		nextState <= actualState;
		case actualState is
			when init =>
				nextState <= count;
			when count =>
				if tempo = 59 and sn_m1 /= 0 and sn_m0 /= 0 then
					nextState <= sm0;
				elsif  tempo = 59 and sn_m1 /= 0 and sn_m0 = 0 then
					nextState <= sm1;
				elsif tempo = 59 and sn_m1 = 0 and sn_m0 = 0 then
					nextState <= zero;
				end if;
			when sm0 =>
				nextState <= count;
			when sm1 =>
				nextState <= count;
		end case;
	end process;

	-- state element (memory)
	ME: process(clock, reset) is
	begin
		if reset = '0' then
			actualState <= init;
		elsif rising_edge(clock) then
			if enable = '1' then
				actualState <= nextState;
			end if;
		end if;
	end process;
	
	-- output-logic
	OL: process(actualState) is
	begin
		case actualState is
			when init =>
				tempo <= 0;
				sn_m0 <= 0;
				sn_m1 <= unsigned(in_value);
			when count =>
				tempo <= tempo + 1 ;
				sn_m0 <= 0;
				sn_m1 <= 0;
			when sm0 =>
				tempo <= 0 ;
				sn_m0 <= sn_m0 - 1;
				sn_m1 <= sn_m1;
			when sm1 =>
				tempo <= 0;
				sn_m0 <=  9;
				sn_m1 <= sn_m1 - 1;
		end case;
		m0 <= std_logic_vector(sn_m0);
		m1 <= std_logic_vector(sn_m1);
	end process;
	
end architecture; 
