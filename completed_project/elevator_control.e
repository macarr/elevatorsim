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

feature
	default_create
	do
		create launch_mutex.make
	end

	execute
	do

	end

end
