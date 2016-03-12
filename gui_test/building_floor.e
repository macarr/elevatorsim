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
	up: EV_BUTTON
	down: EV_BUTTON
	on_color: EV_COLOR
	off_color: EV_COLOR
	elevator: EV_PIXMAP
	button_box: EV_VERTICAL_BOX


feature {NONE}--make
	create_interface_objects
		do
			create on_color.make_with_8_bit_rgb (0,0,0)
			create off_color.make_with_8_bit_rgb (255,255,255)
			create floor_label
			create up
			create down
			create elevator
			create button_box
		end
	initialize
		do
			Precursor {EV_HORIZONTAL_BOX}
			floor := 0
			set_border_width(5)
			floor_label.set_text (floor.out)
			floor_label.set_minimum_width (150)
			floor_label.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb(99,77,2))
			up.set_text("up")
			down.set_text("down")
			up.set_background_color(off_color)
			down.set_background_color(off_color)
			elevator.set_with_named_file ("elev.png")
			elevator.set_minimum_size (50,30)
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

	activate_up
	require
		up.background_color.is_equal(off_color)
	do
		up.set_background_color(on_color)
	ensure
		up.background_color.is_equal(on_color)
	end

	deactivate_up
	require
		up.background_color.is_equal(on_color)
	do
		up.set_background_color(off_color)
	ensure
		up.background_color.is_equal(off_color)
	end

	activate_down
	require
		down.background_color.is_equal(off_color)
	do
		down.set_background_color(on_color)
	ensure
		down.background_color.is_equal(on_color)
	end

	deactivate_down
	require
		down.background_color.is_equal(on_color)
	do
		down.set_background_color(off_color)
	ensure
		down.background_color.is_equal(off_color)
	end

	activate_elevator
	do
		--TODO
	end

	deactivate_elevator
	do
		--TODO
	end



end
