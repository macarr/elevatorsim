note
	description: "Summary description for {CONTROLLER_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONTROLLER_THREAD
inherit
	THREAD
redefine
	default_create
end

feature



	default_create
	do
		create launch_mutex.make
		create model.make
		model_attached := false
		create command_channel.make
		command_chan_attached := false
	end

	execute
	do
		execution_loop
	end

	execution_loop
	require
		model_attached
		command_chan_attached
	do
		from

		until
			false
		loop
			model.add_to_count
			--command_channel.put(1)
			sleep(1000000000)
		end
	end

feature

	model: MODEL
	command_channel: LINKED_QUEUE[INTEGER]
	model_attached, command_chan_attached: BOOLEAN

	attach_model(m: MODEL)
	require
		model_attached = false
	do
		model := m
		model_attached := true
	ensure
		model = m
		model_attached = true
	end

	attach_command_channel(c: LINKED_QUEUE[INTEGER])
	require
		command_chan_attached = false
	do
		command_channel := c
		command_chan_attached := true
	ensure
		command_channel = c
		command_chan_attached = true
	end



end
