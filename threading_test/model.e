note
	description: "Summary description for {MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MODEL
inherit
	SUBJECT

create make

feature

count: INTEGER

make
do
	count := 0
	create observers.make
end

feature

add_to_count
do
	count := count + 1
	notify
end

end
