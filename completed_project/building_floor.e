note
	description: "Summary description for {BUILDING_FLOOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BUILDING_FLOOR
inherit
	EV_HORIZONTAL_BOX
	redefine
		create_interface_objects,
		initialize,
		is_in_default_state
	end
create
	default_create

feature {ANY} --fields

	floor: INTEGER
	floor_label: EV_LABEL
	up: EL_BUTTON
	down: EL_BUTTON
	elevator: EV_PIXMAP
	elevator_at: EV_PIXMAP
	elevator_nat: EV_PIXMAP
	elevator_open: EV_PIXMAP
	button_box: EV_VERTICAL_BOX
	uparrow: EV_PIXMAP
	downarrow: EV_PIXMAP


feature {NONE}--make
	create_interface_objects
		do
			create floor_label
			create up
			create down
			create elevator
			create elevator_at
			create elevator_nat
			create elevator_open
			create button_box
			create uparrow
			create downarrow
		end
	initialize
		do
			Precursor {EV_HORIZONTAL_BOX}
			floor := 0
			set_border_width(0)
			floor_label.set_text (floor.out)
			floor_label.set_minimum_width (30)
			floor_label.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb(255,215,0))
			floor_label.set_font (create {EV_FONT}.make_with_values ({EV_FONT_CONSTANTS}.family_typewriter,
																  {EV_FONT_CONSTANTS}.weight_bold,
																  {EV_FONT_CONSTANTS}.shape_regular,
																  20))
			uparrow.set_with_named_file("uparrow.png")
			up.set_pixmap (uparrow)
			downarrow.set_with_named_file("downarrow.png")
			down.set_pixmap (downarrow)
			elevator_at.set_with_named_file ("elev_at.png")
			elevator_at.set_minimum_size (60, 75)
			elevator_nat.set_with_named_file ("elev_nat.png")
			elevator_nat.set_minimum_size (60, 75)
			elevator_open.set_with_named_file ("elev_open.png")
			elevator_open.set_minimum_size(60, 75)
			elevator.copy (elevator_nat)
			elevator.set_minimum_size(60, 75)
			button_box.extend(up)
			button_box.extend(down)
			extend(floor_label)
			extend(elevator)
			extend(button_box)
		end
	is_in_default_state: BOOLEAN
		do
			Result := true
		end

feature {ANY} -- public methods

	set_floor(num: INTEGER)
	do
		floor := num
		floor_label.set_text (floor.out)
	ensure
		floor = num
	end

	elevator_left
	do
		elevator.copy(elevator_nat)
		refresh_now
	end

	elevator_entered
	do
		elevator.copy(elevator_at)
		refresh_now
	end

	elevator_opened_doors
	do
		elevator.copy(elevator_open)
		refresh_now
	end



end
