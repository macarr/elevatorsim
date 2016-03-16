note
	description: "Summary description for {SUBJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SUBJECT

feature

observers: LINKED_LIST[OBSERVER]

attach(obs: OBSERVER)
do
	observers.extend(obs)
end

notify
do
	from
		observers.start
	until
		observers.off
	loop
		observers.item.update
		observers.forth
	end
end

end
