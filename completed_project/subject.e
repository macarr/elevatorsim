note
	description: "Summary description for {SUBJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SUBJECT

feature --Observers

	observers: LINKED_LIST[OBSERVER]

feature --Update

	update
	do
		from
			observers.start
		until
			observers.off
		loop
			observers.item.notify
			observers.forth
		end
	end

end
