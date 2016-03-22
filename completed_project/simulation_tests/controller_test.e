note
	description: "Summary description for {CONTROLLER_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONTROLLER_TEST
inherit
	ES_TEST
create make

feature -- Feature under test

controller: ELEVATOR_CONTROL
model: ELEVATOR_MODEL
up_buttons: ARRAY[EL_BUTTON]
down_buttons: ARRAY[EL_BUTTON]
dest_buttons: ARRAY[EL_BUTTON]

feature -- Creation

make
  -- Defines the test cases to use
  do
  	create model.make(2)
  	create controller
  	create up_buttons.make_empty
  	create down_buttons.make_empty
  	create dest_buttons.make_empty
    add_boolean_case (agent ready_gui_test)
    add_boolean_case (agent model_ok_test)
    add_boolean_case (agent target_above_test)
    add_boolean_case (agent target_below_test)
    add_boolean_case (agent at_destination_test)
    add_boolean_case (agent up_rider_waiting_test)
    add_boolean_case (agent down_rider_waiting_test)
  end

	ready_gui_test : BOOLEAN
	local t1, t2: BOOLEAN
	do
		create controller
		up_buttons := make_button_array(7)
		down_buttons := make_button_array(6)
		dest_buttons := make_button_array(8)
		controller.attach_up_buttons (up_buttons)
		controller.attach_down_buttons (down_buttons)
		controller.attach_destination_buttons (dest_buttons)
		controller.ready_gui
		t1 := controller.gui_attached
		down_buttons := make_button_array(7)
		controller.attach_down_buttons (down_buttons)
		dest_buttons := make_button_array(7)
		controller.attach_destination_buttons (dest_buttons)
		controller.ready_gui
		t2 := controller.gui_attached
		Result := (not t1) and t2
	end

	model_ok_test : BOOLEAN
	local t1, t2: BOOLEAN
	do
		create model.make(8)
		create controller
		up_buttons := make_button_array(7)
		down_buttons := make_button_array(7)
		dest_buttons := make_button_array(7)
		controller.attach_up_buttons (up_buttons)
		controller.attach_down_buttons (down_buttons)
		controller.attach_destination_buttons (dest_buttons)
		controller.ready_gui
		controller.attach_model (model)
		controller.model_ok
		t1 := controller.model_valid
		create model.make (7)
		controller.attach_model (model)
		controller.model_ok
		t2 := controller.model_valid
		Result := (not t1) and t2
	end

	target_above_test : BOOLEAN
	local t1, t2: BOOLEAN
	do
		create model.make(7)
		create controller
		up_buttons := make_button_array(7)
		down_buttons := make_button_array(7)
		dest_buttons := make_button_array(7)
		controller.attach_up_buttons (up_buttons)
		controller.attach_down_buttons (down_buttons)
		controller.attach_destination_buttons (dest_buttons)
		controller.attach_model (model)
		model.motor_start_up
		model.travel
		model.travel
		model.travel
		model.travel
		model.travel
		dest_buttons[5].activate
		t1 := controller.target_above
		model.stop_motor
		model.motor_start_down
		model.travel
		t2 := controller.target_above
		Result := (not t1) and t2
	end

	target_below_test : BOOLEAN
	local t1, t2: BOOLEAN
	do
		create model.make(7)
		create controller
		up_buttons := make_button_array(7)
		down_buttons := make_button_array(7)
		dest_buttons := make_button_array(7)
		controller.attach_up_buttons (up_buttons)
		controller.attach_down_buttons (down_buttons)
		controller.attach_destination_buttons (dest_buttons)
		controller.attach_model (model)
		model.motor_start_up
		model.travel
		model.travel
		model.travel
		model.travel
		model.travel
		dest_buttons[5].activate
		t1 := controller.target_below
		model.travel
		model.floor.set_item(6)
		t2 := controller.target_below
		Result := (not t1) and t2
	end

	at_destination_test : BOOLEAN
	local t1, t2: BOOLEAN
	do
		create model.make(7)
		create controller
		up_buttons := make_button_array(7)
		down_buttons := make_button_array(7)
		dest_buttons := make_button_array(7)
		controller.attach_up_buttons (up_buttons)
		controller.attach_down_buttons (down_buttons)
		controller.attach_destination_buttons (dest_buttons)
		controller.attach_model (model)
		model.motor_start_up
		model.travel
		model.travel
		model.travel
		model.travel
		model.floor.set_item (4)
		dest_buttons[5].activate
		t1 := controller.at_destination
		model.travel
		t2 := controller.at_destination
		Result := (not t1) and t2
	end

	up_rider_waiting_test : BOOLEAN
	local t1, t2: BOOLEAN
	do
		create model.make(7)
		create controller
		up_buttons := make_button_array(7)
		down_buttons := make_button_array(7)
		dest_buttons := make_button_array(7)
		controller.attach_up_buttons (up_buttons)
		controller.attach_down_buttons (down_buttons)
		controller.attach_destination_buttons (dest_buttons)
		controller.attach_model (model)
		model.motor_start_up
		model.travel
		model.travel
		model.travel
		model.travel
		model.travel
		dest_buttons[5].activate
		t1 := controller.up_rider_waiting
		up_buttons[5].activate
		t2 := controller.up_rider_waiting
		Result := (not t1) and t2
	end

	down_rider_waiting_test : BOOLEAN
	local t1, t2: BOOLEAN
	do
		create model.make(7)
		create controller
		up_buttons := make_button_array(7)
		down_buttons := make_button_array(7)
		dest_buttons := make_button_array(7)
		controller.attach_up_buttons (up_buttons)
		controller.attach_down_buttons (down_buttons)
		controller.attach_destination_buttons (dest_buttons)
		controller.attach_model (model)
		model.motor_start_up
		model.travel
		model.travel
		model.travel
		model.travel
		model.travel
		dest_buttons[5].activate
		t1 := controller.down_rider_waiting
		down_buttons[5].activate
		t2 := controller.down_rider_waiting
		Result := (not t1) and t2
	end

	make_button_array(num: INTEGER) : ARRAY[EL_BUTTON]
	local i: INTEGER; button: EL_BUTTON; arr: ARRAY[EL_BUTTON]
	do
		create arr.make_empty
		from
			i := 0
		until
			i = num
		loop
			create button
			arr.force (button, i)
			i := i + 1
		end
		Result := arr
	end

end
