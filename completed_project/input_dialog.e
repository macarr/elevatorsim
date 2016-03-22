note
	description: "Summary description for {INPUT_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_DIALOG
inherit
	EV_DIALOG
redefine
	create_interface_objects,
	initialize
end

feature {ANY}

	main_container: EV_VERTICAL_BOX
	label: EV_LABEL
	input: EV_TEXT_FIELD
	confirm: EV_BUTTON
	output: STRING

feature {NONE}

	create_interface_objects
	do
		create main_container
		create label
		create input
		create output.make_empty
		create confirm
	end

	initialize
	do
		Precursor
		label.set_text("Please input the desired%Nnumber of floors")
		label.align_text_vertical_center
		main_container.extend(label)
		main_container.extend(input)
		main_container.disable_item_expand (input)
		confirm.set_text("OK")
		confirm.select_actions.extend (agent on_button_press)
		confirm.set_minimum_size (75, 24)
		main_container.extend(confirm)
		main_container.disable_item_expand (confirm)
		--set_default_push_button(confirm)
		main_container.set_border_width(10)
		main_container.set_padding(4)
		main_container.set_minimum_size (200,100)
		set_title("Input")
		extend(main_container)
	end

	on_button_press
	do
		output := input.text
		if not is_destroyed then
			destroy
		end
	end


end
