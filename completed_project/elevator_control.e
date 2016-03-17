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
	dest_buttons: ARRAY[EV_BUTTON]
	up_buttons: ARRAY[EV_BUTTON]
	down_buttons: ARRAY[EV_BUTTON]
	tickrate: INTEGER
		--default tickrate is 1s = 1000000000ns
	default_tickrate: INTEGER = 1000000000
	model_attached: BOOLEAN
	gui_attached: BOOLEAN
	dest_attached: BOOLEAN
	up_attached: BOOLEAN
	down_attached: BOOLEAN

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
		dest_attached := false
		up_attached := false
		down_attached := false
		gui_attached := false
	end

feature -- Execution

	execute
	do
		execution_loop
	end

	execution_loop
	require
		gui_attached
		model_attached
	do
		from
		until false
		loop
			--execute main elevator loop
			sleep(tickrate)
		end
	end

feature -- configure thread

	--connect destination buttons data channel
	attach_destination_buttons(buttons: ARRAY[EV_BUTTON])
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
	attach_up_buttons(buttons: ARRAY[EV_BUTTON])
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
	attach_down_buttons(buttons: ARRAY[EV_BUTTON])
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

feature -- elevator logic

feature -- elevator queries



end
