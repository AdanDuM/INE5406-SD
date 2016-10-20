library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Alunos: Adan Pereira Gomes e Wesley Mayk Gama Luz

entity washing_machine is
	generic (
		sr_width : positive := 2 	-- state register width (motor_state)
	--	address_width : positive := 2
	);
	port (
		clock, reset: in std_logic;
		-- interface externa
		on_button, sensor_cover, 		-- sensor signals
		zero_minute, zero_seconds, 	-- timer flags
		empty, full : in std_logic; 	-- filled flags
		motor_state_in : in std_logic_vector(sr_width-1 downto 0); 		-- motor state register input
		motor_state_out: out std_logic_vector(sr_width-1 downto 0); 	-- motor state register output
		motor_state_en, 						-- motor state register enable
		water_pump_in, water_pump_out, 	-- pump control signals
		rotate_motor_l, rotate_motor_r, 	-- motor control signals
		led_waiting, led_soak, led_wash, led_spin, led_ready, -- led info
		timer_reset: out std_logic
		-- interface com barramento
		--writeE, readE: in std_logic;
		--address : in std_logic_vector(address_width-1 downto 0);
		--writeData: in std_logic_vector(7 downto 0);
		--readData: out std_logic_vector(7 downto 0)
	);
end entity;

architecture BC of washing_machine is
	type State is (waiting, wash, soak, spin, drain, fill, paused, rotate_l, rotate_r, ready);
	signal actualState, nextState: State;
begin

	-- next-state logic
	LPE: process(actualState, motor_state_en, on_button, sensor_cover, zero_minute, zero_seconds, empty, full) is
	begin
		nextState <= actualState;
		case actualState is
			when waiting =>
				if on_button = '1' then
					nextState <= wash;
				end if;
			when wash => 
				if full = '0' then
					nextState <= fill;
				else
					nextState <= paused;
				end if;
			when soak =>
				if zero_minute = '1' then
					nextState <= spin;
				end if;
			when spin =>
				if empty = '0' then
					nextState <= drain;
				end if;
			when drain =>
				if empty = '1' then
					nextState <= spin;
				end if;
			when fill =>
				if full = '1' then
					nextState <= wash;
				end if;
			when paused =>
				if motor_state_in = "01" and zero_minute = '0' and zero_seconds = '1' then
					nextState <= rotate_r;
				elsif motor_state_in = "10" and zero_minute = '0' and zero_seconds = '1' then
					nextState <= rotate_l;
				elsif zero_minute = '1' then
					nextState <= wash;
				end if;
			when rotate_l =>
				if zero_seconds = '1' then
					nextState <= paused;
				end if;
			when rotate_r =>
				if zero_seconds = '1' then
					nextState <= paused;
				end if;
			when ready =>
				if on_button = '1' or sensor_cover = '0' then
					nextState <= waiting;
				end if;
		end case;
	end process;
	
	-- state element (memory)
	ME: process(clock, reset) is
	begin
		if reset = '1' then
			actualState <= waiting;
		elsif rising_edge(clock) then
			actualState <= nextState;
		end if;
	end process;
	
	-- output-logic
	OL: process(actualState) is
	begin
		case actualState is
			when waiting =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in 	<= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '1';
				led_soak 	<= '0';
				led_wash 	<= '0';
				led_spin 	<= '0';
				led_ready 	<= '0';
			when wash =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in  <= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '1';
				led_spin 	<= '0';
				led_ready 	<= '0';
			when soak =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in  <= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '1';
				led_wash 	<= '0';
				led_spin 	<= '0'; 
				led_ready 	<= '0';
			when spin =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in  <= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '1';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '0';
				led_spin 	<= '1';
				led_ready 	<= '0';
			when drain =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in  <= '0';
				water_pump_out <= '1';
				rotate_motor_l <= '0';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '0';
				led_spin 	<= '1';
				led_ready 	<= '0';
			when fill =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in  <= '1';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '1';
				led_spin 	<= '0';
				led_ready 	<= '0';
			when paused =>
				timer_reset <= '1';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in 	<= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '1';
				led_spin 	<= '0';
				led_ready 	<= '0';
			when rotate_l =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '1';
				motor_state_out <= "10";
				-- motor and pump
				water_pump_in 	<= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '1';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '1';
				led_spin 	<= '0'; 
				led_ready 	<= '0';
			when rotate_r =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '1';
				motor_state_out <= "01";
				-- motor and pump
				water_pump_in 	<= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '1';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '1';
				led_spin 	<= '0';
				led_ready 	<= '0';
			when ready =>
				timer_reset <= '0';
				-- motor state register
				motor_state_en  <= '0';
				motor_state_out <= (others => '0');
				-- motor and pump
				water_pump_in 	<= '0';
				water_pump_out <= '0';
				rotate_motor_l <= '0';
				rotate_motor_r <= '0';
				-- led info
				led_waiting <= '0';
				led_soak 	<= '0';
				led_wash 	<= '0';
				led_spin 	<= '0';
				led_ready 	<= '1';
		end case;
	end process;
end architecture;
