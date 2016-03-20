note
	description: "Summary description for {ELEVATOR_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ELEVATOR_CONTROL
inherit
	THREAD
redefine
	default_create,
	execute
end

feature --Variables

	elevator: ELEVATOR_MODEL
	dest_buttons: ARRAY[EL_BUTTON]
	up_buttons: ARRAY[EL_BUTTON]
	down_buttons: ARRAY[EL_BUTTON]
	tickrate: INTEGER
		--default tickrate is 1s = 1000000000ns
	default_tickrate: INTEGER = 1000000000
	model_attached: BOOLEAN
	model_valid: BOOLEAN
	gui_attached: BOOLEAN
	dest_attached: BOOLEAN
	up_attached: BOOLEAN
	down_attached: BOOLEAN
	last_tick: INTEGER
	t: TIME

feature -- Make

	default_create
	do
		create launch_mutex.make
		create elevator.make(2)
		tickrate := default_tickrate
		create dest_buttons.make_empty
		create up_buttons.make_empty
		create down_buttons.make_empty
		model_attached := false
		model_valid := false
		dest_attached := false
		up_attached := false
		down_attached := false
		gui_attached := false
		create t.make_now
	end

feature -- Execution

	--frozen, so we defer to another method
	execute
	do
		execution_loop
	end

	--main execution loop
	execution_loop
	require
		gui_attached
		model_attached
	do
		create t.make_now
		last_tick := t.nano_second
		elevator.update -- make sure GUI is up to date
		--start resting set
		from
		until up_rider_waiting or target_above -- we are at the bottom floor, these are all we have to consider
		loop
			rest
		end
		--start ascent once we recieve an order, enter main loop body
		from
		until false
		loop
			--ascending set
			enter_ascend_mode
			--first answer any up calls on our current floor
			--(no destination, as we can only enter from rest
			--or having already answered all down destination calls
			if up_rider_waiting then
				open_elevator_doors
				up_buttons[elevator.floor].deactivate
				dest_buttons[elevator.floor].deactivate
				close_elevator_doors
			end
			motor_ascend
			--no between sets, we've abstracted out between-floor travel
			--floor(m)
			from
			until not target_above
			loop
				travel --arrive + depart
				if up_rider_waiting or at_destination then --process
					motor_stop
					open_elevator_doors
					up_buttons[elevator.floor].deactivate
					dest_buttons[elevator.floor].deactivate
					close_elevator_doors
					if target_above then
						motor_ascend
					end
				end
			end
			--no more targets above us, time to descend
			--descending set
			enter_descend_mode
			--first answer any up calls on our current floor
			--(no destination, as we can only enter from rest
			--or having already answered all up destination calls
			if down_rider_waiting then
				open_elevator_doors
				down_buttons[elevator.floor].deactivate
				dest_buttons[elevator.floor].deactivate
				close_elevator_doors
			end
			motor_descend
			from
			until not target_below
			loop
				--floor
				travel --arrive + depart
				if down_rider_waiting or at_destination then --process
					motor_stop
					open_elevator_doors
					down_buttons[elevator.floor].deactivate
					dest_buttons[elevator.floor].deactivate
					close_elevator_doors
					if target_below then
						motor_descend
					end
				end
			end
			--we have now serviced the last floor on the downward cycle
			--if there are no people wanting to go up on this floor or
			--new targets above us, we start resting (travel to bottom
			--floor and wait for orders)
			if not (target_above or up_rider_waiting) then
				enter_rest_mode
				if not is_descending then -- this is less than optimal
					motor_descend
				end
			end
			--descend until we hit bottom floor or get another order
			from
			until target_above or target_below or up_rider_waiting or down_rider_waiting or at_destination or elevator.floor = 0
			loop
				travel
			end
			--we've either hit the bottom floor or recieved another order.
			--In either case, we stop the motor to properly process our
			--next instruction
			motor_stop
			--if we hit the bottom floor, wait for orders
			if elevator.floor = 0 then
				from
				until up_rider_waiting or target_above
				loop
					rest
				end
			end
			--if we didn't hit the bottom floor, we are stopped and ready to process our next order
		end
	end

feature -- configure thread

	--connect destination buttons data channel
	attach_destination_buttons(buttons: ARRAY[EL_BUTTON])
	require
		not_void: buttons /= Void
		more_than_one_floor: buttons.count > 1
	do
		dest_buttons := buttons
		dest_attached := true
	ensure
		hooked_up: dest_buttons = buttons
		dest_attached
	end

	--connect up call buttons data channel
	attach_up_buttons(buttons: ARRAY[EL_BUTTON])
	require
		not_void: buttons /= Void
		more_than_one_floor: buttons.count > 1
	do
		up_buttons := buttons
		up_attached := true
	ensure
		hooked_up: up_buttons = buttons
		up_attached
	end

	--connect down call buttons data channel
	attach_down_buttons(buttons: ARRAY[EL_BUTTON])
	require
		not_void: buttons /= Void
		more_than_one_floor: buttons.count > 1
	do
		down_buttons := buttons
		down_attached := true
	ensure
		hooked_up: down_buttons = buttons
		down_attached
	end

	--confirm gui is correctly attached
		--ensure that we have completed all button attachments
		--ensure that our button attachments are consistent
	ready_gui
	do
		if down_attached and up_attached and dest_attached then
			if down_buttons.count = up_buttons.count and up_buttons.count = dest_buttons.count then
				gui_attached := true
			end
		end
	end

	--attach elevator object
	attach_model(model: ELEVATOR_MODEL)
	require
		not_void: model /= Void
	do
		elevator := model
		model_attached := true
	ensure
		hooked_up: elevator = model
		model_attached
	end

	model_ok
	do
		if gui_attached and model_attached then
			if elevator.max_floor = dest_buttons.count then
				model_valid := true
			end
		end
	end

feature -- elevator logic

	rest
	require
		is_resting
		bottom_floor: elevator.floor = 0
	do
		wait_for_next_tick
	end

	--update mode based on logic specified in requirements doc (see Table 8)
	update_mode
	require
		valid_mode: -1 <= elevator.mode and elevator.mode <= 1
	do
		if is_resting then
			if up_rider_waiting or target_above then
				enter_ascend_mode
			elseif down_rider_waiting or target_below then
				enter_descend_mode
			end
		elseif is_ascending then
			if not (up_rider_waiting or target_above) then
				if down_rider_waiting or target_below then
					enter_descend_mode
				else
					enter_rest_mode
				end
			end
		elseif is_descending then
			if not (down_rider_waiting or target_below) then
				if up_rider_waiting or target_above then
					enter_ascend_mode
				else
					enter_rest_mode
				end
			end
		end
	ensure
		valid_mode: -1 <= elevator.mode and elevator.mode <= 1
	end

	--update motor based on logic specified in requirements doc (see Table 3)
	update_motor
	do
		if not elevator.doors_open then
			if is_resting then
				if elevator.floor > 1 then
					if motor_stopped then
						motor_descend
					elseif motor_up then
						motor_stop
					end
				else
					if not motor_stopped then
						motor_stop
					end
				end
			elseif is_ascending then
				if motor_stopped then
					motor_ascend
				elseif motor_down then
					motor_stop
				end
			elseif is_descending then
				if motor_stopped then
					motor_descend
				elseif motor_up then
					motor_stop
				end
			end
		end
	end

feature -- elevator model queries

	is_ascending: BOOLEAN
	do
		Result := elevator.mode = elevator.mode_ascending
	end

	is_descending: BOOLEAN
	do
		Result := elevator.mode = elevator.mode_descending
	end

	is_resting: BOOLEAN
	do
		Result := elevator.mode = elevator.mode_resting
	end

	motor_up: BOOLEAN
	do
		Result := elevator.motor = elevator.motor_up
	end

	motor_down: BOOLEAN
	do
		Result := elevator.motor = elevator.motor_down
	end

	motor_stopped: BOOLEAN
	do
		Result := elevator.motor = elevator.motor_stop
	end

	--is there an active call button above us?
	target_above: BOOLEAN
	local i: INTEGER
	do
		Result := false
		from
			i := elevator.floor + 1
		until
			i = elevator.max_floor
		loop
			if dest_buttons[i].is_active or down_buttons[i].is_active or up_buttons[i].is_active then
				Result := true
			end
			i := i + 1
		end
	end

	--is there an active call button below us?
	target_below: BOOLEAN
	local i: INTEGER
	do
		Result := false
		from
			i := elevator.floor - 1
		until
			i < 0
		loop
			if dest_buttons[i].is_active or down_buttons[i].is_active or up_buttons[i].is_active then
				Result := true
			end
			i := i - 1
		end
	end

	-- is there someone waiting to go up at the current floor?
	up_rider_waiting : BOOLEAN
	do
		if elevator.floor > up_buttons.upper then
			Result := false
		else
			Result := up_buttons[elevator.floor].is_active
		end
	end

	-- is there someone waiting to go down at the current floor?
	down_rider_waiting: BOOLEAN
	do
		if elevator.floor < down_buttons.lower then
			Result := false
		else
			Result := down_buttons[elevator.floor].is_active
		end
	end

	-- does someone on the elevator want to get off at this floor?
	at_destination: BOOLEAN
	do
		Result := dest_buttons[elevator.floor].is_active
	end

feature --model updates with ticks

	travel
	do
		elevator.travel
		wait_for_next_tick
	end

	enter_ascend_mode
	do
		elevator.begin_ascending
		wait_for_next_tick
	end

	enter_descend_mode
	do
		elevator.begin_descending
		wait_for_next_tick
	end

	enter_rest_mode
	do
		elevator.begin_resting
		wait_for_next_tick
	end

	close_elevator_doors
	do
		elevator.close_doors
		wait_for_next_tick
	end

	open_elevator_doors
	do
		elevator.open_doors
		wait_for_next_tick
	end

	turn_off_up_call(btn: INTEGER)
	require
		valid_button: up_buttons.lower <= btn and btn <= up_buttons.upper
	do
		up_buttons[btn].deactivate
		wait_for_next_tick
	end

	turn_off_down_call(btn: INTEGER)
	require
		valid_button: down_buttons.lower <= btn and btn <= down_buttons.upper
	do
		down_buttons[btn].deactivate
		wait_for_next_tick
	end

	turn_off_dest_button(btn: INTEGER)
	require
		valid_button: dest_buttons.lower <= btn and btn <= dest_buttons.upper
	do
		dest_buttons[btn].deactivate
		wait_for_next_tick
	end

	motor_stop
	do
		elevator.stop_motor
		wait_for_next_tick
	end

	motor_ascend
	do
		elevator.motor_start_up
		wait_for_next_tick
	end

	motor_descend
	do
		elevator.motor_start_down
		wait_for_next_tick
	end

feature --tick

	wait_for_next_tick
	local diff: INTEGER
	do
		create t.make_now
		diff := t.nano_second - last_tick
		sleep(tickrate - diff)
	end

end
