note
	description: "Summary description for {ELEVATOR_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ELEVATOR_MODEL
inherit
	SUBJECT
create
	make

feature {ANY} -- state
		--Motor Direction: 0=stop, 1=up, -1=down
	motor: INTEGER
		--Mode: 0=resting, 1=ascending, 2=descending
	mode: INTEGER
		--Door Status: false=closed, true=open
	doors_open: BOOLEAN
		--Floor: current floor #
	floor: INTEGER
		--Max floor: highest floor in building
	max_floor: INTEGER

feature {ANY} -- constants

	--Motor
	motor_stop: INTEGER = 0
	motor_up: INTEGER = 1
	motor_down: INTEGER = -1
	--Mode
	mode_resting: INTEGER = 0
	mode_ascending: INTEGER = 1
	mode_descending: INTEGER = 2

feature {NONE} --Make

	make(max: INTEGER)
	require
		more_than_one_floor: max >= 1
	do
		motor := motor_stop
		mode := mode_resting
		doors_open := false
		floor := 0
		max_floor := max
		create observers.make
	end

feature {ANY} -- Setters w/ observer update

	stop_motor
	require
		travelling: motor /= motor_stop
	do
		motor := motor_stop
		update
	ensure
		stopped: motor = motor_stop
	end

	motor_start_up
	require
		stopped: motor = motor_stop
		not doors_open
	do
		motor := motor_up
		update
	ensure
		moving_up: motor = motor_up
	end

	motor_start_down
	require
		stopped: motor = motor_stop
		not doors_open
	do
		motor := motor_down
		update
	ensure
		moving_down: motor = motor_down
	end

	open_doors
	require
		stopped: motor = motor_stop
		not doors_open
	do
		doors_open := true
		update
	ensure
		doors_opened: doors_open
	end

	close_doors
	require
		doors_open
	do
		doors_open := false
		update
	ensure
		not doors_open
	end

	travel
	require
		not_stopped: motor /= motor_stop
	do
		floor := floor + motor
		update
	ensure
		in_building: floor >= 0 and floor <= max_floor
		moved: floor = old floor + 1 or floor = old floor - 1
	end

	begin_ascending
	require
		not_ascending: mode /= mode_ascending
	do
		mode := mode_ascending
		update
	ensure
		ascending: mode = mode_ascending
	end

	begin_descending
	require
		not_descending: mode /= mode_descending
	do
		mode := mode_descending
		update
	ensure
		descending: mode = mode_descending
	end

	begin_resting
	require
		not_resting: mode /= mode_resting
	do
		mode := mode_resting
		update
	ensure
		resting: mode = mode_resting
	end

invariant
	in_building: 0 <= floor and floor <= max_floor
	safe_doors: not (doors_open and motor /= 0)

end
