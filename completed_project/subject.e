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

	add_observer(o: OBSERVER)
	require
		initialized: observers /= Void
	do
		observers.extend (o)
	ensure
		added: observers.count = old observers.count + 1
	end

	remove_observer(o: OBSERVER)
	require
		initialized: observers /= Void
		has_observer: observers.count > 0
	do
		from
			observers.start
		until
			observers.off
		loop
			if observers.item = o then
				observers.remove
			end
		end
	ensure
		removed: observers.count = old observers.count - 1
	end

end
