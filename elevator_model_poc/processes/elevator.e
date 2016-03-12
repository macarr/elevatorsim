note
	description: "Summary description for {ELEVATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ELEVATOR
inherit
	EXECUTION_ENVIRONMENT
	THREAD
		rename launch as start,
			   sleep as thread_sleep end

create
	make_start

feature --fields

	current_floor, top_floor: INTEGER
	motor_direction: INTEGER -- -1 is down, 1 is up, 0 is stop
	doors: BOOLEAN -- true is open, false is closed
	mode: INTEGER -- -1 is descend, 1 is ascend, 0 is rest
	destination_buttons: ARRAY[BOOLEAN]
	up_call: ARRAY[BOOLEAN]
	down_call: ARRAY[BOOLEAN]
	tick_length: INTEGER
	busy: BOOLEAN

feature {NONE}

	make_start(tickrate: DOUBLE; floors: INTEGER)
	local temp: DOUBLE
	do
		temp := tickrate * 1000000000 -- 10^9 nanoseconds per second
		tick_length := temp.rounded
		top_floor := floors
		current_floor := 1
		motor_direction := 0
		doors := false
		busy := false
		mode := 0
		create destination_buttons.make_filled(false, 1, floors)
		create up_call.make_filled(false, 1, floors-1)
		create down_call.make_filled(false, 2, floors)
		create launch_mutex.make
	end

feature {ANY}--public functions

execute
do

end

is_busy : BOOLEAN
do
	Result := busy
end

feature {ANY}--public procedures

tick
do
	if resting and current_floor = 0 then
		wait_for_orders
	else
		arrive
		if motor_direction /= 0 then
			travel
		end
	end
end


	arrive
	require
		--travelling: motor_direction /= 0
	local stop: BOOLEAN
	do
		stop := false
		if at_destination then
			stop := true
		else
			if ascending and up_rider_waiting then
				stop := true
			elseif descending and down_rider_waiting then
				stop := true
			end
		end
		if stop then
			motor_stop
			open_doors
			if at_destination then
				turn_off_destination_button(current_floor)
			end
			if ascending and up_rider_waiting then
				turn_off_up_call(current_floor)
			end
			if descending and down_rider_waiting then
				turn_off_down_call(current_floor)
			end
			close_doors
		end
		update_mode
		update_motor
	end

	press_call_up(floor: INTEGER)
	require
		button_exists: floor >= up_call.lower and floor <= up_call.upper
	do
		if not up_call[floor] then
			up_call[floor] := true
			io.put_string ("Up call button activated on floor " + floor.out + "%N")
		end
	ensure
		button_active: up_call[floor]
	end

	press_call_down(floor: INTEGER)
	require
		button_exists: floor >= down_call.lower and floor <= down_call.upper
	do
		if not down_call[floor] then
			down_call[floor] := true
			io.put_string ("Down call button activated on floor " + floor.out + "%N")
		end
	ensure
		button_active: down_call[floor]
	end

	press_destination(floor: INTEGER)
	require
		button_exists: floor >= destination_buttons.lower and floor <= destination_buttons.upper
	do
		if not destination_buttons[floor] then
			destination_buttons[floor] := true
			io.put_string ("Destination button for floor " + floor.out + " pressed%N")
		end
	ensure
		button_active: destination_buttons[floor]
	end


feature {NONE} --private functions

ascending : BOOLEAN
do
	Result := mode = 1
end

descending : BOOLEAN
do
	Result := mode = -1
end

resting : BOOLEAN
do
	Result := mode = 0
end

	target_above : BOOLEAN
	local i: INTEGER
	do
		Result := false
		from
			i := current_floor + 1
		until
			i > top_floor
		loop
			if destination_buttons[i] then
				Result := true
			end
			i := i + 1
		end
	end

	target_below : BOOLEAN
	local i: INTEGER
	do
		Result := false
		from
			i := current_floor - 1
		until
			i = 0
		loop
			if destination_buttons[i] then
				Result := true
			end
			i := i - 1
		end
	end

	up_rider_waiting : BOOLEAN
	do
		if current_floor > up_call.upper then
			Result := false
		else
			Result := up_call[current_floor]
		end
	end

	down_rider_waiting : BOOLEAN
	do
		if current_floor < down_call.lower then
			Result := false
		else
			Result := down_call[current_floor]
		end
	end

	at_destination : BOOLEAN
	do
		Result := destination_buttons[current_floor]
	end

feature {NONE} -- private procedures

turn_off_up_call(floor: INTEGER)
	require
		call_on: up_call[floor]
	do
		up_call[floor] := false
		io.put_string ("Turned off up call button at floor " + floor.out + "%N")
		sleep(tick_length)
	ensure
		call_off: not up_call[floor]
	end

turn_off_down_call(floor: INTEGER)
	require
		call_on: down_call[floor]
	do
		down_call[floor] := false
		io.put_string ("Turned off down call button at floor " + floor.out + "%N")
		sleep(tick_length)
	ensure
		call_off: not down_call[floor]
	end

turn_off_destination_button(floor: INTEGER)
	require
		destination_on: destination_buttons[floor]
	do
		destination_buttons[floor] := false
		io.put_string ("Turned off destination button for floor " + floor.out + "%N")
		sleep(tick_length)
	ensure
		destination_off: not destination_buttons[floor]
	end

travel
	require
		moving: motor_direction /= 0
	local temp: INTEGER
	do
		temp := current_floor
		current_floor := current_floor + motor_direction
		io.put_string ("Moved from floor " + temp.out + " to floor " + current_floor.out + "%N")
		sleep(tick_length)
	ensure
		moved: current_floor = old current_floor + motor_direction
	end

rest
	require
		resting
	do
		if current_floor > 1 then
			if motor_direction /= 0 then
				travel
			end
		else
			io.put_string ("resting!%N")
			sleep(tick_length)
		end
	end

wait_for_orders
require
	resting
	bottom_floor: current_floor = 1
do
	update_mode
	if not resting then
		update_motor
	else
		rest
	end
end

open_doors
	require
		not_moving: motor_direction = 0
		doors_closed: doors = false
	do
		doors := true
		io.put_string("Opened doors%N")
		sleep(tick_length)
	ensure
		doors_open: doors = true
	end

close_doors
	require
		doors_open: doors = true
	do
		doors := false
		io.put_string("Closed doors%N")
		sleep(tick_length)
	ensure
		doors_closed: doors = false
	end

motor_ascend
	require
		correct_mode: mode = 1
		stopped: motor_direction = 0
	do
		motor_direction := 1
		io.put_string("Started travelling upwards%N")
		sleep(tick_length)
	ensure
		going_up: motor_direction = 1
	end

motor_descend
	require
		correct_mode: mode < 1
		stopped: motor_direction = 0
	do
		motor_direction := -1
		io.put_string("Started travelling downwards%N")
		sleep(tick_length)
	ensure
		going_down: motor_direction = -1
	end

motor_stop
	require
		not_stopped: motor_direction /= 0
	do
		motor_direction := 0
		io.put_string ("Stopped travelling%N")
		sleep(tick_length)
	ensure
		not_moving: motor_direction = 0
	end

update_mode
	require
		valid_mode: mode = 1 or mode = 0 or mode = -1
	do
		if resting then
			if up_rider_waiting or target_above then
				mode := 1
				io.put_string ("Mode changed to ASCENDING%N")
				sleep(tick_length)
			elseif down_rider_waiting or target_below then
				mode := -1
				io.put_string ("Mode changed to DESCENDING%N")
				sleep(tick_length)
			end
		elseif ascending then
			if not (up_rider_waiting or target_above) then
				if down_rider_waiting or target_below then
					mode := -1
					io.put_string ("Mode changed to DESCENDING%N")
					sleep(tick_length)
				else
					mode := 0
					io.put_string ("Mode changed to RESTING%N")
					sleep(tick_length)
				end
			end
		elseif descending then
			if not (down_rider_waiting or target_below) then
				if up_rider_waiting or target_above then
					mode := 1
					io.put_string ("Mode changed to ASCENDING%N")
					sleep(tick_length)
				else
					mode := 0
					io.put_string ("Mode changed to DESCENDING%N")
					sleep(tick_length)
				end
			end
		end
		if resting then
			busy := false
		else
			busy := true
		end
	end

update_motor
do
	if not doors then
		if resting then
			if current_floor > 1 then
				if motor_direction = 0 then
					motor_descend
				elseif motor_direction = 1 then
					motor_stop
				end
			else
				if motor_direction /= 0 then
					motor_stop
				end
			end
		elseif ascending then
			if motor_direction = 0 then
				motor_ascend
			elseif motor_direction = -1 then
				motor_stop
			end
		elseif descending then
			if motor_direction = 0 then
				motor_descend
			elseif motor_direction = 1 then
				motor_stop
			end
		end
	end
end

end
