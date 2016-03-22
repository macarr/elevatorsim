note
	description: "Summary description for {EL_BUTTON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_BUTTON
inherit
	EV_BUTTON
redefine
	initialize, create_interface_objects
end

feature {NONE}

	active: BOOLEAN
	active_colour: EV_COLOR
	inactive_colour: EV_COLOR

feature {NONE} -- Creation

	create_interface_objects
	do
		Precursor
		create inactive_colour.make_with_8_bit_rgb(189, 189, 189)
		create active_colour.make_with_8_bit_rgb(0,255,0)
	end
	initialize
	do
		Precursor
		active := false
		set_background_color(inactive_colour)
	end

feature
--here we implement the BUTTON-SERVICE portion of the design doc
--the Button-0 and Button-1 proceses are implemented by EiffelVision's
--button library. An on-click action is added to each button, which
--calls the activate method (read B2). ELEVATOR_CONTROL directly
--deactivates buttons it is servicing, approximating the read/write
--of O

	--read B2
	activate
	do
		active := true
		set_background_color(active_colour)
	end

	--read O
	deactivate
	do
		active := false
		set_background_color(inactive_colour)
	end

	is_active: BOOLEAN
	do
		Result := active
	end

end
