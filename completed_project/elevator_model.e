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
		travelling: motor /= 0
	do
		motor := 0
		update
	ensure
		stopped: motor = 0
	end

	motor_start_up
	require
		stopped: motor = 0
		not doors_open
	do
		motor := 1
		update
	ensure
		moving_up: motor = 1
	end

	motor_start_down
	require
		stopped: motor = 0
		not doors_open
	do
		motor := 2
		update
	ensure
		moving_down: motor = -1
	end

	open_doors
	require
		stopped: motor = 0
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
		not_stopped: motor > 0
	do
		floor := floor + motor
		update
	ensure
		in_building: floor >= 0 and floor <= max_floor
		moved: floor = floor + 1 or floor = floor - 1
	end

	begin_ascending
	require
		not_ascending: mode /= 1
	do
		mode := 1
		update
	ensure
		ascending: mode = 1
	end

	begin_descending
	require
		not_ascending: mode /= 2
	do
		mode := 2
		update
	ensure
		descending: mode = 2
	end

	begin_resting
	require
		not_resting: mode /= 0
	do
		mode := 0
		update
	ensure
		resting: mode = 0
	end

invariant
	in_building: 0 <= floor and floor <= max_floor
	safe_doors: not (doors_open and motor /= 0)

end
